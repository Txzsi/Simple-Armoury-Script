RegisterNetEvent('Rack:Message')
AddEventHandler('Rack:Message', function (text, coords, type)
    local src = source
    local name = GetPlayerName(src)
    TriggerClientEvent('Send:ChatMsg', -1, text, coords, type, name, src)
    DiscordWebhook(src, GetPlayerName(src), text .. ' from a vehicle.')
end)

RegisterNetEvent('Armory:Webhook')
AddEventHandler('Armory:Webhook', function (wepname)
    local src = source
    DiscordWebhook(src, GetPlayerName(src), 'Retrieved `' .. wepname .. '` from the armory.')
end)