logkill = "https://discord.com/api/webhooks/996710828105535598/eVK91BR4qVDxNNAHRRMk-iV_kOCrds-11AcVjS66Gfpi8E_dYjCoNZdNlwHJp4eWsUkx"
RegisterServerEvent('kill:die')
AddEventHandler('kill:die',function(reason, killServerid, weapon, dameweapon)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if reason == 0 then
		xPlayer.showNotification('Bạn đã tự chết')
	elseif reason == 1 and ESX.GetPlayerFromId(tonumber(killServerid)) ~= nil then
		xTarget = ESX.GetPlayerFromId(killServerid)
		TriggerClientEvent('notify:Alert', _source, 'Kill log', 'Bạn đã bị '..GetPlayerName(killServerid)..' giết với súng '..weapon, 7000, 'info')
		TriggerClientEvent('notify:Alert', killServerid, 'Kill log', 'Bạn đã giết ' .. GetPlayerName(_source), 7000, 'info')
        TriggerEvent('luna_log', logkill, 'Log Kill', GetPlayerName(_source)..' đã bị '..GetPlayerName(killServerid)..' bắn chết bởi súng '..weapon..' với dame '..dameweapon)
	elseif reason == 2 and ESX.GetPlayerFromId(tonumber(killServerid)) ~= nil then
		xTarget = ESX.GetPlayerFromId(killServerid)
		TriggerClientEvent('notify:Alert', _source, 'Kill log', 'Bạn đã bị '..GetPlayerName(killServerid)..' tông xe chết', 7000, 'info')
		TriggerClientEvent('notify:Alert', killServerid, 'Kill log', 'Bạn đã giết ' .. GetPlayerName(_source), 7000, 'info')
        TriggerEvent('luna_log', logkill, 'Log Kill', GetPlayerName(_source)..' đã bị '..GetPlayerName(killServerid)..' tông xe chết ')
	end
end)
local dmgcheck = 'https://discord.com/api/webhooks/996711816828829716/83eGSUnTdHfow6t-nVAxJxZGl4s3ocZW7NoL7O5AebzU7vtJ_QUSxF4M3NCa6lrP9FII'
RegisterServerEvent('WeaponDame')
AddEventHandler('WeaponDame', function(dmg, acc)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local reason = ' | Dame: ' .. dmg .. ' | Accuracy ' .. acc
    if xPlayer then
		TriggerEvent('luna_log', dmgcheck, 'Dame check', GetPlayerName(_source) .. reason)
    end
end)
