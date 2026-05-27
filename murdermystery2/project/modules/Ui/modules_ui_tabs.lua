local tabs = {}

function tabs.CreateSystem(MainFrame, ContentFrame, tabNames)
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(1, -12, 0, 18)
    TabBar.Position = UDim2.new(0, 6, 0, 21)
    TabBar.BackgroundTransparency = 1

    local TabButtons = {}
    local TabFrames = {}
    local TabWidth = 1 / #tabNames

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

    for _, name in ipairs(tabNames) do 
        CreateTabFrame(name) 
    end

    local function ShowTab(tabName)
        for name, frame in pairs(TabFrames) do 
            frame.Visible = (name == tabName) 
        end
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 255, 255)
            btn.TextColor3 = (name == tabName) and Color3.new(0,0,0) or Color3.new(1,1,1)
        end
    end

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton", TabBar)
        btn.Size = UDim2.new(TabWidth, -1, 1, 0)
        btn.Position = UDim2.new((i-1)*TabWidth, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Text = name:upper()
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 5.2
        btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        TabButtons[name] = btn
        
        btn.MouseButton1Click:Connect(function() ShowTab(name) end)
    end

    ShowTab("Main")
    return TabFrames
end

return tabs