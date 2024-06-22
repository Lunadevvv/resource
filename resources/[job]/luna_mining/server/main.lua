local mineStone = {}
local random = math.random(1, 3)
Citizen.CreateThread(function()
    for k,v in pairs(Config.Location['mining']) do
        table.insert(mineStone, { 
            coords = v.coord, 
            quantity = Config.QuantityMax
        })
    end

    while true do 
        Wait(Config.RestoreTime * 1000 * 60)
        for k, v in pairs (mineStone) do
            if v.quantity + random <= 150 then
                v.quantity = v.quantity + random
                TriggerClientEvent('luna_mining:client:updateQuantity', -1, mineStone)
            end
        end
    end
end)

lib.callback.register('luna_mining:getMineWithData', function(_)
    return mineStone
end) 

lib.callback.register('luna_mining:callback:hasItem', function(src, itemName)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getInventoryItem(itemName).count
end)

RegisterNetEvent('luna_mining:reducePickaxeDurability', function()
    local ox_inventory = exports.ox_inventory
    local xPlayer = ESX.GetPlayerFromId(source)

    local items = ox_inventory:Search(source, 'slots', 'pickaxe')
    if #items > 0 then
        local item = items[1]
        if item then
            ox_inventory:SetDurability(source, item.slot, (item.metadata?.durability or 100) - 1)
            if tonumber(item.metadata?.durability) <= 1 then 
                ox_inventory:RemoveItem(source, 'pickaxe', 1, false, item.slot)
                xPlayer.showNotification('Your pickaxe broke due to over use!')
            end
        end
    end
end)


RegisterServerEvent("luna_mining:server:processMine", function(curAction, step)
    local xPlayer = ESX.GetPlayerFromId(source)
    local rdm = math.random(1, 3)
    local chance = math.random(0, 99)
    local level = exports['src-skills']:GetCurrentSkill_sv('Mining')
    if step == 1 then
        if xPlayer.canCarryItem('stone', rdm) and mineStone[curAction].quantity >= rdm then
            xPlayer.addInventoryItem('stone', rdm)
            TriggerClientEvent('esx_xp:Add', source, 10)
            mineStone[curAction].quantity = mineStone[curAction].quantity - rdm
            TriggerClientEvent('luna_mining:client:updateQuantity', -1, mineStone)
        else
            TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
        end
    elseif step == 2 then
        xPlayer.removeInventoryItem('stone', 5)
        if xPlayer.canCarryItem('washed_stone', 5) then
            xPlayer.addInventoryItem('washed_stone', 5)
            TriggerClientEvent('esx_xp:Add', source, 10)
        else
            TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
        end
    elseif step == 3 then
        xPlayer.removeInventoryItem('washed_stone', 1)
        TriggerClientEvent('esx_xp:Add', source, 10)
        if chance <= 40 then
            if xPlayer.canCarryItem('copper', 1) then
                xPlayer.addInventoryItem('copper', 1)
            else
                TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
            end
        elseif chance <= 70 then
            if xPlayer.canCarryItem('iron', 1) then
                xPlayer.addInventoryItem('iron', 1)
            else
                TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
            end
        elseif chance <= 85 then
            if xPlayer.canCarryItem('gold', 1) then
                xPlayer.addInventoryItem('gold', 1)
            else
                TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
            end
        elseif chance <= 90 + level then
            if xPlayer.canCarryItem('diamond', 1) then
                xPlayer.addInventoryItem('diamond', 1)
            else
                TriggerClientEvent('notify:Alert', source, 'Túi đồ', 'Kho đồ bạn đã đầy', 5000, 'error')
            end
        else
            TriggerClientEvent('notify:Alert', source, 'Hệ thống', 'Không thu hoạch được gì', 5000, 'error')
        end
    end
end)


