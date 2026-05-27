local esp = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local connections = require("core/connections")
local Settings = require("core/settings")
local rolemanager = require("systems/rolemanager")
local drawing = require("utils/drawing")

local ActiveTracers = {}

function esp.Start(LocalPlayer)
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
        
        local role = rolemanager.GetMM2Role(player)
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

    local function ClearAllTracers()
        for _, tracer in pairs(ActiveTracers) do
            tracer.Visible = false
            tracer:Remove()
        end
        ActiveTracers = {}
    end

    connections.SafeConnect(RunService.RenderStepped, function()
        if not Settings.TracersESP then
            ClearAllTracers()
        end

        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Root = Player.Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                
                if Root and Humanoid and Humanoid.Health > 0 then
                    local Role = rolemanager.GetMM2Role(Player)
                    
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
                    end

                    local TargetColor = Color3.fromRGB(0, 225, 0)
                    if Role == "Murderer" then TargetColor = Color3.fromRGB(255, 0, 0)
                    elseif Role == "Sheriff" then TargetColor = Color3.fromRGB(0, 0, 225) end

                    -- Outlines ESP
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
                                Tracer = drawing.New("Line")
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
end

return esp