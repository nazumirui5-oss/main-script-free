-- [[ LOUIS HUB FREE - INTEGRATED & PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 13.5.2 (Security Sync Update - MM2 Edition Expanded)

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
        AimbotKnifeEnabled = false, -- FITUR BARU: Aim untuk Pisau
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
        
        -- SISTEM SPINNERS & FLING MODS
        SpinEnabled = false,
        SpinSpeed = 10,
        AntiFlingEnabled = false,
        TouchFlingEnabled = false,
        TouchFlingPower = 100,
        InfiniteJumpEnabled = false,
        AntiVoidEnabled = false,
        
        -- TOMBOL EKSTERNAL TOGGLE MASTER
        MasterExtButtonsEnabled = true,

        -- UKURAN TOMBOL EKSTERNAL
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
        Size_TPPreFling = 40
    }

    local OriginalFOV = Camera.FieldOfView
    local OriginalCFrameBeforeFling = nil
    local FlingFailsafeActive = false
    local lastSafeCFrame = nil

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

    -- ========================================================================
    -- [[ DETEKSI JUMP, INFINITE JUMP, & DOUBLE JUMP ENGINE ]]
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
        if humanoid and root and humanoid.Health > 0 then
            -- Logika Double Jump
            if Settings.DoubleJumpEnabled and CanDoubleJump and not HasDoubleJumped then
                HasDoubleJumped = true
                root.Velocity = Vector3.new(root.Velocity.X, humanoid.JumpPower * 1.15, root.Velocity.Z)
            end
            -- Logika Infinite Jump
            if Settings.InfiniteJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    table.insert(_G.LouisConnections, DoubleJumpReq)

    -- ========================================================================
    -- [[ SPIN ENGINE (UTILITY SPIN & TOUCH FLING MODS) ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            if Settings.SpinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
            end
            task.wait()
        end
    end)

    -- ========================================================================
    -- [[ ANTI VOID SYSTEM ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                
                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air and root.Position.Y > -40 then
                    lastSafeCFrame = root.CFrame
                end
                
                if Settings.AntiVoidEnabled and root.Position.Y < -50 then
                    root.Velocity = Vector3.new(0, 0, 0)
                    if lastSafeCFrame then
                        root.CFrame = lastSafeCFrame
                    else
                        root.CFrame = CFrame.new(0, 50, 0)
                    end
                end
            end
            task.wait(0.5)
        end
    end)

    -- ========================================================================
    -- [[ ANTI FLING ENGINE ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            if Settings.AntiFlingEnabled and LocalPlayer.Character then
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, child in ipairs(player.Character:GetDescendants()) do
                                if child:IsA("BasePart") then
                                    child.CanCollide = false
                                    child.Velocity = Vector3.new(0, 0, 0)
                                    child.RotVelocity = Vector3.new(0, 0, 0)
                                end
                            end
                        end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)

    -- ========================================================================
    -- [[ TOUCH FLING ENGINE ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            if Settings.TouchFlingEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local tRoot = player.Character.HumanoidRootPart
                            local dist = (root.Position - tRoot.Position).Magnitude
                            if dist < 4 then
                                local oldV = root.Velocity
                                root.Velocity = Vector3.new(Settings.TouchFlingPower * 10, Settings.TouchFlingPower * 10, Settings.TouchFlingPower * 10)
                                task.wait(0.02)
                                root.Velocity = oldV
                            end
                        end
                    end
                end)
            end
            task.wait()
        end
    end)

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

    -- AIMBOT RENDER: Mendukung Aimbot Gun & Aimbot Knife Baru
    SafeConnect(RunService.RenderStepped, function()
        if Settings.CameraAimbot and LocalPlayer.Character then
            local HoldsGun = LocalPlayer.Character:FindFirstChild("Gun")
            local HoldsKnife = LocalPlayer.Character:FindFirstChild("Knife")
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            local HasKnifeInBag = Backpack and Backpack:FindFirstChild("Knife")

            local ShouldAimbot = false
            if HoldsGun and HoldsGun:IsA("Tool") then
                ShouldAimbot = true
            elseif Settings.AimbotKnifeEnabled and (HoldsKnife or HasKnifeInBag) then
                ShouldAimbot = true
            end

            if ShouldAimbot then
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
    -- [[ KILL AURA & TELEPORT ALL ]]
    -- ========================================================================
    task.spawn(function()
        while true do
            task.wait(0.1)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if Settings.KillAuraEnabled and char and root then
                local knife = char:FindFirstChild("Knife")
                if knife and GetMM2Role(LocalPlayer) == "Murderer" then
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
    -- [[ METODE NAVIGASI TELEPORTASI BARU (LOBBY, SHERIFF, MURDERER, UNDERGROUND, PREFLING) ]]
    -- ========================================================================
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

    local function TPToSheriff()
        local target = GetTargetByRole("Sheriff")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2) end
        end
    end

    local function TPToMurderer()
        local target = GetTargetByRole("Murderer")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2) end
        end
    end

    local function TPToLobby()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local lobby = Workspace:FindFirstChild("Lobby")
        if lobby then
            local spawnPoint = lobby:FindFirstChild("Spawn") or lobby:FindFirstChildOfClass("SpawnLocation") or lobby:FindFirstChildOfClass("BasePart")
            if spawnPoint then
                root.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
                return
            end
        end
        -- Koordinat default lobby MM2 jika spawn model tidak ditemukan
        root.CFrame = CFrame.new(-108.5, 138.5, 12)
    end

    local function TPUnderground()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = CFrame.new(root.Position.X, root.Position.Y - 25, root.Position.Z)
    end

    local function TPPreFling()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and OriginalCFrameBeforeFling then
            root.CFrame = OriginalCFrameBeforeFling
        end
    end

    -- ========================================================================
    -- [[ CONSTRAINT-BASED FLY ENGINE, NOCLIP & INVISIBLE ]]
    -- ========================================================================
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

    -- Koleksi Elemen untuk Sinkronisasi Warna Pelangi Dinamis
    local UI_Accent_Elements = {}
    local UI_Toggled_Buttons = {}

    -- Memulai Loop Sinkronisasi Warna Neon/Pelangi Bersama
    SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4 -- Loop warna dalam waktu 4 detik
        local RainbowColor = Color3.fromHSV(hue, 0.8, 1)
        
        for _, el in ipairs(UI_Accent_Elements) do
            pcall(function()
                if el:IsA("UIStroke") then
                    el.Color = RainbowColor
                elseif el:IsA("Frame") and el.Name == "SliderFill" then
                    el.BackgroundColor3 = RainbowColor
                elseif el:IsA("Frame") and el.Name == "HUDFrameBorder" then
                    el.BackgroundColor3 = RainbowColor
                end
            end)
        end
        
        for btn, stateKey in pairs(UI_Toggled_Buttons) do
            pcall(function()
                if Settings[stateKey] then
                    btn.BackgroundColor3 = RainbowColor
                else
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                end
            end)
        end
    end)

    -- ==========================================
    -- [[ 3. MAIN SCRIPT GUI & HUD STRUCT ]]
    -- ==========================================
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    ScreenGui.Name = "LouisHub_FREE_Edition"
    ScreenGui.ResetOnSpawn = false

    -- HELPER: Penerapan warna neon bergerak pada stroke & transparansi tengah 60%
    local function ApplyExternalButtonStyle(btn, stroke)
        btn.BackgroundTransparency = 0.6
        table.insert(UI_Accent_Elements, stroke)
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

    -- [[ DEKLARASI TOMBOL UTAMA L (Floating Toggle) ]]
    ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -200)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    ToggleBtnMain.Visible = false 

    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    ApplyExternalButtonStyle(ToggleBtnMain, ToggleStroke)
    MakeDraggable(ToggleBtnMain)

    -- [[ SYSTEM PEMBUATAN TOMBOL EKSTERNAL SECARA DINAMIS ]]
    local ExtAimbotBtn, ExtGrabBtn, ExtDoubleJumpBtn, ExtSpinBtn
    local ExtTPSheriffBtn, ExtTPMurderBtn, ExtFlingMurderBtn, ExtFlingSheriffBtn
    local ExtTPLobbyBtn, ExtTPUndergroundBtn, ExtTPPreFlingBtn

    local function CreateFloatingButton(name, text, defaultPos, settingSizeKey)
        local btn = Instance.new("TextButton", ScreenGui)
        btn.Name = name
        btn.Size = UDim2.new(0, Settings[settingSizeKey], 0, Settings[settingSizeKey])
        btn.Position = defaultPos
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Visible = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke", btn)
        stroke.Thickness = 1.5
        ApplyExternalButtonStyle(btn, stroke)
        MakeDraggable(btn)
        return btn
    end

    -- Inisialisasi Tombol Eksteral Melayang
    ExtAimbotBtn = CreateFloatingButton("ExtAimbot", "A", UDim2.new(0, 20, 0.5, -145), "Size_A")
    ExtGrabBtn = CreateFloatingButton("ExtGrabGun", "G", UDim2.new(0, 20, 0.5, -100), "Size_G")
    ExtDoubleJumpBtn = CreateFloatingButton("ExtDoubleJump", "DJ", UDim2.new(0, 20, 0.5, -55), "Size_DJ")
    ExtSpinBtn = CreateFloatingButton("ExtSpin", "SP", UDim2.new(0, 20, 0.5, -10), "Size_Spin")
    ExtTPSheriffBtn = CreateFloatingButton("ExtTPSheriff", "TS", UDim2.new(0, 20, 0.5, 35), "Size_TPSheriff")
    ExtTPMurderBtn = CreateFloatingButton("ExtTPMurder", "TM", UDim2.new(0, 20, 0.5, 80), "Size_TPMurder")
    
    ExtFlingMurderBtn = CreateFloatingButton("ExtFlingMurder", "FM", UDim2.new(0, 70, 0.5, -145), "Size_FlingMurder")
    ExtFlingSheriffBtn = CreateFloatingButton("ExtFlingSheriff", "FS", UDim2.new(0, 70, 0.5, -100), "Size_FlingSheriff")
    ExtTPLobbyBtn = CreateFloatingButton("ExtTPLobby", "TL", UDim2.new(0, 70, 0.5, -55), "Size_TPLobby")
    ExtTPUndergroundBtn = CreateFloatingButton("ExtTPUnder", "UG", UDim2.new(0, 70, 0.5, -10), "Size_TPUnderground")
    ExtTPPreFlingBtn = CreateFloatingButton("ExtTPPre", "PF", UDim2.new(0, 70, 0.5, 35), "Size_TPPreFling")

    -- UPDATE UKURAN DAN VISIBILITAS TOMBOL EKSTERNAL DARI SETTING MASTER
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
        ExtTPPreFlingBtn.Size = UDim2.new(0, Settings.Size_TPPreFling, 0, Settings.Size_TPPreFling)
    end

    local function refreshExternalButtonsVisibility()
        local master = Settings.MasterExtButtonsEnabled
        ExtAimbotBtn.Visible = master and Settings.AimbotExtEnabled
        ExtGrabBtn.Visible = master and Settings.GrabGunExtEnabled
        ExtDoubleJumpBtn.Visible = master and Settings.DoubleJumpExtEnabled
        ExtSpinBtn.Visible = master and Settings.SpinEnabledExt
        ExtTPSheriffBtn.Visible = master and Settings.TPSheriffExt
        ExtTPMurderBtn.Visible = master and Settings.TPMurderExt
        ExtFlingMurderBtn.Visible = master and Settings.FlingMurderExt
        ExtFlingSheriffBtn.Visible = master and Settings.FlingSheriffExt
        ExtTPLobbyBtn.Visible = master and Settings.TPLobbyExt
        ExtTPUndergroundBtn.Visible = master and Settings.TPUndergroundExt
        ExtTPPreFlingBtn.Visible = master and Settings.TPPreFlingExt
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

    local HUDFrameBorder = Instance.new("Frame", HUDFrame)
    HUDFrameBorder.Name = "HUDFrameBorder"
    HUDFrameBorder.Size = UDim2.new(1, 0, 0, 1.5)
    HUDFrameBorder.Position = UDim2.new(0, 0, 1, -1.5)
    HUDFrameBorder.BorderSizePixel = 0
    table.insert(UI_Accent_Elements, HUDFrameBorder)

    local FPSLabel = Instance.new("TextLabel", HUDFrame)
    FPSLabel.Size = UDim2.new(0, 60, 0.4, 0); FPSLabel.Position = UDim2.new(0, 5, 0, 4)
    FPSLabel.BackgroundTransparency = 1; FPSLabel.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
    FPSLabel.Font = Enum.Font.GothamBold; FPSLabel.TextSize = 9; FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PingLabel = Instance.new("TextLabel", HUDFrame)
    PingLabel.Size = UDim2.new(0, 60, 0.4, 0); PingLabel.Position = UDim2.new(0, 5, 0.4, 0)
    PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
    PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 9; PingLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GraphFrame = Instance.new("Frame", HUDFrame)
    GraphFrame.Size = UDim2.new(0, 35, 0, 35); GraphFrame.Position = UDim2.new(1, -75, 0, 5); GraphFrame.BackgroundTransparency = 1

    local bars = {}
    for i = 1, 10 do
        local b = Instance.new("Frame", GraphFrame)
        b.Size = UDim2.new(0, 2, 0, 10); b.Position = UDim2.new(0, i*3, 1, -10)
        b.BorderSizePixel = 0; bars[i] = b
        table.insert(UI_Accent_Elements, b)
    end

    local PotatoToggle = Instance.new("TextButton", HUDFrame)
    PotatoToggle.Size = UDim2.new(0, 30, 0, 25); PotatoToggle.Position = UDim2.new(1, -35, 0.5, -12.5)
    PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); PotatoToggle.Text = "🍃"; PotatoToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", PotatoToggle)
    local PotatoStroke = Instance.new("UIStroke", PotatoToggle)
    PotatoStroke.Thickness = 1.5
    table.insert(UI_Accent_Elements, PotatoStroke)

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
    
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Thickness = 1.5
    table.insert(UI_Accent_Elements, Stroke)

    local function createBtn(txt, pos, size, color)
        local b = Instance.new("TextButton")
        b.Size = size; b.Position = pos; b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1) -- Polosan Putih
        b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 6.5; b.ClipsDescendants = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); return b
    end

    local function createLabel(txt, pos, size)
        local l = Instance.new("TextLabel", MainFrame)
        l.Size = size or UDim2.new(0, 148, 0, 10); l.Position = pos
        l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
        l.TextSize = 7; l.Font = Enum.Font.GothamBold; return l
    end

    local HubLabel = createLabel("LOUIS HUB FREE V13.5.2", UDim2.new(0, 6, 0, 4), UDim2.new(0, 95, 0, 12))
    HubLabel.TextSize = 6.5

    -- Lock / Unlock Drag UI Utama
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
    local InfoStroke = Instance.new("UIStroke", InfoFrame); InfoStroke.Thickness = 1
    table.insert(UI_Accent_Elements, InfoStroke)

    local function createInfoLabel(txt, pos, color)
        local l = Instance.new("TextLabel", InfoFrame)
        l.Size = UDim2.new(1, 0, 0, 12); l.Position = pos; l.BackgroundTransparency = 1; l.Text = txt
        l.TextColor3 = color or Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 7; return l
    end
    createInfoLabel("--- SOCIAL MEDIA ---", UDim2.new(0, 0, 0, 5), Color3.fromRGB(255, 255, 255))

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
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextColor3 = Color3.new(0,0,0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                btn.TextColor3 = Color3.new(1,1,1)
            end
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

    -- Fungsi Pembuat Group Container Box
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
        title.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
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

    -- FUNGSI PEMBUAT SLIDER UNIVERSAL YANG DINAMIS MENGIKUTI WARNA PELANGI
    local function createSlider(parent, textFormat, minVal, maxVal, defaultVal, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, 12)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Instance.new("UICorner", sliderFrame)
        
        local sliderFill = Instance.new("Frame", sliderFrame)
        sliderFill.Name = "SliderFill"
        Instance.new("UICorner", sliderFill)
        table.insert(UI_Accent_Elements, sliderFill)
        
        local sliderText = Instance.new("TextLabel", sliderFrame)
        sliderText.Size = UDim2.new(1, 0, 1, 0)
        sliderText.BackgroundTransparency = 1
        sliderText.TextColor3 = Color3.new(1, 1, 1) -- Polosan Putih
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
    InfoStatusLabel.TextColor3 = Color3.new(1,1,1); InfoStatusLabel.Font = Enum.Font.Gotham; InfoStatusLabel.TextSize = 6.5
    addTabElement("Main", InfoStatusLabel)


    -- --- TAB 2: COMBAT ---
    
    -- BOX 1: KILL PLAYER (Murderer Only)
    local BoxKillPlayer = createGroupContainer("Combat", "Kill Player", 64)
    local KillAuraToggleBtn = createBtn("KILL AURA: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    KillAuraToggleBtn.Parent = BoxKillPlayer; KillAuraToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[KillAuraToggleBtn] = "KillAuraEnabled"

    createSlider(BoxKillPlayer, "KA RADIUS: %d STUDS", 1, 50, Settings.KillAuraRadius, function(val)
        Settings.KillAuraRadius = val
    end)

    local KillAllBtn = createBtn("KILL ALL PLAYER (TP ALL)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14), Color3.fromRGB(180, 0, 0))
    KillAllBtn.Parent = BoxKillPlayer; KillAllBtn.LayoutOrder = 3


    -- BOX 2: AIM UTAMA & PISAU
    local BoxAim = createGroupContainer("Combat", "Main Aim Mechanics", 100)
    local ToggleBtn = createBtn("[Q] AIMBOT: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ToggleBtn.Parent = BoxAim; ToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[ToggleBtn] = "CameraAimbot"

    local KnifeAimbotToggleBtn = createBtn("AIMBOT KNIFE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    KnifeAimbotToggleBtn.Parent = BoxAim; KnifeAimbotToggleBtn.LayoutOrder = 2
    UI_Toggled_Buttons[KnifeAimbotToggleBtn] = "AimbotKnifeEnabled"
    
    local ExtAimbotToggleBtn = createBtn("AIMBOT (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ExtAimbotToggleBtn.Parent = BoxAim; ExtAimbotToggleBtn.LayoutOrder = 3
    UI_Toggled_Buttons[ExtAimbotToggleBtn] = "AimbotExtEnabled"

    createSlider(BoxAim, "BUTTON 'A' SIZE: %d", 20, 100, Settings.Size_A, function(val)
        Settings.Size_A = val
        updateExternalButtonSizes()
    end)


    -- BOX 3: TELEPORT NAVIGATION & TP KEMBALI SEBELUM FLING
    local BoxTeleports = createGroupContainer("Combat", "Teleport Navigation Controls", 314)
    
    local TpSheriffBtn = createBtn("TELEPORT TO SHERIFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpSheriffBtn.Parent = BoxTeleports; TpSheriffBtn.LayoutOrder = 1
    
    local TpSheriffExtToggleBtn = createBtn("TELEPORT SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpSheriffExtToggleBtn.Parent = BoxTeleports; TpSheriffExtToggleBtn.LayoutOrder = 2
    UI_Toggled_Buttons[TpSheriffExtToggleBtn] = "TPSheriffExt"

    createSlider(BoxTeleports, "TP SHERIFF SIZE: %d", 20, 100, Settings.Size_TPSheriff, function(val)
        Settings.Size_TPSheriff = val
        updateExternalButtonSizes()
    end)

    local TpMurderBtn = createBtn("TELEPORT TO MURDERER", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpMurderBtn.Parent = BoxTeleports; TpMurderBtn.LayoutOrder = 4

    local TpMurderExtToggleBtn = createBtn("TELEPORT MURDER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpMurderExtToggleBtn.Parent = BoxTeleports; TpMurderExtToggleBtn.LayoutOrder = 5
    UI_Toggled_Buttons[TpMurderExtToggleBtn] = "TPMurderExt"

    createSlider(BoxTeleports, "TP MURDER SIZE: %d", 20, 100, Settings.Size_TPMurder, function(val)
        Settings.Size_TPMurder = val
        updateExternalButtonSizes()
    end)

    local TpLobbyBtn = createBtn("TELEPORT TO LOBBY MAP", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpLobbyBtn.Parent = BoxTeleports; TpLobbyBtn.LayoutOrder = 7

    local TpLobbyExtToggleBtn = createBtn("TELEPORT LOBBY (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpLobbyExtToggleBtn.Parent = BoxTeleports; TpLobbyExtToggleBtn.LayoutOrder = 8
    UI_Toggled_Buttons[TpLobbyExtToggleBtn] = "TPLobbyExt"

    createSlider(BoxTeleports, "TP LOBBY SIZE: %d", 20, 100, Settings.Size_TPLobby, function(val)
        Settings.Size_TPLobby = val
        updateExternalButtonSizes()
    end)

    local TpUndergroundBtn = createBtn("TELEPORT UNDERGROUND", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpUndergroundBtn.Parent = BoxTeleports; TpUndergroundBtn.LayoutOrder = 10

    local TpUndergroundExtToggleBtn = createBtn("TP UNDERGROUND (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpUndergroundExtToggleBtn.Parent = BoxTeleports; TpUndergroundExtToggleBtn.LayoutOrder = 11
    UI_Toggled_Buttons[TpUndergroundExtToggleBtn] = "TPUndergroundExt"

    createSlider(BoxTeleports, "TP UNDERGROUND SIZE: %d", 20, 100, Settings.Size_TPUnderground, function(val)
        Settings.Size_TPUnderground = val
        updateExternalButtonSizes()
    end)

    local TpPreFlingBtn = createBtn("TP PRE-FLING POSITION", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpPreFlingBtn.Parent = BoxTeleports; TpPreFlingBtn.LayoutOrder = 13

    local TpPreFlingExtToggleBtn = createBtn("TP PRE-FLING (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TpPreFlingExtToggleBtn.Parent = BoxTeleports; TpPreFlingExtToggleBtn.LayoutOrder = 14
    UI_Toggled_Buttons[TpPreFlingExtToggleBtn] = "TPPreFlingExt"

    createSlider(BoxTeleports, "TP PRE-FLING SIZE: %d", 20, 100, Settings.Size_TPPreFling, function(val)
        Settings.Size_TPPreFling = val
        updateExternalButtonSizes()
    end)


    -- BOX 4: FIELD OF VIEW (FOV)
    local BoxFOV = createGroupContainer("Combat", "Field of View (FOV)", 82)
    local FOVHideBtn = createBtn("[P] HIDE FOV CIRCLE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FOVHideBtn.Parent = BoxFOV; FOVHideBtn.LayoutOrder = 1
    UI_Toggled_Buttons[FOVHideBtn] = "HideFOVCircle"
    
    createSlider(BoxFOV, "FOV: %d RAD", 1, 200, Settings.FOVSize, function(val)
        Settings.FOVSize = val
    end)

    local CamFOVToggleBtn = createBtn("CAMERA FOV MODIFIER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    CamFOVToggleBtn.Parent = BoxFOV; CamFOVToggleBtn.LayoutOrder = 3
    UI_Toggled_Buttons[CamFOVToggleBtn] = "CameraFOVEnabled"

    createSlider(BoxFOV, "CAM FOV: %d", 30, 120, Settings.CameraFOVValue, function(val)
        Settings.CameraFOVValue = val
    end)


    -- BOX 5: GRAB GUN SYSTEM
    local BoxGrab = createGroupContainer("Combat", "Gun Grabber System", 64)
    local GrabBtn = createBtn("[H] AUTO GRAB GUN: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    GrabBtn.Parent = BoxGrab; GrabBtn.LayoutOrder = 1
    UI_Toggled_Buttons[GrabBtn] = "AutoGrabGun"
    
    local ManualGrabToggleBtn = createBtn("GRAB GUN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    ManualGrabToggleBtn.Parent = BoxGrab; ManualGrabToggleBtn.LayoutOrder = 2
    UI_Toggled_Buttons[ManualGrabToggleBtn] = "GrabGunExtEnabled"

    createSlider(BoxGrab, "BUTTON 'G' SIZE: %d", 20, 100, Settings.Size_G, function(val)
        Settings.Size_G = val
        updateExternalButtonSizes()
    end)


    -- --- TAB 3: ESP & VISUALS ---
    local BoxESP = createGroupContainer("ESP", "Visual & Hitbox Hack", 172)
    local EspBtn = createBtn("[X] ESP + GUN DROP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    EspBtn.Parent = BoxESP; EspBtn.LayoutOrder = 1
    UI_Toggled_Buttons[EspBtn] = "ESP"

    local TracersEspBtn = createBtn("TRACERS ESP LINE: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TracersEspBtn.Parent = BoxESP; TracersEspBtn.LayoutOrder = 2
    UI_Toggled_Buttons[TracersEspBtn] = "TracersESP"

    local NameEspBtn = createBtn("NAME ESP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NameEspBtn.Parent = BoxESP; NameEspBtn.LayoutOrder = 3
    UI_Toggled_Buttons[NameEspBtn] = "NameESP"

    -- Filter ESP (Murderer, Sheriff, Innocent)
    local FilterMurderBtn = createBtn("FILTER: MURDERER (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FilterMurderBtn.Parent = BoxESP; FilterMurderBtn.LayoutOrder = 4
    UI_Toggled_Buttons[FilterMurderBtn] = "EspMurderer"

    local FilterSheriffBtn = createBtn("FILTER: SHERIFF (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FilterSheriffBtn.Parent = BoxESP; FilterSheriffBtn.LayoutOrder = 5
    UI_Toggled_Buttons[FilterSheriffBtn] = "EspSheriff"

    local FilterInnocentBtn = createBtn("FILTER: INNOCENT (ON)", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FilterInnocentBtn.Parent = BoxESP; FilterInnocentBtn.LayoutOrder = 6
    UI_Toggled_Buttons[FilterInnocentBtn] = "EspInnocent"
    
    local HitboxBtn = createBtn("[C] HITBOX EXPANDER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    HitboxBtn.Parent = BoxESP; HitboxBtn.LayoutOrder = 7
    UI_Toggled_Buttons[HitboxBtn] = "HitboxExpander"
    
    local VisualBtn = createBtn("[V] HITBOX VISUAL: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    VisualBtn.Parent = BoxESP; VisualBtn.LayoutOrder = 8
    UI_Toggled_Buttons[VisualBtn] = "HitboxVisual"

    createSlider(BoxESP, "SIZE: %d STUDS", 1, 200, Settings.HitboxSize, function(val)
        Settings.HitboxSize = val
    end)


    -- --- TAB 4: UTILITY ---
    
    -- BOX 1: WALKSPEED MODIFIER
    local BoxSpeed = createGroupContainer("Utility", "Walkspeed Modifier", 46)
    local SpeedWalkBtn = createBtn("SPEED WALK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpeedWalkBtn.Parent = BoxSpeed; SpeedWalkBtn.LayoutOrder = 1
    UI_Toggled_Buttons[SpeedWalkBtn] = "SpeedWalkEnabled"
    
    createSlider(BoxSpeed, "SPEED: %d WS", 1, 100, Settings.SpeedWalkValue, function(val)
        Settings.SpeedWalkValue = val
    end)


    -- BOX 2: JUMP HEIGHT & INFINITE JUMP
    local BoxPlayerJump = createGroupContainer("Utility", "Jump Power & Mechanics", 118)
    local JumpToggleBtn = createBtn("JUMP HEIGHT MOD: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    JumpToggleBtn.Parent = BoxPlayerJump; JumpToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[JumpToggleBtn] = "JumpPowerEnabled"

    createSlider(BoxPlayerJump, "JUMP POWER: %d", 50, 200, Settings.JumpPowerValue, function(val)
        Settings.JumpPowerValue = val
    end)

    local InfJumpToggleBtn = createBtn("INFINITE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InfJumpToggleBtn.Parent = BoxPlayerJump; InfJumpToggleBtn.LayoutOrder = 3
    UI_Toggled_Buttons[InfJumpToggleBtn] = "InfiniteJumpEnabled"

    local DoubleJumpToggleBtn = createBtn("DOUBLE JUMP: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpToggleBtn.Parent = BoxPlayerJump; DoubleJumpToggleBtn.LayoutOrder = 4
    UI_Toggled_Buttons[DoubleJumpToggleBtn] = "DoubleJumpEnabled"

    local DoubleJumpExtToggleBtn = createBtn("DOUBLE JUMP (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    DoubleJumpExtToggleBtn.Parent = BoxPlayerJump; DoubleJumpExtToggleBtn.LayoutOrder = 5
    UI_Toggled_Buttons[DoubleJumpExtToggleBtn] = "DoubleJumpExtEnabled"

    createSlider(BoxPlayerJump, "BUTTON 'DJ' SIZE: %d", 20, 100, Settings.Size_DJ, function(val)
        Settings.Size_DJ = val
        updateExternalButtonSizes()
    end)


    -- BOX 3: SPIN MODS & TOUCH FLING MODS
    local BoxSpinFling = createGroupContainer("Utility", "Spin & Touch Fling Controls", 118)
    
    local SpinToggleBtn = createBtn("SPIN CHAR: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpinToggleBtn.Parent = BoxSpinFling; SpinToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[SpinToggleBtn] = "SpinEnabled"

    local SpinExtToggleBtn = createBtn("SPIN (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    SpinExtToggleBtn.Parent = BoxSpinFling; SpinExtToggleBtn.LayoutOrder = 2
    UI_Toggled_Buttons[SpinExtToggleBtn] = "SpinEnabledExt"

    createSlider(BoxSpinFling, "SPIN SPEED: %d", 1, 100, Settings.SpinSpeed, function(val)
        Settings.SpinSpeed = val
    end)

    createSlider(BoxSpinFling, "BUTTON 'SP' SIZE: %d", 20, 100, Settings.Size_Spin, function(val)
        Settings.Size_Spin = val
        updateExternalButtonSizes()
    end)


    -- BOX 4: FLING SYSTEM & ANTI-FLING (TERMASUK TOUCH FLING)
    local BoxFling = createGroupContainer("Utility", "Fling Glitch Systems", 172)
    
    local FlingSheriffBtn = createBtn("AUTO FLING SHERIFF: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingSheriffBtn.Parent = BoxFling; FlingSheriffBtn.LayoutOrder = 1
    UI_Toggled_Buttons[FlingSheriffBtn] = "AutoFlingSheriff"

    local FlingSheriffExtBtn = createBtn("FLING SHERIFF (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingSheriffExtBtn.Parent = BoxFling; FlingSheriffExtBtn.LayoutOrder = 2
    UI_Toggled_Buttons[FlingSheriffExtBtn] = "FlingSheriffExt"

    createSlider(BoxFling, "FLING SHERIFF SIZE: %d", 20, 100, Settings.Size_FlingSheriff, function(val)
        Settings.Size_FlingSheriff = val
        updateExternalButtonSizes()
    end)
    
    local FlingMurderBtn = createBtn("AUTO FLING MURDER: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingMurderBtn.Parent = BoxFling; FlingMurderBtn.LayoutOrder = 4
    UI_Toggled_Buttons[FlingMurderBtn] = "AutoFlingMurder"

    local FlingMurderExtBtn = createBtn("FLING MURDER (EXT): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlingMurderExtBtn.Parent = BoxFling; FlingMurderExtBtn.LayoutOrder = 5
    UI_Toggled_Buttons[FlingMurderExtBtn] = "FlingMurderExt"

    createSlider(BoxFling, "FLING MURDER SIZE: %d", 20, 100, Settings.Size_FlingMurder, function(val)
        Settings.Size_FlingMurder = val
        updateExternalButtonSizes()
    end)

    local AntiFlingToggleBtn = createBtn("ANTI FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiFlingToggleBtn.Parent = BoxFling; AntiFlingToggleBtn.LayoutOrder = 7
    UI_Toggled_Buttons[AntiFlingToggleBtn] = "AntiFlingEnabled"

    local TouchFlingToggleBtn = createBtn("TOUCH FLING: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    TouchFlingToggleBtn.Parent = BoxFling; TouchFlingToggleBtn.LayoutOrder = 8
    UI_Toggled_Buttons[TouchFlingToggleBtn] = "TouchFlingEnabled"

    createSlider(BoxFling, "TOUCH POWER: %d", 1, 200, Settings.TouchFlingPower, function(val)
        Settings.TouchFlingPower = val
    end)


    -- BOX 5: FLY & NOCLIP
    local BoxFlyNoclip = createGroupContainer("Utility", "No Clip & Fly Hack", 64)
    local FlyToggleBtn = createBtn("FLY HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    FlyToggleBtn.Parent = BoxFlyNoclip; FlyToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[FlyToggleBtn] = "FlyEnabled"

    createSlider(BoxFlyNoclip, "FLY SPEED: %d", 10, 150, Settings.FlySpeedValue, function(val)
        Settings.FlySpeedValue = val
    end)

    local NoclipToggleBtn = createBtn("NOCLIP (WALK THRU WALLS): OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    NoclipToggleBtn.Parent = BoxFlyNoclip; NoclipToggleBtn.LayoutOrder = 3
    UI_Toggled_Buttons[NoclipToggleBtn] = "NoclipEnabled"


    -- BOX 6: INVISIBILITY & ANTI-VOID
    local BoxInvisible = createGroupContainer("Utility", "Invisibility & Defences", 46)
    local InvisibleToggleBtn = createBtn("INVISIBLE HACK: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    InvisibleToggleBtn.Parent = BoxInvisible; InvisibleToggleBtn.LayoutOrder = 1
    UI_Toggled_Buttons[InvisibleToggleBtn] = "InvisibleEnabled"

    local AntiVoidToggleBtn = createBtn("ANTI VOID FALLS: OFF", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    AntiVoidToggleBtn.Parent = BoxInvisible; AntiVoidToggleBtn.LayoutOrder = 2
    UI_Toggled_Buttons[AntiVoidToggleBtn] = "AntiVoidEnabled"


    -- BOX 7: MASTER CONTROL TOMBOL EKSTERNAL & SLIDER UKURAN 'L'
    local BoxUIControls = createGroupContainer("Utility", "Master UI Buttons Controls", 46)
    
    local MasterExtButtonsBtn = createBtn("MASTER EXT BUTTONS: ON", UDim2.new(0,0,0,0), UDim2.new(1, -10, 0, 14))
    MasterExtButtonsBtn.Parent = BoxUIControls; MasterExtButtonsBtn.LayoutOrder = 1
    UI_Toggled_Buttons[MasterExtButtonsBtn] = "MasterExtButtonsEnabled"

    createSlider(BoxUIControls, "BUTTON 'L' SIZE: %d", 20, 100, Settings.Size_L, function(val)
        Settings.Size_L = val
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
            refreshExternalButtonsVisibility()
        else
            local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 160, 0, 0)})
            t:Play(); t.Completed:Connect(function() if not MainVisible then MainFrame.Visible = false end end)
            HUDMain.Visible = false
            refreshExternalButtonsVisibility()
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
    end

    local function toggleAimbot()
        Settings.CameraAimbot = not Settings.CameraAimbot
    end

    local function toggleKnifeAimbot()
        Settings.AimbotKnifeEnabled = not Settings.AimbotKnifeEnabled
    end

    local function toggleExtAimbotMaster()
        Settings.AimbotExtEnabled = not Settings.AimbotExtEnabled
        refreshExternalButtonsVisibility()
    end

    local function toggleEsp()
        Settings.ESP = not Settings.ESP
        if not Settings.ESP then ClearGunOutlines() end
    end

    local function toggleTracersEsp()
        Settings.TracersESP = not Settings.TracersESP
        if not Settings.TracersESP then ClearAllTracers() end
    end

    local function toggleNameEsp()
        Settings.NameESP = not Settings.NameESP
    end

    local function toggleFilterMurder()
        Settings.EspMurderer = not Settings.EspMurderer
    end

    local function toggleFilterSheriff()
        Settings.EspSheriff = not Settings.EspSheriff
    end

    local function toggleFilterInnocent()
        Settings.EspInnocent = not Settings.EspInnocent
    end

    local function toggleHitbox()
        Settings.HitboxExpander = not Settings.HitboxExpander
    end

    local function toggleAutoGrab()
        Settings.AutoGrabGun = not Settings.AutoGrabGun
    end

    local function toggleManualGrabMaster()
        Settings.GrabGunExtEnabled = not Settings.GrabGunExtEnabled
        refreshExternalButtonsVisibility()
    end

    local function executeManualGrab()
        local activeGun = ScanForDroppedGun()
        if activeGun then
            SafeInstantTween(activeGun)
        end
    end

    local function toggleHideFOV()
        Settings.HideFOVCircle = not Settings.HideFOVCircle
    end

    local function toggleCameraFOV()
        Settings.CameraFOVEnabled = not Settings.CameraFOVEnabled
    end

    local function toggleFly()
        Settings.FlyEnabled = not Settings.FlyEnabled
    end

    local function toggleJumpHeight()
        Settings.JumpPowerEnabled = not Settings.JumpPowerEnabled
    end

    local function toggleNoclip()
        Settings.NoclipEnabled = not Settings.NoclipEnabled
    end

    local function toggleInvisible()
        Settings.InvisibleEnabled = not Settings.InvisibleEnabled
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
        -- Sinkronisasi Visual Fling Status
    end

    local function toggleFlingMurder()
        Settings.AutoFlingMurder = not Settings.AutoFlingMurder
        if Settings.AutoFlingMurder then Settings.AutoFlingSheriff = false end
    end

    local function toggleFlingSheriff()
        Settings.AutoFlingSheriff = not Settings.AutoFlingSheriff
        if Settings.AutoFlingSheriff then Settings.AutoFlingMurder = false end
    end

    local function toggleSpeedWalk()
        Settings.SpeedWalkEnabled = not Settings.SpeedWalkEnabled
        if not Settings.SpeedWalkEnabled then pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end
    end

    local function toggleDoubleJump()
        Settings.DoubleJumpEnabled = not Settings.DoubleJumpEnabled
    end

    local function toggleDoubleJumpExt()
        Settings.DoubleJumpExtEnabled = not Settings.DoubleJumpExtEnabled
        refreshExternalButtonsVisibility()
    end

    -- TOGGLE & HANDLERS UNTUK FITUR BARU
    local function toggleSpin()
        Settings.SpinEnabled = not Settings.SpinEnabled
    end

    local function toggleSpinExt()
        Settings.SpinEnabledExt = not Settings.SpinEnabledExt
        refreshExternalButtonsVisibility()
    end

    local function toggleTPSheriffExt()
        Settings.TPSheriffExt = not Settings.TPSheriffExt
        refreshExternalButtonsVisibility()
    end

    local function toggleTPMurderExt()
        Settings.TPMurderExt = not Settings.TPMurderExt
        refreshExternalButtonsVisibility()
    end

    local function toggleFlingMurderExt()
        Settings.FlingMurderExt = not Settings.FlingMurderExt
        refreshExternalButtonsVisibility()
    end

    local function toggleFlingSheriffExt()
        Settings.FlingSheriffExt = not Settings.FlingSheriffExt
        refreshExternalButtonsVisibility()
    end

    local function toggleTPLobbyExt()
        Settings.TPLobbyExt = not Settings.TPLobbyExt
        refreshExternalButtonsVisibility()
    end

    local function toggleTPUndergroundExt()
        Settings.TPUndergroundExt = not Settings.TPUndergroundExt
        refreshExternalButtonsVisibility()
    end

    local function toggleTPPreFlingExt()
        Settings.TPPreFlingExt = not Settings.TPPreFlingExt
        refreshExternalButtonsVisibility()
    end

    local function toggleAntiFling()
        Settings.AntiFlingEnabled = not Settings.AntiFlingEnabled
    end

    local function toggleTouchFling()
        Settings.TouchFlingEnabled = not Settings.TouchFlingEnabled
    end

    local function toggleInfiniteJump()
        Settings.InfiniteJumpEnabled = not Settings.InfiniteJumpEnabled
    end

    local function toggleAntiVoid()
        Settings.AntiVoidEnabled = not Settings.AntiVoidEnabled
    end

    local function toggleMasterExtButtons()
        Settings.MasterExtButtonsEnabled = not Settings.MasterExtButtonsEnabled
        refreshExternalButtonsVisibility()
    end

    -- KONEKSI EVENT KE TOMBOL-TOMBOL FITUR
    KillAuraToggleBtn.MouseButton1Click:Connect(toggleKillAura)
    KillAllBtn.MouseButton1Click:Connect(TeleportAllPlayersToMe)

    ToggleBtn.MouseButton1Click:Connect(toggleAimbot)
    KnifeAimbotToggleBtn.MouseButton1Click:Connect(toggleKnifeAimbot)
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
    SpeedWalkBtn.MouseButton1Click:Connect(toggleSpeedWalk)

    FlyToggleBtn.MouseButton1Click:Connect(toggleFly)
    JumpToggleBtn.MouseButton1Click:Connect(toggleJumpHeight)
    NoclipToggleBtn.MouseButton1Click:Connect(toggleNoclip)
    InvisibleToggleBtn.MouseButton1Click:Connect(toggleInvisible)

    DoubleJumpToggleBtn.MouseButton1Click:Connect(toggleDoubleJump)
    DoubleJumpExtToggleBtn.MouseButton1Click:Connect(toggleDoubleJumpExt)
    ExtDoubleJumpBtn.MouseButton1Click:Connect(toggleDoubleJump)

    -- Koneksi Event Tambahan Fitur Baru
    SpinToggleBtn.MouseButton1Click:Connect(toggleSpin)
    SpinExtToggleBtn.MouseButton1Click:Connect(toggleSpinExt)
    ExtSpinBtn.MouseButton1Click:Connect(toggleSpin)

    TpSheriffBtn.MouseButton1Click:Connect(TPToSheriff)
    TpSheriffExtToggleBtn.MouseButton1Click:Connect(toggleTPSheriffExt)
    ExtTPSheriffBtn.MouseButton1Click:Connect(TPToSheriff)

    TpMurderBtn.MouseButton1Click:Connect(TPToMurderer)
    TpMurderExtToggleBtn.MouseButton1Click:Connect(toggleTPMurderExt)
    ExtTPMurderBtn.MouseButton1Click:Connect(TPToMurderer)

    FlingMurderExtBtn.MouseButton1Click:Connect(toggleFlingMurderExt)
    ExtFlingMurderBtn.MouseButton1Click:Connect(toggleFlingMurder)

    FlingSheriffExtBtn.MouseButton1Click:Connect(toggleFlingSheriffExt)
    ExtFlingSheriffBtn.MouseButton1Click:Connect(toggleFlingSheriff)

    TpLobbyBtn.MouseButton1Click:Connect(TPToLobby)
    TpLobbyExtToggleBtn.MouseButton1Click:Connect(toggleTPLobbyExt)
    ExtTPLobbyBtn.MouseButton1Click:Connect(TPToLobby)

    TpUndergroundBtn.MouseButton1Click:Connect(TPUnderground)
    TpUndergroundExtToggleBtn.MouseButton1Click:Connect(toggleTPUndergroundExt)
    ExtTPUndergroundBtn.MouseButton1Click:Connect(TPUnderground)

    TpPreFlingBtn.MouseButton1Click:Connect(TPPreFling)
    TpPreFlingExtToggleBtn.MouseButton1Click:Connect(toggleTPPreFlingExt)
    ExtTPPreFlingBtn.MouseButton1Click:Connect(TPPreFling)

    AntiFlingToggleBtn.MouseButton1Click:Connect(toggleAntiFling)
    TouchFlingToggleBtn.MouseButton1Click:Connect(toggleTouchFling)
    InfJumpToggleBtn.MouseButton1Click:Connect(toggleInfiniteJump)
    AntiVoidToggleBtn.MouseButton1Click:Connect(toggleAntiVoid)
    MasterExtButtonsBtn.MouseButton1Click:Connect(toggleMasterExtButtons)

    VisualBtn.MouseButton1Click:Connect(function()
        Settings.HitboxVisual = not Settings.HitboxVisual
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

    -- Dragging Frame Utama (Menggunakan SafeConnect)
    local dragging, dragStart, startPos
    SafeConnect(MainFrame.InputBegan, function(i) if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then dragging = true; dragStart = i.Position; startPos = MainFrame.Position end end)
    SafeConnect(UserInputService.InputChanged, function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
    SafeConnect(UserInputService.InputEnded, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    startLoading()
    print("Louis Hub FREE V13.5.2: Rebuilt Box Systems & Memory Leak Patch Successfully Initialized.")
end
