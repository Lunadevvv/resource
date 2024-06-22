Config = {}

-- # Locale to be used. You can create your own by simple copying the 'en' and translating the values.
Config.Locale       				= 'en' -- Traduções disponives en / br

-- # By how many services a player's community service gets extended if he tries to escape
-- Config.ServiceExtensionOnEscape		= 0

-- # Don't change this unless you know what you are doing.
Config.ServiceLocation 				= {x = 1643.13, y = 2510.89, z = 45.56}

-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation				= {x = 1854.57, y = 2586.13, z = 45.67}


-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1641.88, 2504.58, 45.56) },
	{ type = "cleaning", coords = vector3(1637.97, 2498.57, 45.56) },
	{ type = "cleaning", coords = vector3(1627.71, 2493.71, 45.56) },
	{ type = "cleaning", coords = vector3(1624.1, 2503.48, 45.56) },
	{ type = "cleaning", coords = vector3(1629.31, 2513.65, 45.56) },
	{ type = "cleaning", coords = vector3(1625.87, 2522.62, 45.56) },
	{ type = "cleaning", coords = vector3(1644.66, 2515.93, 45.56) },
	{ type = "cleaning", coords = vector3(1650.54, 2505.33, 45.56) },
	{ type = "gardening", coords = vector3(1650.9, 2512.78, 45.56) },
	{ type = "gardening", coords = vector3(1655.78, 2519.53, 45.56) },
	{ type = "gardening", coords = vector3(1660.56, 2524.41, 45.56) },
	{ type = "gardening", coords = vector3(1664.75, 2519.51, 45.56) },
	{ type = "gardening", coords = vector3(1661.08, 2512.85, 45.56) }
}



Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 119, ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 120,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}
