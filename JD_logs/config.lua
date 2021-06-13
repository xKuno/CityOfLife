Config = {}

Config.AllLogs = true											-- Enable/Disable All Logs Channel
Config.postal = true  											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "Mulletbot" 							-- Bot Username
Config.avatar = "https://i.imgur.com/gh9PwWd.png"				-- Bot Avatar
Config.communtiyName = "Mulletville Legacy"					-- Icon top of the Embed
Config.communtiyLogo = "https://i.imgur.com/gh9PwWd.png"		-- Icon top of the Embed


Config.weaponLog = true  			-- set to false to disable the shooting weapon logs
Config.weaponLogDelay = 1000		-- delay to wait after someone fired a weapon to check again in ms (put to 0 to disable) Best to keep this at atleast 1000

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs


-- Change color of the default embeds here
-- It used Decimal color codes witch you can get and convert here: https://jokedevil.com/colorPicker
Config.joinColor = "3863105" 		-- Player Connecting
Config.leaveColor = "15874618"		-- Player Disconnected
Config.chatColor = "10592673"		-- Chat Message
Config.shootingColor = "10373"		-- Shooting a weapon
Config.deathColor = "000000"		-- Player Died
Config.serverstatus = "00ff33"	-- server Stopped/Started
Config.resourceColor = "15461951"	-- Resource Stopped/Started


Config.webhooks = {
	all = "<DISCORD_WEBHOOK>",
	exm = 'https://discord.com/api/webhooks/822028757563867176/b4OYgkQ2NRwSSIkKB6AyF3gi7sWgjBJrVRtX7hA6FarX8T_bsYcg-fHIdkgWqR0tZSRF',
	chat = "https://discord.com/api/webhooks/787683322149994506/3NctU5kTZSqOkEpfNGRxL482d6FCMqWVqDVlcOvp7_nhPrz5wV5Qhoigj3CsYO6WVs4K",
	joins = "https://discord.com/api/webhooks/787682435587768330/TcUH5daUc-gJMZU2EvS1QayvnxFJWg5RojEMO8SR78wzootUwexKy2mk6W6lrzyPsTRd",
	leaving = "https://discord.com/api/webhooks/787683881771073536/FE_Wn-1TVX5bGWYfTeJgz_2CU5UXRVJjs9gwLfCNYuSUuEvbFYSD469LPQnTEAR3xtdX",
	deaths = "https://discord.com/api/webhooks/787684078476460033/OPK5wL5VE9beFWoNgiZ4qoSQXHj1LISBUE7zNcizF4FOzxCYnJ_XYfxjY0dJMGKtTadu",
	trashpicker = "https://discord.com/api/webhooks/787684250358382614/elIlPzaucHPgoR3O-UazW_QBliNz9WGTKox-5b0tVazrF3AQRx2lUPI7CbSG_tGJIsdu",
	jailer = "https://discord.com/api/webhooks/787684463835480084/H68clOv1ENvXv6n6OUnIks76MTQaBoqUM2SKfk_l4zi22JNnF6VjzRrY9lah6r6I4I7t",
	doorlock = "https://discord.com/api/webhooks/787684618702815233/-7IrKVqXec3q_Licl5b6w--cAog_2VVCJSu_hSHsTryBrSaermK-b3QAKAa-M6ta-ge4",
	shooting = "https://discord.com/api/webhooks/787684761039798292/RIcySLXYccIVLq_CpEDMYyQWlL86K7qwMn8QndFoFfQXRVBRurjE-lFgfTVG-mosP-r6",
	pdlogg = "https://discord.com/api/webhooks/787684898646655026/Mr4utZUxdVOzJB3jarCK7ue96flfpRaF2yLpDVi185b5JygGdpzPU6OvWAC10wAqhlAy",
	serverstatus = "https://discord.com/api/webhooks/787685055359221801/lfah-phvRJCI8IzhDcjSNVG1gQB-oDSLyZ46twVDVW_Q1kO7l_WiqQbDyX98DjCGABNN",
	emsclockin = "https://discord.com/api/webhooks/787685207020666880/W5C-z-gD9Vq6-uMY8MceVMiUHgGUxtXqy5JdeypvKefkPJ72XvrifB3GfhfpjHXj6b6n",
	pdclockin = "https://discord.com/api/webhooks/787685364076511263/4ZKmVNabFPJzDtI3tw6RnHPmqge4sH-3HGFXJ3tY_-Q20-pWfxgcwZ_iCHcywcfCEFAy",
	taxiclockin = "https://discord.com/api/webhooks/787685514333126716/7J7WX3euhWUTX9eyVgQrzsmAw5TT8oCexwbNdY37SxfXl9w2gNMBSBUJQpk-g3gLHojn",
	mechclockin = "https://discord.com/api/webhooks/787685676757155891/Vxt68Y6SG9xEdHFMX11wsACQ72Nbl1eVpP9u0mtwpCWo8mlXkgdFP4fpuQbN98xY9H8N",
	darkspiderlogger = "https://discord.com/api/webhooks/787685844420001812/DX2RvxRhiots2oUuXPsSI9YEmLTXss3WrVnSyjvKVNgM7HlSsmv8Pdj6YcWSq5p_JyCk",
	pawnlog = "https://discord.com/api/webhooks/787685999496659015/bYOQdKUSjyw5R2qHOBq8luR5LC5_Voq_if9xWyr-NGP4H0be8mB6N-fZEfyNVnmxpZ4Q",
	tuners = "https://discord.com/api/webhooks/787686136834162728/DvcZZT2vunUCorbjst078PLzWmaMKO_4DHQ7Gh6XZcLp_3D8QpeLLi9Bw-eN1WdNG_0f",
	test = "https://discord.com/api/webhooks/823812078195965993/riigCZX6ohcF2YKNYYw3jDf4iiEUoR4bM03Out296Vi42u2MebAdy0_vq6ixXn5EJ_kN",
	tax = "https://discord.com/api/webhooks/835209172982169660/QImpH0cPTtuS61dp4DW2tS4VKBaiGnPAePGiycI5FgGFrbl6A6cfN9WC8I2K9WydMp8o",
	policearmoury = "https://discord.com/api/webhooks/837827983854010398/U3VOmxBlkTJyRB6J9YCBxCP9iCPGWXwl-4TvMw5QZ2v3Q3_h0fgcCp-8p8NFnwvwyBYp",
	resources = "<DISCORD_WEBHOOK>",

  -- You can add more logs by using exports in other resources
  -- When the action is done call the function below in the script to send the information to JD_logs
  -- exports.JD_logs:discord('<MESSAGE_YOU_WANT_TO_POST_IN_THE_EMBED>', '1752220', '<WEBHOOK_CHANNEL>')
  -- Then create a webhook for the action you just executed
  -- <YOUR NEW WEBHOOK NAME> = "<DISCORD_WEBHOOK>",
  -- How you add more logs is explained on https://docs.jokedevil.com/JD_logs
  }

 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.1.0"
