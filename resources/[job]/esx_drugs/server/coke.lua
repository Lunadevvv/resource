
RegisterServerEvent('esx_illegal:pickedUpCocaLeaf')
AddEventHandler('esx_illegal:pickedUpCocaLeaf', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('coca_leaf')

	if xItem.count >= 40 then
		TriggerClientEvent('esx:showNotification', source, _U('coca_leaf_inventoryfull'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.addInventoryItem(xItem.name, 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
		end
	end
end)

RegisterServerEvent('esx_illegal:processCocaLeaf')
AddEventHandler('esx_illegal:processCocaLeaf', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xCocaLeaf, xCoke = xPlayer.getInventoryItem('coca_leaf'), xPlayer.getInventoryItem('coke')

	if xCoke.count >= 40 then
		TriggerClientEvent('esx:showNotification', _source, _U('coke_processingfull'), 'error', 3000)
	elseif xCocaLeaf.count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough'), 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.removeInventoryItem('coca_leaf', 1)
			xPlayer.addInventoryItem('coke', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
			TriggerClientEvent('esx:showNotification', _source, _U('coke_processed'), 'success', 3000)
		end
	end
end)

