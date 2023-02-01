Config = {}

Config.Setup = {
    Distance = 3, -- distance to show armoury ui
    Key = 38, -- key to open
    KeyName = '~INPUT_PICKUP~' -- keyname (https://docs.fivem.net/docs/game-references/controls/)
}

Config.Ped = {
    PedModel = "s_m_y_cop_01",
    AnimDictionary = "anim@amb@nightclub@peds@",
    Animation = "rcmme_amanda1_stand_loop_cop"
}

Config.Zones = { -- the type has to match the type defined in Config.Weapons
    { Type = "Police", loc = vector3(454.07, -980.03, 30.69), h = 89.46 } -- armoury locations, types have to be specified and they also have to be configured in the Config.Weapons section below.
}

Config.Weapons = {
    ["Police"] = { -- Type
        {
            WeaponGameName = "WEAPON_CARBINERIFLE",
            DisplayName = "Carbine Rifle",
            Attachments = {
                { GameCode = "COMPONENT_AT_AR_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_COMBATPISTOL_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
        {
            WeaponGameName = "WEAPON_COMBATPISTOL",
            DisplayName = "Combat Pistol",
            Attachments = {
                { GameCode = "COMPONENT_AT_PI_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_COMBATPISTOL_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
        {
            WeaponGameName = "WEAPON_SNIPERRIFLE",
            DisplayName = "Sniper Rifle",
            Attachments = {
                { GameCode = "COMPONENT_AT_PI_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_COMBATPISTOL_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
    },
    ["EMS"] = {
        {
            WeaponGameName = "WEAPON_CARBINERIFLE",
            DisplayName = "Carbine Rifle",
            Attachments = {
                { GameCode = "COMPONENT_AT_PI_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_COMBATPISTOL_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
        {
            WeaponGameName = "WEAPON_CARBINERIFLE",
            DisplayName = "Carbine Rifle",
            Attachments = {
                { GameCode = "COMPONENT_AT_PI_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_COMBATPISTOL_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
        {
            WeaponGameName = "WEAPON_CARBINERIFLE",
            DisplayName = "Carbine Rifle",
            Attachments = {
                { GameCode = "COMPONENT_AT_AR_FLSH", Label = "Flashlight", Toggled = false },
                { GameCode = "COMPONENT_CARBINERIFLE_CLIP_02", Label = "Extendo", Toggled = true },
            },
        },
    },
}

Config.RackableWeapons = {
    FrameworkCfg = { -- configure your own framewokr functions with the JobCheck() function below
        Enabled = true,
        AllowedJobs = { 'BCSO' }
    },
    MeCfg = { -- Displays in chat locally to nearby players when a weapon is racked/unracked
        Enabled = true,
        Distance = 10
    },
    WeaponCfg = { -- set your weapons here
        ["rifle"] = { -- this will be the command to toggle rack the weapon in a vehicle
            WeaponGameName = "WEAPON_CARBINERIFLE",
            Attachments = { "COMPONENT_AT_AR_FLSH", "COMPONENT_CARBINERIFLE_CLIP_02" },
            AllowedVehCategories = { 18, 1 }
        },
        ["shotgun"] = {
            WeaponGameName = "WEAPON_PUMPSHOTGUN",
            Attachments = { "COMPONENT_AT_AR_FLSH" },
            AllowedVehCategories = { 18, 1 }
        },
    }
}

function JobCheck()
    local check = false
    local id = GetPlayerServerId(PlayerId())
    local framework = exports.framework:getclientdept(id)
    for k, Jobs in pairs(Config.RackableWeapons.FrameworkCfg.AllowedJobs) do
        if framework[id].dept == Jobs then
            check = true
        end
    end
    return check
end

function Notify(msg)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { "System", msg }
    })
end
