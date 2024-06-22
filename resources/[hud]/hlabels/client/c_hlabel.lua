                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --[[
---------------------------------------------------
HEAD LABELS (C_HLABELS.LUA) by MrDaGree | Edited by Jack
---------------------------------------------------
Last revision: APR 15 2019
---------------------------------------------------
NOTES 
	
---------------------------------------------------
	
]]

local playerNamesDist = 25
local displayIDHeight = 1 
local displayIDHeight1 = 0.35
local connectedPlayers = nil
local PlayerLoaded = false
local insert = false
local PlayerData = {}
local index = 1

local Polices = nil
local isBusy = false
Citizen.CreateThread(function()
    Wait(1000)
    ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(check)
        connectedPlayers = check
    end)
    
    PlayerData = ESX.GetPlayerData()
    NetworkSetTalkerProximity(25.0)
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers1)
    connectedPlayers = connectedPlayers1
    isBusy = false
end)

function DisplayText(x, y, text, scale)
	SetTextScale(scale or 0.3, scale or 0.3)
	SetTextFont(ESX.FontId)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextOutline()
	AddTextComponentString(text)
	DrawText(x,y)
end




--[[ Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local status
        if NetworkIsPlayerTalking(PlayerId()) then
            status = '~g~Active'
        else
            status = '~y~None'
        end
        DisplayText(0.2, 0.96, "Voice: " .. status)
    end
end) ]]

local function DrawText3D(x, y, z, name)
    local camCoords = GetGameplayCamCoord()
    local coords = vector3(x, y, z)
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = (4.00001 / dist) * 0.3
	if scale > 0.2 then
		scale = 0.2
	elseif scale < 0.15 then
		scale = 0.15
    end
    local fov = (1 / GetGameplayCamFov()) * 75
	local scale = scale * fov

    -- Format the text
    SetTextColour(255,255,255, 255)
    SetTextScale(scale, scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(name)
    SetTextOutline()
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function DrawText3D2(x, y, z, name)
    local camCoords = GetGameplayCamCoord()
    local coords = vector3(x, y, z)
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = (4.00001 / dist) * 0.3
	if scale > 0.2 then
		scale = 0.2
	elseif scale < 0.15 then
		scale = 0.15
    end
    local fov = (1 / GetGameplayCamFov()) * 75
	local scale = scale * fov

    -- Format the text
    SetTextColour(245, 16, 0, 255)
    SetTextScale(scale, scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(name)
    SetTextOutline()
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    PlayerLoaded = true
    ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(check)
        connectedPlayers = check
    end) 
end)

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(25.0)
end)


local AdminLook = false
RegisterCommand('admhlabels', function()
    AdminLook = not AdminLook
end)

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        local myped = GetPlayerPed(-1)
        local sleep = 1000
        local CoordsMyPed = GetEntityCoords(myped)
        for k, id in ipairs(GetActivePlayers()) do
            local ped  = GetPlayerPed( id) 
            if ped ~= myped then
                local CoordsIdPed = GetEntityCoords(ped, false)
                local distance = #(CoordsMyPed - CoordsIdPed)
                if distance < 20 and not isBusy then
                    if HasEntityClearLosToEntity(PlayerPedId(), ped, 17) then 
                    -- if HasEntityClearLosToEntityInFront(PlayerPedId(), ped) then
                        local serverId = tonumber(GetPlayerServerId(id))
                        if connectedPlayers ~= nil and connectedPlayers[serverId] ~= nil then
                            sleep = 0
                            local Marker = nil
                            local ids = tostring(connectedPlayers[serverId].id)
                            local JobName = connectedPlayers[serverId].job
                            local wanted = 0
                            local nameplayer = "[~y~"..ids.."~w~] " .. connectedPlayers[serverId].name

                            if connectedPlayers[serverId].saotruyna == 1 then
                                wanted = "⭐"
                            elseif connectedPlayers[serverId].saotruyna == 2 then
                                wanted = "⭐⭐"
                            elseif connectedPlayers[serverId].saotruyna == 3 then
                                wanted = "⭐⭐⭐"
                            elseif connectedPlayers[serverId].saotruyna == 4 then
                                wanted = "⭐⭐⭐⭐"
                            elseif connectedPlayers[serverId].saotruyna == 5 then
                                wanted = "⭐⭐⭐⭐⭐"
                            end
                             -- Show Wanted
                            -- if connectedPlayers[serverId].wanted then
                            --     nameplayer = '~r~❗ ' .. nameplayer .. ' ❗~s~'
                            -- end
                            
                              -- Show Talking
                            if NetworkIsPlayerTalking(id) then    
                                nameplayer = "[~y~"..idcard.."~w~] " .. connectedPlayers[serverId].name .. ' 🔈'
                            end  

                            if JobName == 'mechanic' then  
                                nameplayer = ' ~g~[~y~CH~g~]~s~ '       .. nameplayer 
                            elseif JobName == 'police' then
                                nameplayer = ' ~g~[~b~CA~g~]~s~ '      .. nameplayer  
                            elseif JobName == 'ambulance' then
                                nameplayer = ' ~g~[~r~BS~g~]~s~ '      .. nameplayer  
                            elseif JobName == 'doxe' then
                                nameplayer = ' ~g~[~r~DX~g~]~s~ '      .. nameplayer  
                            elseif JobName == 'Admin' then
                                nameplayer = ' ~r~[ADMIN]~s~ ' .. nameplayer
                            elseif JobName ~= 'unemployed' and JobName ~= 'offambulance' and JobName ~= 'offmechanic' and JobName ~= 'offpolice' then
                                nameplayer = ' ~g~[~p~' .. JobName .. '~g~]~s~ ' .. nameplayer
                            end
                            
                            DrawText3D(CoordsIdPed.x, CoordsIdPed.y, CoordsIdPed.z + displayIDHeight, nameplayer)   
                            if wanted ~= 0 then
                                DrawText3D(CoordsIdPed.x, CoordsIdPed.y, CoordsIdPed.z + 1.1, wanted) 
                            end
                        elseif connectedPlayers[serverId] == nil then 
                            isBusy = true
                            TriggerServerEvent("esx_scoreboard:server:requestPlayer")
                            Wait(5000)
                        end
                        --DrawText3D(CoordsIdPed.x, CoordsIdPed.y, CoordsIdPed.z + displayIDHeight, GetPlayerName(id))     
                    end
                end  
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    -- if resource == 'esx_scoreboard' then
    --     TriggerServerEvent('esx_scoreboard:updateConnected')
    -- end
    if resource == 'hlabels' then
        TriggerServerEvent('esx_scoreboard:updateConnected')
    end
end)
