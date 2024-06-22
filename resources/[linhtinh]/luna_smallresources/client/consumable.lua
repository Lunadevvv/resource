-- ESX = nil

-- Citizen.CreateThread(function()
--     while ESX == nil do
--         Wait(0)
--         TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
--     end
-- end)

-- RegisterNetEvent('consumable:Weed', function()
    
--     TriggerEvent('animations:client:EmoteCommandStart', {"cigarette"})
--     exports.rprogress:Custom({
--         Duration = 10000,
--         Label = 'Hút cần',
--         LabelPosition = "bottom",
--         ShowTimer = true,
--         useWhileDead = 0,
--         canCancel = 0,
--         DisableControls = {
--             Mouse = false,
--             Player = true,
--             Vehicle = true
--         },
--         Animation = {
--             -- animationDictionary = "Scenario",
--             -- animationName = "WORLD_HUMAN_SMOKING"
--         },
--     onComplete = function()
--         TriggerEvent('animations:client:EmoteCommandStart', {"c"})
--         CokeBaggyEffect()
--     end})
-- end)

-- function CokeBaggyEffect()
--     local ped = PlayerPedId()
--     AlienEffect()
--     SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
--     AlienEffect()
--     Wait(1000)
--     SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
-- end

-- function AlienEffect()
--     StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
--     Wait(math.random(5000, 8000))
--     StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
--     Wait(math.random(5000, 8000))    
--     StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
--     StopScreenEffect("DrugsMichaelAliensFightIn")
--     StopScreenEffect("DrugsMichaelAliensFight")
--     StopScreenEffect("DrugsMichaelAliensFightOut")
-- end

-- RegisterNetEvent('consumable:giapcanh', function()
--     exports.rprogress:Custom({
--         Duration = 5000,
--         Label = 'Đang mặc giáp',
--         LabelPosition = "bottom",
--         ShowTimer = true,
--         useWhileDead = 0,
--         canCancel = 0,
--         DisableControls = {
--             Mouse = false,
--             Player = true,
--             Vehicle = true
--         },
--         Animation = {
--             animationDictionary = "rcmfanatic3",
--             animationName = "kneel_idle_a"
--         },
--     onComplete = function()
--         local playerPed = GetPlayerPed(-1)
--         SetPedComponentVariation(playerPed, 9, 27, 9, 2)
--         AddArmourToPed(playerPed, 100)
--         SetPedArmour(playerPed, 100)
--     end})
-- end)

RegisterNetEvent('consumable:suaxe', function()
    local ped = PlayerPedId()
    local pedCoord = GetEntityCoords(ped)

    if IsPedInAnyVehicle(ped, false) then
        vehicle = GetVehiclePedIsIn(ped, false)
    else
        vehicle = GetClosestVehicle(pedCoord.x, pedCoord.y, pedCoord.z, 3.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
        TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
        -- exports.rprogress:Custom({
        --     Duration = 8000,
        --     Label = 'Sửa xe',
        --     LabelPosition = "bottom",
        --     ShowTimer = true,
        --     useWhileDead = 0,
        --     canCancel = 0,
        --     DisableControls = {
        --         Mouse = false,
        --         Player = true,
        --         Vehicle = true
        --     },
        --     Animation = {
        --         -- animationDictionary = "mini@cpr@char_a@cpr_str",
        --         -- animationName = "cpr_pumpchest"
        --     },
        -- onComplete = function()
        --     ClearPedTasksImmediately(ped)
        --     TriggerServerEvent('consumable:server:suaxe', vehicle)
        -- end})
        TriggerEvent("mythic_progbar:client:progress", {
            name = "ffixcar",
            duration = 8000,
            label = 'Sửa xe',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },	
            animation = {
                -- animDict = "amb@world_human_hammering@male@base",
                -- anim = "base",
            },		
            -- prop = {
                -- model = "prop_tool_pickaxe",
            -- }	
            },function(status)
            if not status then
                ClearPedTasksImmediately(ped)
                TriggerServerEvent('consumable:server:suaxe', vehicle)
            else
                ClearPedTasksImmediately(ped)
            end
        end)
    end
end)

RegisterNetEvent('consumable:lauxe', function()
    local ped = PlayerPedId()
    local pedCoord = GetEntityCoords(ped)

    if IsPedInAnyVehicle(ped, false) then
        vehicle = GetVehiclePedIsIn(ped, false)
    else
        vehicle = GetClosestVehicle(pedCoord.x, pedCoord.y, pedCoord.z, 3.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
        -- exports.rprogress:Custom({
        --     Duration = 5000,
        --     Label = 'Lau xe',
        --     LabelPosition = "bottom",
        --     ShowTimer = true,
        --     useWhileDead = 0,
        --     canCancel = 0,
        --     DisableControls = {
        --         Mouse = false,
        --         Player = true,
        --         Vehicle = true
        --     },
        --     Animation = {
        --         -- animationDictionary = "mini@cpr@char_a@cpr_str",
        --         -- animationName = "cpr_pumpchest"
        --     },
        -- onComplete = function()
        --     ClearPedTasksImmediately(ped)
        --     TriggerServerEvent('consumable:server:lauxe', vehicle)
        -- end})

        TriggerEvent("mythic_progbar:client:progress", {
            name = "fcleancar",
            duration = 5000,
            label = 'Lau xe',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },	
            animation = {
                -- animDict = "amb@world_human_hammering@male@base",
                -- anim = "base",
            },		
            -- prop = {
                -- model = "prop_tool_pickaxe",
            -- }	
            },function(status)
            if not status then
                ClearPedTasksImmediately(ped)
                TriggerServerEvent('consumable:server:lauxe', vehicle)
            else
                ClearPedTasksImmediately(ped)
            end
        end)
    end
end)

-- RegisterNetEvent('consumable:client:lauxe', function(vehicle)
--     SetVehicleDirtLevel(vehicle, 0)
--     ESX.ShowNotification('Xe của bạn đã được lau sạch')
-- end)

-- RegisterNetEvent('consumable:client:suaxe', function(vehicle)
--     SetVehicleFixed(vehicle)
--     SetVehicleDeformationFixed(vehicle)
--     SetVehicleUndriveable(vehicle, false)
--     ESX.ShowNotification('Xe của bạn đã được sửa')
-- end)

-- -- RegisterNetEvent('esx_extraitems:clipcli')
-- -- AddEventHandler('esx_extraitems:clipcli', function()
-- -- 	local playerPed = PlayerPedId()
-- --     local hash = GetSelectedPedWeapon(playerPed)
    
-- --     if IsPedArmed(playerPed, 4) then
-- --         if hash ~= nil then
-- --             local weapon = ESX.GetWeaponFromHash(hash)
-- --             -- exports.rprogress:Custom({
-- --             --     Duration = 1500,
-- --             --     Label = 'Nạp đạn',
-- --             --     LabelPosition = "bottom",
-- --             --     ShowTimer = true,
-- --             --     useWhileDead = 0,
-- --             --     canCancel = 0,
-- --             --     DisableControls = {
-- --             --         Mouse = false,
-- --             --         Player = true,
-- --             --         Vehicle = true
-- --             --     },
-- --             --     Animation = {
-- --             --         animationDictionary = "rcmfanatic3",
-- --             --         animationName = "kneel_idle_a"
-- --             --     },
-- --             -- onComplete = function()
-- --                 TriggerServerEvent('esx_ammo:giveWeaponAmmo', weapon.name)
-- --             -- end})
-- --         end
-- --     end
-- -- end)

-- -- RegisterNetEvent('esx_extraitems:dannganh')
-- -- AddEventHandler('esx_extraitems:dannganh', function()
-- -- 	local playerPed = PlayerPedId()
-- --     local hash = GetSelectedPedWeapon(playerPed)
    
-- --     if IsPedArmed(playerPed, 4) then
-- --         if hash ~= nil then
-- --             local weapon = ESX.GetWeaponFromHash(hash)
-- --             -- exports.rprogress:Custom({
-- --             --     Duration = 1500,
-- --             --     Label = 'Nạp đạn',
-- --             --     LabelPosition = "bottom",
-- --             --     ShowTimer = true,
-- --             --     useWhileDead = 0,
-- --             --     canCancel = 0,
-- --             --     DisableControls = {
-- --             --         Mouse = false,
-- --             --         Player = true,
-- --             --         Vehicle = true
-- --             --     },
-- --             --     Animation = {
-- --             --         animationDictionary = "rcmfanatic3",
-- --             --         animationName = "kneel_idle_a"
-- --             --     },
-- --             -- onComplete = function()
-- --                 TriggerServerEvent('esx_ammo:giveWeaponAmmoNganh', weapon.name)
-- --             -- end})
-- --         end
-- --     end
-- -- end)

-- RegisterNetEvent('esx_extraitems:oxygen_mask')
-- AddEventHandler('esx_extraitems:oxygen_mask', function()
-- 	local playerPed  = GetPlayerPed(-1)
-- 	local coords     = GetEntityCoords(playerPed)
-- 	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
-- 	--local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	
-- 	ESX.Game.SpawnObject('p_s_scuba_mask_s', {
-- 		x = coords.x,
-- 		y = coords.y,
-- 		z = coords.z - 3
-- 	}, function(object)
-- 		ESX.Game.SpawnObject('p_s_scuba_tank_s', {
-- 			x = coords.x,
-- 			y = coords.y,
-- 			z = coords.z - 3
-- 		}, function(object2)
-- 			--AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
-- 			AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
-- 			SetPedDiesInWater(playerPed, false)
			
-- 			ESX.ShowNotification('Bạn đã mặc đồ lặn, bạn có 100%.')
			
-- 			Citizen.Wait(100000)
-- 			ESX.ShowNotification('Bạn còn 50%.')
			
-- 			Citizen.Wait(50000)
-- 			ESX.ShowNotification('Bạn còn 25%.')

-- 			Citizen.Wait(15000)
-- 			ESX.ShowNotification('Bạn còn 10%.')

-- 			Citizen.Wait(10000)
-- 			ESX.ShowNotification('Bạn còn 0%.')
			
			
-- 			SetPedDiesInWater(playerPed, true)
-- 			DeleteObject(object)
-- 			DeleteObject(object2)
-- 			ClearPedSecondaryTask(playerPed)
-- 		end)
-- 	end)
-- end)

-- -- phụ kiện
-- -- RegisterNetEvent('esx_extraitems:componentWeapon', function(type)
-- --     local playerPed = PlayerPedId()
-- --     local hash = GetSelectedPedWeapon(playerPed)

-- --     if IsPedArmed(playerPed, 4) then
-- --         if type == 'extended' then
-- --             if hash ~= nil then
-- --                 local weapon  = ESX.GetWeaponFromHash(hash)
-- --                 TriggerServerEvent('esx_extraitems:extendedClip', weapon.name)
-- --             end
-- --         elseif type == 'silenced' then
-- --             if hash ~= nil then
-- --                 local weapon  = ESX.GetWeaponFromHash(hash)
-- --                 TriggerServerEvent('esx_extraitems:silencedClip', weapon.name)
-- --             end
-- --         elseif type == 'skinakvang' then
-- --             if hash ~= nil then
-- --                 local weapon  = ESX.GetWeaponFromHash(hash)
-- --                 TriggerServerEvent('esx_extraitems:SkinAkGold', weapon.name)
-- --             end
-- --         end
-- --     end
-- -- end)

-- RegisterNetEvent('consumable:langbam', function()
--     local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
--     local closestPlayerPed = GetPlayerPed(closestPlayer)
--     local chance = math.random(0,100)
--     if IsPedDeadOrDying(closestPlayerPed, 1) then
--         exports.rprogress:Custom({
--             Duration = 10000,
--             Label = 'Hô hấp nhân tạo',
--             LabelPosition = "bottom",
--             ShowTimer = true,
--             useWhileDead = 0,
--             canCancel = 0,
--             DisableControls = {
--                 Mouse = false,
--                 Player = true,
--                 Vehicle = true
--             },
--             Animation = {
--                 animationDictionary = "mini@cpr@char_a@cpr_str",
--                 animationName = "cpr_pumpchest"
--             },
--         onComplete = function()
--             TriggerServerEvent('esx_ambulancejob:removeItem', 'langbam')
--             if chance <= 70 then
--                 TriggerServerEvent('esx_ambulancejob:revivelangbam', GetPlayerServerId(closestPlayer))
--             end
--         end})
--     else
--         ESX.ShowNotification('Người chơi không chết')
--     end
-- end)

