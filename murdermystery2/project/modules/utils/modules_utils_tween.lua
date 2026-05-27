local tweenUtils = {}
local TweenService = game:GetService("TweenService")

function tweenUtils.Create(obj, info, target)
    local tween = TweenService:Create(obj, info, target)
    tween:Play()
    return tween
end

return tweenUtils