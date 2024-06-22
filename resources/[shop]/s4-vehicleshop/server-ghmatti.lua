ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
 
ESX.RegisterServerCallback('s4-vehicleshop:checkPlatePrice', function(source, cb, plate) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if tonumber(xPlayer.getQuantity("cash")) >= 15000 then 
      cardata = exports.ghmattimysql:executeSync("SELECT plate FROM owned_vehicles WHERE plate='"..plate.."' ", {})
      if #cardata == 0 then 
        cb(true)
        xPlayer.removeInventoryItem("cash", 15000)
      end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sie haben nicht genug Bargeld'})
    end
end)
 
 
 

ESX.RegisterServerCallback('s4-vehicleshop:checkPrice', function(source, cb, data) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = "cash"
    
    if data.blackMoney == true then 
       item = "blackmoney"
    end
    
    local i = tonumber(xPlayer.getQuantity(item))

    if i >= data.price then 
       xPlayer.removeInventoryItem(item, data.price)
       
       if tonumber(xPlayer.getQuantity(item)) == (i - data.price) then -- two auth
          cb(true)
       end
    end
end)
 

RegisterNetEvent('s4-vehicleshop:server:givecar')
AddEventHandler('s4-vehicleshop:server:givecar', function(props)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    exports.ghmattimysql:execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES ('"..Player.identifier.."', '"..props.plate.."', '"..json.encode(props).."')", {  })
    local info = {model = props.model, plaka = props.plate}
    Player.addInventoryItem('carkey', 1, false, info)
    print(Player.source..' ARAC SATIN ALDI')
end)
