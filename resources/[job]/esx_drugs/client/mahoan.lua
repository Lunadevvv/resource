local spawnedMahoan = 0
local mahoanPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MahoanField.coords, true) < 50 then
			SpawnmahoanPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MahoanProcessing.coords, true) < 5 then
			if not isProcessing then
				ESX.ShowHelpNotification('Bấm ~g~[E]~w~ để đóng gói Ma hoàng')
			end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then
				if ESX.NumPolice_CL() > 1 then
					ProcessMahoan()
				else
					ESX.ShowNotification('Cần 2 cảnh sát', 'error', 3000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessMahoan()
	-- isProcessing = true

	-- ESX.ShowNotification(_U('weed_processingstarted'))
	-- TriggerServerEvent('esx_illegal:processMahoan')
	-- local timeLeft = Config.Delays.MahoanProcessing / 1000
	-- local playerPed = PlayerPedId()

	-- while timeLeft > 0 do
	-- 	Citizen.Wait(1000)
	-- 	timeLeft = timeLeft - 1

	-- 	if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MahoanProcessing.coords, false) > 5 then
	-- 		ESX.ShowNotification(_U('weed_processingtoofar'))
	-- 		TriggerServerEvent('esx_illegal:cancelProcessing')
	-- 		break
	-- 	end
	-- end

	-- isProcessing = false
	exports.rprogress:Custom({
        Duration = Config.Delays.MahoanProcessing,
        Label = "Đang đóng gói Ma hoàng...",
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
            TriggerServerEvent('esx_illegal:processMahoan')
        end
    })
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #mahoanPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(mahoanPlants[i]), false) < 1 then
				nearbyObject, nearbyID = mahoanPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification('Bấm ~g~[E]~w~ để thu hoạch Ma hoàng')
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				if ESX.NumPolice_CL() > 1 then
					isPickingUp = true

					ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)
							if canPickUp then
								TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
								exports.rprogress:Custom({
									Duration = 3000,
									Label = "Đang hái Ma hoàng...",
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
										table.remove(mahoanPlants, nearbyID)
										spawnedMahoan = spawnedMahoan - 1
										TriggerServerEvent('esx_illegal:pickedUpMahoan')
									end
								})
							else
								ESX.ShowNotification('Không thể mang thêm được nữa', 'error', 3000)
							end

							isPickingUp = false

					end, 'mahoan')
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
		for k, v in pairs(mahoanPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnmahoanPlants()
	while spawnedMahoan < 15 do
		Citizen.Wait(0)
		local mahoanCoords = GenerateMahoanCoords()

		ESX.Game.SpawnLocalObject('prop_mp_drug_package', mahoanCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			
			table.insert(mahoanPlants, obj)
			spawnedMahoan = spawnedMahoan + 1
		end)
	end
end

function ValidateMahoanCoord(plantCoord)
	if spawnedMahoan > 0 then
		local validate = true

		for k, v in pairs(mahoanPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.MahoanField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMahoanCoords()
	while true do
		Citizen.Wait(1)

		local mahoanCoordX, mahoanCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		mahoanCoordX = Config.CircleZones.MahoanField.coords.x + modX
		mahoanCoordY = Config.CircleZones.MahoanField.coords.y + modY

		local coordZ = GetCoordZMahoan(mahoanCoordX, mahoanCoordY)
		local coord = vector3(mahoanCoordX, mahoanCoordY, coordZ)

		if ValidateMahoanCoord(coord) then
			return coord
		end
	end
end

function GetCoordZMahoan(x, y)
	local groundCheckHeights = { 46, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end