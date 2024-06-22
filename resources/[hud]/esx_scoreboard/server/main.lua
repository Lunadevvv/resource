
local connectedPlayers = {}
		
AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name
	-- connectedPlayers[playerId].job2 = job2.name
	connectedPlayers[playerId].jobLabel = job.label

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	Wait(5000)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

RegisterNetEvent("esx_scoreboard:server:requestPlayer", function()
	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', source, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		AddPlayersToScoreboard()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			AddPlayersToScoreboard()
		end)
	end
end)

function _CheckLogged(identifier)
    for k,v in ipairs(connectedPlayers) do
		
        if identifier == v.identifier then
            return true,v
        end
    end
    return false,{}
end

local phone_number
function NumberPhone(source)
 	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source) 
	phone_number = MySQL.Sync.fetchAll('SELECT `phone_number` FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
	end)
	return phone_number[1].phone_number
end

function WantedLevel(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	wanted_level = MySQL.Sync.fetchAll('SELECT `saotruyna` FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
	end)
	return wanted_level[1].saotruyna
end

function AddPlayerToScoreboard(xPlayer, update)
	local check,connected = _CheckLogged()

	local playerId = xPlayer.source
	connectedPlayers[playerId] = {}
	--connectedPlayers[playerId].cid = xPlayer.cid
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].name = xPlayer.getName()
	connectedPlayers[playerId].job = xPlayer.job.name
	connectedPlayers[playerId].jobLabel = xPlayer.job.label
	connectedPlayers[playerId].phoneNumber = NumberPhone(playerId)
	connectedPlayers[playerId].saotruyna = WantedLevel(playerId)
	if update then
		TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end

	if xPlayer.getGroup() == 'user' then
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			TriggerClientEvent('esx_scoreboard:toggleID', playerId, false)
		end)
	end
end



function AddPlayersToScoreboard()

	local players = ESX.GetPlayers()
	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end


ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

ESX.RegisterCommand('loadsc', 'superadmin', function(source, args, user)
	AddPlayersToScoreboard()
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Refresh esx_scoreboard names!"})

TriggerEvent('es:addGroupCommand', 'sctoggle', 'admin', function(source, args, user)
	TriggerClientEvent('esx_scoreboard:toggleID', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Toggle ID column on the scoreboard!"})

-- TriggerEvent('es:addGroupCommand', 'reviveall', 'superadmin', function(source, args, user)
--     for k,_ in pairs(connectedPlayers) do
--         local identifier = GetPlayerIdentifiers(k)[1]
--         MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
--             ['@identifier'] = identifier
--         }, function(isDead)
--             if isDead then
--                 TriggerClientEvent('esx_ambulancejob:rolly', k)
-- 				TriggerClientEvent('esx:showNotification',k,'Bạn đã được ~g~ hồi sinh')
--             end
--         end)
--     end
-- end)

TriggerEvent('es:addGroupCommand', 'healall', 'superadmin', function(source, args, user)
    for k,_ in pairs(connectedPlayers) do
		TriggerClientEvent('esx_basicneeds:healPlayer', k)
		TriggerClientEvent('esx:showNotification',k,'Bạn đã được ~g~ hồi máu')
    end
end)

TriggerEvent('es:addGroupCommand', 'bringall', 'superadmin', function(source, args, user)
    for k,_ in pairs(connectedPlayers) do
		TriggerClientEvent('es_admin:teleportUser', k, 219.62, -811.47, 30.64)
		-- TriggerClientEvent('esx_basicneeds:healPlayer', k)
		-- TriggerClientEvent('esx:showNotification',k,'Bạn đã được ~y~Thiên Sứ Rolly~g~ hồi máu')
    end
end)