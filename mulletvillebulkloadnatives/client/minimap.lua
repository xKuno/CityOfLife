Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(PlayerPedId()) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(PlayerPedId(), true) then
			SetRadarZoom(1100)
		end
    end
end)
Citizen.CreateThread(function()
    while true do
		local pCoords = GetEntityCoords(PlayerPedId())		
			local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)
			if distance1 < 2000.0 then
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
			Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
			else
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
			Citizen.InvokeNative("0x5E1460624D194A38", false)
			end
		Citizen.Wait(5000)
    end
end)

SetScenarioGroupEnabled('Heist_Island_Peds', true)
SetAudioFlag('PlayerOnDLCHeist4Island', true)
SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)