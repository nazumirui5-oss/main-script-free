-- [[ LOUIS HUB FREE - INTEGRATED & PROTECTED EDITION ]]
-- AUTH: Louis | LAYERS: 1, 3, 4 (Handshake, Key, Anti-Tamper)
-- VERSION: 13.5.2 (Security Sync Update - MM2 Edition)

return function(AccessKey)
    -- Inisialisasi Sistem Modul Virtual
    local modules = {}

    -- Pendaftaran modul (Path mapping)
    local function require(path)
        local mod = modules[path]
        if not mod then
            error("Module not found: " .. tostring(path))
        end
        if type(mod) == "function" then
            modules[path] = mod()
            return modules[path]
        end
        return mod
    end

    -- [Load Core Modules]
    modules["core/init"] = loadstring(game:HttpGet("path_to/modules/core/init.lua"))()
    modules["core/settings"] = loadstring(game:HttpGet("path_to/modules/core/settings.lua"))()
    modules["core/connections"] = loadstring(game:HttpGet("path_to/modules/core/connections.lua"))()
    modules["core/cleanup"] = loadstring(game:HttpGet("path_to/modules/core/cleanup.lua"))()

    -- [Load Utils Modules]
    modules["utils/math"] = loadstring(game:HttpGet("path_to/modules/utils/math.lua"))()
    modules["utils/tween"] = loadstring(game:HttpGet("path_to/modules/utils/tween.lua"))()
    modules["utils/draggable"] = loadstring(game:HttpGet("path_to/modules/utils/draggable.lua"))()
    modules["utils/drawing"] = loadstring(game:HttpGet("path_to/modules/utils/drawing.lua"))()

    -- [Load Security Modules]
    modules["security/handshake"] = loadstring(game:HttpGet("path_to/modules/security/handshake.lua"))()
    modules["security/antitamper"] = loadstring(game:HttpGet("path_to/modules/security/antitamper.lua"))()
    modules["security/webhook"] = loadstring(game:HttpGet("path_to/modules/security/webhook.lua"))()
    modules["security/debugger"] = loadstring(game:HttpGet("path_to/modules/security/debugger.lua"))()

    -- [Load Systems Modules]
    modules["systems/rolemanager"] = loadstring(game:HttpGet("path_to/modules/systems/rolemanager.lua"))()
    modules["systems/targetfinder"] = loadstring(game:HttpGet("path_to/modules/systems/targetfinder.lua"))()
    modules["systems/prediction"] = loadstring(game:HttpGet("path_to/modules/systems/prediction.lua"))()
    modules["systems/gungrab"] = loadstring(game:HttpGet("path_to/modules/systems/gungrab.lua"))()
    modules["systems/potato"] = loadstring(game:HttpGet("path_to/modules/systems/potato.lua"))()

    -- [Load Combat Modules]
    modules["combat/aimbot"] = loadstring(game:HttpGet("path_to/modules/combat/aimbot.lua"))()
    modules["combat/hitbox"] = loadstring(game:HttpGet("path_to/modules/combat/hitbox.lua"))()
    modules["combat/killaura"] = loadstring(game:HttpGet("path_to/modules/combat/killaura.lua"))()
    modules["combat/autofling"] = loadstring(game:HttpGet("path_to/modules/combat/autofling.lua"))()

    -- [Load ESP Modules]
    modules["esp/esp"] = loadstring(game:HttpGet("path_to/modules/esp/esp.lua"))()
    modules["esp/tracers"] = loadstring(game:HttpGet("path_to/modules/esp/tracers.lua"))()
    modules["esp/nameesp"] = loadstring(game:HttpGet("path_to/modules/esp/nameesp.lua"))()
    modules["esp/gunesp"] = loadstring(game:HttpGet("path_to/modules/esp/gunesp.lua"))()

    -- [Load Movement Modules]
    modules["movement/fly"] = loadstring(game:HttpGet("path_to/modules/movement/fly.lua"))()
    modules["movement/speed"] = loadstring(game:HttpGet("path_to/modules/movement/speed.lua"))()
    modules["movement/noclip"] = loadstring(game:HttpGet("path_to/modules/movement/noclip.lua"))()
    modules["movement/doublejump"] = loadstring(game:HttpGet("path_to/modules/movement/doublejump.lua"))()
    modules["movement/invisible"] = loadstring(game:HttpGet("path_to/modules/movement/invisible.lua"))()

    -- [Load UI Modules]
    modules["ui/components"] = loadstring(game:HttpGet("path_to/modules/ui/components.lua"))()
    modules["ui/loading"] = loadstring(game:HttpGet("path_to/modules/ui/loading.lua"))()
    modules["ui/hud"] = loadstring(game:HttpGet("path_to/modules/ui/hud.lua"))()
    modules["ui/externalbuttons"] = loadstring(game:HttpGet("path_to/modules/ui/externalbuttons.lua"))()
    modules["ui/tabs"] = loadstring(game:HttpGet("path_to/modules/ui/tabs.lua"))()
    modules["ui/mainui"] = loadstring(game:HttpGet("path_to/modules/ui/mainui.lua"))()

    -- === EKSEKUSI PIPELINE INHERITANCE ===
    local init = require("core/init")
    local LocalPlayer, MyID = init.GetPlayer()

    -- Proteksi 1 & Keamanan Internal
    local handshake = require("security/handshake")
    if not handshake.Verify(MyID, LocalPlayer) then return end

    local antitamper = require("security/antitamper")
    if not antitamper.Check(LocalPlayer) then return end

    if AccessKey ~= "LouisVIP_Secret_Key_9922" then 
        LocalPlayer:Kick("LOUIS HUB: Bypass Detected (Key Error)")
        return 
    end

    -- Jalankan Debugger & Webhook Monitor
    local debugger = require("security/debugger")
    debugger.Start(LocalPlayer)

    -- Pembersihan Sesi Lama
    local cleanup = require("core/cleanup")
    cleanup.CleanAll()

    -- Inisialisasi UI Utama & Layanan Internal
    local loading = require("ui/loading")
    local mainui = require("ui/mainui")

    mainui.Initialize(require)
    loading.Start(LocalPlayer, function()
        mainui.Show()
    end)
end
