function getSpeed() return speedlimit end
function getStreet() return currentStreetName end
function getStreetandZone(coords)
	local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	playerStreetsLocation = currentStreetName .. ", " .. zone
	return playerStreetsLocation
end

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then return false end
	if not ESX.PlayerData.job then return false end
	for k,v in ipairs({'police'}) do
		if v == ESX.PlayerData.job.name then
			return true
		end	
	end
	return false
end

function BlacklistedWeapon(playerPed)
	for i = 1, #Config.WeaponBlacklist do
		local weaponHash = GetHashKey(Config.WeaponBlacklist[i])
		if GetSelectedPedWeapon(playerPed) == weaponHash then
			return true -- Is a blacklisted weapon
		end
	end
	return false -- Is not a blacklisted weapon
end

function GetAllPeds()
	local getPeds = {}
	local findHandle, foundPed = FindFirstPed()
	local continueFind = (foundPed and true or false)
	local count = 0
	while continueFind do
		local pedCoords = GetEntityCoords(foundPed)
		if GetPedType(foundPed) ~= 28 and not IsEntityDead(foundPed) and not IsPedAPlayer(foundPed) and #(playerCoords - pedCoords) < 35.0 then
			getPeds[#getPeds + 1] = foundPed
			count = count + 1
		end
		continueFind, foundPed = FindNextPed(findHandle)
	end
	EndFindPed(findHandle)
	return count
end

function zoneChance(type, zoneMod, street)
	if Config.DebugChance then return true end
	if not street then street = currentStreetName end
	playerCoords = GetEntityCoords(PlayerPedId())
	local zone, sendit = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)), false
	if not nearbyPeds then
		nearbyPeds = GetAllPeds()
	elseif nearbyPeds < 1 then if Config.Debug then print(('^1[%s] Nobody is nearby to send a report^7'):format(type)) end
		return false
	end
	if zoneMod == nil then zoneMod = 1 end
	zoneMod = (math.ceil(zoneMod+0.5))
	local hour = GetClockHours()
	if hour >= 21 or hour <= 4 then
		zoneMod = zoneMod * 1.6
		zoneMod = math.ceil(zoneMod+0.5)
	end
	zoneMod = zoneMod / (nearbyPeds / 3)
	zoneMod = (math.ceil(zoneMod+0.5))
	local sum = math.random(1, zoneMod)
	local chance = string.format('%.2f',(1 / zoneMod) * 100)..'%'
	debugMessage = ('^2[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds)
	if sum > 1 then
		if Config.Debug then print(debugMessage) end
		sendit = false
	else
		if Config.Debug then print(debugMessage) end
		sendit = true
	end
	return sendit
end

function vehicleData(vehicle)
	local vData = {}
	local vehicleClass = GetVehicleClass(vehicle)
	local vClass = {[0] = _U('compact'), [1] = _U('sedan'), [2] = _U('suv'), [3] = _U('coupe'), [4] = _U('muscle'), [5] = _U('sports_classic'), [6] = _U('sports'), [7] = _U('super'), [8] = _U('motorcycle'), [9] = _U('offroad'), [10] = _U('industrial'), [11] = _U('utility'), [12] = _U('van'), [17] = _U('service'), [19] = _U('military'), [20] = _U('truck')}
	local vehClass = vClass[vehicleClass]
	local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	local vehicleColour1, vehicleColour2 = GetVehicleColours(vehicle)
	if vehicleColour1 then
		if Config.Colours[tostring(vehicleColour2)] and Config.Colours[tostring(vehicleColour1)] then
			vehicleColour = Config.Colours[tostring(vehicleColour2)] .. " on " .. Config.Colours[tostring(vehicleColour1)]
		elseif Config.Colours[tostring(vehicleColour1)] then
			vehicleColour = Config.Colours[tostring(vehicleColour1)]
		elseif Config.Colours[tostring(vehicleColour2)] then
			vehicleColour = Config.Colours[tostring(vehicleColour2)]
		else
			vehicleColour = "Unknown"
		end
	end
	local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	local doorCount = 0
	if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end
	if doorCount == 2 then doorCount = _U('two_door') elseif doorCount == 3 then doorCount = _U('three_door') elseif doorCount == 4 then doorCount = _U('four_door') else doorCount = '' end
	vData.class, vData.name, vData.colour, vData.doors, vData.plate, vData.id = vehClass, vehicleName, vehicleColour, doorCount, plate, NetworkGetNetworkIdFromEntity(vehicle)
	return vData
end

function createBlip(data)
	Citizen.CreateThread(function()
		local alpha, blip = 255
		local sprite, colour, scale = 161, 84, 1.0
		if data.sprite then sprite = data.sprite end
		if data.colour then colour = data.colour end
		if data.scale then scale = data.scale end
		local entId = NetworkGetEntityFromNetworkId(data.netId)
		if data.netId and entId > 0 then
			blip = AddBlipForEntity(entId)
			SetBlipSprite(blip, sprite)
			SetBlipHighDetail(blip, true)
			SetBlipScale(blip, scale)
			SetBlipColour(blip, colour)
			SetBlipAlpha(blip, alpha)
			SetBlipAsShortRange(blip, false)
			SetBlipCategory(blip, 2)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(data.displayCode..' - '..data.dispatchMessage)
			EndTextCommandSetBlipName(blip)
			Citizen.Wait(data.length * 2)
			RemoveBlip(blip)
			Citizen.Wait(0)
			blip = AddBlipForCoord(GetEntityCoords(entId))
		else
			data.netId = nil
			blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
		end
		SetBlipSprite(blip, sprite)
		SetBlipHighDetail(blip, true)
		SetBlipScale(blip, scale)
		SetBlipColour(blip, colour)
		SetBlipAlpha(blip, alpha)
		SetBlipAsShortRange(blip, true)
		SetBlipCategory(blip, 2)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(data.displayCode..' - '..data.dispatchMessage)
		EndTextCommandSetBlipName(blip)
		while alpha ~= 0 do
			if data.netId then Citizen.Wait((data.length / 1000) * 5) else Citizen.Wait((data.length / 1000) * 20) end
			alpha = alpha - 1
			SetBlipAlpha(blip, alpha)
			if alpha == 0 then
				RemoveBlip(blip)
				return
			end
		end
	end)
end


RegisterNetEvent('wf-alerts:clNotify')
AddEventHandler('wf-alerts:clNotify', function(pData)
	if pData ~= nil then
		local sendit = false
		for i=1, #pData.recipientList do
			if pData.recipientList[i] == ESX.PlayerData.job.name then sendit = true break end
		end
		if sendit then
			Citizen.Wait(1500)
			if not pData.length then pData.length = 4000 end
			pData.street = getStreetandZone(vector3(pData.coords.x, pData.coords.y, pData.coords.z))
			SendNUIMessage({action = 'display', info = pData, job = ESX.PlayerData.job.name, length = pData.length})
			PlaySound(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 0, 0, 1)
			waypoint = vector2(pData.coords.x, pData.coords.y)
			createBlip(pData)
			Citizen.Wait(pData.length*2+1500)
			waypoint = nil
		end
	end
end)

RegisterCommand('alert_gps', function()
	if waypoint then SetWaypointOff() SetNewWaypoint(waypoint.x, waypoint.y) end
end, false)

RegisterKeyMapping('alert_gps', 'Set waypoint', 'keyboard', 'Y')


Citizen.CreateThread(function()
	while notLoaded do Citizen.Wait(0) end
	local speedlimitValues = {["Joshua Rd"]=75, ["East Joshua Road"]=75, ["Marina Dr"]=60, ["Alhambra Dr"]=60, ["Niland Ave"]=60, ["Zancudo Ave"]=60, ["Armadillo Ave"]=60, ["Algonquin Blvd"]=60, ["Mountain View Dr"]=60, ["Cholla Springs Ave"]=60, ["Panorama Dr"]=60, ["Lesbos Ln"]=60, ["Calafia Rd"]=60, ["North Calafia Way"]=60, ["Cassidy Trail"]=60, ["Seaview Rd"]=60, ["Grapeseed Main St"]=60, ["Grapeseed Ave"]=60, ["Joad Ln"]=60, ["Union Rd"]=60, ["O'Neil Way"]=60, ["Senora Fwy"]=120, ["Catfish View"]=60, ["Great Ocean Hwy"]=60, ["Paleto Blvd"]=60, ["Duluoz Ave"]=60, ["Procopio Dr"]=60, ["Cascabel Ave"]=60, ["Procopio Promenade"]=60, ["Pyrite Ave"]=60, ["Fort Zancudo Approach Rd"]=60, ["Barbareno Rd"]=60, ["Ineseno Road"]=60, ["West Eclipse Blvd"]=60, ["Playa Vista"]=60, ["Bay City Ave"]=60, ["Del Perro Fwy"]=120, ["Equality Way"]=60, ["Red Desert Ave"]=60, ["Magellan Ave"]=60, ["Sandcastle Way"]=60, ["Vespucci Blvd"]=60, ["Prosperity St"]=60, ["San Andreas Ave"]=60, ["North Rockford Dr"]=60, ["South Rockford Dr"]=60, ["Marathon Ave"]=60, ["Boulevard Del Perro"]=60, ["Cougar Ave"]=60, ["Liberty St"]=60, ["Bay City Incline"]=60, ["Conquistador St"]=60, ["Cortes St"]=60, ["Vitus St"]=60, ["Aguja St"]=60, ["Goma St"]=60, ["Melanoma St"]=60, ["Palomino Ave"]=60, ["Invention Ct"]=60, ["Imagination Ct"]=60, ["Rub St"]=60, ["Tug St"]=60, ["Ginger St"]=60, ["Lindsay Circus"]=60, ["Calais Ave"]=60, ["Adam's Apple Blvd"]=60, ["Alta St"]=60, ["Integrity Way"]=60, ["Swiss St"]=60, ["Strawberry Ave"]=60, ["Capital Blvd"]=60, ["Crusade Rd"]=60, ["Innocence Blvd"]=60, ["Davis Ave"]=60, ["Little Bighorn Ave"]=60, ["Roy Lowenstein Blvd"]=60, ["Jamestown St"]=60, ["Carson Ave"]=45, ["Grove St"]=60, ["Brouge Ave"]=60, ["Covenant Ave"]=60, ["Dutch London St"]=60, ["Signal St"]=60, ["Elysian Fields Fwy"]=120, ["Plaice Pl"]=60, ["Chum St"]=60, ["Chupacabra St"]=60, ["Miriam Turner Overpass"]=60, ["Autopia Pkwy"]=60, ["Exceptionalists Way"]=60, ["La Puerta Fwy"]=120, ["New Empire Way"]=60, ["Runway1"]="--", ["Greenwich Pkwy"]=60, ["Kortz Dr"]=60, ["Banham Canyon Dr"]=60, ["Buen Vino Rd"]=60, ["Route 68"]=120, ["Zancudo Grande Valley"]=60, ["Zancudo Barranca"]=60, ["Galileo Rd"]=60, ["Mt Vinewood Dr"]=60, ["Marlowe Dr"]=60, ["Milton Rd"]=60, ["Kimble Hill Dr"]=60, ["Normandy Dr"]=60, ["Hillcrest Ave"]=60, ["Hillcrest Ridge Access Rd"]=60, ["North Sheldon Ave"]=60, ["Lake Vinewood Dr"]=60, ["Lake Vinewood Est"]=60, ["Baytree Canyon Rd"]=60, ["Peaceful St"]=60, ["North Conker Ave"]=60, ["Wild Oats Dr"]=60, ["Whispymound Dr"]=60, ["Didion Dr"]=60, ["Cox Way"]=60, ["Picture Perfect Drive"]=60, ["South Mo Milton Dr"]=60, ["Cockingend Dr"]=60, ["Mad Wayne Thunder Dr"]=60, ["Hangman Ave"]=60, ["Dunstable Ln"]=60, ["Dunstable Dr"]=60, ["Greenwich Way"]=60, ["Greenwich Pl"]=60, ["Hardy Way"]=60, ["Richman St"]=60, ["Ace Jones Dr"]=60, ["Los Santos Freeway"]=120, ["Senora Rd"]=60, ["Nowhere Rd"]=50, ["Smoke Tree Rd"]=60, ["Cholla Rd"]=60, ["Cat-Claw Ave"]=60, ["Senora Way"]=60, ["Palomino Fwy"]=120, ["Shank St"]=60, ["Macdonald St"]=60, ["Route 68 Approach"]=120, ["Vinewood Park Dr"]=60, ["Vinewood Blvd"]=60, ["Mirror Park Blvd"]=60, ["Glory Way"]=60, ["Bridge St"]=60, ["West Mirror Drive"]=60, ["Nikola Ave"]=60, ["East Mirror Dr"]=60, ["Nikola Pl"]=50, ["Mirror Pl"]=60, ["El Rancho Blvd"]=60, ["Olympic Fwy"]=120, ["Fudge Ln"]=60, ["Amarillo Vista"]=60, ["Labor Pl"]=60, ["El Burro Blvd"]=60, ["Sustancia Rd"]=55, ["South Shambles St"]=60, ["Hanger Way"]=60, ["Orchardville Ave"]=60, ["Popular St"]=60, ["Buccaneer Way"]=55, ["Abattoir Ave"]=60, ["Voodoo Place"]=40, ["Mutiny Rd"]=60, ["South Arsenal St"]=60, ["Forum Dr"]=60, ["Morningwood Blvd"]=60, ["Dorset Dr"]=60, ["Caesars Place"]=60, ["Spanish Ave"]=60, ["Portola Dr"]=60, ["Edwood Way"]=60, ["San Vitus Blvd"]=60, ["Eclipse Blvd"]=60, ["Gentry Lane"]=40, ["Las Lagunas Blvd"]=60, ["Power St"]=60, ["Mt Haan Dr"]=60, ["Elgin Ave"]=60, ["Hawick Ave"]=60, ["Meteor St"]=60, ["Alta Pl"]=60, ["Occupation Ave"]=60, ["Carcer Way"]=60, ["Eastbourne Way"]=60, ["Rockford Dr"]=60, ["Abe Milton Pkwy"]=60, ["Laguna Pl"]=60, ["Sinners Passage"]=60, ["Atlee St"]=60, ["Sinner St"]=60, ["Supply St"]=60, ["Amarillo Way"]=60, ["Tower Way"]=60, ["Decker St"]=60, ["Tackle St"]=60, ["Low Power St"]=60, ["Clinton Ave"]=60, ["Fenwell Pl"]=60, ["Utopia Gardens"]=60, ["Cavalry Blvd"]=60, ["South Boulevard Del Perro"]=60, ["Americano Way"]=60, ["Sam Austin Dr"]=60, ["East Galileo Ave"]=60, ["Galileo Park"]=60, ["West Galileo Ave"]=60, ["Tongva Dr"]=60, ["Zancudo Rd"]=60, ["Movie Star Way"]=60, ["Heritage Way"]=60, ["Perth St"]=60, ["Chianski Passage"]=60, ["Lolita Ave"]=60, ["Meringue Ln"]=60, ["Strangeways Dr"]=60}
	while true do
		Citizen.Wait(0)
		playerCoords = GetEntityCoords(PlayerPedId())
		if currentStreetName then lastStreet = currentStreetName end
		local currentStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
		if currentStreetName ~= lastStreet or not speedlimit then speedlimit = speedlimitValues[currentStreetName] end
		nearbyPeds = GetAllPeds()
		Citizen.Wait(500)
		local vehicle = GetVehiclePedIsUsing(playerPed, true)
		if GetVehicleEstimatedMaxSpeed(vehicle) > 100.0 then
			SetVehicleMaxSpeed(vehicle, 100.0)
		end
	end
end)

Citizen.CreateThread(function()
	local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}
	local sleep = 100
	while true do
		if not notLoaded then
			playerPed = PlayerPedId()
			if (not isPlayerWhitelisted or Config.Debug) then
				for k, v in pairs(Config.Timer) do
					if v > 0 then Config.Timer[k] = v - 1 end
				end

				if GetVehiclePedIsUsing(playerPed) ~= 0 then
					local vehicle = GetVehiclePedIsUsing(playerPed, true)
						if vehicleWhitelist[GetVehicleClass(vehicle)] then
						local driver = GetPedInVehicleSeat(vehicle, -1)
						if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
							sleep = 10
							if IsPedShooting(playerPed) and zoneChance('Driveby', 2, currentStreetName) then
								local veh = vehicleData(vehicle)
								data = {dispatchCode = 'driveby', caller = _U('caller_local'), coords = playerCoords, netId = veh.id, length = 8000,
								info = ('[%s] %s%s'):format(veh.plate, veh.doors, veh.class), info2 = veh.colour}
								TriggerServerEvent('wf-alerts:svNotify', data, debugMessage)
								Config.Timer['Shooting'] = Config.Shooting.Success
							else
								Config.Timer['Shooting'] = Config.Shooting.Fail
							end
						elseif Config.Timer['Speeding'] == 0 and playerPed == driver and speedlimit then
							sleep = 100
							local random = math.random(50, 100)
							if (GetEntitySpeed(vehicle) * 2.236936) >= (speedlimit + random) then
								if zoneChance('Speeding', 4, currentStreetName) then
									Citizen.Wait(400)
									if IsPedInAnyVehicle(playerPed, true) and (GetEntitySpeed(vehicle) * 2.236936) >= (speedlimit + random) then
										local veh = vehicleData(vehicle)
										data = {dispatchCode = 'speeding', caller = _U('caller_local'), coords = playerCoords, netId = veh.id,
										info = ('[%s] %s%s'):format(veh.plate, veh.doors, veh.class), info2 = veh.colour}
										TriggerServerEvent('wf-alerts:svNotify', data, debugMessage)
										Config.Timer['Speeding'] = Config.Speeding.Success
									end
								else
									Config.Timer['Speeding'] = Config.Speeding.Fail
								end
							end
						elseif Config.Timer['Autotheft'] == 0 and (IsPedGettingIntoAVehicle(playerPed) and GetSeatPedIsTryingToEnter(playerPed) == -1) and ((driver > 0 and not IsPedAPlayer(driver)) or IsVehicleAlarmActivated(vehicle)) then
							sleep = 100
							local triggered = false
							local veh = vehicleData(vehicle)
							ESX.TriggerServerCallback('linden_outlawalert:isVehicleOwned', function(hasowner)
								veh.owner = hasowner
								triggered = true
							end, veh.plate)
							while not triggered do Citizen.Wait(30) end
							if not veh.owner then
								if zoneChance('Autotheft', 2, currentStreetName) then
									data = {dispatchCode = 'autotheft', caller = _U('caller_local'), coords = playerCoords, netId = veh.id, length = 8000,
									info = ('[%s] %s %s'):format(veh.plate, veh.name..',', veh.class), info2 = veh.colour}
									TriggerServerEvent('wf-alerts:svNotify', data, debugMessage)
									Config.Timer['Autotheft'] = Config.Autotheft.Success
								else
									Config.Timer['Autotheft'] = Config.Autotheft.Fail
								end
							end

						else sleep = 100 end
					end
				else
					if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
						sleep = 10
						if IsPedShooting(playerPed) and zoneChance('Shooting', 2, currentStreetName) then
							data = {dispatchCode = 'shooting', caller = _U('caller_local'), coords = playerCoords, netId = NetworkGetNetworkIdFromEntity(playerPed), length = 8000}
							TriggerServerEvent('wf-alerts:svNotify', data, debugMessage)
							Config.Timer['Shooting'] = Config.Shooting.Success
						else
							Config.Timer['Shooting'] = Config.Shooting.Fail
						end
					elseif Config.Timer['Melee'] == 0 and IsPedInMeleeCombat(playerPed) and HasPedBeenDamagedByWeapon(GetMeleeTargetForPed(playerPed), 0, 1) then
						sleep = 10
						if zoneChance('Melee', 3, currentStreetName) then
							data = {dispatchCode = 'melee', caller = _U('caller_local'), coords = playerCoords, netId = NetworkGetNetworkIdFromEntity(playerPed), length = 8000}
							TriggerServerEvent('wf-alerts:svNotify', data, debugMessage)
							Config.Timer['Melee'] = Config.Melee.Success
						else
							Config.Timer['Melee'] = Config.Melee.Fail
						end
					else sleep = 100 end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

RegisterCommand('911', function(playerId, args, rawCommand)
	if not args[1] then exports['mythic_notify']:SendAlert('error', 'You must include a message with your 911 call') return end
	args = table.concat(args, ' ')
	local caller
	if Config.PhoneNumber then caller = phone else caller = ('%s %s'):format(firstname, lastname) end
	if Config.Default911 then TriggerServerEvent('mdt:newCall', args, caller, playerCoords) else
		TriggerServerEvent('wf-alerts:svNotify911', args, caller, playerCoords)
	end
	exports['mythic_notify']:SendAlert('success', 'Your message has been sent to the authorities')
end, false)

RegisterCommand('911a', function(playerId, args, rawCommand)
	if not args[1] then exports['mythic_notify']:SendAlert('error', 'You must include a message with your 911 call') return end
	args = table.concat(args, ' ')
	if Config.Default911 then TriggerServerEvent('mdt:newCall', args, _U('caller_unknown'), playerCoords) else
		TriggerServerEvent('wf-alerts:svNotify911', args, _U('caller_unknown'), playerCoords)
	end
	exports['mythic_notify']:SendAlert('success', 'Your message has been sent to the authorities')
end, false)
