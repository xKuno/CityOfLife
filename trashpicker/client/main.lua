ESX        = nil
percent    = false
searching  = false
cachedBins = {}
closestBin = {
    `prop_dumpster_01a`,
    `prop_dumpster_02a`,
    `prop_bin_05a`,
    `prop_bin_03a`,
    `prop_bin_07d`,
    `prop_dumpster_02b`
}
cachedScrap = {}
closestScrap = {
    `prop_rub_carwreck_11`,
    `prop_rub_carwreck_5`,
    `prop_rub_carwreck_17`,
    `prop_rub_carwreck_2`,
    `prop_rub_carwreck_3`,
    `prop_rub_carwreck_8`
}

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        

		if percent then

            for i = 1, #closestBin do

                local x = GetClosestObjectOfType(playerCoords, 1.0, closestBin[i], false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end

        else

			for i = 1, #closestBin do
				local x = GetClosestObjectOfType(playerCoords, 1.0, closestBin[i], false, false, false)
				local entity = nil
				if DoesEntityExist(x) then
					sleep  = 5
					entity = x
					bin    = GetEntityCoords(entity)
					DrawText3Ds(bin.x, bin.y, bin.z + 1.5, '[~g~E~s~] Search Trashbin') 
					if IsControlJustReleased(0, 38) then
						if not cachedBins[entity] then
							openBin(entity)
						else
							exports['mythic_notify']:SendAlert('Error', 'You already searched here!')
						end
					end
					break
				else
					sleep = 1000
				end
			end

		end
		
		playerPed = PlayerPedId()
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000

		if percent then

            for i = 1, #closestScrap do

                local x = GetClosestObjectOfType(playerCoords, 1.0, closestScrap[i], false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    scr    = GetEntityCoords(entity)
                    DrawText3Ds(scr.x, scr.y, scr.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end

        else
        
			for i = 1, #closestScrap do
				local x = GetClosestObjectOfType(playerCoords, 1.0, closestScrap[i], false, false, false)
				local entity = nil
				if DoesEntityExist(x) then
					sleep  = 5
					entity = x
					scr    = GetEntityCoords(entity)
					DrawText3Ds(scr.x, scr.y, scr.z + 1.5, '[~g~E~s~] Salvage Scrap') 
					if IsControlJustReleased(0, 38) then
						if not cachedScrap[entity] then
							openScrap(entity)
						else
							exports['mythic_notify']:SendAlert('Error', 'You already Salvaged what you could!')
						end
					end
					break
				else
					sleep = 1000
				end
			end

		end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 73) 
		else
			Citizen.Wait(50)
			playerCoords = GetEntityCoords(playerPed)
		end
    end
end)