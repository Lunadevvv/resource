RegisterServerEvent('mt-delivery:Payout')
AddEventHandler('mt-delivery:Payout', function(salary)	
	local xPlayer = ESX.GetPlayerFromId(source)
	local Payout = salary
	
	xPlayer.addMoney(Payout)
	TriggerClientEvent('esx_xp:Add', source, 100)
end)