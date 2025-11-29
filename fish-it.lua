Tab1:createSection({Name = "⚙️ Kontrol Kecepatan", Column = 1})

-- Status Global Skrip
_G.AutoFishEnabled = false
_G.DelayBetweenCasts = 0.2   -- Default: Jeda antar siklus
_G.DelayAfterCharge = 0.8   -- Default: Jeda setelah melempar pancing
_G.DelayDuringMinigame = 1 -- Default: Jeda setelah Request Minigame sebelum FishingCompleted

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- Remote Events/Functions
local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigameStarted = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")

local minigame_args = {
    -1.233184814453125,
    0.5,
    1764409220.329373
}

local function AutoFish()
    -- 1. Mengisi daya Pancing
    local chargeSuccess = pcall(function()
        ChargeFishingRod:InvokeServer()
    end)
    if not chargeSuccess then
        Yv:Notify("Gagal: ChargeFishingRod")
    return end
    
    -- Jeda setelah melempar (Kontrol 2)
    wait(_G.DelayAfterCharge)

    -- 2. Meminta dimulainya Minigame
    local minigameSuccess = pcall(function()
        RequestFishingMinigameStarted:InvokeServer(unpack(minigame_args))
    end)
    if not minigameSuccess then
        Yv:Notify("Gagal: RequestFishingMinigameStarted")
    return end
    
    -- Jeda selama Minigame
    wait(_G.DelayDuringMinigame) 

    -- 3. Menyelesaikan Memancing
    local completeSuccess = pcall(function()
        FishingCompleted:FireServer()
    end)
    if not completeSuccess then
        Yv:Notify("Gagal: FishingCompleted")
    return end
end

Tab1:createToggle({
    Name = "🎣 Blantant",
    CurrentValue = _G.AutoFishEnabled,
    Flag = "AutoFish",
    Column = 1,
    Callback = function(state)
        _G.AutoFishEnabled = state
        Yv:Notify("Auto Memancing:", state and "AKTIF" or "NONAKTIF")
    end
})

Tab1:createLabel({
    Text = "Pengaturan Jeda Memancing.\n- Contoh:\n- Kontrol kecepatan siklus keseluruhan(0.2).\n- Kontrol waktu tunggu setelah lemparan pancing(0.8).\n- Kontrol waktu simulasi minigame(1.0).",
    TextSize = 14,
    Background = true,
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    Column = 1
})

-- Jeda Antar Siklus (Delay Between Casts)**
Tab1:createTextbox({
    Name = "Kecepatan Siklus",
    Placeholder = "Antar Siklus(0.2)",
    CurrentValue = tostring(_G.DelayBetweenCasts),
    Column = 1,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then 
            _G.DelayBetweenCasts = num
            Yv:Notify("Jeda Siklus diatur ke:", num .. "s")
        end
    end
})

-- Jeda Setelah Lempar (Delay After Charge)**
Tab1:createTextbox({
    Name = "Jeda Lempar",
    Placeholder = "Setelah Charge(0.8)",
    CurrentValue = tostring(_G.DelayAfterCharge),
    Column = 1,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            _G.DelayAfterCharge = num
            Yv:Notify("Jeda Setelah Lempar diatur ke:", num .. "s")
        end
    end
})

-- Jeda Saat Minigame (Delay During Minigame)**
Tab1:createTextbox({
    Name = "Jeda Minigame",
    Placeholder = "Setelah Minigame (1.0)",
    CurrentValue = tostring(_G.DelayDuringMinigame),
    Column = 1,
    Callback = function(value)
        local num = tonumber(value)
        -- Jeda minigame biasanya memerlukan waktu yang cukup
        if num and num >= 0 then
            _G.DelayDuringMinigame = num
            Yv:Notify("Jeda Minigame diatur ke:", num .. "s")
        end
    end
})

local AutoFishThread = coroutine.wrap(function()
    while task.wait() do
        if _G.AutoFishEnabled then
            AutoFish()
            -- Jeda antar siklus (Kontrol 1)
            task.wait(_G.DelayBetweenCasts)
        end
    end
end)

AutoFishThread()
