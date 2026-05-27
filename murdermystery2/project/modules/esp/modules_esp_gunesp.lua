local gunesp = {}

function gunesp.Apply(gunPart)
    if not gunPart or gunPart:FindFirstChild("LouisGunOutline") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "LouisGunOutline"
    highlight.FillColor = Color3.fromRGB(0, 100, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = gunPart
    highlight.Parent = gunPart
end

function gunesp.Clear()
    for _, object in ipairs(workspace:GetDescendants()) do
        if object.Name == "LouisGunOutline" then
            object:Destroy()
        end
    end
end

return gunesp