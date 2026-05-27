local mathUtils = {}

function mathUtils.Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return mathUtils