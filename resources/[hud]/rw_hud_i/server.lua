
function getCoin(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	coin_amount = MySQL.Sync.fetchAll("SELECT `coin` FROM `users` WHERE `identifier` = ?", {xPlayer.identifier}, function(result)
	end)
	return coin_amount[1].coin
end

function getCoinLock(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	coinlock_amount = MySQL.Sync.fetchAll("SELECT `coinlock` FROM `users` WHERE `identifier` = ?", {xPlayer.identifier}, function(result) end)
	return coinlock_amount[1].coinlock
end

RegisterServerEvent('rw_hud:getServerInfo')
AddEventHandler('rw_hud:getServerInfo', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)


	local time = '22:00'
	local date = '00/00/2022'



	time = os.date("%H:%M", os.time() + 1 * 60 * 60 )
	date = os.date("%d/%m/%Y",os.time() + 1 * 60 * 60 ) 

	Citizen.Wait(100)

	local info = {
		money = xPlayer.getMoney(),
		bank = xPlayer.getAccount('bank').money,
		blackm = xPlayer.getAccount('black_money').money, 
		clock = getCoinLock(source),
		coin = getCoin(source),
		time = time,
		date = date
	}

	TriggerClientEvent('rw_hud:setInfo', source, info) 
 	
end)


RegisterServerEvent('luna:getplayers')
AddEventHandler('luna:getplayers', function (playersonline)
-- RegisterCommand("online1", function(source, raw, args)
	local playersonline = GetNumPlayerIndices()
	TriggerClientEvent("luna:getplayers", source, playersonline)
end)
