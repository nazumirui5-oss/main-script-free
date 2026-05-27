local debugger = {}
local webhook = require("security/webhook")

_G.LouisSecurityRunning = false

function debugger.Start(LocalPlayer)
    _G.LouisSecurityRunning = false
    task.wait(0.1)
    _G.LouisSecurityRunning = true

    local CoreGui = game:GetService("CoreGui")
    local BlacklistNames = {
        "SimpleSpy", "Hydroxide", "TurtleSpy", "RemoteSpy", "Explorer", 
        "Dex", "DarkDex", "Adonis", "V.G Hub Spy", "OwlHub Spy", 
        "Postman", "ScriptDumper", "SaveInstance", "RbxSpy"
    }

    local function ScanDeeper()
        for _, name in pairs(BlacklistNames) do
            if CoreGui:FindFirstChild(name) then return true, name end
        end
        for _, obj in pairs(CoreGui:GetChildren()) do
            if obj:IsA("ScreenGui") and not obj:IsA("PluginGui") then
                local data = tostring(obj):lower()
                if data:find("spy") or data:find("remote") or data:find("debug") then
                    return true, obj.Name
                end
            end
        end
        return false
    end

    task.spawn(function()
        while _G.LouisSecurityRunning do
            local detected, toolFound = false, ""
            pcall(function() 
                local found, name = ScanDeeper()
                if found then 
                    detected = true 
                    toolFound = name
                end 
            end)
            
            if detected then
                _G.LouisSecurityRunning = false
                webhook.SendAlert(LocalPlayer, toolFound)
                task.wait(0.1)
                LocalPlayer:Kick("\n[LOUIS HUB SECURITY]\nUnauthorized Debugging Tool Detected: " .. toolFound)
                break
            end
            task.wait(3)
        end
    end)
end

return debugger