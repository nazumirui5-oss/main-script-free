local aimbot = {}
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local connections = require("core/connections")
local Settings = require("core/settings")
local targetfinder = require("systems/targetfinder")
local prediction = require("systems/prediction")
local rolemanager = require("systems/rolemanager")

function aimbot.Init(LocalPlayer)
    connections.SafeConnect(RunService.RenderStepped, function()
        if Settings.CameraAimbot and LocalPlayer.Character then
            local HoldsGun = LocalPlayer.Character:FindFirstChild("Gun")
            if HoldsGun and HoldsGun:IsA("Tool") then
                local MyRole = rolemanager.GetMM2Role(LocalPlayer)
                
                if MyRole == "Murderer" then
                    local TargetPart = targetfinder.GetTargetForMurderer(LocalPlayer)
                    if TargetPart then
                        local PredictedPos = prediction.GetPredictedPosition(LocalPlayer, TargetPart)
                        if PredictedPos then
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, PredictedPos)
                        end
                    end
                else
                    local TargetPart = targetfinder.GetTargetForInnocentOrSheriff(LocalPlayer)
                    if TargetPart then
                        local PredictedPos = prediction.GetPredictedPosition(LocalPlayer, TargetPart)
                        if PredictedPos then
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, PredictedPos)
                        end
                    end
                end
            end
        end
    end)
end

return aimbot