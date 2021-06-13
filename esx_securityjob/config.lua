Config                            = {}

Config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType                 = {BossActions = 22, Vehicles = 36, Helicopters = 34}
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 204, b = 50}

Config.EnablePlayerManagement     = true -- Enable if you want society managing.
Config.EnableESXIdentity          = true -- Enable if you're using esx_identity.
Config.EnableLicenses             = true -- Enable if you're using esx_license.

Config.EnableJobBlip              = false -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.

Config.Locale                     = 'en'

Config.Stations = {

	Main = {

		Blip = {
			Coords  = vector3(-629.22, -1635.56, 25.97),
			Sprite  = 487,
			Display = 4,
			Scale   = 1.2,
			Colour  = 43
		},

		Vehicles = {
			{
				Spawner = vector3(-629.22, -1635.56, 25.97),
				InsideShop = vector3(-617.51, -1598.23, 26.35),
				SpawnPoints = {
					{coords = vector3(-618.72, -1645.48, 25.43), heading = 60.92, radius = 2.0},
					{coords = vector3(-621.26, -1649.15, 25.43), heading = 60.92, radius = 2.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(-568.32, -1644.07, 19.27),
				InsideShop = vector3(-555.01, -1654.01, 19.27),
				SpawnPoints = {
					{coords = vector3(-555.01, -1654.01, 19.27), heading = 150.35, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(-615.1371, -1624.121, 33.01)
		}

	}

}

Config.AuthorizedVehicles = {
	car = {
		recruit = {
			{model = 'dilettante2', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'caddy', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0}, 
		},

		officer = {
			{model = 'dilettante2', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'caddy', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'stockade', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'securitychgr', props = {color1 = 125, color2 = 125, pearlescentColor = 125}, price = 0},
		},

		captain = {
			{model = 'dilettante2', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'caddy', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'stockade', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'xls2', props = {color1 = 125, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'securitychgr', props = {color1 = 125, color2 = 125, pearlescentColor = 125}, price = 0},			
		},

		boss = {
			{model = 'dilettante2', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'caddy', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'stockade', props = {color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'xls2', props = {color1 = 125, color2 = 125, pearlescentColor = 125}, price = 0},
			{model = 'securitychgr', props = {color1 = 125, color2 = 125, pearlescentColor = 125}, price = 0},			
		}
	},

	helicopter = {
		recruit = {

		},

		officer = {

		},

		captain = {
			{model = 'frogger2', props = {modLivery = 2, color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0}
		},

		boss = {
			{model = 'frogger2', props = {modLivery = 2, color1 = 131, color2 = 125, pearlescentColor = 125}, price = 0}
		}
	}
}