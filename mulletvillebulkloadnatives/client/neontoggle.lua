--[[local isOn	=	false

RegisterCommand("neon", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
		--left
        if isOn then
            SetVehicleNeonLightEnabled(veh, 0, false)
            SetVehicleNeonLightEnabled(veh, 1, false)
            SetVehicleNeonLightEnabled(veh, 2, false)
            SetVehicleNeonLightEnabled(veh, 3, false)
			
			isOn = false
        else
            SetVehicleNeonLightEnabled(veh, 0, true)
            SetVehicleNeonLightEnabled(veh, 1, true)
            SetVehicleNeonLightEnabled(veh, 2, true)
            SetVehicleNeonLightEnabled(veh, 3, true)
			
			isOn = true
        end
    end
end, false)


Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', "/neon", "turn neons on/off ")
end)

RegisterKeyMapping('neon', 'Toggle neon', 'keyboard', '0')]]