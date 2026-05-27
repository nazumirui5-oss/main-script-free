local drawingUtils = {}
_G.LouisDrawings = _G.LouisDrawings or {}

function drawingUtils.New(className)
    local drawing = Drawing.new(className)
    table.insert(_G.LouisDrawings, drawing)
    return drawing
end

return drawingUtils