AddEventHandler("esx_xp:rankUp", function(newRank, previousRank)
    -- Do something when player ranks up
    TriggerServerEvent('luna_balo:addWeightLevel', newRank)
end)