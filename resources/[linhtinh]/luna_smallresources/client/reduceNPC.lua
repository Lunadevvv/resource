Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()		
		local pos = GetEntityCoords(playerPed) 
			RemoveVehiclesFromGeneratorsInArea(pos['x'] - 1000.0, pos['y'] - 1000.0, pos['z'] - 1000.0, pos['x'] + 1000.0, pos['y'] + 1000.0, pos['z'] + 1000.0);
			SetGarbageTrucks(false) 
			SetRandomBoats(false) 
			SetCreateRandomCops(false) 
			SetCreateRandomCopsNotOnScenarios(false) 
			SetCreateRandomCopsOnScenarios(false) 
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetPedDensityMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)		
	end	

end)

CreateThread( function()
	while true do
	   Wait(0)
	   RestorePlayerStamina(PlayerId(), 1.0)
	end
end)