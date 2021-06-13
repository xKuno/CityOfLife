Config = {}

Config = {
	DrawDistance = 100,
	BlipInfos = {
		Sprite = 527,
		Color = 54
	}
}

-- Set to true if you are using a "plate" column on your owned_vehicles table (such as when using esx_migrate)
Config.OwnedVehiclesHasPlateColumn = true

-- Determines if the ability to impound vehicles is based upon esx jobs
Config.RestrictImpoundToJobs = true

-- The jobs that are able to impound vehicles
Config.JobsThatCanImpound = {'police', 'mechanic'}

-- Determines if the ability to retrieve vehicles is based upon esx jobs
Config.RestrictRetrievalToJobs = false

-- The jobs that are able to retrieve vehicles
Config.RetrievalJobs = {'unemployed'}

-- Is the user required to wait a period of time before they can get their vehicle back
Config.UserMustWaitElapsedTime = true

-- Is the user required to pay a fine before they get their vehicle back
Config.UserMustPayFine = true

-- The amount of the fine the user must pay
Config.ImpoundFineAmount = 10000


-- The time in minutes before a user is able to retrieve a vehicle from the
-- impound lot.
Config.ElapsedTimeBeforeRelease = 60


Config.ImpoundLots = {
	Sandy = {
		Pos = {x=1048.13, y= 3618.42, z= 32.2},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = -1,
		DropoffPoint = {
			Pos = {x=1048.13, y= 3618.42, z= 32.2},
			Color = {r=58,g=100,b=122},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 27
		},
		RetrievePoint = {
			Pos = {x=1047.72, y= 3593.72, z= 33.00},
			Color = {r=0,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},
	Davis = {
		Pos = {x= 408.48, y= -1638.24, z= 29.28},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = -1,
		DropoffPoint = {
			Pos = {x =402.32, y =-1632.48, z =29.28},
			Color = {r=58,g=100,b=122},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 27
		},
		RetrievePoint = {
			Pos = {x= 411.24, y= -1647.4, z= 29.28},
			Color = {r=0,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1
		},
	},
}
