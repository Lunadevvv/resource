-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bosuaxe', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
     TriggerClientEvent('consumable:suaxe', source)
end)

ESX.RegisterUsableItem('bolauxe', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
     TriggerClientEvent('consumable:lauxe', source)
end)


-- ESX.RegisterUsableItem('marijuana', function(source)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)

--     xPlayer.removeInventoryItem('marijuana', 1)
--     TriggerClientEvent('consumable:Weed', src)
-- end)

-- ESX.RegisterUsableItem('coke', function(source)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)

--     xPlayer.removeInventoryItem('coke', 1)
--     TriggerClientEvent('consumable:Weed', src)
-- end)

-- ESX.RegisterUsableItem('heroin', function(source)
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)

--     xPlayer.removeInventoryItem('heroin', 1)
--     TriggerClientEvent('consumable:Weed', src)
-- end)

-- ESX.RegisterUsableItem('giapcanhsat', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.job.name == 'police' then
--         xPlayer.removeInventoryItem('giapcanhsat', 1)
--         TriggerClientEvent('consumable:giapcanh', source)
--     end
-- end)

-- ESX.RegisterUsableItem('giap3', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if xPlayer.job.name ~= 'police' then
--         xPlayer.removeInventoryItem('giap3', 1)
--         TriggerClientEvent('consumable:giapcanh', source)
--     end
-- end)
 
RegisterNetEvent('consumable:server:suaxe', function(veh)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xBosuaxe = xPlayer.getInventoryItem('bosuaxe')
    if xBosuaxe.count >= 1 then
        TriggerClientEvent('consumable:client:suaxe', source, veh)
        xPlayer.removeInventoryItem('bosuaxe', 1)
    else
        xPlayer.showNotification('Bạn không có bộ sửa xe')
    end
end)

RegisterNetEvent('consumable:server:lauxe', function(veh)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xBolauxe = xPlayer.getInventoryItem('bolauxe')
    if xBolauxe.count >= 1 then
        TriggerClientEvent('consumable:client:lauxe', source, veh)
        xPlayer.removeInventoryItem('bolauxe', 1)
    else
        xPlayer.showNotification('Bạn không có bộ lau xe')
    end
end)

-- -- ESX.RegisterUsableItem('clip', function(source)
-- -- 	local xPlayer = ESX.GetPlayerFromId(source)
-- --     if xPlayer.job.name ~= 'police' then
-- -- 	    TriggerClientEvent('esx_extraitems:clipcli', source)
-- --     end
-- -- end)

-- -- ESX.RegisterUsableItem('dannganh', function(source)
-- -- 	local xPlayer = ESX.GetPlayerFromId(source)
-- --     if xPlayer.job.name == 'police' then
-- -- 	    TriggerClientEvent('esx_extraitems:dannganh', source)
-- --     end
-- -- end)

-- -- RegisterNetEvent('esx_ammo:giveWeaponAmmoNganh')
-- -- AddEventHandler('esx_ammo:giveWeaponAmmoNganh', function(weaponName)
-- --     local xPlayer = ESX.GetPlayerFromId(source)
-- --     local hasItem = xPlayer.getInventoryItem('dannganh').count

-- --     if xPlayer then
-- --         if hasItem >= 1 then
-- --             xPlayer.addWeaponAmmo(weaponName, 60)
-- --             xPlayer.removeInventoryItem('dannganh', 1)
-- --         end
-- --     end
-- -- end)

-- -- RegisterNetEvent('esx_ammo:giveWeaponAmmo')
-- -- AddEventHandler('esx_ammo:giveWeaponAmmo', function(weaponName)
-- --     local xPlayer = ESX.GetPlayerFromId(source)
-- --     local hasItem = xPlayer.getInventoryItem('clip').count

-- --     if xPlayer then
-- --         if hasItem >= 1 then
-- --             xPlayer.addWeaponAmmo(weaponName, 60)
-- --             xPlayer.removeInventoryItem('clip', 1)
-- --         end
-- --     end
-- -- end)

-- ESX.RegisterUsableItem('lannganh', function(source)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'police' then
-- 		TriggerClientEvent('esx_extraitems:oxygen_mask', source)
-- 		local xPlayer  = ESX.GetPlayerFromId(source)
-- 		xPlayer.removeInventoryItem('lannganh', 1)
-- 	end
-- end)

-- ESX.RegisterUsableItem('oxy_mask', function(source)
-- 	TriggerClientEvent('esx_extraitems:oxygen_mask', source)
-- 	local xPlayer  = ESX.GetPlayerFromId(source)
-- 	xPlayer.removeInventoryItem('oxy_mask', 1)
-- end)

-- -- phụ kiện

-- -- ESX.RegisterUsableItem('clip_extended', function(source)
-- -- 	local xPlayer = ESX.GetPlayerFromId(source)
-- --     TriggerClientEvent('esx_extraitems:componentWeapon', source, 'extended')
-- -- end)

-- -- ESX.RegisterUsableItem('silencer', function(source)
-- -- 	local xPlayer = ESX.GetPlayerFromId(source)
-- --     TriggerClientEvent('esx_extraitems:componentWeapon', source, 'silenced')
-- -- end)

-- -- RegisterNetEvent('esx_extraitems:silencedClip', function(weaponName)
-- --     local xPlayer = ESX.GetPlayerFromId(source)
-- --     local silencerItem = xPlayer.getInventoryItem('silencer').count
-- --     if xPlayer then
-- --         if silencerItem >= 1 then
-- --             xPlayer.addWeaponComponent(weaponName, 'suppressor')
-- --             xPlayer.removeInventoryItem('silencer', 1)
-- --         end
-- --     end 
-- -- end)

-- -- RegisterNetEvent('esx_extraitems:extendedClip', function(weaponName)
-- --     local xPlayer = ESX.GetPlayerFromId(source)
-- --     local extendedItem = xPlayer.getInventoryItem('clip_extended').count
-- --     if xPlayer then
-- --         if extendedItem >= 1 then
-- --             xPlayer.addWeaponComponent(weaponName, 'clip_extended')
-- --             xPlayer.removeInventoryItem('clip_extended', 1)
-- --         end
-- --     end    
-- -- end)

-- ESX.RegisterUsableItem('langbam', function(source)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
--     TriggerClientEvent('consumable:langbam', source)
-- end)