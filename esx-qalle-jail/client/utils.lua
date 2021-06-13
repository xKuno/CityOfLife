RegisterCommand("jailmenu", function(source, args)

	if PlayerData.job.name == "police" then
		OpenJailMenu()
	else
		ESX.ShowNotification("You are not an officer!")
	end
end)

function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function Cutscene()
	DoScreenFadeOut(100)

	Citizen.Wait(250)

	local Male = `mp_m_freemode_01`
	local Female = `mp_f_freemode_01`
	local Model = GetEntityModel(PlayerPedId())

	TriggerEvent('skinchanger:getSkin', function(skin)
		if Model == Male then
				skin['tshirt_1'] = 15  
				skin['tshirt_2'] = 0 
				skin['torso_1'] = 5 
				skin['arms'] = 5
				skin['torso_2'] = 0 
				skin['decals_1'] = 0   
				skin['decals_2']= 0 
				skin['pants_1'] = 9  
				skin['pants_2'] = 4 
				skin['glasses_1'] = 0  
				skin['glasses_2'] = 0 
				skin['shoes_1'] = 42  
				skin['shoes_2'] = 2 
				skin['ears_1'] = -1  
				skin['ears_2'] = 0 
				skin['bproof_1'] = -1 
				skin['bproof_2'] = 0 
				skin['chain_1'] = 0  
				skin['chain_2'] = 0 
				skin['bags_1'] = 0  
				skin['bags_2'] = 0 
				skin['helmet_1'] 	= -1  
				skin['helmet_2'] = 0 
				skin['bracelets_1'] = -1  
				skin['bracelets_2'] = 0 
				skin['watches_1'] 	= -1  
				skin['watches_2'] = 0 
				
			TriggerEvent('skinchanger:loadSkin', skin)
		elseif Model == Female then
			skin['tshirt_1'] = 15  
			skin['tshirt_2'] = 0 
			skin['torso_1'] = 5 
			skin['arms'] = 5
			skin['torso_2'] = 0 
			skin['decals_1'] = 0   
			skin['decals_2']= 0 
			skin['pants_1'] = 9  
			skin['pants_2'] = 4 
			skin['glasses_1'] = 0  
			skin['glasses_2'] = 0 
			skin['shoes_1'] = 42  
			skin['shoes_2'] = 2 
			skin['ears_1'] = -1  
			skin['ears_2'] = 0 
			skin['bproof_1'] = -1 
			skin['bproof_2'] = 0 
			skin['chain_1'] = 0  
			skin['chain_2'] = 0 
			skin['bags_1'] = 0  
			skin['bags_2'] = 0 
			skin['helmet_1'] 	= -1  
			skin['helmet_2'] = 0 
			skin['bracelets_1'] = -1  
			skin['bracelets_2'] = 0 
			skin['watches_1'] 	= -1  
			skin['watches_2'] = 0 
			TriggerEvent('skinchanger:loadSkin', skin)
		end
	end)

	LoadModel(-1320879687)

	local PolicePosition = Config.Cutscene["PolicePosition"]
	local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)
	TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)

	local PlayerPosition = Config.Cutscene["PhotoPosition"]
	local PlayerPed = PlayerPedId()
	SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
	SetEntityHeading(PlayerPed, PlayerPosition["h"])
	FreezeEntityPosition(PlayerPed, true)

	Cam()

	Citizen.Wait(1000)

	DoScreenFadeIn(100)

	Citizen.Wait(10000)

	DoScreenFadeOut(250)

	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPed, JailPosition["x"], JailPosition["y"], JailPosition["z"])
	DeleteEntity(Police)
	SetModelAsNoLongerNeeded(-1320879687)

	Citizen.Wait(1000)

	DoScreenFadeIn(250)

	TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.3)

	RenderScriptCams(false,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPed, false)
	DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])

	InJail()
end

function Cam()
	local CamOptions = Config.Cutscene["CameraPos"]

	CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
	SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])

	RenderScriptCams(true, false, 0, true, true)
end

function TeleportPlayer(pos)

	local Values = pos

	if #Values["goal"] > 1 then

		local elements = {}

		for i, v in pairs(Values["goal"]) do
			table.insert(elements, { label = v, value = v })
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'teleport_jail',
			{
				title    = "Choose Position",
				align    = 'center',
				elements = elements
			},
		function(data, menu)

			local action = data.current.value
			local position = Config.Teleports[action]

			if action == "Boiling Broke" or action == "Security" then

				if PlayerData.job.name ~= "police" then
					ESX.ShowNotification("You don't have an key to go here!")
					return
				end
			end

			menu.close()

			DoScreenFadeOut(100)

			Citizen.Wait(250)

			SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])

			Citizen.Wait(250)

			DoScreenFadeIn(100)
			
		end,

		function(data, menu)
			menu.close()
		end)
	else
		local position = Config.Teleports[Values["goal"][1]]

		DoScreenFadeOut(100)

		Citizen.Wait(250)

		SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])

		Citizen.Wait(250)

		DoScreenFadeIn(100)
	end
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Teleports["Boiling Broke"]["x"], Config.Teleports["Boiling Broke"]["y"], Config.Teleports["Boiling Broke"]["z"])

    SetBlipSprite (blip, 188)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 49)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Boilingbroke Penitentiary')
    EndTextCommandSetBlipName(blip)
end)