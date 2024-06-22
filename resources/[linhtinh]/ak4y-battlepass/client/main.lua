playerData = nil

local depositTime, withdrawTime, transferTime = 0, 0, 0
Citizen.CreateThread(function()
	PlayerData = ESX.GetPlayerData()
	SendNUIMessage({
		type = 'firstLoading',
		neededEXP = AK4Y.RequiredXpForNextLevel,
		htmlLanguage = AK4Y.Language,
	})	
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	PlayerData = ESX.GetPlayerData()
end)

local openMenuSpamProtect = 0
RegisterCommand('battlepass', function()
	if openMenuSpamProtect < GetGameTimer() then 
		openMenuSpamProtect = GetGameTimer() + 3000
		ESX.TriggerServerCallback("ak4y-battlePass:getPlayerDetails", function(result)
			SetNuiFocus(true,true)
			SendNUIMessage({
				type = 'openUi', 
				currentXP = result.playerData.currentXP,
				standartTasks = result.playerData.standartTasks,
				premiumTasks = result.playerData.premiumTasks,
				rewards = result.playerData.rewards,
				userPremium = result.playerData.premium,
				bpItems = AK4Y.BattlePassItems,
				bpBottomTask = AK4Y.BattlePassTasks, 
				bpDailyPremiumTasks = AK4Y.DailyPremiumTasks,
				bpResetTime = result.resetDate,
				bpDailyResetTime = result.playerData.standartResetTime,
				firstName = ESX.GetPlayerData().name,
			})	
		end)
	else
		ESX.ShowNotification(AK4Y.Language.openSpamProtectNotif)
	end
end)

RegisterKeyMapping('battlepass', 'Battlepass Menüsünü Aç', 'keyboard', 'F9')

local getStandartSpamProtect = 0
RegisterNUICallback('getStandartReward', function(data, cb)
	if getStandartSpamProtect < GetGameTimer() then 
		getStandartSpamProtect = GetGameTimer() + 1000
		ESX.TriggerServerCallback("ak4y-battlePass:getStandartRewards", function(result)
			if result then 
				cb(true)
			else
				cb(false)
			end
		end, data)
	else
		cb(false)
	end
end)

local getPremiumSpamProtect = 0
RegisterNUICallback('getPremiumReward', function(data, cb)
	if getPremiumSpamProtect < GetGameTimer() then
		getPremiumSpamProtect = GetGameTimer() + 100 
		ESX.TriggerServerCallback("ak4y-battlePass:getPremiumRewards", function(result)
			if result then 
				cb(true)
			else
				cb(false)
			end
		end, data)
	else
		cb(false)
	end
end)

local standartTaskSpam = 0
RegisterNUICallback('standartTaskDone', function(data, cb)
	if standartTaskSpam < GetGameTimer() then 
		standartTaskSpam = GetGameTimer() + 1000
		ESX.TriggerServerCallback("ak4y-battlePass:standartTaskDone", function(result)
			if result then 
				SendNUIMessage({
					type = 'addEXP', 
					exp = tonumber(result),
				})	
				cb(true)
			else
				cb(false)
			end
		end, data)
	else
		cb(false)
	end
end)

local premiumTaskSpam = 0
RegisterNUICallback('premiumTaskDone', function(data, cb)
	if premiumTaskSpam < GetGameTimer() then 
		premiumTaskSpam = GetGameTimer() + 1000 
		ESX.TriggerServerCallback("ak4y-battlePass:premiumTaskDone", function(result)
			if result then 
				SendNUIMessage({
					type = 'addEXP', 
					exp = tonumber(result),
				})	
				cb(true)
			else
				cb(false)
			end
		end, data)
	else
		cb(false)
	end
end)

local sendInputSpam = 0
RegisterNUICallback('sendInput', function(data, cb)
	if sendInputSpam < GetGameTimer() then 
		sendInputSpam = GetGameTimer() + 1000
		ESX.TriggerServerCallback("ak4y-battlePass:sendInput", function(result)
			if result then 	
				cb(true)
			else
				cb(false)
			end
		end, data)
	else
		cb(false)
	end
end)

RegisterNUICallback('closeMenu', function(data, cb)
	SetNuiFocus(false, false)
end)

RegisterNetEvent('ak4y-battlepass:addtaskcount:standart')
AddEventHandler('ak4y-battlepass:addtaskcount:standart', function(taskId, count)
	TriggerServerEvent('ak4y-battlepass:taskCountAdd:standart', taskId, count)
end)

RegisterNetEvent('ak4y-battlepass:addtaskcount:premium')
AddEventHandler('ak4y-battlepass:addtaskcount:premium', function(taskId, count)
	TriggerServerEvent('ak4y-battlepass:taskCountAdd:premium', taskId, count)
end)

RegisterCommand('rabbitcavemaidinh', function(source, args)
    -- Here is client
    -- first param 1, because taskId = 1
    -- second param 1, because i will add just 1 count. if you type 2 you will add 2 count to task
    -- this task is daily thats why i used ak4y-battlepass:taskCountAdd:standart
    TriggerServerEvent('ak4y-battlepass:taskCountAdd:standart', 1, 1)
end)

print(" Leaked by Suck Leaks - https://discord.gg/WVMhNBvUbm ")