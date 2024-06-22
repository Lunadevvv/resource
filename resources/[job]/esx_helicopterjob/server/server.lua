msg = _U('deliveredBannerText')

RegisterNetEvent('helicopterJob:jobFinished')
AddEventHandler('helicopterJob:jobFinished', function(salary)
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local payment = salary
xPlayer.addMoney(payment)
TriggerClientEvent('esx_xp:Add', source, 50)
TriggerClientEvent('helicopterJob:banner', xPlayer.source, msg)
end)

RegisterNetEvent('helicopterJob:jobFailed')
AddEventHandler('helicopterJob:jobFailed', function()
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local playerCash = xPlayer.getMoney()
local playerBank = xPlayer.getAccount('bank')
if playerCash < Config.fineAmount then
    if playerBank.money < Config.fineAmount then
        xPlayer.removeAccountMoney('bank', playerBank.money)
        -- TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('jobNotifyTitle'), _U('vehicleDestroyedPayBankRest', playerBank.money), 10000, 'error')
        xPlayer.showNotification( _U('vehicleDestroyedPayBankRest', playerBank.money), 'error', 3000)
    else
        xPlayer.removeAccountMoney('bank', Config.fineAmount)
        -- TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('jobNotifyTitle'), _U('vehicleDestroyedPayBank', Config.fineAmount), 10000, 'error')
        xPlayer.showNotification( _U('vehicleDestroyedPayBank', Config.fineAmount), 'error', 3000)
    end
else
    xPlayer.removeMoney(Config.fineAmount)
    -- TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('jobNotifyTitle'), _U('vehicleDestroyedPayCash', Config.fineAmount), 10000, 'error')
        xPlayer.showNotification( _U('vehicleDestroyedPayCash', Config.fineAmount), 'error', 3000)
end
end)