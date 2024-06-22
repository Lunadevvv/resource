Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 500 * 10,
	MethProcessing = 500 * 10,
	CokeProcessing = 500 * 10,
	MahoanProcessing = 500 * 10,
	lsdProcessing = 500 * 10,
	HeroinProcessing = 500 * 10,
	thionylchlorideProcessing = 1000 * 10,
}

Config.DrugDealerItems = {
	heroin = 2000,
	marijuana = 2100,
	meth = 1800,
	coke = 2100,
	lsd = 1250,
	goimahoan = 2000,
}

Config.ChemicalsConvertionItems = {
	hydrochloric_acid = 0,
	sodium_hydroxide = 0,
	sulfuric_acid = 0,
	lsa = 0,
}

Config.ChemicalsLicenseEnabled = false --Will Enable or Disable the need for a Chemicals License.
Config.MoneyWashLicenseEnabled = false --Will Enable or Disable the need for a MoneyWash License.

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 1}
}

Config.Licenses = {
	moneywash = 1,
	chemicalslisence = 1,
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	--Weed
	WeedField = {coords = vector3(2224.64, 5577.03, 53.85), name = _U('blip_WeedFarm'), color = 25, sprite = 496, radius = 200.0},
	WeedProcessing = {coords = vector3(2329.12, 2571.86, 46.68), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 200.0},
	
	--Coke
	CokeField = {coords = vector3(-310.43, 2496.34, 76.60), name = _U('blip_CokeFarm'), color = 60, sprite = 501, radius = 200.0},
	CokeProcessing = {coords = vector3(1689.14, 3291.36, 41.15), name = _U('blip_Cokeprocessing'),color = 60, sprite = 501, radius = 200.0},
	
	--Heroin
	HeroinField = {coords = vector3(16.34, 6875.94, 12.64), name = _U('blip_heroinfield'), color = 50, sprite = 403, radius = 200},
	HeroinProcessing = {coords = vector3(-216.66174316406,6367.083984375,31.492294311523), name = _U('blip_heroinprocessing'), color = 50, sprite = 403, radius = 100.0},

	--Ma hoàng
	MahoanField = {coords = vector3(315.639557, 4325.367, 48.438), name = 'Bãi Ma hoàn', color = 34, sprite = 484, radius = 200},
	MahoanProcessing = {coords = vector3(1531.239, 1703.446, 109.754), name = 'Đóng gói Ma hoàn', color = 34, sprite = 484, radius = 200.0},

	--DrugDealer
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 100.0},
	
}
