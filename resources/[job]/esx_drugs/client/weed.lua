local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 50 then
			SpawnWeedPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 5 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('weed_processprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then
				if ESX.NumPolice_CL() >= 2 then
					ProcessWeed()
				else
					ESX.ShowNotification('Cần 2 cảnh sát', 'error', 3000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessWeed()
	-- isProcessing = true

	-- ESX.ShowNotification(_U('weed_processingstarted'))
	-- TriggerServerEvent('esx_illegal:processCannabis')
	-- local timeLeft = Config.Delays.WeedProcessing / 1000
	-- local playerPed = PlayerPedId()

	-- while timeLeft > 0 do
	-- 	Citizen.Wait(1000)
	-- 	timeLeft = timeLeft - 1

	-- 	if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 5 then
	-- 		ESX.ShowNotification(_U('weed_processingtoofar'))
	-- 		TriggerServerEvent('esx_illegal:cancelProcessing')
	-- 		break
	-- 	end
	-- end

	-- isProcessing = false
	exports.rprogress:Custom({
        Duration = Config.Delays.WeedProcessing,
        Label = "Đang sấy cần...",
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
            TriggerServerEvent('esx_illegal:processCannabis')
        end
    })
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('weed_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				if ESX.NumPolice_CL() > 1 then
					isPickingUp = true

					ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)
							if canPickUp then
								TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
								exports.rprogress:Custom({
									Duration = 3000,
									Label = "Đang hái lá cần...",
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
										table.remove(weedPlants, nearbyID)
										spawnedWeeds = spawnedWeeds - 1
										TriggerServerEvent('esx_illegal:pickedUpCannabis')
									end
								})
							else
								ESX.ShowNotification(_U('weed_inventoryfull'), 'error', 3000)
							end

							isPickingUp = false

					end, 'cannabis')
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
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 30 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end