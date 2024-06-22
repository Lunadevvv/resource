local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
PlayerData = {}
local wantedTime = 0
local wantedBlip = {}
local disPlayerNames = 30
local saotruyna = 0
playerDistances = {}


Citizen.CreateThread(function()

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function DrawText3D(x, y, z, text) 
    local coords = vector3(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = GetDistanceBetweenCoords(camCoords, x, y, z, 1)

    if not size then size = 1 end
    
    local scale = (4.00001 / dist) * 0.3
    if scale < 0.08 then
        scale = 0.08
    end
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(scale, scale)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
	Citizen.Wait(25000)
	ESX.TriggerServerCallback("esx-wanted:retrieveWantedTime", function(inWanted, newWantedTime)
		if inWanted then
			wantedTime = newWantedTime
			WantedLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

--[[ RegisterNetEvent("esx-wanted:getMugshot")
AddEventHandler("esx-wanted:getMugshot", function(tartgetPed)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
	ESX.ShowAdvancedNotification('WANTED', 'WANTED', 'WANTED '..GetPlayerName(GetPlayerFromServerId(tartgetPed)), mugshotStr, 1)
	UnregisterPedheadshot(mugshot)
	exports['mugshot']:getMugshotUrl(PlayerPedId(), function ( url )
		print(url)
		TriggerServerEvent("esx-wanted:sendMugshot", url)
	end)
end) ]]

--[[ RegisterNetEvent("esx-wanted:syncMugshot")
AddEventHandler("esx-wanted:syncMugshot", function(url)
	SendNUIMessage(
		{
			update = true,
			url = url,
		}
	)
end) ]]

RegisterNetEvent("esx-wanted:openui")
AddEventHandler("esx-wanted:openui", function(name, time, id, reason, sao)	
	tg = tonumber(time)
	if tg < 60 then
		h = 0
		m = time
	else
		h = math.floor(time / 60)
		m = time - (h * 60)
	end
	SendNUIMessage(
		{
			display = true,
			ten = name,
			thoigian = time,
			id = id,
			lydo = reason,
			sao = sao,
			h = h,
			m = time,
		}
	)
	Citizen.Wait(Config.UIDelayTime)			---Wait 30s and close UI
	SendNUIMessage(
		{
			display = false,
		}
	)
end)

-- RegisterNetEvent("esx-wanted:showBlip")
-- AddEventHandler("esx-wanted:showBlip", function(target, blip, name)
-- 	if wantedBlip[target] ~= nil then 
-- 		RemoveBlip(wantedBlip[target])
-- 		wantedBlip[target] = nil 
-- 		wantedBlip[target] = AddBlipForCoord( blip.x, blip.y, blip.z)
-- 		SetBlipSprite(wantedBlip[target], 458)
-- 		SetBlipColour(wantedBlip[target], 1)
-- 		SetBlipScale(wantedBlip[target], 0.8)
-- 		SetBlipAsShortRange(wantedBlip[target], false)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString(""..name.."")
-- 		EndTextCommandSetBlipName(wantedBlip[target])
-- 	else 
-- 		wantedBlip[target] = AddBlipForCoord( blip.x, blip.y, blip.z)
-- 		SetBlipSprite(wantedBlip[target], 458)
-- 		SetBlipColour(wantedBlip[target], 1)
-- 		SetBlipScale(wantedBlip[target], 0.8)
-- 		SetBlipAsShortRange(wantedBlip[target], false)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString(""..name.."")
-- 		EndTextCommandSetBlipName(wantedBlip[target])
-- 	end
-- end)

RegisterNetEvent("esx-wanted:openWantedMenu")
AddEventHandler("esx-wanted:openWantedMenu", function()
	OpenWantedMenu()
end)

RegisterNetEvent("esx-wanted:wantedPlayer")
AddEventHandler("esx-wanted:wantedPlayer", function(newWantedTime)
	wantedTime = newWantedTime
	InWanted()
end)

RegisterNetEvent("esx-wanted:unWantedPlayer")
AddEventHandler("esx-wanted:unWantedPlayer", function()
	wantedTime = 0
	UnWanted()
end)

function WantedLogin()
	InWanted()	
end

function UnWanted()
	ESX.ShowNotification('Đã hủy truy nã')
	TriggerServerEvent('esx-wanted:unWanted')
end

RegisterNetEvent('esx-wanted:unWanted')
AddEventHandler('esx-wanted:unWanted', function(target)
	RemoveBlip(wantedBlip[target])

	Citizen.Wait(5)
end)

-----SEND LOCATION-----

function InWanted()
	Citizen.CreateThread(function()
		while wantedTime > 0  do
			local playerPed = PlayerPedId()
			ESX.ShowNotification("Thời Gian Truy Nã Còn "..wantedTime.." Phút")
			Wait(60000)
			wantedTime = wantedTime - 1
			if wantedTime == 0 then
				UnWanted()
				TriggerServerEvent("esx-wanted:updateWantedTime2", 0)
			end			
			TriggerServerEvent("esx-wanted:updateWantedTime", wantedTime)
		end	
	end)
end

-----COMMAND-----

RegisterNetEvent('wanted:client:menu', function()
	if PlayerData.job.name == Config.Job then
		OpenWantedMenu()
	else
		ESX.ShowNotification("Bạn không phải cảnh sát!")
	end
end)

-----WANTED MENU------

function OpenWantedMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'wanted_prison_menu',
		{
			title    = "Truy nã",
			align    = 'center',
			elements = {
				{ label = "Truy nã người chơi", value = "wanted_closest_player" },
				{ label = "Danh sách truy nã", value = "unwanted_player" }
			}
		}, 
	function(data, menu)
		local action = data.current.value
		if action == "wanted_closest_player" then
			menu.close()
			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'wanted_choose_id',
          		{
            		title = "Nhập ID"
          		},
          	function(data2, menu2)
				local targetId = tonumber(data2.value)
            	if targetId == nil then
					ESX.ShowNotification("Bạn phải nhập id người cần truy nã")
				elseif GetPlayerFromServerId(targetId) == -1 then 
					ESX.ShowNotification("Id không hợp lệ")
            	else
              		menu2.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wanted_time', {
						title = "Nhập thời gian"
					}, function(data3 , menu3)
						local time = tonumber(data3.value)
						if time == nil or time == 0 then 
							ESX.ShowNotification("Bạn phải nhập thời gian truy nã")
						elseif time < 5 then
							ESX.ShowNotification("Thời gian truy nã phải hơn 5p")
						else 
							menu3.close()
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wanted_reason', {
								title = 'Lí do truy nã'
							}, function(data4, menu4)
								local reason = data4.value
								menu4.close()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wanted_star', {
									title = 'Mức độ truy nã'
								},function(data5, menu5)
									local sao = tonumber(data5.value)
									if sao == nil or sao == 0 or sao > 5 then
										ESX.ShowNotification("Bạn phải nhập mức độ")
									else
										TriggerServerEvent('esx-wanted:wantedPlayer', targetId, time, reason, sao)
										TriggerServerEvent("AddSaoTruyNa", sao, targetId)
									end
									menu5.close()
								end,function(data5, menu5)
									menu5.close()
								end)
							end, function(data4, menu4)
								menu4.close()
							end)
						end 
					end, function(data3, menu3)
						menu3.close()
					end)
				end
          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unwanted_player" then
			local elements = {}
			ESX.TriggerServerCallback("esx-wanted:retrieveWantededPlayers", function(playerArray)
				if #playerArray == 0 then
					ESX.ShowNotification("Không có ai bị truy nã")
					return
				end
				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Tên: " .. playerArray[i].name .. " | Thời gian: " .. playerArray[i].wantedTime .. " Phút | Mức độ: " .. playerArray[i].saotruyna, value = playerArray[i].identifier })
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'wanted_unwanted_menu',
					{
						title = "Danh sách truy nã",
						align = "center",
						elements = elements
					},
				function(data2, menu2)
					local action = data2.current.value
					TriggerServerEvent("esx-wanted:unWantedPlayer", action)
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)	
end

