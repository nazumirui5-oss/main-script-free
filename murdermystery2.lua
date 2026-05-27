-- [[ LOUIS HUB FREE - INTEGRATED & PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 14.0.1 (Premium Feature Sync Update - MM2 Edition)

return function(AccessKey)
    local Players = game:GetService("Players")
    
    -- ========================================================
    -- [[ INISIALISASI INSTAN PEMAIN LOKAL ]]
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
    -- [[ RE-EXECUTION CLEANUP ENGINE ]]
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
                            ["footer"] = {["text"] = "Louis Hub v14.0.1 | Anti-Tamper System"},
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
    -- [[ KONFIGURASI FITUR GLOBAL ]]
    -- ========================================================
    local Settings = {
        CameraAimbot = false,
        AimbotKnifeEnabled = false, -- FITUR BARU
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
        
        -- BARU: Spin & Spin Power
        SpinEnabled = false,
        SpinPower = 50,
        SpinExtEnabled = false,
        
        -- BARU: Teleport Sheriff & Murderer
        TPSheriffExtEnabled = false,
        TPMurderExtEnabled = false,
        
        -- BARU: Teleport Lobby & Underground
        AutoTPLobbyExtEnabled = false,
        AutoTPUndergroundExtEnabled = false,
        
        -- BARU: Fling Murder & Sheriff External
        FlingMurderExtEnabled = false,
        FlingSheriffExtEnabled = false,
        
        -- BARU: Anti-Fling & Touch Fling
        AntiFlingEnabled = false,
        TouchFlingEnabled = false,
        TouchFlingPower = 100,
        
        -- BARU: Infinite Jump & Anti Void
        InfiniteJumpEnabled = false,
        AntiVoidEnabled = false,
        
        -- BARU: Target Pick Player Fling & TP
        TargetPlayerName = "",
        
        -- BARU: TP Back (Sebelum Fling)
        TPBackExtEnabled = false,
        
        -- BARU: Master Toggle External Buttons
        AllExtEnabled = true,

        -- Ukuran Tombol Eksternal (Lengkap dengan Slider Size masing-masing)
        Size_L = 50,
        Size_A = 40,
        Size_G = 40,
        Size_DJ = 40,
        Size_Spin = 40,
        Size_TPSheriff = 40,
        Size_TPMurder = 40,
        Size_FlingMurder = 40,
        Size_FlingSheriff = 40,
        Size_TPLobby = 40,
        Size_TPUnderground = 40,
        Size_TPBack = 40
    }

    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    local OriginalFOV = Camera.FieldOfView
    
    local OriginalCFrameBeforeFling = nil
    local FlingFailsafeActive = false

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
            for _, v in ipairs(Workspace:GetDescendants()) do pcall(Clean, v) end
        end)
    end

    local ToggleBtnMain, HUDMain, MainFrame, ContentFrame

    -- ==========================================
    -- [[ LOADING SCREEN SYSTEM ]]
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
    -- [[ JUMP RUNTIME & DOUBLE/INFINITE JUMP ENGINE ]]
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

    -- Penggabungan Double Jump & Infinite Jump
    local JumpReqConn = UserInputService.JumpRequest:Connect(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and root and humanoid.Health > 0 then
            if Settings.InfiniteJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            elseif Settings.DoubleJumpEnabled then
                if CanDoubleJump and not HasDoubleJumped then
                    HasDoubleJumped = true
                    root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower * 1.15, root.Velocity.Z)
                end
            end
        end
    end)
    table.insert(_G.LouisConnections, JumpReqConn)

    -- ========================================================================
    -- [[ ANTI-VOID ENGINE ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            task.wait(0.5)
            if Settings.AntiVoidEnabled and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Position.Y < -40 then
                    root.Velocity = Vector3.new(0, 0, 0)
                    -- Teleport ke titik aman default (Spawn / Lobby / Tinggi di langit)
                    root.CFrame = CFrame.new(0, 50, 0)
                end
            end
        end
    end)

    -- ========================================================================
    -- [[ ANTI-FLING & SPIN RUNTIME ]]
    -- ========================================================================
    SafeConnect(RunService.Heartbeat, function()
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if root and humanoid then
            -- Anti-Fling
            if Settings.AntiFlingEnabled then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                if root.Velocity.Magnitude > 75 and not Settings.AutoFlingMurder and not Settings.AutoFlingSheriff and not Settings.TouchFlingEnabled then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end

            -- Spin Engine
            if Settings.SpinEnabled then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinPower), 0)
            end
        end
    end)

    -- ========================================================================
    -- [[ TOUCH FLING ENGINE ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            task.wait()
            if Settings.TouchFlingEnabled and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local oldVelocity = root.Velocity
                    -- Berikan gaya impuls fisika luar biasa cepat dalam hitungan detik untuk efek Fling
                    root.Velocity = Vector3.new(Settings.TouchFlingPower * 100, Settings.TouchFlingPower * 100, Settings.TouchFlingPower * 100)
                    RunService.RenderStepped:Wait()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        root.Velocity = oldVelocity
                    end
                end
            end
        end
    end)

    -- ========================================================================
    -- [[ DETEKSI TARGET & LOGIKA EMULASI AIMBOT (MM2 - GUN & KNIFE) ]]
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

    -- Target untuk Pembunuh (Target = Innocent / Sheriff)
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

    -- Target untuk Innocent & Sheriff (Target = Murderer)
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

    -- AIMBOT RENDER: Dipicu saat memegang Gun atau Knife (Aktif di tangan / Tas)
    SafeConnect(RunService.RenderStepped, function()
        if Settings.CameraAimbot and LocalPlayer.Character then
            local HoldsGun = LocalPlayer.Character:FindFirstChild("Gun")
            local HoldsKnife = LocalPlayer.Character:FindFirstChild("Knife")
            local InBackpackGun = LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Gun")
            local InBackpackKnife = LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife")
            
            local GunEquipped = (HoldsGun and HoldsGun:IsA("Tool"))
            local KnifeEquipped = (HoldsKnife and HoldsKnife:IsA("Tool"))
            local HasGunActive = GunEquipped or InBackpackGun
            local HasKnifeActive = KnifeEquipped or InBackpackKnife
            
            -- Pemicu Aimbot: Jika membawa Pistol secara umum, atau memegang Pisau saat Knife Aimbot aktif
            if HasGunActive or (Settings.AimbotKnifeEnabled and HasKnifeActive) then
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
            if hum.FloorMaterial == Enum.Material.Air and root.Velocity.Magnitude > 100 and not Settings.AutoFlingMurder and not Settings.AutoFlingSheriff and not Settings.TouchFlingEnabled then 
                root.Velocity = root.Velocity.Unit * 100 
            end
        end
    end)

    -- ========================================================================
    -- [[ NOCLIP & RETURN ENGINE (GUN GRABBER) ]]
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
    -- [[ CORE SETTINGS FOR UI THEME ]]
    -- ========================================================================
    local _GMainColor = Color3.fromRGB(15, 15, 20)
    local isMinimized = true
    local MainVisible = false
    local hudMinimized = false

    -- Setup ScreenGui Utama
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "LouisHub_FREE_Edition"
    ScreenGui.ResetOnSpawn = false

    -- HELPER UTAMA: Penerapan efek neon/pelangi bergerak pada stroke komponen (UI & Tombol Eksternal)
    local function ApplyNeonStyle(element, stroke)
        if not stroke then return end
        element.BackgroundTransparency = 0.6
        SafeConnect(RunService.RenderStepped, function()
            local hue = (tick() % 4) / 4 -- Siklus warna pelangi dalam waktu 4 detik
            local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
            stroke.Color = rainbowColor
            
            -- Jika element adalah tombol dengan warna aktif, sinkronkan isinya
            if element:IsA("TextButton") and element.BackgroundColor3 ~= Color3.fromRGB(30,30,35) and element.BackgroundColor3 ~= Color3.fromRGB(20,20,25) and element.BackgroundColor3 ~= Color3.fromRGB(0,0,0) then
                element.BackgroundColor3 = rainbowColor
            end
        end)
    end

    -- HELPER UTAMA: Sistem Drag Tombol Eksternal dengan Fitur Lock Status
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

    -- ==========================================
    -- [[ DEKLARASI TOMBOL-TOMBOL EKSTERNAL ]]
    -- ==========================================
    
    -- [[ 1. TOMBOL UTAMA L ]]
    ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    ToggleBtnMain.Visible = false 
    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ApplyNeonStyle(ToggleBtnMain, ToggleStroke)
    MakeDraggable(ToggleBtnMain)

    -- [[ 2. TOMBOL EXTERNAL AIMBOT ]]
    local ExtAimbotBtn = Instance.new("TextButton", ScreenGui)
    ExtAimbotBtn.Name = "ExtAimbot"
    ExtAimbotBtn.Size = UDim2.new(0, Settings.Size_A, 0, Settings.Size_A)
    ExtAimbotBtn.Position = UDim2.new(0, 20, 0.5, 35)
    ExtAimbotBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtAimbotBtn.Text = "A"
    ExtAimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtAimbotBtn.Font = Enum.Font.GothamBold
    ExtAimbotBtn.TextSize = 18
    ExtAimbotBtn.Visible = false
    Instance.new("UICorner", ExtAimbotBtn).CornerRadius = UDim.new(1, 0)
    local ExtAimbotStroke = Instance.new("UIStroke", ExtAimbotBtn)
    ExtAimbotStroke.Thickness = 1.5
    ApplyNeonStyle(ExtAimbotBtn, ExtAimbotStroke)
    MakeDraggable(ExtAimbotBtn)

    -- [[ 3. TOMBOL EXTERNAL GRAB GUN ]]
    local ExtGrabBtn = Instance.new("TextButton", ScreenGui)
    ExtGrabBtn.Name = "ExtGrabGun"
    ExtGrabBtn.Size = UDim2.new(0, Settings.Size_G, 0, Settings.Size_G)
    ExtGrabBtn.Position = UDim2.new(0, 20, 0.5, 85)
    ExtGrabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtGrabBtn.Text = "G"
    ExtGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtGrabBtn.Font = Enum.Font.GothamBold
    ExtGrabBtn.TextSize = 18
    ExtGrabBtn.Visible = false
    Instance.new("UICorner", ExtGrabBtn).CornerRadius = UDim.new(1, 0)
    local ExtGrabStroke = Instance.new("UIStroke", ExtGrabBtn)
    ExtGrabStroke.Thickness = 1.5
    ApplyNeonStyle(ExtGrabBtn, ExtGrabStroke)
    MakeDraggable(ExtGrabBtn)

    -- [[ 4. TOMBOL EXTERNAL DOUBLE JUMP ]]
    local ExtDoubleJumpBtn = Instance.new("TextButton", ScreenGui)
    ExtDoubleJumpBtn.Name = "ExtDoubleJump"
    ExtDoubleJumpBtn.Size = UDim2.new(0, Settings.Size_DJ, 0, Settings.Size_DJ)
    ExtDoubleJumpBtn.Position = UDim2.new(0, 20, 0.5, 135)
    ExtDoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtDoubleJumpBtn.Text = "DJ"
    ExtDoubleJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtDoubleJumpBtn.Font = Enum.Font.GothamBold
    ExtDoubleJumpBtn.TextSize = 15
    ExtDoubleJumpBtn.Visible = false
    Instance.new("UICorner", ExtDoubleJumpBtn).CornerRadius = UDim.new(1, 0)
    local ExtDoubleJumpStroke = Instance.new("UIStroke", ExtDoubleJumpBtn)
    ExtDoubleJumpStroke.Thickness = 1.5
    ApplyNeonStyle(ExtDoubleJumpBtn, ExtDoubleJumpStroke)
    MakeDraggable(ExtDoubleJumpBtn)

    -- [[ 5. TOMBOL EXTERNAL SPIN ]]
    local ExtSpinBtn = Instance.new("TextButton", ScreenGui)
    ExtSpinBtn.Name = "ExtSpin"
    ExtSpinBtn.Size = UDim2.new(0, Settings.Size_Spin, 0, Settings.Size_Spin)
    ExtSpinBtn.Position = UDim2.new(0, 20, 0.5, 185)
    ExtSpinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtSpinBtn.Text = "SP"
    ExtSpinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtSpinBtn.Font = Enum.Font.GothamBold
    ExtSpinBtn.TextSize = 15
    ExtSpinBtn.Visible = false
    Instance.new("UICorner", ExtSpinBtn).CornerRadius = UDim.new(1, 0)
    local ExtSpinStroke = Instance.new("UIStroke", ExtSpinBtn)
    ExtSpinStroke.Thickness = 1.5
    ApplyNeonStyle(ExtSpinBtn, ExtSpinStroke)
    MakeDraggable(ExtSpinBtn)

    -- [[ 6. TOMBOL EXTERNAL TP SHERIFF ]]
    local ExtTPSheriffBtn = Instance.new("TextButton", ScreenGui)
    ExtTPSheriffBtn.Name = "ExtTPSheriff"
    ExtTPSheriffBtn.Size = UDim2.new(0, Settings.Size_TPSheriff, 0, Settings.Size_TPSheriff)
    ExtTPSheriffBtn.Position = UDim2.new(0, 70, 0.5, 35)
    ExtTPSheriffBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtTPSheriffBtn.Text = "TS"
    ExtTPSheriffBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtTPSheriffBtn.Font = Enum.Font.GothamBold
    ExtTPSheriffBtn.TextSize = 15
    ExtTPSheriffBtn.Visible = false
    Instance.new("UICorner", ExtTPSheriffBtn).CornerRadius = UDim.new(1, 0)
    local ExtTPSheriffStroke = Instance.new("UIStroke", ExtTPSheriffBtn)
    ExtTPSheriffStroke.Thickness = 1.5
    ApplyNeonStyle(ExtTPSheriffBtn, ExtTPSheriffStroke)
    MakeDraggable(ExtTPSheriffBtn)

    -- [[ 7. TOMBOL EXTERNAL TP MURDERER ]]
    local ExtTPMurderBtn = Instance.new("TextButton", ScreenGui)
    ExtTPMurderBtn.Name = "ExtTPMurder"
    ExtTPMurderBtn.Size = UDim2.new(0, Settings.Size_TPMurder, 0, Settings.Size_TPMurder)
    ExtTPMurderBtn.Position = UDim2.new(0, 70, 0.5, 85)
    ExtTPMurderBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtTPMurderBtn.Text = "TM"
    ExtTPMurderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtTPMurderBtn.Font = Enum.Font.GothamBold
    ExtTPMurderBtn.TextSize = 15
    ExtTPMurderBtn.Visible = false
    Instance.new("UICorner", ExtTPMurderBtn).CornerRadius = UDim.new(1, 0)
    local ExtTPMurderStroke = Instance.new("UIStroke", ExtTPMurderBtn)
    ExtTPMurderStroke.Thickness = 1.5
    ApplyNeonStyle(ExtTPMurderBtn, ExtTPMurderStroke)
    MakeDraggable(ExtTPMurderBtn)

    -- [[ 8. TOMBOL EXTERNAL FLING MURDERER ]]
    local ExtFlingMurderBtn = Instance.new("TextButton", ScreenGui)
    ExtFlingMurderBtn.Name = "ExtFlingMurder"
    ExtFlingMurderBtn.Size = UDim2.new(0, Settings.Size_FlingMurder, 0, Settings.Size_FlingMurder)
    ExtFlingMurderBtn.Position = UDim2.new(0, 70, 0.5, 135)
    ExtFlingMurderBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtFlingMurderBtn.Text = "FM"
    ExtFlingMurderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtFlingMurderBtn.Font = Enum.Font.GothamBold
    ExtFlingMurderBtn.TextSize = 15
    ExtFlingMurderBtn.Visible = false
    Instance.new("UICorner", ExtFlingMurderBtn).CornerRadius = UDim.new(1, 0)
    local ExtFlingMurderStroke = Instance.new("UIStroke", ExtFlingMurderBtn)
    ExtFlingMurderStroke.Thickness = 1.5
    ApplyNeonStyle(ExtFlingMurderBtn, ExtFlingMurderStroke)
    MakeDraggable(ExtFlingMurderBtn)

    -- [[ 9. TOMBOL EXTERNAL FLING SHERIFF ]]
    local ExtFlingSheriffBtn = Instance.new("TextButton", ScreenGui)
    ExtFlingSheriffBtn.Name = "ExtFlingSheriff"
    ExtFlingSheriffBtn.Size = UDim2.new(0, Settings.Size_FlingSheriff, 0, Settings.Size_FlingSheriff)
    ExtFlingSheriffBtn.Position = UDim2.new(0, 70, 0.5, 185)
    ExtFlingSheriffBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtFlingSheriffBtn.Text = "FS"
    ExtFlingSheriffBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtFlingSheriffBtn.Font = Enum.Font.GothamBold
    ExtFlingSheriffBtn.TextSize = 15
    ExtFlingSheriffBtn.Visible = false
    Instance.new("UICorner", ExtFlingSheriffBtn).CornerRadius = UDim.new(1, 0)
    local ExtFlingSheriffStroke = Instance.new("UIStroke", ExtFlingSheriffBtn)
    ExtFlingSheriffStroke.Thickness = 1.5
    ApplyNeonStyle(ExtFlingSheriffBtn, ExtFlingSheriffStroke)
    MakeDraggable(ExtFlingSheriffBtn)

    -- [[ 10. TOMBOL EXTERNAL TP LOBBY ]]
    local ExtTPLobbyBtn = Instance.new("TextButton", ScreenGui)
    ExtTPLobbyBtn.Name = "ExtTPLobby"
    ExtTPLobbyBtn.Size = UDim2.new(0, Settings.Size_TPLobby, 0, Settings.Size_TPLobby)
    ExtTPLobbyBtn.Position = UDim2.new(0, 120, 0.5, 35)
    ExtTPLobbyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtTPLobbyBtn.Text = "LBY"
    ExtTPLobbyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtTPLobbyBtn.Font = Enum.Font.GothamBold
    ExtTPLobbyBtn.TextSize = 12
    ExtTPLobbyBtn.Visible = false
    Instance.new("UICorner", ExtTPLobbyBtn).CornerRadius = UDim.new(1, 0)
    local ExtTPLobbyStroke = Instance.new("UIStroke", ExtTPLobbyBtn)
    ExtTPLobbyStroke.Thickness = 1.5
    ApplyNeonStyle(ExtTPLobbyBtn, ExtTPLobbyStroke)
    MakeDraggable(ExtTPLobbyBtn)

    -- [[ 11. TOMBOL EXTERNAL TP UNDERGROUND ]]
    local ExtTPUndergroundBtn = Instance.new("TextButton", ScreenGui)
    ExtTPUndergroundBtn.Name = "ExtTPUnderground"
    ExtTPUndergroundBtn.Size = UDim2.new(0, Settings.Size_TPUnderground, 0, Settings.Size_TPUnderground)
    ExtTPUndergroundBtn.Position = UDim2.new(0, 120, 0.5, 85)
    ExtTPUndergroundBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtTPUndergroundBtn.Text = "UG"
    ExtTPUndergroundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtTPUndergroundBtn.Font = Enum.Font.GothamBold
    ExtTPUndergroundBtn.TextSize = 12
    ExtTPUndergroundBtn.Visible = false
    Instance.new("UICorner", ExtTPUndergroundBtn).CornerRadius = UDim.new(1, 0)
    local ExtTPUndergroundStroke = Instance.new("UIStroke", ExtTPUndergroundBtn)
    ExtTPUndergroundStroke.Thickness = 1.5
    ApplyNeonStyle(ExtTPUndergroundBtn, ExtTPUndergroundStroke)
    MakeDraggable(ExtTPUndergroundBtn)

    -- [[ 12. TOMBOL EXTERNAL TP BACK ]]
    local ExtTPBackBtn = Instance.new("TextButton", ScreenGui)
    ExtTPBackBtn.Name = "ExtTPBack"
    ExtTPBackBtn.Size = UDim2.new(0, Settings.Size_TPBack, 0, Settings.Size_TPBack)
    ExtTPBackBtn.Position = UDim2.new(0, 120, 0.5, 135)
    ExtTPBackBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtTPBackBtn.Text = "BCK"
    ExtTPBackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtTPBackBtn.Font = Enum.Font.GothamBold
    ExtTPBackBtn.TextSize = 12
    ExtTPBackBtn.Visible = false
    Instance.new("UICorner", ExtTPBackBtn).CornerRadius = UDim.new(1, 0)
    local ExtTPBackStroke = Instance.new("UIStroke", ExtTPBackBtn)
    ExtTPBackStroke.Thickness = 1.5
    ApplyNeonStyle(ExtTPBackBtn, ExtTPBackStroke)
    MakeDraggable(ExtTPBackBtn)

    -- ========================================================================
    -- [[ FUNGSI SYNC VISIBILITY TOMBOL EKSTERNAL TERHADAP ALL-EXT TOGGLE ]]
    -- ========================================================================
    local function UpdateExternalButtonsVisibility()
        local master = Settings.AllExtEnabled
        
        ExtAimbotBtn.Visible = master and Settings.AimbotExtEnabled
        ExtGrabBtn.Visible = master and Settings.GrabGunExtEnabled
        ExtDoubleJumpBtn.Visible = master and Settings.DoubleJumpExtEnabled
        ExtSpinBtn.Visible = master and Settings.SpinExtEnabled
        ExtTPSheriffBtn.Visible = master and Settings.TPSheriffExtEnabled
        ExtTPMurderBtn.Visible = master and Settings.TPMurderExtEnabled
        ExtFlingMurderBtn.Visible = master and Settings.FlingMurderExtEnabled
        ExtFlingSheriffBtn.Visible = master and Settings.FlingSheriffExtEnabled
        ExtTPLobbyBtn.Visible = master and Settings.AutoTPLobbyExtEnabled
        ExtTPUndergroundBtn.Visible = master and Settings.AutoTPUndergroundExtEnabled
        ExtTPBackBtn.Visible = master and Settings.TPBackExtEnabled
    end

    -- Fungsi memperbarui ukuran seluruh tombol dari value slider dinamis
    local function updateExternalButtonSizes()
        ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
        ExtAimbotBtn.Size = UDim2.new(0, Settings.Size_A, 0, Settings.Size_A)
        ExtGrabBtn.Size = UDim2.new(0, Settings.Size_G, 0, Settings.Size_G)
        ExtDoubleJumpBtn.Size = UDim2.new(0, Settings.Size_DJ, 0, Settings.Size_DJ)
        ExtSpinBtn.Size = UDim2.new(0, Settings.Size_Spin, 0, Settings.Size_Spin)
        ExtTPSheriffBtn.Size = UDim2.new(0, Settings.Size_TPSheriff, 0, Settings.Size_TPSheriff)
        ExtTPMurderBtn.Size = UDim2.new(0, Settings.Size_TPMurder, 0, Settings.Size_TPMurder)
        ExtFlingMurderBtn.Size = UDim2.new(0, Settings.Size_FlingMurder, 0, Settings.Size_FlingMurder)
        ExtFlingSheriffBtn.Size = UDim2.new(0, Settings.Size_FlingSheriff, 0, Settings.Size_FlingSheriff)
        ExtTPLobbyBtn.Size = UDim2.new(0, Settings.Size_TPLobby, 0, Settings.Size_TPLobby)
        ExtTPUndergroundBtn.Size = UDim2.new(0, Settings.Size_TPUnderground, 0, Settings.Size_TPUnderground)
        ExtTPBackBtn.Size = UDim2.new(0, Settings.Size_TPBack, 0, Settings.Size_TPBack)
    end

    -- ==========================================
    -- [[ HUD DAN GRAFIK FPS / PING ENGINE ]]
    -- ==========================================
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
    
    local HUDStroke = Instance.new("UIStroke", HUDFrame)
    HUDStroke.Thickness = 1.5
    ApplyNeonStyle(HUDFrame, HUDStroke) -- Sinkronisasi neon pelangi ke HUD

    local FPSLabel = Instance.new("TextLabel", HUDFrame)
    FPSLabel.Size = UDim2.new(0, 60, 0.4, 0)
    FPSLabel.Position = UDim2.new(0, 5, 0, 4)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.TextColor3 = Color3.new(1, 1, 1) -- Teks putih polos
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextSize = 9
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PingLabel = Instance.new("TextLabel", HUDFrame)
    PingLabel.Size = UDim2.new(0, 60, 0.4, 0)
    PingLabel.Position = UDim2.new(0, 5, 0.4, 0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.TextColor3 = Color3.new(1, 1, 1) -- Teks putih polos
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextSize = 9
    PingLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GraphFrame = Instance.new("Frame", HUDFrame)
    GraphFrame.Size = UDim2.new(0, 35, 0, 35)
    GraphFrame.Position = UDim2.new(1, -75, 0, 5)
    GraphFrame.BackgroundTransparency = 1

    local bars = {}
    for i = 1, 10 do
        local b = Instance.new("Frame", GraphFrame)
        b.Size = UDim2.new(0, 2, 0, 10)
        b.Position = UDim2.new(0, i * 3, 1, -10)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.BorderSizePixel = 0
        bars[i] = b
        
        -- Beri warna neon bergerak ke bar grafik juga
        SafeConnect(RunService.RenderStepped, function()
            local hue = (tick() % 4 + (i * 0.05)) % 4 / 4
            b.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1)
        end)
    end

    local PotatoToggle = Instance.new("TextButton", HUDFrame)
    PotatoToggle.Size = UDim2.new(0, 30, 0, 25)
    PotatoToggle.Position = UDim2.new(1, -35, 0.5, -12.5)
    PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PotatoToggle.Text = "🍃"
    PotatoToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", PotatoToggle)
    local PotatoStroke = Instance.new("UIStroke", PotatoToggle)
    PotatoStroke.Color = Color3.fromRGB(100, 100, 100)
    PotatoStroke.Thickness = 1.5
    ApplyNeonStyle(PotatoToggle, PotatoStroke)

    local HUDToggleBtn = Instance.new("TextButton", HUDMain)
    HUDToggleBtn.Size = UDim2.new(0, 15, 1, 0)
    HUDToggleBtn.Position = UDim2.new(1, -15, 0, 0)
    HUDToggleBtn.BackgroundColor3 = Color3.new(0, 0, 0)
    HUDToggleBtn.BackgroundTransparency = 0.8
    HUDToggleBtn.Text = ">"
    HUDToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", HUDToggleBtn)

    HUDToggleBtn.MouseButton1Click:Connect(function()
        hudMinimized = not hudMinimized
        HUDFrame:TweenSize(hudMinimized and UDim2.new(0, 0, 1, 0) or UDim2.new(1, -20, 1, 0), "Out", "Quad", 0.3, true)
        HUDToggleBtn.Text = hudMinimized and "<" or ">"
    end)

    -- ==========================================
    -- [[ MAIN MENU PANEL ]]
    -- ==========================================
    MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 160, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -80, 0.2, 0)
    MainFrame.BackgroundColor3 = _GMainColor
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Thickness = 1.5
    ApplyNeonStyle(MainFrame, Stroke) -- Menghubungkan pelangi ke border Main Frame

    -- Dynamic Header Text
    local function createLabel(txt, pos, size)
        local l = Instance.new("TextLabel", MainFrame)
        l.Size = size or UDim2.new(0, 148, 0, 10)
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih Polos
        l.TextSize = 7
        l.Font = Enum.Font.GothamBold
        return l
    end

    local HubLabel = createLabel("LOUIS HUB FREE V14.0.1", UDim2.new(0, 6, 0, 4), UDim2.new(0, 95, 0, 12))
    HubLabel.TextSize = 6.5
    
    SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        HubLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1) -- Menjaga label title tetap bersinar
    end)

    -- Sistem UI Helper Button Creation
    local function createBtn(txt, pos, size, color)
        local b = Instance.new("TextButton")
        b.Size = size
        b.Position = pos
        b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35)
        b.TextColor3 = Color3.new(1, 1, 1) -- Teks putih polos
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 6.5
        b.ClipsDescendants = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        return b
    end

    -- Tombol Kunci Drag
    local LockDragBtn = createBtn("🔓", UDim2.new(0, 105, 0, 4), UDim2.new(0, 20, 0, 14), Color3.fromRGB(45, 45, 55))
    LockDragBtn.Parent = MainFrame
    LockDragBtn.TextSize = 10
    LockDragBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local function toggleLockDrag()
        Settings.DragLocked = not Settings.DragLocked
        LockDragBtn.Text = Settings.DragLocked and "🔒" or "🔓"
        LockDragBtn.TextColor3 = Settings.DragLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    end
    LockDragBtn.MouseButton1Click:Connect(toggleLockDrag)

    -- Tombol Info Panel
    local InfoBtn = createBtn("i", UDim2.new(0, 128, 0, 4), UDim2.new(0, 26, 0, 14), Color3.fromRGB(45, 45, 55))
    InfoBtn.Parent = MainFrame
    InfoBtn.TextSize = 8
    InfoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)

    -- [[ PANEL SOSIAL MEDIA ]]
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
    InfoStroke.Thickness = 1
    ApplyNeonStyle(InfoFrame, InfoStroke)

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12)
        l.Position = pos
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.new(1, 1, 1) -- Putih Polos
        l.Font = Enum.Font.GothamBold
        l.TextSize = 7
        return l
    end
    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5))

    local function createSocialBtn(name, link, pos, color)
        local b = createBtn(name, pos, UDim2.new(1, -10, 0, 18), color)
        b.Parent = InfoFrame
        b.TextSize = 6
        b.ZIndex = 11
        b.TextColor3 = Color3.new(1, 1, 1)
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

    local CloseInfo = createBtn("BACK TO MENU", UDim2.new(0, 5, 1, -22), UDim2.new(1, -10, 0, 18), Color3.fromRGB(40, 40, 45))
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

    -- ==========================================
    -- [[ DEKLARASI SISTEM TAB NAVIGASI ]]
    -- ==========================================
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, -12, 0, 18)
    TabBar.Position = UDim2.new(0, 6, 0, 21)
    TabBar.BackgroundTransparency = 1

    local TabButtons = {}
    local TabFrames = {}
    local CurrentTab = "Main"
    local TabNames = {"Main", "Combat", "ESP", "Utility"}
    local TabWidth = 1 / #TabNames

    ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -62)
    ContentFrame.Position = UDim2.new(0, 0, 0, 42)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false

    local function CreateTabFrame(name)
        local f = Instance.new("ScrollingFrame", ContentFrame)
        f.Size = UDim2.new(1, -12, 1, 0)
        f.Position = UDim2.new(0, 6, 0, 0)
        f.BackgroundTransparency = 1
        f.ScrollBarThickness = 2
        f.Visible = false
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

    for _, name in ipairs(TabNames) do 
        CreateTabFrame(name) 
    end

    local function ShowTab(tabName)
        CurrentTab = tabName
        for name, frame in pairs(TabFrames) do 
            frame.Visible = (name == tabName) 
        end
        for name, btn in pairs(TabButtons) do
            local isSelected = (name == tabName)
            btn.BackgroundColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 30)
            btn.TextColor3 = isSelected and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        end
    end

    for i, name in ipairs(TabNames) do
        local btn = Instance.new("TextButton", TabBar)
        btn.Size = UDim2.new(TabWidth, -1, 1, 0)
        btn.Position = UDim2.new((i - 1) * TabWidth, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Text = name:upper()
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 5.2
        btn.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        
        local TabStroke = Instance.new("UIStroke", btn)
        TabStroke.Thickness = 1
        ApplyNeonStyle(btn, TabStroke) -- Tab bar sinkronisasi pelangi neon

        TabButtons[name] = btn
        btn.MouseButton1Click:Connect(function() 
            ShowTab(name) 
        end)
    end
    ShowTab("Main")
-- ========================================================================
    -- [[ PEMASANGAN FITUR PADA MASING-MASING TAB ]]
    -- ========================================================================
    local elementCounter = 0
    local function addTabElement(tab, obj)
        elementCounter = elementCounter + 1
        obj.LayoutOrder = elementCounter
        obj.Parent = TabFrames[tab]
    end

    -- Fungsi Pembuat Group Container Box
    local function createGroupContainer(tab, titleText, boxHeight)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -4, 0, boxHeight)
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        container.BorderSizePixel = 0
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 5)
        
        local stroke = Instance.new("UIStroke", container)
        stroke.Thickness = 1
        ApplyNeonStyle(container, stroke) -- Stroke group container warna pelangi neon
        
        local title = Instance.new("TextLabel", container)
        title.Size = UDim2.new(1, -10, 0, 12)
        title.Position = UDim2.new(0, 6, 0, 2)
        title.BackgroundTransparency = 1
        title.Text = titleText:upper()
        title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih polos
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

    -- FUNGSI PEMBUAT SLIDER UNIVERSAL YANG SINKRON DENGAN TEMA WARNA NEON
    local function createSlider(parent, textFormat, minVal, maxVal, defaultVal, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, 12)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Instance.new("UICorner", sliderFrame)
        
        local sliderStroke = Instance.new("UIStroke", sliderFrame)
        sliderStroke.Thickness = 1
        ApplyNeonStyle(sliderFrame, sliderStroke) -- Slider border menyala pelangi neon

        local sliderFill = Instance.new("Frame", sliderFrame)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", sliderFill)
        
        local sliderText = Instance.new("TextLabel", sliderFrame)
        sliderText.Size = UDim2.new(1, 0, 1, 0)
        sliderText.BackgroundTransparency = 1
        sliderText.TextColor3 = Color3.new(1, 1, 1) -- Teks putih polos
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

    -- FUNGSI PEMBUAT TEXTBOX INPUT UNTUK PLAYER PICKER
    local function createTextBox(parent, placeholder, callback)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -10, 0, 14)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        box.TextColor3 = Color3.new(1, 1, 1) -- Teks putih polos
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        box.Text = ""
        box.Font = Enum.Font.GothamBold
        box.TextSize = 6.5
        Instance.new("UICorner", box)
        
        local boxStroke = Instance.new("UIStroke", box)
        boxStroke.Thickness = 1
        ApplyNeonStyle(box, boxStroke) -- Textbox border menyala pelangi neon

        box.FocusLost:Connect(function(enterPressed)
            callback(box.Text)
        end)
        
        box.Parent = parent
        return box
    end

    -- --- TAB 1: MAIN ---
    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Size = UDim2.new(1, -4, 0, 15)
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Text = "Welcome to Louis Hub, " .. LocalPlayer.Name
    WelcomeLabel.TextColor3 = Color3.new(1,1,1)
    WelcomeLabel.Font = Enum.Font.GothamMedium
    WelcomeLabel.TextSize = 7
    addTabElement("Main", WelcomeLabel)

    local InfoStatusLabel = Instance.new("TextLabel")
    InfoStatusLabel.Size = UDim2.new(1, -4, 0, 25)
    InfoStatusLabel.BackgroundTransparency = 1
    InfoStatusLabel.Text = "Status: ACTIVE\nPress 'L' button on left screen\nto hide/open this main UI window."
    InfoStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoStatusLabel.Font = Enum.Font.Gotham
    InfoStatusLabel.TextSize = 6.5
    addTabElement("Main", InfoStatusLabel)


    -- --- TAB 2: COMBAT ---
    
    -- BOX 1: KILL PLAYER (Murderer Only)
    local BoxKillPlayer = createGroupContainer("Combat", "Kill Player", 64)
    local KillAuraToggleBtn = createBtn("KILL AURA: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    KillAuraToggleBtn.Parent = BoxKillPlayer
    local KillAuraStroke = Instance.new("UIStroke", KillAuraToggleBtn)
    ApplyNeonStyle(KillAuraToggleBtn, KillAuraStroke)

    createSlider(BoxKillPlayer, "KA RADIUS: %d STUDS", 1, 50, Settings.KillAuraRadius, function(val)
        Settings.KillAuraRadius = val
    end)

    local KillAllBtn = createBtn("KILL ALL PLAYER (TP ALL)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(180, 0, 0))
    KillAllBtn.Parent = BoxKillPlayer
    local KillAllStroke = Instance.new("UIStroke", KillAllBtn)
    ApplyNeonStyle(KillAllBtn, KillAllStroke)


    -- BOX 2: AIM UTAMA & DETEKSI PISAU (Knife Aimbot Terintegrasi)
    local BoxAim = createGroupContainer("Combat", "Main Aim Mechanics", 100)
    local ToggleBtn = createBtn("[Q] AIMBOT: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ToggleBtn.Parent = BoxAim
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ApplyNeonStyle(ToggleBtn, ToggleStroke)

    local KnifeAimbotToggleBtn = createBtn("KNIFE AIMBOT: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    KnifeAimbotToggleBtn.Parent = BoxAim
    local KnifeAimbotStroke = Instance.new("UIStroke", KnifeAimbotToggleBtn)
    ApplyNeonStyle(KnifeAimbotToggleBtn, KnifeAimbotStroke)
    
    local ExtAimbotToggleBtn = createBtn("AIMBOT (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtAimbotToggleBtn.Parent = BoxAim
    local ExtAimbotToggleStroke = Instance.new("UIStroke", ExtAimbotToggleBtn)
    ApplyNeonStyle(ExtAimbotToggleBtn, ExtAimbotToggleStroke)

    createSlider(BoxAim, "BUTTON 'A' SIZE: %d", 20, 100, Settings.Size_A, function(val)
        Settings.Size_A = val
        updateExternalButtonSizes()
    end)


    -- BOX 3: TELEPORT TO ROLES (Sheriff & Murderer + External)
    local BoxTPRoles = createGroupContainer("Combat", "Teleport To Players", 118)
    local TPSheriffBtn = createBtn("TELEPORT TO SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TPSheriffBtn.Parent = BoxTPRoles
    local TPSheriffStroke = Instance.new("UIStroke", TPSheriffBtn)
    ApplyNeonStyle(TPSheriffBtn, TPSheriffStroke)

    local TPMurderBtn = createBtn("TELEPORT TO MURDERER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TPMurderBtn.Parent = BoxTPRoles
    local TPMurderStroke = Instance.new("UIStroke", TPMurderBtn)
    ApplyNeonStyle(TPMurderBtn, TPMurderStroke)

    local ExtTPSheriffToggleBtn = createBtn("TP SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtTPSheriffToggleBtn.Parent = BoxTPRoles
    local ExtTPSheriffToggleStroke = Instance.new("UIStroke", ExtTPSheriffToggleBtn)
    ApplyNeonStyle(ExtTPSheriffToggleBtn, ExtTPSheriffToggleStroke)

    local ExtTPMurderToggleBtn = createBtn("TP MURDER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtTPMurderToggleBtn.Parent = BoxTPRoles
    local ExtTPMurderToggleStroke = Instance.new("UIStroke", ExtTPMurderToggleBtn)
    ApplyNeonStyle(ExtTPMurderToggleBtn, ExtTPMurderToggleStroke)

    createSlider(BoxTPRoles, "TP BUTTONS SIZE: %d", 20, 100, Settings.Size_TPSheriff, function(val)
        Settings.Size_TPSheriff = val
        Settings.Size_TPMurder = val
        updateExternalButtonSizes()
    end)


    -- BOX 4: FIELD OF VIEW (FOV)
    local BoxFOV = createGroupContainer("Combat", "Field of View (FOV)", 82)
    local FOVHideBtn = createBtn("[P] HIDE FOV CIRCLE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FOVHideBtn.Parent = BoxFOV
    local FOVHideStroke = Instance.new("UIStroke", FOVHideBtn)
    ApplyNeonStyle(FOVHideBtn, FOVHideStroke)
    
    createSlider(BoxFOV, "FOV: %d RAD", 1, 200, Settings.FOVSize, function(val)
        Settings.FOVSize = val
    end)

    local CamFOVToggleBtn = createBtn("CAMERA FOV MODIFIER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    CamFOVToggleBtn.Parent = BoxFOV
    local CamFOVToggleStroke = Instance.new("UIStroke", CamFOVToggleBtn)
    ApplyNeonStyle(CamFOVToggleBtn, CamFOVToggleStroke)

    createSlider(BoxFOV, "CAM FOV: %d", 30, 120, Settings.CameraFOVValue, function(val)
        Settings.CameraFOVValue = val
    end)


    -- BOX 5: FLING SYSTEM & TOUCH FLING / ANTI-FLING (TERINTEGRASI DI FLING BOX)
    local BoxFling = createGroupContainer("Combat", "Fling Glitch System", 172)
    local FlingSheriffBtn = createBtn("AUTO FLING SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingSheriffBtn.Parent = BoxFling
    local FlingSheriffStroke = Instance.new("UIStroke", FlingSheriffBtn)
    ApplyNeonStyle(FlingSheriffBtn, FlingSheriffStroke)
    
    local FlingMurderBtn = createBtn("AUTO FLING MURDER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingMurderBtn.Parent = BoxFling
    local FlingMurderStroke = Instance.new("UIStroke", FlingMurderBtn)
    ApplyNeonStyle(FlingMurderBtn, FlingMurderStroke)

    local ExtFlingMurderToggleBtn = createBtn("FLING MURDER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtFlingMurderToggleBtn.Parent = BoxFling
    local ExtFlingMurderToggleStroke = Instance.new("UIStroke", ExtFlingMurderToggleBtn)
    ApplyNeonStyle(ExtFlingMurderToggleBtn, ExtFlingMurderToggleStroke)

    local ExtFlingSheriffToggleBtn = createBtn("FLING SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtFlingSheriffToggleBtn.Parent = BoxFling
    local ExtFlingSheriffToggleStroke = Instance.new("UIStroke", ExtFlingSheriffToggleBtn)
    ApplyNeonStyle(ExtFlingSheriffToggleBtn, ExtFlingSheriffToggleStroke)

    local AntiFlingToggleBtn = createBtn("ANTI FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiFlingToggleBtn.Parent = BoxFling
    local AntiFlingStroke = Instance.new("UIStroke", AntiFlingToggleBtn)
    ApplyNeonStyle(AntiFlingToggleBtn, AntiFlingStroke)

    local TouchFlingToggleBtn = createBtn("TOUCH FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TouchFlingToggleBtn.Parent = BoxFling
    local TouchFlingStroke = Instance.new("UIStroke", TouchFlingToggleBtn)
    ApplyNeonStyle(TouchFlingToggleBtn, TouchFlingStroke)

    createSlider(BoxFling, "TOUCH FLING POWER: %d", 1, 200, Settings.TouchFlingPower, function(val)
        Settings.TouchFlingPower = val
    end)

    createSlider(BoxFling, "FLING EXT BUTTONS SIZE: %d", 20, 100, Settings.Size_FlingMurder, function(val)
        Settings.Size_FlingMurder = val
        Settings.Size_FlingSheriff = val
        updateExternalButtonSizes()
    end)


    -- BOX 6: TARGETED PLAYER HACK (Pick Fling / Pick TP / TP Back)
    local BoxPlayerPicker = createGroupContainer("Combat", "Target Player Hack", 154)
    
    createTextBox(BoxPlayerPicker, "Enter Target Player Name...", function(text)
        Settings.TargetPlayerName = text
    end)

    local PickFlingBtn = createBtn("FLING TARGET PLAYER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    PickFlingBtn.Parent = BoxPlayerPicker
    local PickFlingStroke = Instance.new("UIStroke", PickFlingBtn)
    ApplyNeonStyle(PickFlingBtn, PickFlingStroke)

    local PickTPBtn = createBtn("TELEPORT TO TARGET PLAYER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    PickTPBtn.Parent = BoxPlayerPicker
    local PickTPStroke = Instance.new("UIStroke", PickTPBtn)
    ApplyNeonStyle(PickTPBtn, PickTPStroke)

    local ManualTPBackBtn = createBtn("TELEPORT BACK (PRE-FLING)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ManualTPBackBtn.Parent = BoxPlayerPicker
    local ManualTPBackStroke = Instance.new("UIStroke", ManualTPBackBtn)
    ApplyNeonStyle(ManualTPBackBtn, ManualTPBackStroke)

    local ExtTPBackToggleBtn = createBtn("TP BACK (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtTPBackToggleBtn.Parent = BoxPlayerPicker
    local ExtTPBackToggleStroke = Instance.new("UIStroke", ExtTPBackToggleBtn)
    ApplyNeonStyle(ExtTPBackToggleBtn, ExtTPBackToggleStroke)

    createSlider(BoxPlayerPicker, "TP BACK BUTTON SIZE: %d", 20, 100, Settings.Size_TPBack, function(val)
        Settings.Size_TPBack = val
        updateExternalButtonSizes()
    end)


    -- BOX 7: TELEPORT MAP STATIONS (Lobby & Underground + External)
    local BoxMapStations = createGroupContainer("Combat", "Teleport Map Stations", 118)
    local TPLobbyBtn = createBtn("TELEPORT TO LOBBY", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TPLobbyBtn.Parent = BoxMapStations
    local TPLobbyStroke = Instance.new("UIStroke", TPLobbyBtn)
    ApplyNeonStyle(TPLobbyBtn, TPLobbyStroke)

    local TPUndergroundBtn = createBtn("TELEPORT UNDERGROUND", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TPUndergroundBtn.Parent = BoxMapStations
    local TPUndergroundStroke = Instance.new("UIStroke", TPUndergroundBtn)
    ApplyNeonStyle(TPUndergroundBtn, TPUndergroundStroke)

    local ExtTPLobbyToggleBtn = createBtn("TP LOBBY (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtTPLobbyToggleBtn.Parent = BoxMapStations
    local ExtTPLobbyToggleStroke = Instance.new("UIStroke", ExtTPLobbyToggleBtn)
    ApplyNeonStyle(ExtTPLobbyToggleBtn, ExtTPLobbyToggleStroke)

    local ExtTPUndergroundToggleBtn = createBtn("TP UG (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtTPUndergroundToggleBtn.Parent = BoxMapStations
    local ExtTPUndergroundToggleStroke = Instance.new("UIStroke", ExtTPUndergroundToggleBtn)
    ApplyNeonStyle(ExtTPUndergroundToggleBtn, ExtTPUndergroundToggleStroke)

    createSlider(BoxMapStations, "MAP STATIONS BTN SIZE: %d", 20, 100, Settings.Size_TPLobby, function(val)
        Settings.Size_TPLobby = val
        Settings.Size_TPUnderground = val
        updateExternalButtonSizes()
    end)


    -- BOX 8: GRAB GUN SYSTEM
    local BoxGrab = createGroupContainer("Combat", "Gun Grabber System", 64)
    local GrabBtn = createBtn("[H] AUTO GRAB GUN: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    GrabBtn.Parent = BoxGrab
    local GrabStroke = Instance.new("UIStroke", GrabBtn)
    ApplyNeonStyle(GrabBtn, GrabStroke)
    
    local ManualGrabToggleBtn = createBtn("GRAB GUN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ManualGrabToggleBtn.Parent = BoxGrab
    local ManualGrabToggleStroke = Instance.new("UIStroke", ManualGrabToggleBtn)
    ApplyNeonStyle(ManualGrabToggleBtn, ManualGrabToggleStroke)

    createSlider(BoxGrab, "BUTTON 'G' SIZE: %d", 20, 100, Settings.Size_G, function(val)
        Settings.Size_G = val
        updateExternalButtonSizes()
    end)


    -- BOX 9: DOUBLE JUMP SYSTEM
    local BoxDoubleJump = createGroupContainer("Combat", "Double Jump System", 64)
    local DoubleJumpToggleBtn = createBtn("DOUBLE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpToggleBtn.Parent = BoxDoubleJump
    local DoubleJumpStroke = Instance.new("UIStroke", DoubleJumpToggleBtn)
    ApplyNeonStyle(DoubleJumpToggleBtn, DoubleJumpStroke)

    local DoubleJumpExtToggleBtn = createBtn("DOUBLE JUMP (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpExtToggleBtn.Parent = BoxDoubleJump
    local DoubleJumpExtToggleStroke = Instance.new("UIStroke", DoubleJumpExtToggleBtn)
    ApplyNeonStyle(DoubleJumpExtToggleBtn, DoubleJumpExtToggleStroke)

    createSlider(BoxDoubleJump, "BUTTON 'DJ' SIZE: %d", 20, 100, Settings.Size_DJ, function(val)
        Settings.Size_DJ = val
        updateExternalButtonSizes()
    end)


    -- --- TAB 3: ESP ---
    local BoxESP = createGroupContainer("ESP", "Visual & Hitbox Hack", 172)
    local EspBtn = createBtn("[X] ESP + GUN DROP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    EspBtn.Parent = BoxESP
    local EspStroke = Instance.new("UIStroke", EspBtn)
    ApplyNeonStyle(EspBtn, EspStroke)

    local TracersEspBtn = createBtn("TRACERS ESP LINE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TracersEspBtn.Parent = BoxESP
    local TracersEspStroke = Instance.new("UIStroke", TracersEspBtn)
    ApplyNeonStyle(TracersEspBtn, TracersEspStroke)

    local NameEspBtn = createBtn("NAME ESP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NameEspBtn.Parent = BoxESP
    local NameEspStroke = Instance.new("UIStroke", NameEspBtn)
    ApplyNeonStyle(NameEspBtn, NameEspStroke)

    local FilterMurderBtn = createBtn("FILTER: MURDERER (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 0, 0))
    FilterMurderBtn.Parent = BoxESP
    local FilterMurderStroke = Instance.new("UIStroke", FilterMurderBtn)
    ApplyNeonStyle(FilterMurderBtn, FilterMurderStroke)

    local FilterSheriffBtn = createBtn("FILTER: SHERIFF (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 0, 0))
    FilterSheriffBtn.Parent = BoxESP
    local FilterSheriffStroke = Instance.new("UIStroke", FilterSheriffBtn)
    ApplyNeonStyle(FilterSheriffBtn, FilterSheriffStroke)

    local FilterInnocentBtn = createBtn("FILTER: INNOCENT (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 0, 0))
    FilterInnocentBtn.Parent = BoxESP
    local FilterInnocentStroke = Instance.new("UIStroke", FilterInnocentBtn)
    ApplyNeonStyle(FilterInnocentBtn, FilterInnocentStroke)
    
    local HitboxBtn = createBtn("[C] HITBOX EXPANDER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    HitboxBtn.Parent = BoxESP
    local HitboxStroke = Instance.new("UIStroke", HitboxBtn)
    ApplyNeonStyle(HitboxBtn, HitboxStroke)
    
    local VisualBtn = createBtn("[V] HITBOX VISUAL: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(0, 120, 200))
    VisualBtn.Parent = BoxESP
    local VisualStroke = Instance.new("UIStroke", VisualBtn)
    ApplyNeonStyle(VisualBtn, VisualStroke)

    createSlider(BoxESP, "SIZE: %d STUDS", 1, 200, Settings.HitboxSize, function(val)
        Settings.HitboxSize = val
    end)


    -- --- TAB 4: UTILITY ---
    
    -- BOX 1: MASTER EXTERNAL CONTROLS (ON / OFF UNTUK SEMUA TOMBOL EKSTERNAL)
    local BoxMasterControls = createGroupContainer("Utility", "Master UI Controls", 28)
    local MasterExtToggleBtn = createBtn("EXTERNAL BUTTONS: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    MasterExtToggleBtn.Parent = BoxMasterControls
    local MasterExtStroke = Instance.new("UIStroke", MasterExtToggleBtn)
    ApplyNeonStyle(MasterExtToggleBtn, MasterExtStroke)


    -- BOX 2: SPIN & RAPID ENGINE UTILITY
    local BoxSpin = createGroupContainer("Utility", "Spin & Rapid Engine", 64)
    local SpinToggleBtn = createBtn("SPIN HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpinToggleBtn.Parent = BoxSpin
    local SpinStroke = Instance.new("UIStroke", SpinToggleBtn)
    ApplyNeonStyle(SpinToggleBtn, SpinStroke)

    local ExtSpinToggleBtn = createBtn("SPIN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtSpinToggleBtn.Parent = BoxSpin
    local ExtSpinToggleStroke = Instance.new("UIStroke", ExtSpinToggleBtn)
    ApplyNeonStyle(ExtSpinToggleBtn, ExtSpinToggleStroke)

    createSlider(BoxSpin, "SPIN POWER / SPEED: %d", 1, 200, Settings.SpinPower, function(val)
        Settings.SpinPower = val
    end)


    -- BOX 3: WALKSPEED MODIFIER
    local BoxSpeed = createGroupContainer("Utility", "Walkspeed Modifier", 46)
    local SpeedWalkBtn = createBtn("SPEED WALK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpeedWalkBtn.Parent = BoxSpeed
    local SpeedWalkStroke = Instance.new("UIStroke", SpeedWalkBtn)
    ApplyNeonStyle(SpeedWalkBtn, SpeedWalkStroke)
    
    createSlider(BoxSpeed, "SPEED: %d WS", 1, 100, Settings.SpeedWalkValue, function(val)
        Settings.SpeedWalkValue = val
    end)


    -- BOX 4: JUMP MODIFIER (DOUBLE JUMP & INFINITE JUMP)
    local BoxPlayerJump = createGroupContainer("Utility", "Jump Power Modifier", 64)
    local JumpToggleBtn = createBtn("JUMP HEIGHT MOD: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    JumpToggleBtn.Parent = BoxPlayerJump
    local JumpStroke = Instance.new("UIStroke", JumpToggleBtn)
    ApplyNeonStyle(JumpToggleBtn, JumpStroke)

    local InfiniteJumpToggleBtn = createBtn("INFINITE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InfiniteJumpToggleBtn.Parent = BoxPlayerJump
    local InfiniteJumpStroke = Instance.new("UIStroke", InfiniteJumpToggleBtn)
    ApplyNeonStyle(InfiniteJumpToggleBtn, InfiniteJumpStroke)

    createSlider(BoxPlayerJump, "JUMP POWER: %d", 50, 200, Settings.JumpPowerValue, function(val)
        Settings.JumpPowerValue = val
    end)


    -- BOX 5: FLY & NOCLIP
    local BoxFlyNoclip = createGroupContainer("Utility", "No Clip & Fly Hack", 64)
    local FlyToggleBtn = createBtn("FLY HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlyToggleBtn.Parent = BoxFlyNoclip
    local FlyStroke = Instance.new("UIStroke", FlyToggleBtn)
    ApplyNeonStyle(FlyToggleBtn, FlyStroke)

    createSlider(BoxFlyNoclip, "FLY SPEED: %d", 10, 150, Settings.FlySpeedValue, function(val)
        Settings.FlySpeedValue = val
    end)

    local NoclipToggleBtn = createBtn("NOCLIP (WALK THRU WALLS): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NoclipToggleBtn.Parent = BoxFlyNoclip
    local NoclipStroke = Instance.new("UIStroke", NoclipToggleBtn)
    ApplyNeonStyle(NoclipToggleBtn, NoclipStroke)


    -- BOX 6: SAFETY UTILITY (ANTI-VOID & INVISIBILITY)
    local BoxSafety = createGroupContainer("Utility", "Invisibility & Void Shield", 46)
    local InvisibleToggleBtn = createBtn("INVISIBLE HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InvisibleToggleBtn.Parent = BoxSafety
    local InvisibleStroke = Instance.new("UIStroke", InvisibleToggleBtn)
    ApplyNeonStyle(InvisibleToggleBtn, InvisibleStroke)

    local AntiVoidToggleBtn = createBtn("ANTI VOID SHIELD: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiVoidToggleBtn.Parent = BoxSafety
    local AntiVoidStroke = Instance.new("UIStroke", AntiVoidToggleBtn)
    ApplyNeonStyle(AntiVoidToggleBtn, AntiVoidStroke)


    -- BOX 7: FLOATING BUTTON 'L' SIZE SLIDER & ALL SLIDERS CONTROL
    local BoxUIControls = createGroupContainer("Utility", "UI Button Settings", 28)
    createSlider(BoxUIControls, "BUTTON 'L' SIZE: %d", 20, 100, Settings.Size_L, function(val)
        Settings.Size_L = val
        updateExternalButtonSizes()
    end)


    -- ========================================================================
    -- [[ CLOSING / OPENING BAR MAIN CONTROLLER ]]
    -- ========================================================================
    local CloseBar = createBtn("▼ OPEN MENU ▼", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16), Color3.new(0,0,0))
    CloseBar.Parent = MainFrame
    CloseBar.BackgroundTransparency = 1
    CloseBar.TextSize = 6

    CloseBar.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        MainFrame:TweenSize(isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205), "Out", "Quad", 0.25, true)
        CloseBar.Text = isMinimized and "▼ OPEN MENU ▼" or "▲ CLOSE MENU ▲"
        task.wait(0.2)
        ContentFrame.Visible = not isMinimized
    end)

    ToggleBtnMain.MouseButton1Click:Connect(function()
        MainVisible = not MainVisible
        if MainVisible then
            MainFrame.Visible = true
            HUDMain.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 160, 0, 58) or UDim2.new(0, 160, 0, 205)}):Play()
            UpdateExternalButtonsVisibility()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 160, 0, 0)})
            t:Play()
            t.Completed:Connect(function() 
                if not MainVisible then MainFrame.Visible = false end 
            end)
            HUDMain.Visible = false
            UpdateExternalButtonsVisibility()
        end
    end)

    -- Dynamic Graph FPS Engine
    task.spawn(function()
        local lastTime = tick()
        local frames = 0
        SafeConnect(RunService.RenderStepped, function()
            frames = frames + 1
            if tick() - lastTime >= 1 then
                FPSLabel.Text = "FPS: " .. frames
                PingLabel.Text = "PING: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms"
                for i = 1, 9 do 
                    pcall(function() 
                        bars[i].Size = bars[i+1].Size 
                        bars[i].Position = UDim2.new(0, i*3, 1, -bars[i].Size.Y.Offset) 
                    end) 
                end
                local newH = math.clamp(frames/3, 5, 30)
                pcall(function() 
                    bars[10].Size = UDim2.new(0, 2, 0, newH)
                    bars[10].Position = UDim2.new(0, 30, 1, -newH) 
                end)
                frames = 0
                lastTime = tick()
            end
        end)
    end)

    -- ========================================================================
    -- [[ FUNGSI AKSI & SISTEM TOGGLES ]]
    -- ========================================================================
    
    -- Master External Toggle
    local function toggleAllExternal()
        Settings.AllExtEnabled = not Settings.AllExtEnabled
        MasterExtToggleBtn.Text = Settings.AllExtEnabled and "EXTERNAL BUTTONS: ON" or "EXTERNAL BUTTONS: OFF"
        MasterExtToggleBtn.BackgroundColor3 = Settings.AllExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleKillAura()
        Settings.KillAuraEnabled = not Settings.KillAuraEnabled
        KillAuraToggleBtn.Text = Settings.KillAuraEnabled and "KILL AURA: ON" or "KILL AURA: OFF"
        KillAuraToggleBtn.BackgroundColor3 = Settings.KillAuraEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function syncAimbotVisual()
        ToggleBtn.Text = Settings.CameraAimbot and "[Q] AIMBOT: ON" or "[Q] AIMBOT: OFF"
        ToggleBtn.BackgroundColor3 = Settings.CameraAimbot and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        ExtAimbotBtn.BackgroundColor3 = Settings.CameraAimbot and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 25)
    end

    local function toggleAimbot()
        Settings.CameraAimbot = not Settings.CameraAimbot
        syncAimbotVisual()
    end

    local function toggleKnifeAimbot()
        Settings.AimbotKnifeEnabled = not Settings.AimbotKnifeEnabled
        KnifeAimbotToggleBtn.Text = Settings.AimbotKnifeEnabled and "KNIFE AIMBOT: ON" or "KNIFE AIMBOT: OFF"
        KnifeAimbotToggleBtn.BackgroundColor3 = Settings.AimbotKnifeEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleExtAimbotMaster()
        Settings.AimbotExtEnabled = not Settings.AimbotExtEnabled
        ExtAimbotToggleBtn.Text = Settings.AimbotExtEnabled and "AIMBOT (EXT): ON" or "AIMBOT (EXT): OFF"
        ExtAimbotToggleBtn.BackgroundColor3 = Settings.AimbotExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    -- Teleport Ke Role Tertentu
    local function GetPlayerByRole(roleName)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and GetMM2Role(p) == roleName then
                    return p
                end
            end
        end
        return nil
    end

    local function TeleportToRole(roleName)
        local target = GetPlayerByRole(roleName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            end
        end
    end

    local function toggleTPSheriffExt()
        Settings.TPSheriffExtEnabled = not Settings.TPSheriffExtEnabled
        ExtTPSheriffToggleBtn.Text = Settings.TPSheriffExtEnabled and "TP SHERIFF (EXT): ON" or "TP SHERIFF (EXT): OFF"
        ExtTPSheriffToggleBtn.BackgroundColor3 = Settings.TPSheriffExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleTPMurderExt()
        Settings.TPMurderExtEnabled = not Settings.TPMurderExtEnabled
        ExtTPMurderToggleBtn.Text = Settings.TPMurderExtEnabled and "TP MURDER (EXT): ON" or "TP MURDER (EXT): OFF"
        ExtTPMurderToggleBtn.BackgroundColor3 = Settings.TPMurderExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    -- Teleport Map Stations
    local function TeleportToLobby()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Koordinat lobby standar MM2
            root.CFrame = CFrame.new(-109, 138, 9)
        end
    end

    local function TeleportUnderground()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Teleport jauh di bawah map koordinat aman untuk menyelinap
            root.CFrame = root.CFrame * CFrame.new(0, -150, 0)
        end
    end

    local function toggleTPLobbyExt()
        Settings.AutoTPLobbyExtEnabled = not Settings.AutoTPLobbyExtEnabled
        ExtTPLobbyToggleBtn.Text = Settings.AutoTPLobbyExtEnabled and "TP LOBBY (EXT): ON" or "TP LOBBY (EXT): OFF"
        ExtTPLobbyToggleBtn.BackgroundColor3 = Settings.AutoTPLobbyExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleTPUndergroundExt()
        Settings.AutoTPUndergroundExtEnabled = not Settings.AutoTPUndergroundExtEnabled
        ExtTPUndergroundToggleBtn.Text = Settings.AutoTPUndergroundExtEnabled and "TP UG (EXT): ON" or "TP UG (EXT): OFF"
        ExtTPUndergroundToggleBtn.BackgroundColor3 = Settings.AutoTPUndergroundExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    -- Targeted Player Fling & TP
    local function GetTargetPlayerByName()
        local query = Settings.TargetPlayerName:lower()
        if query == "" then return nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name:lower():find(query) then
                return p
            end
        end
        return nil
    end

    local function ExecutePickTP()
        local target = GetTargetPlayerByName()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            end
        end
    end

    local function ExecutePickFling()
        local target = GetTargetPlayerByName()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                -- Backup CFrame sebelum memulai fling untuk sistem TP BACK
                OriginalCFrameBeforeFling = root.CFrame
                
                local tRoot = target.Character.HumanoidRootPart
                local duration = 0
                while duration < 2 do
                    if not target.Character or not tRoot then break end
                    root.CFrame = tRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                    root.Velocity = Vector3.new(99999, 99999, 99999)
                    task.wait(0.05)
                    duration = duration + 0.05
                end
                
                -- Kembalikan kecepatan ke normal
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
                task.wait(0.1)
                
                -- Auto TP ke lokasi sebelum fling jika data koordinat tersimpan
                if OriginalCFrameBeforeFling then
                    root.CFrame = OriginalCFrameBeforeFling
                end
            end
        end
    end

    local function ExecuteManualTPBack()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and OriginalCFrameBeforeFling then
            root.CFrame = OriginalCFrameBeforeFling
        end
    end

    local function toggleTPBackExt()
        Settings.TPBackExtEnabled = not Settings.TPBackExtEnabled
        ExtTPBackToggleBtn.Text = Settings.TPBackExtEnabled and "TP BACK (EXT): ON" or "TP BACK (EXT): OFF"
        ExtTPBackToggleBtn.BackgroundColor3 = Settings.TPBackExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    -- Visual & ESP Toggles
    local function toggleEsp()
        Settings.ESP = not Settings.ESP
        EspBtn.Text = Settings.ESP and "[X] ESP + GUN DROP: ON" or "[X] ESP + GUN DROP: OFF"
        EspBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        if not Settings.ESP then ClearGunOutlines() end
    end

    local function toggleTracersEsp()
        Settings.TracersESP = not Settings.TracersESP
        TracersEspBtn.Text = Settings.TracersESP and "TRACERS ESP LINE: ON" or "TRACERS ESP LINE: OFF"
        TracersEspBtn.BackgroundColor3 = Settings.TracersESP and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        if not Settings.TracersESP then ClearAllTracers() end
    end

    local function toggleNameEsp()
        Settings.NameESP = not Settings.NameESP
        NameEspBtn.Text = Settings.NameESP and "NAME ESP: ON" or "NAME ESP: OFF"
        NameEspBtn.BackgroundColor3 = Settings.NameESP and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleFilterMurder()
        Settings.EspMurderer = not Settings.EspMurderer
        FilterMurderBtn.Text = Settings.EspMurderer and "FILTER: MURDERER (ON)" or "FILTER: MURDERER (OFF)"
        FilterMurderBtn.BackgroundColor3 = Settings.EspMurderer and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        FilterMurderBtn.TextColor3 = Settings.EspMurderer and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleFilterSheriff()
        Settings.EspSheriff = not Settings.EspSheriff
        FilterSheriffBtn.Text = Settings.EspSheriff and "FILTER: SHERIFF (ON)" or "FILTER: SHERIFF (OFF)"
        FilterSheriffBtn.BackgroundColor3 = Settings.EspSheriff and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        FilterSheriffBtn.TextColor3 = Settings.EspSheriff and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleFilterInnocent()
        Settings.EspInnocent = not Settings.EspInnocent
        FilterInnocentBtn.Text = Settings.EspInnocent and "FILTER: INNOCENT (ON)" or "FILTER: INNOCENT (OFF)"
        FilterInnocentBtn.BackgroundColor3 = Settings.EspInnocent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        FilterInnocentBtn.TextColor3 = Settings.EspInnocent and Color3.new(0,0,0) or Color3.new(1,1,1)
    end

    local function toggleHitbox()
        Settings.HitboxExpander = not Settings.HitboxExpander
        HitboxBtn.Text = Settings.HitboxExpander and "[C] HITBOX EXPANDER: ON" or "[C] HITBOX EXPANDER: OFF"
        HitboxBtn.BackgroundColor3 = Settings.HitboxExpander and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAutoGrab()
        Settings.AutoGrabGun = not Settings.AutoGrabGun
        GrabBtn.Text = Settings.AutoGrabGun and "[H] AUTO GRAB GUN: ON" or "[H] AUTO GRAB GUN: OFF"
        GrabBtn.BackgroundColor3 = Settings.AutoGrabGun and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleManualGrabMaster()
        Settings.GrabGunExtEnabled = not Settings.GrabGunExtEnabled
        ManualGrabToggleBtn.Text = Settings.GrabGunExtEnabled and "GRAB GUN (EXT): ON" or "GRAB GUN (EXT): OFF"
        ManualGrabToggleBtn.BackgroundColor3 = Settings.GrabGunExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
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
        FOVHideBtn.BackgroundColor3 = Settings.HideFOVCircle and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleCameraFOV()
        Settings.CameraFOVEnabled = not Settings.CameraFOVEnabled
        CamFOVToggleBtn.Text = Settings.CameraFOVEnabled and "CAMERA FOV MODIFIER: ON" or "CAMERA FOV MODIFIER: OFF"
        CamFOVToggleBtn.BackgroundColor3 = Settings.CameraFOVEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    -- Spin & Utility Toggles
    local function toggleSpin()
        Settings.SpinEnabled = not Settings.SpinEnabled
        SpinToggleBtn.Text = Settings.SpinEnabled and "SPIN HACK: ON" or "SPIN HACK: OFF"
        SpinToggleBtn.BackgroundColor3 = Settings.SpinEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        ExtSpinBtn.BackgroundColor3 = Settings.SpinEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 25)
    end

    local function toggleSpinExt()
        Settings.SpinExtEnabled = not Settings.SpinExtEnabled
        ExtSpinToggleBtn.Text = Settings.SpinExtEnabled and "SPIN (EXT): ON" or "SPIN (EXT): OFF"
        ExtSpinToggleBtn.BackgroundColor3 = Settings.SpinExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleFly()
        Settings.FlyEnabled = not Settings.FlyEnabled
        FlyToggleBtn.Text = Settings.FlyEnabled and "FLY HACK: ON" or "FLY HACK: OFF"
        FlyToggleBtn.BackgroundColor3 = Settings.FlyEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleJumpHeight()
        Settings.JumpPowerEnabled = not Settings.JumpPowerEnabled
        JumpToggleBtn.Text = Settings.JumpPowerEnabled and "JUMP HEIGHT MOD: ON" or "JUMP HEIGHT MOD: OFF"
        JumpToggleBtn.BackgroundColor3 = Settings.JumpPowerEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleInfiniteJump()
        Settings.InfiniteJumpEnabled = not Settings.InfiniteJumpEnabled
        InfiniteJumpToggleBtn.Text = Settings.InfiniteJumpEnabled and "INFINITE JUMP: ON" or "INFINITE JUMP: OFF"
        InfiniteJumpToggleBtn.BackgroundColor3 = Settings.InfiniteJumpEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleNoclip()
        Settings.NoclipEnabled = not Settings.NoclipEnabled
        NoclipToggleBtn.Text = Settings.NoclipEnabled and "NOCLIP: ON" or "NOCLIP (WALK THRU WALLS): OFF"
        NoclipToggleBtn.BackgroundColor3 = Settings.NoclipEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleInvisible()
        Settings.InvisibleEnabled = not Settings.InvisibleEnabled
        InvisibleToggleBtn.Text = Settings.InvisibleEnabled and "INVISIBLE HACK: ON" or "INVISIBLE HACK: OFF"
        InvisibleToggleBtn.BackgroundColor3 = Settings.InvisibleEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        
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

    local function toggleAntiVoid()
        Settings.AntiVoidEnabled = not Settings.AntiVoidEnabled
        AntiVoidToggleBtn.Text = Settings.AntiVoidEnabled and "ANTI VOID SHIELD: ON" or "ANTI VOID SHIELD: OFF"
        AntiVoidToggleBtn.BackgroundColor3 = Settings.AntiVoidEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleAntiFling()
        Settings.AntiFlingEnabled = not Settings.AntiFlingEnabled
        AntiFlingToggleBtn.Text = Settings.AntiFlingEnabled and "ANTI FLING: ON" or "ANTI FLING: OFF"
        AntiFlingToggleBtn.BackgroundColor3 = Settings.AntiFlingEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    local function toggleTouchFling()
        Settings.TouchFlingEnabled = not Settings.TouchFlingEnabled
        TouchFlingToggleBtn.Text = Settings.TouchFlingEnabled and "TOUCH FLING: ON" or "TOUCH FLING: OFF"
        TouchFlingToggleBtn.BackgroundColor3 = Settings.TouchFlingEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
    end

    -- SINKRONISASI FLING BUTTONS
    _G.SyncFlingButtons = function()
        FlingMurderBtn.Text = Settings.AutoFlingMurder and "FLING MURDER: ON" or "AUTO FLING MURDER"
        FlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        FlingSheriffBtn.Text = Settings.AutoFlingSheriff and "FLING SHERIFF: ON" or "AUTO FLING SHERIFF"
        FlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        
        ExtFlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 25)
        ExtFlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 25)
    end

    local function toggleFlingMurder()
        Settings.AutoFlingMurder = not Settings.AutoFlingMurder
        if Settings.AutoFlingMurder then 
            Settings.AutoFlingSheriff = false 
        end
        _G.SyncFlingButtons()
    end

    local function toggleFlingSheriff()
        Settings.AutoFlingSheriff = not Settings.AutoFlingSheriff
        if Settings.AutoFlingSheriff then 
            Settings.AutoFlingMurder = false 
        end
        _G.SyncFlingButtons()
    end

    local function toggleFlingMurderExt()
        Settings.FlingMurderExtEnabled = not Settings.FlingMurderExtEnabled
        ExtFlingMurderToggleBtn.Text = Settings.FlingMurderExtEnabled and "FLING MURDER (EXT): ON" or "FLING MURDER (EXT): OFF"
        ExtFlingMurderToggleBtn.BackgroundColor3 = Settings.FlingMurderExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleFlingSheriffExt()
        Settings.FlingSheriffExtEnabled = not Settings.FlingSheriffExtEnabled
        ExtFlingSheriffToggleBtn.Text = Settings.FlingSheriffExtEnabled and "FLING SHERIFF (EXT): ON" or "FLING SHERIFF (EXT): OFF"
        ExtFlingSheriffToggleBtn.BackgroundColor3 = Settings.FlingSheriffExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    local function toggleSpeedWalk()
        Settings.SpeedWalkEnabled = not Settings.SpeedWalkEnabled
        SpeedWalkBtn.Text = Settings.SpeedWalkEnabled and "SPEED WALK: ON" or "SPEED WALK: OFF"
        SpeedWalkBtn.BackgroundColor3 = Settings.SpeedWalkEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        if not Settings.SpeedWalkEnabled then 
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) 
        end
    end

    local function toggleDoubleJump()
        Settings.DoubleJumpEnabled = not Settings.DoubleJumpEnabled
        DoubleJumpToggleBtn.Text = Settings.DoubleJumpEnabled and "DOUBLE JUMP: ON" or "DOUBLE JUMP: OFF"
        DoubleJumpToggleBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        
        ExtDoubleJumpBtn.BackgroundColor3 = Settings.DoubleJumpEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 25)
    end

    local function toggleDoubleJumpExt()
        Settings.DoubleJumpExtEnabled = not Settings.DoubleJumpExtEnabled
        DoubleJumpExtToggleBtn.Text = Settings.DoubleJumpExtEnabled and "DOUBLE JUMP (EXT): ON" or "DOUBLE JUMP (EXT): OFF"
        DoubleJumpExtToggleBtn.BackgroundColor3 = Settings.DoubleJumpExtEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 35)
        UpdateExternalButtonsVisibility()
    end

    -- ==========================================
    -- [[ KONEKSI EVENT KE TOMBOL-TOMBOL FITUR ]]
    -- ==========================================
    
    -- Tab Combat Toggles & Buttons
    KillAuraToggleBtn.MouseButton1Click:Connect(toggleKillAura)
    KillAllBtn.MouseButton1Click:Connect(TeleportAllPlayersToMe)

    ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
    KnifeAimbotToggleBtn.MouseButton1Click:Connect(toggleKnifeAimbot)
    ExtAimbotToggleBtn.MouseButton1Click:Connect(toggleExtAimbotMaster)
    ExtAimbotBtn.MouseButton1Click:Connect(toggleAimbot)

    TPSheriffBtn.MouseButton1Click:Connect(function() TeleportToRole("Sheriff") end)
    TPMurderBtn.MouseButton1Click:Connect(function() TeleportToRole("Murderer") end)
    ExtTPSheriffToggleBtn.MouseButton1Click:Connect(toggleTPSheriffExt)
    ExtTPMurderToggleBtn.MouseButton1Click:Connect(toggleTPMurderExt)
    ExtTPSheriffBtn.MouseButton1Click:Connect(function() TeleportToRole("Sheriff") end)
    ExtTPMurderBtn.MouseButton1Click:Connect(function() TeleportToRole("Murderer") end)

    FOVHideBtn.MouseButton1Click:Connect(toggleHideFOV)
    CamFOVToggleBtn.MouseButton1Click:Connect(toggleCameraFOV)

    FlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)
    FlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)
    ExtFlingMurderToggleBtn.MouseButton1Click:Connect(toggleFlingMurderExt)
    ExtFlingSheriffToggleBtn.MouseButton1Click:Connect(toggleFlingSheriffExt)
    ExtFlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)
    ExtFlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)
    AntiFlingToggleBtn.MouseButton1Click:Connect(toggleAntiFling)
    TouchFlingToggleBtn.MouseButton1Click:Connect(toggleTouchFling)

    PickFlingBtn.MouseButton1Click:Connect(ExecutePickFling)
    PickTPBtn.MouseButton1Click:Connect(ExecutePickTP)
    ManualTPBackBtn.MouseButton1Click:Connect(ExecuteManualTPBack)
    ExtTPBackToggleBtn.MouseButton1Click:Connect(toggleTPBackExt)
    ExtTPBackBtn.MouseButton1Click:Connect(ExecuteManualTPBack)

    TPLobbyBtn.MouseButton1Click:Connect(TeleportToLobby)
    TPUndergroundBtn.MouseButton1Click:Connect(TeleportUnderground)
    ExtTPLobbyToggleBtn.MouseButton1Click:Connect(toggleTPLobbyExt)
    ExtTPUndergroundToggleBtn.MouseButton1Click:Connect(toggleTPUndergroundExt)
    ExtTPLobbyBtn.MouseButton1Click:Connect(TeleportToLobby)
    ExtTPUndergroundBtn.MouseButton1Click:Connect(TeleportUnderground)

    GrabBtn.MouseButton1Click:Connect(toggleAutoGrab) 
    ManualGrabToggleBtn.MouseButton1Click:Connect(toggleManualGrabMaster)
    ExtGrabBtn.MouseButton1Click:Connect(executeManualGrab)

    DoubleJumpToggleBtn.MouseButton1Click:Connect(toggleDoubleJump)
    DoubleJumpExtToggleBtn.MouseButton1Click:Connect(toggleDoubleJumpExt)
    ExtDoubleJumpBtn.MouseButton1Click:Connect(toggleDoubleJump)

    -- Tab ESP Toggles
    EspBtn.MouseButton1Click:Connect(toggleEsp)
    TracersEspBtn.MouseButton1Click:Connect(toggleTracersEsp)
    NameEspBtn.MouseButton1Click:Connect(toggleNameEsp)
    FilterMurderBtn.MouseButton1Click:Connect(toggleFilterMurder)
    FilterSheriffBtn.MouseButton1Click:Connect(toggleFilterSheriff)
    FilterInnocentBtn.MouseButton1Click:Connect(toggleFilterInnocent)
    HitboxBtn.MouseButton1Click:Connect(toggleHitbox)
    
    VisualBtn.MouseButton1Click:Connect(function()
        Settings.HitboxVisual = not Settings.HitboxVisual
        VisualBtn.Text = Settings.HitboxVisual and "[V] HITBOX VISUAL: ON" or "[V] HITBOX VISUAL: OFF"
        VisualBtn.BackgroundColor3 = Settings.HitboxVisual and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 35)
    end)

    -- Tab Utility Toggles
    MasterExtToggleBtn.MouseButton1Click:Connect(toggleAllExternal)

    SpinToggleBtn.MouseButton1Click:Connect(toggleSpin)
    ExtSpinToggleBtn.MouseButton1Click:Connect(toggleSpinExt)
    ExtSpinBtn.MouseButton1Click:Connect(toggleSpin)

    SpeedWalkBtn.MouseButton1Click:Connect(toggleSpeedWalk)
    FlyToggleBtn.MouseButton1Click:Connect(toggleFly)
    JumpToggleBtn.MouseButton1Click:Connect(toggleJumpHeight)
    InfiniteJumpToggleBtn.MouseButton1Click:Connect(toggleInfiniteJump)
    NoclipToggleBtn.MouseButton1Click:Connect(toggleNoclip)
    InvisibleToggleBtn.MouseButton1Click:Connect(toggleInvisible)
    AntiVoidToggleBtn.MouseButton1Click:Connect(toggleAntiVoid)

    local potatoEnabled = false
    PotatoToggle.MouseButton1Click:Connect(function()
        potatoEnabled = not potatoEnabled
        if potatoEnabled then
            ApplyPotato()
            PotatoToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
    SafeConnect(MainFrame.InputBegan, function(i) 
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then 
            dragging = true
            dragStart = i.Position
            startPos = MainFrame.Position 
        end 
    end)
    SafeConnect(UserInputService.InputChanged, function(i) 
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local d = i.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) 
        end 
    end)
    SafeConnect(UserInputService.InputEnded, function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end 
    end)

    startLoading()
    print("Louis Hub FREE V14.0.1: Premium Updates & Dynamic Rainbow Sync Fully Rebuilt.")
end
