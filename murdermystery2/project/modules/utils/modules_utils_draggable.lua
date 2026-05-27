local draggable = {}
local UserInputService = game:GetService("UserInputService")
local connections = require("core/connections")
local Settings = require("core/settings")

function draggable.Make(button)
    local dragging, dragStart, startPos
    connections.SafeConnect(button.InputBegan, function(i) 
        if not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then 
            dragging = true
            dragStart = i.Position
            startPos = button.Position 
        end 
    end)
    connections.SafeConnect(UserInputService.InputChanged, function(i) 
        if dragging and not Settings.DragLocked and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local d = i.Position - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) 
        end 
    end)
    connections.SafeConnect(UserInputService.InputEnded, function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end 
    end)
end

return draggable