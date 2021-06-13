-------START Event Triggers-------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		-- If Left CTRL + 1 is pressed
		if IsControlPressed(0, 210) and IsControlJustPressed(0, 157) then 
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local class = GetVehicleClass(vehicle)
			
			if vehicle ~= 0 then --If player in vehicle
				if class == 18 then --If emergency vehicle
					TriggerServerEvent('codeOne', vehicle)
				end
			end
		end
		
		-- If Left CTRL + 2 is pressed
		if IsControlPressed(0, 210) and IsControlJustPressed(0, 158) then 
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local class = GetVehicleClass(vehicle)
			
			if vehicle ~= 0 then
				if class == 18 then 
					TriggerServerEvent('codeTwo', vehicle)
				end
			end
		end
		
		-- If Left CTRL + 3 is pressed
		if IsControlPressed(0, 210) and IsControlJustPressed(0, 160) then 
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local class = GetVehicleClass(vehicle)
			
			if vehicle ~= 0 then
				if class == 18 then 
					TriggerServerEvent('codeThree', vehicle)
				end
			end
		end
    end
end)

-------END Event Triggers-------

-------START Net Event Registration & Handlers-------

-- code one --
RegisterNetEvent('codeOne')
AddEventHandler('codeOne', function(vehicle)
	SetVehicleSiren(vehicle, false)
	DisableVehicleImpactExplosionActivation(vehicle, false)
	
end)


-- code two --
RegisterNetEvent('codeTwo')
AddEventHandler('codeTwo', function(vehicle)
	SetVehicleSiren(vehicle, true)
	DisableVehicleImpactExplosionActivation(vehicle, true)
	
end)


-- code three --
RegisterNetEvent('codeThree')
AddEventHandler('codeThree', function(vehicle)
	SetVehicleSiren(vehicle, true)
	DisableVehicleImpactExplosionActivation(vehicle, false)
	
end)


-------END Net Event Registration & Handlers-------

-------START Optional Commands-------



RegisterCommand("c1",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	
	if vehicle ~= 0 then
		if class == 18 then 
			
			TriggerServerEvent('codeOne', vehicle)
			ShowNotification("You've entered ~y~Code One~w~.")
		end
	end
	
end)
RegisterCommand("c2",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	
	if vehicle ~= 0 then
		if class == 18 then 
			
			TriggerServerEvent('codeTwo', vehicle)
			ShowNotification("You've entered ~y~Code Two~w~.")
		end
	end
	
end)
RegisterCommand("c3",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	
	if vehicle ~= 0 then
		if class == 18 then 
			
			TriggerServerEvent('codeThree', vehicle)
			ShowNotification("You've entered ~y~Code Three~w~.")
		end
	end
	
end)


RegisterKeyMapping('c1', 'Code one lights', 'keyboard', '[')
RegisterKeyMapping('c2', 'Code two lights', 'keyboard', ']')
RegisterKeyMapping('c3', 'Code three lights', 'keyboard', '-')
--]]

-------END Optional Commands-------