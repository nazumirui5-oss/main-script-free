local components = {}
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local connections = require("core/connections")

function components.CreateBtn(txt, pos, size, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 6.5
    b.ClipsDescendants = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

function components.CreateLabel(txt, pos, size, parent)
    local l = Instance.new("TextLabel", parent)
    l.Size = size or UDim2.new(0, 148, 0, 10)
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(200, 200, 200)
    l.TextSize = 7
    l.Font = Enum.Font.GothamBold
    return l
end

function components.CreateSlider(parent, textFormat, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 12)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", sliderFrame)
    
    local sliderFill = Instance.new("Frame", sliderFrame)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
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
        connection = connections.SafeConnect(RunService.RenderStepped, update)
    end)
    
    connections.SafeConnect(UserInputService.InputEnded, function(input)
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

function components.CreateGroupContainer(tabFrame, titleText, boxHeight)
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
    title.TextColor3 = Color3.fromRGB(0, 180, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 5.5
    title.TextXAlignment = Enum.TextXAlignment.Left

    local list = Instance.new("UIListLayout", container)
    list.Padding = UDim.new(0, 4)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    
    container.Parent = tabFrame
    return container
end

return components