Config = {}
Config.ShowUnlockedText = false
Config.CheckVersion = false
Config.CheckVersionDelay = 60 -- Minutes
Config.Debug = true

Config.DoorList = {
------------------------------------------
--	MISSION ROW POLICE DEPARTMENT		--
------------------------------------------



	-- gabz_mrpd	FRONT DOORS
	{
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = false,
		maxDistance = 1.5,
		doors = {
			{objHash = -1547307588, objHeading = 90.0, objCoords = vector3(434.7444, -983.0781, 30.8153)},
			{objHash = -1547307588, objHeading = 270.0, objCoords = vector3(434.7444, -980.7556, 30.8153)}
		},
		lockpick = true
	},
	
	-- gabz_mrpd	NORTH DOORS
	{
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 1.5,
		doors = {
			{objHash = -1547307588, objHeading = 180.0, objCoords = vector3(458.2087, -972.2543, 30.8153)},
			{objHash = -1547307588, objHeading = 0.0, objCoords = vector3(455.8862, -972.2543, 30.8153)}
		},
		
	},

	-- gabz_mrpd	SOUTH DOORS
	{
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 1.5,
		doors = {
			{objHash = -1547307588, objHeading = 0.0, objCoords = vector3(440.7392, -998.7462, 30.8153)},
			{objHash = -1547307588, objHeading = 180.0, objCoords = vector3(443.0618, -998.7462, 30.8153)}
		},
		
	},

	-- gabz_mrpd	LOBBY LEFT


	{
		authorizedJobs = {['police']=0},
		objHash = -1406685646,
		objHeading = 0.0,
		objCoords = vector3(441.13, -977.93, 30.82319),
		locked = true,
		maxDistance = 1.5,
		fixText = true
	
	},

	-- gabz_mrpd	LOBBY RIGHT
	{
		objHash = -96679321,
		objHeading = 180.0,
		objCoords = vector3(440.5201, -986.2335, 30.82319),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 1.5,
	},

	-- gabz_mrpd	GARAGE ENTRANCE 1
	{
		objHash = 1830360419,
		objHeading = 269.78,
		objCoords = vector3(464.1591, -974.6656, 26.3707),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true,
		autoLock = 10000
	},

	-- gabz_mrpd	GARAGE ENTRANCE 2
	{
		objHash = 1830360419,
		objHeading = 89.87,
		objCoords = vector3(464.1566, -997.5093, 26.3707),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true,
		autoLock = 10000
	},
	
	-- gabz_mrpd	GARAGE ROLLER DOOR 1
	{
		objHash = 2130672747,
		objHeading = 0.0,
		objCoords = vector3(431.4119, -1000.772, 26.69661),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 6,
		garage = true,
		slides = true,
		audioRemote = true,
		autoLock = 10000
	},
	
	-- gabz_mrpd	GARAGE ROLLER DOOR 2
	{
		objHash = 2130672747,
		objHeading = 0.0,
		objCoords = vector3(452.3005, -1000.772, 26.69661),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 6,
		garage = true,
		slides = true,
		audioRemote = true,
		autoLock = 10000
	},
	
	-- gabz_mrpd	BACK GATE
	{
		objHash = -1603817716,
		objHeading = 90.0,
		objCoords = vector3(488.8948, -1017.212, 27.14935),
		authorizedJobs = { ['police']=0, ['offpolice']=0 },
		locked = true,
		maxDistance = 6,
		slides = true,
		audioRemote = true,
		autoLock = 10000
		
	},

	-- gabz_mrpd	MUGSHOT
	{
		objHash = -1406685646,
		objHeading = 180.0,
		objCoords = vector3(475.9539, -1010.819, 26.40639),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	CELL ENTRANCE 1
	{
		objHash = -53345114,
		objHeading = 270.0,
		objCoords = vector3(476.6157, -1008.875, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL ENTRANCE 2
	{
		objHash = -53345114,
		objHeading = 180.0,
		objCoords = vector3(481.0084, -1004.118, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 1
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(477.9126, -1012.189, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 2
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(480.9128, -1012.189, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 3
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(483.9127, -1012.189, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 4
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(486.9131, -1012.189, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 5
	{
		objHash = -53345114,
		objHeading = 180.0,
		objCoords = vector3(484.1764, -1007.734, 26.48005),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	LINEUP
	{
		objHash = -288803980,
		objHeading = 90.0,
		objCoords = vector3(479.06, -1003.173, 26.4065),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	OBSERVATION I
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6694, -983.9868, 26.40548),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	INTERROGATION I
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6701, -987.5792, 26.40548),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	OBSERVATION II
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6699, -992.2991, 26.40548),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	INTERROGATION II
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6703, -995.7285, 26.40548),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	EVIDENCE
	{
		objHash = -692649124,
		objHeading = 134.7,
		objCoords = vector3(475.8323, -990.4839, 26.40548),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true
	},

	-- gabz_mrpd	ARMOURY 1
	{
		objHash = -692649124,
		objHeading = 90.0,
		objCoords = vector3(479.7507, -999.629, 30.78927),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true,
		autoLock = 10000
	},

	-- gabz_mrpd	ARMOURY 2
	{
		objHash = -692649124,
		objHeading = 181.28,
		objCoords = vector3(487.4378, -1000.189, 30.78697),
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		fixText = true,
		autoLock = 10000
	},

	-- gabz_mrpd	SHOOTING RANGE
	{
		authorizedJobs = { ['police']=0 },
		locked = true,
		maxDistance = 1.5,
		doors = {
			{objHash = -692649124, objHeading = 0.0, objCoords = vector3(485.6133, -1002.902, 30.78697)},
			{objHash = -692649124, objHeading = 180.0, objCoords = vector3(488.0184, -1002.902, 30.78697)}
		},
		autoLock = 10000
		
	},

	-- gabz_mrpd	ROOFTOP
	{
		objCoords = vector3(464.3086, -984.5284, 43.77124),
		authorizedJobs = { ['police']=0 },
		objHeading = 90.000465393066,
		slides = false,
		lockpick = false,
		audioRemote = false,
		maxDistance = 1.5,
		garage = false,
		objHash = -692649124,
		locked = true,
		fixText = true,
		autoLock = 2000
	}

}

-- gabz pd double door back
table.insert(Config.DoorList, {
	locked = true,
	doors = {
		{objHash = -692649124, objHeading = 180.00001525879, objCoords = vector3(469.7743, -1014.406, 26.48382)},
		{objHash = -692649124, objHeading = 0.0, objCoords = vector3(467.3686, -1014.406, 26.48382)}
 },
	maxDistance = 2.5,
	slides = false,
	audioRemote = false,
	lockpick = false,
	authorizedJobs = { ['police']=0 },
	autoLock = 10000
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison entrance gate 1
table.insert(Config.DoorList, {
	objHash = 741314661,
	audioRemote = true,
	slides = true,
	objHeading = 90.0,
	fixText = false,
	authorizedJobs = { ['police']=0 },
	garage = false,
	objCoords = vector3(1844.998, 2604.813, 44.63978),
	maxDistance = 6.0,
	lockpick = false,
	locked = true,
	autoLock = 10000	
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison entrance gate 1
table.insert(Config.DoorList, {
	objHash = 741314661,
	audioRemote = true,
	slides = true,
	objHeading = 90.0,
	fixText = false,
	authorizedJobs = { ['police']=0 },
	garage = false,
	objCoords = vector3(1818.543, 2604.813, 44.611),
	maxDistance = 6.0,
	lockpick = false,
	locked = true,
	autoLock = 10000
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison door outside 1
table.insert(Config.DoorList, {
	objHash = -1156020871,
	audioRemote = false,
	slides = false,
	objHeading = 179.99987792969,
	fixText = false,
	authorizedJobs = { ['police']=0 },
	garage = false,
	objCoords = vector3(1797.761, 2596.565, 46.38731),
	maxDistance = 2.0,
	lockpick = false,
	locked = true,
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison gate inside 1
table.insert(Config.DoorList, {
	objHash = 741314661,
	audioRemote = true,
	slides = true,
	objHeading = 179.99998474121,
	fixText = false,
	authorizedJobs = { ['police']=0 },
	garage = false,
	objCoords = vector3(1799.608, 2616.975, 44.60325),
	maxDistance = 6.0,
	lockpick = false,
	locked = true,
	autoLock = 10000
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- police
table.insert(Config.DoorList, {
	maxDistance = 2.0,
	objHeading = 270.00003051758,
	lockpick = false,
	fixText = false,
	objCoords = vector3(458.6543, -990.6498, 30.82319),
	audioRemote = false,
	objHash = -96679321,
	garage = false,
	slides = false,
	authorizedJobs = { ['police']=0 },
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- staff
table.insert(Config.DoorList, {
	maxDistance = 6.0,
	locked = true,
	fixText = false,
	objCoords = vector3(-1145.898, -1991.144, 14.18357),
	garage = true,
	objHeading = 135.00006103516,
	lockpick = false,
	audioRemote = false,
	authorizedJobs = { ['staff']=0 },
	slides = 6.0,
	objHash = -550347177,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- staff
table.insert(Config.DoorList, {
	slides = false,
	lockpick = false,
	audioRemote = false,
	maxDistance = 2.5,
	authorizedJobs = { ['staff']=0 },
	doors = {
		{objHash = -1775213343, objHeading = 240.00003051758, objCoords = vector3(-932.0214, -2933.113, 14.09436)},
		{objHash = -1775213343, objHeading = 60.000019073486, objCoords = vector3(-933.3221, -2935.366, 14.09436)}
 },
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- staff
table.insert(Config.DoorList, {
	objHash = -1775213343,
	maxDistance = 2.0,
	authorizedJobs = { ['staff']=0 },
	garage = false,
	lockpick = false,
	objCoords = vector3(-922.5665, -2941.576, 14.09436),
	audioRemote = false,
	slides = false,
	fixText = false,
	objHeading = 60.000019073486,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- fire doors
table.insert(Config.DoorList, {
	doors = {
		{objHash = 812467272, objHeading = 354.82919311523, objCoords = vector3(-590.8196, -1621.441, 33.16198)},
		{objHash = 812467272, objHeading = 174.24942016602, objCoords = vector3(-589.5289, -1621.576, 33.16212)}
 	},
	delete = true,
	slides = false,
	lockpick = false,
	authorizedJobs = { ['security']=0 },
	locked = false,
	maxDistance = 2.5,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- police
table.insert(Config.DoorList, {
	fixText = false,
	audioRemote = false,
	lockpick = false,
	locked = true,
	maxDistance = 2.0,
	objHash = -96679321,
	objCoords = vector3(459.9454, -990.7053, 35.10398),
	slides = false,
	garage = false,
	authorizedJobs = { ['police']=0 },
	objHeading = 0.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- police
table.insert(Config.DoorList, {
	fixText = false,
	audioRemote = false,
	lockpick = false,
	locked = true,
	maxDistance = 2.0,
	objHash = -1406685646,
	objCoords = vector3(459.9454, -981.0742, 35.10398),
	slides = false,
	garage = false,
	authorizedJobs = { ['police']=0 },
	objHeading = 180.00001525879,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Dungeon
table.insert(Config.DoorList, {
	fixText = false,
	audioRemote = false,
	lockpick = false,
	locked = true,
	maxDistance = 2.0,
	objHash = -607013269,
	objCoords = vector3(4989.271, -5735.335, 15.07164),
	slides = false,
	garage = false,
	authorizedJobs = { ['fib']=0 },
	objHeading = 328.17016601563,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- mechanic
table.insert(Config.DoorList, {
	objHash = -983965772,
	locked = false,
	objHeading = 3.6506202220917,
	objCoords = vector3(945.9343, -985.5709, 41.1689),
	lockpick = false,
	audioRemote = false,
	garage = true,
	authorizedJobs = { ['mechanic']=0, ['offmechanic']=0 },
	fixText = false,
	slides = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Mechanic
table.insert(Config.DoorList, {
	objHash = 1289778077,
	slides = false,
	locked = true,
	audioRemote = false,
	objHeading = 93.65064239502,
	fixText = true,
	garage = false,
	lockpick = false,
	authorizedJobs = { ['mechanic']=0, ['offmechanic']=0 },
	maxDistance = 2.0,
	objCoords = vector3(948.5289, -965.3519, 39.64355),		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Mechanic
table.insert(Config.DoorList, {
	objHash = -626684119,
	slides = false,
	locked = true,
	audioRemote = false,
	objHeading = 183.65063476563,
	fixText = true,
	garage = false,
	lockpick = false,
	authorizedJobs = { ['mechanic']=0, ['offmechanic']=0 },
	maxDistance = 6.0,
	objCoords = vector3(955.3583, -972.4452, 39.64792),		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Benny's
table.insert(Config.DoorList, {
	objHash = -427498890,
	fixText = false,
	lockpick = false,
	maxDistance = 6.0,
	audioRemote = false,
	objCoords = vector3(-205.6828, -1310.683, 30.29572),
	objHeading = 0.0,
	garage = true,
	authorizedJobs = { ['mechanic']=0, ['offmechanic']=0 },
	locked = true,
	slides = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Court House meeting room
table.insert(Config.DoorList, {
	audioRemote = false,
	slides = false,
	locked = true,
	maxDistance = 2.5,
	lockpick = false,
	authorizedJobs = { ['lawyer']=0, ['government']=0 },
	doors = {
		{objHash = -739665083, objHeading = 179.99998474121, objCoords = vector3(237.5845, -1093.266, 29.42783)},
		{objHash = -739665083, objHeading = 1.0017911336035e-05, objCoords = vector3(234.9886, -1093.26, 29.42783)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Court House meeting room 2
table.insert(Config.DoorList, {
	audioRemote = false,
	slides = false,
	locked = true,
	maxDistance = 2.5,
	lockpick = false,
	authorizedJobs = { ['lawyer']=0, ['government']=0 },
	doors = {
		{objHash = -739665083, objHeading = 89.999961853027, objCoords = vector3(244.0013, -1101.253, 29.42782)},
		{objHash = -739665083, objHeading = 269.99996948242, objCoords = vector3(244.0079, -1098.651, 29.42782)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Court House assistant judge office
table.insert(Config.DoorList, {
	audioRemote = false,
	slides = false,
	locked = true,
	maxDistance = 2.5,
	lockpick = false,
	authorizedJobs = { ['lawyer']=0, ['government']=0 },
	doors = {
		{objHash = -739665083, objHeading = 1.0017911336035e-05, objCoords = vector3(249.3059, -1093.26, 36.26669)},
		{objHash = -739665083, objHeading = 179.99998474121, objCoords = vector3(251.9079, -1093.266, 36.26669)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Court House judge office
table.insert(Config.DoorList, {
	audioRemote = false,
	slides = false,
	locked = true,
	maxDistance = 2.5,
	lockpick = false,
	authorizedJobs = { ['lawyer']=0, ['government']=0 },
	doors = {
		{objHash = -739665083, objHeading = 1.0017911336035e-05, objCoords = vector3(234.9886, -1093.26, 36.26731)},
		{objHash = -739665083, objHeading = 179.99998474121, objCoords = vector3(237.5845, -1093.266, 36.26731)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Lawyer
table.insert(Config.DoorList, {
	doors = {
		{objHash = -739665083, objHeading = 1.0017911336035e-05, objCoords = vector3(249.3059, -1093.26, 29.42789)},
		{objHash = -739665083, objHeading = 179.99998474121, objCoords = vector3(251.9079, -1093.266, 29.42789)}
 },
	maxDistance = 2.5,
	locked = true,
	audioRemote = false,
	slides = false,
	authorizedJobs = { ['Lawyer']=0 },
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Tyces Safe
table.insert(Config.DoorList, {
	slides = false,
	authorizedJobs = { ['rea']=0 },
	garage = false,
	maxDistance = 2.0,
	objHash = -1185205679,
	objCoords = vector3(-1014.431, 1569.8, 278.491),
	audioRemote = false,
	lockpick = false,
	objHeading = 278.96795654297,
	fixText = false,
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})


-- mechanic 
table.insert(Config.DoorList, {
	objCoords = vector3(1.02154, -1675.23, 28.71656),
	lockpick = false,
	fixText = false,
	slides = 6.0,
	objHeading = 22.3996925354,
	locked = true,
	garage = true,
	authorizedJobs = { ['mechanic']=0 },
	maxDistance = 6.0,
	audioRemote = false,
	objHash = 1450521648,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})



-- mechanic 
table.insert(Config.DoorList, {
	objCoords = vector3(-18.49778, -1674.178, 28.75193),
	authorizedJobs = { ['mechanic']=0 },
	objHash = 1450521648,
	garage = true,
	fixText = false,
	audioRemote = false,
	lockpick = false,
	objHeading = 140.02754211426,
	slides = 6.0,
	locked = false,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Planes
table.insert(Config.DoorList, {
	slides = false,
	locked = true,
	doors = {
		{objHash = -1775213343, objHeading = 60.000019073486, objCoords = vector3(-922.5665, -2941.576, 14.09436)},
		{objHash = -1775213343, objHeading = 240.00003051758, objCoords = vector3(-921.2658, -2939.323, 14.09436)}
 },
	authorizedJobs = { ['rea']=0 },
	lockpick = false,
	audioRemote = false,
	maxDistance = 2.5,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Jewlery Store
table.insert(Config.DoorList, {
	locked = false,
	slides = false,
	doors = {
		{objHash = 1425919976, objHeading = 306.00003051758, objCoords = vector3(-631.9554, -236.3333, 38.20653)},
		{objHash = 9467943, objHeading = 306.00003051758, objCoords = vector3(-630.4265, -238.4375, 38.20653)}
 },
	lockpick = false,
	maxDistance = 2.5,
	audioRemote = false,
	authorizedJobs = { ['Police']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})