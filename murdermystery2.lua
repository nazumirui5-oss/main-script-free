-- [[ LOUIS HUB FREE - PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 13.5.2 (Security Sync Update - No Whitelist)

return function(AccessKey)
    -- [[ PROTEKSI 4: ANTI-TAMPER ]]
    local function IntegrityCheck()
        local test = tostring(game.HttpGet)
        if not test:find("function") or test:find("custom") or test:find("hook") then
            game.Players.LocalPlayer:Kick("LOUIS HUB: Security Violation (Hook Detected)")
            return false
        end
        return true
    end
    if not IntegrityCheck() then return end

    -- [[ PROTEKSI 3: KUNCI FUNGSI ]]
    if AccessKey ~= "LouisVIP_Secret_Key_9922" then 
        game.Players.LocalPlayer:Kick("LOUIS HUB: Bypass Detected (Key Error)")
        return 
    end

    -- [[ PROTEKSI 1: SESSION HANDSHAKE (Updated to genv) ]]
    local MyID = game.Players.LocalPlayer.UserId
    if not getgenv().LouisVerify or getgenv().LouisVerify() ~= "LouisVIP_Validated_" .. MyID then
        game.Players.LocalPlayer:Kick("LOUIS HUB: Illegal Execution (Handshake Failed)")
        return
    end

    -- ========================================================
    -- [[ ULTIMATE ANTI-DEBUG & SPY PROTECTOR + WEBHOOK ]]
    -- ========================================================
    local SecurityRunning = true
    local w1 = "https://discord.com/api/webhooks/"
    local w2 = "1499859204670750952/"
    local w3 = "333FbG7tb63jvKPPgD_zhHt7tn0cA1Y4T3-WLG16xQPY0uc-uozPcvnnSKS32dgzzt0P"
    local WebhookURL = w1 .. w2 .. w3

    local function SendSecurityAlert(toolName)
        local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if request then
            pcall(function()
                request({
                    Url = WebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode({
                        ["embeds"] = {{
                            ["title"] = "⚠️ SECURITY BREACH DETECTED!",
                            ["description"] = "A user tried to spy on Louis Hub FREE scripts.",
                            ["color"] = 0xFF0000,
                            ["fields"] = {
                                {["name"] = "👤 User", ["value"] = game.Players.LocalPlayer.Name, ["inline"] = true},
                                {["name"] = "🆔 ID", ["value"] = tostring(game.Players.LocalPlayer.UserId), ["inline"] = true},
                                {["name"] = "🔍 Detected Tool", ["value"] = toolName, ["inline"] = false},
                                {["name"] = "🛡️ Action", ["value"] = "Auto-Kick Executed", ["inline"] = true}
                            },
                            ["footer"] = {["text"] = "Louis Hub v13.5.2 | Anti-Tamper System"},
                            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                        }}
                    })
                })
            end)
        end
    end

    local function UltimateSecurity()
        local LP = game:GetService("Players").LocalPlayer
        local CoreGui = game:GetService("CoreGui")
        
        local BlacklistNames = {
            "SimpleSpy", "Hydroxide", "TurtleSpy", "RemoteSpy", "Explorer", 
            "Dex", "DarkDex", "Adonis", "V.G Hub Spy", "OwlHub Spy", 
            "Postman", "ScriptDumper", "SaveInstance", "RbxSpy"
        }

        local function ScanDeeper()
            for _, name in pairs(BlacklistNames) do
                if CoreGui:FindFirstChild(name) then return true, name end
            end
            for _, obj in pairs(CoreGui:GetChildren()) do
                if obj:IsA("ScreenGui") and not obj:IsA("PluginGui") then
                    local data = tostring(obj):lower()
                    if data:find("spy") or data:find("remote") or data:find("debug") then
                        return true, obj.Name
                    end
                end
            end
            return false
        end

        task.spawn(function()
            while SecurityRunning do
                local detected, toolFound = false, ""
                pcall(function() 
                    local found, name = ScanDeeper()
                    if found then 
                        detected = true 
                        toolFound = name
                    end 
                end)
                
                if detected then
                    SecurityRunning = false
                    SendSecurityAlert(toolFound)
                    task.wait(0.1)
                    LP:Kick("\n[LOUIS HUB SECURITY]\nUnauthorized Debugging Tool Detected: " .. toolFound)
                    break
                end
                task.wait(3)
            end
        end)
    end
    UltimateSecurity()

    -- ========================================================
    -- [[ KODE UTAMA LOUIS HUB FREE ]]
    -- ========================================================
    
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- ==========================================
    -- [[ NOTIFICATION SYSTEM ]]
    -- ==========================================
    local function NotifyPremium()
        local sg = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 200, 0, 40)
        f.Position = UDim2.new(0.5, -100, 0, -50)
        f.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Instance.new("UICorner", f)
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(1,1,1)
        t.Font = Enum.Font.GothamBold; t.TextSize = 12; t.Text = "THIS FEATURE IS FOR PREMIUM ONLY!"
        f:TweenPosition(UDim2.new(0.5, -100, 0, 50), "Out", "Back", 0.4)
        task.delay(2, function()
            f:TweenPosition(UDim2.new(0.5, -100, 0, -50), "In", "Back", 0.4, true, function() sg:Destroy() end)
        end)
    end

    -- ==========================================
    -- [[ 1. LOADING SCREEN ]]
    -- ==========================================
    local function startLoading()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        if playerGui:FindFirstChild("LouisFREE_Loading") then
            playerGui.LouisFREE_Loading:Destroy()
        end

        local loadingGui = Instance.new("ScreenGui", playerGui)
        loadingGui.Name = "LouisFREE_Loading"
        loadingGui.IgnoreGuiInset = true
        loadingGui.DisplayOrder = 999999

        local bg = Instance.new("Frame", loadingGui)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.3
        bg.BorderSizePixel = 0

        local profileFrame = Instance.new("Frame", bg)
        profileFrame.Size = UDim2.new(0, 250, 0, 70)
        profileFrame.Position = UDim2.new(0, 20, 1, -90)
        profileFrame.BackgroundTransparency = 1

        local profileImage = Instance.new("ImageLabel", profileFrame)
        profileImage.Size = UDim2.new(0, 55, 0, 55)
        profileImage.Position = UDim2.new(0, 0, 0.5, -27)
        profileImage.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        profileImage.BorderSizePixel = 0
        profileImage.ImageTransparency = 1 
        profileImage.BackgroundTransparency = 1
        
        task.spawn(function()
            local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            profileImage.Image = content
        end)
        
        Instance.new("UICorner", profileImage).CornerRadius = UDim.new(1, 0)
        local pStroke = Instance.new("UIStroke", profileImage)
        pStroke.Thickness = 2
        pStroke.Color = Color3.fromRGB(0, 180, 255)
        pStroke.Transparency = 1 

        local userInfo = Instance.new("TextLabel", profileFrame)
        userInfo.Size = UDim2.new(1, -65, 1, 0)
        userInfo.Position = UDim2.new(0, 65, 0, 0)
        userInfo.BackgroundTransparency = 1
        userInfo.Font = Enum.Font.GothamBold
        userInfo.TextColor3 = Color3.new(1, 1, 1)
        userInfo.TextSize = 12
        userInfo.TextXAlignment = Enum.TextXAlignment.Left
        userInfo.RichText = true
        userInfo.TextTransparency = 1 
        userInfo.Text = '<font color="rgb(200, 200, 200)">FREE MEMBER:</font>\n' .. LocalPlayer.Name:upper() .. '\n<font size="10" color="rgb(150, 150, 150)">ID: ' .. LocalPlayer.UserId .. '</font>'

        local title = Instance.new("TextLabel", bg)
        title.Size = UDim2.new(1, 0, 0.2, 0)
        title.Position = UDim2.new(0, 0, 0.3, 0)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 65
        title.RichText = true
        title.Text = 'LOUIS HUB <font color="rgb(255, 255, 255)">FREE</font>'
        title.TextColor3 = Color3.fromRGB(0, 180, 255)
        title.TextTransparency = 1

        local welcome = Instance.new("TextLabel", bg)
        welcome.Size = UDim2.new(1, 0, 0.1, 0)
        welcome.Position = UDim2.new(0, 0, 0.45, 0)
        welcome.BackgroundTransparency = 1
        welcome.Text = "WELCOME MY FREE MEMBERS"
        welcome.TextColor3 = Color3.new(1, 1, 1)
        welcome.TextSize = 22
        welcome.Font = Enum.Font.GothamMedium
        welcome.TextTransparency = 1

        local subTitle = Instance.new("TextLabel", bg)
        subTitle.Size = UDim2.new(1, 0, 0.1, 0)
        subTitle.Position = UDim2.new(0, 0, 0.45, 0)
        subTitle.BackgroundTransparency = 1
        subTitle.Text = "TIME BOMB DUELS SCRIPT"
        subTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        subTitle.TextSize = 24
        subTitle.Font = Enum.Font.GothamBold
        subTitle.TextTransparency = 1

        local barBg = Instance.new("Frame", bg)
        barBg.Size = UDim2.new(0.3, 0, 0.008, 0)
        barBg.Position = UDim2.new(0.35, 0, 0.62, 0)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", barBg)
        
        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", barFill)

        local skipBtn = Instance.new("TextButton", bg)
        skipBtn.Size = UDim2.new(0, 100, 0, 30)
        skipBtn.Position = UDim2.new(0.5, -50, 0.9, 0)
        skipBtn.BackgroundTransparency = 1
        skipBtn.Text = "SKIP"
        skipBtn.TextColor3 = Color3.new(1, 1, 1)
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.TextSize = 16
        skipBtn.ZIndex = 1000

        local introSound = Instance.new("Sound", bg)
        introSound.SoundId = "rbxassetid://131070686"
        introSound.Volume = 2

        local beepSound = Instance.new("Sound", bg)
        beepSound.SoundId = "rbxassetid://1567483853"
        beepSound.Volume = 0.6

        local function electricZapEffect()
            for i = 1, 3 do
                local zap = Instance.new("Frame", bg)
                zap.BackgroundColor3 = Color3.new(1, 1, 1)
                zap.BorderSizePixel = 0
                zap.Size = UDim2.new(0, math.random(50, 150), 0, 2)
                zap.Position = UDim2.new(0.5, math.random(-150, 150), 0.35, math.random(-40, 40))
                zap.Rotation = math.random(0, 360)
                task.spawn(function() task.wait(0.12); zap:Destroy() end)
            end
        end

        local skipTriggered = false
        local function forceExit()
            if skipTriggered then return end
            skipTriggered = true
            introSound:Stop()
            beepSound:Stop()
            local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(bg, fadeInfo, {BackgroundTransparency = 1}):Play()
            for _, obj in ipairs(bg:GetDescendants()) do
                pcall(function()
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        TweenService:Create(obj, fadeInfo, {TextTransparency = 1}):Play()
                    elseif obj:IsA("ImageLabel") then
                        TweenService:Create(obj, fadeInfo, {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                    elseif obj:IsA("Frame") then
                        TweenService:Create(obj, fadeInfo, {BackgroundTransparency = 1}):Play()
                    elseif obj:IsA("UIStroke") then
                        TweenService:Create(obj, fadeInfo, {Transparency = 1}):Play()
                    end
                end)
            end
            task.delay(0.45, function() loadingGui:Destroy() end)
        end

        skipBtn.MouseButton1Click:Connect(forceExit)
        introSound:Play()

        task.spawn(function()
            TweenService:Create(title, TweenInfo.new(1), {TextTransparency = 0}):Play()
            TweenService:Create(welcome, TweenInfo.new(1), {TextTransparency = 0}):Play()
            TweenService:Create(profileImage, TweenInfo.new(1), {ImageTransparency = 0, BackgroundTransparency = 0}):Play()
            TweenService:Create(pStroke, TweenInfo.new(1), {Transparency = 0}):Play()
            TweenService:Create(userInfo, TweenInfo.new(1), {TextTransparency = 0}):Play()
            task.wait(2.5)
            if skipTriggered then return end
            TweenService:Create(welcome, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
            task.wait(0.8)
            if skipTriggered then return end
            TweenService:Create(subTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            for i = 1, 6 do 
                if skipTriggered then break end
                local vis = not subTitle.Visible
                subTitle.Visible = vis
                title.Visible = vis
                if vis then electricZapEffect(); beepSound:Play() end
                task.wait(0.25)
            end
            if not skipTriggered then subTitle.Visible = true; title.Visible = true end
        end)

        barFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 7)
        local waitTime = 0
        while waitTime < 7.5 and not skipTriggered do
            waitTime = waitTime + 0.1
            task.wait(0.1)
        end
        if not skipTriggered then forceExit() end
    end

    startLoading()

    -- ==========================================
    -- [[ 2. CORE SETTINGS ]]
    -- ==========================================
    _G.MainColor = Color3.fromRGB(15, 15, 20)
    _G.AccentColor = Color3.fromRGB(0, 180, 255)
    _G.FollowEnabled = false
    _G.PredictEnabled = false 
    _G.HJEnabled = false 
    _G.FaceClassic = false 
    _G.FacePro = false 
    _G.FlickEnabled = false 
    _G.AutoJumpEnabled = false
    _G.WallWalkEnabled = false
    _G.WallHopDist = 2.5 
    _G.WHNormal = true 
    _G.WHInstant = false
    _G.PotatoEnabled = false

    local faceSpeed = 0.18
    local lockedTarget = nil 
    local lastHadBomb = false
    local retreatTimer = 0
    local targetMemory = 0 
    local bombTimer = 0 
    local isLocked = false
    local isMinimized = false -- FIX: Diubah ke false biar default awal kebuka full
    local hudMinimized = false
    local canWallJump = true

    local lastRaycastCheck = 0
    local lastTargetSearch = 0
    local raycastInterval = 0.1
    local searchInterval = 0.25
    local isVisibleCached = false
    local lastCameraRotation = Camera.CFrame
    local flickSensitivity = 0.45
    local isSticking = false

    -- ==========================================
    -- [[ 3. MAIN SCRIPT GUI ]]
    -- ==========================================
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "LouisHub_FREE_Edition"
    ScreenGui.ResetOnSpawn = false

    -- [[ FLOATING TOGGLE (L BUTTON) ]]
    local MainVisible = false
    local ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = _G.AccentColor
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    Instance.new("UICorner", ToggleBtnMain).CornerRadius = UDim.new(1, 0)
    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Color = _G.AccentColor
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Dragging Toggle Button
    local t_dragging, t_dragStart, t_startPos
    ToggleBtnMain.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then t_dragging = true; t_dragStart = i.Position; t_startPos = ToggleBtnMain.Position end end)
    UserInputService.InputChanged:Connect(function(i) if t_dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - t_dragStart; ToggleBtnMain.Position = UDim2.new(t_startPos.X.Scale, t_startPos.X.Offset + d.X, t_startPos.Y.Scale, t_startPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then t_dragging = false end end)

    -- [[ HUD ELEMENTS ]]
    local HUDMain = Instance.new("Frame", ScreenGui)
    HUDMain.Size = UDim2.new(0, 125, 0, 45)
    HUDMain.Position = UDim2.new(1, -140, 0.15, 0)
    HUDMain.BackgroundTransparency = 1
    HUDMain.Visible = false

    local HUDFrame = Instance.new("Frame", HUDMain)
    HUDFrame.Size = UDim2.new(1, -20, 1, 0)
    HUDFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    HUDFrame.BackgroundTransparency = 0.6
    HUDFrame.ClipsDescendants = true
    Instance.new("UICorner", HUDFrame).CornerRadius = UDim.new(0, 6)

    local FPSLabel = Instance.new("TextLabel", HUDFrame)
    FPSLabel.Size = UDim2.new(0, 60, 0.4, 0); FPSLabel.Position = UDim2.new(0, 5, 0, 4)
    FPSLabel.BackgroundTransparency = 1; FPSLabel.TextColor3 = Color3.new(1, 1, 1)
    FPSLabel.Font = Enum.Font.GothamBold; FPSLabel.TextSize = 9; FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PingLabel = Instance.new("TextLabel", HUDFrame)
    PingLabel.Size = UDim2.new(0, 60, 0.4, 0); PingLabel.Position = UDim2.new(0, 5, 0.4, 0)
    PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = _G.AccentColor
    PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 9; PingLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GraphFrame = Instance.new("Frame", HUDFrame)
    GraphFrame.Size = UDim2.new(0, 35, 0, 35); GraphFrame.Position = UDim2.new(1, -75, 0, 5); GraphFrame.BackgroundTransparency = 1

    local bars = {}
    for i = 1, 10 do
        local b = Instance.new("Frame", GraphFrame)
        b.Size = UDim2.new(0, 2, 0, 10); b.Position = UDim2.new(0, i*3, 1, -10)
        b.BackgroundColor3 = _G.AccentColor; b.BorderSizePixel = 0; bars[i] = b
    end

    local PotatoToggle = Instance.new("TextButton", HUDFrame)
    PotatoToggle.Size = UDim2.new(0, 30, 0, 25); PotatoToggle.Position = UDim2.new(1, -35, 0.5, -12.5)
    PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); PotatoToggle.Text = "🍃"; PotatoToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", PotatoToggle)
    local PotatoStroke = Instance.new("UIStroke", PotatoToggle)
    PotatoStroke.Color = Color3.fromRGB(100, 100, 100)
    PotatoStroke.Thickness = 1.5

    local HUDToggleBtn = Instance.new("TextButton", HUDMain)
    HUDToggleBtn.Size = UDim2.new(0, 15, 1, 0); HUDToggleBtn.Position = UDim2.new(1, -15, 0, 0)
    HUDToggleBtn.BackgroundColor3 = Color3.new(0,0,0); HUDToggleBtn.BackgroundTransparency = 0.8; HUDToggleBtn.Text = ">"
    HUDToggleBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", HUDToggleBtn)

    HUDToggleBtn.MouseButton1Click:Connect(function()
        hudMinimized = not hudMinimized
        HUDFrame:TweenSize(hudMinimized and UDim2.new(0, 0, 1, 0) or UDim2.new(1, -20, 1, 0), "Out", "Quad", 0.3, true)
        HUDToggleBtn.Text = hudMinimized and "<" or ">"
    end)

    -- [[ MAIN FRAME SETUP ]]
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 140, 0, 0) -- Mulai dari 0 untuk keperluan animasi buka pertama kali
    MainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
    MainFrame.BackgroundColor3 = _G.MainColor; MainFrame.Active = true; MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = _G.AccentColor; Stroke.Thickness = 1.5

    local function createBtn(txt, pos, size, color)
        local b = Instance.new("TextButton", MainFrame)
        b.Size = size; b.Position = pos; b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1)
        b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 6.5; b.ClipsDescendants = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); return b
    end

    local function createLabel(txt, pos, size)
        local l = Instance.new("TextLabel", MainFrame)
        l.Size = size or UDim2.new(0, 128, 0, 10); l.Position = pos
        l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.TextSize = 7; l.Font = Enum.Font.GothamBold; return l
    end

    local function createLine(pos)
        local l = Instance.new("Frame", MainFrame)
        l.Size = UDim2.new(0, 128, 0, 1); l.Position = pos
        l.BackgroundColor3 = Color3.fromRGB(45, 45, 55); l.BorderSizePixel = 0; return l
    end

    local HubLabel = createLabel("LOUIS HUB FREE V13.5.2", UDim2.new(0, 6, 0, 4), UDim2.new(0, 128, 0, 12))
    HubLabel.TextColor3 = _G.AccentColor; HubLabel.TextSize = 6.5

    local ToggleBtn = createBtn("[Q] AUTO: OFF", UDim2.new(0, 6, 0, 18), UDim2.new(0, 98, 0, 20))
    local LockBtn = createBtn("🔓", UDim2.new(0, 108, 0, 18), UDim2.new(0, 26, 0, 20))

    -- [[ MENU INFO & SOSMED ]]
    local InfoBtn = createBtn("i", UDim2.new(0, 108, 0, 4), UDim2.new(0, 26, 0, 12), Color3.fromRGB(45, 45, 55))
    InfoBtn.TextSize = 8
    InfoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)

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
    InfoStroke.Color = _G.AccentColor
    InfoStroke.Thickness = 1

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12); l.Position = pos; l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = color or Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 7; return l
    end

    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5), _G.AccentColor)

    local function createSocialBtn(name, link, pos, color)
        local b = createBtn(name, pos, UDim2.new(1, -10, 0, 18), color)
        b.Parent = InfoFrame; b.TextSize = 6; b.ZIndex = 11
        b.MouseButton1Click:Connect(function()
            setclipboard(link)
            local oldText = b.Text; b.Text = "COPIED TO CLIPBOARD!"; task.wait(1.5); b.Text = oldText
        end)
    end

    createSocialBtn("DISCORD SERVER", "https://discord.gg/sE7G9nGqb", UDim2.new(0, 5, 0, 25), Color3.fromRGB(88, 101, 242))
    createSocialBtn("TIKTOK: @louistimebombduels", "https://www.tiktok.com/@louistimebombduels", UDim2.new(0, 5, 0, 48), Color3.fromRGB(0, 0, 0))
    createSocialBtn("TIKTOK: @chillajakaliye_", "https://www.tiktok.com/@chillajakaliye_", UDim2.new(0, 5, 0, 71), Color3.fromRGB(0, 0, 0))

    local CloseInfo = createBtn("BACK TO MENU", UDim2.new(0, 5, 1, -22), UDim2.new(1, -10, 0, 18), Color3.fromRGB(40, 40, 45))
    CloseInfo.Parent = InfoFrame; CloseInfo.ZIndex = 11

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

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -45); ContentFrame.Position = UDim2.new(0, 0, 0, 45); ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = true -- FIX: Diubah ke true agar saat MainFrame membesar, isinya ga hilang

    -- [[ BUTTONS WITH PREMIUM TAGS ]]
    local ModeBtn = createBtn("[E] MODE: CLASSIC (PREMIUM)", UDim2.new(0, 6, 0, 0), UDim2.new(0, 128, 0, 20)); ModeBtn.Parent = ContentFrame
    local FlickBtn = createBtn("[Z] FLICK: OFF", UDim2.new(0, 6, 0, 25), UDim2.new(0, 62, 0, 20)); FlickBtn.Parent = ContentFrame
    local HJBtn = createBtn("[X] HJ: OFF (PREMIUM)", UDim2.new(0, 72, 0, 25), UDim2.new(0, 62, 0, 20)); HJBtn.Parent = ContentFrame
    local AutoJumpBtn = createBtn("[C] AUTO JUMP: OFF (PREMIUM)", UDim2.new(0, 6, 0, 50), UDim2.new(0, 128, 0, 20)); AutoJumpBtn.Parent = ContentFrame
    local WallWalkBtn = createBtn("[V] WALL WALK: OFF (PREMIUM)", UDim2.new(0, 6, 0, 75), UDim2.new(0, 128, 0, 20)); WallWalkBtn.Parent = ContentFrame

    createLine(UDim2.new(0, 6, 0, 100)).Parent = ContentFrame 
    createLabel("FACES MODE", UDim2.new(0, 6, 0, 106)).Parent = ContentFrame
    local ClassicBtn = createBtn("[G] CLASSIC: OFF (PREMIUM)", UDim2.new(0, 6, 0, 118), UDim2.new(0, 62, 0, 20)); ClassicBtn.Parent = ContentFrame
    local ProBtn = createBtn("[H] PRO: OFF (PREMIUM)", UDim2.new(0, 72, 0, 118), UDim2.new(0, 62, 0, 20)); ProBtn.Parent = ContentFrame

    createLine(UDim2.new(0, 6, 0, 144)).Parent = ContentFrame
    createLabel("WALLHOP MODE", UDim2.new(0, 6, 0, 150)).Parent = ContentFrame
    local WHNormalBtn = createBtn("NORMAL (PREMIUM)", UDim2.new(0, 6, 0, 162), UDim2.new(0, 62, 0, 20), _G.WHNormal and _G.AccentColor or nil); WHNormalBtn.Parent = ContentFrame
    local WHInstantBtn = createBtn("INSTANT (PREMIUM)", UDim2.new(0, 72, 0, 162), UDim2.new(0, 62, 0, 20)); WHInstantBtn.Parent = ContentFrame

    createLabel("WALLHOP DISTANCE (PREMIUM)", UDim2.new(0, 6, 0, 187)).Parent = ContentFrame
    local SliderFrame = Instance.new("Frame", ContentFrame); SliderFrame.Size = UDim2.new(0, 128, 0, 12); SliderFrame.Position = UDim2.new(0, 6, 0, 199); SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", SliderFrame)
    local SliderFill = Instance.new("Frame", SliderFrame); SliderFill.BackgroundColor3 = _G.AccentColor; Instance.new("UICorner", SliderFill)
    local SliderText = Instance.new("TextLabel", SliderFrame); SliderText.Size = UDim2.new(1, 0, 1, 0); SliderText.BackgroundTransparency = 1; SliderText.TextColor3 = Color3.new(1, 1, 1); SliderText.TextSize = 7; SliderText.Font = Enum.Font.GothamBold

    local CloseBar = createBtn("▲ CLOSE MENU ▲", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16), Color3.new(0,0,0))
    CloseBar.BackgroundTransparency = 1; CloseBar.TextSize = 6

    -- [[ FIX LOGIKA MINIMIZE & OPEN CONTROL ]]
    CloseBar.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame:TweenSize(UDim2.new(0, 140, 0, 58), "Out", "Quad", 0.25, true)
            CloseBar.Text = "▼ OPEN MENU ▼"
            ContentFrame.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, 140, 0, 280), "Out", "Quad", 0.25, true)
            CloseBar.Text = "▲ CLOSE MENU ▲"
            ContentFrame.Visible = true
        end
    end)

    ToggleBtnMain.MouseButton1Click:Connect(function()
        MainVisible = not MainVisible
        if MainVisible then
            MainFrame.Visible = true; HUDMain.Visible = true
            local targetSize = isMinimized and UDim2.new(0, 140, 0, 58) or UDim2.new(0, 140, 0, 280)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            TweenService:Create(ToggleBtnMain, TweenInfo.new(0.3), {BackgroundColor3 = _G.MainColor}):Play()
            ContentFrame.Visible = not isMinimized
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 140, 0, 0)})
            t:Play(); t.Completed:Connect(function() if not MainVisible then MainFrame.Visible = false end end)
            HUDMain.Visible = false
            TweenService:Create(ToggleBtnMain, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end
    end)

    -- ==========================================
    -- [[ 4. CORE ENGINE LOGIC ]]
    -- ==========================================
    local function hasBomb(p) 
        if not p.Character then return false end
        return p.Character:FindFirstChild("Bomb") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Bomb")) 
    end

    local function isAlive(p) 
        return p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and p.Character:FindFirstChild("HumanoidRootPart") 
    end

    local function isTeammate(p)
        if not p or not p.Character then return false end
        if p.Team ~= nil and p.Team == LocalPlayer.Team then return true end
        for _, v in pairs(p.Character:GetDescendants()) do 
            if v:IsA("Highlight") and (v.FillColor.G > 0.5 or v.OutlineColor.G > 0.5) then return true end 
        end
        return false
    end

    local function canSeePlayerSticky(p)
        if not p.Character or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
        local char = p.Character; local origin = LocalPlayer.Character.HumanoidRootPart.Position
        local params = RaycastParams.new(); params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local partsToCheck = {"Head", "HumanoidRootPart"}
        for _, partName in ipairs(partsToCheck) do
            local part = char:FindFirstChild(partName)
            if part then
                local direction = part.Position - origin
                local success, ray = pcall(function() return Workspace:Raycast(origin, direction, params) end)
                if success and (not ray or ray.Instance:IsDescendantOf(char)) then return true end
            end
        end
        return false
    end

    RunService.Heartbeat:Connect(function(dt)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = LocalPlayer.Character.HumanoidRootPart; local hum = LocalPlayer.Character.Humanoid
        local amIHolder = hasBomb(LocalPlayer)
        
        if hum.FloorMaterial == Enum.Material.Air and root.Velocity.Magnitude > 100 then root.Velocity = root.Velocity.Unit * 100 end
        if amIHolder then bombTimer += dt else bombTimer = 0 end

        if _G.WallWalkEnabled and hum.FloorMaterial == Enum.Material.Air then
            local currentRotation = Camera.CFrame; local deltaRot = (currentRotation.LookVector - lastCameraRotation.LookVector).Magnitude
            lastCameraRotation = currentRotation
            local params = RaycastParams.new(); params.FilterDescendantsInstances = {LocalPlayer.Character}
            local res = Workspace:Raycast(root.Position, root.CFrame.LookVector * 4, params)
            if res and deltaRot > flickSensitivity then isSticking = true end
            if isSticking and res then
                root.AssemblyLinearVelocity = Vector3.new(0, 0.15, 0)
                local wallNormal = res.Normal; local targetCF = CFrame.new(root.Position, root.Position - wallNormal)
                root.CFrame = targetCF * CFrame.Angles(0, math.sin(tick()*30)*0.1, 0)
            else isSticking = false end
        else isSticking = false end

        if tick() - lastRaycastCheck >= raycastInterval then
            if lockedTarget then isVisibleCached = canSeePlayerSticky(lockedTarget) end
            lastRaycastCheck = tick()
        end

        if not lastHadBomb and amIHolder then
            retreatTimer = 0; local minDist = 15; local tagger = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isAlive(p) then
                    local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < minDist then minDist = d; tagger = p end
                end
            end
            if tagger then lockedTarget = tagger; targetMemory = 2 end 
        end

        if lockedTarget and (not isAlive(lockedTarget) or isTeammate(lockedTarget) or (amIHolder and hasBomb(lockedTarget))) then lockedTarget = nil end
        if isVisibleCached then targetMemory = 1.2 elseif targetMemory > 0 then targetMemory -= dt end

        if tick() - lastTargetSearch >= searchInterval then
            local minDist = math.huge; local best = nil; local closestDist = math.huge; local closestPlayer = nil
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isAlive(p) and not isTeammate(p) then
                    local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < closestDist then closestDist = d; closestPlayer = p end
                    if (amIHolder and not hasBomb(p)) or (not amIHolder) then
                        if canSeePlayerSticky(p) then if d < minDist then minDist = d; best = p end end
                    end
                end
            end
            if closestPlayer and closestDist <= 7 then
                lockedTarget = closestPlayer; targetMemory = 1.2
            elseif not lockedTarget or (targetMemory <= 0 and not isVisibleCached) or (amIHolder and bombTimer > 7) then
                if best then lockedTarget = best; targetMemory = 1.2 end
            end
            lastTargetSearch = tick()
        end

        if lockedTarget and isAlive(lockedTarget) then
            local tRoot = lockedTarget.Character.HumanoidRootPart; local dist = (root.Position - tRoot.Position).Magnitude
            if amIHolder and dist <= 12 then hum.WalkSpeed = 25 else hum.WalkSpeed = 16 end
            if _G.FollowEnabled and retreatTimer <= 0 then 
                local targetPos = _G.PredictEnabled and (tRoot.Position + (tRoot.Velocity * 0.13)) or tRoot.Position
                hum:MoveTo(targetPos) 
            elseif _G.FollowEnabled then
                retreatTimer -= dt; hum:MoveTo(root.Position + (root.Position - tRoot.Position).Unit * 22)
            end
        else hum.WalkSpeed = 16 end

        if lastHadBomb and not amIHolder then 
            hum.WalkSpeed = 16; retreatTimer = _G.HJEnabled and 3.8 or 2.5
            if _G.HJEnabled then task.spawn(function() hum:ChangeState(3); task.wait(0.4); hum:ChangeState(3) end) end
        end

        if _G.FlickEnabled and amIHolder and isAlive(lockedTarget) and (root.Position - lockedTarget.Character.HumanoidRootPart.Position).Magnitude <= 4 then
            Camera.CFrame *= CFrame.Angles(math.rad(math.random(-25, 25)), math.rad(math.random(-45, 45)), 0)
        end

        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter and isAlive(lockedTarget) and (_G.FaceClassic or _G.FacePro) then
            hum.AutoRotate = false; local lookDir = amIHolder and Vector3.new(lockedTarget.Character.HumanoidRootPart.Position.X, root.Position.Y, lockedTarget.Character.HumanoidRootPart.Position.Z) or (root.Position + (root.Position - lockedTarget.Character.HumanoidRootPart.Position).Unit)
            root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position, lookDir), _G.FacePro and 0.3 or faceSpeed)
        else hum.AutoRotate = true end
        lastHadBomb = amIHolder
    end)

    local function handleAutoJump()
        if _G.AutoJumpEnabled and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            if LocalPlayer.Character and LocalPlayer.Character.Humanoid and LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then 
                LocalPlayer.Character.Humanoid.Jump = true 
            end
        end
    end
    UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(handleAutoJump)

    UserInputService.JumpRequest:Connect(function()
        isSticking = false 
        if not LocalPlayer.Character or not canWallJump then return end
        local hrp = LocalPlayer.Character.HumanoidRootPart; local params = RaycastParams.new(); params.FilterDescendantsInstances = {LocalPlayer.Character}
        if _G.WHInstant and Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * _G.WallHopDist, params) then
            -- Locked
        elseif _G.WHNormal then
            for i = 0, 7 do
                local dir = (hrp.CFrame * CFrame.Angles(0, math.rad(i*45), 0)).LookVector
                local r = Workspace:Raycast(hrp.Position, dir * _G.WallHopDist, params)
                if r and r.Instance.CanCollide then
                    if not _G.PremiumUser then break end
                end
            end
        end
    end)

    local function syncSlider(val)
        SliderFill.Size = UDim2.new(math.clamp((val - 1) / 9, 0, 1), 0, 1, 0); SliderText.Text = string.format("%.1f STUDS (PREMIUM)", val)
    end
    syncSlider(_G.WallHopDist)

    task.spawn(function()
        local lastTime = tick(); local frames = 0
        RunService.RenderStepped:Connect(function()
            frames += 1
            if tick() - lastTime >= 1 then
                FPSLabel.Text = "FPS: " .. frames; PingLabel.Text = "PING: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms"
                for i = 1, 9 do bars[i].Size = bars[i+1].Size; bars[i].Position = UDim2.new(0, i*3, 1, -bars[i].Size.Y.Offset) end
                local newH = math.clamp(frames/3, 5, 30); bars[10].Size = UDim2.new(0, 2, 0, newH); bars[10].Position = UDim2.new(0, 30, 1, -newH)
                frames = 0; lastTime = tick()
            end
        end)
    end)

    -- [[ BUTTON FUNCTIONALITIES ]]
    ToggleBtn.MouseButton1Click:Connect(function() 
        _G.FollowEnabled = not _G.FollowEnabled
        ToggleBtn.Text = _G.FollowEnabled and "[Q] AUTO: ON" or "[Q] AUTO: OFF"
        ToggleBtn.BackgroundColor3 = _G.FollowEnabled and _G.AccentColor or Color3.fromRGB(30, 30, 35) 
    end)

    FlickBtn.MouseButton1Click:Connect(function() 
        _G.FlickEnabled = not _G.FlickEnabled
        FlickBtn.Text = _G.FlickEnabled and "[Z] FLICK: ON" or "[Z] FLICK: OFF"
        FlickBtn.BackgroundColor3 = _G.FlickEnabled and _G.AccentColor or Color3.fromRGB(30, 30, 35) 
    end)

    -- PREMIUM TRIGGERS
    ModeBtn.MouseButton1Click:Connect(NotifyPremium)
    HJBtn.MouseButton1Click:Connect(NotifyPremium)
    AutoJumpBtn.MouseButton1Click:Connect(NotifyPremium)
    WallWalkBtn.MouseButton1Click:Connect(NotifyPremium)
    ClassicBtn.MouseButton1Click:Connect(NotifyPremium)
    ProBtn.MouseButton1Click:Connect(NotifyPremium)
    WHNormalBtn.MouseButton1Click:Connect(NotifyPremium)
    WHInstantBtn.MouseButton1Click:Connect(NotifyPremium)
    PotatoToggle.MouseButton1Click:Connect(NotifyPremium)

    LockBtn.MouseButton1Click:Connect(function() isLocked = not isLocked; LockBtn.Text = isLocked and "🔒" or "🔓" end)

    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            NotifyPremium()
        end
    end)

    -- [[ 5. KEYBIND SYSTEM ]]
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.Q then ToggleBtn:Activate()
        elseif key == Enum.KeyCode.Z then FlickBtn:Activate()
        elseif key == Enum.KeyCode.E or key == Enum.KeyCode.X or key == Enum.KeyCode.C or key == Enum.KeyCode.V or key == Enum.KeyCode.G or key == Enum.KeyCode.H or key == Enum.KeyCode.P then
            NotifyPremium()
        end
    end)

    -- Dragging MainFrame
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not isLocked then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    print("Louis Hub FREE V13.5.2: Initialized Successfully (Protection 2 Disabled).")
end

