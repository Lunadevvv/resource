PlayerData = {}
Citizen.CreateThread(function()
    if ESX.IsPlayerLoaded() then 
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Blips) do
		local blip = AddBlipForRadius(v.x, v.y, v.z, v.Size)
	
		SetBlipColour(blip, v.Color)
		SetBlipAlpha(blip, v.Alpha)
	end
end)

local function DrawText3D(x,y ,width,height,scale, text, r,g,b,a)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

for k,v in pairs(Config.Blips) do
    Citizen.CreateThread(function ()
        while true do
            Citizen.Wait(0)
            local shouldDelay = true
            local player = PlayerPedId()
            local dist = GetDistanceBetweenCoords(GetEntityCoords(player), vector3(v.x,v.y,v.z), true)
            if dist <= v.Size then
                shouldDelay = false
                if not v.notifIn then
                    SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
                    v.notifIn = true
                    v.notifOut = false
                    Citizen.CreateThread(function ()
                        while v.notifIn do
                            Citizen.Wait(0)
                            if PlayerData.job.name ~= "police" then
                                DrawText3D(Config.PositionX, Config.PositionY, 1.0,1.0,0.55,"Khu vực ~r~:~g~ An toàn", 255,255,255,255)
                                DisableControlAction(0, 140, true)	
                                DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
                                DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
                                DisableControlAction(0, 106, true)
                                DisableControlAction(0, 44, true)
                                DisableControlAction(0, 91, true)
                                DisableControlAction(0, 92, true)
                                DisableControlAction(0, 25, true)
                                DisableControlAction(0, 24, true)
                                
                            end
                            -- if GetEntityHealth(PlayerPedId()) == 0 then 
                            --     ESX.ShowNotification("Bạn sẽ được hồi sinh sau 15s (Vùng An Toàn)")
                            --     Wait(15000)
                            --     TriggerEvent("esx_ambulancejob:revive")
                            --     Wait(5000)
                            -- end
                        end
                    end)
                end
            else
                if not v.notifOut then
                    v.notifOut = true
                    v.notifIn = false
                end
            end    
            if shouldDelay then 
                Wait(2000)
            end
        end
    end)
end
