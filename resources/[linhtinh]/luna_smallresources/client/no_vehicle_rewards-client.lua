-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		DisablePlayerVehicleRewards(PlayerId())
-- 		SetWeaponDrops()
-- 	end
-- end)

-- function SetWeaponDrops()
-- 	local handle, ped = FindFirstPed()
-- 	local finished = false

-- 	repeat
-- 		if not IsEntityDead(ped) then
-- 			SetPedDropsWeaponsWhenDead(ped, false)
-- 		end
-- 		finished, ped = FindNextPed(handle)
-- 	until not finished

-- 	EndFindPed(handle)
-- end

-- -- RegisterCommand('ca', function()
-- -- 	ClearPedTasksImmediately(PlayerPedId())
-- -- end, false)

-- -- CreateThread(function()
-- --     while true do
-- --         local ped = PlayerPedId()
-- --         local weapon = GetSelectedPedWeapon(ped)
-- -- 		if weapon ~= `WEAPON_UNARMED` then
-- -- 			if IsPedArmed(ped, 6) then
-- -- 				DisableControlAction(1, 140, true)
-- -- 				DisableControlAction(1, 141, true)
-- -- 				DisableControlAction(1, 142, true)
-- -- 			end
-- -- 		else
-- -- 			Wait(500)
-- -- 		end
-- --         Wait(7)
-- --     end
-- -- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         local ped = PlayerPedId()
-- 		local veh = GetVehiclePedIsIn(ped, false)
--         if IsPedArmed(ped, 6) then
-- 			DisableControlAction(1, 140, true)
--             DisableControlAction(1, 141, true)
--             DisableControlAction(1, 142, true)
--             if GetPedInVehicleSeat(veh, -1) == ped then
-- 				print('1')
--                 SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
--             end
--         else
--             Wait(500)
--         end
--     end
-- end)