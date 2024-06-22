RegisterServerEvent('trew_hud_ui:NotifyAllPlayers')
AddEventHandler('trew_hud_ui:NotifyAllPlayers', function(title, args)

	local xPlayers = ESX.GetPlayers()


	for i=1, #xPlayers, 1 do
		TriggerClientEvent('luna_NotifyShow', xPlayers[i],title, args)
	end
	
end)