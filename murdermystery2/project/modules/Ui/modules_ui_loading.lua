local loading = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

function loading.Start(LocalPlayer, onComplete)
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
            if onComplete then onComplete() end
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

return loading