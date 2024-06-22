Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["Enter"] = 191
};
display = false;
isLoadEconomy = false;
ConfigNotLoad = false;
local currentType = "none";
local NPCList = {}

function loadScriptsClient()
    ESX.TriggerServerCallback("syntax_economy:callback:getCallback", function(economy)
        Config.Items = economy
        isLoadEconomy = true;
    end)

    RegisterNetEvent(GetCurrentResourceName()..":client:updateEconomy")
    AddEventHandler(GetCurrentResourceName()..":client:updateEconomy", function(update, key)
        Config.Items[key] = update;

        if display then
            if currentType == "sell" then
                local dataItems = checkInventory(key)
                SendNUIMessage({
                    action      = "updateItems",
                    itemData    = {
                        label = dataItems.label,
                        name = key,
                        price = update.price,
                        max = update.randomPrice[#update.randomPrice],
                        min = update.randomPrice[1],
                        count = update.count,
                    };
                })
            else
                showItemsCheck();
            end
        end
    end)

    checkEconomy = function()
        if isLoadEconomy then
            showItemsCheck();
            showDisplay(true, "check");
        end
    end

    if Config.CheckKeyWithCommand then
        RegisterCommand("economy", function(source, args, raw)
            checkEconomy()
        end, false)
        RegisterKeyMapping("economy", "Economy Check List", "keyboard", Config.EconomyKeys)
    end

    Citizen.CreateThread(function()	
        while true do
            local isDistance = false
            local playerPed = PlayerPedId()
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(playerPed)

            for k, v in pairs(Config.Zones) do
                if GetDistanceBetweenCoords(coords, v.coords, true) < 5.0 and isLoadEconomy then
                    isDistance = true
                    DisableControlAction(0, Keys["G"], true)
                end
            end

            if not IsPedInAnyVehicle(GetPlayerPed(-1)) and isLoadEconomy then
                for k, v in pairs(Config.Zones) do
                    if GetDistanceBetweenCoords(coords, v.coords, true) < 2 and not display then
                        ESX.TextUI(Config.Text, "info")
                        if IsControlJustReleased(0, 38) and not display then
                            setItems(v.items);
                            showDisplay(true, "sell");
                        end
                    elseif GetDistanceBetweenCoords(coords, v.coords, true) > 3.0 and GetDistanceBetweenCoords(coords, v.coords, true) < 10.0 and currentType == "sell" then
                        showDisplay(false);
                    else 
                        ESX.HideUI()
                    end
                end
            end

            if Config.CheckKeysWithLoop then
                if IsControlJustReleased(0, Config.KeyLoops) and not display then
                    checkEconomy()
                end
            end

            if isDistance then
                Wait(7)
            else
                Wait(1000)
            end
        end
    end)
 
    Citizen.CreateThread(function()
        for k,zone in pairs(Config.Zones) do
            if zone.Blips then
                CreateBlipCircle(zone.coords, zone.Blips.name, zone.Blips.radius, zone.Blips.color, zone.Blips.sprite, zone.Blips.scale)
                -- SetBlipColour (blip, 0.40)
            end
        end
        -- while true do
        --     local isDistance = false
        --     local playerPed = PlayerPedId()
        --     local coords = GetEntityCoords(playerPed)

            -- for k, v in pairs(Config.Zones) do
            --     if v.Marker and not display and isLoadEconomy then
            --         if GetDistanceBetweenCoords(coords, v.coords, true) < (v.Marker.Distance or Config.DrawDistance) then
            --             isDistance = true
            --             -- DrawMarker(v.Marker.type, v.coords + vector3(0.0, 0.0, v.Marker.up or 0.0), v.Marker.dirX, v.Marker.dirY, v.Marker.dirZ, v.Marker.rotX, v.Marker.rotY, v.Marker.rotZ, v.Marker.scaleX, v.Marker.scaleY, v.Marker.scaleZ, v.Marker.red, v.Marker.green, v.Marker.blue, v.Marker.alpha, v.Marker.bobUpAndDown, v.Marker.faceCamera, v.Marker.p19, v.Marker.rotate, v.Marker.textureDict, v.Marker.textureName, v.Marker.drawOnEnts)
            --         end
            --     end
            -- end

        --     if isDistance then
        --         Wait(7)
        --     else
        --         Wait(1000)
        --     end
        -- end
    end)

    -- Create NPC
    Citizen.CreateThread(function()
        for k,v in pairs(Config.Zones) do
            if v.NPC then
                local x,y,z = table.unpack(v.coords)
                RequestModel(GetHashKey(v.NPC.Model))
                while not HasModelLoaded(GetHashKey(v.NPC.Model)) do
                    Wait(1)
                end
                playerPed = CreatePed(4, v.NPC.Model, x, y, z - 1.0, v.NPC.heading, false, true)
                FreezeEntityPosition(playerPed, true)
                SetEntityInvincible(playerPed, true)
                SetBlockingOfNonTemporaryEvents(playerPed, true)

                -- Play Animation
                if v.NPC.Animation then
                    if v.NPC.Animation.Scenario then
                        TaskStartScenarioInPlace(playerPed, v.NPC.Animation.AnimationScene, 0, false)
                    else
                        RequestAnimDict(v.NPC.Animation.AnimationDirect)
                        while (not HasAnimDictLoaded(v.NPC.Animation.AnimationDirect)) do Citizen.Wait(0) end
                        Wait(100)
                        TaskPlayAnim(playerPed, v.NPC.Animation.AnimationDirect, v.NPC.Animation.AnimationScene, 20.0, -20.0, -1, 1, 0, false, false, false)						
                    end
                end

                if v.NPC.Skins then
                    SetPedHeadBlendData			(playerPed, v.NPC.Skins['face'], v.NPC.Skins['face'], v.NPC.Skins['face'], v.NPC.Skins['skin'], v.NPC.Skins['skin'], v.NPC.Skins['skin'], 1.0, 1.0, 1.0, true)
                    SetPedHairColor				(playerPed,			v.NPC.Skins['hair_color_1'],		v.NPC.Skins['hair_color_2'])				-- Hair Color
                    SetPedComponentVariation	(playerPed, 2,		v.NPC.Skins['hair_1'],			v.NPC.Skins['hair_2'], 2)						-- Hair
                    SetPedComponentVariation	(playerPed, 8,		v.NPC.Skins['tshirt_1'],			v.NPC.Skins['tshirt_2'], 2)					-- Tshirt
                    SetPedComponentVariation	(playerPed, 11,		v.NPC.Skins['torso_1'],			v.NPC.Skins['torso_2'], 2)					-- torso parts
                    SetPedComponentVariation	(playerPed, 3,		v.NPC.Skins['arms'],				v.NPC.Skins['arms_2'], 2)						-- Amrs
                    SetPedComponentVariation	(playerPed, 4,		v.NPC.Skins['pants_1'],			v.NPC.Skins['pants_2'], 2)					-- pants
                    SetPedComponentVariation	(playerPed, 6,		v.NPC.Skins['shoes_1'],			v.NPC.Skins['shoes_2'], 2)					-- shoes
                    SetPedHeadOverlay			(playerPed, 1,		v.NPC.Skins['beard_1'],			(v.NPC.Skins['beard_2'] / 10) + 0.0)			-- Beard + opacity
                    SetPedHeadOverlayColor		(playerPed, 1, 1,	v.NPC.Skins['beard_3'],			v.NPC.Skins['beard_4'])						-- Beard Color
                end

                table.insert(NPCList, playerPed)
            end
        end
    end)

    AddEventHandler("onResourceStop", function(res)
        if res == GetCurrentResourceName() then
            for k,v in pairs(NPCList) do
                DeletePed(v)
            end
        end
    end)

    setItems = function(list)
        local itemList = {}
        for k,v in pairs(Config.Items) do
            local dataItems = checkInventory(k)
            if k == ecoitem then
                sell = 1
            else 
                sell = 0
            end
            if dataItems ~= nil and checkList(list, k) then
                table.insert(itemList, {
                    label = dataItems.label,
                    name = k,
                    price = v.price,
                    max = v.randomPrice[#v.randomPrice],
                    min = v.randomPrice[1],
                    count = dataItems.count,
                })
            end
        end

        SendNUIMessage({
            action = "setItems",
            items = itemList
        })
    end

    showItemsCheck = function()
        local itemList = {}
        for k,v in pairs(Config.Items) do
            -- local dataItems = checkInventory(k)

            -- if dataItems ~= nil then
                table.insert(itemList, {
                    label = v.name,
                    name = k,
                    price = v.price,
                    max = v.randomPrice[#v.randomPrice],
                    min = v.randomPrice[1],
                    count = v.count,
                })
            -- end
        end

        SendNUIMessage({
            action = "setCheckItems",
            items = itemList
        })
    end

    checkList = function(list, key)
        for k,v in pairs(list) do
            if v == key then
                return true;
            end
        end
        
        return false;
    end

    checkInventory = function(itemName)
        for k,v in pairs(ESX.GetPlayerData().inventory) do
            if v.name == itemName then
                return v;
            end
        end

        return nil
    end

    showDisplay = function(bool, type)
        display = bool
        currentType = type or "none",
        SetNuiFocus(bool, bool)
        if bool then
            SendNUIMessage({
                action = "display",
                type = type
            })
        else
            SendNUIMessage({
                action = "hide",
            })
        end
    end

    RegisterNUICallback("FOCUSOFF", function(data, cb)
        showDisplay(false);
    end)

    RegisterNUICallback("sellItems", function(data, cb)
        local dataItems = checkInventory(data.itmData.name)

        if dataItems ~= nil and dataItems.count > 0 then
            TriggerServerEvent(GetCurrentResourceName()..':server:sellItems', data.itmData.name, data.count)
        else
            NotifyCL((Config['Translate']['NoHaveItems']):format(data.itmData.label))
        end
    end)

    RegisterNUICallback("sellAllItems", function(data, cb)
        local dataItems = checkInventory(data.itmData.name)

        if dataItems ~= nil and dataItems.count > 0 then
            TriggerServerEvent(GetCurrentResourceName()..':server:sellItems', data.itmData.name, dataItems.count)
        else
            NotifyCL((Config['Translate']['NoHaveItems']):format(data.itmData.label))
        end
    end)

    function CreateBlipCircle(coords, text, radius, color, sprite)
        local blip 

        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, 1)
        SetBlipAlpha (blip, 128)

        blip = AddBlipForCoord(coords)

        SetBlipHighDetail(blip, true)
        SetBlipSprite (blip, sprite)
        SetBlipScale  (blip, 0.70)
        SetBlipColour (blip, color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blip)
    end

    RegisterFontFile('sarabun') -- the name of your .gfx, without .gfx
    fontId = RegisterFontId('sarabun') -- the name from the .xml
    function DrawText3D(coords, textInput)
        local x,y,z = table.unpack(coords)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
        if onScreen then
            SetTextScale(0.45, 0.45)
            SetTextFont(fontId)
            SetTextProportional(1)
            SetTextEntry("STRING")
            SetTextCentre(1)
            SetTextColour(255, 255, 255, 215)
        
            AddTextComponentString(textInput)
            DrawText(_x, _y)
        
            -- local factor = (string.len(textInput)) / 230
            -- DrawRect(_x, _y + 0.0270, factor, 0.045, 0, 0, 0, 100)
        end
    end
end

Citizen.CreateThread(function()

    PlayerData = ESX.GetPlayerData()
    _Config = Config
    while not ConfigNotLoad do
        _Config['Webhooks'] = nil
        SendNUIMessage({
            action = "setConfig",
            Config  = _Config,
        })
        Wait(800)
    end
    loadScriptsClient()
end)

RegisterNUICallback("stopNUI", function(data, cb)
    ConfigNotLoad = true
end)