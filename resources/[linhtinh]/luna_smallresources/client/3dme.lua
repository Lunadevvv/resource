Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me', 'Để nói chuyện mà admin không check đc.')
end)
local pedDisplaying = {}
local nbrDisplaying = 1
local mesending = false

RegisterCommand('me', function(source, args, raw)
    local text = '*'
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' *'
    TriggerServerEvent('3dme:shareDisplay', text)
end)

-- ## Functions

local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    local c = Config.visual.color
    SetTextColour(c.r, c.g, c.b, c.a)
    SetTextScale(0.0, Config.visual.scale * scale)
    SetTextFont(Config.visual.font)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

-- OBJ : handle the drawing of text above a ped head
-- PARAMETERS :
--      - coords : world coordinates to where you want to draw the text
--      - text : the text to display
local function Display(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= Config.visual.dist then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        -- Timer
        local display = true

        Citizen.CreateThread(function()
            Wait(Config.visual.time)
            display = false
        end)

        -- Display
        local offset = 0.8 + pedDisplaying[ped] * -0.2
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

-- ## Events

-- Share the display of 3D text
RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text)
    end
end)

-- local LANGUAGE = Config.language
-- TriggerEvent('chat:addSuggestion', '/' .. Languages[LANGUAGE].commandName, Languages[LANGUAGE].commandDescription, Languages[LANGUAGE].commandSuggestion)

--     Citizen.CreateThread(function()
--         Wait(10000)
--         displaying = false
--     end)
    
--     Citizen.CreateThread(function()
--         nbrDisplaying = nbrDisplaying + 1
--         if mePlayer ~= -1 then
--             while displaying do
--                 Wait(0)
--                 local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
--                 local coords = GetEntityCoords(PlayerPedId(), false)
--                 local dist = Vdist2(coordsMe, coords)
--                 if dist < 300 then
--                      DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset-1.250, text)
--                 end
--             end
--         end
--         nbrDisplaying = nbrDisplaying - 1
--     end)
-- end