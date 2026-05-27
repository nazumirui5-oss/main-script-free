local gungrab = {}
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

function gungrab.Scan()
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

return gungrab