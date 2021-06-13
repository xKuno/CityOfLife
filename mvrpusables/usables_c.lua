ESX          = nil
local IsDead = false
local IsHandcuffed = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer 
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)



RegisterNetEvent('mvrp_usables:oxygen_mask')
AddEventHandler('mvrp_usables:oxygen_mask', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	
	ESX.Game.SpawnObject('p_s_scuba_mask_s', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		ESX.Game.SpawnObject('p_michael_scuba_tank_s', {
			x = coords.x,
			y = coords.y,
			z = coords.z - 3
		}, function(object2)
			AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			SetPedDiesInWater(playerPed, false)
			
			ESX.ShowNotification(_U('dive_suit_on') .. '%.')
			Citizen.Wait(50000)
			ESX.ShowNotification(_U('oxygen_notify', '~y~', '50') .. '%.')
			Citizen.Wait(25000)
			ESX.ShowNotification(_U('oxygen_notify', '~o~', '25') .. '%.')
			Citizen.Wait(25000)
			ESX.ShowNotification(_U('oxygen_notify', '~r~', '0') .. '%.')
			
			SetPedDiesInWater(playerPed, true)
			DeleteObject(object)
			DeleteObject(object2)
			ClearPedSecondaryTask(playerPed)
		end)
	end)
end)

RegisterNetEvent('mvrp_usables:oxygen_masklarge')
AddEventHandler('mvrp_usables:oxygen_masklarge', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	
	ESX.Game.SpawnObject('p_s_scuba_mask_s', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		ESX.Game.SpawnObject('p_s_scuba_tank_s', {
			x = coords.x,
			y = coords.y,
			z = coords.z - 3
		}, function(object2)
			AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			SetPedDiesInWater(playerPed, false)
			
			ESX.ShowNotification(_U('dive_suit_on') .. '%.')
			Citizen.Wait(50000)
			ESX.ShowNotification(_U('oxygen_notify', '~y~', '75') .. '%.')
			Citizen.Wait(50000)
			ESX.ShowNotification(_U('oxygen_notify', '~o~', '50') .. '%.')
			Citizen.Wait(50000)
			ESX.ShowNotification(_U('oxygen_notify', '~r~', '25') .. '%.')
			Citizen.Wait(50000)
			ESX.ShowNotification(_U('oxygen_notify', '~r~', '0') .. '%.')
			Citizen.Wait(50000)
			
			SetPedDiesInWater(playerPed, true)
			DeleteObject(object)
			DeleteObject(object2)
			ClearPedSecondaryTask(playerPed)
		end)
	end)
end)


local gasMaskOn = false
local damageTime = 0

RegisterNetEvent("esx_gasmask:useItem")
AddEventHandler("esx_gasmask:useItem", function()
        local animdict = 'mp_masks@on_foot'
        local animname = 'put_on_mask'
        local playerped = PlayerPedId()
        ESX.Streaming.RequestAnimDict(animdict, function()
            TaskPlayAnim(playerped, animdict, animname, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
        Wait(260)
        if not gasMaskOn then
            TriggerEvent("skinchanger:getSkin", function(skin)
                skin.mask_1 = 46
                skin.mask_2 = 0
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
            gasMaskOn = true
            SetEntityProofs(playerped, false, false, false, false, false, false, true, true, false)

        else
            TriggerEvent("skinchanger:getSkin", function(skin)
                skin.mask_1 = 0
                skin.mask_2 = 0
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
            gasMaskOn = false
            SetEntityProofs(playerped, false, false, false, false, false, false, false, false, false)
        end


end)

RegisterNetEvent('mvrp_usables:rollingpaper')
AddEventHandler('mvrp_usables:rollingpaper', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 18905)
	local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

	RequestAnimDict("anim@amb@business@weed@weed_sorting_seated@")
	while not HasAnimDictLoaded("anim@amb@business@weed@weed_sorting_seated@") do
		Citizen.Wait(1)
	end
	
	ESX.Game.SpawnObject('bkr_prop_weed_bud_pruned_01a', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		TaskPlayAnim(playerPed, "anim@amb@business@weed@weed_sorting_seated@", "sorter_right_sort_v3_sorter02", 8.0, -8, -1, 49, 0, 0, 0, 0)
		AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
		Citizen.Wait(6500)
		DeleteObject(object)
		ClearPedSecondaryTask(playerPed)
	end)
end)

RegisterNetEvent('mvrp_usables:shroom')
AddEventHandler('mvrp_usables:shroom', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 18905)
	local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

	RequestAnimDict("anim@amb@business@weed@weed_sorting_seated@")
	while not HasAnimDictLoaded("anim@amb@business@weed@weed_sorting_seated@") do
		Citizen.Wait(1)
	end
	
	ESX.Game.SpawnObject('bkr_prop_weed_bud_pruned_01a', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		TaskPlayAnim(playerPed, "anim@amb@business@weed@weed_sorting_seated@", "sorter_right_sort_v3_sorter02", 8.0, -8, -1, 49, 0, 0, 0, 0)
		AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
		Citizen.Wait(6500)
		DeleteObject(object)
		ClearPedSecondaryTask(playerPed)
	end)
end)

RegisterNetEvent('mvrp_usables:ozshroom')
AddEventHandler('mvrp_usables:ozshroom', function()
  
  local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "lmaoshroom", 0.4)
	Citizen.Wait(1000)
	TriggerEvent('esx_drugeffect:runMan')
	Citizen.Wait(600000)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "fartsss", 0.4)
end)

RegisterNetEvent('esx_drugeffect:runMan')
AddEventHandler('esx_drugeffect:runMan', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
    onDrugs = true
	count = 0
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(PlayerPedId(), true)
    SetTimecycleModifier("spectator5")
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry_butch@b", true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.4)
    DoScreenFadeIn(1000)
	repeat
	ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
		Citizen.Wait(10000)
		count = count  + 1
	until count == 6
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(PlayerPedId(), 0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    ClearAllPedProps(PlayerPedId(), true)
    SetPedMotionBlur(PlayerPedId(), false)
	exports['mythic_notify']:SendAlert('inform', 'You Have shit yourself. Drugs are bad')
    onDrugs = false
end)

RegisterNetEvent('mvrp_usables:ramen')
AddEventHandler('mvrp_usables:ramen', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 18905)
	local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

	RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
		Citizen.Wait(1)
	end
	
	ESX.Game.SpawnObject('prop_ff_noodle_01', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
		AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
		Citizen.Wait(6500)
		DeleteObject(object)
		ClearPedSecondaryTask(playerPed)
	end)
end)


RegisterNetEvent('mvrp_usables:carcleankit')
AddEventHandler('mvrp_usables:carcleankit', function()
	local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification('Get out lazy shit')
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					-- exports['t0sic_loadingbar']:loadingbar ('Tvättar Fordon...', 10000)
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification('Vehicle has been ~g~cleaned~s~')
					isBusy = false
				end)
			else
				ESX.ShowNotification('There is no vehicle nearby')
			end
end)



AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
end)


RegisterNetEvent('esx_repairkit:onUse')
AddEventHandler('esx_repairkit:onUse', function()
	local playerPed		= PlayerPedId()
	local coords		= GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local attempt = 0

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			if Config.IgnoreAbort then
				print("Checked")
			end
			SetVehicleDoorOpen(vehicle, 4)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "Repairing engine",
				duration = 15000,
				label = "Using zipties and superglue",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
				},
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
				end
			--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				--exports["t0sic_loadingbar"]:StartDelayedFunction('Using zipties and superglue', 20000, function()

					if CurrentAction ~= nil then
						if GetVehicleEngineHealth(targetVehicle) < 200.0 then
                            SetVehicleEngineHealth(targetVehicle, 605.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end
                        if GetEntityModel(targetVehicle) == `BLAZER` then
                            SetVehicleEngineHealth(targetVehicle, 600.0)
                            SetVehicleBodyHealth(targetVehicle, 800.0)
						end
					end
	
					ClearPedTasksImmediately(playerPed)
					SetVehicleDoorShut(vehicle, 4)


					TriggerServerEvent('esx_repairkit:removeKit')

				CurrentAction = nil
				TerminateThisThread()
			end)
		end)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				exports['mythic_notify']:SendAlert('inform', 'Press X to cancel', 5000)

				if IsControlJustReleased(0, 73) then
					TerminateThread(ThreadID)
					exports['mythic_notify']:SendAlert('inform', 'Repair canceled', 6000)
					CurrentAction = nil
				end
			end

		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'No vehicle near-by', 6000)
	end
end)


RegisterNetEvent('esx_tyrekit:onUse')
AddEventHandler('esx_tyrekit:onUse', function()
	local playerPed		= PlayerPedId()
	local coords		= GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local attempt = 0

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			if Config.IgnoreAbort then
				print("Checked")
			end
			TriggerEvent("mythic_progbar:client:progress", {
				name = "Replacing tire",
				duration = 22000,
				label = "Replacing tire",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
					anim = "machinic_loop_mechandplayer",
				},
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
				end
			--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				--exports["t0sic_loadingbar"]:StartDelayedFunction('Repairing tire', 20000, function()

				if CurrentAction ~= nil then
					if IsVehicleTyreBurst(vehicle, 0) or IsVehicleTyreBurst(vehicle, 1) or IsVehicleTyreBurst(vehicle, 2) or IsVehicleTyreBurst(vehicle, 3) or IsVehicleTyreBurst(vehicle, 4) or IsVehicleTyreBurst(vehicle, 5) or IsVehicleTyreBurst(vehicle, 45) or IsVehicleTyreBurst(vehicle, 47) then
					
					SetVehicleTyreFixed(vehicle, 0)
					SetVehicleTyreFixed(vehicle, 1)
					SetVehicleTyreFixed(vehicle, 2)
					SetVehicleTyreFixed(vehicle, 3)
					SetVehicleTyreFixed(vehicle, 4)
					SetVehicleTyreFixed(vehicle, 5)
					SetVehicleTyreFixed(vehicle, 45)
					SetVehicleTyreFixed(vehicle, 47)
					ClearPedTasksImmediately(playerPed)

					exports['mythic_notify']:SendAlert('success', 'You have repaired your tyre', 7000)
				else				
					exports['mythic_notify']:SendAlert('error', 'It looks like your tyres are fine!', 7000)
					ClearPedTasks(PlayerPedId())
				end


					TriggerServerEvent('esx_tyrekit:removeKit')


				CurrentAction = nil
				TerminateThisThread()
				end
			end)
		end)
	end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				exports['mythic_notify']:SendAlert('inform', 'Press X to cancel', 5000)

				if IsControlJustReleased(0, 73) then
					TerminateThread(ThreadID)
					exports['mythic_notify']:SendAlert('inform', 'Repair canceled', 6000)
					CurrentAction = nil
				end
			end

		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'No vehicle near-by', 6000)
	end
end)

RegisterNetEvent('esx_adv-repairkit:onUse')
AddEventHandler('esx_adv-repairkit:onUse', function()
	local playerPed		= PlayerPedId()
	local coords		= GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local attempt = 0

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			if Config.IgnoreAbort then
				print("Checked")
			end
			SetVehicleDoorOpen(vehicle, 4)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "Repairing engine",
				duration = 22000,
				label = "Repairing Engine",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "mini@repair",
					anim = "fixing_a_ped",
				},
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
				end
			--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'
				--exports["t0sic_loadingbar"]:StartDelayedFunction('Repairing engine', 20000, function()

				if CurrentAction ~= nil then
					TriggerEvent('veh.randomDegredation',30,vehicle,3)
					if GetVehicleEngineHealth(vehicle) < 900.0 then
							SetVehicleEngineHealth(vehicle, 900.0)
							SetVehiclePetrolTankHealth(vehicle, 800.0)
                        end
                        if GetVehicleBodyHealth(vehicle) < 945.0 then
							SetVehicleBodyHealth(vehicle, 945.0)
							SetVehiclePetrolTankHealth(vehicle, 800.0)

							SetVehicleTyreFixed(vehicle, 0)
							SetVehicleTyreFixed(vehicle, 1)
							SetVehicleTyreFixed(vehicle, 2)
							SetVehicleTyreFixed(vehicle, 3)
							SetVehicleTyreFixed(vehicle, 4)
							SetVehicleTyreFixed(vehicle, 5)
							SetVehicleTyreFixed(vehicle, 45)
							SetVehicleTyreFixed(vehicle, 47)

						end
						
				end

				ClearPedTasksImmediately(playerPed)
				SetVehicleDoorShut(vehicle, 4)


				TriggerServerEvent('esx_adv-repairkit:removeKit')


				CurrentAction = nil
				TerminateThisThread()
			end)
		end)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				exports['mythic_notify']:SendAlert('inform', 'Press X to cancel', 5000)
				if IsControlJustReleased(0, 73) then
					TerminateThread(ThreadID)
					exports['mythic_notify']:SendAlert('inform', 'Repair canceled', 6000)
					CurrentAction = nil
				end
			end

		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'No vehicle near-by', 6000)
	end
end)


RegisterNetEvent('esx_dentpuller:onUse')
AddEventHandler('esx_dentpuller:onUse', function()
	local playerPed		= PlayerPedId()
	local coords		= GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local attempt = 0

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			if Config.IgnoreAbort then
				print("Checked")
			end
			TriggerEvent("mythic_progbar:client:progress", {
				name = "Pulling out dents",
				duration = 22000,
				label = "Using the dent puller",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
					anim = "machinic_loop_mechandplayer",
				},
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
				end
			--TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				--exports["t0sic_loadingbar"]:StartDelayedFunction('Pulling out dents', 20000, function()

				if CurrentAction ~= nil then				
					SetVehicleDeformationFixed(vehicle)
					ClearPedTasksImmediately(playerPed)

					exports['mythic_notify']:SendAlert('success', 'You removed all the dents, Nice work!', 7000)
					TriggerServerEvent('esx_dentpuller:removeKit')
				end

					TriggerServerEvent('esx_dentpuller:removeKit')


				CurrentAction = nil
				TerminateThisThread()
			end)
		end)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				exports['mythic_notify']:SendAlert('inform', 'Press X to cancel', 5000)

				if IsControlJustReleased(0, 73) then
					TerminateThread(ThreadID)
					exports['mythic_notify']:SendAlert('inform', 'Repair canceled', 6000)
					CurrentAction = nil
				end
			end

		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'No vehicle near-by', 6000)
	end
end)

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
	local vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
		if IsPedGettingIntoAVehicle(PlayerPedId()) then
			NetworkRequestControlOfEntity(vehicle)
		end		        
	end
end)

function UpdateAmmo(ped, currentWeaponHash, ammoCount)
	local weapon = ESX.GetWeaponFromHash(currentWeaponHash)
	if weapon then
		TriggerServerEvent('mvrp_usables:addWeaponAmmo', weapon.name, ammoCount)
	end
end

RegisterNetEvent('mvrp_usables:pAmmo')
AddEventHandler('mvrp_usables:pAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "pAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!')
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_PISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_COMBATPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_PISTOL_MK2` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_PISTOL50` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_SNSPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_HEAVYPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_VINTAGEPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_REVOLVER` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
		exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
	elseif currentWeaponHash == `WEAPON_DOUBLEACTION` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
		exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
	elseif currentWeaponHash == `WEAPON_MARKSMANPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
		exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    elseif currentWeaponHash == `WEAPON_APPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
        exports['mythic_notify']:SendAlert('inform', 'Added 24 more Pistol ammo')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)

RegisterNetEvent('mvrp_usables:mgAmmo')
AddEventHandler('mvrp_usables:mgAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "mgAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!')
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_MICROSMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_MACHINEPISTOL` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_SMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_ASSAULTSMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_COMBATPDW` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_MG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_COMBATMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_GUSENBERG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    elseif currentWeaponHash == `WEAPON_MINISMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 45)
        exports['mythic_notify']:SendAlert('inform', 'Added 45 more Machine Gun ammo')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)

RegisterNetEvent('mvrp_usables:smgAmmo')
AddEventHandler('mvrp_usables:smgAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "smgAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!')
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_MINISMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more SMG ammo')
    elseif currentWeaponHash == `WEAPON_SMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more SMG ammo')
    elseif currentWeaponHash == `WEAPON_MICROSMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more SMG ammo')
    elseif currentWeaponHash == `WEAPON_ASSAULTSMG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more SMG ammo')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)

RegisterNetEvent('mvrp_usables:arAmmo')
AddEventHandler('mvrp_usables:arAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "arAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!')
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_ASSAULTRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
    elseif currentWeaponHash == `WEAPON_CARBINERIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
    elseif currentWeaponHash == `WEAPON_ADVANCEDRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
    elseif currentWeaponHash == `WEAPON_SPECIALCARBINE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
    elseif currentWeaponHash == `WEAPON_BULLPUPRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
        exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
    elseif currentWeaponHash == `WEAPON_COMPACTRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
		exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
	elseif currentWeaponHash == `WEAPON_MARKSMANRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 60)
		exports['mythic_notify']:SendAlert('inform', 'Added 60 more Assault Rifle ammo')
	elseif currentWeaponHash == `WEAPON_HEAVYSNIPER` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
		exports['mythic_notify']:SendAlert('inform', 'Added 24 more Assault Rifle ammo')
	elseif currentWeaponHash == `WEAPON_SNIPERRIFLE` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 24)
		exports['mythic_notify']:SendAlert('inform', 'Added 24 more Assault Rifle ammo')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)

RegisterNetEvent('mvrp_usables:sgAmmo')
AddEventHandler('mvrp_usables:sgAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "sgAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!') 
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_PUMPSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_SAWNOFFSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_DBSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_BULLPUPSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_ASSAULTSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_MUSKET` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_HEAVYSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_DOUBLEBARRELSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    elseif currentWeaponHash == `WEAPON_AUTOSHOTGUN` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 12)
        exports['mythic_notify']:SendAlert('inform', 'Added 12 more Shotgun ammo')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)


RegisterNetEvent('mvrp_usables:rpe')
AddEventHandler('mvrp_usables:rpe', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "rpe"

    if(ammo >= 250 or ammo + 50 > 250) then
        exports['mythic_notify']:SendAlert('inform', 'Your weapon ammo is already maxed!') 
        TriggerServerEvent('returnItem', item)
        return
    end

    if currentWeaponHash == `WEAPON_RPG` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 1)
        exports['mythic_notify']:SendAlert('inform', 'Added 1 RPE') 
    elseif currentWeaponHash == `WEAPON_FIREWORK` then
        exports['progressBars']:startUI(2000, "Reloading")
        Citizen.Wait(2000)
        AddAmmoToPed(ped, currentWeaponHash, 1)
        exports['mythic_notify']:SendAlert('inform', 'Added 1 RPE')
    else
        exports['mythic_notify']:SendAlert('inform', 'This weapon is not compatible with this ammo')
        TriggerServerEvent('returnItem', item)
		return
	end
	local newammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
	local ammoCount = newammo - ammo
	UpdateAmmo(ped, currentWeaponHash, ammoCount)
end)



RegisterNetEvent('esx_armour:armour')
AddEventHandler('esx_armour:armour', function() 
	exports['mythic_progbar']:Progress({
        name = "firstaid_action",
        duration = 3000,
        label = "Using Armour",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "oddjobs@basejump@ig_15",
            anim = "puton_parachute",
            flags = 49,
        },
    }, function(status)
        if not status then
            local playerPed = PlayerPedId()
			Citizen.CreateThread(function()
			SetPedArmour(playerPed, 100)
			end)
		end
	end)
end)

RegisterNetEvent("fn_cuff_item:checkCuff")
AddEventHandler("fn_cuff_item:checkCuff", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        ESX.TriggerServerCallback("fn_cuff_item:isCuffed",function(cuffed)
            if not cuffed then
                TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 8.0, -8, 4000, 48, 0, 0, 0, 0) 
                TriggerServerEvent("fn_cuff_item:handcuff",GetPlayerServerId(player),true)
            else
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8, 5000, 49, 0, 0, 0, 0)
                TriggerServerEvent("fn_cuff_item:handcuff",GetPlayerServerId(player),false)
            end
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'busted', 1.0)
        end,GetPlayerServerId(player))
    else
        ESX.ShowNotification("~r~No players nearby!")
    end
end)

RegisterNetEvent("fn_cuff_item:uncuff")
AddEventHandler("fn_cuff_item:uncuff",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("fn_cuff_item:uncuff",GetPlayerServerId(player))
    else
        ESX.ShowNotification("~r~No players nearby")
    end
end)

RegisterNetEvent('fn_cuff_item:forceUncuff')
AddEventHandler('fn_cuff_item:forceUncuff',function()
    IsHandcuffed = false
    local playerPed = PlayerPedId()
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)
end)

RegisterNetEvent("fn_cuff_item:handcuff")
AddEventHandler("fn_cuff_item:handcuff",function()
    local playerPed = PlayerPedId()
    IsHandcuffed = not IsHandcuffed
    Citizen.CreateThread(function()
        if IsHandcuffed then
            ClearPedTasks(playerPed)
            SetPedCanPlayAmbientBaseAnims(playerPed, true)

            Citizen.Wait(10)
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(100)
            end
            RequestAnimDict('mp_arrest_paired')
            while not HasAnimDictLoaded('mp_arrest_paired') do
                Citizen.Wait(100)
            end
			TaskPlayAnim(playerPed, "mp_arrest_paired", "crook_p2_back_right", 8.0, -8, -1, 32, 0, 0, 0, 0)
			Citizen.Wait(5000)
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
        else
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            DisplayRadar(true)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsHandcuffed then
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
            DisableControlAction(0, 140, true)
        end
        if not IsHandcuffed and not IsControlEnabled(0, 140) then EnableControlAction(0, 140, true) end
    end
end)

Citizen.CreateThread(function()
    local wasgettingup = false
    while true do
        Citizen.Wait(250)
        if IsHandcuffed then
            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3) or (wasgettingup and not IsPedGettingUp(ped)) then ESX.Streaming.RequestAnimDict("mp_arresting", function() TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0) end) end
            wasgettingup = IsPedGettingUp(ped)
        end
    end
end)

