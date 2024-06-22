------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--

local function checkWhitelist(id)
	for key, value in pairs(RepairWhitelist) do
		if id == value then
			return true
		end
	end	
	return false
end

--[[AddEventHandler('chatMessage', function(source, _, message)
	local msg = string.lower(message)
	local identifier = GetPlayerIdentifiers(source)[1]
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if msg == "/suaxe" then
		CancelEvent()
		--if RepairEveryoneWhitelisted == true then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'police' then
			TriggerClientEvent('iens:repair1', source)
		else
			if checkWhitelist(identifier) then
				TriggerClientEvent('iens:repair1', source)
			else
				TriggerClientEvent('iens:notAllowed', source)
			end
		end
	end
end)]]

--[[RegisterServerEvent('rvFailure:takemoney')
AddEventHandler('rvFailure:takemoney', function(repairCost)
	local xPlayer = ESX.GetPlayerFromId(source)			
	xPlayer.removeMoney(repairCost)
end)]]