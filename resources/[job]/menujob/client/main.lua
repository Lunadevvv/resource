local RequestData = {}
local isRequestMenuOpen = false
local JobName = nil

Citizen.CreateThread(function()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    JobName = ESX.GetPlayerData().job.name
end)

RegisterNetEvent("tiengkeu")
AddEventHandler("tiengkeu", function()
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	JobName = xPlayer.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	JobName = job.name
end)

RegisterCommand('openMenujob', function()
    if JobName == "ambulance" or JobName == "mechanic" then
        OpenMenu()
        InitData()
    end
end)

RegisterKeyMapping('openMenujob', 'Mở menu ngành', 'keyboard', 'F5')

RegisterNetEvent("request_menu:sync")
AddEventHandler("request_menu:sync", function()
    if isRequestMenuOpen then 
        InitData()
    end
end)

RegisterNUICallback('request:accept', function(data, cb)
    local id = data.id:gsub("%s", "")
    id = tonumber(id)
    for k, v in ipairs(RequestData) do 
        if v.id == id then 
            SetNewWaypoint(v.gps.x, v.gps.y)
            TriggerServerEvent("request_menu:acceptRequest",id,GetPlayerName(GetPlayerFromServerId(v.source)),v.source)
        end
    end
end)


RegisterNUICallback('request:getPos', function(data, cb)
    local id = data.id:gsub("%s", "")
    id = tonumber(id)
    for k, v in ipairs(RequestData) do 
        if v.id == id then 
            SetNewWaypoint(v.gps.x, v.gps.y)
        end
    end
end)

RegisterNUICallback('request:remove', function(data, cb)
    local id = data.id
    DeleteWaypoint()
    TriggerServerEvent('request_menu:removeRequest', tonumber(id))
end)

RegisterNUICallback('request:cancel', function(data, cb)
    local id = data.id
    DeleteWaypoint()
    TriggerServerEvent('request_menu:cancelRequest', tonumber(id), JobName)
end)

RegisterCommand("huych",function()
    TriggerServerEvent('request_menu:cancelRequest_selfCH', GetPlayerServerId(PlayerId()) , "mechanic")
end)

RegisterCommand("huybs",function()
    TriggerServerEvent('request_menu:cancelRequest_self', GetPlayerServerId(PlayerId()) , "ambulance")
end)
local lastdead = nil
local lastdead2 = nil

RegisterCommand("pingbs",function()
    if lastdead and lastdead > GetGameTimer() then
		ESX.ShowNotification('Bạn đã ping bác sĩ gần đây, vui lòng chờ ' .. ESX.Math.Round((lastdead - GetGameTimer()) / 1000) .. ' giây nữa để ping lại','error', 3000)
		return
	end
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    if IsPedDeadOrDying(playerPed) then
        ESX.ShowNotification('GPS đã gửi cho Bác sĩ', 'success', 3000)
        
        TriggerServerEvent("request_menu:sendData", 'ambulance', PedPosition, 'Cứu người')
        lastdead = tonumber(GetGameTimer()) + (3 * 60 * 1000)
    else
        ESX.ShowNotification("Bạn chưa chết",'error', 3000)
    end
end)

RegisterCommand("pingch",function()
    if lastdead2 and lastdead2 > GetGameTimer() then
		ESX.ShowNotification('Bạn đã ping cứu hộ gần đây, vui lòng chờ ' .. ESX.Math.Round((lastdead2 - GetGameTimer()) / 1000) .. ' giây nữa để ping lại','error', 3000)
		return
	end
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	ESX.ShowNotification('GPS đã gửi cho Cứu Hộ', 'success', 3000)
	
    TriggerServerEvent("request_menu:sendData", 'ambulance', PedPosition, 'Sửa xe')
	lastdead2 = tonumber(GetGameTimer()) + (3 * 60 * 1000)
end)

RegisterNetEvent('pingbs', function()
    if lastdead and lastdead > GetGameTimer() then
		ESX.ShowNotification('Bạn đã ping bác sĩ gần đây, vui lòng chờ ' .. ESX.Math.Round((lastdead - GetGameTimer()) / 1000) .. ' giây nữa để ping lại','error', 3000)
		return
	end
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    if IsPedDeadOrDying(playerPed) then
        ESX.ShowNotification('GPS đã gửi cho Bác sĩ','success', 3000)
        
        TriggerServerEvent("request_menu:sendData", 'ambulance', PedPosition, 'Cứu người')
        lastdead = tonumber(GetGameTimer()) + (3 * 60 * 1000)
    else
        ESX.ShowNotification("Bạn chưa chết", 'error', 3000)
    end
end)

RegisterNetEvent('pingch', function()
    if lastdead2 and lastdead2 > GetGameTimer() then
		ESX.ShowNotification('Bạn đã ping cứu hộ gần đây, vui lòng chờ ' .. ESX.Math.Round((lastdead - GetGameTimer()) / 1000) .. ' giây nữa để ping lại','error', 3000)
		return
	end
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	ESX.ShowNotification('GPS đã gửi cho Cứu Hộ','success', 3000)
	
    TriggerServerEvent("request_menu:sendData", 'ambulance', PedPosition, 'Sửa xe')
	lastdead2 = tonumber(GetGameTimer()) + (3 * 60 * 1000)
end)

RegisterNetEvent("DeleteWayPoint")
AddEventHandler("DeleteWayPoint",function()
    DeleteWaypoint()
end)

OpenMenu = function()
    if not isUIOpen then 
        isUIOpen = true 
        isRequestMenuOpen = true
        TriggerScreenblurFadeIn(1000)
        SetNuiFocus(true, true)
        SendNUIMessage({
            name = 'request_menu',
            event = 'toggle',
            open = true
        })
    end
end

RegisterNUICallback('closeNUI', function()
	SetNuiFocus(false, false)
    isUIOpen = false
    isRequestMenuOpen = false
	SendNUIMessage({
        name = 'request_menu',
        event = 'toggle',
        open = false
    })
    TransitionFromBlurred(1000)
end)

InitData = function()
    ESX.TriggerServerCallback("request_menu:getData", function(data,source)
        local requestData = {}
        for k,v in ipairs(data) do
            if v.source ~= "none" then
                local pedCoords = GetEntityCoords(PlayerPedId())
                -- local target1 = GetPlayerFromServerId(v.source)
                -- local targetCoords = GetEntityCoords(GetPlayerPed(target1))
                local distance = GetDistanceBetweenCoords(pedCoords, v.gps, true)
                local status = 0
                if v.status ~= 0 then 
                    status = v.receiver_name
                end
                local isAccept = 0
                if v.status == GetPlayerServerId(PlayerId()) then 
                    isAccept = 1 
                end
                table.insert(requestData, {id = v.id,gps = v.gps, name =  v.ping_name, distance = math.floor(distance).." m", status = status , time = v.time.." giây trước", source = v.source, isAccept = isAccept, note = v.note})
            end
        end
        RequestData = requestData
        SendNUIMessage({
            name = "request_menu",
            event = "init",
            initData = requestData,
            hidden = JobName == "ambulance" and true or false
        })
    end)
end

RegisterCommand("lagmenujob",function(a,b,c) SetNuiFocus(false,false) end, false)