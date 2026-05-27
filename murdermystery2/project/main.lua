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
    modules["core/init"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/core/modules_core_init.lua"))()
    modules["core/settings"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/core/modules_core_settings.lua"))()
    modules["core/connections"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/core/modules_core_connections.lua"))()
    modules["core/cleanup"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/core/modules_core_cleanup.lua"))()

    -- [Load Utils Modules]
    modules["utils/math"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/utils/modules_utils_math.lua"))()
    modules["utils/tween"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/utils/modules_utils_tween.lua"))()
    modules["utils/draggable"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/utils/modules_utils_draggable.lua"))()
    modules["utils/drawing"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/utils/modules_utils_drawing.lua"))()

    -- [Load Security Modules]
    modules["security/handshake"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/security/modules_security_handshake.lua"))()
    modules["security/antitamper"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/security/modules_security_antitamper.lua"))()
    modules["security/webhook"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/security/modules_security_webhook.lua"))()
    modules["security/debugger"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/security/modules_security_debugger.lua"))()

    -- [Load Systems Modules]
    modules["systems/rolemanager"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/system/modules_systems_rolemanager.lua"))()
    modules["systems/targetfinder"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/system/modules_systems_targetfinder.lua"))()
    modules["systems/prediction"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/system/modules_systems_prediction.lua"))()
    modules["systems/gungrab"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/system/modules_systems_gungrab.lua"))()
    modules["systems/potato"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/system/modules_systems_potato.lua"))()

    -- [Load Combat Modules]
    modules["combat/aimbot"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/combat/modules_combat_aimbot.lua"))()
    modules["combat/hitbox"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/combat/modules_combat_hitbox.lua"))()
    modules["combat/killaura"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/combat/modules_combat_killaura.lua"))()
    modules["combat/autofling"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/combat/modules_combat_autofling.lua"))()

    -- [Load ESP Modules]
    modules["esp/esp"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/esp/modules_esp_esp.lua"))()
    modules["esp/tracers"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/esp/modules_esp_tracers.lua"))()
    modules["esp/nameesp"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/esp/modules_esp_nameesp.lua"))()
    modules["esp/gunesp"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/esp/modules_esp_gunesp.lua"))()

    -- [Load Movement Modules]
    modules["movement/fly"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/movement/modules_movement_fly.lua"))()
    modules["movement/speed"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/movement/modules_movement_speed.lua"))()
    modules["movement/noclip"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/movement/modules_movement_noclip.lua"))()
    modules["movement/doublejump"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/movement/modules_movement_doublejump.lua"))()
    modules["movement/invisible"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/movement/modules_movement_invisible.lua"))()

    -- [Load UI Modules]
    modules["ui/components"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_components.lua"))()
    modules["ui/loading"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_loading.lua"))()
    modules["ui/hud"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_hud.lua"))()
    modules["ui/externalbuttons"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_externalbuttons.lua"))()
    modules["ui/tabs"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_tabs.lua"))()
    modules["ui/mainui"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/nazumirui5-oss/main-script-free/refs/heads/main/murdermystery2/project/modules/Ui/modules_ui_mainui.lua"))()

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
