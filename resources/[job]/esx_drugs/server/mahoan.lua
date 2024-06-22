-- local playersProcessingCannabis = {}

RegisterServerEvent('esx_illegal:pickedUpMahoan')
AddEventHandler('esx_illegal:pickedUpMahoan', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('mahoan')

	if xItem.count >= 40 then
		TriggerClientEvent('esx:showNotification', source, 'Không thể chứa thêm được nữa', 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.addInventoryItem('mahoan', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
		end
	end
end)

RegisterServerEvent('esx_illegal:processMahoan')
AddEventHandler('esx_illegal:processMahoan', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xMahoan, xGoiMahoan = xPlayer.getInventoryItem('mahoan'), xPlayer.getInventoryItem('goimahoan')

	if xGoiMahoan.count >= 40 then
		TriggerClientEvent('esx:showNotification', _source, 'Không thể chứa thêm được nữa', 'error', 3000)
	elseif xMahoan.count < 1 then
		TriggerClientEvent('esx:showNotification', _source, 'Không đủ Ma hoàng', 'error', 3000)
	else
		if xPlayer.job.name ~= 'police' then
			xPlayer.removeInventoryItem('mahoan', 1)
			xPlayer.addInventoryItem('goimahoan', 1)
			TriggerClientEvent('esx_xp:Add', source, 10)
			TriggerClientEvent('esx:showNotification', _source, 'Đóng gói thành công', 'success', 3000)
		end
	end
end)