ESX.RegisterServerCallback('carlock:isVehicleOwner', function(source, cb, plates)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = ?', {plates}, function(result)
        if result[1] ~= nil then
            if result[1].owner == xPlayer.identifier then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
	end)
end)

Citizen.CreateThread(function()
    local uptimeMinute, uptimeHour, uptime = 0, 0, ''
    SetConvarServerInfo('DevTeam', "Luna dev")
    SetConvarServerInfo('Discord', "discord.gg/ocrpg")
    while true do
        SetConvarServerInfo('Công Việc', "👮:"..ESX.NumPolice_SV().. "🚑:"..ESX.NumAmbulance_SV().."🔧:"..ESX.NumMechanic_SV())
        Citizen.Wait(1000 * 60) -- every minute
    end
end)