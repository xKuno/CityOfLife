Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 1000  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 10 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 15 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 10000

Config.RespawnPoint = { coords = vector3(327.94302368164,-601.21099853516,43.284034729004), heading = 171.4 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(295.7, -583.3, 42.4),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			--vector3(305.9, -597.8, 42.4)
			vector3(304.43, -600.76, 42.29)
		},

		Pharmacies = {
			vector3(316.7, -588.1, 42.2)
		},

		Vehicles = {
			{
				Spawner = vector3(295.87, -602.074, 42.33),
				InsideShop = vector3(319.1684, -574.3137, 28.79686),
				Marker = { type = 27, x = 1.0, y = 1.0, z = 1.0, r = 225, g = 0, b = 0, a = 200, rotate = true },
				SpawnPoints = {
					{ coords = vector3(288.5, -612.3, 43.3), heading = 74.4, radius = 4.0 },
					{ coords = vector3(288.5, -605.9, 43.3), heading = 74.4, radius = 4.0 },
					{ coords = vector3(277.6, -607.8, 43.3), heading = 100.9, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(343.27694702148,-580.04455566406,73.20),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 0, b = 0, a = 200, rotate = true },
				SpawnPoints = {
					{ coords = vector3(351.6, -587.9, 74.1), heading = 102.1, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'ambulance', label = 'EMS Ford E450', price = 5000},			
	},

	doctor = {
		{ model = 'ambulance', label = 'EMS Ford E450', price = 5000},	
	},

	chief_doctor = {
		{ model = 'ambulance', label = 'EMS Ford E450', price = 5000},		
	},

	boss = {
		{ model = 'ambulance', label = 'EMS Ford E450', price = 5000},
	},

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {
		{ model = 'polmav', label = 'EMS Chopper', price = 500000 },		
	},
}
