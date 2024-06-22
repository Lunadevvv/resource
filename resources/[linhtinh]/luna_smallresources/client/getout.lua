
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local listxenganh ={
    'police',
    'police2',
    'police3',
    'policeb',
    'riot',
    'fbi',
    'ambulance',
    'dodgeEMS',
    'r1custom',
    'ikx3mini21',
    'policedemon',
    'valor14chgr',
    'wmfenyrcop'
}

function checkxenganh(modelhash)
    for k,v in ipairs(listxenganh) do  
		if GetHashKey(v) == modelhash then
			return true
		end
	end
	return false
end

function kickXeNganh()
    local playerPed  = PlayerPedId()
    local veh = GetVehiclePedIsIn(playerPed, false)
    local reval = checkxenganh(GetEntityModel(veh))
    if not reval then
        return
    end 
    if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
        if reval then
            TaskLeaveVehicle(playerPed, veh, 16)
            ESX.ShowNotification('Bạn không thể lái xe ngành')
        end
    end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(2000)
        if ESX.PlayerData.job.name ~= 'ambulance' and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'mechanic' and ESX.PlayerData.job.name ~= 'doxe' then 	
            kickXeNganh()
        end
	end
end)

CreateThread(function()
    while true do
        Wait(5000)
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        if ESX.PlayerData.job.name ~= 'police' then 
            if weapon == GetHashKey('WEAPON_CARBINERIFLE') or weapon == GetHashKey('WEAPON_ADVANCEDRIFLE') then
                SetCurrentPedWeapon(ped, GetHashKey('weapon_unarmed'), true)
            end
        end
    end
end)