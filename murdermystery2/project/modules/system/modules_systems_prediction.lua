local prediction = {}
local Camera = workspace.CurrentCamera

function prediction.GetPredictedPosition(LocalPlayer, targetPart)
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

return prediction