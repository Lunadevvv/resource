------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--


-- Configuration:

-- IMPORTANT: Some of these values MUST be defined as a floating point number. ie. 10.0 instead of 10

cfg = {
	deformationMultiplier = 0.1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 1.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 1.0,						-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 15.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.5,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.3,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 4.0,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 4.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 200.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 200.0,		-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = false,				-- Decrease engine torque as engine gets more and more damaged

	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25

	preventVehicleFlip = false,					-- If true, you can't turn over an upside down vehicle

	sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	displayBlips = false,						-- Show blips for mechanics locations

	compatibilityMode = false,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)

	randomTireBurstInterval = 0,				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled

	chargeForRepairs = true,					-- if true fixing vehicle cost money
	price = 15000.0,									-- you may edit this to your liking. if "chargeForRepairs = false" ignore this one
	DamageMultiplier = 5.0,						-- you may edit this to your liking. if "chargeForRepairs = false" ignore this one

	-- Class Damagefactor Multiplier
	-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
	-- Use it to increase or decrease damage for each class

	classDamageMultiplier = {
		[0] = 	0.7,		--	0: Compacts
				0.7,		--	1: Sedans
				0.7,		--	2: SUVs
				0.7,		--	3: Coupes
				0.7,		--	4: Muscle
				0.7,		--	5: Sports Classics
				0.7,		--	6: Sports
				0.7,		--	7: Super
				0.7,		--	8: Motorcycles
				0.7,		--	9: Off-road
				0.7,		--	10: Industrial
				0.7,		--	11: Utility
				0.9,		--	12: Vans
				1.0,		--	13: Cycles
				1.0,		--	14: Boats
				0.2,		--	15: Helicopters
				0.7,		--	16: Planes
				0.5,		--	17: Service
				0.5,		--	18: Emergency
				0.7,		--	19: Military
				0.7,		--	20: Commercial
				0.7			--	21: Trains
	}
}



--[[

	-- Alternate configuration values provided by ImDylan93 - Vehicles can take more damage before failure, and the balance between vehicles has been tweaked.
	-- To use: comment out the settings above, and uncomment this section.

cfg = {

	deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch
	deformationExponent = 1.0,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 1.0,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 5.1,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 5.1,						-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 61.0,				-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 1.0,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.124,			-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 7.4,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 1.5,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 677.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 310.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,				-- Decrease engine torge as engine gets more and more damaged

	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25

	preventVehicleFlip = true,					-- If true, you can't turn over an upside down vehicle

	sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	displayBlips = true,						-- Show blips for mechanics locations

	classDamageMultiplier = {
		[0] = 	1.0,		--	0: Compacts
				1.0,		--	1: Sedans
				1.0,		--	2: SUVs
				0.95,		--	3: Coupes
				1.0,		--	4: Muscle
				0.95,		--	5: Sports Classics
				0.95,		--	6: Sports
				0.95,		--	7: Super
				0.27,		--	8: Motorcycles
				0.7,		--	9: Off-road
				0.25,		--	10: Industrial
				0.35,		--	11: Utility
				0.85,		--	12: Vans
				1.0,		--	13: Cycles
				0.4,		--	14: Boats
				0.7,		--	15: Helicopters
				0.7,		--	16: Planes
				0.75,		--	17: Service
				0.85,		--	18: Emergency
				0.67,		--	19: Military
				0.43,		--	20: Commercial
				1.0			--	21: Trains
	}
}

]]--





-- End of Main Configuration

-- Configure Repair system

-- id=446 for wrench icon, id=72 for spraycan icon

repairCfg = {
	mechanics = {
		{name="Sữa xe công cộng", id=446, r=25.0, x=-337.0,  y=-135.0,  z=39.0},	-- LSC Burton
		{name="Sữa xe công cộng", id=446, r=25.0, x=-1155.0, y=-2007.0, z=13.0},	-- LSC by airport
		{name="Sữa xe công cộng", id=446, r=25.0, x=734.0,   y=-1085.0, z=22.0},	-- LSC La Mesa
		{name="Sữa xe công cộng", id=446, r=25.0, x=1177.0,  y=2640.0,  z=37.0},	-- LSC Harmony
		{name="Sữa xe công cộng", id=446, r=25.0, x=108.0,   y=6624.0,  z=31.0},	-- LSC Paleto Bay
		{name="Sữa xe công cộng", id=446, r=18.0, x=538.0,   y=-183.0,  z=54.0},	-- Sữa xe công cộng Hawic
		{name="Sữa xe công cộng", id=446, r=15.0, x=1774.0,  y=3333.0,  z=41.0},	-- Sữa xe công cộng Sandy Shores Airfield
		{name="Sữa xe công cộng", id=446, r=15.0, x=1143.0,  y=-776.0,  z=57.0},	-- Sữa xe công cộng Mirror Park
		{name="Sữa xe công cộng", id=446, r=30.0, x=2508.0,  y=4103.0,  z=38.0},	-- Sữa xe công cộng East Joshua Rd.
		{name="Sữa xe công cộng", id=446, r=16.0, x=2006.0,  y=3792.0,  z=32.0},	-- Sữa xe công cộng Sandy Shores gas station
		{name="Sữa xe công cộng", id=446, r=25.0, x=484.0,   y=-1316.0, z=29.0},	-- Hayes Auto, Little Bighorn Ave.
		{name="Sữa xe công cộng", id=446, r=33.0, x=-1419.0, y=-450.0,  z=36.0},	-- Hayes Auto Body Shop, Del Perro
		{name="Sữa xe công cộng", id=446, r=33.0, x=268.0,   y=-1810.0, z=27.0},	-- Hayes Auto Body Shop, Davis
	--	{name="Sữa xe công cộng", id=446, r=24.0, x=288.0,   y=-1730.0, z=29.0},	-- Hayes Auto, Rancho (Disabled, looks like a warehouse for the Davis branch)
		{name="Sữa xe công cộng", id=446, r=27.0, x=1915.0,  y=3729.0,  z=32.0},	-- Otto's Auto Parts, Sandy Shores
		{name="Sữa xe công cộng", id=446, r=45.0, x=-29.0,   y=-1665.0, z=29.0},	-- Mosley Auto Service, Strawberry
		{name="Sữa xe công cộng", id=446, r=44.0, x=-212.0,  y=-1378.0, z=31.0},	-- Glass Heroes, Strawberry
		{name="Sữa xe công cộng", id=446, r=33.0, x=258.0,   y=2594.0,  z=44.0},	-- Mechanic Harmony
		{name="Sữa xe công cộng", id=446, r=18.0, x=-32.0,   y=-1090.0, z=26.0},	-- Simeons
		{name="Sữa xe công cộng", id=446, r=25.0, x=-211.0,  y=-1325.0, z=31.0},	-- Bennys
		{name="Sữa xe công cộng", id=446, r=25.0, x=903.0,   y=3563.0,  z=34.0},	-- Auto Repair, Grand Senora Desert
		{name="Sữa xe công cộng", id=446, r=25.0, x=437.0,   y=3568.0,  z=38.0}		-- Auto Shop, Grand Senora Desert
	},

	fixMessages = {
		"Trông đã sửa rồi ... phải đẹp!",
		"Ứng dụng băng cuộn hoàn chỉnh ...",
		"Hoàn tất ứng dụng zip tie ...",
		"Tôi nghe nói đá xe của bạn sửa nó ...",
		"Keo siêu cố định mọi thứ ..."
	},
	fixMessageCount = 5,

	noFixMessages = {
		"Ca này bó tay"
	},
	noFixMessageCount = 1
}

RepairEveryoneWhitelisted = false
RepairWhitelist =
{
	"steam:11000011a3415f0",
	"steam:",
	"ip:"			-- not sure if ip whitelist works?
}

