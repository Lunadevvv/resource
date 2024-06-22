
-- local NumberCharset = {}
-- local Charset = {}

-- for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

-- for i = 65,  90 do table.insert(Charset, string.char(i)) end
-- for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- function GeneratePlate()
-- 	local generatedPlate
-- 	local doBreak = false 
-- 	while true do 
-- 		Citizen.Wait(2)
-- 		math.randomseed(os.time())
-- 		generatedPlate = string.upper(GetRandomLetter(3) .. " " .. GetRandomNumber(3))
-- 		MySQL.Async.fetchScalar("SELECT plate FROM owned_vehicles WHERE plate = @plate", {
-- 			['@plate'] = generatedPlate
-- 		}, function(result)
-- 			if result == nil then 
-- 				doBreak = true
-- 			end
-- 		end)
-- 		if doBreak then break end
-- 	end
-- 	return generatedPlate
-- end

-- function GetRandomNumber(length)
-- 	Wait(0)
-- 	if length > 0 then
-- 		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
-- 	else
-- 		return ''
-- 	end
-- end

-- function GetRandomLetter(length)
-- 	Wait(0)
-- 	if length > 0 then
-- 		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
-- 	else
-- 		return ''
-- 	end
-- end

-- ESX.RegisterUsableItem('newbiegift', function(source)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
-- 	xPlayer.removeInventoryItem('newbiegift', 1)
-- 	TriggerClientEvent('luna_newbie:client:newbieGift', src)
-- end)

-- RegisterNetEvent('luna_newbie:newbieGift', function()
-- 	local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
-- 	xPlayer.addInventoryItem('bread', 15)
-- 	xPlayer.addInventoryItem('water', 15)
-- 	xPlayer.addMoney(50000)
-- 	addVehicleStarter(xPlayer.getIdentifier(), 'm4f82')
-- 	TriggerClientEvent('notify:Alert', src, 'NEWBIE', 'Bạn nhận được 1 xe Newbie, Hãy về garage để lấy xe', 7000, 'success')
-- 	TriggerEvent('luna_log', 'https://discord.com/api/webhooks/1017660789684961311/StJ7f9zN8OOo1y7_PedQp9hRO52MS1BOT13iQ7IVACEYz2g34FUHWrthA1xSPFqL3wmz', 'Quà Tân thủ', xPlayer.name .. ' đã dùng 1 hòm tân thủ')
-- end)

-- addVehicleStarter = function(identifier, model)
--     local plate = GeneratePlate()
--     MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
--         ['@owner'] = identifier,
--         ['@plate'] = plate,
--         ['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
--     })
-- end

-- ESX.RegisterCommand('giveallitem', 'admin', function(xPlayer, args, showError)
-- 	if xPlayer.source ~= 0 then
-- 		local _source = source
-- 		local xPlayers = ESX.GetPlayers()
-- 		local item    = args.item
-- 		local count   = (args.count == nil and 1 or tonumber(args.count))
		
-- 		for i=1, #xPlayers, 1 do
-- 			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
-- 			if ESX.GetItemLabel(item) ~= nil then
-- 				xPlayer.addInventoryItem(item, count)
-- 				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, '~y~Quà nè lấy đi', 'Chúc bạn trải nghiệm vui vẻ', 'Bạn đã nhận được x' .. count .. ESX.GetItemLabel(item), 'CHAR_MP_MORS_MUTUAL', 9)
-- 			else
-- 				-- TriggerClientEvent('esx:showNotification', _source, _U('unknown_item'))
-- 				showError('unknown item')
-- 			end	
-- 		end		
-- 	end
-- end, false, {help = 'giveallitem', validate = false, arguments = {
--     {name = 'item', help = ('item'), type = 'any'},
-- 	{name = 'count', help = ('count'), type = 'any'}
-- }})