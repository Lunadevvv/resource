Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
            if IsControlJustReleased(1, 303) then
                ToggleLocks()
            end
        -- end
    end
end)

function ToggleLocks()
    local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
    if Vehicle ~= nil and Vehicle ~= 0 then
        local VehicleCoords = GetEntityCoords(Vehicle)
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
        local Plate = GetVehicleNumberPlateText(Vehicle)
        print(Plate)
        ESX.TriggerServerCallback('carlock:isVehicleOwner', function(result) 
            if result then
                if VehDistance <= 3.2 then
                    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                    if VehicleLocks == 1 then
                        Citizen.Wait(450)
                        SetVehicleDoorsLocked(Vehicle, 2)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerEvent('vehicleley:client:blink:lights', Vehicle)
                        ESX.ShowNotification("Đã khóa xe")
                    else
                        Citizen.Wait(450)
                        SetVehicleDoorsLocked(Vehicle, 1)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerEvent('vehicleley:client:blink:lights', Vehicle)
                        ESX.ShowNotification("Đã mở khóa xe")
                    end
                end
            else
                ESX.ShowNotification('Đây ko phải xe của bạn', 3000, 'error')
            end
        end, Plate)
    end
end

RegisterNetEvent('vehicleley:client:blink:lights')
AddEventHandler('vehicleley:client:blink:lights', function(Vehicle)
    SetVehicleLights(Vehicle, 2)
    SetVehicleBrakeLights(Vehicle, true)
    SetVehicleInteriorlight(Vehicle, true)
    SetVehicleIndicatorLights(Vehicle, 0, true)
    SetVehicleIndicatorLights(Vehicle, 1, true)
    Citizen.Wait(450)
    SetVehicleIndicatorLights(Vehicle, 0, false)
    SetVehicleIndicatorLights(Vehicle, 1, false)
    Citizen.Wait(450)
    SetVehicleInteriorlight(Vehicle, true)
    SetVehicleIndicatorLights(Vehicle, 0, true)
    SetVehicleIndicatorLights(Vehicle, 1, true)
    Citizen.Wait(450)
    SetVehicleLights(Vehicle, 0)
    SetVehicleBrakeLights(Vehicle, false)
    SetVehicleInteriorlight(Vehicle, false)
    SetVehicleIndicatorLights(Vehicle, 0, false)
    SetVehicleIndicatorLights(Vehicle, 1, false)
end)
