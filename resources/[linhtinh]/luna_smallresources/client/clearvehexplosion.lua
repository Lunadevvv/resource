local thoigian = 5*60*1000

CreateThread(function()
	while true do 
		Wait(thoigian)
		for theveh in EnumerateVehicles() do
			if GetEntityHealth(theveh) == 0 then
				SetEntityAsMissionEntity(theveh, false, false)
				DeleteEntity(theveh)
			end
		end
	end
end)

local entityEnumerator = {
	__gc = function(enum)
	    if enum.destructor and enum.handle then
		    enum.destructor(enum.handle)
	    end
	    enum.destructor = nil
	    enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
	    local iter, id = initFunc()
	    if not id or id == 0 then
	        disposeFunc(iter)
		    return
	    end
	  
	    local enum = {handle = iter, destructor = disposeFunc}
	    setmetatable(enum, entityEnumerator)
	  
	    local next = true
	    repeat
		    coroutine.yield(id)
		    next, id = moveFunc(iter)
	    until not next
	  
	    enum.destructor, enum.handle = nil, nil
	    disposeFunc(iter)
	end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end