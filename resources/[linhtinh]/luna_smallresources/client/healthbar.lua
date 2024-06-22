LRPT = {}
LRPT.__index = LRPT

function LRPT:Start()
    local obj = {}
    setmetatable(obj, LRPT)
    obj.ped = PlayerPedId()
    obj.player = PlayerId()
    obj.serverId = GetPlayerServerId(PlayerId())
    obj.playersData = {}
    return obj
end

function LRPT:MainThread()
    Citizen.CreateThread(function()
        while true do 
            -- coroutine.yield(0)
            local sleep = 1000
            self.ped = PlayerPedId()
            local aiming, targetEnt = GetEntityPlayerIsFreeAimingAt(self.player)
            if aiming and DoesEntityExist(targetEnt) then 
                if IsPedAPlayer(targetEnt) then 
                    sleep = 0
                    local targetCoords = GetEntityCoords(targetEnt)
                    local targetHealth = GetEntityHealth(targetEnt)
                    local targetArmour = GetPedArmour(targetEnt)
                    if self.playersData[targetEnt] == nil or self.playersData[targetEnt] < targetHealth then
                        self.playersData[targetEnt] = targetHealth
                    end
                    DrawHealthBar(targetCoords.x, targetCoords.y, targetCoords.z + 1, targetEnt);
                    -- if IsPedShooting(self.ped) then 
                    -- end
                end
            end
            Wait(sleep)
        end
    end)
end

rt = LRPT:Start()
rt:MainThread()
local maxDistance = 50;
local width = 0.03;
local height = 0.0065;
local border = 0.001;

function DrawHealthBar(x,y,z,otherPed)
    local camCoords = GetGameplayCamCoords()
    local dist = GetDistanceBetweenCoords(camCoords.x, camCoords.y, camCoords.z, x, y, z, true);
    if (dist <= maxDistance) then
      local abc = GetWeaponDamageModifier(GetHashKey(GetSelectedPedWeapon(otherPed)))
      --print(abc, GetHashKey(GetSelectedPedWeapon(otherPed)))
      local onScreen,_x,_y=World3dToScreen2d(x,y,z)
      if not onScreen then
        return;
      end
      
      -- local scale = dist / maxDistance;
      -- local camFov = GetGameplayCamFov();
      -- scale = (scale + scale * camFov) / 2;
      -- if (scale < 0.6) then
      local scale = 0.6;
      -- end
  
      local health = GetEntityHealth(otherPed);
      if health < 100 then
          health = 0
      else
          health = (health - 100) / 100
      end

  
      local armour = GetPedArmour(otherPed) / 100;
      y = _y;
      y = y - (scale * (0.005 * (3000 / 1080)));
      x = _x;
  
      --if (IsPlayerFreeAimingAtEntity(PlayerId(), otherPed)) then
        local y2 = _y;
        --DrawId(x - 0.0225, y2 - 0.0125, otherPlayer);
        if (armour > 0) then
          local x2 = x - width / 2 - border / 2;
          DrawRect(x2, y2, width + border * 2, 0.0085, 0, 0, 0, 200);
          DrawRect(x2, y2, width, height, 68, 121, 68, 255);
          DrawRect(x2 - (width / 2) * (1 - health), y2, width * health, height, 114, 203, 114, 200);
  
          x2 = x + width / 2 + border / 2;
          DrawRect(x2, y2, width + border * 2, height + border * 2, 0, 0, 0, 200);
          DrawRect(x2, y2, width, height, 41, 66, 78, 255);
          DrawRect(x2 - (width / 2) * (1 - armour), y2, width * armour, height, 48, 108, 135, 200);
        else 
          DrawRect(x, y2, width + border * 2, height + border * 2, 0, 0, 0, 200);
          DrawRect(x, y2, width, height, 68, 121, 68, 255);
          DrawRect(x - (width / 2) * (1 - health), y2, width * health, height, 114, 203, 114, 200);
        end
      --end
    end
end

function DrawText3D(coords, text, size, font)
    coords = vector3(coords.x, coords.y, coords.z + 0.2)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / 11) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
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