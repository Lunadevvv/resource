-- local modelBlacklist = {
-- 	'mustang2',
-- 	'rmodbolide',
-- 	'mustang',
-- 	'q60',
-- 	'lbkv',
-- 	'lamborghinis93',
-- 	'21ltz',
-- 	'evo2',
-- 	'f458',
-- 	'jimmy',
-- 	'LordTfenyr',
-- 	'oyclc500',
-- 	'rmodgtr50s',
-- 	'shelby20',
-- 	'veneno',
-- 	'xevanh',
-- }

-- RegisterNetEvent('esx_contract:getVehicle')
-- AddEventHandler('esx_contract:getVehicle', function()
-- 	local playerPed = PlayerPedId()
-- 	local coords = GetEntityCoords(playerPed)
-- 	local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()

-- 	if closestPlayer ~= -1 and playerDistance <= 3.0 then
-- 		local vehicle = ESX.Game.GetClosestVehicle(coords)
-- 		local vehiclecoords = GetEntityCoords(vehicle)
-- 		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
-- 		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
-- 			local vehProps = ESX.Game.GetVehicleProperties(vehicle)
-- 			ESX.ShowNotification('Hợp đồng cho tấm giấy phép sau: ~g~' .. vehProps.plate)
-- 			TriggerServerEvent('esx_contract:sellVehicle', GetPlayerServerId(closestPlayer), vehProps.plate)
-- 		else
-- 			ESX.ShowNotification('Không có ai gần bạn')
-- 		end
-- 	else
-- 		ESX.ShowNotification('Không có người mua gần đây')
-- 	end
-- end)

-- RegisterNetEvent('esx_contract:showAnim')
-- AddEventHandler('esx_contract:showAnim', function(player)
-- 	loadAnimDict('anim@amb@nightclub@peds@')
-- 	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
-- 	Citizen.Wait(20000)
-- 	ClearPedTasks(PlayerPedId())
-- end)

-- RegisterNetEvent('contract:themluot', function()
--     local playerPed = PlayerPedId()
-- 	local coords = GetEntityCoords(playerPed)
--     local vehicle = GetVehiclePedIsIn(playerPed, false)
--     if DoesEntityExist(vehicle) then
-- 		for k,v in pairs (modelBlacklist) do
-- 			if GetEntityModel(vehicle) ~= GetHashKey(v) then
-- 				local vehProps = ESX.Game.GetVehicleProperties(vehicle)
-- 				TriggerServerEvent('contract:server:themluot', vehProps.plate)
-- 			else
-- 				TriggerEvent('notify:Alert', 'Thêm lượt', 'Không thể thêm lượt cho xe này', 7000, 'error')
-- 			end
-- 		end
--     end
-- end)

-- function loadAnimDict(dict)
-- 	while (not HasAnimDictLoaded(dict)) do
-- 		RequestAnimDict(dict)
-- 		Citizen.Wait(0)
-- 	end
-- end