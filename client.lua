local inzone = false
local racked = true


Citizen.CreateThread(function()
    if NetworkIsSessionStarted() then
        ped = GetHashKey(Config.Ped.PedModel)
        RequestModel(ped)
        while not HasModelLoaded(ped) do
            Citizen.Wait(0)
        end
        for _, coords in pairs(Config.Zones) do
            local ai = CreatePed(4, ped, coords.loc.xyz, coords.h, false, true)
            SetEntityInvincible(ai, true)
            loadAnimDict2(Config.Ped.AnimDictionary)
            TaskPlayAnimAdvanced(ai, Config.Ped.AnimDictionary, Config.Ped.Animation, GetEntityCoords(ai, true), 0, 0, GetEntityHeading(ai), 8.0, 3.0, -1, 50, 100.01, 0, 0)
            SetBlockingOfNonTemporaryEvents(ai, true)
            Wait(800)
            FreezeEntityPosition(ai, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(800)
        local ped = GetPlayerPed(-1)
        local plycoords = GetEntityCoords(ped)
        for _, info in pairs(Config.Zones) do
            local distance = GetDistanceBetweenCoords(info.loc.xyz, plycoords.xyz)
            if distance <= Config.Setup.Distance then
                inzone = true
                Armoury(info.Type)
            else
                inzone = false
            end
        end
    end
end)

function Armoury(CurrZone)
    Citizen.CreateThread(function()
        while inzone do
            DisplayNotification(Config.Setup.KeyName .. ' Open Armory')
            if IsControlJustPressed(0, Config.Setup.Key) then
                SendNUIMessage({ action = "toggleOpen", Weapons = Config.Weapons[CurrZone] })
                SetNuiFocus(true, true)
            end
            Citizen.Wait(0)
        end
    end)
end

for Command, Data in pairs(Config.RackableWeapons.WeaponCfg) do
    RegisterCommand(Command, function(source, args, rawCommand)
        local vehchecks = false
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        if JobCheck() == true then
            if IsPedInAnyVehicle(ped) then
                for _, CatCheck in pairs(Config.RackableWeapons.WeaponCfg[Command].AllowedVehCategories) do
                    if CatCheck == GetVehicleClass(GetVehiclePedIsIn(ped)) then
                        vehchecks = true
                        break;
                    else
                        Notify('This vehicle cannot use this command.')
                        return
                    end
                end
            else
                Notify('You\'re not in a vehicle.')
                return
            end
        else
            Notify('You do not have the correct permissions to use this command!')
            return
        end
        if vehchecks then
            if racked then
                racked = false
                GiveWeapon(Config.RackableWeapons.WeaponCfg[Command].WeaponGameName)
                Notify('You unracked the ' .. Command .. ' from your vehicle.')
                TriggerServerEvent('Rack:Message', Command, coords, 'unracked')
                for k, v in pairs(Config.RackableWeapons.WeaponCfg[Command].Attachments) do
                    AddComponent(Config.RackableWeapons.WeaponCfg[Command].WeaponGameName, v)
                end
            else
                racked = true
                RemoveWeapon(Config.RackableWeapons.WeaponCfg[Command].WeaponGameName)
                Notify('You racked the ' .. Command .. ' inside your vehicle.')
                TriggerServerEvent('Rack:Message', Command, coords, 'racked')
            end
        end
    end)
end

RegisterNetEvent('Send:ChatMsg')
AddEventHandler('Send:ChatMsg', function(text, coords, type, name, id)
    if Config.RackableWeapons.MeCfg.Enabled and GetPlayerServerId(PlayerId()) ~= id then
        local ped = GetPlayerPed(-1)
        local plycoords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coords, plycoords)
        if distance <= Config.RackableWeapons.MeCfg.Distance then
            Notify(name .. ' ' .. type .. ' a ' .. text .. ' from their vehicle near you.')
        end
    end
end)

RegisterNUICallback("spawnloadout", function(data, cb)
    local wep = data.wep -- this is the weapon
    local ped = GetPlayerPed(-1)
    if HasPedGotWeapon(ped, wep.WeaponGameName) then
        RemoveWeapon(wep.WeaponGameName)
    end
    GiveWeapon(wep.WeaponGameName)
    Notify('You\'ve been given a ' .. wep.DisplayName .. '.')
    TriggerServerEvent('Armory:Webhook', wep.DisplayName)
    for _, Componenets in pairs(wep.Attachments) do
        if Componenets.Toggled then
            AddComponent(wep.WeaponGameName, Componenets.GameCode)
        end
    end
    cb("ok")
end)

RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

function RemoveWeapon(wep)
    local ped = GetPlayerPed(-1)
    local hash = GetHashKey(wep)
    RemoveWeaponFromPed(ped, hash)
end

function GiveWeapon(hash)
    local ped = GetPlayerPed(-1)
    local hash = GetHashKey(hash)
    GiveWeaponToPed(ped, hash, 100, false, true)
end

function AddComponent(weapon, comp)
    local ped = GetPlayerPed(-1)
    local hash = GetHashKey(weapon)
    local comphash = GetHashKey(comp)
    if HasPedGotWeapon(ped, hash, false) then
        GiveWeaponComponentToPed(ped, hash, comphash)
    end
end

function loadAnimDict2(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function DisplayNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
