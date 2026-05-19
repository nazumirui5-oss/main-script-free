-- [[ LOUIS HUB FREE - INTEGRATED & PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 13.5.2 (Security Sync Update - MM2 Edition Fixed Click)

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
    local Mouse = LocalPlayer:GetMouse()

    -- Konfigurasi Fitur Internal (MM2)
    local Settings = {
        CameraAimbot = false,
        SilentAim = false,
        HitboxExpander = false,
        HitboxVisual = true,
        ESP = false,
        AutoGrabGun = false, 
        TargetPart = "HumanoidRootPart",
        HitboxSize = 20,
        FOVSize = 150,
        HideFOVCircle = false,
        AutoFlingMurder = false,
        AutoFlingSheriff = false,
        SpeedWalkEnabled = false,
        SpeedWalkValue = 16
    }

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

    -- Forward declaration komponen UI agar sinkron dengan loader exit
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
                    MainFrame.Size = UDim2.new(0, 140, 0, 0)
                    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Out, Enum.EasingDirection.Quad), {Size = UDim2.new(0, 140, 0, 58)}):Play()
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
    -- [[ LOGIKA EMULASI TEKNIS AIMBOT & ROLE DETECTION (MM2) ]]
    -- ========================================================================
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Color = Color3.fromRGB(255, 0, 255)
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 60
    FOVCircle.Radius = Settings.FOVSize
    FOVCircle.Filled = false
    FOVCircle.Visible = false

    RunService.RenderStepped:Connect(function()
        if (Settings.CameraAimbot or Settings.SilentAim) and not Settings.HideFOVCircle then
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

    local function GetMurdererTarget()
        local Target = nil
        local ShortestDistance = math.huge
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Root = v.Character:FindFirstChild("HumanoidRootPart")
                local Hum = v.Character:FindFirstChildOfClass("Humanoid")
                local ESP = v.Character:FindFirstChild("MM2_ESP")
                
                if Root and Hum and Hum.Health > 0 and ESP and ESP.FillColor == Color3.fromRGB(255, 0, 0) then
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
        return Target
    end

    local function GetInnocentOrSheriffTarget()
        local Target = nil
        local ShortestDistance = math.huge
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local Root = v.Character:FindFirstChild("HumanoidRootPart")
                local Hum = v.Character:FindFirstChildOfClass("Humanoid")
                local ESP = v.Character:FindFirstChild("MM2_ESP")
                
                if Root and Hum and Hum.Health > 0 and (not ESP or ESP.FillColor ~= Color3.fromRGB(255, 0, 0)) then
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
        return Target
    end

    RunService.RenderStepped:Connect(function()
        if Settings.CameraAimbot and LocalPlayer.Character then
            local MyRole = GetMM2Role(LocalPlayer)
            
            if MyRole == "Murderer" then
                local TargetPart = GetInnocentOrSheriffTarget()
                if TargetPart then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, TargetPart.Position)
                end
            else
                local TargetPart = GetMurdererTarget()
                if TargetPart then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, TargetPart.Position)
                end
            end
        end
    end)

    -- ========================================================================
    -- [[ FIXED INTEGRATION SILENT AIM: RE-HOOK ENGINE ]]
    -- ========================================================================
    local MainMetatable = getrawmetatable(game)
    local OldIndex = MainMetatable.__index
    local OldNewIndex = MainMetatable.__newindex
    local OldNamecall = MainMetatable.__namecall
    setreadonly(MainMetatable, false)

    local function GetClosestTargetForSilentAim()
        local Target = nil
        local ShortestDistance = math.huge
        local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local MyRole = GetMM2Role(LocalPlayer)

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local Root = v.Character.HumanoidRootPart
                local Hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if Hum and Hum.Health > 0 then
                    local TargetRole = GetMM2Role(v)
                    local IsValidTarget = false
                    
                    if MyRole == "Murderer" and TargetRole ~= "Murderer" then
                        IsValidTarget = true
                    elseif MyRole == "Sheriff" and TargetRole == "Murderer" then
                        IsValidTarget = true
                    elseif MyRole == "Innocent" and TargetRole == "Murderer" then
                        IsValidTarget = true
                    end
                    
                    if IsValidTarget then
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

    MainMetatable.__namecall = newcclosure(function(Self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        
        if Settings.SilentAim and not checkcaller() then
            if Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" or Method == "FireServer" then
                local TargetPart = GetClosestTargetForSilentAim()
                if TargetPart then
                    if Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" then
                        local Origin = Args[1].Origin
                        local Direction = (TargetPart.Position - Origin).Unit * 1000
                        Args[1] = Ray.new(Origin, Direction)
                        return OldNamecall(Self, unpack(Args))
                    end
                end
            end
        end
        return OldNamecall(Self, ...)
    end)

    MainMetatable.__index = newcclosure(function(Self, Key)
        if Settings.SilentAim and not checkcaller() then
            if Self == Mouse and (Key == "Hit" or Key == "Target") then
                local TargetPart = GetClosestTargetForSilentAim()
                if TargetPart then
                    if Key == "Hit" then
                        return TargetPart.CFrame + Vector3.new(math.random(-1,1)/100, 0, math.random(-1,1)/100)
                    elseif Key == "Target" then
                        return TargetPart
                    end
                end
            end
        end
        return OldIndex(Self, Key)
    end)

    setreadonly(MainMetatable, true)

    -- [[ CLICK TRIGGER ENGINE: MEMAKSA SENJATA MM2 MENEMBAK ]]
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Settings.SilentAim then
            local char = LocalPlayer.Character
            local gun = char and char:FindFirstChild("Gun")
            if gun and gun:FindFirstChild("KnifeServer") and gun.KnifeServer:FindFirstChild("ShootGun") then
                local TargetPart = GetClosestTargetForSilentAim()
                if TargetPart then
                    -- Trigger remote tembakan bawaan MM2 langsung ke server dengan kalkulasi offset target part
                    gun.KnifeServer.ShootGun:InvokeServer({
                        ["Normal"] = Vector3.new(0, 1, 0),
                        ["Direction"] = (TargetPart.Position - char.HumanoidRootPart.Position).Unit,
                        ["Position"] = TargetPart.Position,
                        ["Hit"] = TargetPart
                    })
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character.Humanoid
            if hum.FloorMaterial == Enum.Material.Air and root.Velocity.Magnitude > 100 and not Settings.AutoFlingMurder and not Settings.AutoFlingSheriff then 
                root.Velocity = root.Velocity.Unit * 100 
            end
        end
    end)

    -- ========================================================================
    -- [[ REVOLUTIONARY UPDATE: INSTANT TELEPORT, NOCLIP & RETURN ENGINE ]]
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
            noclipConnection = RunService.Stepped:Connect(function()
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
            while timeout < 1.5 and Settings.AutoGrabGun do
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
    -- [[ FLING ENGINE & SPEEDWALK LISTENER ]]
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

    task.spawn(function()
        while true do
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                if Settings.SpeedWalkEnabled then
                    humanoid.WalkSpeed = Settings.SpeedWalkValue
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
                            
                            _G.SyncFlingButtons()
                        end
                    end
                end
            end
            task.wait()
        end
    end)

    -- ========================================================================
    -- LOOPING RENDER: HITBOX EXPANDER DAN ESP OUTLINE SYSTEM
    -- ========================================================================
    RunService.RenderStepped:Connect(function()
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Root = Player.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                
                if Root and Humanoid and Humanoid.Health > 0 then
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

                    local Highlight = Player.Character:FindFirstChild("MM2_ESP")
                    if Settings.ESP then
                        if not Highlight then
                            Highlight = Instance.new("Highlight")
                            Highlight.Name = "MM2_ESP"
                            Highlight.Parent = Player.Character
                            Highlight.FillTransparency = 0.6
                            Highlight.OutlineTransparency = 0.1
                        end
                        
                        local Role = GetMM2Role(Player)
                        if Role == "Murderer" then
                            Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                        elseif Role == "Sheriff" then
                            Highlight.FillColor = Color3.fromRGB(0, 0, 225)
                            Highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
                        else
                            Highlight.FillColor = Color3.fromRGB(0, 225, 0)
                            Highlight.OutlineColor = Color3.fromRGB(0, 225, 0)
                        end
                    else
                        if Highlight then Highlight:Destroy() end
                    end
                end
            elseif Player.Character and Player.Character:FindFirstChild("MM2_ESP") then
                Player.Character:FindFirstChild("MM2_ESP"):Destroy()
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

    -- [[ FLOATING TOGGLE (L BUTTON) ]]
    ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = _GAccentColor
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    ToggleBtnMain.Visible = false 

    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Color = _GAccentColor
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local t_dragging, t_dragStart, t_startPos
    ToggleBtnMain.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then t_dragging = true; t_dragStart = i.Position; t_startPos = ToggleBtnMain.Position end end)
    UserInputService.InputChanged:Connect(function(i) if t_dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - t_dragStart; ToggleBtnMain.Position = UDim2.new(t_startPos.X.Scale, t_startPos.X.Offset + d.X, t_startPos.Y.Scale, t_startPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then t_dragging = false end end)

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

    -- [[ MAIN FRAME SETUP ]]
    MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 140, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
    MainFrame.BackgroundColor3 = _GMainColor; MainFrame.Active = true; MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = _GAccentColor; Stroke.Thickness = 1.5

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
    HubLabel.TextColor3 = _GAccentColor; HubLabel.TextSize = 6.5

    local ToggleBtn = createBtn("[Q] AIMBOT: OFF", UDim2.new(0, 6, 0, 18), UDim2.new(0, 98, 0, 20))

    -- [[ MENU INFO & SOSMED ]]
    local InfoBtn = createBtn("i", UDim2.new(0, 108, 0, 18), UDim2.new(0, 26, 0, 20), Color3.fromRGB(45, 45, 55))
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
    InfoStroke.Color = _GAccentColor
    InfoStroke.Thickness = 1

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12); l.Position = pos
        l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = color or Color3.new(1,1,1)
        l.TextSize = 7; l.Font = Enum.Font.GothamBold; return l
    end

    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5), _GAccentColor)

    local function createSocialBtn(name, link, pos, color)
        local b = createBtn(name, pos, UDim2.new(1, -10, 0, 18), color)
        b.Parent = InfoFrame; b.TextSize = 6; b.ZIndex = 11
        b.MouseButton1Click:Connect(function()
            setclipboard(link)
            local oldText = b.Text; b.Text = "COPIED TO CLIPBOARD!"; task.wait(1.5); b.Text = oldText
        end)
    end

    createSocialBtn("DISCORD SERVER", "https://discord.gg/sE7G9nGqb", UDim2.new(0, 5, 0, 25), Color3.fromRGB(88, 101, 242))
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

    ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, 0, 1, -45); ContentFrame.Position = UDim2.new(0, 0, 0, 45); ContentFrame.BackgroundTransparency = 1; ContentFrame.Visible = false

    -- [[ STRUKTUR MENU HUD WITH TOGGLES ]]
    local SilentAimBtn = createBtn("[Z] SILENT AIM: OFF", UDim2.new(0, 6, 0, 0), UDim2.new(0, 128, 0, 18)); SilentAimBtn.Parent = ContentFrame
    local EspBtn = createBtn("[X] ESP + GUN DROP: OFF", UDim2.new(0, 6, 0, 21), UDim2.new(0, 128, 0, 18)); EspBtn.Parent = ContentFrame
    local HitboxBtn = createBtn("[C] HITBOX EXPANDER: OFF", UDim2.new(0, 6, 0, 42), UDim2.new(0, 128, 0, 18)); HitboxBtn.Parent = ContentFrame
    local VisualBtn = createBtn("[V] HITBOX VISUAL: ON", UDim2.new(0, 6, 0, 63), UDim2.new(0, 128, 0, 18), Color3.fromRGB(0, 120, 200)); VisualBtn.Parent = ContentFrame
    local GrabBtn = createBtn("[H] AUTO GRAB GUN: OFF", UDim2.new(0, 6, 0, 84), UDim2.new(0, 128, 0, 18)); GrabBtn.Parent = ContentFrame 
    local FOVHideBtn = createBtn("[P] HIDE FOV CIRCLE: OFF", UDim2.new(0, 6, 0, 105), UDim2.new(0, 128, 0, 18)); FOVHideBtn.Parent = ContentFrame

    createLine(UDim2.new(0, 6, 0, 127)).Parent = ContentFrame 
    createLabel("FLING & SPEED FEATURES", UDim2.new(0, 6, 0, 131)).Parent = ContentFrame
    
    local FlingMurderBtn = createBtn("AUTO FLING MURDER", UDim2.new(0, 6, 0, 142), UDim2.new(0, 62, 0, 18)); FlingMurderBtn.Parent = ContentFrame
    local FlingSheriffBtn = createBtn("AUTO FLING SHERIFF", UDim2.new(0, 72, 0, 142), UDim2.new(0, 62, 0, 18)); FlingSheriffBtn.Parent = ContentFrame
    local SpeedWalkBtn = createBtn("SPEED WALK: OFF", UDim2.new(0, 6, 0, 163), UDim2.new(0, 128, 0, 18)); SpeedWalkBtn.Parent = ContentFrame

    -- [[ SPEED WALK SLIDER CONFIG ]]
    createLabel("SPEED WALK VALUE CONFIG", UDim2.new(0, 6, 0, 184)).Parent = ContentFrame
    local SpeedSliderFrame = Instance.new("Frame", ContentFrame); SpeedSliderFrame.Size = UDim2.new(0, 128, 0, 12); SpeedSliderFrame.Position = UDim2.new(0, 6, 0, 195); SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", SpeedSliderFrame)
    local SpeedSliderFill = Instance.new("Frame", SpeedSliderFrame); SpeedSliderFill.BackgroundColor3 = _GAccentColor; Instance.new("UICorner", SpeedSliderFill)
    local SpeedSliderText = Instance.new("TextLabel", SpeedSliderFrame); SpeedSliderText.Size = UDim2.new(1, 0, 1, 0); SpeedSliderText.BackgroundTransparency = 1; SpeedSliderText.TextColor3 = Color3.new(1, 1, 1); SpeedSliderText.TextSize = 7; SpeedSliderText.Font = Enum.Font.GothamBold

    local function syncSpeedSlider(val)
        SpeedSliderFill.Size = UDim2.new(math.clamp((val - 1) / 99, 0, 1), 0, 1, 0); SpeedSliderText.Text = string.format("SPEED: %d WS", val)
    end
    syncSpeedSlider(Settings.SpeedWalkValue)

    local SpeedSliderButton = Instance.new("TextButton", SpeedSliderFrame)
    SpeedSliderButton.Size = UDim2.new(1, 0, 1, 0); SpeedSliderButton.BackgroundTransparency = 1; SpeedSliderButton.Text = ""

    local function UpdateSpeedSlider()
        local Percentage = math.clamp((Mouse.X - SpeedSliderFrame.AbsolutePosition.X) / SpeedSliderFrame.AbsoluteSize.X, 0, 1)
        Settings.SpeedWalkValue = math.floor(1 + (Percentage * 99))
        syncSpeedSlider(Settings.SpeedWalkValue)
    end

    local SpeedSliderConnection = nil
    SpeedSliderButton.MouseButton1Down:Connect(function()
        UpdateSpeedSlider()
        SpeedSliderConnection = RunService.RenderStepped:Connect(UpdateSpeedSlider)
    end)

    -- [[ HITBOX SLIDER CONFIG ]]
    createLine(UDim2.new(0, 6, 0, 212)).Parent = ContentFrame
    createLabel("HITBOX SIZE CONFIG", UDim2.new(0, 6, 0, 216)).Parent = ContentFrame
    
    local SliderFrame = Instance.new("Frame", ContentFrame); SliderFrame.Size = UDim2.new(0, 128, 0, 12); SliderFrame.Position = UDim2.new(0, 6, 0, 227); SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", SliderFrame)
    local SliderFill = Instance.new("Frame", SliderFrame); SliderFill.BackgroundColor3 = _GAccentColor; Instance.new("UICorner", SliderFill)
    local SliderText = Instance.new("TextLabel", SliderFrame); SliderText.Size = UDim2.new(1, 0, 1, 0); SliderText.BackgroundTransparency = 1; SliderText.TextColor3 = Color3.new(1, 1, 1); SliderText.TextSize = 7; SliderText.Font = Enum.Font.GothamBold

    local function syncSlider(val)
        SliderFill.Size = UDim2.new(math.clamp((val - 1) / 199, 0, 1), 0, 1, 0); SliderText.Text = string.format("SIZE: %d STUDS", val)
    end
    syncSlider(Settings.HitboxSize)

    local SliderButton = Instance.new("TextButton", SliderFrame)
    SliderButton.Size = UDim2.new(1, 0, 1, 0); SliderButton.BackgroundTransparency = 1; SliderButton.Text = ""

    local function UpdateSlider()
        local Percentage = math.clamp((Mouse.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
        Settings.HitboxSize = math.floor(1 + (Percentage * 199))
        syncSlider(Settings.HitboxSize)
    end

    local SliderConnection = nil
    SliderButton.MouseButton1Down:Connect(function()
        UpdateSlider()
        SliderConnection = RunService.RenderStepped:Connect(UpdateSlider)
    end)

    -- [[ FOV SLIDER CONFIG ]]
    createLabel("AIM FOV SIZE CONFIG", UDim2.new(0, 6, 0, 244)).Parent = ContentFrame
    local FOVSliderFrame = Instance.new("Frame", ContentFrame); FOVSliderFrame.Size = UDim2.new(0, 128, 0, 12); FOVSliderFrame.Position = UDim2.new(0, 6, 0, 255); FOVSliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", FOVSliderFrame)
    local FOVSliderFill = Instance.new("Frame", FOVSliderFrame); FOVSliderFill.BackgroundColor3 = _GAccentColor; Instance.new("UICorner", FOVSliderFill)
    local FOVSliderText = Instance.new("TextLabel", FOVSliderFrame); FOVSliderText.Size = UDim2.new(1, 0, 1, 0); FOVSliderText.BackgroundTransparency = 1; FOVSliderText.TextColor3 = Color3.new(1, 1, 1); FOVSliderText.TextSize = 7; FOVSliderText.Font = Enum.Font.GothamBold

    local function syncFOVSlider(val)
        FOVSliderFill.Size = UDim2.new(math.clamp((val - 1) / 199, 0, 1), 0, 1, 0); FOVSliderText.Text = string.format("FOV: %d RAD", val)
    end
    syncFOVSlider(Settings.FOVSize)

    local FOVSliderButton = Instance.new("TextButton", FOVSliderFrame)
    FOVSliderButton.Size = UDim2.new(1, 0, 1, 0); FOVSliderButton.BackgroundTransparency = 1; FOVSliderButton.Text = ""

    local function UpdateFOVSlider()
        local Percentage = math.clamp((Mouse.X - FOVSliderFrame.AbsolutePosition.X) / FOVSliderFrame.AbsoluteSize.X, 0, 1)
        Settings.FOVSize = math.floor(1 + (Percentage * 199))
        syncFOVSlider(Settings.FOVSize)
    end

    local FOVSliderConnection = nil
    FOVSliderButton.MouseButton1Down:Connect(function()
        UpdateFOVSlider()
        FOVSliderConnection = RunService.RenderStepped:Connect(UpdateFOVSlider)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if SliderConnection then SliderConnection:Disconnect() SliderConnection = nil end
            if FOVSliderConnection then FOVSliderConnection:Disconnect() FOVSliderConnection = nil end
            if SpeedSliderConnection then SpeedSliderConnection:Disconnect() SpeedSliderConnection = nil end
        end
    end)

    local CloseBar = createBtn("▼ OPEN MENU ▼", UDim2.new(0, 0, 1, -16), UDim2.new(1, 0, 0, 16), Color3.new(0,0,0))
    CloseBar.BackgroundTransparency = 1; CloseBar.TextSize = 6

    CloseBar.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        MainFrame:TweenSize(isMinimized and UDim2.new(0, 140, 0, 58) or UDim2.new(0, 140, 0, 335), "Out", "Quad", 0.25, true)
        CloseBar.Text = isMinimized and "▼ OPEN MENU ▼" or "▲ CLOSE MENU ▲"
        task.wait(0.2); ContentFrame.Visible = not isMinimized
    end)

    ToggleBtnMain.MouseButton1Click:Connect(function()
        MainVisible = not MainVisible
        if MainVisible then
            MainFrame.Visible = true; HUDMain.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, 140, 0, 58) or UDim2.new(0, 140, 0, 335)}):Play()
            TweenService:Create(ToggleBtnMain, TweenInfo.new(0.3), {BackgroundColor3 = _GMainColor}):Play()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 140, 0, 0)})
            t:Play(); t.Completed:Connect(function() if not MainVisible then MainFrame.Visible = false end end)
            HUDMain.Visible = false
            TweenService:Create(ToggleBtnMain, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end
    end)

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

    -- ==========================================
    -- [[ BUTTON FUNCTIONALITIES & INTEGRATION ]]
    -- ==========================================
    local function toggleAimbot()
        Settings.CameraAimbot = not Settings.CameraAimbot
        ToggleBtn.Text = Settings.CameraAimbot and "[Q] AIMBOT: ON" or "[Q] AIMBOT: OFF"
        ToggleBtn.BackgroundColor3 = Settings.CameraAimbot and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleSilentAim()
        Settings.SilentAim = not Settings.SilentAim
        SilentAimBtn.Text = Settings.SilentAim and "[Z] SILENT AIM: ON" or "[Z] SILENT AIM: OFF"
        SilentAimBtn.BackgroundColor3 = Settings.SilentAim and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleEsp()
        Settings.ESP = not Settings.ESP
        EspBtn.Text = Settings.ESP and "[X] ESP + GUN DROP: ON" or "[X] ESP + GUN DROP: OFF"
        EspBtn.BackgroundColor3 = Settings.ESP and _GAccentColor or Color3.fromRGB(30, 30, 35)
        if not Settings.ESP then 
            ClearGunOutlines() 
        end
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

    local function toggleHideFOV()
        Settings.HideFOVCircle = not Settings.HideFOVCircle
        FOVHideBtn.Text = Settings.HideFOVCircle and "[P] HIDE FOV CIRCLE: ON" or "[P] HIDE FOV CIRCLE: OFF"
        FOVHideBtn.BackgroundColor3 = Settings.HideFOVCircle and _GAccentColor or Color3.fromRGB(30, 30, 35)
    end

    local function toggleFlingMurder()
        Settings.AutoFlingMurder = not Settings.AutoFlingMurder
        if Settings.AutoFlingMurder then Settings.AutoFlingSheriff = false end
        _G.SyncFlingButtons()
    end

    local function toggleFlingSheriff()
        Settings.AutoFlingSheriff = not Settings.AutoFlingSheriff
        if Settings.AutoFlingSheriff then Settings.AutoFlingMurder = false end
        _G.SyncFlingButtons()
    end

    local function toggleSpeedWalk()
        Settings.SpeedWalkEnabled = not Settings.SpeedWalkEnabled
        SpeedWalkBtn.Text = Settings.SpeedWalkEnabled and "SPEED WALK: ON" or "SPEED WALK: OFF"
        SpeedWalkBtn.BackgroundColor3 = Settings.SpeedWalkEnabled and _GAccentColor or Color3.fromRGB(30, 30, 35)
        if not Settings.SpeedWalkEnabled then
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
        end
    end

    _G.SyncFlingButtons = function()
        FlingMurderBtn.Text = Settings.AutoFlingMurder and "FLING MURDER: ON" or "AUTO FLING MURDER"
        FlingMurderBtn.BackgroundColor3 = Settings.AutoFlingMurder and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(30, 30, 35)
        
        FlingSheriffBtn.Text = Settings.AutoFlingSheriff and "FLING SHERIFF: ON" or "AUTO FLING SHERIFF"
        FlingSheriffBtn.BackgroundColor3 = Settings.AutoFlingSheriff and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(30, 30, 35)
    end

    ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
    SilentAimBtn.MouseButton1Click:Connect(toggleSilentAim)
    EspBtn.MouseButton1Click:Connect(toggleEsp)
    HitboxBtn.MouseButton1Click:Connect(toggleHitbox)
    GrabBtn.MouseButton1Click:Connect(toggleAutoGrab) 
    FOVHideBtn.MouseButton1Click:Connect(toggleHideFOV)
    FlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)
    FlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)
    SpeedWalkBtn.MouseButton1Click:Connect(toggleSpeedWalk)

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

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.Q then toggleAimbot()
        elseif key == Enum.KeyCode.Z then toggleSilentAim()
        elseif key == Enum.KeyCode.X then toggleEsp()
        elseif key == Enum.KeyCode.C then toggleHitbox()
        elseif key == Enum.KeyCode.H then toggleAutoGrab() 
        elseif key == Enum.KeyCode.P then toggleHideFOV()
        end
    end)

    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    startLoading()

    print("Louis Hub FREE V13.5.2: Initialized Successfully (Protection 2 Disabled).")
end
