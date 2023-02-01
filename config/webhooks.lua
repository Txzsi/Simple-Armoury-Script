Webhookscfg = {
    Webhook = 'WEBHOOK HERE',
    EmbedColour = 666,
    FooterText = 'Armory Logs',
    IdentifierType = 'DISCORD' -- Available: STEAM/DISCORD/LICENSE
}

function DiscordWebhook(src, name, message)
    local webhook = Webhookscfg.Webhook
    local identifier = ''
    if Webhookscfg.IdentifierType == 'DISCORD' then
        identifier = "<@" .. ExtractIdentifiers(src).discord:gsub('discord:', '') .. ">"
    elseif Webhookscfg.IdentifierType == 'STEAM' then
        identifier = '`' .. ExtractIdentifiers(src).steam .. '`'
    elseif Webhookscfg.IdentifierType == 'LICENSE' then
        identifier = '`' .. ExtractIdentifiers(src).license .. '`'
    end
	local embed = {
		{
			["color"] = Webhookscfg.EmbedColour,
			["title"] = "**" .. name .. " (#" .. src .. ")**" ,
			["description"] = message .. '\n\nIdentifier: ' .. identifier,
			["footer"] = {
				["text"] = Webhookscfg.FooterText,
			},
		}
	}
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed, }), { ['Content-Type'] = 'application/json' })
end

function ExtractIdentifiers(src)
	local identifiers = {
		steam = "",
		discord = "",
		license = "",
	}
	for i = 0, GetNumPlayerIdentifiers(src) - 1 do
		local id = GetPlayerIdentifier(src, i)
		if string.find(id, "steam") then
			identifiers.steam = id
		elseif string.find(id, "discord") then
			identifiers.discord = id
		elseif string.find(id, "license") then
		end
	end
	return identifiers
end