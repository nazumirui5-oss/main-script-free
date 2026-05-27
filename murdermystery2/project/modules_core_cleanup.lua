local cleanup = {}
local Players = game:GetService("Players")

function cleanup.CleanAll()
    local oldGui = (gethui and gethui():FindFirstChild("LouisHub_FREE_Edition")) or game:GetService("CoreGui"):FindFirstChild("LouisHub_FREE_Edition")
    if oldGui then oldGui:Destroy() end

    if _G.LouisConnections then
        for _, conn in pairs(_G.LouisConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
    end
    _G.LouisConnections = {}

    if _G.LouisDrawings then
        for _, drawing in pairs(_G.LouisDrawings) do
            pcall(function() drawing:Remove() end)
        end
    end
    _G.LouisDrawings = {}

    -- Bersihkan Tag Nama ESP lama
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                local billboard = head and head:FindFirstChild("MM2_NameESP")
                if billboard then billboard:Destroy() end
            end
        end)
    end
end

return cleanup