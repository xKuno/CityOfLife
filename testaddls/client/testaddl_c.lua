ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

------------------- EBLIPS

local ACTIVE = false
local ACTIVE_EMERGENCY_PERSONNEL = {}

------------
-- events --
------------
RegisterNetEvent("eblips:toggle")
AddEventHandler("eblips:toggle", function(on)
	-- toggle blip display --
	ACTIVE = on
	-- remove all blips if turned off --
	if not ACTIVE then
		RemoveAnyExistingEmergencyBlips()
	end
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(personnel)
	ACTIVE_EMERGENCY_PERSONNEL = personnel
end)

RegisterNetEvent("eblips:update")
AddEventHandler("eblips:update", function(person)
	ACTIVE_EMERGENCY_PERSONNEL[person.src] = person
end)

RegisterNetEvent("eblips:remove")
AddEventHandler("eblips:remove", function(src)
	RemoveAnyExistingEmergencyBlipsById(src)
end)

---------------
-- functions --
---------------
function RemoveAnyExistingEmergencyBlips()
	for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(src)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[src] = nil
		end
	end
end

function RemoveAnyExistingEmergencyBlipsById(id)
		local possible_blip = GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(id)))
		if possible_blip ~= 0 then
			RemoveBlip(possible_blip)
			ACTIVE_EMERGENCY_PERSONNEL[id] = nil
		end
end

-----------------------------------------------------
-- Watch for emergency personnel to show blips for --
-----------------------------------------------------
Citizen.CreateThread(function()
	while true do
		--if ACTIVE then
			for src, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do

				if ( (info.name == 'Police' or info.name == 'EMS') and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance') ) or (info.name == 'Security' and ESX.PlayerData.job.name == 'security') or (info.name == 'Mechanic' and ESX.PlayerData.job.name == 'mechanic') then
					local player = GetPlayerFromServerId(src)
					local ped = GetPlayerPed(player)
					if PlayerPedId() ~= ped then
						if GetBlipFromEntity(ped) == 0 then
							local blip = AddBlipForEntity(ped)
							SetBlipSprite(blip, 1)
							SetBlipColour(blip, info.color)
							ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
							SetBlipAsShortRange(blip, true)
							SetBlipScale(blip, 0.8) -- set scale
							--SetBlipDisplay(blip, 4)
							--SetBlipShowCone(blip, true)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(info.name)
							EndTextCommandSetBlipName(blip)
						end
					end
				end
			end
		--else RemoveAnyExistingEmergencyBlips() end
		Wait(3)
	end
end)
