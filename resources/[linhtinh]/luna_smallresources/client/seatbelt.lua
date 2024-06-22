local isUiOpen = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false


IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end
 
	Citizen.CreateThread(function()
	while true do
  	Citizen.Wait(0)
    
      local ped = GetPlayerPed(-1)
      local car = GetVehiclePedIsIn(ped)
      local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local vehicleClass = GetVehicleClass(vehicle)
      
      if car ~= 0 and (wasInCar or IsCar(car)) and vehicleClass ~= 8 then
        wasInCar = true
        if isUiOpen == false and not IsPlayerDead(PlayerId()) then
          SendNUIMessage({
      	   displayWindow = 'true'
      	   })
          isUiOpen = true
        end

         if beltOn then 
      	  DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
      	  DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
      	 end

        speedBuffer[2] = speedBuffer[1]
        speedBuffer[1] = GetEntitySpeed(car)


        
        if speedBuffer[2] ~= nil 
           and not beltOn
           and GetEntitySpeedVector(car, true).y > 1.0  
           and speedBuffer[1] > 19.25 
           and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
           
          local co = GetEntityCoords(ped)
          local fw = Fwv(ped)
          SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
          SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
          Citizen.Wait(1)
          SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
          
        velBuffer[2] = velBuffer[1]
        velBuffer[1] = GetEntityVelocity(car)
          
        if IsControlJustReleased(0, 47) and GetLastInputMethod(0) then
          TriggerEvent('seatbelt:togglesb')
        end
        
      elseif wasInCar then
        wasInCar = false
        beltOn = false
        speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        if isUiOpen == true and not IsPlayerDead(PlayerId()) then
          SendNUIMessage({
      	   displayWindow = 'false'
      	   })
          isUiOpen = false 
        end
        Wait(2000)
      end
    
  end
end)

RegisterNetEvent("FakeRevive")
AddEventHandler("FakeRevive", function(inputText) 
  RequestAnimDict("oddjobs@taxi@cyi")
  TaskPlayAnim(GetPlayerPed(-1),"oddjobs@taxi@cyi", "std_hand_off_ps_passenger", 8.0, -8.0, -1, 0, 0, false, false, false)
end)

RegisterNetEvent('seatbelt:togglesb')
AddEventHandler('seatbelt:togglesb', function()
  -- TriggerEvent("FakeRevive")
  
  beltOn = not beltOn 
  if beltOn then 
    ESX.ShowNotification("Đã cài dây an toàn")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
    
    SendNUIMessage({
      displayWindow = 'false'
      })
    isUiOpen = true 
    
  else 
    ESX.ShowNotification("Đã tháo dây an toàn")
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
    SendNUIMessage({
       displayWindow = 'true'
       })
    isUiOpen = true  
    
  end
end)


function DrawText3Ds(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.45, 0.45)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.035+ factor, 0.03, 41, 11, 41, 68)
end
-------------------------------------------------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
  veheng = GetVehicleEngineHealth(GetVehiclePedIsUsing(PlayerPedId()))
  vehbody = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))
  local Coords  = GetEntityCoords(PlayerPedId())
      local coords2 = GetEntityCoords(GetPlayerPed(-1))
      local cansee = false
  if IsPedInAnyVehicle(PlayerPedId(), 1) then
    vehenground = tonumber(string.format("%.2f", veheng))
    vehbodround = tonumber(string.format("%.2f", vehbody))
    if IsControlPressed(0, 353) then
              if GetDistanceBetweenCoords(coords2, Coords.x, Coords.y, Coords.z+1.0, true) < 5.0 then
                  cansee = true
             DrawText3Ds(Coords.x, Coords.y, Coords.z+1.0, "~o~Độ bền : ~b~"..vehenground .. "%")
              end
    end

      end
      if cansee == false then Wait(1000) end
  end
end)
