local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false
local IsDragged                 = false
local CopPed                    = 0

function OpenAmbulanceActionsMenu()
	local elements = {
		--{label = _U('cloakroom'), value = 'cloakroom'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
				menu.close()
			end, {wash = false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'bottom-right',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'bottom-right',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_putincar'), value = 'put_in_vehicle'},
					{label = _U('ems_menu_pulloutcar'), value = 'pull_out_vehicle'},
					{label = _U('ems_menu_drag'), value = 'drag_player'},
					{label = "Un-drag player", value = 'un_drag'},

				}
			}, function(data, menu)
				if IsBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification(_U('no_players'))
				else

					if data.current.value == 'revive' then

						IsBusy = true

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)

								if IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_b", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_c", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_e", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_f", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_g", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_h", 3)then
									local playerPed = PlayerPedId()
									

									exports['mythic_notify']:SendAlert('error', 'Revive is in progress!', 8000)

									--[[ local lib, anim = 'amb@medic@standing@tendtodead@base', 'base'

									for i=1, 15, 1 do
										Citizen.Wait(900)
								
										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
										end)
									end ]]
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									local reward = Config.ReviveReward
									local pCoords = GetEntityCoords(PlayerPedId())
									local pillbox = vector3(316.043, -588.6526, 43.2841)
									local sandy = vector3(1833.247, 3682.883, 34.50759)
									local pillboxDistance = #(pCoords - pillbox)
									local sandyDistance = #(pCoords - sandy)
									if pillboxDistance < sandyDistance then dist = pillboxDistance else dist = sandyDistance end
									if dist > 15 then
										local math = (reward * ((dist - 14) / 600))
										reward = reward - math
									end
									if reward > Config.ReviveReward then reward = Config.ReviveReward elseif reward < 1000 then reward = 1000 end
									reward = ESX.Math.Round(reward)
					 
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('tp_ambulancejob:revive', GetPlayerServerId(closestPlayer), dist)

									-- Show revive award?
									if reward > 0 then
										
                                        local reviveString = "you have revived someone and earned $"..reward.."!"
                                        exports['mythic_notify']:SendAlert('success', reviveString, 8000)
                                    else
                                        local reviveString = "you have revived someone!"
                                        exports['mythic_notify']:SendAlert('success', reviveString, 8000)
                                    end
                                else
                                    exports['mythic_notify']:SendAlert('error', 'Player not unconscious', 8000)
                                end
                            else
                                exports['mythic_notify']:SendAlert('error', 'Not enough medikits', 8000)
                            end

							IsBusy = false

						end, 'medikit')

					elseif data.current.value == 'small' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									exports['mythic_notify']:SendAlert('success', 'You are healing', 8000)
									--ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')

									local reviveString = "you have healed someone"
									exports['mythic_notify']:SendAlert('success', reviveString, 8000)
									--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									exports['mythic_notify']:SendAlert('error', 'Player not conscious', 8000)
								end
							else
								exports['mythic_notify']:SendAlert('error', 'Not enough bandages', 8000)
							end
							IsBusy = false
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
                                    exports['mythic_notify']:SendAlert('inform', 'you are healing!', 8000)
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									local revivePlayer = GetPlayerName(closestPlayer)
									local reviveString = "you have healed "..revivePlayer
									exports['mythic_notify']:SendAlert('success', reviveString, 8000)
									--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									exports['mythic_notify']:SendAlert('error', 'That player is not conscious!', 8000)
								end
							else
								exports['mythic_notify']:SendAlert('error', 'You dont have a medikit', 8000)
							end
							IsBusy = false
						end, 'medikit')

					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif data.current.value == 'pull_out_vehicle' then
						TriggerServerEvent('esx_ambulancejob:pullOutVehicle', GetPlayerServerId(closestPlayer))
					elseif data.current.value == 'drag_player' then
						TriggerServerEvent('esx_ambulancejob:drag', GetPlayerServerId(closestPlayer))
					elseif data.current.value == 'un_drag' then
						TriggerServerEvent('esx_ambulancejob:undrag', GetPlayerServerId(closestPlayer))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum
		
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			
			for hospitalNum,hospital in pairs(Config.Hospitals) do

				-- Ambulance Actions
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = GetDistanceBetweenCoords(playerCoords, v, true)

					if distance < Config.DrawDistance then
						DrawMarker(27, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < Config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
					end
				end


				-- Vehicle Spawners
				for k,v in ipairs(hospital.Vehicles) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(27, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
					end
				end

				-- Helicopter Spawners
				for k,v in ipairs(hospital.Helicopters) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(27, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
					end
				end

				-- Fast Travels
				for k,v in ipairs(hospital.FastTravels) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)

					if distance < Config.DrawDistance then
						DrawMarker(27, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, false, nil, nil, false)
						letSleep = false
					end


					if distance < v.Marker.x then
						FastTravel(v.To.coords, v.To.heading)
					end
				end

				-- Fast Travels (Prompt)
				for k,v in ipairs(hospital.FastTravelsPrompt) do
					local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)

					if distance < Config.DrawDistance then
						DrawMarker(27, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, false, nil, nil, false)
						letSleep = false
					end

					if distance < v.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k
					end
				end

			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Vehicles' then
			CurrentAction = part
			CurrentActionMsg = _U('garage_prompt')
			CurrentActionData = {hospital = hospital, partNum = partNum}
		elseif part == 'Helicopters' then
			CurrentAction = part
			CurrentActionMsg = _U('helicopter_prompt')
			CurrentActionData = {hospital = hospital, partNum = partNum}
		elseif part == 'FastTravelsPrompt' then
			local travelItem = Config.Hospitals[hospital][part][partNum]

			CurrentAction = part
			CurrentActionMsg = travelItem.Prompt
			CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then

				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
				elseif CurrentAction == 'Helicopters' then
					OpenHelicopterSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)
				end

				CurrentAction = nil

			end

		elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not IsDead then
			 if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end 
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

		if distance ~= -1 and distance <= 5.0 then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
		
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				if IsDragged then
					IsDragged = not IsDragged
				end
			end
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:pullOutVehicle')
AddEventHandler('esx_ambulancejob:pullOutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(cop)
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

RegisterNetEvent('esx_ambulancejob:un_drag')
AddEventHandler('esx_ambulancejob:un_drag', function(cop)
	IsDragged = not IsDragged
	DetachEntity(PlayerPedId(), true, false)
end)




Citizen.CreateThread(function()
	while true do
	  Wait(0)
		if IsDragged then
		  local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
		  local myped = PlayerPedId()
		  AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
		  --DetachEntity(PlayerPedId(), true, false) --Disabled to fix attatching...
		end
	end
  end)

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'bottom-right',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadClothes', skin)
			end)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleSpawnerMenu(hospital, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	local elements = {
		{label = _U('garage_storeditem'), action = 'garage'},
		{label = _U('garage_storeitem'), action = 'store_garage'},
		{label = _U('garage_buyitem'), action = 'buy_vehicle'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = _U('garage_title'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_vehicle' then
			local shopCoords = Config.Hospitals[hospital].Vehicles[partNum].InsideShop
			local shopElements = {}

			local authorizedVehicles = Config.AuthorizedVehicles[ESX.PlayerData.job.grade_name]

			if #authorizedVehicles > 0 then
				for k,vehicle in ipairs(authorizedVehicles) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
						name  = vehicle.label,
						model = vehicle.model,
						price = vehicle.price,
						type  = 'car'
					})
				end
			else
				return
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_boatshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = _U('garage_title'),
						align    = 'bottom-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Vehicles', partNum)

							if foundSpawn then
								menu2.close()

								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)

									TriggerServerEvent('esx_boatshop:setJobVehicleState', data2.current.vehicleProps.plate, false)

									exports['mythic_notify']:SendAlert('error', 'your vehicle has been released from the garage..', 8000)
									SetVehicleMod(vehicle, 12, 2)
	                                SetVehicleMod(vehicle, 13, 3)
	                                SetVehicleMod(vehicle, 16, 2)
	                                SetVehicleMod(vehicle, 17, 4)
	                                SetVehicleExtra(vehicle, 4, 0)
	                                SetVehicleExtra(vehicle, 5, 0)
	                                SetVehicleExtra(vehicle, 9, 0)
	                                SetVehicleExtra(vehicle, 1, 0)
	                                SetVehicleExtra(vehicle, 2, 0)
	                                SetVehicleExtra(vehicle, 11, 0)
									SetVehicleExtra(vehicle, 12, 0)
									SetVehicleDirtLevel(vehicle, 0.1)
								

	                                local plate = GetVehicleNumberPlateText(vehicle)
	                                TriggerServerEvent('garage:addKeys', plate)

									--ESX.ShowNotification(_U('garage_released'))
								end)
							end
						else
							exports['mythic_notify']:SendAlert('error', 'your vehicle is not stored in the garage.', 8000)
							--ESX.ShowNotification(_U('garage_notavailable'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					exports['mythic_notify']:SendAlert('error', 'You dont have any vehicles in your garage.', 8000)
				end
			end, 'car')

		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do

			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		exports['mythic_notify']:SendAlert('error', 'There is no nearby vehicles.', 8000)
		return
	end

	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)

			-- Workaround for vehicle not deleting when other players are near it.
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			IsBusy = false
			exports['mythic_notify']:SendAlert('success', 'The vehicle has been stored in your garage', 8000)
		else
			exports['mythic_notify']:SendAlert('success', 'No nearby owned vehicles were found', 8000)
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(hospital, part, partNum)
	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		exports['mythic_notify']:SendAlert('success', 'Please wait until the area is clear.', 8000)
		return false
	end
end

function OpenHelicopterSpawnerMenu(hospital, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	ESX.PlayerData = ESX.GetPlayerData()
	local elements = {
		{label = _U('helicopter_garage'), action = 'garage'},
		{label = _U('helicopter_store'), action = 'store_garage'},
		{label = _U('helicopter_buy'), action = 'buy_helicopter'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawner', {
		title    = _U('helicopter_title'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_helicopter' then
			local shopCoords = Config.Hospitals[hospital].Helicopters[partNum].InsideShop
			local shopElements = {}

			local authorizedHelicopters = Config.AuthorizedHelicopters[ESX.PlayerData.job.grade_name]

			if #authorizedHelicopters > 0 then
				for k,helicopter in ipairs(authorizedHelicopters) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(helicopter.label, _U('shop_item', ESX.Math.GroupDigits(helicopter.price))),
						name  = helicopter.label,
						model = helicopter.model,
						price = helicopter.price,
						type  = 'helicopter'
					})
				end
			else
				exports['mythic_notify']:SendAlert('error', 'you\'re not authorized to buy helicopters.', 8000)
				--ESX.ShowNotification(_U('helicopter_notauthorized'))
				return
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_boatshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_garage', {
						title    = _U('helicopter_garage_title'),
						align    = 'bottom-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Helicopters', partNum)

							if foundSpawn then
								menu2.close()

								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)

									local plate = GetVehicleNumberPlateText(vehicle)
	                                TriggerServerEvent('garage:addKeys', plate)

									TriggerServerEvent('esx_boatshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									exports['mythic_notify']:SendAlert('inform', 'Your vehicle has been released from the garage.', 8000)
                                    


								end)
							end
						else
							exports['mythic_notify']:SendAlert('inform', 'Your vehicle is not stored in the garage.', 8000)
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					exports['mythic_notify']:SendAlert('inform', 'You dont have any vehicles in your garage.', 8000)
				end
			end, 'helicopter')

		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'bottom-right',
			elements = {
				{ label = _U('confirm_no'), value = 'no' },
				{ label = _U('confirm_yes'), value = 'yes' }
			}
		}, function(data2, menu2)

			if data2.current.value == 'yes' then
				local newPlate = exports['boatshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
				
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
				
						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						exports['mythic_notify']:SendAlert('error', 'You cannot afford that vehicle', 8000)
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end

		end, function(data2, menu2)
			menu2.close()
		end)

		end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetEntityHeading(vehicle, 249.63229)
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetEntityHeading(vehicle, 249.63229)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('vehicleshop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end


function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		exports['mythic_notify']:SendAlert('error', 'No vehicles nearby', 8000)
	end
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		exports['mythic_notify']:SendAlert('error', 'You have been treated.', 8000)
	end
end)

RegisterNetEvent("tp:emsRevive")
AddEventHandler("tp:emsRevive", function()
	if IsBusy then return end

    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
        ESX.ShowNotification(_U('no_players'))
	else
					
    IsBusy = true
 
    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
        if quantity > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
 
            if IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_b", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_c", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_e", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_f", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_g", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_h", 3)then
                local playerPed = PlayerPedId()
               
 
                exports['mythic_notify']:SendAlert('error', 'Revive is in progress!', 8000)
 
 --[[                local lib, anim = 'amb@medic@standing@tendtodead@base', 'base'
 
                for i=1, 15, 1 do
                    Citizen.Wait(900)
           
                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    end)
				end ]]
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(playerPed)

				local reward = Config.ReviveReward
				local pCoords = GetEntityCoords(PlayerPedId())
				local pillbox = vector3(316.043, -588.6526, 43.2841)
				local sandy = vector3(1833.247, 3682.883, 34.50759)
				local pillboxDistance = #(pCoords - pillbox)
				local sandyDistance = #(pCoords - sandy)
				if pillboxDistance < sandyDistance then dist = pillboxDistance else dist = sandyDistance end
				if dist > 15 then
					local math = (reward * ((dist - 14) / 600))
					reward = reward - math
				end
				print(dist)
				print(reward)
				if reward > Config.ReviveReward then reward = Config.ReviveReward elseif reward < 1000 then reward = 1000 end
				reward = ESX.Math.Round(reward)
 
                TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                TriggerServerEvent('tp_ambulancejob:revive', GetPlayerServerId(closestPlayer), dist)
 
                -- Show revive award?
                if reward > 0 then
                    local reviveString = "you have revived someone and earned $"..reward.."!"
                    exports['mythic_notify']:SendAlert('success', reviveString, 8000)
                else
                    local reviveString = "you have revived someone!"
                    exports['mythic_notify']:SendAlert('success', reviveString, 8000)
                end
            else
                exports['mythic_notify']:SendAlert('error', 'Player not unconscious', 8000)
            end
        else
            exports['mythic_notify']:SendAlert('error', 'Not enough medikits', 8000)
        end
 
        IsBusy = false
 
	end, 'medikit')
end
end)

RegisterNetEvent("tp:emssmallheal")
AddEventHandler("tp:emssmallheal", function()
	if IsBusy then return end

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 2.0 then
                    ESX.ShowNotification(_U('no_players'))
				else
					
    IsBusy = true
 
	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			local health = GetEntityHealth(closestPlayerPed)
	
			if health > 0 then
				local playerPed = PlayerPedId()
	
				IsBusy = true
				exports['mythic_notify']:SendAlert('success', 'You are healing', 8000)
				--ESX.ShowNotification(_U('heal_inprogress'))
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(playerPed)
	
				TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
				TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
	
				local reviveString = "you have healed someone"
				exports['mythic_notify']:SendAlert('success', reviveString, 8000)
				--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
				IsBusy = false
			else
				exports['mythic_notify']:SendAlert('error', 'Player not conscious', 8000)
			end
		else
			exports['mythic_notify']:SendAlert('error', 'Not enough bandages', 8000)
		end
		IsBusy = false
	end, 'bandage')
end
end)

RegisterNetEvent("tp:emsbigheal")
AddEventHandler("tp:emsbigheal", function()
	if IsBusy then return end

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 2.0 then
                    ESX.ShowNotification(_U('no_players'))
				else
					
    IsBusy = true
 
	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			local health = GetEntityHealth(closestPlayerPed)

			if health > 0 then
				local playerPed = PlayerPedId()

				IsBusy = true
				exports['mythic_notify']:SendAlert('inform', 'you are healing!', 8000)
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(playerPed)

				TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
				TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
				local revivePlayer = GetPlayerName(closestPlayer)
				local reviveString = "you have healed "..revivePlayer
				exports['mythic_notify']:SendAlert('success', reviveString, 8000)
				--ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
				IsBusy = false
			else
				exports['mythic_notify']:SendAlert('error', 'That player is not conscious!', 8000)
			end
		else
			exports['mythic_notify']:SendAlert('error', 'You dont have a medikit', 8000)
		end
		IsBusy = false
	end, 'medikit')
end
end)

RegisterNetEvent("tp:emsputinvehicle")
AddEventHandler("tp:emsputinvehicle", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
    else
		--ESX.ShowNotification(_U('no_players_nearby'))
		TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:emstakeoutvehicle")
AddEventHandler("tp:emstakeoutvehicle", function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

		if distance ~= -1 and distance <= 5.0 then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			local passenger
			for i=maxSeats - 1, 0, -1 do
				if not IsVehicleSeatFree(vehicle, i) then
					passenger = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, i))
					break
				end
			end
		
			if passenger then
				TriggerServerEvent('esx_ambulancejob:pullOutVehicle', GetPlayerServerId(passenger))
			else
				TriggerServerEvent("tp:addChatSystem", "No players nearby")
			end
		end
	end
end)


RegisterNetEvent("tp:emsdrag")
AddEventHandler("tp:emsdrag", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_ambulancejob:drag', GetPlayerServerId(closestPlayer))
    else
		--ESX.ShowNotification(_U('no_players_nearby'))
		TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)

RegisterNetEvent("tp:emsundrag")
AddEventHandler("tp:emsundrag", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_ambulancejob:undrag', GetPlayerServerId(closestPlayer))
    else
		--ESX.ShowNotification(_U('no_players_nearby'))
		TriggerServerEvent("tp:addChatSystem", "No players nearby")
    end
end)