local playersProcessingPoppyResin = {}

RegisterServerEvent('esx_illegal:pickedUpPoppy')
AddEventHandler('esx_illegal:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('poppyresin')

	if xItem.count > 40 then
		TriggerClientEvent('esx:showNotification', source, _U('poppy_inventoryfull'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.addInventoryItem(xItem.name, 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
		end
	end
end)

RegisterServerEvent('esx_illegal:processPoppyResin')
AddEventHandler('esx_illegal:processPoppyResin', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPoppyResin, xHeroin = xPlayer.getInventoryItem('poppyresin'), xPlayer.getInventoryItem('heroin')

	if xHeroin.count >= 40 then
		TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingfull'), 'error', 3000)
	elseif xPoppyResin.count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _U('heroin_processingenough'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.removeInventoryItem('poppyresin', 1)
			xPlayer.addInventoryItem('heroin', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
			TriggerClientEvent('esx:showNotification', _source, _U('heroin_processed'), 'success', 3000)
		end
	end
end)

