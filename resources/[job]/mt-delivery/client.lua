local ped = PlayerPedId()

local salary = Config.Payout
local name = Config.Name
local Dealer = Config.Delivery.Dealer

spawned = false
local onDuty = false

local point = lib.points.new({
    coords = vector3(-40.62, -1081.82, 26.61),
    distance = 2,
    dunak = 'nerd'
})
 
function point:onEnter()
    lib.showTextUI("Nhấn E nhận nhiệm vụ")
end
 
function point:onExit()
    lib.hideTextUI()
end
 
function point:nearby()

    DrawMarker(27, -40.62, -1081.82, 26.61, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
 
    if IsControlJustReleased(0, 38) then
        if not onDuty then
          TriggerEvent('mt-delivery:toggleDuty', true)
          ESX.ShowNotification("Bạn đã nhận việc của " ..name.. ", hãy đến điểm nhận xe trên map.", 'success', 3000)
          blip()
          createPed()
        else 
          TriggerEvent('mt-delivery:toggleDuty', false)
          ESX.ShowNotification("Bạn đã hết ca!", 'success', 3000)
          RemoveBlip(dealerBlip)
          DeletePed(npc)
        end 
    end
end

local point = lib.points.new({
    coords = vector3(1009.79, -2892.43, 11.26),
    distance = 2,
    dunak = 'nerd'
})
 
function point:onEnter()
    lib.showTextUI("Nhấn E để nói chuyện")
end
 
function point:onExit()
    lib.hideTextUI()
end
 
function point:nearby()
 local ped = PlayerPedId()
  if onDuty then
    DrawMarker(27, 1009.79, -2892.43, 11.26, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
 
    if IsControlJustReleased(0, 38) then

        lib.progressBar({
            duration = 8000,
            label = 'Đang giao dịch',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true
            },
            anim = {
                dict = 'special_ped@baygor@monologue_3@monologue_3d',
                clip = 'trees_can_talk_3'
            },
        })
        RequestModel('adder')
        while not HasModelLoaded('adder') do
            Citizen.Wait(1)
        end
        local vehicle = CreateVehicle('adder', 991.8, -2956.15, 5.49, 89.14, true, true)
        SetVehicleNumberPlateText(vehicle, "DELIVERY")
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        local alert = lib.alertDialog({
            header = 'Giao xe ',
            content = 'Giao xe đến địa điểm trên map!',
            centered = true,
            cancel = false
        })
        SetNewWaypoint(-17.19, -1106.32)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        SetModelAsNoLongerNeeded('adder')
        DeletePed(npc)

    end
  end
end


function blip()
    dealerBlip = AddBlipForCoord(Dealer.Pos.x, Dealer.Pos.y, Dealer.Pos.z)
    SetBlipSprite(dealerBlip, Dealer.BlipSprite)
    SetBlipDisplay(dealerBlip, 4)
    SetBlipScale(dealerBlip, Dealer.BlipScale)
    SetBlipAsShortRange(dealerBlip, true)
    SetBlipColour(dealerBlip, Dealer.BlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Dealer.BlipLabel)
    EndTextCommandSetBlipName(dealerBlip)
end

function createPed()

    local ped_hash = GetHashKey('a_m_m_bevhills_01')
    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do
        Citizen.Wait(1)
    end
    npc = CreatePed(1, ped_hash, 1009.79, -2892.43, 11.26-0.96, 174.2, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end

AddEventHandler('mt-delivery:toggleDuty', function(bool)
    onDuty = bool
end)

local point = lib.points.new({
    coords = vector3(-17.19, -1106.32, 26.67),
    distance = 4,
    dunak = 'nerd'
})
 
function point:onEnter()
if onDuty then
    lib.showTextUI("Nhấn E để giao xe")
end
end
 
function point:onExit()
if onDuty then
    lib.hideTextUI()
end
end
 
function point:nearby()
 local ped = PlayerPedId()
  if onDuty then
    DrawMarker(27, -17.19, -1106.32, 26.67, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
    local vehicle2 = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(vehicle2)
    if plate == 'DELIVERY' then
        if IsControlJustReleased(0, 38) then

            lib.progressBar({
            duration = 2000,
            label = 'Giao xe',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = false,
                move = true
            },
            })

            TriggerEvent('mt-delivery:toggleDuty', false)
            ESX.Game.DeleteVehicle(vehicle2)
            ESX.ShowNotification("Giao xe thành công", 'success', 3000)
            TriggerServerEvent('mt-delivery:Payout', salary)
            RemoveBlip(dealerBlip)
        end
    end
  end
end