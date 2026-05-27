local hud = {}
local RunService = game:GetService("RunService")
local connections = require("core/connections")
local potato = require("systems/potato")

function hud.Create(ScreenGui)
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
    PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 9; PingLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GraphFrame = Instance.new("Frame", HUDFrame)
    GraphFrame.Size = UDim2.new(0, 35, 0, 35); GraphFrame.Position = UDim2.new(1, -75, 0, 5); GraphFrame.BackgroundTransparency = 1

    local bars = {}
    for i = 1, 10 do
        local b = Instance.new("Frame", GraphFrame)
        b.Size = UDim2.new(0, 2, 0, 10); b.Position = UDim2.new(0, i*3, 1, -10)
        b.BackgroundColor3 = Color3.fromRGB(0, 180, 255); b.BorderSizePixel = 0; bars[i] = b
    end

    local PotatoToggle = Instance.new("TextButton", HUDFrame)
    PotatoToggle.Size = UDim2.new(0, 30, 0, 25); PotatoToggle.Position = UDim2.new(1, -35, 0.5, -12.5)
    PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); PotatoToggle.Text = "🍃"; PotatoToggle.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", PotatoToggle)
    local PotatoStroke = Instance.new("UIStroke", PotatoToggle)
    PotatoStroke.Color = Color3.fromRGB(100, 100, 100)
    PotatoStroke.Thickness = 1.5

    local potatoEnabled = false
    PotatoToggle.MouseButton1Click:Connect(function()
        potatoEnabled = not potatoEnabled
        if potatoEnabled then
            potato.Apply()
            PotatoToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            PotatoStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            PotatoToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            PotatoStroke.Color = Color3.fromRGB(100, 100, 100)
        end
    end)

    local HUDToggleBtn = Instance.new("TextButton", HUDMain)
    HUDToggleBtn.Size = UDim2.new(0, 15, 1, 0); HUDToggleBtn.Position = UDim2.new(1, -15, 0, 0)
    HUDToggleBtn.BackgroundColor3 = Color3.new(0,0,0); HUDToggleBtn.BackgroundTransparency = 0.8; HUDToggleBtn.Text = ">"
    HUDToggleBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", HUDToggleBtn)

    local hudMinimized = false
    HUDToggleBtn.MouseButton1Click:Connect(function()
        hudMinimized = not hudMinimized
        HUDFrame:TweenSize(hudMinimized and UDim2.new(0, 0, 1, 0) or UDim2.new(1, -20, 1, 0), "Out", "Quad", 0.3, true)
        HUDToggleBtn.Text = hudMinimized and "<" or ">"
    end)

    task.spawn(function()
        local lastTime = tick(); local frames = 0
        local LocalPlayer = game:GetService("Players").LocalPlayer
        connections.SafeConnect(RunService.RenderStepped, function()
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

    return HUDMain
end

return hud