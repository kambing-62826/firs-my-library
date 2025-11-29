-- File: FISH-IT.lua

-- Mengembalikan fungsi yang menerima satu argumen (TabObject)
return function(TabObject)
    -- Variabel Tab1 sekarang dialiaskan ke argumen yang diberikan (TabObject)
    -- Ini memastikan skrip dapat membuat elemen GUI di Tab yang sudah dibuat di skrip utama.
    local Tab1 = TabObject 
    
    -- Yv sudah tersedia melalui _G, tetapi jika Anda ingin menggunakannya, 
    -- Anda bisa mengaksesnya jika sudah didefinisikan secara global.

    -- ======================================================================
    -- 1. PENGATURAN GLOBAL DAN INISIALISASI GAME
    -- ======================================================================
    
    -- Status Global Skrip (Pastikan variabel ini sama dengan yang digunakan di skrip utama)
    _G.AutoFishEnabled = _G.AutoFishEnabled or false
    _G.DelayBetweenCasts = _G.DelayBetweenCasts or 0.2
    _G.DelayAfterCharge = _G.DelayAfterCharge or 0.8
    _G.DelayDuringMinigame = _G.DelayDuringMinigame or 1.0

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local NetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

    -- Remote Events/Functions
    local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
    local RequestFishingMinigameStarted = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
    local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")

    -- Ambil Yv untuk notifikasi (asumsi tersedia secara global atau di cache)
    local Yv = _G.Yv or nil -- Mendapatkan Yv dari global jika diperlukan

    local minigame_args = {
        -1.233184814453125,
        0.5,
        1764409220.329373
    }

    -- ======================================================================
    -- 2. FUNGSI INTI AUTO-MEMANCING
    -- ======================================================================

    local function AutoFish()
        -- 1. Mengisi daya Pancing
        local chargeSuccess = pcall(function()
            ChargeFishingRod:InvokeServer()
        end)
        if not chargeSuccess then
            if Yv then Yv:notify("Gagal: ChargeFishingRod") end
        return end
        
        wait(_G.DelayAfterCharge)

        -- 2. Meminta dimulainya Minigame
        local minigameSuccess = pcall(function()
            RequestFishingMinigameStarted:InvokeServer(unpack(minigame_args))
        end)
        if not minigameSuccess then
            if Yv then Yv:notify("Gagal: RequestFishingMinigameStarted") end
        return end
        
        wait(_G.DelayDuringMinigame) 

        -- 3. Menyelesaikan Memancing
        local completeSuccess = pcall(function()
            FishingCompleted:FireServer()
        end)
        if not completeSuccess then
            if Yv then Yv:notify("Gagal: FishingCompleted") end
        return end
    end

    -- ======================================================================
    -- 3. KONTROL GUI MENGGUNAKAN TAB1
    -- ======================================================================
    
    -- Buat Section
    Tab1:createSection({Name = "⚙️ Kontrol Kecepatan", Column = 1})

    -- Label Informasi
    Tab1:createLabel({
        Text = "Pengaturan Jeda Memancing:\n- Kecepatan siklus.\n- Waktu tunggu setelah lempar.\n- Waktu simulasi minigame.",
        TextSize = 14,
        Background = true,
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        Column = 1
    })

    -- Toggle On/Off
    Tab1:createToggle({
        Name = "🎣 Auto Memancing (Blatant)",
        CurrentValue = _G.AutoFishEnabled,
        Flag = "AutoFish",
        Column = 1,
        Callback = function(state)
            _G.AutoFishEnabled = state
            if Yv then Yv:notify("Auto Memancing:", state and "AKTIF" or "NONAKTIF") end
        end
    })

    -- Jeda Antar Siklus (Delay Between Casts)
    Tab1:createTextbox({
        Name = "Kecepatan Siklus",
        Placeholder = "Antar Siklus (detik)",
        CurrentValue = tostring(_G.DelayBetweenCasts),
        Column = 1,
        Callback = function(value)
            local num = tonumber(value)
            if num and num >= 0 then 
                _G.DelayBetweenCasts = num
                if Yv then Yv:notify("Jeda Siklus diatur ke:", num .. "s") end
            end
        end
    })

    -- Jeda Setelah Lempar (Delay After Charge)
    Tab1:createTextbox({
        Name = "Jeda Lempar",
        Placeholder = "Setelah Charge (detik)",
        CurrentValue = tostring(_G.DelayAfterCharge),
        Column = 1,
        Callback = function(value)
            local num = tonumber(value)
            if num and num >= 0 then
                _G.DelayAfterCharge = num
                if Yv then Yv:notify("Jeda Setelah Lempar diatur ke:", num .. "s") end
            end
        end
    })

    -- Jeda Saat Minigame (Delay During Minigame)
    Tab1:createTextbox({
        Name = "Jeda Minigame",
        Placeholder = "Simulasi Minigame (detik)",
        CurrentValue = tostring(_G.DelayDuringMinigame),
        Column = 1,
        Callback = function(value)
            local num = tonumber(value)
            if num and num >= 0 then
                _G.DelayDuringMinigame = num
                if Yv then Yv:notify("Jeda Saat Minigame diatur ke:", num .. "s") end
            end
        end
    })


    -- ======================================================================
    -- 4. LOOP UTAMA
    -- ======================================================================
    
    local AutoFishThread = coroutine.wrap(function()
        while task.wait() do
            if _G.AutoFishEnabled then
                AutoFish()
                task.wait(_G.DelayBetweenCasts)
            end
        end
    end)

    AutoFishThread()
    
end
