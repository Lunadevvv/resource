local spawnedCocaLeaf = 0
local CocaPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 50 then
			SpawnCocaPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 5 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('coke_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then
				if ESX.NumPolice_CL() > 1 then
					ProcessCoke()
				else
					ESX.ShowNotification('Cần 2 cảnh sát', 'error', 3000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCoke()
	exports.rprogress:Custom({
        Duration = Config.Delays.CokeProcessing,
        Label = "Đang chế cocain...",
        LabelPosition = "center",
        ShowTimer = false,
        DisableControls = {
            Mouse = false,
            Player = true,
            Vehicle = true
        },
        Animation = {
            animationDictionary = "creatures@rottweiler@tricks@",
            animationName = "petting_franklin"
        },
        onComplete = function()
			TriggerServerEvent('esx_illegal:processCocaLeaf')
        end
    })
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #CocaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(CocaPlants[i]), false) < 1 then
				nearbyObject, nearbyID = CocaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('coke_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				if ESX.NumPolice_CL() > 1 then
					isPickingUp = true

					ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)
							if canPickUp then
								TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
								exports.rprogress:Custom({
									Duration = 3000,
									Label = "Đang hái lá Coca...",
									LabelPosition = "center",
									ShowTimer = false,
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									},
									Animation = {
										-- animationDictionary = "creatures@rottweiler@tricks@",
										-- animationName = "petting_franklin"
									},
									onComplete = function()
										ClearPedTasksImmediately(playerPed)
										ESX.Game.DeleteObject(nearbyObject)
										table.remove(CocaPlants, nearbyID)
										spawnedCocaLeaf = spawnedCocaLeaf - 1
										TriggerServerEvent('esx_illegal:pickedUpCocaLeaf')
									end
								})
							else
								ESX.ShowNotification(_U('coke_inventoryfull'), 'error', 3000)
							end

							isPickingUp = false

					end, 'coca_leaf')
				else
					ESX.ShowNotification('Cần 2 cảnh sát', 'error', 3000)
				end
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(CocaPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCocaPlants()
	while spawnedCocaLeaf < 15 do
		Citizen.Wait(0)
		local weedCoords = GenerateCocaLeafCoords()

		ESX.Game.SpawnLocalObject('prop_plant_01a', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(CocaPlants, obj)
			spawnedCocaLeaf = spawnedCocaLeaf + 1
		end)
	end
end

function ValidateCocaLeafCoord(plantCoord)
	if spawnedCocaLeaf > 0 then
		local validate = true

		for k, v in pairs(CocaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CokeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCocaLeafCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		weedCoordX = Config.CircleZones.CokeField.coords.x + modX
		weedCoordY = Config.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZCoke(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateCocaLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZCoke(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end