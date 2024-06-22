local bpStandartTasks = {}
local bpPremiumTasks = {}
local bpRewards = {}

Citizen.CreateThread(function()
    for k, v in pairs(AK4Y.BattlePassTasks) do 
        bpStandartTasks[k] = {}
        bpStandartTasks[k].taskId = v.taskId
        bpStandartTasks[k].taken = false
        bpStandartTasks[k].hasCount = 0
        bpStandartTasks[k].requiredCount = v.requiredcount
        bpStandartTasks[k].rewardEXP = v.rewardXP
    end

    for k, v in pairs(AK4Y.DailyPremiumTasks) do 
        bpPremiumTasks[k] = {}
        bpPremiumTasks[k].taskId = v.taskId
        bpPremiumTasks[k].taken = false
        bpPremiumTasks[k].hasCount = 0
        bpPremiumTasks[k].requiredCount = v.requiredcount
        bpPremiumTasks[k].rewardEXP = v.rewardXP
    end

    for k, v in pairs(AK4Y.BattlePassItems) do 
        bpRewards[k] = {}
        bpRewards[k].taskId = v.taskId
        bpRewards[k].requiredLevel = v.requiredLevel
        bpRewards[k].rewards = {}
        bpRewards[k].rewards.standart = {}
        bpRewards[k].rewards.standart.itemName = v.rewards.standart.itemName
        bpRewards[k].rewards.standart.itemCount = v.rewards.standart.count
        bpRewards[k].rewards.standart.type = v.rewards.standart.type
        bpRewards[k].rewards.standart.taken = false
        bpRewards[k].rewards.premium = {}
        bpRewards[k].rewards.premium.itemName = v.rewards.premium.itemName
        bpRewards[k].rewards.premium.itemCount = v.rewards.premium.count
        bpRewards[k].rewards.premium.type = v.rewards.premium.type
        bpRewards[k].rewards.premium.taken = false
    end

    local nowDate = os.time()
    local resetDate = os.time(AK4Y.BPEndDate)
    local difference = os.difftime(resetDate, nowDate) / (24*60*60)
    local reelDate = math.floor(difference)
    if reelDate <= 0 then 
        print("^5[ak4y-battlePass] ^2Battlepass GENERALLY ^1Reset^0")
    else
        print("^5[ak4y-battlePass] ^2Battlepass GENERALLY will be reset after ^9"..reelDate.."^2 days^0")
    end

    Citizen.Wait(3000)
    ExecuteSql("UPDATE ak4y_battlepass SET standartTasks = '"..json.encode(bpStandartTasks).."', standartResetTime = (CURDATE() + INTERVAL "..AK4Y.DailyTasksResetPeriod.." DAY) WHERE standartResetTime <= CURDATE()")
end)

ESX.RegisterServerCallback('ak4y-battlePass:getPlayerDetails', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local charInfo = xPlayer.name
    local nowDate = os.time()
    local resetDate = os.time(AK4Y.BPEndDate)
    local difference = os.difftime(resetDate, nowDate) / (24*60*60)
    local reelDate = math.floor(difference)
    local callbackData = {}
    local result = ExecuteSql("SELECT * FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] == nil then 
        ExecuteSql("INSERT INTO ak4y_battlepass (citizenid, currentXP, standartTasks, premiumTasks, rewards, standartResetTime) VALUES ('"..citizenId.."', 0, '"..json.encode(bpStandartTasks).."', '"..json.encode(bpPremiumTasks).."', '"..json.encode(bpRewards).."', (CURDATE() + INTERVAL "..AK4Y.DailyTasksResetPeriod.." DAY))")
        callbackData = {
            playerData = {
                ["currentXP"] = 0,
                ["standartTasks"] = json.encode(bpStandartTasks),
                ["premiumTasks"] = json.encode(bpPremiumTasks),
                ["rewards"] = json.encode(bpRewards),
                ["premium"] = false,
            },
            resetDate = reelDate,
            charInfo = charInfo,
        }
    else
        callbackData = {playerData = result[1], resetDate = reelDate, charInfo = charInfo}
    end
    cb(callbackData)
end)

ESX.RegisterServerCallback('ak4y-battlePass:getStandartRewards', function(source, cb, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local currentRew = data.itemDetails
    local callbackData = {}
    local result = ExecuteSql("SELECT currentXP, rewards FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local dbXP = result[1].currentXP
        local currentLevel = 0
        local neededEXP = AK4Y.RequiredXpForNextLevel
        if (dbXP >= neededEXP) then
            currentLevel = currentLevel + math.floor(dbXP / neededEXP);
        end
        local taskResult = json.decode(result[1].rewards)
        for k, v in pairs(taskResult) do 
            if v.taskId == tonumber(data.reqTaskId) then 
                local rewItem = v.rewards.standart.itemName
                local rewCount = tonumber(v.rewards.standart.itemCount)
                local rewTaken = v.rewards.standart.taken
                local rewType = v.rewards.standart.type
                local rewReqLv = tonumber(v.requiredLevel)
                local taken = false
                if currentLevel >= rewReqLv then
                    if not rewTaken then 
                        if rewType == "money" then 
                            taken = true
                            xPlayer.addAccountMoney('money', rewCount)
                            cb(true)
                        elseif rewType == "weapon" then
                            taken = true
                            xPlayer.addWeapon(rewItem, 1)
                            cb(true)
                        elseif rewType == "item" then
                            local itemUnique = false
                                for k, v in pairs(AK4Y.BattlePassItems) do 
                                    if rewTaskId == v.taskId then 
                                        if v.rewards.standart.unique then
                                            itemUnique = true
                                            for i = 1, v.rewards.standart.count, 1 do 
                                                xPlayer.addInventoryItem(rewItem, 1)
                                            end
                                            cb(true)
                                        end
                                        break
                                    end
                                end
                                if not itemUnique then 
                                    if xPlayer.addInventoryItem(rewItem, rewCount) then
                                        taken = true
                                        cb(true)
                                    else
                                        print("[ak4y-battlepass:DEBUG] ITEM NOT EXIST")
                                        cb(false)
                                    end
                                end
                        elseif rewType == "vehicle" then 
                            local plate = GeneratePlate()
                            TriggerClientEvent('esx_vehicleshop:addvehicle', _source, rewItem)
                            taken = true
                            cb(true)
                        else
                            print("TYPE NOT FOUND!")
                            cb(false)
                        end
                        if taken then 
                            v.rewards.standart.taken = true
                            ExecuteSql("UPDATE ak4y_battlepass SET rewards = '"..json.encode(taskResult).."' WHERE citizenid = '"..citizenId.."'")
                        end
                    else
                        print("[ak4y-battlepass:DEBUG] ITEM WAS TAKEN")
                    end
                else
                    print("LEVEL PROBLEM")
                    cb(false)
                end
                break
            end
        end
    end
end)


ESX.RegisterServerCallback('ak4y-battlePass:getPremiumRewards', function(source, cb, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local currentRew = data.itemDetails
    local callbackData = {}
    local result = ExecuteSql("SELECT currentXP, rewards FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local dbXP = result[1].currentXP
        local currentLevel = 0
        local neededEXP = AK4Y.RequiredXpForNextLevel
        if (dbXP >= neededEXP) then
            currentLevel = currentLevel + math.floor(dbXP / neededEXP);
        end
        local taskResult = json.decode(result[1].rewards)
        for k, v in pairs(taskResult) do 
            if v.taskId == tonumber(data.reqTaskId) then 
                local rewItem = v.rewards.premium.itemName
                local rewCount = tonumber(v.rewards.premium.itemCount)
                local rewTaken = v.rewards.premium.taken
                local rewType = v.rewards.premium.type
                local rewReqLv = tonumber(v.requiredLevel)
                local taken = false
                if currentLevel >= rewReqLv then
                    if not rewTaken then 
                        if rewType == "money" then 
                            taken = true
                            xPlayer.addAccountMoney('money', rewCount)
                            cb(true)
                        elseif rewType == "weapon" then
                            taken = true
                            xPlayer.addWeapon(rewItem, 1)
                            cb(true)
                        elseif rewType == "item" then
                            local itemUnique = false
                            for k, v in pairs(AK4Y.BattlePassItems) do 
                                if rewTaskId == v.taskId then 
                                    if v.rewards.premium.unique then
                                        itemUnique = true
                                        for i = 1, v.rewards.premium.count, 1 do 
                                            xPlayer.addInventoryItem(rewItem, 1)
                                        end
                                        cb(true)
                                    end
                                    break
                                end
                            end
                            if not itemUnique then 
                                if xPlayer.addInventoryItem(rewItem, rewCount) then
                                    taken = true
                                    cb(true)
                                else
                                    print("[ak4y-battlepass:DEBUG] ITEM NOT EXIST")
                                    cb(false)
                                end
                            end
                        elseif rewType == "vehicle" then 
                            local plate = GeneratePlate()
                            TriggerClientEvent('esx_vehicleshop:addvehicle', _source, rewItem)
                            taken = true
                            cb(true)
                        else
                            print("TYPE NOT FOUND!")
                            cb(false)
                        end
                        if taken then 
                            v.rewards.premium.taken = true
                            ExecuteSql("UPDATE ak4y_battlepass SET rewards = '"..json.encode(taskResult).."' WHERE citizenid = '"..citizenId.."'")
                        end
                    else
                        print("[ak4y-battlepass:DEBUG] ITEM WAS TAKEN")
                    end
                else
                    print("LEVEL PROBLEM")
                    cb(false)
                end
                break
            end
        end
    end
end)

ESX.RegisterServerCallback('ak4y-battlePass:standartTaskDone', function(source, cb, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local currentTaskId = tonumber(data.taskId)
    local result = ExecuteSql("SELECT standartTasks FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local tasks = json.decode(result[1].standartTasks)
        for k, v in pairs(tasks) do 
            if currentTaskId == v.taskId then 
                if v.hasCount >= v.requiredCount and not v.taken then 
                    v.taken = true
                    local addEXP = v.rewardEXP
                    ExecuteSql("UPDATE ak4y_battlepass SET standartTasks = '"..json.encode(tasks).."', currentXP = currentXP + '"..addEXP.."' WHERE citizenid = '"..citizenId.."'")
                    cb(addEXP)
                end
                break
            else
                cb(false)
            end
        end
    end
end)

ESX.RegisterServerCallback('ak4y-battlePass:premiumTaskDone', function(source, cb, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local currentTaskId = tonumber(data.taskId)
    local result = ExecuteSql("SELECT premiumTasks FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local tasks = json.decode(result[1].premiumTasks)
        for k, v in pairs(tasks) do 
            if currentTaskId == tonumber(v.taskId) then 
                if v.hasCount >= v.requiredCount and not v.taken then 
                    v.taken = true
                    local addEXP = v.rewardEXP
                    ExecuteSql("UPDATE ak4y_battlepass SET premiumTasks = '"..json.encode(tasks).."', currentXP = currentXP + '"..addEXP.."' WHERE citizenid = '"..citizenId.."'")
                    cb(addEXP)
                end
                break
            else
                cb(false)
            end
        end
    end
end)

RegisterNetEvent('ak4y-battlepass:addXP')
AddEventHandler('ak4y-battlepass:addXP', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local deger = tonumber(amount)
    ExecuteSql("UPDATE ak4y_battlepass SET currentXP = currentXP + '"..deger.."' WHERE citizenid = '"..citizenId.."'")
end)

RegisterNetEvent('ak4y-battlepass:taskCountAdd:standart')
AddEventHandler('ak4y-battlepass:taskCountAdd:standart', function(taskId, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local citizenId = xPlayer.idcard
    local result = ExecuteSql("SELECT standartTasks FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local kayit = true
        local resultak4y = json.decode(result[1].standartTasks)
        for k, v in pairs(resultak4y) do 
            if tonumber(v.taskId) == tonumber(taskId) then 
                if v.taken or v.hasCount >= v.requiredCount then 
                    kayit = false
                end
                v.hasCount = v.hasCount + tonumber(count)
                if v.hasCount > v.requiredCount then 
                    v.hasCount = v.requiredCount
                end
                break
            end
        end
        if kayit then 
            ExecuteSql("UPDATE ak4y_battlepass SET standartTasks = '"..json.encode(resultak4y).."' WHERE citizenid = '"..citizenId.."'")
        end
    end
end)

RegisterNetEvent('ak4y-battlepass:taskCountAdd:premium')
AddEventHandler('ak4y-battlepass:taskCountAdd:premium', function(taskId, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local citizenId = xPlayer.identifier
    local result = ExecuteSql("SELECT premiumTasks FROM ak4y_battlepass WHERE citizenid = '"..citizenId.."'")
    if result[1] then 
        local kayit = true
        local resultak4y = json.decode(result[1].premiumTasks)
        for k, v in pairs(resultak4y) do 
            if tonumber(v.taskId) == tonumber(taskId) then 
                if v.taken or v.hasCount >= v.requiredCount then 
                    kayit = false
                end
                v.hasCount = v.hasCount + tonumber(count)
                if v.hasCount > v.requiredCount then 
                    v.hasCount = v.requiredCount
                end
                break
            end
        end
        if kayit then 
            ExecuteSql("UPDATE ak4y_battlepass SET premiumTasks = '"..json.encode(resultak4y).."' WHERE citizenid = '"..citizenId.."'")
        end
    end
end)

-------------------------------------

ESX.RegisterServerCallback('ak4y-battlePass:sendInput', function(source, cb, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local citizenId = xPlayer.identifier
    local inputData = data.input
    local result = ExecuteSql("SELECT * FROM ak4y_battlepass_premiumcodes WHERE code = '"..inputData.."'")
    if result[1] ~= nil then 
        ExecuteSql("DELETE FROM ak4y_battlepass_premiumcodes WHERE code = '"..inputData.."'")
        ExecuteSql("UPDATE ak4y_battlepass SET premium = 1 WHERE citizenid = '"..citizenId.."'")
        SendToDiscord("Code: ``"..inputData.."``\nsuccessfuly used by citizen id: ``"..citizenId.."``")
        cb(true)
    else
        cb(false)
    end
end)


RegisterCommand('purchase_premium_battlepass', function(source, args)
	local src = source
    if src == 0 then
        local dec = json.decode(args[1])
        local tbxid = dec.transid
        while inProgress do
            Wait(1000)
        end
        inProgress = true
        local result = ExecuteSql("SELECT * FROM ak4y_battlepass_premiumcodes WHERE code = '"..tbxid.."'")
        if result[1] == nil then
            ExecuteSql("INSERT INTO ak4y_battlepass_premiumcodes (code) VALUES ('"..tbxid.."')")
            SendToDiscord("Code: ``"..tbxid.."``\nsuccessfuly into your database!")
        end
        inProgress = false  
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if AK4Y.UseTebexForPremiumCodes then 
            local tebexConvar = GetConvar('sv_tebexSecret', '')
            if tebexConvar == '' or tebexConvar == nil then
                print('^1////////////////////////////////////////////////////////////////////////////////////////////////////////////')
                print('^1//////////////////////////////////////////^Tebex Secret Missing.^1//////////////////////////////////////////')
                print('^1////////////////////////////////////////////////////////////////////////////////////////////////////////////')
                print('ak4y-battlepass: Tebex Secret Missing please set in server.cfg and try again. Script will not work correctly.')
                shouldStop = true
            end
        end
	end
end)

local DISCORD_NAME = "ak4y_battlepass"
local DISCORD_IMAGE = "https://i.imgur.com/Q72RWcB.png"
DiscordWebhook = Discord_Webhook
function SendToDiscord(name, message, color)
	if DiscordWebhook == "CHANGE_ME" then
	else
		local connect = {
		  	{
			  	["color"] = color,
			  	["title"] = "**".. name .."**",
			  	["description"] = message,
			  	["footer"] = {
			  	["text"] = "ak4y development",
			  	},
		 	 }
	  	}
		PerformHttpRequest(DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatarrl = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
	end
end

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if AK4Y.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif AK4Y.Mysql == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif AK4Y.Mysql == "mysql-async" then   
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GeneratePlate()
    local plate = string.upper(GetRandomLetter(3) .. " " .. GetRandomNumber(3))
    local send = false
    local result = ExecuteSql("SELECT plate FROM owned_vehicles WHERE plate = '"..plate.."'")
    if result[1] then
        return GeneratePlate()
    else
        return plate:upper()
    end
end