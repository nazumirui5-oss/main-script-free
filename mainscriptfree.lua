-- [[ LOUIS HUB VIP: JUNKYU HYBRID LOADER ]]
-- AUTH: Louis | VERSION: 13.7.7 EXTERNAL-SYNC (FULL HYBRID)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- [[ SECURITY CONFIGURATION ]]
local WebhookURL = "https://discord.com/api/webhooks/1504047792841162792/8WcB9Yd3vYUhCEuelAWaQk17xFtIMADnvJFwEdMfxZinhFDeu6dG9IezhL_f3AErG9D7"

local function SecureKick(msg)
    pcall(function() LP:Kick(msg) end)
end

-- [[ DATABASE MAPPING (ID Tempat / Place ID) ]]
local SupportedGames = {
    [11379739543] = {
        GameName = "Timebomb Duels",
        Scripts = {
            { Name = "Louis Hub Premium", URL = "https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/main/mainscriptfree.lua" }
        }
    },
    [142823291] = {
        GameName = "Murder Mystery 2",
        Scripts = {
            { Name = "Louis Hub Free", URL = "https://raw.githubusercontent.com/nazumirui5-oss/Ui-Library/refs/heads/main/Loader.lua" }
        }
    }
}

local CurrentPlaceID = game.PlaceId
local GameData = SupportedGames[CurrentPlaceID]

-- Validasi dasar ID tempat untuk kedua game
if not GameData then
    SecureKick("LOUIS HUB: Access Denied. Map (" .. tostring(CurrentPlaceID) .. ") not supported.")
    return
end

-- [[ INTEGRITY CHECK - HANYA UNTUK TIMEBOMB DUELS ]]
-- Untuk MM2, proses ini otomatis dilewati (bypass) untuk mencegah kick atau lag
if CurrentPlaceID == 11379739543 then
    local _HttpGet = game.HttpGet
    local _loadstring = loadstring

    local function IntegrityCheck()
        local test = tostring(_HttpGet)
        if not test:find("function") or test:find("custom") or test:find("hook") then
            SecureKick("LOUIS HUB: Security Violation (Executor Hook Detected)")
            return false
        end
        return true
    end

    if not IntegrityCheck() then return end
end

-- [[ WEBHOOK LOGIC ]]
local function NotifyDiscord(status, detail, scriptName)
    task.spawn(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if request then
            local executor = (identifyexecutor and identifyexecutor() or "Unknown")
            local payload = {
                ["embeds"] = {{
                    ["title"] = "🛡️ LOUIS HUB VIP - JUNKYU HYBRID LOG",
                    ["description"] = "Activity detected at " .. os.date("%X"),
                    ["color"] = (status == "SUCCESS" and 0x00FF00 or 0xFF0000),
                    ["fields"] = {
                        {["name"] = "👤 Player", ["value"] = "Name: " .. LP.Name .. "\nID: " .. tostring(LP.UserId), ["inline"] = true},
                        {["name"] = "🎮 Game", ["value"] = "Name: " .. GameData.GameName .. "\nPlaceID: " .. tostring(CurrentPlaceID), ["inline"] = true},
                        {["name"] = "💻 Executor", ["value"] = executor, ["inline"] = true},
                        {["name"] = "📜 Script", ["value"] = scriptName or "None", ["inline"] = false},
                        {["name"] = "📊 Status", ["value"] = status, ["inline"] = false},
                        {["name"] = "📝 Detail", ["value"] = detail or "No additional info.", ["inline"] = false}
                    },
                    ["footer"] = {["text"] = "Louis Hub v13.7.7 | Hybrid Sync System"}
                }}
            }
            pcall(function()
                request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
            end)
        end
    end)
end

-- [[ FETCH LOGIC ]]
local function FetchRemote(url)
    local content
    for i = 1, 3 do
        local success, res = pcall(function() return game:HttpGet(url .. "?cache=" .. math.random(1, 999999)) end)
        if success and res then content = res break end
        task.wait(1)
    end
    return content
end

-- [[ CORE EXECUTION ]]
local function ExecuteSelectedScript(scriptInfo)
    local mainCode = FetchRemote(scriptInfo.URL)
    if not mainCode then
        NotifyDiscord("FAILED", "Could not fetch MainScript from GitHub.", scriptInfo.Name)
        SecureKick("LOUIS HUB: Failed to fetch script assets.")
        return
    end

    if CurrentPlaceID == 142823291 then
        -- [[ JALUR MURDER MYSTERY 2 (BYPASS TOTAL) ]]
        local compileSuccess, mainFunc = pcall(loadstring, mainCode)
        if compileSuccess and type(mainFunc) == "function" then
            -- Handshake dasar disiapkan agar script utama MM2 tidak error
            getgenv().LouisVerify = function() return "LouisVIP_Validated_" .. tostring(LP.UserId) end
            
            -- Eksekusi langsung tanpa verifikasi ganda/loop yang berlebihan agar tidak lag
            local execSuccess, runResult = pcall(mainFunc, "LouisVIP_Secret_Key_9922")
            if execSuccess then
                NotifyDiscord("SUCCESS", "Louis Hub Loaded for MM2 (Bypassed Mode).", scriptInfo.Name)
            else
                NotifyDiscord("CRITICAL ERROR", "Execution error: " .. tostring(runResult), scriptInfo.Name)
            end
        else
            NotifyDiscord("CRITICAL ERROR", "Failed to compile MM2 code.", scriptInfo.Name)
        end
        
    elseif CurrentPlaceID == 11379739543 then
        -- [[ JALUR TIMEBOMB DUELS (KEAMANAN PENUH) ]]
        getgenv().LouisVerify = function() return "LouisVIP_Validated_" .. tostring(LP.UserId) end
        
        local compileSuccess, mainFunc = pcall(loadstring, mainCode)
        if compileSuccess and type(mainFunc) == "function" then
            local execSuccess, runResult = pcall(mainFunc, "LouisVIP_Secret_Key_9922")
            
            if execSuccess then
                -- Menjalankan fungsi lapis kedua jika dikembalikan oleh script utama (sesuai script asli)
                if type(runResult) == "function" then
                    pcall(runResult, "LouisVIP_Secret_Key_9922")
                end
                NotifyDiscord("SUCCESS", "Handshake Completed. Louis Hub Loaded.", scriptInfo.Name)
            else
                NotifyDiscord("CRITICAL ERROR", "Execution error: " .. tostring(runResult), scriptInfo.Name)
                SecureKick("LOUIS HUB: Handshake Failed (Runtime Error).")
            end
        else
            NotifyDiscord("CRITICAL ERROR", "Failed to compile the loaded code.", scriptInfo.Name)
            SecureKick("LOUIS HUB: Compilation Error.")
        end
    end
end

-- [[ TRIGGER ]]
local ScriptList = GameData.Scripts
if ScriptList and #ScriptList == 1 then
    ExecuteSelectedScript(ScriptList[1])
end
