local isArmoured = false
local curAr = 0
local loadout = {}
local WEAPON_HASHES_STRINGS = {
    [-1569615261]="Taykhông",
    [-102973651]="WEAPON_STONE_HATCHET",
    [-1716189206]="WEAPON_KNIFE",
    [1737195953]="WEAPON_NIGHTSTICK",
    [1317494643]="WEAPON_HAMMER",
    [2508868239]="weapon_bat",
    [1141786504]="weapon_golfclub",
    [2227010557]="weapon_crowbar",
    [4192643659]="weapon_bottle",
    [3756226112]="weapon_switchblade",
    [453432689]="weapon_pistol",
    [1593441988]="weapon_combatpistol",
    [-1716589765]="weapon_pistol50",
    [-1076751822]="weapon_snspistol",
    [-771403250]="weapon_heavypistol",
    [584646201]="weapon_appistol",
    [2578377531]="weapon_pistol50",
    [1198879012]="weapon_flaregun",
    [3696079510]="weapon_marksmanpistol",
    [3249783761]="weapon_revolver",
    [324215364]="weapon_microsmg",
    [-619010992]="weapon_machinepistol",
    [736523883]="weapon_smg",
    [4024951519]="weapon_assaultsmg",
    [171789620]="weapon_combatpdw",
    [-1660422300]="weapon_mg",
    [-1074790547]="weapon_assaultrifle",
    [2210333304]="weapon_carbinerifle",
    [2937143193]="weapon_advancedrifle",
    [1649403952]="weapon_compactrifle",
    [2634544996]="MG",
    [2144741730]="weapon_combatmg",
    [487013001]="weapon_pumpshotgun",
    [-1312131151]="weapon_rpg",
    [2017895192]="weapon_sawnoffshotgun",
    [3800352039]="weapon_assaultshotgun",
    [2640438543]="weapon_bullpupshotgun",
    [4019527611]="weapon_dbshotgun",
    [911657153]="weapon_stungun",
    [100416529]="weapon_sniperrifle",
    [205991906]="weapon_heavysniper",
    [2726580491]="weapon_grenadelauncher",
    [1305664598]="weapon_grenadelauncher_smoke",
    [2982836145]="weapon_rpg",
    [1119849093]="weapon_minigun",
    [2481070269]="weapon_grenade",
    [741814745]="weapon_stickybomb",
    [4256991824]="weapon_smokegrenade",
    [2694266206]="weapon_bzgas",
    [615608432]="weapon_molotov",
    [101631238]="weapon_fireextinguisher",
    [883325847]="weapon_petrolcan",
    [3218215474]="weapon_snspistol",
    [-1063057011]="weapon_specialcarbine",
    [3523564046]="weapon_heavypistol",
    [2132975508]="weapon_bullpuprifle",
    [2228681469]="weapon_bullpuprifle",
    [1672152130]="weapon_hominglauncher",
    [2874559379]="weapon_proxmine",
    [126349499]="weapon_snowball",
    [137902532]="weapon_vintagepistol",
    [-598887786]="weapon_marksmanpistol",
    [-1045183535]="weapon_revolver",
    [2460120199]="weapon_dagger",
    [2138347493]="weapon_firework",
    [2828843422]="weapon_musket",
    [3342088282]="weapon_marksmanrifle",
    [984333226]="weapon_heavyshotgun",
    [1627465347]="weapon_gusenberg",
    [4191993645]="weapon_stone_hatchet",
    [1834241177]="weapon_railgun",
    [2725352035]="Fists",
    [3638508604]="weapon_knuckle",
    [3713923289]="weapon_machete",
    [3675956304]="weapon_machinepistol",
    [2343591895]="weapon_flashlight",
    [600439132]="weapon_ball",
    [1233104067]="weapon_flare",
    [2803906140]="NightVision",
    [4222310262]="gadget_parachute",
    [317205821]="weapon_autoshotgun",
    [3441901897]="weapon_battleaxe",
    [125959754]="weapon_compactlauncher",
    [-1813897027]="weapon_grenade",
    [-37975472]="weapon_smokegrenade",
    [-1121678507]="weapon_minismg",
    [3125143736]="weapon_pipebomb",
    [2484171525]="weapon_poolcue",
    [419712736]="weapon_wrench",
    [4208062921]="weapon_carbinerifle_mk2",
    [-1357824103]="weapon_advancedrifle",
    [3219281620]="weapon_pistol_mk2",
    [3686625920]="weapon_combatmg_mk2",
    [961495388]="weapon_assaultrifle_mk2",
    [-2084633992]="weapon_carbinerifle",
    [177293209]="weapon_heavysniper_mk2",
    [-952879014]="weapon_marksmanrifle",
    [2024373456]="weapon_smg_mk2",
    [-270015777]="weapon_assaultsmg",
    [-335430670]="AKGOLD",
    [-335430670] = "WEAPON_AKB",
    [1084920949] = "WEAPON_BF3",
    [1595201550] = "WEAPON_XR2",
    [-1171598465] = "WEAPON_XM25",
    [-303983872] = "WEAPON_BUSTERSWORD",
    [1495124272] = "WEAPON_GUNBLADE",
    [-484865036] = "WEAPON_RUNESCAPE1",
    [-261839222] = "WEAPON_RUNESCAPE2",
    [1529117720] = "WEAPON_RUNESCAPE3",
    [693999755] = "WEAPON_RUNESCAPE4",
    [1034162531] = "WEAPON_XBOW",
    [1438000445] = "WEAPON_MAGIKSWORD",
    [1217255841] = "WEAPON_MSR",
    [1276725267] = "WEAPON_F4MINI",
    [757043420] = "WEAPON_CHEYTAC",
    [-851966428] = "WEAPON_AWPH",
    [1994451307] = "WEAPON_TOMAHAWK" 
}
local wbh = 'https://discord.com/api/webhooks/1014967837141508236/WL8eZkqpWDmQsZiFuggeL1An9HCfiJE7Jt0Sx6FSF_AUVeLS3o4S22hIh8s9YwDrrBIN'

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	
    local healtTable = {}
    while true do
        Citizen.Wait(0)
		SetPlayerWeaponDamageModifier(PlayerId(), 1.0)
		SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)
        local aiming, targetAiming = GetEntityPlayerIsFreeAimingAt(PlayerId())
        --[[ if aiming and DoesEntityExist(targetAiming) and not IsPedAPlayer(targetAiming) then
            if IsControlJustReleased(0, 48) then -----Z
                print('debug model: ' .. GetEntityModel(targetAiming) .. ' | dist: ' .. Vdist(GetEntityCoords(PlayerPedId()), GetEntityCoords(targetAiming)) .. ' | owner: ' .. GetPlayerName(NetworkGetEntityOwner(targetAiming)) .. " | isOwned: "..IsVehiclePreviouslyOwnedByPlayer(targetAiming))
            end
			if IsControlJustReleased(0, 47) then -----G
				TrigerServerEvent('lorraxs:forceDelete', ObjToNet(targetAiming))
			end
        else ]]
        if aiming and DoesEntityExist(targetAiming) and IsPedAPlayer(targetAiming) then
            if healtTable[targetAiming] == nil or healtTable[targetAiming] < GetEntityHealth(targetAiming) then
                healtTable[targetAiming] = GetEntityHealth(targetAiming)
            end
            local targetCoords = GetEntityCoords(targetAiming)
            local x, y, z = table.unpack(targetCoords)
            local newTargetCoords = vector3(x, y, z + 1.1)
            if IsPedShooting(PlayerPedId()) then
                local currentHealth = GetEntityHealth(targetAiming)
                local currentArmour = GetPedArmour(targetAiming)
                    DrawHealth(targetAiming, currentHealth, currentArmour, newTargetCoords)
                Citizen.Wait(0)
            end
        end
    end
end)

function DrawHealth(targetAiming, currentHealth, currentArmour, coords)
    Citizen.CreateThread(function()

        local newTargetHealth = GetEntityHealth(targetAiming)
        local newTargetArmour = GetPedArmour(targetAiming)

                if currentArmour == 0 then
                    while newTargetHealth == currentHealth do
                        newTargetHealth = GetEntityHealth(targetAiming)
                        Citizen.Wait(0)
                    end
                end
                if currentArmour ~= 0 then
                    while newTargetArmour == currentArmour do
                        newTargetArmour = GetPedArmour(targetAiming)
                        print(newTargetArmour)
                        Citizen.Wait(0)
                    end
                end
		local isDamagebone, bone = GetPedLastDamageBone(targetAiming)
        local dmg =  tonumber(currentHealth) - newTargetHealth
        local dmgar = currentArmour - newTargetArmour		
		-- if currentHealth > 140 then
			local weaponHandler, weaponHash = GetCurrentPedWeapon(PlayerPedId(), true)
			if (dmg > 10 or dmgar > 10) then
				if dmg > dmgar then
					TriggerServerEvent('luna_log', wbh, 'Dame', GetPlayerName(PlayerId()).." Sát thương gây ra: "..dmg.." weapon : "..WEAPON_HASHES_STRINGS[weaponHash])
				else
					TriggerServerEvent('luna_log', wbh, 'Dame', GetPlayerName(PlayerId()).." Sát thương gây ra: "..dmgar.." weapon : "..WEAPON_HASHES_STRINGS[weaponHash])
				end
			end
		-- end
        if dmg >= 105 then
            dmg = 'DEAD'
        end
        
        if dmgar ~= 0 then
            DrawText2DTweenUp('~b~'.. dmgar,8.0,0.6,0.5,0.1,0.5)
        else
            DrawText2DTweenUp('~r~'.. dmg,8.0,0.6,0.5,0.1,0.5)
        end
        -- if dmgar ~= 0 then
        --     for i = 1, 100, 1 do
        --         local x, y, z = table.unpack(GetEntityCoords(targetAiming))
        --         z2 = z + 1 + (i/100)
        --         --local scale = 0.7 * (i/500)
        --         --print(scale)
        --         local newcoords = vector3(x, y, z2)
        --         ESX.Game.Utils.DrawText3D(newcoords,' ~b~'..dmgar, 2.0, 7)
        --         Citizen.Wait(10)
        --     end
        -- else
        --     for i = 1, 100, 1 do
        --         local x, y, z = table.unpack(GetEntityCoords(targetAiming))
        --         z2 = z + 1 + (i/100)
        --         --local scale = 0.7 * (i/500)
        --         --print(scale)
        --         local newcoords = vector3(x, y, z2)
        --         ESX.Game.Utils.DrawText3D(newcoords, '~r~'..dmg, 2.0, 7)
        --         Citizen.Wait(10)
        --     end
        -- end
    end)
end
	
function table.contains(table, element)
  for k, value in pairs(table) do
    if GetHashKey(value.name) == element then
		return true
	end
	end
	return false
end

function DrawText2D(text,scale,x,y,a)
    
	SetTextScale(scale/24, scale/24)
	SetTextFont(0)
	SetTextColour(224, 50, 50, 255)
	--SetTextDropshadow(0, 0, 0, 0, 255)
	--SetTextDropShadow()
	SetTextOutline(0, 0, 0, 255)
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
	ClearDrawOrigin()
end

function DrawText2DTweenUp(text,scale,x,y,moveheight,speed)
    CreateThread(function()
        local height = y
        local total_ = height - (y-moveheight) 
        local total = height - (y-moveheight) 
        
        while height > y-moveheight do 
            DrawText2D(text,scale,x,height,math.floor(255* (total/total_)))
            height = height - 0.003*speed
            total = total - 0.003*speed
            Wait(0)
        end 
    end)
end 
