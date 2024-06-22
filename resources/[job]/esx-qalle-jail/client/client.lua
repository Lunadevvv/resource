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

local jailTime = 0
local vassoumodel = "prop_tool_broom"
local spatulamodel = "bkr_prop_coke_spatula_04"
local vassour_net = nil
local spatula_net = nil
Citizen.CreateThread(function()

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(15)
	end

	PlayerData = ESX.GetPlayerData()

	LoadTeleporters()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData

	Citizen.Wait(25000)

	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then

			jailTime = newJailTime

			JailLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function(newJailTime)
	jailTime =	 newJailTime
	Cutscene()
end)

RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
	jailTime = 0
	UnJail()
end)

function JailLogin()
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(  PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
	InJail()
end

function UnJail()
	InJail()

	ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	ESX.ShowNotification("Bạn đã được ra tù, hãy sống tốt !")
end

function InJail()

	--Jail Timer--

	Citizen.CreateThread(function()

		while jailTime > 0 do
			Citizen.Wait(60000)
			if jailTime > 0 then
				jailTime = jailTime - 1
			end
			ESX.ShowNotification('Bạn còn ' .. jailTime .. ' phút trong tù')
			TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)
			if jailTime == 0 then
				UnJail()
				TriggerServerEvent("esx-qalle-jail:updateJailTime", 0)
				return
			end
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped) 
			local Distance = GetDistanceBetweenCoords(PedCoords.x, PedCoords.y, PedCoords.z, 1662.93, 2593.07, 45.56, true)
			local Distance2 = GetDistanceBetweenCoords(PedCoords.x, PedCoords.y, PedCoords.z, 1800.6979980469, 2483.0979003906, -122.68814849854, true)
			if Distance > 320 and Distance2 > 320 and jailTime > 0 then
				jailTime = jailTime + 10
				ESX.ShowNotification('Bạn bị tăng thêm 10 phút vì cố gắng vượt ngục')
				ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Jail"])
			end
		end
	end)

end

function GetNearWork()
	for k,v in pairs(Config.ServiceLocations) do 
		local Ped = PlayerPedId()
		local PedCoords = GetEntityCoords(Ped)
		local Distance = GetDistanceBetweenCoords(v.coords, PedCoords, true)
		if Distance < 1.5 then
			return v.type
		end
	end
end

local disable_actions = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if disable_actions then 
			DisableAllControlActions(0)
		else
			Wait(200)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if jailTime > 0 then
		ESX.ShowNotification('Bạn đã chết trong tù hãy chờ 30 giây để được hồi sinh')
		SetTimeout(30000, function()
			TriggerEvent('esx_ambulancejob:revive')
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if jailTime > 0 then
			DisableAction()
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)
			for k,v in pairs(Config.ServiceLocations) do
				local Distance = GetDistanceBetweenCoords(v.coords, PedCoords, true)
				if Distance < 20 then
					DrawMarker(21, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
					if Distance < 1.5 and not disable_actions then
						ESX.ShowHelpNotification('Nhấn ~g~[E]~s~ để làm việc')
						if IsControlJustPressed(0, 38) then
							if (v.type == "cleaning") then
								local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed( PlayerId()), 0.0, 0.0, -5.0)
								local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
								local netid = ObjToNet(vassouspawn)
								disable_actions = true 
								ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
										TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
										AttachEntityToEntity(  vassouspawn,GetPlayerPed( PlayerId()),GetPedBoneIndex(GetPlayerPed( PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
										vassour_net = netid
									end)
									exports.rprogress:Custom({
										Duration = 60000,
										Label = 'Đang làm việc',
										LabelPosition = "bottom",
										ShowTimer = true,
										useWhileDead = 0,
										canCancel = 0,
										DisableControls = {
											Mouse = false,
											Player = true,
											Vehicle = true
										},
										Animation = {
											-- animationDictionary = "mini@cpr@@cpr_str",
											-- animationName = "cpr_pumpchest"
										},
									onComplete = function()
										disable_actions = false
										DetachEntity(NetToObj(vassour_net), 1, 1)
										DeleteEntity(NetToObj(vassour_net))
										vassour_net = nil
										ClearPedTasks(PlayerPedId())
										if jailTime > 0 then
											jailTime = jailTime - 1
										end

										ESX.ShowNotification('Bạn còn ' .. jailTime .. ' phút trong tù')
										TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)
										if jailTime < 1 then
											UnJail()
										end
									end})
							elseif (v.type == "gardening") then
								local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed( PlayerId()), 0.0, 0.0, -5.0)
								local spatulaspawn = CreateObject(GetHashKey(spatulamodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
								local netid = ObjToNet(spatulaspawn)
								disable_actions = true
								TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
								AttachEntityToEntity(  spatulaspawn,GetPlayerPed( PlayerId()),GetPedBoneIndex(GetPlayerPed( PlayerId()), 28422),-0.005,0.0,0.0,190.0,190.0,-50.0,1,1,0,1,0,1)
								spatula_net = netid
								exports.rprogress:Custom({
									Duration = 60000,
									Label = 'Đang làm việc',
									LabelPosition = "bottom",
									ShowTimer = true,
									useWhileDead = 0,
									canCancel = 0,
									DisableControls = {
										Mouse = false,
										Player = true,
										Vehicle = true
									},
									Animation = {
										-- animationDictionary = "mini@cpr@@cpr_str",
										-- animationName = "cpr_pumpchest"
									},
								onComplete = function()
									disable_actions = false
									DetachEntity(NetToObj(spatula_net), 1, 1)
									DeleteEntity(NetToObj(spatula_net))
									spatula_net = nil
									ClearPedTasks(PlayerPedId())
									if jailTime > 0 then
										jailTime = jailTime - 1
									end
									ESX.ShowNotification('Bạn còn ' .. jailTime .. ' phút trong tù')
									TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)
									if jailTime < 1 then
										UnJail()
									end
								end})
							end
						end
					end
				end
			end
		else
			Wait(500)
		end
	end
end)

function DisableAction()
	local playerPed = PlayerPedId()
	DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
	DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
    DisableControlAction(0, 106, true) -- Disable in-game mouse controls
    DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)

	if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	end

	if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
	end
end

function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do
			
			local sleepThread = 500

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do

				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 7.5 then

					sleepThread = 5

					ESX.Game.Utils.DrawText3D(v, "[E] Mở Cửa", 0.4)

					if DistanceCheck <= 1.0 then
						if IsControlJustPressed(0, 38) then
							TeleportPlayer(v)
						end
					end
				end
			end

			Citizen.Wait(sleepThread)

		end
	end)
end


function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = '',
			align    = 'center',
			elements = {
				{ label = "Tống người gần nhất vào tù", value = "jail_closest_player" },
				{ label = "Thả tù", value = "unjail_player" }
			}
		}, 
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Thoi gian vao tu (phut)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("Can phai la don vi phut!")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("Khong nguoi choi nao o gan!")
					else
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Li do vao tu"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								ESX.ShowNotification("Ban can phai dien cai gi do vao day!")
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("Khong nguoi choi nao o gan!")
								else

								  	TriggerServerEvent("esx-qalle-jail:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
								end
						  	end
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" and PlayerData.job.grade >= 3 then

			local elements = {}

			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					ESX.ShowNotification("Nha tu cua ban dang trong!")
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Tù nhân: " .. playerArray[i].name .. " | Thoi gian trong tu: " .. playerArray[i].jailTime .. " phut", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Tha nguoi choi",
						align = "center",
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

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
