local mainui = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui, MainFrame, ContentFrame, HUDMain, extButtons

function mainui.Initialize(require)
    local Settings = require("core/settings")
    local components = require("ui/components")
    local hud = require("ui/hud")
    local externalbuttons = require("ui/externalbuttons")
    local tabs = require("ui/tabs")
    local connections = require("core/connections")
    local draggable = require("utils/draggable")
    
    -- Inisialisasi Environment Pendukung
    require("combat/aimbot").Init(LocalPlayer)
    require("combat/killaura").Start(LocalPlayer)
    require("esp/esp").Start(LocalPlayer)
    require("movement/fly.lua").Start(LocalPlayer)
    require("movement/doublejump").Setup(LocalPlayer)
    require("movement/invisible").Start(LocalPlayer)

    ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "LouisHub_FREE_Edition"
    ScreenGui.ResetOnSpawn = false

    extButtons = externalbuttons.Create(ScreenGui)
    HUDMain = hud.Create(ScreenGui)

    -- Konfigurasi Tampilan Bingkai Utama
    MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 160, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -80, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(0, 180, 255)
    Stroke.Thickness = 1.5

    connections.SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        Stroke.Color = Color3.fromHSV(hue, 0.8, 1)
    end)

    local HubLabel = components.CreateLabel("LOUIS HUB FREE V13.5.2", UDim2.new(0, 6, 0, 4), UDim2.new(0, 95, 0, 12), MainFrame)
    HubLabel.TextSize = 6.5
    
    connections.SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        HubLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end)

    local LockDragBtn = components.CreateBtn("🔓", UDim2.new(0, 105, 0, 4), UDim2.new(0, 20, 0, 14), Color3.fromRGB(45, 45, 55))
    LockDragBtn.Parent = MainFrame
    LockDragBtn.TextSize = 10

    LockDragBtn.MouseButton1Click:Connect(function()
        Settings.DragLocked = not Settings.DragLocked
        LockDragBtn.Text = Settings.DragLocked and "🔒" or "🔓"
        LockDragBtn.TextColor3 = Settings.DragLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    end)

    local InfoBtn = components.CreateBtn("i", UDim2.new(0, 128, 0, 4), UDim2.new(0, 26, 0, 14), Color3.fromRGB(45, 45, 55))
    InfoBtn.Parent = MainFrame
    InfoBtn.TextSize = 8
    InfoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)

    -- Info Panel
    local InfoFrame = Instance.new("Frame", MainFrame)
    InfoFrame.Size = UDim2.new(1, -12, 0, 0)
    InfoFrame.Position = UDim2.new(0, 6, 0, 45)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.ClipsDescendants = true
    InfoFrame.Visible = false
    InfoFrame.ZIndex = 10
    Instance.new("UICorner", InfoFrame)
    local InfoStroke = Instance.new("UIStroke", InfoFrame)
    InfoStroke.Color = Color3.fromRGB(0, 180, 255)
    InfoStroke.Thickness = 1

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12)
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = color or Color3.new(1,1,1)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 7
        return l
    end
    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5), Color3.fromRGB(0, 180, 255))

    local function createSocialBtn(name, link, pos, color)
        local b = components.CreateBtn(name, pos, UDim2.new(1, -10, 0, 18), color)
        b.Parent = InfoFrame
        b.TextSize = 6
        b.ZIndex = 11
        b.MouseButton1Click:Connect(function()
            setclipboard(link)
            local oldText = b.Text
            b.Text = "COPIED!"
            task.wait(1.5)
            b.Text = oldText
        end)
    end
    createSocialBtn("DISCORD SERVER", "https://discord.gg/P2FEVBz2PG", UDim2.new(0, 5, 0, 25), Color3.fromRGB(88, 101, 242))
    createSocialBtn("TIKTOK: @louismurdermystery2", "https://www.tiktok.com/@louismurdermystery2", UDim2.new(0, 5, 0, 48), Color3.fromRGB(0, 0, 0))
    createSocialBtn("TIKTOK: @chillajakaliye_", "https://www.tiktok.com/@chillajakaliye_", UDim2.new(0, 5, 0, 71), Color3.fromRGB(0, 0, 0))

    local CloseInfo = components.CreateBtn("BACK TO MENU", UDim2.new(0, 5, 1, -22), UDim2.new(1, -10, 0, 18), Color3.fromRGB(40, 40, 45))
    CloseInfo.Parent = InfoFrame
    CloseInfo.ZIndex = 11

    local infoOpen = false
    InfoBtn.MouseButton1Click:Connect(function()
        infoOpen = not infoOpen
        if infoOpen then
            InfoFrame.Visible = true
            InfoFrame:TweenSize(UDim2.new(1, -12, 1, -55), "Out", "Quad", 0.3, true)
        else
            InfoFrame:TweenSize(UDim2.new(1, -12, 0, 0), "In", "Quad", 0.3, true, function() InfoFrame.Visible = false end)
        end
    end)
    CloseInfo.MouseButton1Click:Connect(function()
        infoOpen = false
        InfoFrame:TweenSize(UDim2.new(1, -12, 0, 0), "In", "Quad", 0.3, true, function() InfoFrame.Visible = false end)
    end)

    ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -62)
    ContentFrame.Position = UDim2.new(0, 0, 0, 42)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false

    -- Inisialisasi Navigasi Tab
    local TabFrames = tabs.CreateSystem(MainFrame, ContentFrame, {"Main", "Combat", "ESP", "Utility"})

    -- === KONTEN TAB 1: MAIN ===
    local WelcomeLabel = components.CreateLabel("Welcome to Louis Hub, " .. LocalPlayer.Name, UDim2.new(0,0,0,0), UDim2.new(1,-4,0,15), TabFrames["Main"])
    local InfoStatusLabel = components.CreateLabel("Status: ACTIVE\nPress 'L' button on left screen\nto hide/open this main UI window.", UDim2.new(0,0,0,0), UDim2.new(1,-4,0,25), TabFrames["Main"])
    InfoStatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)

    -- === KONTEN TAB 2: COMBAT ===
    local BoxKillPlayer = components.CreateGroupContainer(TabFrames["Combat"], "Kill Player", 64)
    local KillAuraToggleBtn = components.CreateBtn("KILL AURA: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxKillPlayer)
    components.CreateSlider(BoxKillPlayer, "KA RADIUS: %d STUDS", 1, 50, Settings.KillAuraRadius, function(val)
        Settings.KillAuraRadius = val
    end)
    local KillAllBtn = components.CreateBtn("KILL ALL PLAYER (TP ALL)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(180, 0, 0))
    KillAllBtn.Parent = BoxKillPlayer

    local BoxAim = components.CreateGroupContainer(TabFrames["Combat"], "Main Aim Mechanics", 64)
    local ToggleBtn = components.CreateBtn("[Q] AIMBOT: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxAim)
    local ExtAimbotToggleBtn = components.CreateBtn("AIMBOT (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxAim)
    components.CreateSlider(BoxAim, "BUTTON 'A' SIZE: %d", 20, 100, Settings.Size_A, function(val)
        Settings.Size_A = val
        extButtons.UpdateSizes()
    end)

    local BoxFOV = components.CreateGroupContainer(TabFrames["Combat"], "Field of View (FOV)", 82)
    local FOVHideBtn = components.CreateBtn("[P] HIDE FOV CIRCLE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFOV)
    components.CreateSlider(BoxFOV, "FOV: %d RAD", 1, 200, Settings.FOVSize, function(val)
        Settings.FOVSize = val
    end)
    local CamFOVToggleBtn = components.CreateBtn("CAMERA FOV MODIFIER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFOV)
    components.CreateSlider(BoxFOV, "CAM FOV: %d", 30, 120, Settings.CameraFOVValue, function(val)
        Settings.CameraFOVValue = val
    end)

    local BoxFling = components.CreateGroupContainer(TabFrames["Combat"], "Fling Glitch System", 46)
    local FlingSheriffBtn = components.CreateBtn("AUTO FLING SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFling)
    local FlingMurderBtn = components.CreateBtn("AUTO FLING MURDER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFling)

    local BoxGrab = components.CreateGroupContainer(TabFrames["Combat"], "Gun Grabber System", 64)
    local GrabBtn = components.CreateBtn("[H] AUTO GRAB GUN: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxGrab)
    local ManualGrabToggleBtn = components.CreateBtn("GRAB GUN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxGrab)
    components.CreateSlider(BoxGrab, "BUTTON 'G' SIZE: %d", 20, 100, Settings.Size_G, function(val)
        Settings.Size_G = val
        extButtons.UpdateSizes()
    end)

    local BoxDoubleJump = components.CreateGroupContainer(TabFrames["Combat"], "Double Jump System", 64)
    local DoubleJumpToggleBtn = components.CreateBtn("DOUBLE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxDoubleJump)
    local DoubleJumpExtToggleBtn = components.CreateBtn("DOUBLE JUMP (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxDoubleJump)
    components.CreateSlider(BoxDoubleJump, "BUTTON 'DJ' SIZE: %d", 20, 100, Settings.Size_DJ, function(val)
        Settings.Size_DJ = val
        extButtons.UpdateSizes()
    end)

    -- === KONTEN TAB 3: ESP ===
    local BoxESP = components.CreateGroupContainer(TabFrames["ESP"], "Visual & Hitbox Hack", 172)
    local EspBtn = components.CreateBtn("[X] ESP + GUN DROP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxESP)
    local TracersEspBtn = components.CreateBtn("TRACERS ESP LINE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxESP)
    local NameEspBtn = components.CreateBtn("NAME ESP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxESP)
    local FilterMurderBtn = components.CreateBtn("FILTER: MURDERER (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 180, 255))
    FilterMurderBtn.Parent = BoxESP
    FilterMurderBtn.TextColor3 = Color3.new(0,0,0)
    local FilterSheriffBtn = components.CreateBtn("FILTER: SHERIFF (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 180, 255))
    FilterSheriffBtn.Parent = BoxESP
    FilterSheriffBtn.TextColor3 = Color3.new(0,0,0)
    local FilterInnocentBtn = components.CreateBtn("FILTER: INNOCENT (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 180, 255))
    FilterInnocentBtn.Parent = BoxESP
    FilterInnocentBtn.TextColor3 = Color3.new(0,0,0)
    local HitboxBtn = components.CreateBtn("[C] HITBOX EXPANDER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxESP)
    local VisualBtn = components.CreateBtn("[V] HITBOX VISUAL: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 120, 200))
    VisualBtn.Parent = BoxESP
    components.CreateSlider(BoxESP, "SIZE: %d STUDS", 1, 200, Settings.HitboxSize, function(val)
        Settings.HitboxSize = val
    end)

    -- === KONTEN TAB 4: UTILITY ===
    local BoxSpeed = components.CreateGroupContainer(TabFrames["Utility"], "Walkspeed Modifier", 46)
    local SpeedWalkBtn = components.CreateBtn("SPEED WALK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxSpeed)
    components.CreateSlider(BoxSpeed, "SPEED: %d WS", 1, 100, Settings.SpeedWalkValue, function(val)
        Settings.SpeedWalkValue = val
    end)

    local BoxPlayerJump = components.CreateGroupContainer(TabFrames["Utility"], "Jump Power Modifier", 46)
    local JumpToggleBtn = components.CreateBtn("JUMP HEIGHT MOD: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxPlayerJump)
    components.CreateSlider(BoxPlayerJump, "JUMP POWER: %d", 50, 200, Settings.JumpPowerValue, function(val)
        Settings.JumpPowerValue = val
    end)

    local BoxFlyNoclip = components.CreateGroupContainer(TabFrames["Utility"], "No Clip & Fly Hack", 64)
    local FlyToggleBtn = components.CreateBtn("FLY HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFlyNoclip)
    components.CreateSlider(BoxFlyNoclip, "FLY SPEED: %d", 10, 150, Settings.FlySpeedValue, function(val)
        Settings.FlySpeedValue = val
    end)
    local NoclipToggleBtn = components.CreateBtn("NOCLIP (WALK THRU WALLS): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxFlyNoclip)

    local BoxInvisible = components.CreateGroupContainer(TabFrames["Utility"], "Invisibility", 28)
    local InvisibleToggleBtn = components.CreateBtn("INVISIBLE HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), BoxInvisible)

    local BoxUIControls = components.CreateGroupContainer(TabFrames["Utility"], "UI Button Settings", 28)
    components.CreateSlider(BoxUIControls, "BUTTON 'L' SIZE: %d", 20, 100, Settings.Size_L, function(val)
        Settings.Size_L = val
        extButtons.UpdateSizes()
    end)

    -- Kontrol buka-tutup bingkai menu
    local CloseBar = components.CreateBtn("▼ OPEN MENU ▼", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16), Color3.new(0,0,0))
    CloseBar.Parent = MainFrame
    CloseBar.BackgroundTransparency = 1
    CloseBar.TextSize = 6

    local isMinimized = true
    CloseBar.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        MainFrame:TweenSize(isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205), "Out", "Quad", 0.25, true)
        CloseBar.Text = isMinimized and "▼ OPEN MENU ▼" or "▲ CLOSE MENU ▲"
        task.wait(0.2)
        ContentFrame.Visible = not isMinimized
    end)

    -- === KONEKSI TRIGGER DAN EVENT ===
    local isMainVisible = false
    extButtons.ToggleBtnMain.MouseButton1Click:Connect(function()
        isMainVisible = not isMainVisible
        if isMainVisible then
            MainFrame.Visible = true
            HUDMain.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205)}):Play()
            if Settings.AimbotExtEnabled then extButtons.ExtAimbotBtn.Visible = true end
            if Settings.GrabGunExtEnabled then extButtons.ExtGrabBtn.Visible = true end
            if Settings.DoubleJumpExtEnabled then extButtons.ExtDoubleJumpBtn.Visible = true end
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 160, 0, 0)})
            t:Play()
            t.Completed:Connect(function() 
                if not isMainVisible then MainFrame.Visible = false end 
            end)
            HUDMain.Visible = false
            extButtons.ExtAimbotBtn.Visible = Settings.AimbotExtEnabled
            extButtons.ExtGrabBtn.Visible = Settings.GrabGunExtEnabled
            extButtons.ExtDoubleJumpBtn.Visible = Settings.DoubleJumpExtEnabled
        end
    end)

    -- Fungsi Sinkronisasi Visual
    local function syncAimbotVisual()
        ToggleBtn.Text = Settings.CameraAimbot and "[Q] AIMBOT: ON" or "[Q] AIMBOT: OFF"
        ToggleBtn.BackgroundColor3 = Settings.CameraAimbot and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtAimbotBtn.BackgroundColor3 = Settings.CameraAimbot and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(20, 20, 25)
        extButtons.ExtAimbotBtn.TextColor3 = Settings.CameraAimbot and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end

    local function toggleAimbot()
        Settings.CameraAimbot = not Settings.CameraAimbot
        syncAimbotVisual()
    end

    local function toggleEsp()
        Settings.ESP = not Settings.ESP
        EspBtn.Text = Settings.ESP and "[X] ESP + GUN DROP: ON" or "[X] ESP + GUN DROP: OFF"
        EspBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        if not Settings.ESP then require("esp/gunesp").Clear() end
    end

    local function toggleHitbox()
        Settings.HitboxExpander = not Settings.HitboxExpander
        HitboxBtn.Text = Settings.HitboxExpander and "[C] HITBOX EXPANDER: ON" or "[C] HITBOX EXPANDER: OFF"
        HitboxBtn.BackgroundColor3 = Settings.HitboxExpander and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAutoGrab()
        Settings.AutoGrabGun = not Settings.AutoGrabGun
        GrabBtn.Text = Settings.AutoGrabGun and "[H] AUTO GRAB GUN: ON" or "[H] AUTO GRAB GUN: OFF"
        GrabBtn.BackgroundColor3 = Settings.AutoGrabGun and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleHideFOV()
        Settings.HideFOVCircle = not Settings.HideFOVCircle
        FOVHideBtn.Text = Settings.HideFOVCircle and "[P] HIDE FOV CIRCLE: ON" or "[P] HIDE FOV CIRCLE: OFF"
        FOVHideBtn.BackgroundColor3 = Settings.HideFOVCircle and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end

    _G.SyncFlingButtons = function()
        FlingMurderBtn.Text = Settings.AutoFlingMurder and "FLING MURDER: ON" or "AUTO FLING MURDER"
        FlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 35)
        FlingSheriffBtn.Text = Settings.AutoFlingSheriff and "FLING SHERIFF: ON" or "AUTO FLING SHERIFF"
        FlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(30, 30, 35)
    end

    -- Event listener klik elemen menu
    KillAuraToggleBtn.MouseButton1Click:Connect(function()
        Settings.KillAuraEnabled = not Settings.KillAuraEnabled
        KillAuraToggleBtn.Text = Settings.KillAuraEnabled and "KILL AURA: ON" or "KILL AURA: OFF"
        KillAuraToggleBtn.BackgroundColor3 = Settings.KillAuraEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    KillAllBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then return end
        if require("systems/rolemanager").GetMM2Role(LocalPlayer) ~= "Murderer" then return end
        
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = p.Character.HumanoidRootPart
                local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health > 0 then
                    pcall(function() tRoot.CFrame = root.CFrame * CFrame.new(0, 0, -2) end)
                end
            end
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
    extButtons.ExtAimbotBtn.MouseButton1Click:Connect(toggleAimbot)
    
    ExtAimbotToggleBtn.MouseButton1Click:Connect(function()
        Settings.AimbotExtEnabled = not Settings.AimbotExtEnabled
        ExtAimbotToggleBtn.Text = Settings.AimbotExtEnabled and "AIMBOT (EXT): ON" or "AIMBOT (EXT): OFF"
        ExtAimbotToggleBtn.BackgroundColor3 = Settings.AimbotExtEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtAimbotBtn.Visible = Settings.AimbotExtEnabled
    end)

    EspBtn.MouseButton1Click:Connect(toggleEsp)

    TracersEspBtn.MouseButton1Click:Connect(function()
        Settings.TracersESP = not Settings.TracersESP
        TracersEspBtn.Text = Settings.TracersESP and "TRACERS ESP LINE: ON" or "TRACERS ESP LINE: OFF"
        TracersEspBtn.BackgroundColor3 = Settings.TracersESP and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    NameEspBtn.MouseButton1Click:Connect(function()
        Settings.NameESP = not Settings.NameESP
        NameEspBtn.Text = Settings.NameESP and "NAME ESP: ON" or "NAME ESP: OFF"
        NameEspBtn.BackgroundColor3 = Settings.NameESP and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    FilterMurderBtn.MouseButton1Click:Connect(function()
        Settings.EspMurderer = not Settings.EspMurderer
        FilterMurderBtn.Text = Settings.EspMurderer and "FILTER: MURDERER (ON)" or "FILTER: MURDERER (OFF)"
        FilterMurderBtn.BackgroundColor3 = Settings.EspMurderer and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        FilterMurderBtn.TextColor3 = Settings.EspMurderer and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)

    FilterSheriffBtn.MouseButton1Click:Connect(function()
        Settings.EspSheriff = not Settings.EspSheriff
        FilterSheriffBtn.Text = Settings.EspSheriff and "FILTER: SHERIFF (ON)" or "FILTER: SHERIFF (OFF)"
        FilterSheriffBtn.BackgroundColor3 = Settings.EspSheriff and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        FilterSheriffBtn.TextColor3 = Settings.EspSheriff and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)

    FilterInnocentBtn.MouseButton1Click:Connect(function()
        Settings.EspInnocent = not Settings.EspInnocent
        FilterInnocentBtn.Text = Settings.EspInnocent and "FILTER: INNOCENT (ON)" or "FILTER: INNOCENT (OFF)"
        FilterInnocentBtn.BackgroundColor3 = Settings.EspInnocent and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        FilterInnocentBtn.TextColor3 = Settings.EspInnocent and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)

    HitboxBtn.MouseButton1Click:Connect(toggleHitbox)

    VisualBtn.MouseButton1Click:Connect(function()
        Settings.HitboxVisual = not Settings.HitboxVisual
        VisualBtn.Text = Settings.HitboxVisual and "[V] HITBOX VISUAL: ON" or "[V] HITBOX VISUAL: OFF"
        VisualBtn.BackgroundColor3 = Settings.HitboxVisual and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 35)
    end)

    GrabBtn.MouseButton1Click:Connect(toggleAutoGrab)

    ManualGrabToggleBtn.MouseButton1Click:Connect(function()
        Settings.GrabGunExtEnabled = not Settings.GrabGunExtEnabled
        ManualGrabToggleBtn.Text = Settings.GrabGunExtEnabled and "GRAB GUN (EXT): ON" or "GRAB GUN (EXT): OFF"
        ManualGrabToggleBtn.BackgroundColor3 = Settings.GrabGunExtEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtGrabBtn.Visible = Settings.GrabGunExtEnabled
    end)

    local isGrabbing = false
    local function SafeInstantTween(targetPart)
        if not targetPart or isGrabbing then return end
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if root and humanoid and humanoid.Health > 0 then
            isGrabbing = true
            local originalCFrame = root.CFrame
            local targetCFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
            
            local noclipConnection = connections.SafeConnect(RunService.Stepped, function()
                if character then
                    for _, child in ipairs(character:GetDescendants()) do
                        if child:IsA("BasePart") then child.CanCollide = false end
                    end
                end
            end)
            
            root.CFrame = targetCFrame
            
            local timeout = 0
            while timeout < 1.5 do
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
                    break
                end
                root.CFrame = targetCFrame
                task.wait(0.05)
                timeout = timeout + 0.05
            end
            
            if character and character:FindFirstChild("HumanoidRootPart") then
                root.CFrame = originalCFrame
            end
            if noclipConnection then noclipConnection:Disconnect() end
            task.wait(0.3)
            isGrabbing = false
        end
    end

    extButtons.ExtGrabBtn.MouseButton1Click:Connect(function()
        local activeGun = require("systems/gungrab").Scan()
        if activeGun then SafeInstantTween(activeGun) end
    end)

    -- Auto Grab Gun Loop
    task.spawn(function()
        while true do
            if Settings.AutoGrabGun or Settings.ESP then
                local activeGun = require("systems/gungrab").Scan()
                if activeGun then
                    if Settings.ESP then require("esp/gunesp").Apply(activeGun) end
                    if Settings.AutoGrabGun then SafeInstantTween(activeGun) end
                end
            else
                require("esp/gunesp").Clear()
            end
            task.wait(0.2)
        end
    end)

    FOVHideBtn.MouseButton1Click:Connect(toggleHideFOV)

    CamFOVToggleBtn.MouseButton1Click:Connect(function()
        Settings.CameraFOVEnabled = not Settings.CameraFOVEnabled
        CamFOVToggleBtn.Text = Settings.CameraFOVEnabled and "CAMERA FOV MODIFIER: ON" or "CAMERA FOV MODIFIER: OFF"
        CamFOVToggleBtn.BackgroundColor3 = Settings.CameraFOVEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    FlingMurderBtn.MouseButton1Click:Connect(function()
        Settings.AutoFlingMurder = not Settings.AutoFlingMurder
        if Settings.AutoFlingMurder then Settings.AutoFlingSheriff = false end
        _G.SyncFlingButtons()
    end)

    FlingSheriffBtn.MouseButton1Click:Connect(function()
        Settings.AutoFlingSheriff = not Settings.AutoFlingSheriff
        if Settings.AutoFlingSheriff then Settings.AutoFlingMurder = false end
        _G.SyncFlingButtons()
    end)

    SpeedWalkBtn.MouseButton1Click:Connect(function()
        Settings.SpeedWalkEnabled = not Settings.SpeedWalkEnabled
        SpeedWalkBtn.Text = Settings.SpeedWalkEnabled and "SPEED WALK: ON" or "SPEED WALK: OFF"
        SpeedWalkBtn.BackgroundColor3 = Settings.SpeedWalkEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        if not Settings.SpeedWalkEnabled then pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end
    end)

    FlyToggleBtn.MouseButton1Click:Connect(function()
        Settings.FlyEnabled = not Settings.FlyEnabled
        FlyToggleBtn.Text = Settings.FlyEnabled and "FLY HACK: ON" or "FLY HACK: OFF"
        FlyToggleBtn.BackgroundColor3 = Settings.FlyEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    JumpToggleBtn.MouseButton1Click:Connect(function()
        Settings.JumpPowerEnabled = not Settings.JumpPowerEnabled
        JumpToggleBtn.Text = Settings.JumpPowerEnabled and "JUMP HEIGHT MOD: ON" or "JUMP HEIGHT MOD: OFF"
        JumpToggleBtn.BackgroundColor3 = Settings.JumpPowerEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    NoclipToggleBtn.MouseButton1Click:Connect(function()
        Settings.NoclipEnabled = not Settings.NoclipEnabled
        NoclipToggleBtn.Text = Settings.NoclipEnabled and "NOCLIP: ON" or "NOCLIP (WALK THRU WALLS): OFF"
        NoclipToggleBtn.BackgroundColor3 = Settings.NoclipEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
    end)

    InvisibleToggleBtn.MouseButton1Click:Connect(function()
        Settings.InvisibleEnabled = not Settings.InvisibleEnabled
        InvisibleToggleBtn.Text = Settings.InvisibleEnabled and "INVISIBLE HACK: ON" or "INVISIBLE HACK: OFF"
        InvisibleToggleBtn.BackgroundColor3 = Settings.InvisibleEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        
        if not Settings.InvisibleEnabled and LocalPlayer.Character then
            for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") then
                    if child.Name ~= "HumanoidRootPart" then child.Transparency = 0 end
                end
            end
        end
    end)

    DoubleJumpToggleBtn.MouseButton1Click:Connect(function()
        Settings.DoubleJumpEnabled = not Settings.DoubleJumpEnabled
        DoubleJumpToggleBtn.Text = Settings.DoubleJumpEnabled and "DOUBLE JUMP: ON" or "DOUBLE JUMP: OFF"
        DoubleJumpToggleBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtDoubleJumpBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(20, 20, 25)
        extButtons.ExtDoubleJumpBtn.TextColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end)

    DoubleJumpExtToggleBtn.MouseButton1Click:Connect(function()
        Settings.DoubleJumpExtEnabled = not Settings.DoubleJumpExtEnabled
        DoubleJumpExtToggleBtn.Text = Settings.DoubleJumpExtEnabled and "DOUBLE JUMP (EXT): ON" or "DOUBLE JUMP (EXT): OFF"
        DoubleJumpExtToggleBtn.BackgroundColor3 = Settings.DoubleJumpExtEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtDoubleJumpBtn.Visible = Settings.DoubleJumpExtEnabled
    end)

    extButtons.ExtDoubleJumpBtn.MouseButton1Click:Connect(function()
        Settings.DoubleJumpEnabled = not Settings.DoubleJumpEnabled
        DoubleJumpToggleBtn.Text = Settings.DoubleJumpEnabled and "DOUBLE JUMP: ON" or "DOUBLE JUMP: OFF"
        DoubleJumpToggleBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 35)
        extButtons.ExtDoubleJumpBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(20, 20, 25)
        extButtons.ExtDoubleJumpBtn.TextColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end)

    -- Event Keybind listener
    connections.SafeConnect(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.Q then toggleAimbot()
        elseif key == Enum.KeyCode.X then toggleEsp()
        elseif key == Enum.KeyCode.C then toggleHitbox()
        elseif key == Enum.KeyCode.H then toggleAutoGrab() 
        elseif key == Enum.KeyCode.P then toggleHideFOV()
        end
    end)

    -- Draggable MainFrame
    draggable.Make(MainFrame)
end

function mainui.Show()
    if extButtons and MainFrame and HUDMain then
        extButtons.ToggleBtnMain.Visible = true
        MainFrame.Visible = true
        HUDMain.Visible = true
        MainFrame.Size = UDim2.new(0, 160, 0, 58)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Out, Enum.EasingDirection.Quad), {Size = UDim2.new(0, 160, 0, 58)}):Play()
    end
end

return mainui