local dutyPlayers = {}
local trees = {}

lib.callback.register('map_lumberjack:duty', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    if not Config.FreelanceJob and job.name ~= Config.JobName then
        return false
    end

    if dutyPlayers[source] then
        dutyPlayers[source] = nil
        return false
    else
        dutyPlayers[source] = true
        return true
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Trees) do
        table.insert(trees, { 
            coords = v, health = 100 
        })
    end
end)

lib.callback.register('map_lumberjack:getTreesWithData', function(_)
   return trees
end)

lib.callback.register('map_lumberjack:hasItem', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getInventoryItem('axe').count
end)

RegisterNetEvent('map_lumberjack:reduceAxeDurability', function()
    local ox_inventory = exports.ox_inventory
    local xPlayer = ESX.GetPlayerFromId(source)

    local items = ox_inventory:Search(source, 'slots', 'axe')
    if #items > 0 then
        local item = items[1]
        if item then
            ox_inventory:SetDurability(source, item.slot, (item.metadata?.durability or 100) - 1)
            if tonumber(item.metadata?.durability) <= 1 then 
                ox_inventory:RemoveItem(source, 'axe', 1, false, item.slot)
                xPlayer.showNotification('Rìu của bạn đã bị hư!', 'error', 3000)
            end
        end
    end
end)

lib.callback.register('map_lumberjack:makeDamage', function(source, index)
    local data = trees[index]
    local xPlayer = ESX.GetPlayerFromId(source)
    local lvl = exports['src-skills']:GetCurrentSkill_sv('Lumberjack')
    if not data or not dutyPlayers[source] then
        return false
    end

    trees[index].health = trees[index].health - 20 - (lvl * 2)
    syncTrees()

    if data.health == 0 then
        local chance = math.random(0, 99)
        TriggerClientEvent('esx_xp:Add', source, 50)
        if chance <= 40 then
            xPlayer.addInventoryItem('gosu', 1)
        elseif chance <= 70 then
            xPlayer.addInventoryItem('gosua', 1)
        elseif chance <= 90 then
            xPlayer.addInventoryItem('gogu', 1)
        else
            xPlayer.addInventoryItem('gocamlai', 1)
        end
        TriggerClientEvent('skill:updateSkill', source, 'Lumberjack', 1)
        Citizen.SetTimeout(Config.GrowingTime, function()
            trees[index].health = 100
            syncTrees()
        end)
    end

    return true
end)

function syncTrees()
    TriggerClientEvent('map_lumberjack:syncTrees', -1, trees)
end

-- lib.callback.register('map_lumberjack:sellAllWood', function()
--     local source = source

--     if not dutyPlayers[source] then
--         return false
--     end

--     local xPlayer = ESX.GetPlayerFromId(source)
--     local dist = #(xPlayer.getCoords(true) - Config.SellPoint)

--     if dist > 2 then
--         xPlayer.showNotification('You are too far away from the sell point.')
--         return
--     end

--     local woodCount = xPlayer.getInventoryItem('wood').count
--     if woodCount <= 0 then
--         xPlayer.showNotification('You do not have any wood to sell.')
--         return
--     end

--     local totalPrice = woodCount * Config.WoodPrice
--     xPlayer.addAccountMoney('money', totalPrice)
--     xPlayer.removeInventoryItem('wood', woodCount)

--     xPlayer.showNotification('You sold ' .. woodCount .. ' wood and received $' .. totalPrice)
-- end)
