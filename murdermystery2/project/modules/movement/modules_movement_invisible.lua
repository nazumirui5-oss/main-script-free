local invisible = {}
local RunService = game:GetService("RunService")
local connections = require("core/connections")
local Settings = require("core/settings")

function invisible.Start(LocalPlayer)
    connections.SafeConnect(RunService.Heartbeat, function()
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
end

return invisible