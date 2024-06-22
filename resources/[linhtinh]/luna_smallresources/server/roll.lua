ESX.RegisterUsableItem('roll', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('roll', 1)

	TriggerClientEvent('roll:Display', _source)
end)