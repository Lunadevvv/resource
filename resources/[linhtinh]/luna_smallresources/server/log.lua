RegisterServerEvent('luna_log')
AddEventHandler('luna_log', function(DiscordWebHook,name,message)

	local embeds = {
		{
			["title"]=message,
			["type"]="Luna Log",
			["color"] =11750815,
			["footer"]=  {
				["text"]= "Luna Log",
			},
		}
	}
	if message == nil or message == '' then 
		return false
	end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('luna:getplayers')
AddEventHandler('luna:getplayers', function (playersonline)
	local playersonline = GetNumPlayerIndices()
	TriggerClientEvent("luna:getplayers", source, playersonline)
end)