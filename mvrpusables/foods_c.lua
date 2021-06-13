ESX          = nil
local IsDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer 
end)


RegisterNetEvent('mvrp_usables:ramen')
AddEventHandler('mvrp_usables:ramen', function()
	local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 18905)
	local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

	RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
	while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
		Citizen.Wait(1)
	end
	
	ESX.Game.SpawnObject('prop_ff_noodle_01', {
		x = coords.x,
		y = coords.y,
		z = coords.z - 3
	}, function(object)
		TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
		AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
		Citizen.Wait(6500)
		DeleteObject(object)
		ClearPedSecondaryTask(playerPed)
	end)
end)


RegisterNetEvent('mulletusable_items:onEat')
AddEventHandler('mulletusable_items:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_food_bs_burger2'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), 1.0, 1.0, 1.0, 1, 1, 0)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.07, 0.02, 120.0, 16.0, 60.0, 1, 0, 0, 0, 2, 1)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatChocolate')
AddEventHandler('mulletusable_items:onEatChocolate', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.035, 0.009, -30.0, -240.0, -120.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatpandq')
AddEventHandler('mulletusable_items:onEatpandq', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_candy_pqs'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.03, -240.0, -180.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatCupCake')
AddEventHandler('mulletusable_items:onEatCupCake', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'ng_proc_food_ornge1a'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.045, 0.06, 45.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatChips')
AddEventHandler('mulletusable_items:onEatChips', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'v_ret_ml_chips4'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)



RegisterNetEvent('mulletusable_items:onEatTaco')
AddEventHandler('mulletusable_items:onEatTaco', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_taco_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onGetCalm')
AddEventHandler('mulletusable_items:onGetCalm', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_pills'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:OnSmokeDaMeth')
AddEventHandler('mulletusable_items:OnSmokeDaMeth', function()
	prop_name = prop_name or 'prop_cs_meth_pipe' ---used cigarett prop for now. Tired of trying to place object.
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	local boneIndex = GetPedBoneIndex(ped, 64017)
			
    if not IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) then
        RequestAnimDict("amb@world_human_smoking@male@male_b@idle_a")
        while not HasAnimDictLoaded("amb@world_human_smoking@male@male_b@idle_a") do
            Citizen.Wait(100)
        end

		Wait(100)
		AttachEntityToEntity(prop, ped, boneIndex, 0.015, 0.0100, 0.0250, 0.024, -100.0, 40.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, 'amb@world_human_smoking@male@male_b@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
        Wait(2000)
        while IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) do
            Wait(1)
			if IsControlPressed(0, 153) then
				Citizen.Wait(5000)--5 secondes
				ClearPedSecondaryTask(ped)
				DeleteObject(prop)
                break
            end
        end
    end
end)

RegisterNetEvent('mulletusable_items:OnSmokeJoint')
AddEventHandler('mulletusable_items:OnSmokeJoint', function()
	prop_name = prop_name or 'p_cs_joint_01' ---used cigarett prop for now. Tired of trying to place object.
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	local boneIndex = GetPedBoneIndex(ped, 64017)
			
    if not IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) then
        RequestAnimDict("amb@world_human_smoking@male@male_b@idle_a")
        while not HasAnimDictLoaded("amb@world_human_smoking@male@male_b@idle_a") do
            Citizen.Wait(100)
        end

		Wait(100)
		AttachEntityToEntity(prop, ped, boneIndex, 0.015, 0.0100, 0.0250, 0.024, -100.0, 40.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, 'amb@world_human_smoking@male@male_b@idle_a', 'idle_a', 8.0, 8.0, -1, 49, 0, 0, 0, 0)
        Wait(2000)
        while IsEntityPlayingAnim(ped, "amb@world_human_smoking@male@male_b@idle_a", "idle_a", 3) do
            Wait(1)
			if IsControlPressed(0, 153) then
				Citizen.Wait(5000)--5 secondes
				ClearPedSecondaryTask(ped)
				DeleteObject(prop)
                break
            end
        end
    end
end)

RegisterNetEvent('mulletusable_items:onEatSteak')
AddEventHandler('mulletusable_items:onEatSteak', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_steak'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatPineapple')
AddEventHandler('mulletusable_items:onEatPineapple', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_pineapple'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatSandwich')
AddEventHandler('mulletusable_items:onEatSandwich', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_sandwich_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.00, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, 1, 0, 0, 0, 2, 1)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatDonut1')
AddEventHandler('mulletusable_items:onEatDonut1', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_amb_donut'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), 1.0, 1.0, 1.0, 1, 1, 0)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, 1, 0, 0, 0, 2, 1)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrink')
AddEventHandler('mulletusable_items:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrinksprunk')
AddEventHandler('mulletusable_items:onDrinksprunk', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_can_01' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrinkecola')
AddEventHandler('mulletusable_items:onDrinkecola', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ecola_can' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrinklemonade')
AddEventHandler('mulletusable_items:onDrinklemonade', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'ng_proc_sodacup_01b' --ng_proc_sodacan_01b
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrinkIceTea')
AddEventHandler('mulletusable_items:onDrinkIceTea', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_script_bottle_01' --ng_proc_sodacan_01b
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatHotdog')
AddEventHandler('mulletusable_items:onEatHotdog', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_hotdog_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onEatDonut2')
AddEventHandler('mulletusable_items:onEatDonut2', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_donut_02'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), 1.0, 1.0, 1.0, 1, 1, 0)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, 1, 0, 0, 0, 2, 1)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('mulletusable_items:onDrinkCoffe')
AddEventHandler('mulletusable_items:onDrinkCoffe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_fib_coffee'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.01, -0.03, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'tasty', 0.4)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)