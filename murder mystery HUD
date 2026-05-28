-- [[ LOUIS LITE HUD - CUSTOM FEATURES EDITION ]]
-- VERSION: 2.2.0 (Spacing, Resizeable POS & Lock Sync Edition)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer

-- ========================================================
-- [[ INTERNAL CONFIGURATION STATES ]]
-- ========================================================
local Settings = {
    DragLocked = false,
    InfiniteJump = false,
    AntiVoid = false,
    AntiFling = false,
    TouchFling = false,
    FlingPower = 100,
    SelectedPlayerName = "",
    ShowExtPos = true, -- Default menampilkan tombol eksternal POS
}

local SavedCFrame = nil
local Connections = {}
local DynamicThemeElements = {}

local function SafeConnect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(Connections, conn)
    return conn
end

-- Fungsi Pembersihan Skrip (Clean Unload)
local function UnloadScript()
    for _, conn in ipairs(Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(Connections)
    table.clear(DynamicThemeElements)
    
    local gui = (gethui and gethui()) or game:GetService("CoreGui")
    local existingGui = gui:FindFirstChild("LouisLite_Custom_GUI")
    if existingGui then
        existingGui:Destroy()
    end
    
    print("Louis Lite GUI cleanly unloaded.")
end

-- Menghapus GUI lama jika dijalankan ulang
local currentGuiContainer = (gethui and gethui()) or game:GetService("CoreGui")
local oldGui = currentGuiContainer:FindFirstChild("LouisLite_Custom_GUI")
if oldGui then
    oldGui:Destroy()
end

-- ========================================================
-- [[ DYNAMIC THEME SYSTEM (RAINBOW SYNC) ]]
-- ========================================================
local function RegisterDynamic(instance, property)
    table.insert(DynamicThemeElements, {Instance = instance, Property = property})
end

SafeConnect(RunService.RenderStepped, function()
    local hue = (os.clock() % 4) / 4
    local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
    for i = #DynamicThemeElements, 1, -1 do
        local item = DynamicThemeElements[i]
        if item.Instance and item.Instance.Parent then
            pcall(function()
                item.Instance[item.Property] = rainbowColor
            end)
        else
            table.remove(DynamicThemeElements, i)
        end
    end
end)

-- Mengatur visual tombol aktif/nonaktif
local function SetToggleState(btn, state)
    if state then
        for i = #DynamicThemeElements, 1, -1 do
            local item = DynamicThemeElements[i]
            if item.Instance == btn and item.Property == "BackgroundColor3" then
                table.remove(DynamicThemeElements, i)
            end
        end
        btn.TextColor3 = Color3.new(0, 0, 0)
        RegisterDynamic(btn, "BackgroundColor3")
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then
            RegisterDynamic(stroke, "Color")
        end
    else
        for i = #DynamicThemeElements, 1, -1 do
            local item = DynamicThemeElements[i]
            if item.Instance == btn and (item.Property == "BackgroundColor3" or (item.Instance:IsA("UIStroke") and item.Instance.Parent == btn)) then
                table.remove(DynamicThemeElements, i)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.TextColor3 = Color3.new(1, 1, 1)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(45, 45, 50) end
    end
end

-- ========================================================
-- [[ CORE GAMEPLAY UTILITIES ]]
-- ========================================================

-- Pencocokan Nama Pemain
local function MatchPlayer(name)
    if name == "" then return nil end
    name = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name then
            return p
        end
    end
    return nil
end

local function SavePosition()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        SavedCFrame = root.CFrame
    end
end

local function LoadSavedPosition()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and SavedCFrame then
        root.CFrame = SavedCFrame
    end
end

-- Fling Spesifik Target
local function FlingPlayer(targetPlayer)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local oldPos = root.CFrame
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        
        SavePosition()
        local originalFlingState = Settings.TouchFling
        Settings.TouchFling = true
        
        task.spawn(function()
            for i = 1, 15 do
                if targetRoot and root and char:FindFirstChild("HumanoidRootPart") then
                    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0.2)
                end
                task.wait(0.02)
            end
            Settings.TouchFling = originalFlingState
            root.CFrame = oldPos
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    end
end

-- Teleport ke pemain target
local function TpToPlayer(targetPlayer)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        root.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end

-- ========================================================
-- [[ SILENT TOUCH FLING PHYSICS LOOPS ]]
-- ========================================================
local originalVelocity = Vector3.new(0, 0, 0)
local originalRotVelocity = Vector3.new(0, 0, 0)

-- Langkah Fisika
SafeConnect(RunService.Heartbeat, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        if Settings.TouchFling then
            local multiplier = Settings.FlingPower * 1000
            originalVelocity = root.AssemblyLinearVelocity
            originalRotVelocity = root.AssemblyAngularVelocity
            
            root.AssemblyLinearVelocity = Vector3.new(multiplier, multiplier, multiplier)
            root.AssemblyAngularVelocity = Vector3.new(0, multiplier, 0)
            
            for _, child in ipairs(char:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
        if Settings.AntiFling and not Settings.TouchFling then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Langkah Visualisasi
SafeConnect(RunService.RenderStepped, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and Settings.TouchFling then
        root.AssemblyLinearVelocity = originalVelocity
        root.AssemblyAngularVelocity = originalRotVelocity
    end
end)

-- Infinite Jump Mechanics
SafeConnect(UserInputService.JumpRequest, function()
    if Settings.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Anti-Void Execution Loop
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AntiVoid and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and root.Position.Y < -80 then
                if SavedCFrame then
                    root.CFrame = SavedCFrame
                else
                    local spawns = Workspace:FindFirstChildOfClass("SpawnLocation")
                    if not spawns and Workspace:FindFirstChild("SpawnLocations") then
                        spawns = Workspace.SpawnLocations:FindFirstChildOfClass("SpawnLocation")
                    end
                    if spawns then
                        root.CFrame = spawns.CFrame * CFrame.new(0, 3, 0)
                    end
                end
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- ========================================================
-- [[ MAIN CORE GUI ENGINE ]]
-- ========================================================
local ScreenGui = Instance.new("ScreenGui", currentGuiContainer)
ScreenGui.Name = "LouisLite_Custom_GUI"
ScreenGui.ResetOnSpawn = false

-- Draggable Utility Helper (Mendukung Fitur Kunci Bersama)
local function MakeDraggable(frame)
    local dragging, dragStart, startPos
    SafeConnect(frame.InputBegan, function(i)
        if not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    SafeConnect(UserInputService.InputChanged, function(i)
        if dragging and not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    SafeConnect(UserInputService.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ========================================================
-- [[ EXTERNAL CONTROLS WITH DYNAMIC RESIZING ]]
-- ========================================================
local ExtButtonContainer = Instance.new("Frame", ScreenGui)
ExtButtonContainer.Name = "ExtButtonContainer"
ExtButtonContainer.Position = UDim2.new(0, 20, 0.4, 0)
ExtButtonContainer.BackgroundTransparency = 1
ExtButtonContainer.Visible = Settings.ShowExtPos
MakeDraggable(ExtButtonContainer)

-- Konfigurasi Ukuran Eksternal (Small, Medium, Large)
local currentExtSizeIndex = 2
local extSizes = {
    {btnSize = 32, spacing = 36, fontSize = 8},   -- Small
    {btnSize = 42, spacing = 48, fontSize = 10},  -- Medium
    {btnSize = 52, spacing = 58, fontSize = 12}   -- Large
}

local function CreateExtButton(text, callback)
    local btn = Instance.new("TextButton", ExtButtonContainer)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    RegisterDynamic(stroke, "Color")
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local ExtLoadPosBtn = CreateExtButton("POS", LoadSavedPosition)
local ExtSizeBtn = CreateExtButton("SZ", function()
    currentExtSizeIndex = currentExtSizeIndex + 1
    if currentExtSizeIndex > #extSizes then
        currentExtSizeIndex = 1
    end
    UpdateExtLayout()
end)

-- Fungsi memperbarui tata letak & ukuran tombol eksternal
function UpdateExtLayout()
    local cfg = extSizes[currentExtSizeIndex]
    ExtButtonContainer.Size = UDim2.new(0, (cfg.spacing * 2), 0, cfg.btnSize)
    
    ExtLoadPosBtn.Size = UDim2.new(0, cfg.btnSize, 0, cfg.btnSize)
    ExtLoadPosBtn.Position = UDim2.new(0, 0, 0, 0)
    ExtLoadPosBtn.TextSize = cfg.fontSize
    
    ExtSizeBtn.Size = UDim2.new(0, cfg.btnSize, 0, cfg.btnSize)
    ExtSizeBtn.Position = UDim2.new(0, cfg.spacing, 0, 0)
    ExtSizeBtn.TextSize = cfg.fontSize
end

UpdateExtLayout()

-- ========================================================
-- [[ FLOATING TOGGLE ICON ]]
-- ========================================================
local FloatingToggle = Instance.new("TextButton", ScreenGui)
FloatingToggle.Name = "FloatingIconToggle"
FloatingToggle.Size = UDim2.new(0, 50, 0, 50)
FloatingToggle.Position = UDim2.new(0, 20, 0.25, 0)
FloatingToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
FloatingToggle.Text = "L"
FloatingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingToggle.Font = Enum.Font.GothamBlack
FloatingToggle.TextSize = 24
Instance.new("UICorner", FloatingToggle).CornerRadius = UDim.new(1, 0)

local FloatStroke = Instance.new("UIStroke", FloatingToggle)
FloatStroke.Thickness = 2
RegisterDynamic(FloatStroke, "Color")
MakeDraggable(FloatingToggle)

-- ========================================================
-- [[ MAIN UI PANEL FRAME ]]
-- ========================================================
local MainFrame = Instance.new("CanvasGroup", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 310)
MainFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.GroupTransparency = 1
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local PanelStroke = Instance.new("UIStroke", MainFrame)
PanelStroke.Thickness = 1.8
RegisterDynamic(PanelStroke, "Color")
MakeDraggable(MainFrame)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 24)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.65, 0, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LOUIS HUD PRO"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
RegisterDynamic(Title, "TextColor3")

local DragLockBtn = Instance.new("TextButton", Header)
DragLockBtn.Size = UDim2.new(0, 20, 0, 16)
DragLockBtn.Position = UDim2.new(1, -28, 0.5, -8)
DragLockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DragLockBtn.Text = "🔓"
DragLockBtn.TextColor3 = Color3.fromRGB(255,255,255)
DragLockBtn.Font = Enum.Font.GothamBold
DragLockBtn.TextSize = 10
Instance.new("UICorner", DragLockBtn).CornerRadius = UDim.new(0, 3)

local DragLockStroke = Instance.new("UIStroke", DragLockBtn)
DragLockStroke.Thickness = 1
DragLockStroke.Color = Color3.fromRGB(45, 45, 50)

DragLockBtn.MouseButton1Click:Connect(function()
    Settings.DragLocked = not Settings.DragLocked
    DragLockBtn.Text = Settings.DragLocked and "🔒" or "🔓"
end)

-- Tab Navigation Panel
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -12, 0, 20)
TabBar.Position = UDim2.new(0, 6, 0, 26)
TabBar.BackgroundTransparency = 1

local TabButtons = {}
local TabFrames = {}
local CurrentTab = "Combat"
local TabNames = {"Combat", "Utility"}
local TabWidth = 1 / #TabNames

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -52)
ContentFrame.Position = UDim2.new(0, 0, 0, 48)
ContentFrame.BackgroundTransparency = 1

local function CreateTabFrame(name)
    local f = Instance.new("ScrollingFrame", ContentFrame)
    f.Size = UDim2.new(1, -12, 1, -6)
    f.Position = UDim2.new(0, 6, 0, 2)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local layout = Instance.new("UIListLayout", f)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    TabFrames[name] = f
    return f
end

for _, name in ipairs(TabNames) do CreateTabFrame(name) end

local function ShowTab(tabName)
    CurrentTab = tabName
    for name, frame in pairs(TabFrames) do frame.Visible = (name == tabName) end
    for name, btn in pairs(TabButtons) do
        if name == tabName then
            RegisterDynamic(btn, "BackgroundColor3")
            btn.TextColor3 = Color3.new(0, 0, 0)
        else
            for i = #DynamicThemeElements, 1, -1 do
                local item = DynamicThemeElements[i]
                if item.Instance == btn and item.Property == "BackgroundColor3" then
                    table.remove(DynamicThemeElements, i)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            btn.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

for i, name in ipairs(TabNames) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(TabWidth, -1, 1, 0)
    btn.Position = UDim2.new((i - 1) * TabWidth, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = name:upper()
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 7.5
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    TabButtons[name] = btn
    
    local tabStroke = Instance.new("UIStroke", btn)
    tabStroke.Thickness = 1
    tabStroke.Color = Color3.fromRGB(45, 45, 50)
    
    btn.MouseButton1Click:Connect(function() ShowTab(name) end)
end

ShowTab("Combat")

-- Element Creation Helpers
local function CreateButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 20)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8.5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(45, 45, 50)
    s.Thickness = 1
    
    b.MouseButton1Click:Connect(callback)
    return b
end

local function CreateToggle(text, startState, callback)
    local btn = CreateButton(text .. ": " .. (startState and "ON" or "OFF"), function() end)
    local active = startState
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. ": " .. (active and "ON" or "OFF")
        SetToggleState(btn, active)
        callback(active)
    end)
    SetToggleState(btn, active)
    return btn
end

local function CreateSlider(textFormat, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local fill = Instance.new("Frame", frame)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
    RegisterDynamic(fill, "BackgroundColor3")
    
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 8
    textLabel.Font = Enum.Font.GothamBold
    textLabel.ZIndex = 3
    
    local sliderBtn = Instance.new("TextButton", frame)
    sliderBtn.Size = UDim2.new(1, 0, 1, 0)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 4
    
    local function sync(val)
        fill.Size = UDim2.new(math.clamp((val - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
        textLabel.Text = string.format(textFormat, val)
    end
    
    sync(defaultVal)
    
    local activeConn
    local function update()
        local pct = math.clamp((LocalPlayer:GetMouse().X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (pct * (maxVal - minVal)))
        sync(val)
        callback(val)
    end
    
    sliderBtn.MouseButton1Down:Connect(function()
        update()
        activeConn = SafeConnect(RunService.RenderStepped, update)
    end)
    
    SafeConnect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeConn then
                activeConn:Disconnect()
                activeConn = nil
            end
        end
    end)
    
    return frame
end

-- CreateGroupBox Dinamis dengan AutomaticSize untuk Menghindari Overlapping (Tumpuk)
local function CreateGroupBox(tabName, titleText)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -2, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = Color3.fromRGB(45, 45, 50)
    boxStroke.Thickness = 1
    
    local padding = Instance.new("UIPadding", box)
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    
    local list = Instance.new("UIListLayout", box)
    list.Padding = UDim.new(0, 6)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    
    local title = Instance.new("TextLabel", box)
    title.Size = UDim2.new(1, 0, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = titleText:upper()
    title.Font = Enum.Font.GothamBold
    title.TextSize = 8
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 0
    RegisterDynamic(title, "TextColor3")
    
    box.Parent = TabFrames[tabName]
    return box
end

-- ========================================================
-- [[ POPULATING TABS ]]
-- ========================================================

-- --- COMBAT TAB ---

-- 1. Fling Systems Group
local FlingGroupBox = CreateGroupBox("Combat", "Fling Settings")

local ToggleTouchFling = CreateToggle("TOUCH FLING", Settings.TouchFling, function(state)
    Settings.TouchFling = state
end)
ToggleTouchFling.Parent = FlingGroupBox
ToggleTouchFling.LayoutOrder = 1

local PowerSlider = CreateSlider("FLING POWER: %d", 1, 200, Settings.FlingPower, function(val)
    Settings.FlingPower = val
end)
PowerSlider.Parent = FlingGroupBox
PowerSlider.LayoutOrder = 2

local ToggleAntiFling = CreateToggle("ANTI FLING", Settings.AntiFling, function(state)
    Settings.AntiFling = state
end)
ToggleAntiFling.Parent = FlingGroupBox
ToggleAntiFling.LayoutOrder = 3


-- 2. Target Operations Group (Daftar Pemain)
local TargetGroupBox = CreateGroupBox("Combat", "Target Operations")

local SelectedTargetLabel = Instance.new("TextLabel")
SelectedTargetLabel.Size = UDim2.new(1, 0, 0, 14)
SelectedTargetLabel.BackgroundTransparency = 1
SelectedTargetLabel.Text = "SELECTED: NONE"
SelectedTargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedTargetLabel.Font = Enum.Font.GothamBold
SelectedTargetLabel.TextSize = 8
SelectedTargetLabel.Parent = TargetGroupBox
SelectedTargetLabel.LayoutOrder = 1

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(1, 0, 0, 80)
PlayerListScroll.BackgroundTransparency = 0.95
PlayerListScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PlayerListScroll.ScrollBarThickness = 2
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.Parent = TargetGroupBox
PlayerListScroll.LayoutOrder = 2
Instance.new("UICorner", PlayerListScroll).CornerRadius = UDim.new(0, 4)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = PlayerListScroll

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
end)

local PlayerButtons = {}
local function UpdatePlayerList()
    for _, btn in pairs(PlayerButtons) do
        btn:Destroy()
    end
    table.clear(PlayerButtons)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 18)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 7.5
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
            
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(45, 45, 50)
            stroke.Thickness = 1
            
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayerName = player.Name
                SelectedTargetLabel.Text = "SELECTED: " .. player.Name:upper()
                for _, pBtn in pairs(PlayerButtons) do
                    pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            end)
            
            btn.Parent = PlayerListScroll
            PlayerButtons[player.Name] = btn
        end
    end
end

UpdatePlayerList()
SafeConnect(Players.PlayerAdded, UpdatePlayerList)
SafeConnect(Players.PlayerRemoving, function(player)
    if Settings.SelectedPlayerName == player.Name then
        Settings.SelectedPlayerName = ""
        SelectedTargetLabel.Text = "SELECTED: NONE"
    end
    UpdatePlayerList()
end)

local FlingTargetBtn = CreateButton("FLING SELECTED PLAYER", function()
    local p = MatchPlayer(Settings.SelectedPlayerName)
    if p then FlingPlayer(p) end
end)
FlingTargetBtn.Parent = TargetGroupBox
FlingTargetBtn.LayoutOrder = 3

local TpTargetBtn = CreateButton("TELEPORT TO PLAYER", function()
    local p = MatchPlayer(Settings.SelectedPlayerName)
    if p then TpToPlayer(p) end
end)
TpTargetBtn.Parent = TargetGroupBox
TpTargetBtn.LayoutOrder = 4


-- 3. Positions Group
local TeleportsGroupBox = CreateGroupBox("Combat", "Teleports & Positions")

local SavePosBtn = CreateButton("SAVE POSITION", SavePosition)
SavePosBtn.Parent = TeleportsGroupBox
SavePosBtn.LayoutOrder = 1

local LoadPosBtn = CreateButton("LOAD POSITION", LoadSavedPosition)
LoadPosBtn.Parent = TeleportsGroupBox
LoadPosBtn.LayoutOrder = 2

local ToggleExtPos = CreateToggle("EXTERNAL POS BUTTON", Settings.ShowExtPos, function(state)
    Settings.ShowExtPos = state
    ExtButtonContainer.Visible = state
end)
ToggleExtPos.Parent = TeleportsGroupBox
ToggleExtPos.LayoutOrder = 3


-- --- UTILITY TAB ---

-- 1. Movement Utilities
local MoveUtilsGroupBox = CreateGroupBox("Utility", "Movement Utilities")

local ToggleInfJump = CreateToggle("INFINITE JUMP", Settings.InfiniteJump, function(state)
    Settings.InfiniteJump = state
end)
ToggleInfJump.Parent = MoveUtilsGroupBox
ToggleInfJump.LayoutOrder = 1

local ToggleAntiVoid = CreateToggle("ANTI VOID", Settings.AntiVoid, function(state)
    Settings.AntiVoid = state
end)
ToggleAntiVoid.Parent = MoveUtilsGroupBox
ToggleAntiVoid.LayoutOrder = 2


-- 2. Script Control Panel
local ScriptControlBox = CreateGroupBox("Utility", "Script Management")

local UnloadBtn = CreateButton("UNLOAD / DESTROY HUD", UnloadScript)
UnloadBtn.Parent = ScriptControlBox
UnloadBtn.LayoutOrder = 1

-- ========================================================
-- [[ OPEN / CLOSE HANDLERS (FADE IN/OUT TRANSITION) ]]
-- ========================================================
local MainVisible = false

FloatingToggle.MouseButton1Click:Connect(function()
    MainVisible = not MainVisible
    if MainVisible then
        MainFrame.Visible = true
        if Settings.ShowExtPos then
            ExtButtonContainer.Visible = true
        end
        
        MainFrame.Size = UDim2.new(0, 200, 0, 310)
        local tweenIn = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
        tweenIn:Play()
    else
        local tweenOut = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            if not MainVisible then
                MainFrame.Visible = false
                ExtButtonContainer.Visible = false
            end
        end)
    end
end)

print("Louis Lite GUI (v2.2.0) Loaded. Klik tombol 'L' untuk membuka menu.")
