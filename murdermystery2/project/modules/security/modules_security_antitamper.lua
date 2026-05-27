local antitamper = {}

function antitamper.Check(LocalPlayer)
    local test = tostring(game.HttpGet)
    if not test:find("function") or test:find("custom") or test:find("hook") then
        if LocalPlayer then
            LocalPlayer:Kick("LOUIS HUB: Security Violation (Hook Detected)")
        end
        return false
    end
    return true
end

return antitamper