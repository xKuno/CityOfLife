Config.Jobs.taco = {

	BlipInfos = {
		Sprite = 184,
		Color = 1
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'taco',
			Trailer = 'none',
			HasCaution = true
		}

	},

	Zones = {

		VehicleSpawner = {
			Pos = {x = 449.69, y = -1247.77, z = 30.2},
			Size = {x = 2.0, y = 2.0, z = 0.2},
			Color = {r = 204, g = 204, b = 0},
			Marker = 27,
			Blip = true,
			Name = _U('taco_name'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('taco_garage'),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = {x = 455.69, y = -1250.69, z = 29.86},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 90.59
		},

		VehicleDeletePoint = {
			Pos = {x = -144.22, y = -577.02, z = 31.42},
			Size = {x = 5.0, y = 5.0, z = 0.2},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = {x = -139.09, y = -620.74, z = 167.82}
		}

	}
}
