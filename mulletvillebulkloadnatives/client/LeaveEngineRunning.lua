
local commandEnabled = true

Citizen.CreateThread(function()
    if commandEnabled then
        RegisterCommand('engine', function() 
            toggleEngine()
        end, false)
    end
end)


function toggleEngine()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        if (GetIsVehicleEngineRunning(vehicle)) then
            exports['mythic_notify']:SendAlert('inform', 'You switched off the engine!', 5000)
        else
            exports['mythic_notify']:SendAlert('inform', 'You switched on the engine!', 5000)
        end
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end

RegisterKeyMapping('engine', 'Toggle Engine', 'keyboard', 'm')

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()

		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			local veh = GetVehiclePedIsIn(ped, true)
			local engineWasRunning = GetIsVehicleEngineRunning(veh)
			if engineWasRunning then
				SetVehicleEngineOn(veh, true, true, true)
			end

			Citizen.Wait(200)
		end
	end
end)