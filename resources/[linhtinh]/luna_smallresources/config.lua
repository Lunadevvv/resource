-- ## 3dme : shared config file

Config = {
    language = 'en',
    visual = {
        color = { r = 255, g = 0, b = 0, a = 255 }, -- Text color
        font = 0, -- Text font
        time = 5000, -- Duration to display the text (in ms)
        scale = 0.7, -- Text scale
        dist = 20, -- Min. distance to draw 
    },
}

Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

--safezone
Config.PositionX = 0.930 -- ตำแหน่งข้อความ X
Config.PositionY = 0.500 -- ตำแหน่งข้อความ Y
Config.Blips = {
    Garage = {
        x = -318.95,
        y = -937.92,
        z = 31.08,
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
    Garage2 = {
        x = 227.7978515625, y = -788.19342041016, z = 30.689708709717,
        Size = 50.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
	SandyZone = {
        x = 1836.06,
        y = 3676.95,
        z = 34.27,
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
	Mechanic = {
        x = -761.71,
        y = -1490.19,
        z = 5.0,
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
	PoliceStation = {
        x = 425.09,
        y = -979.5,
        z = 30.71,
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
	Hospitalmain = {
        x = 305.090118, y = -588.804382, z = 57.722290,
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
    Jail = {
        x = 1793.0311279297, y = 2483.0871582031, z = 45.69635772705,        
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
    -- Jail2 = {
    --     x = 1009.2793579102, y = -3100.1687011719, z = 5.999877929688,        
    --     Size = 100.0,
    --     Color = 3,
    --     Alpha = 180,
    --     notifIn = false,
    --     notifOut = false
    -- },
    Jail3 = {
        x = 1702.1733398438, y = 2581.1953125, z = 45.411834716797,        
        Size = 100.0,
        Color = 3,
        Alpha = 180,
        notifIn = false,
        notifOut = false
    },
    Jail4 = {
    x = 1632.8251953125, y = 2434.7314453125, z = 45.564907073975,        
    Size = 100.0,
    Color = 3,
    Alpha = 180,
    notifIn = false,
    notifOut = false
    }
}


Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"scratch his nose" for example.'}},
        prefix = ' '
    },
    ['fr'] = {
        commandName = 'me',
        commandDescription = 'Affiche une action au dessus de votre tête.',
        commandSuggestion = {{ name = 'action', help = '"se gratte le nez" par exemple.'}},
        prefix = ' '
    },
}

Config.Backpacks = {
    ['balo1'] = {weight = 75000, type = 1},
    ['balo2'] = {weight = 100000, type = 2},
    ['balo3'] = {weight = 125000, type = 3},
}
