-- ESX = nil
curGarage = nil
vehicle = nil
rgb = {}
spawnedVehs = {}
curVehName = ""
 
Citizen.CreateThread(function()
    while ESX == nil do
        -- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        SetEntityVisible(PlayerPedId(), 1)
        Citizen.Wait(0)
    end

    for k,va in pairs(Config.Vehicles) do 
        for i,v in pairs(Config.Vehicles[k]) do
          if k == "super" then 
            v.fuel = math.random(80, 100)
            v.consumption = 3
            v.trunk = Config.TrunkCapacity
         elseif k == "vans" then 
            v.fuel = math.random(80, 100)
            v.consumption = 2
            v.trunk = Config.TrunkVanCapacity
         else 
            v.fuel = math.random(80, 100)
            v.consumption = 1
            v.trunk = Config.TrunkCapacity
         end
        end
    end

    for k,va in pairs(Config.Boat) do 
        for i,v in pairs(Config.Boat[k]) do
          if k == "Kategori" then 
            v.fuel = math.random(80, 100)
            v.consumption = 3
            v.trunk = Config.TrunkCapacity
         elseif k == "vans" then 
            v.fuel = math.random(80, 100)
            v.consumption = 2
            v.trunk = Config.TrunkVanCapacity
         else 
            v.fuel = math.random(80, 100)
            v.consumption = 1
            v.trunk = Config.TrunkCapacity
         end
        end
    end

    for k,va in pairs(Config.Araba) do 
        for i,v in pairs(Config.Araba[k]) do
          if k == "Kategori" then 
            v.fuel = math.random(80, 100)
            v.consumption = 3
            v.trunk = Config.TrunkCapacity
         elseif k == "vans" then 
            v.fuel = math.random(80, 100)
            v.consumption = 2
            v.trunk = Config.TrunkVanCapacity
         else 
            v.fuel = math.random(80, 100)
            v.consumption = 1
            v.trunk = Config.TrunkCapacity
         end
        end
    end
	
	for i,v in pairs(Config.Shops) do 
	   blip = AddBlipForCoord(v.coord.x, v.coord.y, v.coord.z)
       SetBlipSprite(blip, 225)
       SetBlipDisplay(blip, 4)
       SetBlipScale(blip, 0.7)
       SetBlipColour(blip, 0)
       SetBlipAsShortRange(blip, true)
       BeginTextCommandSetBlipName("STRING")
       AddTextComponentString(v.name)
       EndTextCommandSetBlipName(blip)
	end
 
end)
 
Citizen.CreateThread(function() 
     while 1 > 0 do 
      sleepThread = 2000
      PlayerData = ESX.GetPlayerData()
      plyCoords = GetEntityCoords(PlayerPedId())
      
      for k,v in pairs(Config.Shops) do
         if GetDistanceBetweenCoords(plyCoords, v.coord)  <= v.dist then 
            sleepThread = 0
            auth = false
            if v.job == false then 
               DrawText3D(v.coord.x , v.coord.y  , v.coord.z, '[E] - '..v.name)
               auth = true
            elseif v.job == PlayerData.job.name then 
               DrawText3D(v.coord.x , v.coord.y  , v.coord.z, '[E] - '..v.name)
               auth = true
            end

            if auth == true and IsControlJustPressed(1, 38) and GetDistanceBetweenCoords(plyCoords, v.coord) <= 1.5 then 
               initGarage(k)
               Wait(1500)
            end
         end
      end
      Citizen.Wait(sleepThread)
     end
end)
cam = nil
function initGarage(x)
   curGarage = Config.Shops[x]
   SetEntityVisible(PlayerPedId(), 0)
   cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
   SetCamCoord(cam, curGarage.camCoord)
   SetCamRot(cam, curGarage.camRot, 2)
   SetCamActive(cam, true)
   RenderScriptCams(true, true, 1)
   SendNUIMessage({ action = "load", garage = curGarage })
   SetNuiFocus(1, 1)
   DisplayRadar(0)
end

function destroyCam()
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
        RenderScriptCams(false, true, 1)
        cam = nil
    end
end

RegisterNUICallback("close", function(data, cb)
	SetEntityCoords(PlayerPedId(), curGarage.coord)
	DisplayRadar(1)
    SetNuiFocus(0, 0)
    destroyCam()
    SetEntityVisible(PlayerPedId(), 1)
    deleteLastCar() 
end)


RegisterNUICallback("testdrive", function(data, cb)
    SetNuiFocus(0, 0)
	SetEntityVisible(PlayerPedId(), 1)
    destroyCam()
    if vehicle and DoesEntityExist(vehicle) then
        FreezeEntityPosition(vehicle,false)
        SetVehicleUndriveable(vehicle,false)
		SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetPedCoordsKeepVehicle(PlayerPedId(), Config.TestDrive.coords)
		SendNUIMessage({ action = "startTest" })
    end 
    Citizen.CreateThread(function()
        local start = GetGameTimer()/1000
        while GetGameTimer()/1000 - start < Config.TestDrive.seconds and DoesEntityExist(vehicle) and not IsEntityDead(PlayerPedId()) do
            if #(GetEntityCoords(PlayerPedId()) - Config.TestDrive.coords) > Config.TestDrive.range then
                SetPedCoordsKeepVehicle(PlayerPedId(), Config.TestDrive.coords)
            end
            if GetVehiclePedIsIn(PlayerPedId(), false) == 0 and DoesEntityExist(vehicle) then
                SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end
            Wait(1000)
        end
        SetPedCoordsKeepVehicle(PlayerPedId(), curGarage.carSpawnCoord)
        FreezeEntityPosition(vehicle, true)
        SetVehicleUndriveable(vehicle, true)
        ClearPedTasksImmediately(PlayerPedId())
        SetEntityCoords(PlayerPedId(), curGarage.coord)
		SendNUIMessage({ action = "stopTest" })
		deleteLastCar() 
    end)
end)


RegisterNUICallback("buy", function(data, cb)
    blackMoney = data.blackMoney
    local PlayerPed = PlayerPedId()
     
    local veh = getVehicleFromName(curVehName)
    local generatedPlate = GeneratePlate()
	ESX.TriggerServerCallback("s4-vehicleshop:checkPrice", function(pg)  
        if pg == true then 
            Citizen.CreateThread(function() 
                RequestModel(GetHashKey(veh.name))
                while not HasModelLoaded(GetHashKey(veh.name)) do
                   Wait(1000)
                end
                local xVehicle = CreateVehicle(veh.name, curGarage.deliveryCoord, true, false)
                SetVehicleNumberPlateText(xVehicle, generatedPlate)
                 SetVehicleCustomPrimaryColour(xVehicle, tonumber(rgb.r), tonumber(rgb.g), tonumber(rgb.b))
                 SetVehicleCustomSecondaryColour(xVehicle, tonumber(rgb.r), tonumber(rgb.g), tonumber(rgb.b))
                SetPedIntoVehicle(PlayerPed, xVehicle, -1)
                Wait(500)
                TriggerServerEvent('s4-vehicleshop:server:givecar', ESX.Game.GetVehicleProperties(xVehicle), curGarage, veh.price)
                rgb = {}
				DisplayRadar(1)
                SetNuiFocus(0, 0)
                destroyCam()
                SetEntityVisible(PlayerPed, 1)
                deleteLastCar() 
           end)
           Wait(500)
           cb(pg) 
        else 
           cb(false)
        end 
    end, { price = veh.price, blackMoney = blackMoney, curGarage = curGarage })
end)
 

function getVehicleFromName(x)
   for k,va in pairs(curGarage.Vehicles) do 
      for i,v in pairs(curGarage.Vehicles[k]) do
         if v.name == x then 
            return v
         end
      end
   end
end
 
RegisterNUICallback("checkPlatePrice", function(data, cb)
    plate = data.plate 
	ESX.TriggerServerCallback("s4-vehicleshop:checkPlatePrice", function(pg)  cb(pg) if pg == true then SetVehicleNumberPlateText(vehicle, plate) end end, plate)
end)
 
 
RegisterNUICallback("setcolour", function(data)
	if DoesEntityExist(vehicle) then
        rgb = data.rgb
		SetVehicleCustomPrimaryColour(vehicle, tonumber(data.rgb.r), tonumber(data.rgb.g), tonumber(data.rgb.b))
	end
end)

 
RegisterNUICallback("right", function(data)
	if vehicle and DoesEntityExist(vehicle) then
        SetEntityRotation(vehicle, GetEntityRotation(vehicle) + vector3(0,0,1), false, false, 2, false)
    end
end)

RegisterNUICallback("left", function(data)
	if vehicle and DoesEntityExist(vehicle) then
        SetEntityRotation(vehicle, GetEntityRotation(vehicle) - vector3(0,0,1), false, false, 2, false)
    end
end)

 
RegisterNUICallback("showCar", function(data, cb) showCar(data.name) end)
 
function deleteLastCar() 
    for i,v in pairs(spawnedVehs) do
       if DoesEntityExist(v) then
          DeleteEntity(v)
       end
       table.remove(spawnedVehs, i)
    end
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        vehicle = nil
    end
end
 
function showCar(modelName)
    local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
    
	Citizen.CreateThread(function()
 
        deleteLastCar() 

		local modelHash = model
        modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
    
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(1)
            end
        end

        
		vehicle = CreateVehicle(model, curGarage.carSpawnCoord, false, false)
        curVehName = modelName
		SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        table.insert(spawnedVehs, vehicle)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(curGarage.carSpawnCoord.x, curGarage.carSpawnCoord.y, curGarage.carSpawnCoord.z)

		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end
 
function DrawText3D(x, y, z, text)
	SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end