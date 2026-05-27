local webhook = {}

local w1 = "https://discord.com/api/webhooks/"
local w2 = "1499859204670750952/"
local w3 = "333FbG7tb63jvKPPgD_zhHt7tn0cA1Y4T3-WLG16xQPY0uc-uozPcvnnSKS32dgzzt0P"
local WebhookURL = w1 .. w2 .. w3

function webhook.SendAlert(LocalPlayer, toolName)
    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if request then
        pcall(function()
            request({
                Url = WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode({
                    ["embeds"] = {{
                        ["title"] = "⚠️ SECURITY BREACH DETECTED!",
                        ["description"] = "A user tried to spy on Louis Hub FREE scripts.",
                        ["color"] = 0xFF0000,
                        ["fields"] = {
                            {["name"] = "👤 User", ["value"] = LocalPlayer.Name, ["inline"] = true},
                            {["name"] = "🆔 ID", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
                            {["name"] = "🔍 Detected Tool", ["value"] = toolName, ["inline"] = false},
                            {["name"] = "🛡️ Action", ["value"] = "Auto-Kick Executed", ["inline"] = true}
                        },
                        ["footer"] = {["text"] = "Louis Hub v13.5.2 | Anti-Tamper System"},
                        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }}
                })
            })
        end)
    end
end

return webhook