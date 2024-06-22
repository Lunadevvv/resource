RegisterNetEvent('luna_Notify')
AddEventHandler('luna_Notify', function(title, args)
	TriggerServerEvent('trew_hud_ui:NotifyAllPlayers',title, args)
end)

RegisterNetEvent('luna_NotifyShow')
AddEventHandler('luna_NotifyShow', function(title, args)
	local title = title
	local message = args
	local type = 'red'
	SendNUIMessage({action = 'sendNotification', title = title, message = message, type = type })
end)
