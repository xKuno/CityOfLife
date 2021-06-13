ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--------------------------------------------------------------------------------------------------------------
------------First off, many thanks to @anders for help with the majority of this script. ---------------------
------------Also shout out to @setro for helping understand pNotify better.              ---------------------
--------------------------------------------------------------------------------------------------------------
------------To configure: Add/replace your own coords in the sectiong directly below.    ---------------------
------------        Goto LINE 90 and change "50" to your desired SafeZone Radius.        ---------------------
------------        Goto LINE 130 to edit the Marker( Holographic circle.)               ---------------------
--------------------------------------------------------------------------------------------------------------
-- Place your own coords here!
local zones = {
	{ ['x'] = 304.04, ['y'] = -586.6, ['z'] = 15.28},
	{ ['x'] = 230.84, ['y'] = -785.28, ['z'] = 27.68 },
	{ ['x'] = -1272.28, ['y'] = -3387.08, ['z'] = 9.96 },
	{ ['x'] = -55.24, ['y'] = -1836.88, ['z'] = 2.56 },
	{ ['x'] = 920.92, ['y'] = -1268.6, ['z'] = 15.56 },
	{ ['x'] = -734.88, ['y'] = -1325.8, ['z'] = -5.6 },
	{ ['x'] = 282.6, ['y'] = -333.28, ['z'] = 35.92 },
	{ ['x'] = -1812.84, ['y'] = -342.48, ['z'] = 39.6 },
	{ ['x'] = 967.68, ['y'] = -121.4, ['z'] = 50.36 },
	{ ['x'] = 1738.0, ['y'] = 3711.96, ['z'] = 20.12 },
	{ ['x'] = 1200.96, ['y'] = -1330.32, ['z'] = 25.24 },
	{ ['x'] = 336.4, ['y'] = -906.2, ['z'] = 23.48 },
	{ ['x'] = 936.64, ['y'] = -958.76, ['z'] = 32.08 },
	{ ['x'] = 438.76, ['y'] = -979.64, ['z'] = 24.08}	
}

local notifIn = false
local notifOut = false
local closestZone = 1
local whitelisted = false
function safeZone() return notifIn end
exports('isIn', safeZone)


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	NetworkSetFriendlyFireOption(true)
	while true do
		player = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(player, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = #(vector3(zones[i].x, zones[i].y, zones[i].z) - vector3(x, y, z))
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
  if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'security' then whitelisted = true else whitelisted = false end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'security' then whitelisted = true else whitelisted = false end
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function(source,callback)
	ESX.PlayerData = {}
end)

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
---------   Setting of friendly fire on and off, disabling your weapons, and sending pNoty   -----------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
			Citizen.Wait(5)
			local x,y,z = table.unpack(GetEntityCoords(player, true))
			local dist = #(vector3(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z) - vector3(x, y, z))
		
			if dist <= 50.0 then  ------------------------------------------------------------------------------ Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
				if not notifIn then																			  -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
					ClearPlayerWantedLevel(PlayerId())
					if not whitelisted then RemoveAllPedWeapons(player) end
					TriggerEvent("pNotify:SendNotification",{
						text = "<b style='color:#1E90FF'>You are in a SafeZone</b>",
						type = "success",
						timeout = (3000),
						layout = "bottomcenter",
						queue = "global"
					})
					notifIn = true
					notifOut = false
				end
			else
				if not notifOut then
					TriggerEvent("pNotify:SendNotification",{
						text = "<b style='color:#1E90FF'>You are in NO LONGER a SafeZone</b>",
						type = "error",
						timeout = (3000),
						layout = "bottomcenter",
						queue = "global"
					})
					notifOut = true
					notifIn = false
				end
				local impacted, impactCoords = GetPedLastWeaponImpactCoord(player)
				if not whitelisted and impacted then
					if #(vector3(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z) - impactCoords) <= 50.0 then
						SetPedToRagdoll(player,5000,0,0,false,false,false)
						print('naughty')
					end
				end
			end
			if notifIn and not whitelisted then
				local hasWep, hash = GetCurrentPedWeapon(player, 1)
				if hasWep then RemoveWeaponFromPed(player, hash) end
				DisablePlayerFiring(player, true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			end
			-- Comment out lines 142 - 145 if you dont want a marker.
			--[[if DoesEntityExist(player) then	      --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
				DrawMarker(1, zones[closestZone].x, zones[closestZone].y, zones[closestZone].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 232, 255, 155, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
				--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
			end]]
	end
end)