local externalbuttons = {}
local RunService = game:GetService("RunService")
local connections = require("core/connections")
local draggable = require("utils/draggable")
local Settings = require("core/settings")

local function ApplyExternalButtonStyle(btn, stroke)
    btn.BackgroundTransparency = 0.6
    connections.SafeConnect(RunService.RenderStepped, function()
        local hue = (tick() % 4) / 4
        stroke.Color = Color3.fromHSV(hue, 0.8, 1)
    end)
end

function externalbuttons.Create(ScreenGui)
    local buttons = {}

    -- Toggle Utama L
    local ToggleBtnMain = Instance.new("TextButton", ScreenGui)
    ToggleBtnMain.Name = "FloatingToggle"
    ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
    ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleBtnMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtnMain.Text = "L"
    ToggleBtnMain.TextColor3 = Color3.fromRGB(0, 180, 255)
    ToggleBtnMain.Font = Enum.Font.GothamBlack
    ToggleBtnMain.TextSize = 25
    ToggleBtnMain.AutoButtonColor = false
    ToggleBtnMain.Visible = false

    local ToggleStroke = Instance.new("UIStroke", ToggleBtnMain)
    ToggleStroke.Thickness = 2
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    ApplyExternalButtonStyle(ToggleBtnMain, ToggleStroke)
    draggable.Make(ToggleBtnMain)
    buttons.ToggleBtnMain = ToggleBtnMain

    -- External Aimbot A
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

    ApplyExternalButtonStyle(ExtAimbotBtn, ExtAimbotStroke)
    draggable.Make(ExtAimbotBtn)
    buttons.ExtAimbotBtn = ExtAimbotBtn

    -- External Grab G
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

    ApplyExternalButtonStyle(ExtGrabBtn, ExtGrabStroke)
    draggable.Make(ExtGrabBtn)
    buttons.ExtGrabBtn = ExtGrabBtn

    -- External Double Jump DJ
    local ExtDoubleJumpBtn = Instance.new("TextButton", ScreenGui)
    ExtDoubleJumpBtn.Name = "ExtDoubleJump"
    ExtDoubleJumpBtn.Size = UDim2.new(0, Settings.Size_DJ, 0, Settings.Size_DJ)
    ExtDoubleJumpBtn.Position = UDim2.new(0, 20, 0.5, 135)
    ExtDoubleJumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ExtDoubleJumpBtn.Text = "DJ"
    ExtDoubleJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExtDoubleJumpBtn.Font = Enum.Font.GothamBold
    ExtDoubleJumpBtn.TextSize = 18
    ExtDoubleJumpBtn.Visible = false
    Instance.new("UICorner", ExtDoubleJumpBtn).CornerRadius = UDim.new(1, 0)
    local ExtDoubleJumpStroke = Instance.new("UIStroke", ExtDoubleJumpBtn)
    ExtDoubleJumpStroke.Thickness = 1.5

    ApplyExternalButtonStyle(ExtDoubleJumpBtn, ExtDoubleJumpStroke)
    draggable.Make(ExtDoubleJumpBtn)
    buttons.ExtDoubleJumpBtn = ExtDoubleJumpBtn

    function buttons.UpdateSizes()
        ToggleBtnMain.Size = UDim2.new(0, Settings.Size_L, 0, Settings.Size_L)
        ExtAimbotBtn.Size = UDim2.new(0, Settings.Size_A, 0, Settings.Size_A)
        ExtGrabBtn.Size = UDim2.new(0, Settings.Size_G, 0, Settings.Size_G)
        ExtDoubleJumpBtn.Size = UDim2.new(0, Settings.Size_DJ, 0, Settings.Size_DJ)
    end

    return buttons
end

return externalbuttons