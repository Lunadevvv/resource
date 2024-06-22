RegisterServerEvent('esx_technician:PayMoney')
AddEventHandler('esx_technician:PayMoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local chance = math.random(0, 100)
    
    if Config.MoneyType == true then
        xPlayer.addMoney(Config.MoneyAmount)
        TriggerClientEvent('esx_xp:Add', source, 20)
        xPlayer.showNotification('Thành công khắc phục sự cố. Bạn đã kiếm được ' .. Config.MoneyAmount .. ' cho nó!', 'success', 3000)
    else
        xPlayer.addAccountMoney('bank', Config.MoneyAmount)
    end
end)
