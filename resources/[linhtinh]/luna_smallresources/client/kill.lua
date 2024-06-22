
Citizen.CreateThread(function()
    -- main loop thing
	alreadyDead = false
    while true do
        Citizen.Wait(50)
		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and not alreadyDead then
			
			killer = GetPedSourceOfDeath(playerPed)
			_,weapon = GetCurrentPedWeapon(killer,1)
			weaponHash = GetSelectedPedWeapon(killer)
            weapon = ESX.GetWeaponFromHash(weaponHash)
            if weapon == nil then
            	weapon = 'khong xac dinh'
            else
            	weapon = weapon.name
            end
			for id = 0, 254 do
				if killer == GetPlayerPed(id) then
					killServerid = GetPlayerServerId(id)
				end				
			end
            dameweapon = math.floor(GetWeaponDamage(weaponHash))
		
			if killer == playerPed then
				TriggerServerEvent('kill:die',0)
			elseif killServerid ~= nil then
				TriggerServerEvent('kill:die',1,killServerid,weapon,dameweapon)
            else
                local nguoitong = GetPedInVehicleSeat(killer, -1)
                if nguoitong then
                    for id = 0, 254 do
                        if nguoitong == GetPlayerPed(id) then
							killServerid = GetPlayerServerId(id)
                        end
                    end
                    TriggerServerEvent('kill:die',2, killServerid)
                end
			end
		
			alreadyDead = true
		end
		if not IsEntityDead(playerPed) then
			alreadyDead = false
        end
        RemoveAllPickupsOfType(0x5985D162)
	end
end)

local weapons = {
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01'),
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_01'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_01'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_02'),
    GetHashKey('COMPONENT_PUMPSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_SAWNOFFSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_01'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02'),
    GetHashKey('COMPONENT_AT_RAILCOVER_01'),
    GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    GetHashKey('COMPONENT_AT_PI_FLSH'),
    GetHashKey('COMPONENT_AT_AR_FLSH'),
    GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
    GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
    GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
    GetHashKey('COMPONENT_AT_SCOPE_LARGE'),
    GetHashKey('COMPONENT_AT_SCOPE_MAX'),
    GetHashKey('COMPONENT_AT_PI_SUPP'),
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        for i = 1, #weapons do
            local dmg_mod = GetWeaponComponentDamageModifier(weapons[i])
            local accuracy_mod = GetWeaponComponentAccuracyModifier(weapons[i])
            if dmg_mod > 1.1 or accuracy_mod > 1.2 then
                TriggerServerEvent('WeaponDame', dmg_mod, accuracy_mod)
            end
        end
    end
end)
				



