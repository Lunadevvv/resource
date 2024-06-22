ESX.RegisterServerCallback('s4-vehicleshop:checkPlatePrice', function(source, cb, plate) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local xi = tonumber(xPlayer.getMoney())
 
    if xi >= Config.PlatePrice then 
      cardata = MySQL.Sync.fetchAll("SELECT plate FROM owned_vehicles WHERE plate='"..plate.."' ", {})
	  
      if #cardata == 0 then 
          xPlayer.removeMoney(Config.PlatePrice)
		      cb(true)
      end
    else
        xPlayer.showNotification('You dont have enough money.')
    end
end)
 
ESX.RegisterServerCallback('s4-vehicleshop:checkPrice', function(source, cb, data) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	  local curGarage = data.curGarage
    local i = tonumber(xPlayer.getMoney())
    if i >= data.price then 
      xPlayer.removeMoney(data.price)
      if tonumber(xPlayer.getMoney()) == (i - data.price) then -- two auth
        cb(true)
      end 
    end
end)
 
local log = 'https://discord.com/api/webhooks/1023308718563147879/VSYpmxIITp4PiBb-UJCWs_aAfUgqcucuND4M6qh6Vybu6dpXTsdlWDNopzSTW2d3kJtE'

RegisterNetEvent('s4-vehicleshop:server:givecar')
AddEventHandler('s4-vehicleshop:server:givecar', function(props, curGarage, price)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES ('"..Player.identifier.."', '"..props.plate.."', '"..json.encode(props).."', '"..curGarage.type.."')", {  })
    TriggerEvent('luna_log', log, 'Mua xe', Player.name .. ' đã mua xe biển số ' .. props.plate .. ' với giá ' .. price)
end)


ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchScalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
	function(result)
		cb(result ~= nil)
	end)
end)







