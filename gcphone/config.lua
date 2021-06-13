Config = {}

-- Script locale (only .Lua)
Config.Locale = 'en'

Config.FixePhone = {
	-- Mission Row
	['police'] = { 
	  name =  'Mission Row Police',
	  coords = { x = 443.9856, y = -981.8867, z = 30.58 } 
	},
  
	['mechanic'] = {
		name = 'Mechanic Shop',
		coords = { x= 949.9503, y= -966.6241, z = 39.5145 }
	},
  
	['ambulance'] = {
	  name = 'Pillbox Hospital',
	  coords = { x= 310.6645, y= -596.1021, z = 43.2840 }
	},
	
	['008-0001'] = {
	  name = _U('phone_booth'),
	  coords = { x = 372.25, y = -965.75, z = 28.58 } 
	},
	
	['478-7736'] = {
	  name = 'Gruppe Sechs',
	  coords = { x = -617.8365, y = -1622.101, z = 33.01058 } 
	},
  }

Config.KeyOpenClose = 288 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = true -- Show Number or Contact Name when you receive new SMS

Config.ShareRealtimeGPSDefaultTimeInMs = 1000 * 60 -- Set default realtime GPS sharing expiration time in milliseconds
Config.ShareRealtimeGPSJobTimer = 10 -- Default Job GPS Timer (Minutes)

-- Optional Features (Can all be set to true or false.)
Config.ItemRequired = true -- If true, must have the item "phone" to use it.
Config.NoPhoneWarning = true -- If true, the player is warned when trying to open the phone that they need a phone. To edit this message go to the locales for your language.

-- Optional Discord Logging
Config.UseTwitterLogging = false -- Set the Discord webhook in twitter.lua line 284