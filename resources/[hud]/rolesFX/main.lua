AddEventHandler("chatMessage", function(Source, Name, Msg)
    args = removenormal(Msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    else
        local xPlayer = ESX.GetPlayerFromId(Source)
        str = xPlayer.job.label
        str1 = xPlayer.job.name
        str = str:gsub("^%l", string.upper)
        if str1 == 'police' then
            TriggerClientEvent("chatMessage",-1,"^4[👮".. str .. "]" .. getName(Source) .. "", {255, 255, 255}, Msg)
        elseif str1 == 'ambulance' then
            TriggerClientEvent("chatMessage",-1,"^1[🚑".. str .. "]" .. getName(Source) .. "", {255, 255, 255}, Msg)
        elseif str1 == 'mechanic' then
            TriggerClientEvent("chatMessage",-1,"^3[🔧".. str .. "]" .. getName(Source) .. "", {255, 255, 255}, Msg)
        elseif str1 == 'unemployed' or str1 == 'offpolice' or str1 == 'offambulance' or str1 == 'offmechanic' then
            TriggerClientEvent("chatMessage",-1,"[Cư dân]" .. getName(Source) .. "", {255, 255, 255}, Msg)
        else
            TriggerClientEvent("chatMessage",-1,"^6[👿" .. str1 .. "]" .. getName(Source) .. "", {255, 255, 255}, Msg)
        end
    end
end)

function removenormal(input, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(input, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function getName(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local name = xPlayer.getName()
		return name
	end
    
	-- return GetPlayerName(source)
end
