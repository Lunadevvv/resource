local playersHealing = {}

local cooldown = 0
AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
			--print(cooldown)
		end
	end
end)

RegisterCommand("hs", function(source, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    
    if cooldown <= 0 then 
        if xPlayer and ESX.NumAmbulance_SV() < 1 then
            MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(isDead)
                if isDead then
                    xPlayer.removeMoney(Config.ReviveReward1)
                    xPlayer.triggerEvent('esx_ambulancejob:revive')
                    xPlayer.showNotification("Bạn đã mất 15000$ để hồi sinh")
                else
                    xPlayer.showNotification('Bạn chưa chết')
                end
            end)
            cooldown = 3 * 60000
        else
            xPlayer.showNotification("Bác sĩ vẫn ONLINE")
        end
    else
        xPlayer.showNotification("DELAY 3 phút để dùng lệnh /hs còn "..math.ceil(cooldown*0.001).." giây")
    end
end)