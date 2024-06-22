-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- for k, v in pairs(Config.Backpacks) do
--     ESX.RegisterUsableItem(k, function(source)
--         xPlayer = ESX.GetPlayerFromId(source)
--         addWeight(xPlayer.identifier, v.weight, v.type)
--         xPlayer.removeInventoryItem(k, 1)
--     end)
-- end

-- function addWeight(identifier, weight, typebalo)
--     MySQL.Async.execute('UPDATE users SET balo = ? WHERE identifier = ?', { typebalo, identifier}, function(rowChanged)
--         if rowChanged then
--             local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
--             xPlayer.setMaxWeight(weight)
            -- xPlayer.showNotification('Bạn đã dùng balo' .. typebalo)
--         end
--     end)
-- end

RegisterNetEvent('luna_balo:addWeightLevel', function(rank)
    local defaultWeight = ESX.GetConfig().MaxWeight
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.setMaxWeight(defaultWeight + rank * 5)
end)

function SetWeightByLevel(playerId)
    local defaultWeight = ESX.GetConfig().MaxWeight
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playerRank = xPlayer.get("rank")
    local newWeight = defaultWeight + playerRank * 2
    if newWeight > 125 then
        newWeight = 125
    end
    xPlayer.setMaxWeight(newWeight)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId)
    Wait(1000)
    SetWeightByLevel(playerId)
end)

RegisterCommand('loadweight', function(source)
    SetWeightByLevel(source)
end, false)