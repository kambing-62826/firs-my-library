-- FULL MODULAR YUVIHUB (paste ke LocalScript di StarterGui)

-- === SERVICE DASAR ===
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- rename gui utama jika belum dinamai
task.defer(function()
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScreenGui" then
            gui.Name = "yuvi" -- kasih nama unik biar aman
        end
    end
end)

-- 🔔 NOTIF (tersedia, gunakan UI:Notify)
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- DRAG FUNCTION
local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragInput, startPos, framePos

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            framePos = frame.Position
            UserInputService.InputChanged:Connect(function(inputChanged)
                if dragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    local delta = inputChanged.Position - startPos
                    frame.Position = UDim2.new(
                        framePos.X.Scale, framePos.X.Offset + delta.X,
                        framePos.Y.Scale, framePos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end

    local function onInputEnded(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragging = false
        end
    end

    dragHandle.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
end

-- === BUILD UI & MODULES ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuviHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200) -- Posisikan di tengah layar
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- border stroke
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Parent = MainFrame

-- round corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = MainFrame

-- HEADER / TAB HOLDER
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0, 35)
TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabHolder.Parent = MainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = TabHolder

-- Left (Title + Tabs)
local LeftContainer = Instance.new("Frame")
LeftContainer.Size = UDim2.new(1, -100, 1, 0)
LeftContainer.BackgroundTransparency = 1
LeftContainer.Parent = TabHolder

local LeftLayout = Instance.new("UIListLayout", LeftContainer)
LeftLayout.FillDirection = Enum.FillDirection.Horizontal
LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
LeftLayout.Padding = UDim.new(0, 5)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 120, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yuvi Hub"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = LeftContainer

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = TitleLabel

local textGradient = Instance.new("UIGradient")
textGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90,0,0))
}
textGradient.Rotation = 90
textGradient.Parent = TitleLabel

-- Header logo
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 40, 0, 30)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "rbxassetid://81450116624685"
HeaderLogo.Parent = LeftContainer

local spacing = Instance.new("UIPadding")
spacing.PaddingRight = UDim.new(0, 5)
spacing.Parent = HeaderLogo

-- Right (Close + Minimize)
local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0, 80, 1, 0)
RightContainer.AnchorPoint = Vector2.new(1, 0)
RightContainer.Position = UDim2.new(1, 0, 0, 0)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = TabHolder

local RightLayout = Instance.new("UIListLayout", RightContainer)
RightLayout.FillDirection = Enum.FillDirection.Horizontal
RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
RightLayout.Padding = UDim.new(0, 2)

-- Minimize button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
MinimizeBtn.Parent = RightContainer
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 13)

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.Parent = RightContainer
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 13)

-- Drag only header
makeDraggable(MainFrame, TabHolder)

-- CONTENT FRAME (Ini akan menampung TabFrame yang aktif)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -70)
ContentFrame.Position = UDim2.new(0, 0, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- POPUP BUTTON (initial hidden)
local PopupBtn = Instance.new("TextButton")
PopupBtn.Size = UDim2.new(0, 100, 0, 30)
PopupBtn.Position = UDim2.new(0, 20, 1, -50)
PopupBtn.Text = "Yuvi Hub"
PopupBtn.Font = Enum.Font.GothamBold
PopupBtn.TextSize = 14
PopupBtn.TextColor3 = Color3.fromRGB(255,255,255)
PopupBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
PopupBtn.Visible = false
PopupBtn.Parent = ScreenGui
Instance.new("UICorner", PopupBtn).CornerRadius = UDim.new(0, 6)
makeDraggable(PopupBtn)

-- MINIMIZE / CLOSE HANDLERS
local minimized = false
local function toggleGUI()
    minimized = not minimized
    MainFrame.Visible = not minimized
    PopupBtn.Visible = minimized
end
MinimizeBtn.MouseButton1Click:Connect(toggleGUI)
PopupBtn.MouseButton1Click:Connect(toggleGUI)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- TAB BUTTON HOLDER
local TabButtonHolder = Instance.new("Frame")
TabButtonHolder.Size = UDim2.new(1, -10, 0, 35)
TabButtonHolder.Position = UDim2.new(0, 5, 0, 35)
TabButtonHolder.BackgroundTransparency = 1
TabButtonHolder.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout", TabButtonHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 5)

-- UI MODULE OBJECT
local UI = {}
UI._tabs = {}             -- store tab frames by name (TabAPI object)
UI._tabFrames = {}        -- store actual TabFrame instances by name
UI._keybinds = {}         -- store keybind mapping (name -> KeyCode)
UI._keybindCallbacks = {} -- optional callbacks to run when keybind triggers
UI._editing = nil         -- currently editing keybind {tab, container, label, name}
UI._activeTab = nil       -- Menyimpan nama tab yang sedang aktif

-- Fungsi buat createTab yg punya 2 kolom konten
function UI:createTab(name)
    -- Pastikan tab dengan nama ini belum ada
    if UI._tabs[name] then
        warn("Tab with name '" .. name .. "' already exists.")
        return UI._tabs[name]
    end

    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton_" .. name
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Text = name
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    TabButton.Parent = TabButtonHolder

    local cornerBtn = Instance.new("UICorner", TabButton)
    cornerBtn.CornerRadius = UDim.new(0,13)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,60,60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
    }
    gradient.Rotation = 90
    gradient.Parent = TabButton

    local strokeBtn = Instance.new("UIStroke")
    strokeBtn.Thickness = 1.5
    strokeBtn.Color = Color3.fromRGB(20,20,20)
    strokeBtn.Transparency = 0.3
    strokeBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    strokeBtn.Parent = TabButton

    local scale = TabButton:FindFirstChild("ClickScale") or Instance.new("UIScale", TabButton)
    scale.Name = "ClickScale"
    scale.Scale = 1

    -- === TAB FRAME ===
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = "TabFrame_" .. name
    TabFrame.Size = UDim2.new(1, -10, 1, -10)
    TabFrame.Position = UDim2.new(0, 5, 0, 5)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Parent = ContentFrame -- Parent ke ContentFrame
    TabFrame.Visible = false -- Sembunyikan secara default

    -- Container kiri dan kanan (scrolling frame)
    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.5, -7, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LeftColumn.ScrollBarThickness = 6
    LeftColumn.ScrollingDirection = Enum.ScrollingDirection.Y
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = TabFrame

    local LeftLayout = Instance.new("UIListLayout", LeftColumn)
    LeftLayout.FillDirection = Enum.FillDirection.Vertical
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Padding = UDim.new(0, 6)

    local LeftPadding = Instance.new("UIPadding", LeftColumn)
    LeftPadding.PaddingLeft = UDim.new(0, 5)
    LeftPadding.PaddingRight = UDim.new(0, 5)
    LeftPadding.PaddingTop = UDim.new(0, 5)
    LeftPadding.PaddingBottom = UDim.new(0, 5)

    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.5, -7, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 7, 0, 0)
    RightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
    RightColumn.ScrollBarThickness = 6
    RightColumn.ScrollingDirection = Enum.ScrollingDirection.Y
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = TabFrame

    local RightLayout = Instance.new("UIListLayout", RightColumn)
    RightLayout.FillDirection = Enum.FillDirection.Vertical
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 6)

    local RightPadding = Instance.new("UIPadding", RightColumn)
    RightPadding.PaddingLeft = UDim.new(0, 5)
    RightPadding.PaddingRight = UDim.new(0, 5)
    RightPadding.PaddingTop = UDim.new(0, 5)
    RightPadding.PaddingBottom = UDim.new(0, 5)

    -- Klik tab → tampilkan frame dan animasi tombol
    TabButton.MouseButton1Click:Connect(function()
        -- Sembunyikan semua TabFrame yang ada
        for _, frame in pairs(UI._tabFrames) do
            frame.Visible = false
        end
        -- Tampilkan TabFrame yang diklik
        TabFrame.Visible = true
        UI._activeTab = name -- Set tab aktif

        local shrink = TweenService:Create(scale, TweenInfo.new(0.08), {Scale = 0.92})
        local restore = TweenService:Create(scale, TweenInfo.new(0.08), {Scale = 1})
        shrink:Play()
        shrink.Completed:Connect(function() restore:Play() end)
    end)

    local TabAPI = {}
    TabAPI._frame = TabFrame
    TabAPI._name = name

    -- Memudahkan mendapatkan parent container: kolom utama
    local function getParent(self, column)
        column = column or 1
        return (column == 1 and LeftColumn or RightColumn)
    end

    -- createSection(title, column)
    function TabAPI:createSection(title, column)
        local parent = getParent(self, column)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 30) -- Tinggi section, bisa disesuaikan
        container.BackgroundTransparency = 1 -- Transparan agar tidak terlalu tebal
        container.Parent = parent

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 1, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Text = title
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = container

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 5)
        padding.Parent = titleLabel

        -- Stroke merah tipis di atas section
        local topStroke = Instance.new("Frame")
        topStroke.Size = UDim2.new(1, 0, 0, 1)
        topStroke.Position = UDim2.new(0, 0, 0, 0)
        topStroke.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        topStroke.BorderSizePixel = 0
        topStroke.Parent = container

        return container
    end

    -- createToggle(label, default, callback, column)
    function TabAPI:createToggle(labelText, defaultState, callback, column)
        local parent = getParent(self, column)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 40) -- Sesuaikan ukuran agar pas di layout
        container.BackgroundTransparency = 1
        container.Parent = parent
        local hLayout = Instance.new("UIListLayout", container)
        hLayout.FillDirection = Enum.FillDirection.Horizontal
        hLayout.Padding = UDim.new(0, 8)
        hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        hLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 1, 0) -- Sesuaikan lebar label
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Text = labelText
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(0, 40, 0, 20)
        holder.BackgroundColor3 = Color3.fromRGB(60,60,60)
        holder.BorderSizePixel = 0
        holder.Parent = container
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)

        local g = Instance.new("UIGradient", holder)
        g.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,60,60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
        }
        g.Rotation = 90

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 1, 0, 1)
        knob.BackgroundColor3 = Color3.fromRGB(0,0,0)
        knob.BorderSizePixel = 0
        knob.Parent = holder
        Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 9)

        local glow = Instance.new("UIStroke")
        glow.Thickness = 2
        glow.Color = Color3.fromRGB(255,50,50)
        glow.Transparency = 1
        glow.Parent = knob

        local state = defaultState or false
        local function updateVisual()
            if state then
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -19, 0, 1), BackgroundColor3 = Color3.fromRGB(180,0,0)}):Play()
                glow.Transparency = 0
            else
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 1, 0, 1), BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
                glow.Transparency = 1
            end
        end
        updateVisual()

        holder.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                updateVisual()
                if callback then
                    local ok,err = pcall(function() callback(state) end)
                    if not ok then warn("Toggle callback error:", err) end
                end
            end
        end)

        return {
            Frame = container,
            Get = function() return state end,
            Set = function(v) state = v; updateVisual() end
        }
    end

    -- createButton(text, callback, column)
    function TabAPI:createButton(text, callback, column)
        local parent = getParent(self, column)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 120, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.BorderSizePixel = 0
        button.Text = text
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255,255,255)
        button.AutoButtonColor = false
        button.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,60,60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
        }
        gradient.Rotation = 90
        gradient.Parent = button

        local scale = Instance.new("UIScale")
        scale.Scale = 1
        scale.Parent = button

        local function animateButton(targetScale, targetGradientColor)
            TweenService:Create(
                scale,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Scale = targetScale}
            ):Play()
            TweenService:Create(
                gradient,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Color = targetGradientColor}
            ):Play()
        end

        button.MouseEnter:Connect(function()
            animateButton(1.05, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100,100,100)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80,80,80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))
            })
        end)

        button.MouseLeave:Connect(function()
            animateButton(1, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,60,60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
            })
        end)

        button.MouseButton1Click:Connect(function()
            local shrink = TweenService:Create(
                scale,
                TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Scale = 0.92}
            )
            local restore = TweenService:Create(
                scale,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Scale = 1.05}
            )
            shrink:Play()
            shrink.Completed:Connect(function()
                restore:Play()
            end)

            if callback then
                task.spawn(callback)
            end
        end)
        return button
    end

    -- createSlider(label, min, max, default, callback, column)
    function TabAPI:createSlider(labelText, min, max, default, callback, column)
        local parent = getParent(self, column)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.90 , 0, 0, 60) -- Sesuaikan ukuran agar pas di layout
        container.BackgroundTransparency = 1
        container.Parent = parent

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 20)
        header.BackgroundTransparency = 1
        header.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = labelText
        label.Parent = header

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 14
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Text = tostring(default or min)
        valueLabel.Parent = header

        local track = Instance.new("Frame")
        track.Size = UDim2.new(0.85, 0, 0, 8)
        track.Position = UDim2.new(0.075, 0, 0, 30)
        track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        track.BorderSizePixel = 0
        track.Parent = container
        Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        fill.BorderSizePixel = 0
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(0, -7, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        knob.BorderSizePixel = 0
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local value = default or min
        local dragging = false

        local function updateVisual()
            local percent = (value - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -7, 0.5, -7)
            valueLabel.Text = tostring(math.floor(value))
        end
        updateVisual()

        local function onInputChanged(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relative = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                value = math.clamp(min + relative * (max - min), min, max)
                updateVisual()
                if callback then
                    pcall(callback, value)
                end
            end
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                onInputChanged(input) -- Update immediately on click
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(onInputChanged)

        return {
            Frame = container,
            Get = function() return value end,
            Set = function(v)
                value = math.clamp(v, min, max)
                updateVisual()
                if callback then
                    pcall(callback, value)
                end
            end
        }
    end

 -- createDropdown(labelText, options, default, callback, column)
function TabAPI:createDropdown(labelText, options, default, callback, column)
    local parent = getParent(self, column)
    local container = Instance.new("Frame")
    -- Awalnya, tinggi container hanya untuk label dan tombol dropdown
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent

    -- Tambahkan UIListLayout ke container agar label dan dropdownBtn bisa diatur
    local hLayout = Instance.new("UIListLayout", container)
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    hLayout.Padding = UDim.new(0, 8) -- Sesuaikan padding jika perlu

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 1, 0)
    -- label.Position = UDim2.new(0, 0, 0, 0) -- Tidak perlu posisi absolut jika ada UIListLayout
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(240,240,240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText
    label.Parent = container

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0, 120, 1, 0)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownBtn.Text = default or "Select"
dropdownBtn.Font = Enum.Font.GothamBold
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.fromRGB(240,240,240)
dropdownBtn.AutoButtonColor = false
dropdownBtn.Parent = container

    local corner = Instance.new("UICorner", dropdownBtn)
    corner.CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", dropdownBtn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(120,0,0)
    stroke.Transparency = 0.2

    local glow = Instance.new("UIStroke", dropdownBtn)
    glow.Thickness = 4
    glow.Color = Color3.fromRGB(180,0,0)
    glow.Transparency = 0.8

    -- Frame untuk menampung list opsi dropdown
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 200, 0, 0) -- Awalnya tinggi 0
    listFrame.Position = UDim2.new(0.5, -100, 0, 35) -- Posisikan di bawah dropdownBtn, relatif terhadap container
    listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Visible = false
    listFrame.Parent = container -- Parent ke container
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

    local listStroke = Instance.new("UIStroke", listFrame)
    listStroke.Thickness = 2
    listStroke.Color = Color3.fromRGB(120, 0, 0)

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -10, 0, 25)
    searchBox.Position = UDim2.new(0, 5, 0, 5)
    searchBox.PlaceholderText = "Search..."
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 14
    searchBox.TextColor3 = Color3.fromRGB(240,240,240)
    searchBox.PlaceholderColor3 = Color3.fromRGB(160,160,160)
    searchBox.BackgroundColor3 = Color3.fromRGB(55,55,55)
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = listFrame
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.BackgroundTransparency = 1
    scroll.Parent = listFrame

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)

    local DROPDOWN_CLOSED_HEIGHT = 35 -- Tinggi container saat dropdown tertutup
    local DROPDOWN_OPEN_HEIGHT = 185 -- Tinggi container saat dropdown terbuka (35 + 150)
    local LIST_FRAME_OPEN_HEIGHT = 150 -- Tinggi listFrame saat terbuka

    -- Animasi buka/tutup dropdown
    local function toggleList(show)
        if show then
            listFrame.Visible = true
            -- Animasikan tinggi container dan listFrame secara bersamaan
            TweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, DROPDOWN_OPEN_HEIGHT)}):Play()
            TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 200, 0, LIST_FRAME_OPEN_HEIGHT)}):Play()
        else
            -- Animasikan tinggi container dan listFrame secara bersamaan
            TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, DROPDOWN_CLOSED_HEIGHT)}):Play()
            TweenService:Create(listFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 200, 0, 0)}):Play()
            task.delay(0.2, function() listFrame.Visible = false end)
        end
    end

    local listOpen = false
    dropdownBtn.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        toggleList(listOpen)
    end)

    local function refreshOptions(filter)
        for _,child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _,opt in ipairs(options) do
            if (not filter) or string.find(opt:lower(), filter:lower()) then
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -4, 0, 25)
                optBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
                optBtn.Text = opt
                optBtn.Font = Enum.Font.GothamBold
                optBtn.TextSize = 14
                optBtn.TextColor3 = Color3.fromRGB(220,220,220)
                optBtn.AutoButtonColor = false
                optBtn.Parent = scroll
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)

                local glowOpt = Instance.new("UIStroke", optBtn)
                glowOpt.Thickness = 2
                glowOpt.Color = Color3.fromRGB(180,0,0)
                glowOpt.Transparency = 1

                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(70,70,70),
                        TextColor3 = Color3.fromRGB(255,255,255)
                    }):Play()
                    TweenService:Create(glowOpt, TweenInfo.new(0.15), {Transparency = 0}):Play()
                end)

                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(55,55,55),
                        TextColor3 = Color3.fromRGB(220,220,220)
                    }):Play()
                    TweenService:Create(glowOpt, TweenInfo.new(0.15), {Transparency = 1}):Play()
                end)

                optBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = opt
                    if callback then
                        pcall(callback, opt)
                    end
                    listOpen = false
                    toggleList(false)
                end)
            end
        end
    end
    refreshOptions()

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        refreshOptions(searchBox.Text)
    end)

    UserInputService.InputBegan:Connect(function(input)
        if listOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = game.Players.LocalPlayer:GetMouse()
            -- Cek apakah klik di luar listFrame atau dropdownBtn
            local isClickInsideList = (mouse.X >= listFrame.AbsolutePosition.X and mouse.X <= listFrame.AbsolutePosition.X + listFrame.AbsoluteSize.X and
                                       mouse.Y >= listFrame.AbsolutePosition.Y and mouse.Y <= listFrame.AbsolutePosition.Y + listFrame.AbsoluteSize.Y)
            local isClickInsideButton = (mouse.X >= dropdownBtn.AbsolutePosition.X and mouse.X <= dropdownBtn.AbsolutePosition.X + dropdownBtn.AbsoluteSize.X and
                                         mouse.Y >= dropdownBtn.AbsolutePosition.Y and mouse.Y <= dropdownBtn.AbsolutePosition.Y + dropdownBtn.AbsoluteSize.Y)

            if not isClickInsideList and not isClickInsideButton then
                listOpen = false
                toggleList(false)
            end
        end
    end)

    return {
        Frame = container,
        Get = function() return dropdownBtn.Text end,
        Set = function(v) dropdownBtn.Text = v end
    }
end

    -- createCommandBox(placeholder, callback, column)
    function TabAPI:createCommandBox(placeholder, callback, column)
        local parent = getParent(self, column)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, 130) -- Sesuaikan ukuran agar pas di layout
        box.PlaceholderText = placeholder or "Ketik command..."
        box.TextSize = 14
        box.Font = Enum.Font.Code
        box.TextColor3 = Color3.fromRGB(255,255,255)
        box.BackgroundColor3 = Color3.fromRGB(60,60,60)
        box.ClearTextOnFocus = false
        box.MultiLine = true
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

        local g = Instance.new("UIGradient", box)
        g.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,60,60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
        }
        g.Rotation = 90

        local topStroke = Instance.new("Frame")
        topStroke.Size = UDim2.new(1,0,0,1)
        topStroke.Position = UDim2.new(0,0,0,0)
        topStroke.BackgroundColor3 = Color3.fromRGB(255,0,0)
        topStroke.BorderSizePixel = 0
        topStroke.Parent = box

        box.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local text = box.Text
                box.Text = ""
                if callback then
                    local ok,err = pcall(function() callback(text) end)
                    if not ok then warn("Command callback error:", err) end
                end
            end
        end)

        return box
    end

    -- createKeybind(label, defaultKey, callback, column)
    function TabAPI:createKeybind(labelText, defaultKey, callback, column)
        local parent = getParent(self, column)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 40)
        container.BackgroundTransparency = 1
        container.Parent = parent
        local hLayout = Instance.new("UIListLayout", container)
        hLayout.FillDirection = Enum.FillDirection.Horizontal
        hLayout.Padding = UDim.new(0, 8)
        hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        hLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Text = labelText
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0, 80, 0, 25)
        keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        keybindButton.Text = defaultKey.Name
        keybindButton.Font = Enum.Font.GothamBold
        keybindButton.TextSize = 14
        keybindButton.TextColor3 = Color3.fromRGB(240,240,240)
        keybindButton.AutoButtonColor = false
        keybindButton.Parent = container
        Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 6)

        local glow = Instance.new("UIStroke", keybindButton)
        glow.Thickness = 2
        glow.Color = Color3.fromRGB(0, 150, 255) -- Warna glow saat editing
        glow.Transparency = 1

        local keybindName = labelText:gsub(" ", "") -- Gunakan nama unik untuk keybind
        UI._keybinds[keybindName] = defaultKey
        if callback then
            UI._keybindCallbacks[keybindName] = callback
        end

        keybindButton.MouseButton1Click:Connect(function()
            if UI._editing then
                -- Batalkan editing sebelumnya jika ada
                UI._editing.Glow.Transparency = 1
            end
            UI._editing = {
                KeyName = keybindName,
                Label = keybindButton,
                Glow = glow
            }
            keybindButton.Text = "..."
            glow.Transparency = 0
            UI:Notify("Keybind", "Press any key to set keybind for '" .. labelText .. "'", 2)
        end)

        return {
            Frame = container,
            Get = function() return UI._keybinds[keybindName] end,
            Set = function(key)
                if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
                    UI._keybinds[keybindName] = key
                    keybindButton.Text = key.Name
                else
                    warn("Invalid KeyCode provided for keybind:", labelText)
                end
            end
        }
    end

    -- UI:Notify (global wrapper)
    function UI:Notify(title, text, duration)
        notify(title, text, duration)
    end

    -- Return TabAPI object
    UI._tabs[name] = TabAPI
    UI._tabFrames[name] = TabFrame -- Simpan referensi ke TabFrame
    return TabAPI
end

-- KEY INPUT HANDLER (global)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UI._editing and input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode
        local name = UI._editing.KeyName
        UI._keybinds[name] = key
        UI._editing.Label.Text = key.Name
        UI._editing.Glow.Transparency = 1
        UI._editing = nil
        UI:Notify("Keybind Set", "Keybind for '" .. name .. "' set to " .. key.Name, 1.5)
        return
    end

    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        for name, key in pairs(UI._keybinds) do
            if typeof(key) == "EnumItem" and input.KeyCode == key then
                if UI._keybindCallbacks[name] then
                    local ok,err = pcall(function() UI._keybindCallbacks[name]() end)
                    if not ok then warn("Keybind callback error for '" .. name .. "':", err) end
                end
                -- Keybind khusus untuk membuka/menutup GUI
                if name == "OpenGUI" then
                    toggleGUI()
                end
            end
        end
    end
end)

function UI:createTabs(...)
    local names = {...}
    for _,n in ipairs(names) do
        self:createTab(n)
    end
end

-- === CONTOH / DEFAULTS ===
local PlayerTab = UI:createTab("Player")
local AnotherTab = UI:createTab("Another Tab")
local MountainTab = UI:createTab("Mountain")
local SettingsTab = UI:createTab("Settings")
local VipTab = UI:createTab("Vip Work Tools")

-- Secara default, tampilkan tab pertama
if PlayerTab then
    PlayerTab._frame.Visible = true
    UI._activeTab = "PlayerTab"
end

-- Konten untuk PlayerTab
PlayerTab:createCommandBox("Enter command...", function(text)
    print("Command:", text)
    UI:Notify("Command Executed", "Executed: " .. text, 1.5)
    -- Contoh: Jalankan command di server (jika ada RemoteEvent)
    -- game.ReplicatedStorage.RemoteEvents.ExecuteCommand:FireServer(text)
end, 1) -- Kolom kiri

PlayerTab:createSection("Misc", 1) -- Contoh penggunaan section
-- ====================== ANTI AFK =====================
local VirtualUser = game:GetService("VirtualUser")
local AntiAfkConnection -- buat simpan koneksi anti afk

-- === TOGGLE ANTI AFK ===
PlayerTab:createToggle("Anti AFK", false, function(state)
    if state then
        -- aktifkan
        AntiAfkConnection = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            print("[Anti AFK] Triggered.")
        end)
        UI:Notify("Anti AFK", "ON", 1.5)
    else
        -- matikan
        if AntiAfkConnection then
            AntiAfkConnection:Disconnect()
            AntiAfkConnection = nil
        end
        UI:Notify("Anti AFK", "OFF", 1.5)
    end
end, 1) -- Kolom kiri

-- ==================== ANTI KICK =====================
local AntiKickHook
local AntiKickEnabled = false

-- === TOGGLE ANTI KICK ===
PlayerTab:createToggle("Anti Kick", false, function(state)
AntiKickEnabled = state
        if state then
--Hook metamethod __namecall untuk blokir :Kick()
        AntiKickHook = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if tostring(self) == player.Name and method == "Kick" and AntiKickEnabled then
            warn("[Anti Kick] Kick attempt blocked!")
            return nil
        end
    return AntiKickHook(self, ...)
end)

-- Hook method langsung
local oldKick
oldKick = hookfunction(player.Kick, function(...)
    if AntiKickEnabled then
        warn("[Anti Kick] Kick attempt blocked (direct call)!")
        return nil
    end
        return oldKick(...)
    end)
        UI:Notify("Anti Kick", "ON", 1.5)
    else
-- Matikan (tidak bisa full restore karena hook permanent, tapi toggle matiin logikanya)
        UI:Notify("Anti Kick", "OFF", 1.5)
    end
end, 1) -- Kolom kiri

-- ========================= ANTI BANNED ==========================
local AntiBanEnabled = false
local oldNamecall
local oldKickFunc

local function callOriginalNamecall(...)
    if oldNamecall then
        return oldNamecall(...)
    end
end

if type(hookmetamethod) == "function" then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()

        if AntiBanEnabled then
            -- 1) blokir :Kick() terhadap local player
            if method == "Kick" then
                warn("[AntiBan] Blocked Kick call.")
                return nil
            end

            -- 2) blokir FireServer/InvokeServer ke RemoteEvents/Functions yang namanya mengandung 'ban'/'kick'
            if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                local nm = (self.Name or ""):lower()
                if string.find(nm, "ban") or string.find(nm, "kick") or string.find(nm, "banplayer") then
                    warn("[AntiBan] Blocked call to remote '" .. tostring(self.Name) .. "' (suspected ban/kick).")
                    return nil
                end
            end
        end

        -- fallback: panggil original namecall
        return oldNamecall(self, ...)
    end)
else
    warn("[AntiBan] hookmetamethod not available on this executor; some protections disabled.")
end

-- Try hook direct Player:Kick function (some scripts call player:Kick directly)
if type(hookfunction) == "function" then
    if player and player.Kick then
        -- simpan original
        local ok, orig = pcall(function() return hookfunction(player.Kick, function(...) 
            if AntiBanEnabled then
                warn("[AntiBan] Blocked direct player:Kick() call.")
                return nil
            end
            return orig(...)
        end) end)
        if ok and orig then
            oldKickFunc = orig
        else
            -- jika gagal (hookfunction returns original), masih coba buat wrapper aman
            pcall(function()
                oldKickFunc = player.Kick
                player.Kick = function(...) 
                    if AntiBanEnabled then
                        warn("[AntiBan] Blocked player:Kick() call (wrapper).")
                        return nil
                    end
                    return oldKickFunc(...)
                end
            end)
        end
    end
else
    -- fallback: override function (may error on certains executors)
    pcall(function()
        if player and player.Kick then
            oldKickFunc = player.Kick
            player.Kick = function(...)
                if AntiBanEnabled then
                    warn("[AntiBan] Blocked player:Kick() call (override).")
                    return nil
                end
                return oldKickFunc(...)
            end
        end
    end)
end

local function isSuspiciousRemote(inst)
    local name = (inst and inst.Name and tostring(inst.Name):lower()) or ""
    if string.find(name, "ban") or string.find(name, "kick") or string.find(name, "banplayer") then
        return true
    end
    return false
end

local function notify(msg)
    pcall(function()
        if UI and UI.Notify then UI:Notify("AntiBan", msg, 1.5) end
    end)
end

if PlayerTab and PlayerTab.createToggle then
    PlayerTab:createToggle("Anti Banned", false, function(state)
        AntiBanEnabled = state
        if AntiBanEnabled then
            notify("Anti Ban ON.")
            warn("[AntiBan] OFF.")
        else
            notify("Anti Ban ON.")
            warn("[AntiBan] OFF.")
        end
    end, 1)
else
    warn("[AntiBan] PlayerTab or createToggle not found — toggle not created.")
end

-- ========================= REJOIN =========================
local TeleportService = game:GetService("TeleportService")
-- === BUTTON REJOIN SERVER ===
PlayerTab:createButton("Rejoin Server", function()
local placeId = game.PlaceId
local jobId = game.JobId

    if #jobId > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
        UI:Notify("Rejoin", "Teleporting to same server...", 1.5)
    else
        TeleportService:Teleport(placeId, player)
        UI:Notify("Rejoin", "Teleporting to new server...", 1.5)
    end
end, 1) -- Kolom kiri

-- ======================= SERVER HOP =========================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
-- === BUTTON SERVER HOP ===
PlayerTab:createButton("Server Hop", function()
    local placeId = game.PlaceId

    -- ambil daftar server publik via Roblox API
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
        ))
    end)

    if success and servers and servers.data then
        local availableServers = {}

        -- filter server yang bukan server kita sekarang dan belum penuh
        for _, server in ipairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(availableServers, server.id)
            end
        end

        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            UI:Notify("Server Hop", "Teleporting to new server...", 1.5)
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, player)
        else
            UI:Notify("Server Hop", "Tidak ada server lain yang tersedia", 1.5)
        end
    else
        UI:Notify("Server Hop", "Gagal mendapatkan data server", 1.5)
    end
end, 1) -- Kolom kiri

PlayerTab:createSection("Visuals", 2) -- Contoh penggunaan section
PlayerTab:createSlider("Brightness", 0, 15, 5, function(v)
    print("Brightness:", v)
    -- Contoh: Mengubah pencahayaan global
    game.Lighting.Brightness = v
end, 2) -- Kolom kanan

-- ====================== ANTI LAGGING ====================
local Lighting = game:GetService("Lighting")
local AntiLagEnabled = false
local CleanConnection
local DefaultLighting = {}
local DisabledObjects = {}

-- simpan setting default Lighting
local function saveDefaults()
    DefaultLighting.GlobalShadows = Lighting.GlobalShadows
    DefaultLighting.FogEnd = Lighting.FogEnd
    DefaultLighting.Brightness = Lighting.Brightness
    DefaultLighting.Effects = {}
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
        or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            DefaultLighting.Effects[v] = v.Enabled
        end
    end
end

-- kembalikan setting default Lighting
local function restoreDefaults()
    if DefaultLighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = DefaultLighting.GlobalShadows
        Lighting.FogEnd = DefaultLighting.FogEnd
        Lighting.Brightness = DefaultLighting.Brightness
        for eff, state in pairs(DefaultLighting.Effects) do
            if eff and eff:IsDescendantOf(Lighting) then
                eff.Enabled = state
            end
        end
    end

    -- aktifkan kembali object yang sempat dimatikan
    for obj, state in pairs(DisabledObjects) do
        if obj and obj.Parent then
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
            or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
                obj.Enabled = state
            end
        end
    end
    DisabledObjects = {}
end

-- fungsi bersihkan objek berat
local function clearLaggyStuff()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
        or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
            if DisabledObjects[v] == nil then
                DisabledObjects[v] = v.Enabled
            end
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v:Destroy()
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

-- fungsi apply lighting ringan
local function optimizeLighting()
    saveDefaults()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect")
            or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
    end)
end

-- enable Anti-Lag
local function enableAntiLag()
    AntiLagEnabled = true
    optimizeLighting()
    clearLaggyStuff()
    CleanConnection = RunService.Heartbeat:Connect(clearLaggyStuff)
end

-- disable Anti-Lag (restore ke default)
local function disableAntiLag()
    AntiLagEnabled = false
    if CleanConnection then
        CleanConnection:Disconnect()
        CleanConnection = nil
    end
    restoreDefaults()
end

-- === TOGGLE UI ===
PlayerTab:createToggle("Anti Lag", false, function(s)
    if s then
        print("Anti Lag ON")
        enableAntiLag()
    else
        print("Anti Lag OFF")
        disableAntiLag()
    end
    UI:Notify("Anti-Lag", "Anti Lag is now " .. (s and "ON" or "OFF"), 1.5)
end, 2) -- Kolom kanan

-- ======================= HIDE UI =====================
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")

-- simpan state
local SavedStates = {}
local SavedCore = {}
local SavedBillboards = {}
local SavedSurfaces = {}

-- referensi gui utama (dibuat oleh script ini)
local scriptParentGui = script.Parent

-- fungsi aman get children
local function safeChildren(parent)
    local ok, children = pcall(function() return parent:GetChildren() end)
    return ok and children or {}
end

-- hide semua UI kecuali gui milik script ini
local function hideUI()
    SavedStates = {}
    SavedCore = {}
    SavedBillboards = {}
    SavedSurfaces = {}

    -- CoreGui bawaan Roblox
    for _, cgType in pairs(Enum.CoreGuiType:GetEnumItems()) do
        local ok, state = pcall(function() return StarterGui:GetCoreGuiEnabled(cgType) end)
        if ok then
            SavedCore[cgType] = state
            if state then
                pcall(function() StarterGui:SetCoreGuiEnabled(cgType, false) end)
            end
        end
    end

    -- ScreenGui di PlayerGui & CoreGui
    for _, gui in pairs(safeChildren(PlayerGui)) do
        if gui:IsA("ScreenGui") and gui ~= scriptParentGui then
            SavedStates[gui] = gui.Enabled
            gui.Enabled = false
        end
    end
    for _, gui in pairs(safeChildren(CoreGui)) do
        if gui:IsA("ScreenGui") and gui ~= scriptParentGui then
            SavedStates[gui] = gui.Enabled
            gui.Enabled = false
        end
    end

    -- BillboardGui & SurfaceGui
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            SavedBillboards[obj] = obj.Enabled
            obj.Enabled = false
        elseif obj:IsA("SurfaceGui") then
            SavedSurfaces[obj] = obj.Enabled
            obj.Enabled = false
        end
    end
end

-- restore semua UI
local function showUI()
    for cgType, state in pairs(SavedCore) do
        pcall(function() StarterGui:SetCoreGuiEnabled(cgType, state) end)
    end
    for gui, state in pairs(SavedStates) do
        if gui and gui:IsA("ScreenGui") then
            pcall(function() gui.Enabled = state end)
        end
    end
    for gui, state in pairs(SavedBillboards) do
        if gui and gui:IsA("BillboardGui") then
            pcall(function() gui.Enabled = state end)
        end
    end
    for gui, state in pairs(SavedSurfaces) do
        if gui and gui:IsA("SurfaceGui") then
            pcall(function() gui.Enabled = state end)
        end
    end

    SavedStates, SavedCore, SavedBillboards, SavedSurfaces = {}, {}, {}, {}
end

-- status UI
local uiHidden = false

-- toggle fungsi
local function toggleUI()
    if uiHidden then
        showUI()
        uiHidden = false
        UI:Notify("Hide UI", "UI is now ON", 1)
    else
        hideUI()
        uiHidden = true
        UI:Notify("Hide UI", "UI is now OFF", 1)
    end
end

-- === TOGGLE UI dari menu ===
PlayerTab:createToggle("Hide UI", false, function(s)
    if s then
        hideUI()
        uiHidden = true
    else
        showUI()
        uiHidden = false
    end
    UI:Notify("Hide UI", "Hide UI is now " .. (s and "ON" or "OFF"), 1)
end, 2)

-- Contoh konten untuk "Another Tab"
AnotherTab:createSection("Player Controls", 1)
AnotherTab:createToggle("God Mode", false, function(s)
    print("God Mode:", s)
    UI:Notify("God Mode", "God Mode is now " .. (s and "ON" or "OFF"), 2)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.MaxHealth = (s and math.huge or 100)
        player.Character.Humanoid.Health = (s and math.huge or 100)
    end
end, 1) -- Kolom kiri

-- ========================= FLY ==========================
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local flying = false
local speed = 90
local bv, bg

-- helper smooth
local function lerpVec3(a, b, t)
    return a + (b - a) * t
end

local function startFly()
    if flying then return end
    flying = true
    humanoid.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 5000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    local currentVel = Vector3.zero

    RunService:BindToRenderStep("FlyMove", Enum.RenderPriority.Character.Value, function(dt)
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero

        -- input gerakan
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec -= cam.CFrame.RightVector
        end

        -- naik turun
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVec += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVec += Vector3.new(0, -1, 0)
        end

        -- target kecepatan
        local targetVel = Vector3.zero
        if moveVec.Magnitude > 0 then
            targetVel = moveVec.Unit * speed
        end

        -- smoothing
        currentVel = lerpVec3(currentVel, targetVel, math.clamp(dt * 8, 0, 1))
        bv.Velocity = currentVel

        -- arahkan BodyGyro ke arah kamera (lebih fleksibel)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    RunService:UnbindFromRenderStep("FlyMove")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

local function toggleFly()
    if flying then
        stopFly()
        UI:Notify("Fly", "Fly is now OFF", 1)
    else
        startFly()
        UI:Notify("Fly", "Fly is now ON", 1)
    end
end

-- === TOGGLE DI MENU ===
AnotherTab:createToggle("Fly", false, function(s)
    if s then
        startFly()
    else
        stopFly()
    end
    UI:Notify("Fly", "Fly is now " .. (s and "ON" or "OFF"), 1)
end, 1)

-- === RESET KALAU RESPWAN ===
player.CharacterAdded:Connect(function(c)
    char = c
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    stopFly()
end)

-- ========================== FLY NOCLIP ==========================
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- === STATUS ===
local flying = false
local noclip = false
local speed = 80

local bv, bg
local currentVel = Vector3.zero

-- helper smoothing
local function lerpVec3(a, b, t)
    return a + (b - a) * t
end

-- === FLY START/STOP ===
local function startFly()
    if flying then return end
    flying = true
    humanoid.PlatformStand = true
    noclip = true -- aktifkan noclip juga

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero
    bv.P = 1250
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 3000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    RunService:BindToRenderStep("FlyMove", Enum.RenderPriority.Character.Value, function(dt)
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero

        -- arah input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec -= cam.CFrame.RightVector
        end

        -- naik turun
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVec += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVec += Vector3.new(0, -1, 0)
        end

        local targetVel = Vector3.zero
        if moveVec.Magnitude > 0 then
            targetVel = moveVec.Unit * speed
        end

        -- smoothing biar halus
        currentVel = lerpVec3(currentVel, targetVel, math.clamp(dt * 8, 0, 1))
        bv.Velocity = currentVel

        -- arah karakter mengikuti kamera
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    noclip = false
    RunService:UnbindFromRenderStep("FlyMove")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

-- === NOCLIP LOOP (hanya aktif kalau noclip = true) ===
RunService.Stepped:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- === FEATURE TOGGLE ===
local featureEnabled = false
local function toggleFeature(state)
    featureEnabled = state
    if state then
        startFly()
    else
        stopFly()
    end
end

-- === STATUS ===
local featureEnabled = false  -- status gabungan Fly+Noclip

-- === TOGGLE FUNGSI GABUNG ===
local function toggleFeature(state)
    featureEnabled = state
    if state then
        startFly()
        noclip = true
        UI:Notify("Fly NoCLIP", "Fly Noclip ON", 1)
    else
        stopFly()
        noclip = false
        UI:Notify("Fly NoClip", "Fly Noclip OFF", 1)
    end
end

-- === TOGGLE DARI UI ===
local FeatureToggle = AnotherTab:createToggle("Fly NoClip", false, function(s)
    toggleFeature(s)
end, 1)

-- === RESPAWN CLEANUP ===
player.CharacterAdded:Connect(function(c)
    char = c
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    stopFly()
    noclip = false
end)

-- ======================== INF JUMP ======================
-- === STATUS ===
local infJumpEnabled = false  -- status global Infinite Jump
local humanoid

-- update humanoid tiap respawn
local player = game:GetService("Players").LocalPlayer
local function onCharacterAdded(char)
    humanoid = char:WaitForChild("Humanoid")
end
if player.Character then onCharacterAdded(player.Character) end
player.CharacterAdded:Connect(onCharacterAdded)

-- listener untuk lompat tak terbatas
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled and humanoid and humanoid.Health > 0 then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === TOGGLE FUNGSI GABUNG ===
local function toggleInfJump(state)
    infJumpEnabled = state
    if state then
        UI:Notify("Infinite Jump", "Infinite Jump ON", 1)
    else
        UI:Notify("Infinite Jump", "Infinite Jump OFF", 1)
    end
end

-- === TOGGLE DARI UI ===
local InfJumpToggle = AnotherTab:createToggle("Infinite Jump", false, function(s)
    toggleInfJump(s)
end, 1)

AnotherTab:createSection("Movement Settings", 2)
AnotherTab:createSlider("WalkSpeed", 16, 200, 16,function(v)
    print("WalkSpeed:", v)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = v
    end
end, 2) -- Kolom kanan

-- konten untuk Mountain Tab
MountainTab:createSection("Mount 1", 1)
MountainTab:createButton("Teleport Home", function()
    print("Teleporting home...")
    UI:Notify("Teleport", "Teleporting to spawn...", 2)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0) -- Ganti dengan posisi spawn Anda
    end
end, 1) -- Kolom kiri

MountainTab:createSection("Mount 2", 2)
MountainTab:createDropdown("Team", {"Red", "Blue", "Green"}, "Red", function(v)
    print("Team set to", v)
    UI:Notify("Team Change", "You joined team: " .. v, 1)
    -- Contoh: Mengubah tim pemain (membutuhkan RemoteEvent ke server)
    -- game.ReplicatedStorage.RemoteEvents.ChangeTeam:FireServer(v)
end, 2) -- Kolom kanan

-- Konten untuk Settings Tab
SettingsTab:createSection("Keybinds", 1)
-- ========================== KEYBIND POPUP ==========================
SettingsTab:createKeybind("Open GUI", Enum.KeyCode.T, function()
    print("GUI Keybind triggered!")
end, 1)

-- ========================== KEYBIND HIDE UI =============================
SettingsTab:createKeybind("Hide UI", Enum.KeyCode.H, function()
    toggleUI()
end, 1)

-- ========================== KEYBIND FLY ==============================
SettingsTab:createKeybind("Fly", Enum.KeyCode.F, function()
    toggleFly()
end, 1)

-- =========================== INF JUMP =============================
SettingsTab:createKeybind("Infinite Jump", Enum.KeyCode.J, function()
    local newState = not infJumpEnabled
    InfJumpToggle:Set(newState)
    toggleInfJump(newState)
end, 1)

-- ========================= KEYBIND NOCLIP ==========================
SettingsTab:createKeybind("Fly Noclip",Enum.KeyCode.N, function()
    local newState = not featureEnabled  -- toggle status global
    FeatureToggle:Set(newState)          -- update UI toggle
    toggleFeature(newState)              -- panggil fungsi
end, 1)

-- ======================== KEYBIND WALKSPEED ========================
local defaultSpeed = 16
local speed = defaultSpeed

local function setSpeed(v)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = v
    end
end

-- init on spawn
player.CharacterAdded:Connect(function(c)
    task.wait(0.1)
    setSpeed(speed)
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.Equals or inp.KeyCode == Enum.KeyCode.KeypadPlus then
        speed = math.clamp(speed + 4, 0, 250)
        setSpeed(speed)
        print("WalkSpeed:", speed)
    elseif inp.KeyCode == Enum.KeyCode.Minus or inp.KeyCode == Enum.KeyCode.KeypadMinus then
        speed = math.clamp(speed - 4, 0, 250)
        setSpeed(speed)
        print("WalkSpeed:", speed)
    elseif inp.KeyCode == Enum.KeyCode.K then
        speed = defaultSpeed
        setSpeed(speed)
        print("WalkSpeed reset to", speed)
    end
end, 1)

-- konten untuk Vip Tools tab
VipTab:createSection("Tools Scan Object/Part", 1)
-- ========================= SCAN OBJECT/PART =============================
local HttpService = game:GetService("HttpService")
local mouse = player:GetMouse()

-- === KONFIG WEBHOOK ===
local WEBHOOK_URL = "https://canary.discord.com/api/webhooks/1422465793677066294/4NtJPAWs18oHRtEa2PbsLqtZNWJnBD-aJfG2MI3lePMTHw37K9OtbKW9FO2iRUlLk7rI" -- Ganti dengan webhook milikmu

local function sendToDiscord(target)
    if not http_request then
        warn("Executor tidak support http_request, webhook tidak bisa dikirim.")
        return
    end

    local info = {
        name = target.Name,
        path = target:GetFullName(),
        pos = string.format("X=%.2f, Y=%.2f, Z=%.2f", target.Position.X, target.Position.Y, target.Position.Z),
        player = player.Name
    }

    local embed = {
        title = "📡 Hasil Scan Part",
        description = "Klik scan oleh **" .. player.Name .. "**",
        color = 0x7289da, -- biru Discord
        fields = {
            { name = "Nama Part", value = info.name, inline = true },
            { name = "Posisi", value = info.pos, inline = true },
            { name = "Path", value = info.path, inline = false },
            { name = "Player", value = info.player, inline = true }
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        username = "YuviHub Logger",
        embeds = { embed }
    }

    local ok, err = pcall(function()
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if not ok then
        warn("Gagal kirim webhook:", err)
    else
        UI:Notify("Discord", "Hasil scan terkirim ke Discord", 1.5)
    end
end

-- === VARIABEL SCAN ===
local ScanEnabled = false
local ScanConnection
local CommandBox -- buat simpan command box

-- 🟢 FUNGSI AKTIFKAN / NONAKTIFKAN SCAN
local function setScanState(state)
    ScanEnabled = state
    if ScanEnabled then
        UI:Notify("Scan Mode", "Klik part untuk scan info", 1.5)
        ScanConnection = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target:IsA("BasePart") then
                local info = "Name: " .. target.Name ..
                             " | Path: " .. target:GetFullName() ..
                             " | Pos: " .. tostring(target.Position)

                print("=== HASIL SCAN ===")
                print(info)
                print("==================")

                UI:Notify("Scan Result", target:GetFullName(), 2)

                if CommandBox then
                    CommandBox.Text = info
                end

                -- kirim ke Discord
                sendToDiscord(target)
            else
                UI:Notify("Scan Result", "Bukan part / tidak ada target", 1.2)
                if CommandBox then
                    CommandBox.Text = "Tidak ada target / bukan part"
                end
            end
        end)
    else
        if ScanConnection then
            ScanConnection:Disconnect()
            ScanConnection = nil
        end
        UI:Notify("Scan Mode", "Scan dimatikan", 1.2)
        if CommandBox then
            CommandBox.Text = ""
        end
    end
end

-- === TOGGLE SCAN ===
VipTab:createToggle("Manual Scan", false, function(s)
    print("Manual Scan:", s)
    setScanState(s)
end, 1) -- Kolom kiri

-- === COMMAND BOX (HASIL SCAN) ===
CommandBox = VipTab:createCommandBox("Hasil scan muncul di sini...", function(text)
    print("Command:", text)
    UI:Notify("Command Box", "Input: " .. text, 1.5)
end, 1)

VipTab:createSection("Tools Koordinat", 2)
-- ======================== KOORDINAT =========================
local HttpService = game:GetService("HttpService")
local mouse = player:GetMouse()

-- === KONFIGURASI WEBHOOK ===
local WEBHOOK_URL = "https://canary.discord.com/api/webhooks/1422459930283347972/ML4jRqA2QR-liSdcQnWx8gKfUJVDrV03EzAo8whowhdoXrAxqA8LtArBMq1NxhxW15ig" -- ganti dengan URL webhook kamu

-- fungsi untuk kirim payload ke Discord
local function sendToDiscord(name, pos, index)
    if not http_request then
        warn("Executor tidak support http_request, webhook tidak terkirim.")
        return
    end

    local embed = {
        title = "📍 Koordinat Baru",
        description = "Klik koordinat oleh **" .. player.Name .. "**",
        color = 0x2ecc71, -- hijau
        fields = {
            { name = "Nama", value = name, inline = true },
            { name = "Posisi", value = string.format("X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z), inline = true },
            { name = "Index", value = tostring(index), inline = true }
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = {
        username = "YuviHub Logger",
        embeds = { embed }
    }

    local body = HttpService:JSONEncode(payload)

    local ok, err = pcall(function()
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)

    if not ok then
        warn("Gagal kirim ke Discord:", err)
    else
        UI:Notify("Discord", "Koordinat dikirim ke Discord", 1.5)
    end
end

-- === VARIABEL ===
local ScanEnabled = false
local ScanConnection
local SavedCoords = {} -- simpan hasil koordinat
local CommandBox
local coordCount = 0 -- buat ID unik koordinat

-- === FUNGSI TELEPORT ===
local function teleportTo(position)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
end

-- === FUNGSI HAPUS KOORDINAT ===
local function removeCoordinate(data)
    local index
    for i, v in ipairs(SavedCoords) do
        if v == data then
            index = i
            break
        end
    end
    if not index then return end

    if data.teleportBtn then
        pcall(function() data.teleportBtn:Destroy() end)
    end
    if data.deleteBtn then
        pcall(function() data.deleteBtn:Destroy() end)
    end

    table.remove(SavedCoords, index)
    UI:Notify("Remove", data.name .. " dihapus", 1.5)
end

-- === FUNGSI TAMBAH KOORDINAT + BUTTON ===
local function addCoordinate(tab, column, name, pos)
    coordCount += 1
    local coordName = name .. " #" .. coordCount

    local data = {}

    data.teleportBtn = tab:createButton("Teleport: " .. coordName, function()
        teleportTo(pos)
        UI:Notify("Teleport", "Teleported ke " .. coordName, 1.5)
    end, column)

    data.deleteBtn = tab:createButton("❌ Hapus: " .. coordName, function()
        removeCoordinate(data)
    end, column)

    data.name = coordName
    data.pos = pos
    table.insert(SavedCoords, data)

    print("Koordinat disimpan:", coordName, pos)
    UI:Notify("Scan Result", coordName .. " saved", 1.5)

    -- kirim ke Discord juga
    sendToDiscord(coordName, pos, coordCount)
end

-- === FUNGSI SET SCAN ===
local function setScanState(state, tab, column)
    ScanEnabled = state
    if ScanEnabled then
        UI:Notify("Scan Mode", "Klik dimana saja untuk ambil koordinat", 1.5)
        ScanConnection = mouse.Button1Down:Connect(function()
            local pos = mouse.Hit.Position
            local target = mouse.Target
            local name = target and target.Name or "Koordinat"

            local info = string.format("Name: %s | X=%.2f, Y=%.2f, Z=%.2f", name, pos.X, pos.Y, pos.Z)
            if CommandBox then
                CommandBox.Text = info
            end

            addCoordinate(tab, column, name, pos)
        end)
    else
        if ScanConnection then
            ScanConnection:Disconnect()
            ScanConnection = nil
        end
        UI:Notify("Scan Mode", "Dimatikan", 1.2)
    end
end

-- === TOGGLE SCAN ===
VipTab:createToggle("Manual Scan", false, function(s)
    print("Manual Scan:", s)
    setScanState(s, VipTab, 2)
end, 2)

-- === COMMAND BOX ===
CommandBox = VipTab:createCommandBox("Hasil scan muncul di sini...", function(text)
    print("Command Input:", text)
    UI:Notify("Command Box", "Input: " .. text, 1.5)
end, 2)

-- Logo Loading
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 200, 0, 200)
Logo.Position = UDim2.new(0.5, -100, 0.5, -100)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://81450116624685"
Logo.ImageTransparency = 1
Logo.Parent = ScreenGui

local tweenInfoFade = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoScale = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Animasi fade in
TweenService:Create(Logo, tweenInfoFade, {ImageTransparency = 0}):Play()
-- Animasi scale (jika ingin dari kecil ke besar)
-- Jika ingin ukuran tetap 200x200, hapus baris ini atau set ukuran awal lebih kecil
Logo.Size = UDim2.new(0, 50, 0, 50) -- Contoh: mulai dari 50x50
TweenService:Create(Logo, tweenInfoScale, {Size = UDim2.new(0, 200, 0, 200)}):Play()

task.delay(3, function()
    Logo:Destroy()
    MainFrame.Visible = true
    -- Pastikan tab pertama aktif dan tombolnya terlihat aktif
    if UI._activeTab then
        local activeTabButton = TabButtonHolder:FindFirstChild("TabButton_" .. UI._activeTab)
        if activeTabButton then
            local scale = activeTabButton:FindFirstChild("ClickScale")
            if scale then
                scale.Scale = 1 -- Pastikan skala normal
            end
        end
    end
end)

-- Return UI object (optional)
_G.YuviHubUI = UI
