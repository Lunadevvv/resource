CalculatePrice = function(random, count)
    local price = math.random(random[1], random[#random]);
    local percent = (Config.InDeCress/100);

    if count > Config.DisCount then
        price = price - percent
    elseif count < Config.DisCount then
        price = price + percent
    end

    return ESX.Math.Round(price)
end

Citizen.CreateThread(function()
    Wait(300)
    for k,v in pairs(Config.Items) do
        local price = CalculatePrice(Config.Items[k].randomPrice, 0);

        Config.Items[k].count = 0;
        Config.Items[k].price = price;
    end

    while true do
        Wait(Config.EconomyUpdate * 60000)
        for k,v in pairs(Config.Items) do
            local price = CalculatePrice(Config.Items[k].randomPrice, Config.Items[k].count);

            Config.Items[k].count = 0;
            Config.Items[k].price = price;
			TriggerClientEvent(GetCurrentResourceName()..":client:updateEconomy", -1, Config.Items[k], k)
        end
        NotifyChane()
    end
end)

ESX.RegisterServerCallback("syntax_economy:callback:getCallback", function(source, cb)
    cb(Config.Items);
end)

RegisterServerEvent(GetCurrentResourceName()..':server:sellItems')
AddEventHandler(GetCurrentResourceName()..':server:sellItems', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(itemName)
    local value = Config.Items[itemName]
    
    if xItem.count < amount then
        return
    end

    if value == nil then
        return
    end

    local price = value.price * amount
    local CountItemsSell = value.count + amount;
    Config.Items[itemName].count = CountItemsSell;
    xPlayer.removeInventoryItem(xItem.name, amount)
    xPlayer.addMoney(price)
    NotifySV((Config['Translate']['SellItems']):format(price, value.price), source)
    if Config.RepriceOnCount and Config.Items[itemName].count >= Config.DisCount then
        local newPrice = CalculatePrice(Config.Items[itemName].randomPrice, Config.Items[itemName].count);

        Config.Items[itemName].count = 0;
        Config.Items[itemName].price = newPrice;
        TriggerClientEvent(GetCurrentResourceName()..":client:updateEconomy", -1, value, itemName)
    end
    DiscordSend(xItem.label, amount, price, value.price)
    TriggerClientEvent(GetCurrentResourceName()..":client:updateEconomy", -1, value, itemName)
end)

DiscordSend = function(iname, icount, imoney, imp)
    local playerId = source
    if Config['Webhooks']["EnableCustom"] then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        Config['Webhooks']["CustomWebhook"](playerId, xPlayer, iname, icount, imoney, imp)
    else
        local TokenUsername = "Syntex Developer"
        local logo = ""
        local webhook = ""
        local color = 1752220
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer == nil then
            return false
        end
        local discordId = GetDiscordID(playerId)
        local playerIp = GetPlayerEndpoint(playerId)
        if not discordId then
            discordId = "N/A"
            discordName = "N/A"
        else
            discordId = string.gsub(discordId, "discord:", "")
            discordName = "<@" .. discordId .. ">"
        end
        if not playerIp then
            playerIp = "N/A"
        end
        local desc = ("**Name**: `%s`\n**Identifier**: `%s`\n**Discord**: %s\n**Discord ID**: `%s`\n**IP Address**: `%s`"):format(GetPlayerName(playerId), xPlayer.identifier, discordName, discordId, playerIp)
        local embed = {
            {
                ["title"] = "ประวัติการขายของ",
                ["type"] = "rich",
                ["color"] = color,
                ["thumbnail"] = {
                    ["url"] = logo
                },
                ['description'] = ("**รายละเอียด**:\n```%s ได้ทำการขาย %s จำนวน %s ได้เงินทั้งหมด %s บาท ( %s฿/ชิ้น )```"):format(GetPlayerName(playerId), iname, icount, imoney, imp),
                ['fields'] = {
                    {
                        ['name'] = "Economy Information",
                        ['value'] = desc,
                        ['inline'] = true
                    },
                },
                ["footer"] = {
                    ["text"] = TokenUsername,
                    ["icon_url"] = logo
                }
            }
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({webhookURL = Config['Webhooks']['URL'], embed = embed}), { ['Content-Type'] = 'application/json' })
    end
end

function GetDiscordID(src)
    local discordId = nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordId = v
            break
        end
    end
    if discordId == nil or discordId:sub(1, 8) ~= "discord:" then
        return false
    end
    return discordId
end