ESX = nil
local Closest, LastPed = 0, 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player)
        local playerloc = GetEntityCoords(player)
		if veh ~= 0 and Config.vehicle == GetEntityModel(veh) and GetEntitySpeed(veh) == 0.0 then
			if Closest == 0 then
				Citizen.Wait(500)
				local peds = ESX.Game.GetPeds(onlyOtherPeds)
				for k,v in pairs(peds) do
					local pedCoords = GetEntityCoords(v)
					if not IsPedInAnyVehicle(v) and LastPed ~= v and GetPedType(v) ~= 28 and not IsEntityDead(v) and not IsPedAPlayer(v) and #(playerloc - pedCoords) < 20.0 then
						Closest = v
						break
					end
				end
			else 
				local coords = GetEntityCoords(Closest)
				DrawMarker(0, coords.x, coords.y, coords.z + 1.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 180, 0, 0, 200, false, true, 2, false, false, false, false)
			end

			if Closest > 0 then
				local destiny = GetEntityCoords(PlayerPedId())
				TaskPedSlideToCoord(Closest, destiny, 180.0, 2000)
				if GetDistanceBetweenCoords(destiny, GetEntityCoords(Closest)) < 2 and LastPed ~= Closest then
					local item = math.random(1, #Config.AllowedItems)
					ESX.TriggerServerCallback("esx_foodtruck:sell", function (result)
						if result then
							ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
								TaskPlayAnim(Closest, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
								Citizen.Wait(3000)
								ClearPedTasks(Closest)
								LastPed = Closest
								Closest = 0
							end)
						else
							ClearPedTasks(Closest)
							LastPed = Closest
							Closest = 0
						end
					end, Config.AllowedItems[item].item, Config.AllowedItems[item].price)
					Wait(5000)
				end
			end
		else
			Citizen.Wait(1500)
		end
    end
end)