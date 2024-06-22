truyna			={}


-- RegisterServerEvent("esx-wanted:location")
-- AddEventHandler("esx-wanted:location", function(coords)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	local name = xPlayer.getName()
-- 	local xPlayers = ESX.GetPlayers()
-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent("esx-wanted:showBlip", xPlayers[i], source, coords, name)
-- 		end
-- 	end
-- end)

RegisterServerEvent("truyna:thongbaocs")
AddEventHandler("truyna:thongbaocs", function(args)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], args)
		end
	end
end)

--[[ RegisterCommand("wanted", function(src, args, raw)
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer["job"]["name"] == Config.Job then
		local wantedPlayer = args[1]
		local wantedTime = tonumber(args[2])
		local wantedReason = args[3]
		if GetPlayerName(wantedPlayer) ~= nil then
			if wantedTime ~= nil then
				--TriggerClientEvent("esx-wanted:getMugshot", wantedPlayer, wantedPlayer)
				WantedPlayer(wantedPlayer, wantedTime, wantedReason)
				TriggerClientEvent("esx:showNotification", src, GetPlayerName(wantedPlayer) .. " wanted in " .. wantedTime .. " min!")				
				if args[3] ~= nil then
					GetWantedPlayerName(wantedPlayer, function(Firstname, Lastname)
						TriggerClientEvent('chat:addMessage', -1, { args = { "WANTED",  Firstname .. " " .. Lastname .. " is wanted for reason: " .. args[3] }, color = { 249, 166, 0 } })
					end)
				end
			else
				TriggerClientEvent("esx:showNotification", src, "Time is invalid!")
			end
		else
			TriggerClientEvent("esx:showNotification", src, "This ID is not online!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "You are not a cop!")
	end
end) ]]

--[[ RegisterCommand("unwanted", function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == Config.Job then

		local wantedPlayer = args[1]

		if GetPlayerName(wantedPlayer) ~= nil then
			UnWanted(wantedPlayer)
		else
			TriggerClientEvent("esx:showNotification", src, "This ID is not online!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "You are not a cop!")
	end
end) ]]

RegisterServerEvent("esx-wanted:wantedPlayer")
AddEventHandler("esx-wanted:wantedPlayer", function(targetSrc, wantedTime, wantedReason, sao)
	local src = source
	local targetSrc = tonumber(targetSrc)
	WantedPlayer(targetSrc, wantedTime, wantedReason, sao)
	AddSaoTruyNa(targetSrc, sao)
end)

RegisterServerEvent("AddSaoTruyNa")
AddEventHandler("AddSaoTruyNa", function(sao, serverTarget)
	local saotruyna = tonumber(sao)
	print(saotruyna)
	if serverTarget ~= nil then
		local src = serverTarget
		AddSaoTruyNa(src, saotruyna)
	else
		local src = source
		AddSaoTruyNa(src, saotruyna)
	end
end)

function AddSaoTruyNa(targetSrc, sao)
	local saotruyna = tonumber(sao)
	local xPlayer = ESX.GetPlayerFromId(targetSrc)
	local targetIdentifier = xPlayer.identifier
	MySQL.Async.execute(
			"UPDATE users SET saotruyna = @newsaotruyna WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newsaotruyna'] = saotruyna
			}
		)
end

RegisterServerEvent("esx-wanted:unWantedPlayer")
AddEventHandler("esx-wanted:unWantedPlayer", function(targetIdentifier)
	local src = source
	-- local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
	-- print(xPlayer.src)

	-- if xPlayer ~= nil then
	-- 	UnWanted(src)
	-- else
		MySQL.Async.execute(
			"UPDATE users SET truyna = @newWantedTime, saotruyna = @saotruyna WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newWantedTime'] = 0,
				['@saotruyna'] = 0,
			}
		)
	-- end
	TriggerClientEvent("esx:showNotification", src, GetPlayerName(src) .. " Đã được hủy truy nã!")
end)

RegisterServerEvent("esx-wanted:updateWantedTime")
AddEventHandler("esx-wanted:updateWantedTime", function(newWantedTime)
	local src = source

	EditwantedTime(src, newWantedTime)
end)

RegisterServerEvent("esx-wanted:updateWantedTime2")
AddEventHandler("esx-wanted:updateWantedTime2", function(newWantedTime)
	local src = source

	EditwantedTime(src, newWantedTime, 0)
end)

RegisterServerEvent("esx-wanted:unWanted")
AddEventHandler("esx-wanted:unWanted", function(target)
	TriggerClientEvent('esx-wanted:unWanted',-1, target)
end)

function WantedPlayer(wantedPlayer, wantedTime, wantedReason, sao)
	local targetPlayer = ESX.GetPlayerFromId(wantedPlayer)
	local name = targetPlayer.getName()
	local Reason = wantedReason
	if Reason == nil or Reason == "" then
		Reason = 'Không rõ'
	end
	TriggerClientEvent("esx-wanted:wantedPlayer", wantedPlayer, wantedTime)
	TriggerClientEvent("esx-wanted:openui", -1, name, wantedTime, wantedPlayer, Reason, sao)

	EditwantedTime(wantedPlayer, wantedTime, sao)
end

function UnWanted(wantedPlayer)
	TriggerClientEvent("esx-wanted:unWantedPlayer", wantedPlayer)
	EditwantedTime(wantedPlayer, 0, 0)
end

function EditwantedTime(source, wantedTime, sao)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier
	if sao ~= nil then
		MySQL.Async.execute(
		"UPDATE users SET truyna = @newWantedTime, saotruyna = @saotruyna WHERE identifier = @identifier",
			{
				['@identifier'] = Identifier,
				['@newWantedTime'] = tonumber(wantedTime),
				['@saotruyna'] = tonumber(sao),
			}
		)
	else
		MySQL.Async.execute(
		"UPDATE users SET truyna = @newWantedTime WHERE identifier = @identifier",
			{
				['@identifier'] = Identifier,
				['@newWantedTime'] = tonumber(wantedTime),
			}
		)
	end
end

function GetWantedPlayerName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT name FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].name)
	end)
end

ESX.RegisterServerCallback("esx-wanted:retrieveWantededPlayers", function(source, cb)	
	local wantededPersons = {}
	MySQL.Async.fetchAll("SELECT name, truyna, identifier, saotruyna FROM users WHERE truyna > @wanted", { ["@wanted"] = 0 }, function(result)
		for i = 1, #result, 1 do
			table.insert(wantededPersons, { name = result[i].name, wantedTime = result[i].truyna, identifier = result[i].identifier, saotruyna = result[i].saotruyna })
		end
		cb(wantededPersons)
	end)
end)

ESX.RegisterServerCallback("esx-wanted:retrieveWantedTime", function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier
	MySQL.Async.fetchAll("SELECT truyna, saotruyna FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		local WantedTime = tonumber(result[1].wanted)
		local SaoTruyNa = tonumber(result[1].saotruyna)
		if WantedTime ~= nil and WantedTime > 0 then
			cb(true, WantedTime)
		else
			cb(false, 0)
		end
	end)
end)