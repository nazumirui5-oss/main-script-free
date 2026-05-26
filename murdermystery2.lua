-- [[ LOUIS HUB FREE - INTEGRATED & PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 13.5.2 (Security Sync Update - MM2 Edition)

return function(AccessKey)
    local Players = game:GetService("Players")
    
    -- ========================================================
    -- [[ MASALAH 4: INISIALISASI INSTAN PEMAIN LOKAL ]]
    -- ========================================================
    local LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer
    local MyID = LocalPlayer and LocalPlayer.UserId or (game.Players.LocalPlayer and game.Players.LocalPlayer.UserId)
    
    if not MyID then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer = Players.LocalPlayer
        MyID = LocalPlayer.UserId
    end

    -- ========================================================
    -- [[ PROTEKSI 1: SESSION HANDSHAKE ]]
    -- ========================================================
    if not getgenv().LouisVerify or getgenv().LouisVerify() ~= "LouisVIP_Validated_" .. MyID then
        if LocalPlayer then
            LocalPlayer:Kick("LOUIS HUB: Illegal Execution (Handshake Failed)")
        else
            game.Players.LocalPlayer:Kick("LOUIS HUB: Illegal Execution (Handshake Failed)")
        end
        return
    end

    -- [[ PROTEKSI 4: ANTI-TAMPER ]]
    local function IntegrityCheck()
        local test = tostring(game.HttpGet)
        if not test:find("function") or test:find("custom") or test:find("hook") then
            LocalPlayer:Kick("LOUIS HUB: Security Violation (Hook Detected)")
            return false
        end
        return true
    end
    if not IntegrityCheck() then return end

    -- [[ PROTEKSI 3: KUNCI FUNGSI ]]
    if AccessKey ~= "LouisVIP_Secret_Key_9922" then 
        LocalPlayer:Kick("LOUIS HUB: Bypass Detected (Key Error)")
        return 
    end

    -- ========================================================
    -- [[ MASALAH 1 & 2: RE-EXECUTION CLEANUP ENGINE ]]
    -- ========================================================
    local oldGui = (gethui and gethui():FindFirstChild("LouisHub_FREE_Edition")) or game:GetService("CoreGui"):FindFirstChild("LouisHub_FREE_Edition")
    if oldGui then oldGui:Destroy() end

    if _G.LouisConnections then
        for _, conn in pairs(_G.LouisConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
    end
    _G.LouisConnections = {}

    local function SafeConnect(signal, callback)
        local conn = signal:Connect(callback)
        table.insert(_G.LouisConnections, conn)
        return conn
    end

    if _G.LouisDrawings then
        for _, drawing in pairs(_G.LouisDrawings) do
            pcall(function() drawing:Remove() end)
        end
    end
    _G.LouisDrawings = {}

    local function SafeDrawing(className)
        local drawing = Drawing.new(className)
        table.insert(_G.LouisDrawings, drawing)
        return drawing
    end

    -- Cleanup Name ESP dari eksekusi sebelumnya
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                local billboard = head and head:FindFirstChild("MM2_NameESP")
                if billboard then billboard:Destroy() end
            end
        end)
    end

    -- ========================================================
    -- [[ ULTIMATE ANTI-DEBUG & SPY PROTECTOR + WEBHOOK ]]
    -- ========================================================
    _G.LouisSecurityRunning = false
    task.wait(0.1)
    _G.LouisSecurityRunning = true
    
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
                                {["name"] = "👤 User", ["value"] = LocalPlayer.Name, ["inline"] = true},
                                {["name"] = "🆔 ID", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
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
            while _G.LouisSecurityRunning do
                local detected, toolFound = false, ""
                pcall(function() 
                    local found, name = ScanDeeper()
                    if found then 
                        detected = true 
                        toolFound = name
                    end 
                end)
                
                if detected then
                    _G.LouisSecurityRunning = false
                    SendSecurityAlert(toolFound)
                    task.wait(0.1)
                    LocalPlayer:Kick("\n[LOUIS HUB SECURITY]\nUnauthorized Debugging Tool Detected: " .. toolFound)
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
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- Konfigurasi Fitur Internal (MM2)
    local Settings = {
        CameraAimbot = false,
        HitboxExpander = false,
        HitboxVisual = true,
        ESP = false,
        TracersESP = false,
        NameESP = false,
        EspInnocent = true,
        EspSheriff = true,
        EspMurderer = true,
        AutoGrabGun = false, 
        TargetPart = "HumanoidRootPart",
        HitboxSize = 20,
        FOVSize = 150,
        HideFOVCircle = false,
        AutoFlingMurder = false,
        AutoFlingSheriff = false,
        SpeedWalkEnabled = false,
        SpeedWalkValue = 16,
        AimbotExtEnabled = false,
        GrabGunExtEnabled = false,
        CameraFOVEnabled = false,
        CameraFOVValue = 70,
        FlyEnabled = false,
        FlySpeedValue = 50,
        JumpPowerEnabled = false,
        JumpPowerValue = 50,
        NoclipEnabled = false,
        InvisibleEnabled = false,
        KillAuraEnabled = false,
        KillAuraRadius = 15,
        DoubleJumpEnabled = false,
        DoubleJumpExtEnabled = false,
        DragLocked = false,
        
        -- FITUR BARU & UKURAN TOMBOL EKSTERNAL
        SpinEnabled = false,
        SpinExtEnabled = false,
        SpinSpeed = 50,
        TouchFling = false,
        TouchFlingPower = 100,
        AntiFling = false,
        InfiniteJumpEnabled = false,
        AntiVoid = false,
        PreFlingCFrame = nil,
        ShowExternalButtons = true,
        
        Size_L = 50,
        Size_A = 40,
        Size_G = 40,
        Size_DJ = 40,
        Size_Spin = 40,
        Size_TpSheriff = 40,
        Size_TpMurder = 40,
        Size_FlingMurder = 40,
        Size_FlingSheriff = 40,
        Size_Tplobby = 40,
        Size_TpUnderground = 40,
        Size_TpPreFling = 40,

        TpSheriffExtEnabled = false,
        TpMurderExtEnabled = false,
        TplobbyExtEnabled = false,
        TpUndergroundExtEnabled = false,
        TpPreFlingExtEnabled = false,
        FlingMurderExtEnabled = false,
        FlingSheriffExtEnabled = false
    }

    local OriginalFOV = Camera.FieldOfView

    -- ==========================================
    -- [[ POTATO GRAPHICS OPTIMIZATION ENGINE ]]
    -- ==========================================
    local function ApplyPotato()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 250
            Lighting.Brightness = 2
            local s = settings()
            s.Rendering.QualityLevel = 1
            s.Physics.AllowSleep = true
        end)
        task.defer(function()
            local function Clean(v)
                if not v:IsA("BasePart") and not v:IsA("MeshPart") then 
                    if v:IsA("Decal") or v:IsA("Texture") or v:IsA("Light") then v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
                    return 
                end
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
                v.Reflectance = 0
                if v:IsA("MeshPart") then v.TextureID = "" end
            end
            for _, v in ipairs(workspace:GetDescendants()) do pcall(Clean, v) end
        end)
    end

    local ToggleBtnMain, HUDMain, MainFrame, ContentFrame

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
        userInfo.Text = '<font color="rgb(200, 200, 200)">MEMBER:</font>\n' .. LocalPlayer.Name:upper() .. '\n<font size="10" color="rgb(150, 150, 150)">ID: ' .. LocalPlayer.UserId .. '</font>'

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
        welcome.Text = "WELCOME MY MEMBERS"
        welcome.TextColor3 = Color3.new(1, 1, 1)
        welcome.TextSize = 22
        welcome.Font = Enum.Font.GothamMedium
        welcome.TextTransparency = 1

        local subTitle = Instance.new("TextLabel", bg)
        subTitle.Size = UDim2.new(1, 0, 0.1, 0)
        subTitle.Position = UDim2.new(0, 0, 0.45, 0)
        subTitle.BackgroundTransparency = 1
        subTitle.Text = "MURDER MYSTERY 2" 
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
            task.delay(0.45, function() 
                loadingGui:Destroy() 
                if ToggleBtnMain and MainFrame and HUDMain then
                    ToggleBtnMain.Visible = true
                    MainFrame.Visible = true
                    HUDMain.Visible = true
                    MainFrame.Size = UDim2.new(0, 160, 0, 58)
                    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Out, Enum.EasingDirection.Quad), {Size = UDim2.new(0, 160, 0, 58)}):Play()
                    _G.UpdateExternalButtonsVisibility()
                end
            end)
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

    -- ========================================================================
    -- [[ DETEKSI JUMP & LOGIKA DOUBLE JUMP ENGINE ]]
    -- ========================================================================
    local HasDoubleJumped = false
    local CanDoubleJump = false

    local function SetupDoubleJump(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        
        local stateConn = humanoid.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Landed then
                HasDoubleJumped = false
                CanDoubleJump = false
            elseif new == Enum.HumanoidStateType.Freefall then
                task.wait(0.12)
                if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                    CanDoubleJump = true
                end
            end
        end)
        table.insert(_G.LouisConnections, stateConn)
    end

    if LocalPlayer.Character then
        pcall(SetupDoubleJump, LocalPlayer.Character)
    end
    SafeConnect(LocalPlayer.CharacterAdded, function(char)
        pcall(SetupDoubleJump, char)
    end)

    local DoubleJumpReq = UserInputService.JumpRequest:Connect(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and root and humanoid.Health > 0 and Settings.DoubleJumpEnabled then
            if CanDoubleJump and not HasDoubleJumped then
                HasDoubleJumped = true
                root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower * 1.15, root.Velocity.Z)
            end
        end
    end)
    table.insert(_G.LouisConnections, DoubleJumpReq)

    -- ========================================================================
    -- [[ INFINITE JUMP ENGINE ]]
    -- ========================================================================
    local InfiniteJumpConn = nil
    local function toggleInfiniteJump()
        Settings.InfiniteJumpEnabled = not Settings.InfiniteJumpEnabled
        if Settings.InfiniteJumpEnabled then
            InfiniteJumpConn = SafeConnect(UserInputService.JumpRequest, function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if InfiniteJumpConn then
                InfiniteJumpConn:Disconnect()
                InfiniteJumpConn = nil
            end
        end
    end

    -- ========================================================================
    -- [[ LOGIKA EMULASI TEKNIS AIMBOT & ROLE DETECTION (MM2) ]]
    -- ========================================================================
    local FOVCircle = SafeDrawing("Circle")
    FOVCircle.Color = Color3.fromRGB(255, 0, 255)
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 60
    FOVCircle.Radius = Settings.FOVSize
    FOVCircle.Filled = false
    FOVCircle.Visible = false

    SafeConnect(RunService.RenderStepped, function()
        if Settings.CameraAimbot and not Settings.HideFOVCircle then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            FOVCircle.Radius = Settings.FOVSize
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end
    end)

    local function GetMM2Role(Player)
        if not Player or not Player.Character then return "Innocent" end
        local Character = Player.Character
        local Backpack = Player:FindFirstChild("Backpack")
        
        if Character:FindFirstChild("Knife") or (Backpack and Backpack:FindFirstChild("Knife")) then
            return "Murderer"
        elseif Character:FindFirstChild("Gun") or (Backpack and Backpack:FindFirstChild("Gun")) then
            return "Sheriff"
        end
        return "Innocent"
    end

    local function GetTargetForMurderer()
        local Target = nil
        local ShortestDistance = math.huge
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Root = v.Character:FindFirstChild("HumanoidRootPart")
                local Hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if Root and Hum and Hum.Health > 0 then
                    local role = GetMM2Role(v)
                    if role == "Innocent" or role == "Sheriff" then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                        if OnScreen then
                            local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                            if Magnitude <= Settings.FOVSize and Magnitude < ShortestDistance then
                                ShortestDistance = Magnitude
                                Target = Root
                            end
                        end
                    end
                end
            end
        end
        return Target
    end

    local function GetTargetForInnocentOrSheriff()
        local Target = nil
        local ShortestDistance = math.huge
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Root = v.Character:FindFirstChild("HumanoidRootPart")
                local Hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if Root and Hum and Hum.Health > 0 then
                    local role = GetMM2Role(v)
                    if role == "Murderer" then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                        if OnScreen then
                            local Magnitude = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                            if Magnitude <= Settings.FOVSize and Magnitude < ShortestDistance then
                                ShortestDistance = Magnitude
                                Target = Root
                            end
                        end
                    end
                end
            end
        end
        return Target
    end

    local function GetPredictedPosition(targetPart)
        if not targetPart then return nil end
        
        local BulletSpeed = 230
        local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
        local travelTime = distance / BulletSpeed
        local ping = LocalPlayer:GetNetworkPing()
        local totalTime = travelTime + ping
        
        local velocity = targetPart.AssemblyLinearVelocity or targetPart.Velocity or Vector3.new()
        local predictedPos = targetPart.Position + (velocity * totalTime)
        return predictedPos
    end

    -- AIMBOT RENDER: Dipicu saat memegang "Gun" (Sheriff) atau "Knife" (Murderer) [TERMASUK DETEKSI BACKPACK]
    SafeConnect(RunService.RenderStepped, function()
        if Settings.CameraAimbot and LocalPlayer.Character then
            local HoldsGun = LocalPlayer.Character:FindFirstChild("Gun") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Gun"))
            local HoldsKnife = LocalPlayer.Character:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
            
            if (HoldsGun and LocalPlayer.Character:FindFirstChild("Gun")) or (HoldsKnife and LocalPlayer.Character:FindFirstChild("Knife")) then
                local MyRole = GetMM2Role(LocalPlayer)
                
                if MyRole == "Murderer" then
                    local TargetPart = GetTargetForMurderer()
                    if TargetPart then
                        local PredictedPos = GetPredictedPosition(TargetPart)
                        if PredictedPos then
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, PredictedPos)
                        end
                    end
                else
                    local TargetPart = GetTargetForInnocentOrSheriff()
                    if TargetPart then
                        local PredictedPos = GetPredictedPosition(TargetPart)
                        if PredictedPos then
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, PredictedPos)
                        end
                    end
                end
            end
        end
    end)

    -- ========================================================================
    -- [[ VELOCITY LIMITER ENGINE ]]
    -- ========================================================================
    SafeConnect(RunService.Heartbeat, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character.Humanoid
            if hum.FloorMaterial == Enum.Material.Air and root.Velocity.Magnitude > 100 and not Settings.AutoFlingMurder and not Settings.AutoFlingSheriff and not Settings.TouchFling then 
                root.Velocity = root.Velocity.Unit * 100 
            end
        end
    end)

    -- ========================================================================
    -- [[ NOCLIP & RETURN ENGINE ]]
    -- ========================================================================
    local IsGrabbing = false
    local function SafeInstantTween(targetPart)
        if not targetPart or IsGrabbing then return end
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if root and humanoid and humanoid.Health > 0 then
            IsGrabbing = true
            local originalCFrame = root.CFrame
            local targetCFrame = targetPart.CFrame + Vector3.new(0, 1.5, 0)
            
            local noclipConnection
            noclipConnection = SafeConnect(RunService.Stepped, function()
                if character then
                    for _, child in ipairs(character:GetDescendants()) do
                        if child:IsA("BasePart") then
                            child.CanCollide = false
                        end
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
            
            if noclipConnection then 
                noclipConnection:Disconnect() 
            end
            
            task.wait(0.3)
            IsGrabbing = false
        end
    end

    local function ScanForDroppedGun()
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object.Name == "GunDrop" then
                local targetPart = object:IsA("BasePart") and object or object:FindFirstChildOfClass("BasePart")
                if targetPart then return targetPart end
            end
        end
        
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object:IsA("TouchTransmitter") and object.Parent and object.Parent.Name:lower():find("gun") then
                local rootParent = object.Parent
                if not rootParent:FindFirstAncestorOfClass("Model") or not Players:GetPlayerFromCharacter(rootParent:FindFirstAncestorOfClass("Model")) then
                    return object.Parent
                end
            end
        end
        return nil
    end

    local function ApplyGunOutline(gunPart)
        if not gunPart or gunPart:FindFirstChild("LouisGunOutline") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "LouisGunOutline"
        highlight.FillColor = Color3.fromRGB(0, 100, 255)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = gunPart
        highlight.Parent = gunPart
    end

    local function ClearGunOutlines()
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object.Name == "LouisGunOutline" then
                object:Destroy()
            end
        end
    end

    task.spawn(function()
        while true do
            if Settings.AutoGrabGun or Settings.ESP then
                local activeGun = ScanForDroppedGun()
                if activeGun then
                    if Settings.ESP then
                        ApplyGunOutline(activeGun)
                    end
                    if Settings.AutoGrabGun then
                        SafeInstantTween(activeGun)
                    end
                end
            else
                ClearGunOutlines()
            end
            task.wait(0.2)
        end
    end)

    -- ========================================================================
    -- [[ PRO KILL AURA ENGINE (DIPERBAIKI SECARA PENUH - AUTO EQUIP) ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            task.wait(0.05)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if Settings.KillAuraEnabled and char and root then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local knife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
                
                if knife and GetMM2Role(LocalPlayer) == "Murderer" then
                    if knife.Parent == backpack then
                        pcall(function() char.Humanoid:EquipTool(knife) end)
                    end
                    
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local tRoot = p.Character.HumanoidRootPart
                            local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                            
                            if tHum and tHum.Health > 0 then
                                local distance = (root.Position - tRoot.Position).Magnitude
                                if distance <= Settings.KillAuraRadius then
                                    pcall(function()
                                        knife:Activate()
                                        firetouchinterest(tRoot, knife.Handle, 0)
                                        firetouchinterest(tRoot, knife.Handle, 1)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    local function TeleportAllPlayersToMe()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if not char or not root then return end
        if GetMM2Role(LocalPlayer) ~= "Murderer" then return end
        
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = p.Character.HumanoidRootPart
                local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                
                if tHum and tHum.Health > 0 then
                    pcall(function()
                        tRoot.CFrame = root.CFrame * CFrame.new(0, 0, -2)
                    end)
                end
            end
        end
    end

    -- ========================================================================
    -- [[ ANTI-FLING ENGINE ]]
    -- ========================================================================
    SafeConnect(RunService.Heartbeat, function()
        if Settings.AntiFling then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in ipairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- ========================================================================
    -- [[ SPIN ENGINE ]]
    -- ========================================================================
    local SpinVelocity = nil
    SafeConnect(RunService.Heartbeat, function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if Settings.SpinEnabled and root then
            if not SpinVelocity or SpinVelocity.Parent ~= root then
                if SpinVelocity then SpinVelocity:Destroy() end
                SpinVelocity = Instance.new("BodyAngularVelocity")
                SpinVelocity.Name = "LouisSpin"
                SpinVelocity.MaxTorque = Vector3.new(0, 9e9, 0)
                SpinVelocity.Parent = root
            end
            SpinVelocity.AngularVelocity = Vector3.new(0, Settings.SpinSpeed, 0)
        else
            if SpinVelocity then
                SpinVelocity:Destroy()
                SpinVelocity = nil
            end
        end
    end)

    -- ========================================================================
    -- [[ TOUCH FLING ENGINE ]]
    -- ========================================================================
    local TouchFlingVelocity = nil
    SafeConnect(RunService.Heartbeat, function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if Settings.TouchFling and root then
            root.CanCollide = false
            if not TouchFlingVelocity or TouchFlingVelocity.Parent ~= root then
                if TouchFlingVelocity then TouchFlingVelocity:Destroy() end
                TouchFlingVelocity = Instance.new("BodyAngularVelocity")
                TouchFlingVelocity.Name = "LouisTouchFling"
                TouchFlingVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                TouchFlingVelocity.Parent = root
            end
            TouchFlingVelocity.AngularVelocity = Vector3.new(0, Settings.TouchFlingPower * 10, 0)
            root.Velocity = Vector3.new(Settings.TouchFlingPower, 0, Settings.TouchFlingPower)
            task.wait()
            root.Velocity = Vector3.new(-Settings.TouchFlingPower, 0, -Settings.TouchFlingPower)
        else
            if TouchFlingVelocity then
                TouchFlingVelocity:Destroy()
                TouchFlingVelocity = nil
            end
        end
    end)

    -- ========================================================================
    -- [[ TELEPORTS & PRE-FLING LOCATIONS ]]
    -- ========================================================================
    local function SavePreFlingPosition()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            Settings.PreFlingCFrame = root.CFrame
        end
    end

    local function TeleportToPreFling()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and Settings.PreFlingCFrame then
            root.CFrame = Settings.PreFlingCFrame
        end
    end

    local function TeleportToLobby()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local lobbySpawn = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Spawn") or workspace:FindFirstChild("LobbySpawn")
            if lobbySpawn then
                root.CFrame = lobbySpawn.CFrame + Vector3.new(0, 3, 0)
            else
                root.CFrame = CFrame.new(-108.5, 140, 14.5)
            end
        end
    end

    local function TeleportUnderground()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(-108.5, 90, 14.5)
        end
    end

    local function TeleportToPlayerByRole(roleName)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and GetMM2Role(p) == roleName then
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        break
                    end
                end
            end
        end
    end

    -- ========================================================================
    -- [[ ANTI-VOID SYSTEM ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            if Settings.AntiVoid then
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root and root.Position.Y < -100 then
                        TeleportToLobby()
                    end
                end)
            end
            task.wait(0.5)
        end
    end)

    -- ========================================================================
    -- [[ CONSTRAINT-BASED FLY ENGINE & STATS MODIFIER ]]
    -- ========================================================================
    local FlingFailsafeActive = false
    local OriginalCFrameBeforeFling = nil
    
    local function GetTargetByRole(roleName)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and GetMM2Role(p) == roleName then
                    return p
                end
            end
        end
        return nil
    end

    SafeConnect(RunService.Heartbeat, function()
        local character = LocalPlayer.Character
        if Settings.InvisibleEnabled and character and character:FindFirstChild("HumanoidRootPart") then
            for _, child in ipairs(character:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") then
                    if child.Name ~= "HumanoidRootPart" then
                        child.Transparency = 1
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                if Settings.SpeedWalkEnabled then
                    humanoid.WalkSpeed = Settings.SpeedWalkValue
                end

                if Settings.JumpPowerEnabled then
                    humanoid.JumpPower = Settings.JumpPowerValue
                    humanoid.UseJumpPower = true
                else
                    humanoid.UseJumpPower = false
                end

                if Settings.NoclipEnabled or Settings.FlyEnabled then
                    for _, child in ipairs(character:GetDescendants()) do
                        if child:IsA("BasePart") then child.CanCollide = false end
                    end
                end

                if Settings.CameraFOVEnabled then
                    Camera.FieldOfView = Settings.CameraFOVValue
                else
                    Camera.FieldOfView = OriginalFOV
                end

                if Settings.FlyEnabled then
                    local attachment = root:FindFirstChild("LouisFlyAttachment") or Instance.new("Attachment")
                    if not attachment.Parent then
                        attachment.Name = "LouisFlyAttachment"
                        attachment.Parent = root
                    end

                    local lVelocity = root:FindFirstChild("LouisFlyVelocity") or Instance.new("LinearVelocity")
                    if not lVelocity.Parent then
                        lVelocity.Name = "LouisFlyVelocity"
                        lVelocity.Attachment0 = attachment
                        lVelocity.MaxForce = 9e9
                        lVelocity.Parent = root
                    end

                    local aOrientation = root:FindFirstChild("LouisFlyGyro") or Instance.new("AlignOrientation")
                    if not aOrientation.Parent then
                        aOrientation.Name = "LouisFlyGyro"
                        aOrientation.Attachment0 = attachment
                        aOrientation.Mode = Enum.OrientationMode.OneAttachment
                        aOrientation.MaxTorque = 9e9
                        aOrientation.Parent = root
                    end

                    aOrientation.CFrame = Camera.CFrame

                    local moveDirection = humanoid.MoveDirection
                    local flySpeed = Settings.FlySpeedValue
                    local velocityVector = moveDirection * flySpeed

                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocityVector = velocityVector + Vector3.new(0, flySpeed, 0)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        velocityVector = velocityVector + Vector3.new(0, -flySpeed, 0)
                    end
                    
                    lVelocity.VectorVelocity = velocityVector
                else
                    if root:FindFirstChild("LouisFlyAttachment") then root.LouisFlyAttachment:Destroy() end
                    if root:FindFirstChild("LouisFlyVelocity") then root.LouisFlyVelocity:Destroy() end
                    if root:FindFirstChild("LouisFlyGyro") then root.LouisFlyGyro:Destroy() end
                end

                if Settings.AutoFlingMurder or Settings.AutoFlingSheriff then
                    local targetRole = Settings.AutoFlingMurder and "Murderer" or "Sheriff"
                    local targetPlayer = GetTargetByRole(targetRole)

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if not FlingFailsafeActive then
                            FlingFailsafeActive = true
                            OriginalCFrameBeforeFling = root.CFrame
                        end

                        local tRoot = targetPlayer.Character.HumanoidRootPart
                        root.CFrame = tRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                        root.Velocity = Vector3.new(99999, 99999, 99999)
                        
                        for _, child in ipairs(character:GetDescendants()) do
                            if child:IsA("BasePart") then child.CanCollide = false end
                        end
                    else
                        if FlingFailsafeActive then
                            Settings.AutoFlingMurder = false
                            Settings.AutoFlingSheriff = false
                            root.Velocity = Vector3.new(0, 0, 0)
                            root.RotVelocity = Vector3.new(0, 0, 0)
                            task.wait(0.1)
                            if OriginalCFrameBeforeFling then
                                root.CFrame = OriginalCFrameBeforeFling
                            end
                            FlingFailsafeActive = false
                            OriginalCFrameBeforeFling = nil
                            
                            if _G.SyncFlingButtons then _G.SyncFlingButtons() end
                        end
                    end
                end
            end
            task.wait()
        end
    end)

    -- ========================================================================
    -- [[ DETEKSI NAME ESP ]]
    -- ========================================================================
    local function ApplyNameESP(player)
        if not player or not player.Character then return end
        local head = player.Character:FindFirstChild("Head")
        if not head then return end
        
        local billboard = head:FindFirstChild("MM2_NameESP")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "MM2_NameESP"
            billboard.Size = UDim2.new(0, 100, 0, 20)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            
            billboard.Parent = head
        end
        
        local role = GetMM2Role(player)
        local targetColor = Color3.fromRGB(0, 225, 0)
        if role == "Murderer" then 
            targetColor = Color3.fromRGB(255, 0, 0)
        elseif role == "Sheriff" then 
            targetColor = Color3.fromRGB(0, 0, 225) 
        end
        
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = player.Name .. " [" .. role .. "]"
            label.TextColor3 = targetColor
        end
        
        local shouldShow = false
        if Settings.ESP and Settings.NameESP then
            if role == "Murderer" and Settings.EspMurderer then
                shouldShow = true
            elseif role == "Sheriff" and Settings.EspSheriff then
                shouldShow = true
            elseif role == "Innocent" and Settings.EspInnocent then
                shouldShow = true
            end
        end
        
        billboard.Enabled = shouldShow
    end

    local function ClearNameESP(player)
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            local billboard = head and head:FindFirstChild("MM2_NameESP")
            if billboard then billboard:Destroy() end
        end
    end

    -- ========================================================================
    -- LOOPING RENDER: HITBOX EXPANDER, ESP OUTLINE & TRACERS SYSTEM (DENGAN FILTER)
    -- ========================================================================
    local ActiveTracers = {}

    local function ClearAllTracers()
        for _, tracer in pairs(ActiveTracers) do
            tracer.Visible = false
            tracer:Remove()
        end
        ActiveTracers = {}
    end

    SafeConnect(RunService.RenderStepped, function()
        if not Settings.TracersESP then
            ClearAllTracers()
        end

        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Root = Player.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                
                if Root and Humanoid and Humanoid.Health > 0 then
                    local Role = GetMM2Role(Player)
                    
                    -- Pengecekan Filter ESP
                    local passesFilter = false
                    if Role == "Murderer" and Settings.EspMurderer then
                        passesFilter = true
                    elseif Role == "Sheriff" and Settings.EspSheriff then
                        passesFilter = true
                    elseif Role == "Innocent" and Settings.EspInnocent then
                        passesFilter = true
                    end
                    
                    if Settings.HitboxExpander then
                        Root.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                        if not IsGrabbing and not FlingFailsafeActive then Root.CanCollide = false end
                        if Settings.HitboxVisual then
                            Root.Transparency = 0.7
                            Root.Color = Color3.fromRGB(255, 0, 0)
                            Root.Material = Enum.Material.SmoothPlastic
                        else
                            Root.Transparency = 1
                        end
                    else
                        Root.Size = Vector3.new(2, 2, 1)
                        Root.Transparency = 1
                        if not IsGrabbing and not FlingFailsafeActive then Root.CanCollide = true end
                    end

                    local TargetColor = Color3.fromRGB(0, 225, 0)
                    if Role == "Murderer" then TargetColor = Color3.fromRGB(255, 0, 0)
                    elseif Role == "Sheriff" then TargetColor = Color3.fromRGB(0, 0, 225) end

                    -- Outline ESP
                    local Highlight = Player.Character:FindFirstChild("MM2_ESP")
                    if Settings.ESP and passesFilter then
                        if not Highlight then
                            Highlight = Instance.new("Highlight")
                            Highlight.Name = "MM2_ESP"
                            Highlight.Parent = Player.Character
                            Highlight.FillTransparency = 0.6
                            Highlight.OutlineTransparency = 0.1
                        end
                        Highlight.FillColor = TargetColor
                        Highlight.OutlineColor = TargetColor
                    else
                        if Highlight then Highlight:Destroy() end
                    end

                    -- Name ESP
                    if Settings.ESP and Settings.NameESP and passesFilter then
                        ApplyNameESP(Player)
                    else
                        ClearNameESP(Player)
                    end

                    -- Tracers ESP
                    if Settings.TracersESP and passesFilter then
                        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                        if OnScreen then
                            local Tracer = ActiveTracers[Player.Name]
                            if not Tracer then
                                Tracer = SafeDrawing("Line")
                                Tracer.Thickness = 1.5
                                Tracer.Transparency = 0.8
                                ActiveTracers[Player.Name] = Tracer
                            end
                            Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            Tracer.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
                            Tracer.Color = TargetColor
                            Tracer.Visible = true
                        else
                            if ActiveTracers[Player.Name] then ActiveTracers[Player.Name].Visible = false end
                        end
                    else
                        if ActiveTracers[Player.Name] then
                            ActiveTracers[Player.Name].Visible = false
                            ActiveTracers[Player.Name]:Remove()
                            ActiveTracers[Player.Name] = nil
                        end
                    end
                end
            else
                if Player.Character then
                    if Player.Character:FindFirstChild("MM2_ESP") then
                        Player.Character:FindFirstChild("MM2_ESP"):Destroy()
                    end
                    ClearNameESP(Player)
                end
                if ActiveTracers[Player.Name] then
                    ActiveTracers[Player.Name].Visible = false
                    ActiveTracers[Player.Name]:Remove()
                    ActiveTracers[Player.Name] = nil
                end
            end
        end
    end)

    -- ==========================================
    -- [[ 2. CORE SETTINGS FOR UI THEME ]]
    -- ==========================================
    local _GMainColor = Color3.fromRGB(15, 15, 20)
    local _GAccentColor = Color3.fromRGB(0, 180, 255)
    local isMinimized = true
    local MainVisible = false
    local hudMinimized = false

    -- ==========================================
    -- [[ 3. MAIN SCRIPT GUI & HUD STRUCT ]]
    -- ==========================================
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "LouisHub_FREE_Edition"
    ScreenGui.ResetOnSpawn = false

    -- HELPER: Penerapan warna neon bergerak (Rainbow) pada stroke
    local function ApplyExternalButtonStyle(btn, stroke)
        btn.BackgroundTransparency = 0.6
        SafeConnect(RunService.RenderStepped, function()
            local hue = (tick() % 4) / 4
            stroke.Color = Color3.fromHSV(hue, 0.8, 1)
        end)
    end

    -- HELPER: Mengatur sistem drag tombol dengan pengecekan status kunci dari UI
    local function MakeDraggable(button)
        local dragging, dragStart, startPos
        SafeConnect(button.InputBegan, function(i) 
            if not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then 
                dragging = true
                dragStart = i.Position
                startPos = button.Position 
            end 
        end)
        SafeConnect(UserInputService.InputChanged, function(i) 
            if dragging and not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
                local d = i.Position - dragStart
                button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) 
            end 
        end)
        SafeConnect(UserInputService.InputEnded, function(i) 
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = false 
            end 
        end)
    end

    -- [[ TOMBOL UTAMA L (Floating Toggle Menu) ]]
    ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.4, -25)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = _GAccentColor
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    ToggleBtnMain.Visible = false 

    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    ApplyExternalButtonStyle(ToggleBtnMain, ToggleStroke)
    MakeDraggable(ToggleBtnMain)

    -- HELPER: Pembuat Tombol Eksternal Baru Secara Dinamis & Serasi
    local function CreateExternalButton(name, text, defaultOffset, defaultSize)
        local btn = Instance.new("TextButton", ScreenGui)
        btn.Name = name
        btn.Size = UDim2.new(0, defaultSize, 0, defaultSize)
        btn.Position = UDim2.new(0, 20, 0.4, defaultOffset)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.Visible = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 1.5
        ApplyExternalButtonStyle(btn, stroke)
        MakeDraggable(btn)
        return btn
    end

    -- INISIALISASI SEMUA TOMBOL EKSTERNAL DENGAN POSISI DINAMIS
    local ExtAimbotBtn = CreateExternalButton("ExtAimbot", "A", 35, Settings.Size_A)
    local ExtGrabBtn = CreateExternalButton("ExtGrabGun", "G", 85, Settings.Size_G)
    local ExtDoubleJumpBtn = CreateExternalButton("ExtDoubleJump", "DJ", 135, Settings.Size_DJ)
    local ExtSpinBtn = CreateExternalButton("ExtSpin", "🌀", 185, Settings.Size_Spin)
    local ExtTpSheriffBtn = CreateExternalButton("ExtTpSheriff", "👮", 235, Settings.Size_TpSheriff)
    local ExtTpMurderBtn = CreateExternalButton("ExtTpMurder", "🔪", 285, Settings.Size_TpMurder)
    local ExtFlingMurderBtn = CreateExternalButton("ExtFlingMurder", "☄️", 335, Settings.Size_FlingMurder)
    local ExtFlingSheriffBtn = CreateExternalButton("ExtFlingSheriff", "🌟", 385, Settings.Size_FlingSheriff)
    local ExtTpLobbyBtn = CreateExternalButton("ExtTpLobby", "🏡", 435, Settings.Size_Tplobby)
    local ExtTpUndergroundBtn = CreateExternalButton("ExtTpUnderground", "🕳️", 485, Settings.Size_TpUnderground)
    local ExtTpPreFlingBtn = CreateExternalButton("ExtTpPreFling", "⏮️", 535, Settings.Size_TpPreFling)

    -- PROSEDUR UTAMA: Sinkronisasi Tampilan Semua Tombol Eksternal Berdasarkan Pengaturan
    _G.UpdateExternalButtonsVisibility = function()
        local showExt = Settings.ShowExternalButtons
        
        ExtAimbotBtn.Visible = showExt and Settings.AimbotExtEnabled
        ExtGrabBtn.Visible = showExt and Settings.GrabGunExtEnabled
        ExtDoubleJumpBtn.Visible = showExt and Settings.DoubleJumpExtEnabled
        ExtSpinBtn.Visible = showExt and Settings.SpinExtEnabled
        ExtTpSheriffBtn.Visible = showExt and Settings.TpSheriffExtEnabled
        ExtTpMurderBtn.Visible = showExt and Settings.TpMurderExtEnabled
        ExtFlingMurderBtn.Visible = showExt and Settings.FlingMurderExtEnabled
        ExtFlingSheriffBtn.Visible = showExt and Settings.FlingSheriffExtEnabled
        ExtTpLobbyBtn.Visible = showExt and Settings.TplobbyExtEnabled
        ExtTpUndergroundBtn.Visible = showExt and Settings.TpUndergroundExtEnabled
        ExtTpPreFlingBtn.Visible = showExt and Settings.TpPreFlingExtEnabled
    end

    local function updateExternalButtonSizes()
        ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
        ExtAimbotBtn.Size = UDim2.new(0, Settings.Size_A, 0, Settings.Size_A)
        ExtGrabBtn.Size = UDim2.new(0, Settings.Size_G, 0, Settings.Size_G)
        ExtDoubleJumpBtn.Size = UDim2.new(0, Settings.Size_DJ, 0, Settings.Size_DJ)
        ExtSpinBtn.Size = UDim2.new(0, Settings.Size_Spin, 0, Settings.Size_Spin)
        ExtTpSheriffBtn.Size = UDim2.new(0, Settings.Size_TpSheriff, 0, Settings.Size_TpSheriff)
        ExtTpMurderBtn.Size = UDim2.new(0, Settings.Size_TpMurder, 0, Settings.Size_TpMurder)
        ExtFlingMurderBtn.Size = UDim2.new(0, Settings.Size_FlingMurder, 0, Settings.Size_FlingMurder)
        ExtFlingSheriffBtn.Size = UDim2.new(0, Settings.Size_FlingSheriff, 0, Settings.Size_FlingSheriff)
        ExtTpLobbyBtn.Size = UDim2.new(0, Settings.Size_Tplobby, 0, Settings.Size_Tplobby)
        ExtTpUndergroundBtn.Size = UDim2.new(0, Settings.Size_TpUnderground, 0, Settings.Size_TpUnderground)
        ExtTpPreFlingBtn.Size = UDim2.new(0, Settings.Size_TpPreFling, 0, Settings.Size_TpPreFling)
    end

    -- [[ HUD ELEMENTS ]]
    HUDMain = Instance.new("Frame", ScreenGui)
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
    PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = _GAccentColor
    PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 9; PingLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GraphFrame = Instance.new("Frame", HUDFrame)
    GraphFrame.Size = UDim2.new(0, 35, 0, 35); GraphFrame.Position = UDim2.new(1, -75, 0, 5); GraphFrame.BackgroundTransparency = 1

    local bars = {}
    for i = 1, 10 do
        local b = Instance.new("Frame", GraphFrame)
        b.Size = UDim2.new(0, 2, 0, 10); b.Position = UDim2.new(0, i*3, 1, -10)
        b.BackgroundColor3 = _GAccentColor; b.BorderSizePixel = 0; bars[i] = b
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

    -- [[ MAIN FRAME SETUP WITH TABS SYSTEM ]]
    MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 160, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -80, 0.2, 0)
    MainFrame.BackgroundColor3 = _GMainColor; MainFrame.Active = true; MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = _GAccentColor; Stroke.Thickness = 1.5

    -- INTEGRASI WARNA UI PELANGI SEPERTI TOMBOL EKSTERNAL
    SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
        Stroke.Color = rainbowColor
    end)

    local function createBtn(txt, pos, size, color)
        local b = Instance.new("TextButton")
        b.Size = size; b.Position = pos; b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1)
        b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 6.5; b.ClipsDescendants = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); return b
    end

    local function createLabel(txt, pos, size)
        local l = Instance.new("TextLabel", MainFrame)
        l.Size = size or UDim2.new(0, 148, 0, 10); l.Position = pos
        l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.TextSize = 7; l.Font = Enum.Font.GothamBold; return l
    end

    local HubLabel = createLabel("LOUIS HUB FREE V13.5.2", UDim2.new(0, 6, 0, 4), UDim2.new(0, 95, 0, 12))
    HubLabel.TextSize = 6.5
    
    SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        HubLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end)

    local LockDragBtn = createBtn("🔓", UDim2.new(0, 105, 0, 4), UDim2.new(0, 20, 0, 14), Color3.fromRGB(45, 45, 55))
    LockDragBtn.Parent = MainFrame; LockDragBtn.TextSize = 10; LockDragBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local function toggleLockDrag()
        Settings.DragLocked = not Settings.DragLocked
        LockDragBtn.Text = Settings.DragLocked and "🔒" or "🔓"
        LockDragBtn.TextColor3 = Settings.DragLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    end
    LockDragBtn.MouseButton1Click:Connect(toggleLockDrag)

    local InfoBtn = createBtn("i", UDim2.new(0, 128, 0, 4), UDim2.new(0, 26, 0, 14), Color3.fromRGB(45, 45, 55))
    InfoBtn.Parent = MainFrame; InfoBtn.TextSize = 8; InfoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)

    -- [[ SOSMED / INFO PANEL ]]
    local InfoFrame = Instance.new("Frame", MainFrame)
    InfoFrame.Size = UDim2.new(1, -12, 0, 0); InfoFrame.Position = UDim2.new(0, 6, 0, 45)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); InfoFrame.BorderSizePixel = 0
    InfoFrame.ClipsDescendants = true; InfoFrame.Visible = false; InfoFrame.ZIndex = 10
    Instance.new("UICorner", InfoFrame)
    local InfoStroke = Instance.new("UIStroke", InfoFrame); InfoStroke.Color = _GAccentColor; InfoStroke.Thickness = 1

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12); l.Position = pos; l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = color or Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 7; return l
    end
    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5), _GAccentColor)

    local function createSocialBtn(name, link, pos, color)
        local b = createBtn(name, pos, UDim2.new(1, -10, 0, 18), color)
        b.Parent = InfoFrame; b.TextSize = 6; b.ZIndex = 11
        b.MouseButton1Click:Connect(function()
            setclipboard(link)
            local oldText = b.Text; b.Text = "COPIED!"; task.wait(1.5); b.Text = oldText
        end)
    end
    createSocialBtn("DISCORD SERVER", "https://discord.gg/P2FEVBz2PG", UDim2.new(0, 5, 0, 25), Color3.fromRGB(88, 101, 242))
    createSocialBtn("TIKTOK: @louismurdermystery2", "https://www.tiktok.com/@louismurdermystery2", UDim2.new(0, 5, 0, 48), Color3.fromRGB(0, 0, 0))
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

    -- [[ SISTEM INTEGRASI NAVIGASI TAB ]]
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, -12, 0, 18); TabBar.Position = UDim2.new(0, 6, 0, 21)
    TabBar.BackgroundTransparency = 1

    local TabButtons = {}
    local TabFrames = {}
    local CurrentTab = "Main"

    local TabNames = {"Main", "Combat", "ESP", "Utility"}
    local TabWidth = 1 / #TabNames

    ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -62); ContentFrame.Position = UDim2.new(0, 0, 0, 42)
    ContentFrame.BackgroundTransparency = 1; ContentFrame.Visible = false

    local function CreateTabFrame(name)
        local f = Instance.new("ScrollingFrame", ContentFrame)
        f.Size = UDim2.new(1, -12, 1, 0); f.Position = UDim2.new(0, 6, 0, 0)
        f.BackgroundTransparency = 1; f.ScrollBarThickness = 2; f.Visible = false
        f.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local layout = Instance.new("UIListLayout", f)
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
        end)
        
        TabFrames[name] = f
        return f
    end

    for _, name in ipairs(TabNames) do CreateTabFrame(name) end

    local function ShowTab(tabName)
        CurrentTab = tabName
        for name, frame in pairs(TabFrames) do frame.Visible = (name == tabName) end
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = (name == tabName) and _GAccentColor or Color3.fromRGB(25, 25, 30)
            btn.TextColor3 = (name == tabName) and Color3.new(0,0,0) or Color3.new(1,1,1)
        end
    end

    for i, name in ipairs(TabNames) do
        local btn = Instance.new("TextButton", TabBar)
        btn.Size = UDim2.new(TabWidth, -1, 1, 0)
        btn.Position = UDim2.new((i-1)*TabWidth, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Text = name:upper()
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 5.2
        btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        TabButtons[name] = btn
        
        btn.MouseButton1Click:Connect(function() ShowTab(name) end)
    end
    ShowTab("Main")

    -- ==========================================
    -- [[ PEMASANGAN FITUR PADA MASING-MASING TAB ]]
    -- ==========================================
    local elementCounter = 0
    local function addTabElement(tab, obj)
        elementCounter = elementCounter + 1
        obj.LayoutOrder = elementCounter
        obj.Parent = TabFrames[tab]
    end

    local function createGroupContainer(tab, titleText, boxHeight)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -4, 0, boxHeight)
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)
        
        local stroke = Instance.new("UIStroke", container)
        stroke.Color = Color3.fromRGB(45, 45, 50)
        stroke.Thickness = 1
        
        local title = Instance.new("TextLabel", container)
        title.Size = UDim2.new(1, -10, 0, 12)
        title.Position = UDim2.new(0, 6, 0, 2)
        title.BackgroundTransparency = 1
        title.Text = titleText:upper()
        title.TextColor3 = _GAccentColor
        title.Font = Enum.Font.GothamBold
        title.TextSize = 5.5
        title.TextXAlignment = Enum.TextXAlignment.Left

        local list = Instance.new("UIListLayout", container)
        list.Padding = UDim.new(0, 4)
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.SortOrder = Enum.SortOrder.LayoutOrder
        
        addTabElement(tab, container)
        return container
    end

    local function createSlider(parent, textFormat, minVal, maxVal, defaultVal, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, 12)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Instance.new("UICorner", sliderFrame)
        
        local sliderFill = Instance.new("Frame", sliderFrame)
        sliderFill.BackgroundColor3 = _GAccentColor
        Instance.new("UICorner", sliderFill)
        
        local sliderText = Instance.new("TextLabel", sliderFrame)
        sliderText.Size = UDim2.new(1, 0, 1, 0)
        sliderText.BackgroundTransparency = 1
        sliderText.TextColor3 = Color3.new(1, 1, 1)
        sliderText.TextSize = 6.5
        sliderText.Font = Enum.Font.GothamBold
        sliderText.ZIndex = 3
        
        local sliderButton = Instance.new("TextButton", sliderFrame)
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.ZIndex = 4
        
        local function syncVal(val)
            sliderFill.Size = UDim2.new(math.clamp((val - minVal) / (maxVal - minVal), 0, 1), 0, 1, 0)
            sliderText.Text = string.format(textFormat, val)
        end
        
        syncVal(defaultVal)
        
        local connection
        local function update()
            local pct = math.clamp((Mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + (pct * (maxVal - minVal)))
            syncVal(val)
            callback(val)
        end
        
        sliderButton.MouseButton1Down:Connect(function()
            update()
            connection = SafeConnect(RunService.RenderStepped, update)
        end)
        
        SafeConnect(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end)
        
        sliderFrame.Parent = parent
        return sliderFrame
    end

    -- --- TAB 1: MAIN ---
    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Size = UDim2.new(1, -4, 0, 15)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome to Louis Hub, " .. LocalPlayer.Name
    WelcomeLabel.TextColor3 = Color3.new(1,1,1); WelcomeLabel.Font = Enum.Font.GothamMedium; WelcomeLabel.TextSize = 7
    addTabElement("Main", WelcomeLabel)

    local InfoStatusLabel = Instance.new("TextLabel")
    InfoStatusLabel.Size = UDim2.new(1, -4, 0, 25)
    InfoStatusLabel.BackgroundTransparency = 1
    InfoStatusLabel.Text = "Status: ACTIVE\nPress 'L' button on left screen\nto hide/open this main UI window."
    InfoStatusLabel.TextColor3 = Color3.fromRGB(150,255,150); InfoStatusLabel.Font = Enum.Font.Gotham; InfoStatusLabel.TextSize = 6.5
    addTabElement("Main", InfoStatusLabel)


    -- --- TAB 2: COMBAT ---
    
    -- BOX 1: KILL PLAYER (Murderer Only)
    local BoxKillPlayer = createGroupContainer("Combat", "Kill Player", 64)
    local KillAuraToggleBtn = createBtn("KILL AURA: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    KillAuraToggleBtn.Parent = BoxKillPlayer; KillAuraToggleBtn.LayoutOrder = 1

    createSlider(BoxKillPlayer, "KA RADIUS: %d STUDS", 1, 50, Settings.KillAuraRadius, function(val)
        Settings.KillAuraRadius = val
    end)

    local KillAllBtn = createBtn("KILL ALL PLAYER (TP ALL)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(180, 0, 0))
    KillAllBtn.Parent = BoxKillPlayer; KillAllBtn.LayoutOrder = 3


    -- BOX 2: AIM UTAMA
    local BoxAim = createGroupContainer("Combat", "Aim Assist (Gun & Knife)", 46)
    local ToggleBtn = createBtn("[Q] AIMBOT: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ToggleBtn.Parent = BoxAim; ToggleBtn.LayoutOrder = 1
    
    local ExtAimbotToggleBtn = createBtn("AIMBOT (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtAimbotToggleBtn.Parent = BoxAim; ExtAimbotToggleBtn.LayoutOrder = 2


    -- BOX 3: FIELD OF VIEW (FOV)
    local BoxFOV = createGroupContainer("Combat", "Field of View (FOV)", 82)
    local FOVHideBtn = createBtn("[P] HIDE FOV CIRCLE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FOVHideBtn.Parent = BoxFOV; FOVHideBtn.LayoutOrder = 1
    
    createSlider(BoxFOV, "FOV: %d RAD", 1, 200, Settings.FOVSize, function(val)
        Settings.FOVSize = val
    end)

    local CamFOVToggleBtn = createBtn("CAMERA FOV MODIFIER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    CamFOVToggleBtn.Parent = BoxFOV; CamFOVToggleBtn.LayoutOrder = 3

    createSlider(BoxFOV, "CAM FOV: %d", 30, 120, Settings.CameraFOVValue, function(val)
        Settings.CameraFOVValue = val
    end)


    -- BOX 4: FLING SYSTEM
    local BoxFling = createGroupContainer("Combat", "Fling Glitch System", 82)
    local FlingSheriffBtn = createBtn("AUTO FLING SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingSheriffBtn.Parent = BoxFling; FlingSheriffBtn.LayoutOrder = 1
    
    local FlingMurderBtn = createBtn("AUTO FLING MURDER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingMurderBtn.Parent = BoxFling; FlingMurderBtn.LayoutOrder = 2

    local FlingMurderExtToggleBtn = createBtn("FLING MURDER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingMurderExtToggleBtn.Parent = BoxFling; FlingMurderExtToggleBtn.LayoutOrder = 3

    local FlingSheriffExtToggleBtn = createBtn("FLING SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingSheriffExtToggleBtn.Parent = BoxFling; FlingSheriffExtToggleBtn.LayoutOrder = 4


    -- BOX 5: SPIN & TOUCH FLING
    local BoxSpinTouch = createGroupContainer("Combat", "Spin & Touch Fling", 120)
    local SpinToggleBtn = createBtn("SPIN: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpinToggleBtn.Parent = BoxSpinTouch; SpinToggleBtn.LayoutOrder = 1

    local SpinExtToggleBtn = createBtn("SPIN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpinExtToggleBtn.Parent = BoxSpinTouch; SpinExtToggleBtn.LayoutOrder = 2

    createSlider(BoxSpinTouch, "SPIN POWER: %d", 1, 150, Settings.SpinSpeed, function(val)
        Settings.SpinSpeed = val
    end)

    local TouchFlingToggleBtn = createBtn("TOUCH FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TouchFlingToggleBtn.Parent = BoxSpinTouch; TouchFlingToggleBtn.LayoutOrder = 4

    createSlider(BoxSpinTouch, "TOUCH FLING POWER: %d", 1, 200, Settings.TouchFlingPower, function(val)
        Settings.TouchFlingPower = val
    end)

    local AntiFlingToggleBtn = createBtn("ANTI FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiFlingToggleBtn.Parent = BoxSpinTouch; AntiFlingToggleBtn.LayoutOrder = 6


    -- BOX 6: GRAB GUN SYSTEM
    local BoxGrab = createGroupContainer("Combat", "Gun Grabber System", 46)
    local GrabBtn = createBtn("[H] AUTO GRAB GUN: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    GrabBtn.Parent = BoxGrab; GrabBtn.LayoutOrder = 1
    
    local ManualGrabToggleBtn = createBtn("GRAB GUN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ManualGrabToggleBtn.Parent = BoxGrab; ManualGrabToggleBtn.LayoutOrder = 2


    -- --- TAB 3: ESP ---
    local BoxESP = createGroupContainer("ESP", "Visual & Hitbox Hack", 172)
    local EspBtn = createBtn("[X] ESP + GUN DROP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    EspBtn.Parent = BoxESP; EspBtn.LayoutOrder = 1

    local TracersEspBtn = createBtn("TRACERS ESP LINE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TracersEspBtn.Parent = BoxESP; TracersEspBtn.LayoutOrder = 2

    local NameEspBtn = createBtn("NAME ESP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NameEspBtn.Parent = BoxESP; NameEspBtn.LayoutOrder = 3

    local FilterMurderBtn = createBtn("FILTER: MURDERER (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), _GAccentColor)
    FilterMurderBtn.Parent = BoxESP; FilterMurderBtn.TextColor3 = Color3.new(0,0,0); FilterMurderBtn.LayoutOrder = 4

    local FilterSheriffBtn = createBtn("FILTER: SHERIFF (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), _GAccentColor)
    FilterSheriffBtn.Parent = BoxESP; FilterSheriffBtn.TextColor3 = Color3.new(0,0,0); FilterSheriffBtn.LayoutOrder = 5

    local FilterInnocentBtn = createBtn("FILTER: INNOCENT (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), _GAccentColor)
    FilterInnocentBtn.Parent = BoxESP; FilterInnocentBtn.TextColor3 = Color3.new(0,0,0); FilterInnocentBtn.LayoutOrder = 6
    
    local HitboxBtn = createBtn("[C] HITBOX EXPANDER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    HitboxBtn.Parent = BoxESP; HitboxBtn.LayoutOrder = 7
    
    local VisualBtn = createBtn("[V] HITBOX VISUAL: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 120, 200))
    VisualBtn.Parent = BoxESP; VisualBtn.LayoutOrder = 8

    createSlider(BoxESP, "SIZE: %d STUDS", 1, 200, Settings.HitboxSize, function(val)
        Settings.HitboxSize = val
    end)


    -- --- TAB 4: UTILITY ---
    
    -- BOX 1: TELEPORT ACTIONS
    local BoxTeleports = createGroupContainer("Utility", "MM2 Teleport Actions", 180)
    
    local TpLobbyBtn = createBtn("TP TO LOBBY MAP", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpLobbyBtn.Parent = BoxTeleports; TpLobbyBtn.LayoutOrder = 1
    local TpLobbyExtToggleBtn = createBtn("TP LOBBY (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpLobbyExtToggleBtn.Parent = BoxTeleports; TpLobbyExtToggleBtn.LayoutOrder = 2

    local TpUndergroundBtn = createBtn("TP UNDERGROUND", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpUndergroundBtn.Parent = BoxTeleports; TpUndergroundBtn.LayoutOrder = 3
    local TpUndergroundExtToggleBtn = createBtn("TP UNDERGROUND (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpUndergroundExtToggleBtn.Parent = BoxTeleports; TpUndergroundExtToggleBtn.LayoutOrder = 4

    local TpSheriffBtn = createBtn("TP TO SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpSheriffBtn.Parent = BoxTeleports; TpSheriffBtn.LayoutOrder = 5
    local TpSheriffExtToggleBtn = createBtn("TP SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpSheriffExtToggleBtn.Parent = BoxTeleports; TpSheriffExtToggleBtn.LayoutOrder = 6

    local TpMurderBtn = createBtn("TP TO MURDERER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpMurderBtn.Parent = BoxTeleports; TpMurderBtn.LayoutOrder = 7
    local TpMurderExtToggleBtn = createBtn("TP MURDERER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpMurderExtToggleBtn.Parent = BoxTeleports; TpMurderExtToggleBtn.LayoutOrder = 8

    local TpPreFlingBtn = createBtn("TP TO PRE-FLING POSITION", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpPreFlingBtn.Parent = BoxTeleports; TpPreFlingBtn.LayoutOrder = 9
    local TpPreFlingExtToggleBtn = createBtn("TP PRE-FLING (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpPreFlingExtToggleBtn.Parent = BoxTeleports; TpPreFlingExtToggleBtn.LayoutOrder = 10


    -- BOX 2: JUMPING & VOID CONTROL
    local BoxJumpVoid = createGroupContainer("Utility", "Jumping & Safe Control", 82)
    local AntiVoidToggleBtn = createBtn("ANTI VOID: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiVoidToggleBtn.Parent = BoxJumpVoid; AntiVoidToggleBtn.LayoutOrder = 1

    local InfiniteJumpToggleBtn = createBtn("INFINITE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InfiniteJumpToggleBtn.Parent = BoxJumpVoid; InfiniteJumpToggleBtn.LayoutOrder = 2

    local DoubleJumpToggleBtn = createBtn("DOUBLE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpToggleBtn.Parent = BoxJumpVoid; DoubleJumpToggleBtn.LayoutOrder = 3

    local DoubleJumpExtToggleBtn = createBtn("DOUBLE JUMP (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpExtToggleBtn.Parent = BoxJumpVoid; DoubleJumpExtToggleBtn.LayoutOrder = 4


    -- BOX 3: WALKSPEED MODIFIER
    local BoxSpeed = createGroupContainer("Utility", "Walkspeed Modifier", 46)
    local SpeedWalkBtn = createBtn("SPEED WALK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpeedWalkBtn.Parent = BoxSpeed; SpeedWalkBtn.LayoutOrder = 1
    
    createSlider(BoxSpeed, "SPEED: %d WS", 1, 100, Settings.SpeedWalkValue, function(val)
        Settings.SpeedWalkValue = val
    end)


    -- BOX 4: JUMP POWER MODIFIER
    local BoxPlayerJump = createGroupContainer("Utility", "Jump Power Modifier", 46)
    local JumpToggleBtn = createBtn("JUMP HEIGHT MOD: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    JumpToggleBtn.Parent = BoxPlayerJump; JumpToggleBtn.LayoutOrder = 1

    createSlider(BoxPlayerJump, "JUMP POWER: %d", 50, 200, Settings.JumpPowerValue, function(val)
        Settings.JumpPowerValue = val
    end)


    -- BOX 5: FLY & NOCLIP
    local BoxFlyNoclip = createGroupContainer("Utility", "No Clip & Fly Hack", 64)
    local FlyToggleBtn = createBtn("FLY HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlyToggleBtn.Parent = BoxFlyNoclip; FlyToggleBtn.LayoutOrder = 1

    createSlider(BoxFlyNoclip, "FLY SPEED: %d", 10, 150, Settings.FlySpeedValue, function(val)
        Settings.FlySpeedValue = val
    end)

    local NoclipToggleBtn = createBtn("NOCLIP (WALK THRU WALLS): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NoclipToggleBtn.Parent = BoxFlyNoclip; NoclipToggleBtn.LayoutOrder = 3


    -- BOX 6: INVISIBILITY
    local BoxInvisible = createGroupContainer("Utility", "Invisibility", 28)
    local InvisibleToggleBtn = createBtn("INVISIBLE HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InvisibleToggleBtn.Parent = BoxInvisible; InvisibleToggleBtn.LayoutOrder = 1


    -- BOX 7: MASTER UI BUTTON CONTROLS
    local BoxUIControls = createGroupContainer("Utility", "UI Button Settings", 46)
    local MasterShowExtBtn = createBtn("SHOW EXTERNAL BUTTONS: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), _GAccentColor)
    MasterShowExtBtn.Parent = BoxUIControls; MasterShowExtBtn.TextColor3 = Color3.new(0,0,0); MasterShowExtBtn.LayoutOrder = 1

    createSlider(BoxUIControls, "EXT BUTTONS SIZE: %d", 20, 100, Settings.Size_A, function(val)
        Settings.Size_L = val
        Settings.Size_A = val
        Settings.Size_G = val
        Settings.Size_DJ = val
        Settings.Size_Spin = val
        Settings.Size_TpSheriff = val
        Settings.Size_TpMurder = val
        Settings.Size_FlingMurder = val
        Settings.Size_FlingSheriff = val
        Settings.Size_Tplobby = val
        Settings.Size_TpUnderground = val
        Settings.Size_TpPreFling = val
        updateExternalButtonSizes()
    end)


    -- ========================================================================
    -- [[ CLOSING / OPENING BAR MAIN CONTROLLER ]]
    -- ========================================================================
    local CloseBar = createBtn("▼ OPEN MENU ▼", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16), Color3.new(0,0,0))
    CloseBar.Parent = MainFrame; CloseBar.BackgroundTransparency = 1; CloseBar.TextSize = 6

    CloseBar.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        MainFrame:TweenSize(isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205), "Out", "Quad", 0.25, true)
        CloseBar.Text = isMinimized and "▼ OPEN MENU ▼" or "▲ CLOSE MENU ▲"
        task.wait(0.2); ContentFrame.Visible = not isMinimized
    end)

    ToggleBtnMain.MouseButton1Click:Connect(function()
        MainVisible = not MainVisible
        if MainVisible then
            MainFrame.Visible = true; HUDMain.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205)}):Play()
            _G.UpdateExternalButtonsVisibility()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 160, 0, 0)})
            t:Play(); t.Completed:Connect(function() if not MainVisible then MainFrame.Visible = false end end)
            HUDMain.Visible = false
            _G.UpdateExternalButtonsVisibility()
        end
    end)

    -- Dynamic Graph FPS Engine
    task.spawn(function()
        local lastTime = tick(); local frames = 0
        SafeConnect(RunService.RenderStepped, function()
            frames += 1
            if tick() - lastTime >= 1 then
                FPSLabel.Text = "FPS: " .. frames; PingLabel.Text = "PING: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms"
                for i = 1, 9 do pcall(function() bars[i].Size = bars[i+1].Size; bars[i].Position = UDim2.new(0, i*3, 1, -bars[i].Size.Y.Offset) end) end
                local newH = math.clamp(frames/3, 5, 30); pcall(function() bars[10].Size = UDim2.new(0, 2, 0, newH); bars[10].Position = UDim2.new(0, 30, 1, -newH) end)
                frames = 0; lastTime = tick()
            end
        end)
    end)

    -- ==========================================
    -- [[ TOGGLES BEHAVIOR & INTEGRATION ]]
    -- ==========================================
    local function toggleKillAura()
        Settings.KillAuraEnabled = not Settings.KillAuraEnabled
        KillAuraToggleBtn.Text = Settings.KillAuraEnabled and "KILL AURA: ON" or "KILL AURA: OFF"
        KillAuraToggleBtn.BackgroundColor3 = Settings.KillAuraEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function syncAimbotVisual()
        ToggleBtn.Text = Settings.CameraAimbot and "[Q] AIMBOT: ON" or "[Q] AIMBOT: OFF"
        ToggleBtn.BackgroundColor3 = Settings.CameraAimbot and _GAccentColor or Color3.fromRGB(30, 30, 35)
        ExtAimbotBtn.BackgroundColor3 = Settings.CameraAimbot and _GAccentColor or Color3.fromRGB(20, 20, 25)
        ExtAimbotBtn.TextColor3 = Settings.CameraAimbot and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end

    local function toggleAimbot()
        Settings.CameraAimbot = not Settings.CameraAimbot
        syncAimbotVisual()
    end

    local function toggleExtAimbotMaster()
        Settings.AimbotExtEnabled = not Settings.AimbotExtEnabled
        ExtAimbotToggleBtn.Text = Settings.AimbotExtEnabled and "AIMBOT (EXT): ON" or "AIMBOT (EXT): OFF"
        ExtAimbotToggleBtn.BackgroundColor3 = Settings.AimbotExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleEsp()
        Settings.ESP = not Settings.ESP
        EspBtn.Text = Settings.ESP and "[X] ESP + GUN DROP: ON" or "[X] ESP + GUN DROP: OFF"
        EspBtn.BackgroundColor3 = Settings.ESP and _GAccentColor or Color3.fromRGB(30, 30, 35)
        if not Settings.ESP then ClearGunOutlines() end
    end

    local function toggleTracersEsp()
        Settings.TracersESP = not Settings.TracersESP
        TracersEspBtn.Text = Settings.TracersESP and "TRACERS ESP LINE: ON" or "TRACERS ESP LINE: OFF"
        TracersEspBtn.BackgroundColor3 = Settings.TracersESP and _GAccentColor or Color3.fromRGB(30, 30, 35)
        if not Settings.TracersESP then ClearAllTracers() end
    end

    local function toggleNameEsp()
        Settings.NameESP = not Settings.NameESP
        NameEspBtn.Text = Settings.NameESP and "NAME ESP: ON" or "NAME ESP: OFF"
        NameEspBtn.BackgroundColor3 = Settings.NameESP and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleFilterMurder()
        Settings.EspMurderer = not Settings.EspMurderer
        FilterMurderBtn.Text = Settings.EspMurderer and "FILTER: MURDERER (ON)" or "FILTER: MURDERER (OFF)"
        FilterMurderBtn.BackgroundColor3 = Settings.EspMurderer and _GAccentColor or Color3.fromRGB(30, 30, 35)
        FilterMurderBtn.TextColor3 = Settings.EspMurderer and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleFilterSheriff()
        Settings.EspSheriff = not Settings.EspSheriff
        FilterSheriffBtn.Text = Settings.EspSheriff and "FILTER: SHERIFF (ON)" or "FILTER: SHERIFF (OFF)"
        FilterSheriffBtn.BackgroundColor3 = Settings.EspSheriff and _GAccentColor or Color3.fromRGB(30, 30, 35)
        FilterSheriffBtn.TextColor3 = Settings.EspSheriff and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleFilterInnocent()
        Settings.EspInnocent = not Settings.EspInnocent
        FilterInnocentBtn.Text = Settings.EspInnocent and "FILTER: INNOCENT (ON)" or "FILTER: INNOCENT (OFF)"
        FilterInnocentBtn.BackgroundColor3 = Settings.EspInnocent and _GAccentColor or Color3.fromRGB(30, 30, 35)
        FilterInnocentBtn.TextColor3 = Settings.EspInnocent and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleHitbox()
        Settings.HitboxExpander = not Settings.HitboxExpander
        HitboxBtn.Text = Settings.HitboxExpander and "[C] HITBOX EXPANDER: ON" or "[C] HITBOX EXPANDER: OFF"
        HitboxBtn.BackgroundColor3 = Settings.HitboxExpander and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAutoGrab()
        Settings.AutoGrabGun = not Settings.AutoGrabGun
        GrabBtn.Text = Settings.AutoGrabGun and "[H] AUTO GRAB GUN: ON" or "[H] AUTO GRAB GUN: OFF"
        GrabBtn.BackgroundColor3 = Settings.AutoGrabGun and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleManualGrabMaster()
        Settings.GrabGunExtEnabled = not Settings.GrabGunExtEnabled
        ManualGrabToggleBtn.Text = Settings.GrabGunExtEnabled and "GRAB GUN (EXT): ON" or "GRAB GUN (EXT): OFF"
        ManualGrabToggleBtn.BackgroundColor3 = Settings.GrabGunExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function executeManualGrab()
        local activeGun = ScanForDroppedGun()
        if activeGun then
            SafeInstantTween(activeGun)
        end
    end

    local function toggleHideFOV()
        Settings.HideFOVCircle = not Settings.HideFOVCircle
        FOVHideBtn.Text = Settings.HideFOVCircle and "[P] HIDE FOV CIRCLE: ON" or "[P] HIDE FOV CIRCLE: OFF"
        FOVHideBtn.BackgroundColor3 = Settings.HideFOVCircle and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleCameraFOV()
        Settings.CameraFOVEnabled = not Settings.CameraFOVEnabled
        CamFOVToggleBtn.Text = Settings.CameraFOVEnabled and "CAMERA FOV MODIFIER: ON" or "CAMERA FOV MODIFIER: OFF"
        CamFOVToggleBtn.BackgroundColor3 = Settings.CameraFOVEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleFly()
        Settings.FlyEnabled = not Settings.FlyEnabled
        FlyToggleBtn.Text = Settings.FlyEnabled and "FLY HACK: ON" or "FLY HACK: OFF"
        FlyToggleBtn.BackgroundColor3 = Settings.FlyEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleJumpHeight()
        Settings.JumpPowerEnabled = not Settings.JumpPowerEnabled
        JumpToggleBtn.Text = Settings.JumpPowerEnabled and "JUMP HEIGHT MOD: ON" or "JUMP HEIGHT MOD: OFF"
        JumpToggleBtn.BackgroundColor3 = Settings.JumpPowerEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleNoclip()
        Settings.NoclipEnabled = not Settings.NoclipEnabled
        NoclipToggleBtn.Text = Settings.NoclipEnabled and "NOCLIP: ON" or "NOCLIP (WALK THRU WALLS): OFF"
        NoclipToggleBtn.BackgroundColor3 = Settings.NoclipEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleInvisible()
        Settings.InvisibleEnabled = not Settings.InvisibleEnabled
        InvisibleToggleBtn.Text = Settings.InvisibleEnabled and "INVISIBLE HACK: ON" or "INVISIBLE HACK: OFF"
        InvisibleToggleBtn.BackgroundColor3 = Settings.InvisibleEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        
        if not Settings.InvisibleEnabled and LocalPlayer.Character then
            for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("Decal") then
                    if child.Name ~= "HumanoidRootPart" then
                        child.Transparency = 0
                    end
                end
            end
        end
    end

    _G.SyncFlingButtons = function()
        FlingMurderBtn.Text = Settings.AutoFlingMurder and "FLING MURDER: ON" or "AUTO FLING MURDER"
        FlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 35)
        FlingSheriffBtn.Text = Settings.AutoFlingSheriff and "FLING SHERIFF: ON" or "AUTO FLING SHERIFF"
        FlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(30, 30, 35)
        
        ExtFlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and _GAccentColor or Color3.fromRGB(20, 20, 25)
        ExtFlingMurderBtn.TextColor3 = Settings.AutoFlingMurder and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        
        ExtFlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and _GAccentColor or Color3.fromRGB(20, 20, 25)
        ExtFlingSheriffBtn.TextColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end

    local function toggleFlingMurder()
        Settings.AutoFlingMurder = not Settings.AutoFlingMurder
        if Settings.AutoFlingMurder then 
            SavePreFlingPosition()
            Settings.AutoFlingSheriff = false 
        end
        _G.SyncFlingButtons()
    end

    local function toggleFlingSheriff()
        Settings.AutoFlingSheriff = not Settings.AutoFlingSheriff
        if Settings.AutoFlingSheriff then 
            SavePreFlingPosition()
            Settings.AutoFlingMurder = false 
        end
        _G.SyncFlingButtons()
    end

    local function toggleSpeedWalk()
        Settings.SpeedWalkEnabled = not Settings.SpeedWalkEnabled
        SpeedWalkBtn.Text = Settings.SpeedWalkEnabled and "SPEED WALK: ON" or "SPEED WALK: OFF"
        SpeedWalkBtn.BackgroundColor3 = Settings.SpeedWalkEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        if not Settings.SpeedWalkEnabled then pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end
    end

    local function toggleDoubleJump()
        Settings.DoubleJumpEnabled = not Settings.DoubleJumpEnabled
        DoubleJumpToggleBtn.Text = Settings.DoubleJumpEnabled and "DOUBLE JUMP: ON" or "DOUBLE JUMP: OFF"
        DoubleJumpToggleBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        
        ExtDoubleJumpBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and _GAccentColor or Color3.fromRGB(20, 20, 25)
        ExtDoubleJumpBtn.TextColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end

    local function toggleDoubleJumpExt()
        Settings.DoubleJumpExtEnabled = not Settings.DoubleJumpExtEnabled
        DoubleJumpExtToggleBtn.Text = Settings.DoubleJumpExtEnabled and "DOUBLE JUMP (EXT): ON" or "DOUBLE JUMP (EXT): OFF"
        DoubleJumpExtToggleBtn.BackgroundColor3 = Settings.DoubleJumpExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    -- BARU: LOGIKA INTEGRASI FITUR TAMBAHAN
    local function toggleSpin()
        Settings.SpinEnabled = not Settings.SpinEnabled
        SpinToggleBtn.Text = Settings.SpinEnabled and "SPIN: ON" or "SPIN: OFF"
        SpinToggleBtn.BackgroundColor3 = Settings.SpinEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        ExtSpinBtn.BackgroundColor3 = Settings.SpinEnabled and _GAccentColor or Color3.fromRGB(20, 20, 25)
        ExtSpinBtn.TextColor3 = Settings.SpinEnabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    end

    local function toggleSpinExt()
        Settings.SpinExtEnabled = not Settings.SpinExtEnabled
        SpinExtToggleBtn.Text = Settings.SpinExtEnabled and "SPIN (EXT): ON" or "SPIN (EXT): OFF"
        SpinExtToggleBtn.BackgroundColor3 = Settings.SpinExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleTouchFling()
        Settings.TouchFling = not Settings.TouchFling
        if Settings.TouchFling then
            SavePreFlingPosition()
        end
        TouchFlingToggleBtn.Text = Settings.TouchFling and "TOUCH FLING: ON" or "TOUCH FLING: OFF"
        TouchFlingToggleBtn.BackgroundColor3 = Settings.TouchFling and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAntiFling()
        Settings.AntiFling = not Settings.AntiFling
        AntiFlingToggleBtn.Text = Settings.AntiFling and "ANTI FLING: ON" or "ANTI FLING: OFF"
        AntiFlingToggleBtn.BackgroundColor3 = Settings.AntiFling and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAntiVoid()
        Settings.AntiVoid = not Settings.AntiVoid
        AntiVoidToggleBtn.Text = Settings.AntiVoid and "ANTI VOID: ON" or "ANTI VOID: OFF"
        AntiVoidToggleBtn.BackgroundColor3 = Settings.AntiVoid and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleTpLobbyExt()
        Settings.TplobbyExtEnabled = not Settings.TplobbyExtEnabled
        TpLobbyExtToggleBtn.Text = Settings.TplobbyExtEnabled and "TP LOBBY (EXT): ON" or "TP LOBBY (EXT): OFF"
        TpLobbyExtToggleBtn.BackgroundColor3 = Settings.TplobbyExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleTpUndergroundExt()
        Settings.TpUndergroundExtEnabled = not Settings.TpUndergroundExtEnabled
        TpUndergroundExtToggleBtn.Text = Settings.TpUndergroundExtEnabled and "TP UNDERGROUND (EXT): ON" or "TP UNDERGROUND (EXT): OFF"
        TpUndergroundExtToggleBtn.BackgroundColor3 = Settings.TpUndergroundExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleTpSheriffExt()
        Settings.TpSheriffExtEnabled = not Settings.TpSheriffExtEnabled
        TpSheriffExtToggleBtn.Text = Settings.TpSheriffExtEnabled and "TP SHERIFF (EXT): ON" or "TP SHERIFF (EXT): OFF"
        TpSheriffExtToggleBtn.BackgroundColor3 = Settings.TpSheriffExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleTpMurderExt()
        Settings.TpMurderExtEnabled = not Settings.TpMurderExtEnabled
        TpMurderExtToggleBtn.Text = Settings.TpMurderExtEnabled and "TP MURDERER (EXT): ON" or "TP MURDERER (EXT): OFF"
        TpMurderExtToggleBtn.BackgroundColor3 = Settings.TpMurderExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleTpPreFlingExt()
        Settings.TpPreFlingExtEnabled = not Settings.TpPreFlingExtEnabled
        TpPreFlingExtToggleBtn.Text = Settings.TpPreFlingExtEnabled and "TP PRE-FLING (EXT): ON" or "TP PRE-FLING (EXT): OFF"
        TpPreFlingExtToggleBtn.BackgroundColor3 = Settings.TpPreFlingExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleFlingMurderExt()
        Settings.FlingMurderExtEnabled = not Settings.FlingMurderExtEnabled
        FlingMurderExtToggleBtn.Text = Settings.FlingMurderExtEnabled and "FLING MURDER (EXT): ON" or "FLING MURDER (EXT): OFF"
        FlingMurderExtToggleBtn.BackgroundColor3 = Settings.FlingMurderExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    local function toggleFlingSheriffExt()
        Settings.FlingSheriffExtEnabled = not Settings.FlingSheriffExtEnabled
        FlingSheriffExtToggleBtn.Text = Settings.FlingSheriffExtEnabled and "FLING SHERIFF (EXT): ON" or "FLING SHERIFF (EXT): OFF"
        FlingSheriffExtToggleBtn.BackgroundColor3 = Settings.FlingSheriffExtEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        _G.UpdateExternalButtonsVisibility()
    end

    -- KONEKSI EVENT KE TOMBOL-TOMBOL FITUR
    KillAuraToggleBtn.MouseButton1Click:Connect(toggleKillAura)
    KillAllBtn.MouseButton1Click:Connect(TeleportAllPlayersToMe)

    ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
    ExtAimbotToggleBtn.MouseButton1Click:Connect(toggleExtAimbotMaster)
    ExtAimbotBtn.MouseButton1Click:Connect(toggleAimbot)
    
    EspBtn.MouseButton1Click:Connect(toggleEsp)
    TracersEspBtn.MouseButton1Click:Connect(toggleTracersEsp)
    NameEspBtn.MouseButton1Click:Connect(toggleNameEsp)
    FilterMurderBtn.MouseButton1Click:Connect(toggleFilterMurder)
    FilterSheriffBtn.MouseButton1Click:Connect(toggleFilterSheriff)
    FilterInnocentBtn.MouseButton1Click:Connect(toggleFilterInnocent)
    HitboxBtn.MouseButton1Click:Connect(toggleHitbox)
    
    GrabBtn.MouseButton1Click:Connect(toggleAutoGrab) 
    ManualGrabToggleBtn.MouseButton1Click:Connect(toggleManualGrabMaster)
    ExtGrabBtn.MouseButton1Click:Connect(executeManualGrab)

    FOVHideBtn.MouseButton1Click:Connect(toggleHideFOV)
    CamFOVToggleBtn.MouseButton1Click:Connect(toggleCameraFOV)

    FlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)
    FlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)
    FlingMurderExtToggleBtn.MouseButton1Click:Connect(toggleFlingMurderExt)
    FlingSheriffExtToggleBtn.MouseButton1Click:Connect(toggleFlingSheriffExt)
    ExtFlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)
    ExtFlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)

    SpeedWalkBtn.MouseButton1Click:Connect(toggleSpeedWalk)
    FlyToggleBtn.MouseButton1Click:Connect(toggleFly)
    JumpToggleBtn.MouseButton1Click:Connect(toggleJumpHeight)
    NoclipToggleBtn.MouseButton1Click:Connect(toggleNoclip)
    InvisibleToggleBtn.MouseButton1Click:Connect(toggleInvisible)

    DoubleJumpToggleBtn.MouseButton1Click:Connect(toggleDoubleJump)
    DoubleJumpExtToggleBtn.MouseButton1Click:Connect(toggleDoubleJumpExt)
    ExtDoubleJumpBtn.MouseButton1Click:Connect(toggleDoubleJump)

    -- KONEKSI FITUR BARU
    SpinToggleBtn.MouseButton1Click:Connect(toggleSpin)
    SpinExtToggleBtn.MouseButton1Click:Connect(toggleSpinExt)
    ExtSpinBtn.MouseButton1Click:Connect(toggleSpin)
    TouchFlingToggleBtn.MouseButton1Click:Connect(toggleTouchFling)
    AntiFlingToggleBtn.MouseButton1Click:Connect(toggleAntiFling)

    TpLobbyBtn.MouseButton1Click:Connect(TeleportToLobby)
    TpLobbyExtToggleBtn.MouseButton1Click:Connect(toggleTpLobbyExt)
    ExtTpLobbyBtn.MouseButton1Click:Connect(TeleportToLobby)

    TpUndergroundBtn.MouseButton1Click:Connect(TeleportUnderground)
    TpUndergroundExtToggleBtn.MouseButton1Click:Connect(toggleTpUndergroundExt)
    ExtTpUndergroundBtn.MouseButton1Click:Connect(TeleportUnderground)

    TpSheriffBtn.MouseButton1Click:Connect(function() TeleportToPlayerByRole("Sheriff") end)
    TpSheriffExtToggleBtn.MouseButton1Click:Connect(toggleTpSheriffExt)
    ExtTpSheriffBtn.MouseButton1Click:Connect(function() TeleportToPlayerByRole("Sheriff") end)

    TpMurderBtn.MouseButton1Click:Connect(function() TeleportToPlayerByRole("Murderer") end)
    TpMurderExtToggleBtn.MouseButton1Click:Connect(toggleTpMurderExt)
    ExtTpMurderBtn.MouseButton1Click:Connect(function() TeleportToPlayerByRole("Murderer") end)

    TpPreFlingBtn.MouseButton1Click:Connect(TeleportToPreFling)
    TpPreFlingExtToggleBtn.MouseButton1Click:Connect(toggleTpPreFlingExt)
    ExtTpPreFlingBtn.MouseButton1Click:Connect(TeleportToPreFling)

    AntiVoidToggleBtn.MouseButton1Click:Connect(toggleAntiVoid)
    InfiniteJumpToggleBtn.MouseButton1Click:Connect(toggleInfiniteJump)

    MasterShowExtBtn.MouseButton1Click:Connect(function()
        Settings.ShowExternalButtons = not Settings.ShowExternalButtons
        MasterShowExtBtn.Text = Settings.ShowExternalButtons and "SHOW EXTERNAL BUTTONS: ON" or "SHOW EXTERNAL BUTTONS: OFF"
        MasterShowExtBtn.BackgroundColor3 = Settings.ShowExternalButtons and _GAccentColor or Color3.fromRGB(30, 30, 35)
        MasterShowExtBtn.TextColor3 = Settings.ShowExternalButtons and Color3.new(0,0,0) or Color3.new(1,1,1)
        _G.UpdateExternalButtonsVisibility()
    end)

    VisualBtn.MouseButton1Click:Connect(function()
        Settings.HitboxVisual = not Settings.HitboxVisual
        VisualBtn.Text = Settings.HitboxVisual and "[V] HITBOX VISUAL: ON" or "[V] HITBOX VISUAL: OFF"
        VisualBtn.BackgroundColor3 = Settings.HitboxVisual and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 35)
    end)
    
    local potatoEnabled = false
    PotatoToggle.MouseButton1Click:Connect(function()
        potatoEnabled = not potatoEnabled
        if potatoEnabled then
            ApplyPotato()
            PotatoToggle.BackgroundColor3 = _GAccentColor
            PotatoStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            PotatoStroke.Color = Color3.fromRGB(100, 100, 100)
        end
    end)

    -- Keybind Listener
    SafeConnect(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.Q then toggleAimbot()
        elseif key == Enum.KeyCode.X then toggleEsp()
        elseif key == Enum.KeyCode.C then toggleHitbox()
        elseif key == Enum.KeyCode.H then toggleAutoGrab() 
        elseif key == Enum.KeyCode.P then toggleHideFOV()
        end
    end)

    -- Dragging Frame (Menggunakan SafeConnect)
    local dragging, dragStart, startPos
    SafeConnect(MainFrame.InputBegan, function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
    SafeConnect(UserInputService.InputChanged, function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
    SafeConnect(UserInputService.InputEnded, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    startLoading()
    print("Louis Hub FREE V13.5.2: Rebuilt Box Systems, Extra Mechanics & Memory Leak Patch Successfully Initialized.")
end
