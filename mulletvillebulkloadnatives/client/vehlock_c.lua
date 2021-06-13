ESX               = nil

local isRunningWorkaround = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function StartWorkaroundTask()
	if isRunningWorkaround then
		return
	end

	local timer = 0
	local playerPed = PlayerPedId()
	isRunningWorkaround = true

	while timer < 100 do
		Citizen.Wait(0)
		timer = timer + 1

		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if lockStatus == 2 then
				ClearPedTasks(playerPed)
			end
		end
	end

	isRunningWorkaround = false
end

function ToggleVehicleLock()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	Citizen.CreateThread(function()
		StartWorkaroundTask()
	end)

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)  -- Fix can't lock Emergency Vehicles
	end

	if not DoesEntityExist(vehicle) then
		return
	end

	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)
			local dict = "anim@mp_player_intmenu@key_fob@"
             RequestAnimDict(dict)
             
			if lockStatus == 1 then -- unlocked
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				Citizen.Wait(500)
				SetVehicleDoorsLocked(vehicle, 2)
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'carlock', 0.1)
				SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 0)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 0)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 0)


			elseif lockStatus == 2 then -- locked
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				Citizen.Wait(500)
				SetVehicleDoorsLocked(vehicle, 1)
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'carlock', 0.1)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 0)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SetVehicleLights(vehicle, 0)
                Citizen.Wait(150)
                SoundVehicleHornThisFrame(vehicle)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(150)
                SoundVehicleHornThisFrame(vehicle)
                Citizen.Wait(5000)
                SetVehicleLights(vehicle, 0)
			end
		end

	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

local commandEnabled = true

Citizen.CreateThread(function()
    if commandEnabled --[[and IsInputDisabled(0)]] then
        RegisterCommand('lockcar', function()
            ToggleVehicleLock()
        end, false)
    end
end)


RegisterKeyMapping('lockcar', 'Toggle Vehcile lock', 'keyboard', 'l')