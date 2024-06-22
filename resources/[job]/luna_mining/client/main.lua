local showBlip = false
local blips = {}
local curAction = nil
local mineStone = {}
local isBusy = false

RegisterNetEvent("luna_mining:client:updateQuantity", function(data)
    setMineStone(data)
end)

RegisterNetEvent('luna_mining:showBlip', function()
    showBlip = not showBlip
    refreshBlip()
end)

Citizen.CreateThread(function()
    lib.callback('luna_mining:getMineWithData', false, function(data)
        setMineStone(data)
    end)
end)

CreateThread(function()
    while true do 
        Wait(10)
        checkPos()
        if not isBusy then
            if curAction~= nil then
                if curAction ~= 'washed_stone' and  curAction ~= 'melting' then
                    DrawMarker(2, Config.Location['mining'][curAction].coord.x, Config.Location['mining'][curAction].coord.y, Config.Location['mining'][curAction].coord.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 150, false, false, 2, nil, nil, false)
                    DrawText3D(Config.Location['mining'][curAction].coord.x, Config.Location['mining'][curAction].coord.y, Config.Location['mining'][curAction].coord.z, 'Sản lượng: ' .. mineStone[curAction].quantity .. '/' .. Config.QuantityMax)
                    ESX.TextUI("Nhấn [E] để đào", 'info')
                    if IsControlJustReleased(0, 38) then
                        lib.callback('luna_mining:callback:hasItem', false, function(data)
                            if data >= 1 then
                                mining(curAction)
                            else
                                ESX.ShowNotification('Bạn không có cuốc', 'error', 3000)
                            end
                        end, 'pickaxe')
                    end
                else
                    DrawMarker(2, Config.Location[curAction].x, Config.Location[curAction].y, Config.Location[curAction].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 150, false, false, 2, nil, nil, false)
                    if curAction == 'washed_stone' then
                        ESX.TextUI("Nhấn [E] để rửa đá", 'info')
                        if IsControlJustReleased(0, 38) then
                            lib.callback('luna_mining:callback:hasItem', false, function(data)
                                if data >= 5 then
                                    washingStone(curAction)
                                else
                                    ESX.ShowNotification('Bạn thiếu ' .. 5 - data .. ' đá thô', 'error', 3000)
                                end
                            end, 'stone')
                        end
                    else
                        ESX.TextUI("Nhấn [E] để nung đá", 'info')
                        if IsControlJustReleased(0, 38) then
                            lib.callback('luna_mining:callback:hasItem', false, function(data)
                                if data >= 5 then
                                    melting(curAction)
                                else
                                    ESX.ShowNotification('Bạn thiếu ' .. 5 - data .. ' đá đã rửa', 'error', 3000)
                                end
                            end, 'washed_stone')
                        end
                    end
                end
            end 
        end
    end
end)

Citizen.CreateThread(function()
    blippp = AddBlipForCoord(-593.95855712891, 2091.75390625, 131.71856689453)
    SetBlipSprite(blippp, 357)
    SetBlipDisplay(blippp, 4)
    SetBlipScale(blippp, 0.6)
    SetBlipColour(blippp, 0)
    SetBlipAsShortRange(blippp, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mỏ quặng")
    EndTextCommandSetBlipName(blippp)
end)

function setMineStone(data)
    mineStone = data
end

function mining(curAction)
    local ped = PlayerPedId()
    -- RequestAnimDict("amb@world_human_hammering@male@base")
    -- Citizen.Wait(100)
    -- TaskPlayAnim((ped), 'amb@world_human_hammering@male@base', 'base', 12.0, 12.0, -1, 80, 0, 0, 0, 0)
    -- SetEntityHeading(ped, 270.0)
    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
    isBusy = true
    TriggerEvent("mythic_progbar:client:progress", {
        name = "freeze-step",
        duration = 5000,
        label = 'Đào đá',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },	
        animation = {
            animDict = "amb@world_human_hammering@male@base",
            anim = "base",
        },		
        -- prop = {
            -- model = "prop_tool_pickaxe",
        -- }	
        },function(status)
        if not status then
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('luna_mining:server:processMine', curAction, 1)
            exports["src-skills"]:UpdateSkill("Mining", 1)
            isBusy = false
        else
            ClearPedTasksImmediately(ped)
            isBusy = false
        end
    end)
    DetachEntity(pickaxe, 1, true)
    DeleteEntity(pickaxe)
    DeleteObject(pickaxe)
    TriggerServerEvent('luna_mining:reducePickaxeDurability')
end

function washingStone(curAction)
    local ped = PlayerPedId()
    isBusy = true
    TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "freeze-step2",
        duration = 5000,
        label = 'Rửa đá',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },	
        -- animation = {
            -- animDict = "amb@world_human_hammering@male@base",
            -- anim = "base",
        -- },		
        -- prop = {
            -- model = "prop_tool_pickaxe",
        -- }	
        },function(status)
        if not status then
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('luna_mining:server:processMine', curAction, 2)
            isBusy = false
        else
            ClearPedTasksImmediately(ped)
            isBusy = false
        end
    end)
end

function melting(curAction)
    local ped = PlayerPedId()
    isBusy = true
    TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    lib.callback('luna_mining:callback:hasItem', false, function(data)
        if data >= 1 then
            TriggerEvent("mythic_progbar:client:progress", {
                name = "freeze-step3",
                duration = 5000,
                label = 'Nung đá',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },	
                -- animation = {
                    -- animDict = "amb@world_human_hammering@male@base",
                    -- anim = "base",
                -- },		
                -- prop = {
                    -- model = "prop_tool_pickaxe",
                -- }	
                },function(status)
                if not status then
                    ClearPedTasksImmediately(ped)
                    TriggerServerEvent('luna_mining:server:processMine', curAction, 3)
                    isBusy = false
                    melting(curAction)
                else
                    ClearPedTasksImmediately(ped)
                    isBusy = false
                end
            end)
        else
            ESX.ShowNotification('Bạn không có đá đã rửa', 'error', 3000)
            ClearPedTasksImmediately(ped)
            isBusy = false
        end
    end, 'washed_stone')
end

function refreshBlip()
    for k,v in pairs (blips) do
        RemoveBlip(v)
    end

    if showBlip then
        blips.blip = AddBlipForCoord(Config.Location['washed_stone'].x, Config.Location['washed_stone'].y, Config.Location['washed_stone'].z)
        SetBlipSprite(blips.blip, 502)
        SetBlipScale(blips.blip, 0.6)
        SetBlipColour(blips.blip, 1)
        SetBlipAsShortRange(blips.blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Rửa đá")
        EndTextCommandSetBlipName(blips.blip)

        blips.blip2 = AddBlipForCoord(Config.Location['melting'].x, Config.Location['melting'].y, Config.Location['melting'].z)
        SetBlipSprite(blips.blip2, 503)
        SetBlipScale(blips.blip2, 0.6)
        SetBlipColour(blips.blip2, 1)
        SetBlipAsShortRange(blips.blip2, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Nung đá")
        EndTextCommandSetBlipName(blips.blip2)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

function checkPos()
    local ped = PlayerPedId()
    local pCoord = GetEntityCoords(ped)
    for k, v in pairs (Config.Location) do
        if k == 'mining' then
            for i=1, #Config.Location['mining'], 1 do
                local dist = #(pCoord - Config.Location['mining'][i].coord)
                if dist <= 2.0 then
                    curAction = i
                    return
                end
            end
        else
            local dist = #(pCoord - v)
            if dist <= 2.0 then
                curAction = k
                return
            end
        end
    end
    curAction = nil
    return
    Wait(100)
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

RegisterCommand("showBlipMining", function()
    showBlip = not showBlip
    refreshBlip()
end, false)