-- local playersProcessingCannabis = {}

RegisterServerEvent('esx_illegal:pickedUpCannabis')
AddEventHandler('esx_illegal:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cannabis')

	if xItem.count >= 40 then
		TriggerClientEvent('esx:showNotification', source, _U('weed_inventoryfull'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.addInventoryItem('cannabis', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
		end
	end
end)

RegisterServerEvent('esx_illegal:processCannabis')
AddEventHandler('esx_illegal:processCannabis', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

	if xMarijuana.count >= 40 then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'), 'error', 3000)
	elseif xCannabis.count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.removeInventoryItem('cannabis', 1)
			xPlayer.addInventoryItem('marijuana', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
			TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'), 'success', 3000)
		end
	end
end)