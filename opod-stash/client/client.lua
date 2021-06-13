ESX	= nil


CT(function() while ESX == nil do TE(Config.SharedObject, function(obj) ESX = obj end) Citizen.Wait(0) end end)

CT(function()
	while Opod == nil do Citizen.Wait(0) end
	Opod.PlayerPed = PlayerPedId()
	Opod.StashHouses = {}
	while ESX == nil do Citizen.Wait(0) end
	Opod.PlayerData = ESX.GetPlayerData()
	while Opod.PlayerData == nil or Opod.PlayerData.job == nil  do
		Citizen.Wait(50)
		Opod.PlayerData = ESX.GetPlayerData()
	end
	ESX.TriggerServerCallback('opod-stash:GetStashes', function(stashes)
		Opod.StashHouses = stashes
		Opod:CreateBlips()
	end)
	if Opod.currentCharacter ~= nil then
		Opod.PlayerData.identifier = Opod.currentCharacter
	end
	while true do
		if Opod.PlayerPed ~= PlayerPedId() then
			Opod.PlayerPed = PlayerPedId()
		end
		Opod.PlayerPosition = GetEntityCoords(Opod.PlayerPed)
		Citizen.Wait(50)
	end
end)


CT(function()
	Citizen.Wait(1500)
	while Opod.StashHouses == nil do Citizen.Wait(0) end
	while true do
		Citizen.Wait(5)
		if not Opod.isBusy then
			for k, v in ipairs(Opod.StashHouses) do
				if v.footEntrance ~= nil and not IsPedInAnyVehicle(Opod.PlayerPed, 0) then
					local dist = #(Opod.PlayerPosition - vector3(v.footEntrance.x, v.footEntrance.y, v.footEntrance.z))
					if dist <= 50.0 then
						Opod:DrawMarker(vector3(v.footEntrance.x, v.footEntrance.y, v.footEntrance.z), 27, {255, 0, 0, 100}, 1.0)
						-- if Config.Use3DText then

						-- end
						if dist <= 1.0 then
							-- if not Config.Use3DText then
								Opod:ShowContextMenu(_U("interact_warehouse"), v.footEntrance)
							-- end
							if IsControlJustReleased(0, 38) then
								Opod:OpenMenu(k, true)
								Opod:WaitForMenu('stash_house', v.footEntrance)
							end
						end
					end
				end
				if v.carEntrance ~= nil and v.carPos ~= nil and not v.carActive and Config.ShellClasses[v.shellName] ~= nil and Config.ShellClasses[v.shellName][GetVehicleClass(GetVehiclePedIsIn(Opod.PlayerPed))] and IsPedInAnyVehicle(Opod.PlayerPed, 0) and Opod.PlayerData.job.name ~= Config.PoliceJob then
					local dist = #(Opod.PlayerPosition - vector3(v.carEntrance.x, v.carEntrance.y, v.carEntrance.z))
					if dist <= 50.0 then
						Opod:DrawMarker(vector3(v.carEntrance.x, v.carEntrance.y, v.carEntrance.z), 27, {255, 0, 0, 100}, 3.0)
						if dist <= 3.0 then
							Opod:ShowContextMenu(_U('interact_warehouse'), v.carEntrance)
							if IsControlJustReleased(0, 38) then
								Opod:OpenMenu(k, false)
								Opod:WaitForMenu('stash_house', v.carEntrance)
							end
						end
					end
				end
			end
		end
	end
end)

-- RegisterCommand('getOffset', function(source, args)
-- 	if DoesEntityExist(Opod.Shell) then
-- 		print(GetOffsetFromEntityGivenWorldCoords(Opod.Shell, Opod.PlayerPosition))
-- 	end
-- end)

RegisterCommand('buildStash', function(source, args)
	while Opod.StashHouses == nil do Citizen.Wait(0) end
	local hasPerm = false

	hasPerm = Config.BuilderSettings.WhitelistedBuilders[Opod.PlayerData.identifier]

	if not hasPerm and Config.BuilderSettings.UseAce then
		ESX.TriggerServerCallback('opod-stash:CheckAce', function(hasAce)
			hasPerm = hasAce
			triggerCallback = true
		end)
		while triggerCallback == nil do Citizen.Wait(50) end 
	end

	if hasPerm then
		local type = ''
		if args[1] == '1' then
			type = 'stashhouse1_shell'
		elseif args[1] == '2' then
			type = 'container2_shell'
		else
			type = 'stashhouse3_shell'
		end
	
		local building = GetHashKey(type)
		RequestModel(building)
		while not HasModelLoaded(building) do
			Citizen.Wait(0)
		end
		
		local obj = CreateObject(building, Opod.PlayerPosition.xy, Opod.PlayerPosition.z - 100.0, false, false, false)
		SetModelAsNoLongerNeeded(building)
		FreezeEntityPosition(obj, true)
		local key = #Opod.StashHouses + 1
		local shell = Config.Shells[type]
	
		Opod.StashHouses[key] = {shellName = type, footEntrance = nil, carEntrance = nil, shellPos = vector3(Opod.PlayerPosition.xy, Opod.PlayerPosition.z - 100.0), exitPos = GetOffsetFromEntityInWorldCoords(obj, shell.exitPos), upgradePos = GetOffsetFromEntityInWorldCoords(obj, shell.upgrade), vaultPos = GetOffsetFromEntityInWorldCoords(obj, shell.vaultPos), carPos = nil, placeId = Opod:GenerateId(), code = Opod:GenerateCode()}
		while not IsControlJustReleased(0, 47) do
			Citizen.Wait(5)
			Opod:ShowContextMenu(_U('place_foot_entrance'), Opod.PlayerPosition)
			Opod:DrawMarker(Opod.PlayerPosition, 27, {255, 0, 0, 100}, 1.0)
		end
		Opod.StashHouses[key].footEntrance = Opod.PlayerPosition
		Citizen.Wait(150)
		while not IsControlJustReleased(0, 47) do
			Citizen.Wait(5)
			Opod:ShowContextMenu(_U('place_car_entrance'), Opod.PlayerPosition)
			Opod:DrawMarker(Opod.PlayerPosition, 27, {255, 0, 0, 100}, 3.0)
		end
		Opod.StashHouses[key].carEntrance = Opod.PlayerPosition
	
		if shell.carPort then
			Opod.StashHouses[key].carPos = GetOffsetFromEntityInWorldCoords(obj, shell.carPort)
		end
		SetEntityAsMissionEntity(obj)
		DeleteObject(obj)
		obj = nil
		TSE('opod-stash:CreateStash', Opod.StashHouses[key])
	else
		Opod:ShowNotification(_U('no_perms'))
	end
end)


RNE('opod-stash:SetDoorStatus', function(status, placeId)
	for _, v in ipairs(Opod.StashHouses) do
		if v.placeId == placeId then
			v.locked = status
			return
		end
	end
	
end)

RNE('opod-stash:CreateBlips', function()
	Opod:CreateBlips()
end)

RNE('opod-stash:DeleteBlips', function(index)
	Opod:DeleteBlips(index)
end)

RNE('opod-stash:KickOutPlayer', function(placeId)
	if Opod.InsideStash then
		for k, v in ipairs(Opod.StashHouses) do
			if v.placeId == placeId then
				Opod:ExitStash(k, true)
				return
			end
		end
	end
end)

RNE('opod-stash:ShowNotification', function(str, type)
	if Config.pNotify then
        local options = Config.pNotifyOptions
		options.text = str
		options.type = type
        options.queue = 'opod-stash'
        exports['pNotify']:SendNotification(options)
    elseif Config.MythicNotify then
        exports['mythic_notify']:DoLongHudText(type or 'inform', str)
    else
        ESX.ShowNotification(str)
    end
end)

RNE('opod-stash:SyncStashes', function(stashes)
	Opod.StashHouses = stashes
end)

RNE('opod-stash:UpdateIdentifier', function(id)
	Opod.currentCharacter = id
end)

RNE('opod-stash:checkSpace', function(cb, amount, index, shell)
    if index ~= nil and amount ~= nil then
	local opodstash = 'opod_'..index

    --[[ESX.TriggerServerCallback("opod-stash:getStashInventory", function(inventory)
        local count = 0
        for _, item in pairs(inventory.items) do
            count = count + item.count
        end
        for _, weapon in pairs(inventory.weapons) do
            count = count + 1
        end
        if (inventory.blackMoney) > 0 then count = count + 1 end
        if (inventory.cashMoney) > 0 then count = count + 1 end

        if (Config.Shells[shell].limit ~= nil and (count + amount) > Config.Shells[shell].limit) and count ~= nil then
            cb(false, Config.Shells[shell].limit)
        else
            cb(true)
        end
    end, index)]]
    end
end)

if Config.BlipSettings.civOnly then
	RNE('esx:setJob', function(job)
		Opod.PlayerData.job = job
		Opod:DeleteBlips()
		if job.name ~= Config.PoliceJob then
			Opod:CreateBlips()
		end
	end)
end

RegisterNUICallback("close", function(data, cb)
	-- print("CLOSE")
	Opod:ToggleKeypad()
	if data.success ~= nil then
		if data.success then
			Opod:EnterStash(data.index, data.onFoot)
			Opod:ShowNotification(_U('unlocked_keypad'))
		else
			ShootSingleBulletBetweenCoords(Opod.PlayerPosition.xy,Opod.PlayerPosition.z + 2.0, Opod.PlayerPosition, 1, false, GetHashKey('WEAPON_STUNGUN'), nil, true, true, 200)
			SetEntityHealth(Opod.PlayerPed, GetEntityHealth(Opod.PlayerPed) - 15)
			Opod:ShowNotification(_U('failed_keypad'))
			Opod.isBusy = true
			while true do
				Citizen.Wait(50)
				if not IsPedBeingStunned(Opod.PlayerPed, 0) then
					break
				end
			end
			Opod.isBusy = false
		end
	end
	if data.code ~= nil then
		-- print(data.code)
		-- CHECK IF CODE HAS BEEN CHANGED
		TSE('opod-stash:ChangeCode', Opod.StashHouses[data.index].placeId, data.code)
		if not data.secureMode then
			Opod:ShowNotification(_U('set_code', data.code))
		else
			Opod:ShowNotification(_U('secret_set_code'))
		end
	end

	cb('ok')
end)