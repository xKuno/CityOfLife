local IndicatorL = false
local IndicatorR = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(1, 174) then -- left (Default Button = Left Arrow)
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				TriggerEvent('Indicator', 'left')
			end
		end

		if IsControlJustPressed(1, 175) then --right (Default Button = Right Arrow)
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				TriggerEvent('Indicator', 'right')
			end
		end

		if IsControlJustPressed(1, 246) then --hazard (Default button = Y)
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				TriggerEvent('Indicator', 'right')
				TriggerEvent('Indicator', 'left')
			end
		end
    end
end)

AddEventHandler('Indicator', function(dir)
	Citizen.CreateThread(function()
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped, true) then
			local Veh = GetVehiclePedIsIn(Ped, false)
			if GetPedInVehicleSeat(Veh, -1) == Ped then
				if dir == 'left' then
					IndicatorL = not IndicatorL
					TriggerServerEvent('IndicatorL', IndicatorL)
				elseif dir == 'right' then
					IndicatorR = not IndicatorR
					TriggerServerEvent('IndicatorR', IndicatorR)
				end
			end
		end
	end)
end)

RegisterNetEvent('updateIndicators')
AddEventHandler('updateIndicators', function(PID, dir, Toggle)
	--if isPlayerOnline(PID) then
		local Veh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false)
		if dir == 'left' then
			SetVehicleIndicatorLights(Veh, 1, Toggle)
		elseif dir == 'right' then
			SetVehicleIndicatorLights(Veh, 0, Toggle)
		end
	--end
end)
