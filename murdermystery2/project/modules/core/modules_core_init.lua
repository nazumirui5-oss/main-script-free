local init = {}
local Players = game:GetService("Players")

function init.GetPlayer()
    local LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer
    local MyID = LocalPlayer and LocalPlayer.UserId or (game.Players.LocalPlayer and game.Players.LocalPlayer.UserId)
    
    if not MyID then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LocalPlayer = Players.LocalPlayer
        MyID = LocalPlayer.UserId
    end
    return LocalPlayer, MyID
end

return init
