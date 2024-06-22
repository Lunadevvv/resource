local RequestData = {
    ["ambulance"] = {},
    -- ["mechanic"] = {},
    -- ["taxi"] = {}
}

local index = 0

AddEventHandler('playerDropped', function()
	for k,v in ipairs(RequestData["ambulance"]) do
		if v.id == source then
			table.remove(RequestData["ambulance"], k)
			TriggerClientEvent('request_menu:sync', -1)
			break
		end
	end
    -- for k,v in ipairs(RequestData["mechanic"]) do
	-- 	if v.id == source then
	-- 		table.remove(RequestData["mechanic"], k)
	-- 		TriggerClientEvent('request_menu:sync', -1)
	-- 		break
	-- 	end
	-- end
    -- for k,v in ipairs(RequestData["taxi"]) do
	-- 	if v.id == source then
	-- 		table.remove(RequestData["taxi"], k)
	-- 		TriggerClientEvent('request_menu:sync', -1)
	-- 		break
	-- 	end
	-- end
end)

RegisterServerEvent('request_menu:sendData')
AddEventHandler('request_menu:sendData', function(job, gps, note)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    
    if not RequestData[job] then
        RequestData[job] = {}
    end
    local isRequest = false
    for k, v in pairs(RequestData[job]) do
        if v.identifier == xPlayer.identifier then
            isRequest = true
        end
    end
    for i=1, #xPlayers, 1 do
        local sPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if sPlayer.job.name == 'ambulance' then
            TriggerClientEvent('esx:showNotification', xPlayers[i] ,'Có Người Ping Hỗ Trợ!', 3000, 'success')
            TriggerClientEvent('tiengkeu',xPlayers[i])
        end
    end
    if not isRequest then
        table.insert(RequestData[job], {identifier = xPlayer.identifier,id = xPlayer.source, job = job, time = os.time(), status = 0, gps = gps, note = note})
        TriggerClientEvent('request_menu:sync', -1)
    end
end)

ESX.RegisterServerCallback("request_menu:getData", function(source,cb, requestData)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cbData = {}
    local Request = RequestData[xPlayer.job.name]
    if Request ~= nil then
        for k, v in pairs(Request) do
            local Player = GetPlayerIdentifiers(v.identifier)
            local status = 0
            local receiver_name = "none"
            local player = "none"
            if Player then
                player = v.source
            end
            if v.status ~= 0 then
                local receiver = GetPlayerIdentifiers(v.status)
                if receiver then
                    status = v.statusid
                    receiver_name = GetPlayerName(status)
                end
            end
            table.insert(cbData, {id = k, source = v.id, ping_name = GetPlayerName(v.id), receiver_name = receiver_name, status = status, statusid = v.status, time = os.time() - v.time, gps = v.gps, note = v.note})
        end  
    end
    cb(cbData)
end)

RegisterServerEvent("request_menu:acceptRequest")
AddEventHandler("request_menu:acceptRequest", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    RequestData[xPlayer.job.name][id].status = xPlayer.identifier
    RequestData[xPlayer.job.name][id].statusid = xPlayer.source
    local sPlayer = ESX.GetPlayerFromId(RequestData[xPlayer.job.name][id].id)
    local Player = GetPlayerIdentifiers(RequestData[xPlayer.job.name][id].identifier)
    TriggerClientEvent('request_menu:sync', -1)
    if xPlayer.job.name == "ambulance" then
        TriggerClientEvent("pinggpsnhanh", RequestData[xPlayer.job.name][id].id, "#ff00ff", "<strong style='color:#ff00ff'>BÁC SĨ</strong>","<b style='color:#00ff80'>" .. xPlayer.getName().. "<b style='color:white'> đã nhận <b style='color:#ff0040'>" .. sPlayer.getName() .. "</b></b></b>")
        TriggerClientEvent("pinggpsnhanh", source, "#ff00ff", "<strong style='color:#ff00ff'>BÁC SĨ</strong>","<b style='color:#00ff80'>" .. xPlayer.getName().. "<b style='color:white'> đã nhận <b style='color:#ff0040'>" .. sPlayer.getName() .. "</b></b></b>")
    -- elseif xPlayer.job.name == "mechanic" then
    --     TriggerClientEvent("pinggpsnhanh", RequestData[xPlayer.job.name][id].id, "#00ffff", "<strong style='color:#00ffff'>CỨU HỘ</strong>","<b style='color:yellow'>" .. GetPlayerName(source).. "<b style='color:white'> đã nhận <b style='color:#bf00ff'>" .. GetPlayerName(RequestData[xPlayer.job.name][id].id) .. "</b></b></b>")
    --     TriggerClientEvent("pinggpsnhanh", source, "#00ffff", "<strong style='color:#00ffff'>CỨU HỘ</strong>","<b style='color:yellow'>" .. GetPlayerName(source).. "<b style='color:white'> đã nhận <b style='color:#bf00ff'>" .. GetPlayerName(RequestData[xPlayer.job.name][id].id) .. "</b></b></b>")
    -- elseif xPlayer.job.name == "taxi" then
    --     TriggerClientEvent("pinggpsnhanh", RequestData[xPlayer.job.name][id].id, "#00ffff", "<strong style='color:#00ffff'>CỨU HỘ</strong>","<b style='color:yellow'>" .. GetPlayerName(source).. "<b style='color:white'> đã nhận <b style='color:#bf00ff'>" .. GetPlayerName(RequestData[xPlayer.job.name][id].id) .. "</b></b></b>")
    --     TriggerClientEvent("pinggpsnhanh", source, "#00ffff", "<strong style='color:#00ffff'>TAXI</strong>","<b style='color:yellow'>" .. GetPlayerName(source).. "<b style='color:white'> đã nhận <b style='color:#bf00ff'>" .. GetPlayerName(RequestData[xPlayer.job.name][id].id) .. "</b></b></b>")
    
    end
end)

RegisterServerEvent('request_menu:removeRequest')
AddEventHandler('request_menu:removeRequest', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    table.remove(RequestData[xPlayer.job.name], id)
    TriggerClientEvent('request_menu:sync', -1)
end)

RegisterNetEvent('request_menu:removeReq', function(id)
    for k,v in ipairs(RequestData["ambulance"]) do
		if v.id == id then
			table.remove(RequestData["ambulance"], k)
			TriggerClientEvent('request_menu:sync', -1)
			break
		end
	end
end)

RegisterServerEvent('request_menu:cancelRequest')
AddEventHandler('request_menu:cancelRequest', function(id,job)
    RequestData[job][id].status = 0
    --TriggerClientEvent('esx:showNotification', RequestData[job][id].id,(job == "ambulance" and "Bác Sĩ" or "Cứu Hộ") ..' (' .. GetPlayerName(source) ..') đã hủy  !')
    TriggerClientEvent('request_menu:sync', -1)
end)

RegisterServerEvent('request_menu:cancelRequest_self')
AddEventHandler('request_menu:cancelRequest_self', function(id,job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    local id = nil
    for k, v in pairs(RequestData[job]) do
        if xPlayer.identifier == v.identifier then
            id = k
            break
        end
    end
    if id ~= nil then
        if RequestData[job][id].statusid ~= nil then
            TriggerClientEvent('DeleteWayPoint',RequestData[job][id].statusid)
        end

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                local msg = '[HỆ THỐNG]-^1HỦY Bác Sĩ: ^2' .. xPlayers.getName() .. ' ^3đã gửi hủy bác sĩ'
        
                TriggerClientEvent('chat:addMessage', xPlayers[i], {
                color = { 255, 0, 0},
                multiline = false,
                args = {msg}
                })
                TriggerClientEvent("pinggpsnhanh", xPlayers[i], "#ff00ff", "<strong style='color:#ff00ff'>HỦY BÁC SĨ</strong>","<b style='color:#00ff80'>" .. xPlayers.getName().. "<b style='color:white'> đã gửi hủy bác sĩ</b></b>")
            end
        end
        table.remove(RequestData[job], id)
        TriggerClientEvent('request_menu:sync', -1)
    end
end)

RegisterServerEvent('request_menu:cancelRequest_selfCH')
AddEventHandler('request_menu:cancelRequest_selfCH', function(id,job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    local id = nil
    for k, v in pairs(RequestData[job]) do
        if xPlayer.identifier == v.identifier then
            id = k
            break
        end
    end
    if id ~= nil then
        if RequestData[job][id].statusid ~= nil then
            TriggerClientEvent('DeleteWayPoint',RequestData[job][id].statusid)
        end

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                local msg = '^7[HỆ THỐNG]-^3HỦY CỨU HỘ: ^2' .. GetPlayerName(source) .. ' ^7đã gửi hủy cứu hộ'
                TriggerClientEvent('chat:addMessage', xPlayers[i], {
                color = { 255, 0, 0},
                multiline = false,
                args = {msg}
                })
                TriggerClientEvent("pinggpsnhanh", xPlayers[i], "#00ffff", "<strong style='color:#00ffff'>HỦY CỨU HỘ</strong>","<b style='color:yellow'>" .. xPlayers.getName().. "<b style='color:white'> đã gửi hủy cứu hộ</b></b>")
                
            end
        end
        table.remove(RequestData[job], id)
        TriggerClientEvent('request_menu:sync', -1)
    end
end)

-- RegisterServerEvent('request_menu:cancelRequest_selfTX')
-- AddEventHandler('request_menu:cancelRequest_selfTX', function(id,job)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local xPlayers = ESX.GetPlayers()

--     local id = nil
--     for k, v in pairs(RequestData[job]) do
--         if xPlayer.identifier == v.identifier then
--             id = k
--             break
--         end
--     end
--     if id ~= nil then
--         if RequestData[job][id].statusid ~= nil then
--             TriggerClientEvent('DeleteWayPoint',RequestData[job][id].statusid)
--         end

--         for i=1, #xPlayers, 1 do
--             local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
--             if xPlayer.job.name == 'taxi' then
--                 local msg = '^7[HỆ THỐNG]-^3HỦY TAXI: ^2' .. GetPlayerName(source) .. ' ^7đã gửi hủy taxi'
--                 TriggerClientEvent('chat:addMessage', xPlayers[i], {
--                 color = { 255, 0, 0},
--                 multiline = false,
--                 args = {msg}
--                 })
--                 TriggerClientEvent("pinggpsnhanh", xPlayers[i], "#00ffff", "<strong style='color:#00ffff'>HỦY TAXI</strong>","<b style='color:yellow'>" .. GetPlayerName(source).. "<b style='color:white'> đã gửi hủy taxi</b></b>")
                
--             end
--         end
--         table.remove(RequestData[job], id)
--         TriggerClientEvent('request_menu:sync', -1)
--     end
-- end)