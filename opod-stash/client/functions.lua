Opod = {}
function Opod:DeleteBlips(index)
	if index == nil then
		for _, v in pairs(self.StashHouses) do
			if v.blip then
				RemoveBlip(v.blip)
				v.blip = nil	
			end
		end
	else
		if self.StashHouses[index].blip ~= nil then
			RemoveBlip(self.StashHouses[index].blip)
			self.StashHouses[index].blip = nil
		end
	end
end

function Opod:CreateBlips()
	while self.StashHouses == nil do Citizen.Wait(0) end
	while self.PlayerData == nil do Citizen.Wait(0) end
	local bS = Config.BlipSettings
	if not bS.enable or (self.PlayerData.job.name == Config.PoliceJob and bS.civOnly) then
		return
	end
	for k, v in pairs(Opod.StashHouses) do
		if (bS.onlyAvailable and v.owner == '0') or not bS.onlyAvailable and v.blip == nil then
			v.blip = AddBlipForCoord(v.footEntrance.x, v.footEntrance.y, v.footEntrance.z)
			SetBlipSprite(v.blip, bS.sprite)
			SetBlipDisplay(v.blip, bS.display)
			SetBlipScale(v.blip, bS.scale)
			SetBlipColour(v.blip, bS.colour)
			SetBlipAsShortRange(v.blip, bS.shortRanged)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(bS.title)
			EndTextCommandSetBlipName(v.blip)
			Opod.StashHouses[k].blip = v.blip
		end
		if bS.showOwned and bS.onlyAvailable then
			if v.blip == nil and v.owner == self.PlayerData.identifier then
				v.blip = AddBlipForCoord(v.footEntrance.x, v.footEntrance.y, v.footEntrance.z)
				SetBlipSprite(v.blip, bS.ownedSprite)
				SetBlipDisplay(v.blip, bS.display)
				SetBlipScale(v.blip, bS.scale)
				SetBlipColour(v.blip, bS.colour)
				SetBlipAsShortRange(v.blip, bS.shortRanged)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(bS.ownedTitle)
				EndTextCommandSetBlipName(v.blip)
				Opod.StashHouses[k].blip = v.blip
			end
		end
	end
end


function Opod:WaitForMenu(name, target, inCar)
	local range = 1.5
	if IsPedInAnyVehicle(self.PlayerPed, 0) then
		range = 3.0
	end
	while ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), name) do Citizen.Wait(20)
		dist = #(Opod.PlayerPosition - vector3(target.x, target.y, target.z))
		if dist > range then
			if self.isBusy then
				self.isBusy = not self.isBusy
			end
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), name)
		end
	end
end

function Opod:OpenMenu(index, onFoot)
	local elements = {}
	local price = Config.ShellPrices[self.StashHouses[index].shellName]
	
	self.isBusy = true
	if self.StashHouses[index].owner ~= '0' then
		table.insert(elements, { label = "Enter Keycode", value = 'enter_code' })
	end
	
	if self.PlayerData.job.name ~= Config.PoliceJob then
		if self.StashHouses[index].owner == '0' then
			table.insert(elements, { label = "Purchase Warehouse - $" .. price.buyPrice, value = 'buy', price = price.buyPrice })
		elseif self.StashHouses[index].owner == self.PlayerData.identifier then
			table.insert(elements, { label = "Set Keycode", value = 'set_code' })
			table.insert(elements, { label = "Sell Property - $".. price.sellPrice, value = 'sell', price = price.sellPrice })
		end
	else
		if self.StashHouses[index].owner ~= '0' and self.StashHouses[index].locked then
			table.insert(elements, { label = "Start Police Raid", value = 'raid'})
		else
			table.insert(elements, { label = "Breach Building", value = 'breach'})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stash_house', {
		title = 'Warehouse ' .. self.StashHouses[index].placeId,
		align = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()
		self.isBusy = false
		if data.current.value == 'buy' then
			TSE('opod-stash:DeleteBlips', index)
			ESX.TriggerServerCallback('opod-stash:TryPurchase', function(canBuy)
				if canBuy == 'purchased' then
					self.StashHouses[index].owner = self.PlayerData.identifier
					self:ShowNotification(_U('bought_stash', data.current.price))
					self:DeleteBlips()
					TSE('opod-stash:CreateBlips')
				end
			end, self.PlayerData.identifier, self.StashHouses[index].placeId, data.current.price)
		elseif data.current.value == 'enter_code' then
			self:ToggleKeypad(self.StashHouses[index].code, index, onFoot)
		elseif data.current.value == 'set_code' then
			self:SetCode(index)
		elseif data.current.value == 'sell' then
			local code = self:GenerateCode()
			ESX.TriggerServerCallback('opod-stash:TrySell', function(canSell)
				if canSell == 'sold' then
					self.StashHouses[index].owner = '0'
					self.StashHouses[index].code = code
					TSE("opod-stash:CreateBlips")
					self:ShowNotification(_U('sold_stash', data.current.price))
				end
			end, self.StashHouses[index].placeId, code, data.current.price, index)
			
		elseif data.current.value == 'raid' then
			if self.PlayerData.job.name ~= Config.PoliceJob then
				return
			end
			ESX.TriggerServerCallback('opod-stash:CheckCooldown', function(canRaid, seconds)
				if canRaid then
					local isOnline = true
					if not Config.OfflineRaid then
						isOnline = nil
						ESX.TriggerServerCallback('opod-stash:CheckIfOnline', function(online)
							isOnline = online
						end, self.StashHouses[index].owner)
					end
					while isOnline == nil do
						Citizen.Wait(0)
					end
					
					if isOnline then
						if self:RaidStash(Config.RaidSettings.RaidLength[self.StashHouses[index].shellName], index) then
							self:ShowNotification(_U('broke_lock', 2))
							CT(function()
								local timer = (2000 * 6) * Config.RaidSettings.DoorOpenTime
								while timer > 0 do
									Citizen.Wait(5)
									timer = timer - 2
								end
								TSE('opod-stash:SetDoorStatus', true, self.StashHouses[index].placeId)
							end)
						end
					else
						self:ShowNotification(_U('cant_raid_offline'))
					end
				else
					self:ShowNotification(_U('cant_raid_cooldown'))
				end
			end)
		elseif data.current.value == 'breach' then
			self:EnterStash(index, true)
		end
	end, function(data, menu)
		self.isBusy = false
		menu.close()
	end)
end

function Opod:DrawMarker(coords, id, colour, size)
	DrawMarker(id, coords.x, coords.y, coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, size, size, size, colour[1], colour[2], colour[3], colour[4], false, true, 2, nil, nil, false)
end

function Opod:ShowContextMenu(str, pos)
	if Config.UseTextContext then
		self:CreateText(str)
		DrawText(0.5, 0.9)
	elseif Config.Use3DText then
		self:DrawTxt3D(pos, str)
	else
		ESX.ShowHelpNotification(str)
	end
end

function Opod:DrawTxt3D(coords, text)
    local str = text -- Thanks to loaf

    local start, stop = string.find(text, "~([^~]+)~")
    if start then
        start = start - 2
        stop = stop + 2
        str = ""
        str = str .. string.sub(text, 0, start) .. "   " .. string.sub(text, start+2, stop-2) .. string.sub(text, stop, #text)
    end

	AddTextEntry(GetCurrentResourceName(), str)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)

	SetFloatingHelpTextWorldPosition(1, vector3(coords.x, coords.y, coords.z))
	-- 							  col	 pos
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end


function Opod:CreateText(str)
	SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(str)
end


function Opod:GenerateId()
	while true do
		local id = math.random(1000, 5000)
		local idList = {}
		Citizen.Wait(0)
		for _, v in ipairs(Opod.StashHouses) do
			idList[v.placeId] = true
		end
		if idList[id] == nil then
			return id
		end
	end
end

function Opod:GenerateCode()
	local id = string.format("%04d", math.random(0, 500))
	return id
end

function Opod:SetCode(index)
	self:ToggleKeypad(nil, index)
	SendNUIMessage({
		changeCode = true
	})
end

function Opod:EnterStash(index, onFoot)
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end
	
	DisplayRadar(0)
	
	local v = Opod.StashHouses[index]
	local shell = Config.Shells[v.shellName]

	if onFoot then
		SetEntityCoords(Opod.PlayerPed, vector3(v.exitPos.x, v.exitPos.y, v.exitPos.z - 0.9))
		SetEntityHeading(Opod.PlayerPed, shell.heading)
	else
		local vehicle = GetVehiclePedIsIn(self.PlayerPed, 0)
		FreezeEntityPosition(vehicle, 1)
		SetEntityCoords(vehicle, vector3(v.carPos.x, v.carPos.y, v.carPos.z - 0.9))
		SetEntityHeading(vehicle, shell.heading)
		TSE('opod-stash:SetPortActive', v.placeId, true)
		Wait(150)
		Opod.StashHouses[index].carPortVehicle = vehicle
	end
	FreezeEntityPosition(self.PlayerPed, true)
	Citizen.Wait(500)
	local building = GetHashKey(v.shellName)
	RequestModel(building)
	while not HasModelLoaded(building) do
		Citizen.Wait(0)
	end

	v.shell = CreateObject(building, vector3(v.shellPos.x, v.shellPos.y, v.shellPos.z), false, false, false)
	while not DoesEntityExist(v.shell) do
		Citizen.Wait(0)
	end
	SetModelAsNoLongerNeeded(building)
	FreezeEntityPosition(v.shell, true)
	FreezeEntityPosition(self.PlayerPed, false)

	self:SetSync(false)

	self.InsideStash = v.placeId
	self.Shell = v.shell
	Citizen.Wait(1000)
	DoScreenFadeIn(500)

	CT(function()
		while self.InsideStash ~= nil do
			Citizen.Wait(5)
			local dist = nil
			local sleep = true
			if not IsPedInAnyVehicle(Opod.PlayerPed, 0) then
				dist = #(self.PlayerPosition - vector3(v.exitPos.x, v.exitPos.y, v.exitPos.z))
				if dist <= 50.0 then
					self:DrawMarker(vector3(v.exitPos.x, v.exitPos.y, v.exitPos.z), 27, {255, 0, 0, 100}, 1.0)
					if dist <= 1.0 then
						Opod:ShowContextMenu(_U('exit_building'), v.exitPos)
						if IsControlJustReleased(0, 38) then
							Opod:ExitStash(index, true)
						end
					end
				end
			end
			dist = #(self.PlayerPosition - vector3(v.vaultPos.x, v.vaultPos.y, v.vaultPos.z))
			if dist <= 50.0 then
				self:DrawMarker(vector3(v.vaultPos.x, v.vaultPos.y, v.vaultPos.z), 27, {255, 0, 0, 100}, 1.0)
				if dist <= 1.0 then
					Opod:ShowContextMenu(_U('open_stash'), v.vaultPos)
					if IsControlJustReleased(0, 38) then
						exports['linden_inventory']:OpenStash({ name = ('opod %s'):format(v.placeId), label = 'Warehouse', slots = 200})
						--[[ESX.TriggerServerCallback("opod-stash:getStashInventory", function(inventory)
							TE("esx_inventoryhud:openStashInventory", inventory, "Stash Locker " .. v.placeId, v.placeId, v.shellName)
                        end, v.placeId)]]
					end
				end
			end
			if IsPedInAnyVehicle(self.PlayerPed, 0) then
				dist = #(self.PlayerPosition - vector3(v.carPos.x, v.carPos.y, v.carPos.z))
				if dist <= 50.0 then
					self:DrawMarker(vector3(v.carPos.x, v.carPos.y, v.carPos.z), 27, {255, 0, 0, 100}, 3.0)
					if dist <= 3.0 then
						Opod:ShowContextMenu(_U('exit_building'), v.carPos)
						if IsControlJustReleased(0, 38) then
							Opod:ExitStash(index, false)
						end
					end
				end
			end
			if self.PlayerData.identifier == v.owner and self.PlayerData.job.name ~= Config.PoliceJob then
				dist = #(self.PlayerPosition - vector3(v.upgradePos.x, v.upgradePos.y, v.upgradePos.z))
				if dist <= 50.0 then
					self:DrawMarker(vector3(v.upgradePos.x, v.upgradePos.y, v.upgradePos.z), 27, {255, 0, 0, 100}, 1.0)
					if dist <= 1.0 then
						Opod:ShowContextMenu(_U('open_upgrade'), v.upgradePos)
						if IsControlJustReleased(0, 38) then
							Opod:OpenUpgradeMenu(index)
							Opod:WaitForMenu('upgrade_menu', v.upgradePos)
						end
					end
				end
			end
		end
	end)
end

function Opod:OpenUpgradeMenu(index)
	local elements = {}

	local v = self.StashHouses[index]
	local curType = v.shellName

	for k, v in pairs(Config.Shells) do
		if curType ~= k then
			local price = Config.ShellPrices[k].upgradePrice
			table.insert(elements, { label = v.name .. ' - $' .. price, price = price, value = k  })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade_menu', {
		title = 'Stash House - ' .. v.placeId,
		align = 'left',
		elements = elements,
	} , function(data, menu)
		menu.close()
		ESX.TriggerServerCallback('opod-stash:TryUpgrade', function(canUpgrade)
			if canUpgrade then
				self:UpgradeStash(index, data.current.value, data.current.price)
			else
				self:ShowNotification(_U('cant_afford_upgrade'))
			end
		end, self.PlayerData.identifier, v.placeId, data.current.price)
	end, function(data, menu)
		menu.close()
	end)
end

function Opod:UpgradeStash(index, type, price)
	ESX.TriggerServerCallback("opod-stash:getStashInventory", function(inventory)
        local count = 0
		local upgrade = Config.Shells[type]
		
		for _, item in pairs(inventory.items) do
            count = count + item.count
        end
        for _, weapon in pairs(inventory.weapons) do
            count = count + 1
        end
        if (inventory.blackMoney) > 0 then count = count + 1 end
        if (inventory.cashMoney) > 0 then count = count + 1 end
		if upgrade.limit ~= nil and (count > upgrade.limit) then
			self:ShowNotification(_U('clear_space'))
			return
		end
		local onFoot = true
		if self.StashHouses[index].carPortVehicle ~= nil then
			TaskWarpPedIntoVehicle(self.PlayerPed, self.StashHouses[index].carPortVehicle, -1)
			onFoot = false
		end
		self:ExitStash(index, onFoot)
		local players = ESX.Game.GetPlayersInArea(self.PlayerPosition, 35)
		local nearbyPlayers = {}
		for _, v in ipairs(players) do
			if GetPlayerPed(v) ~= GetPlayerPed(-1) then
				table.insert(nearbyPlayers, GetPlayerServerId(v))
			end
		end
		
		if #nearbyPlayers ~= 0 then
			TSE('opod-stash:KickOutNearby', self.StashHouses[index].placeId, nearbyPlayers)
		end
		
		local building = GetHashKey(type)
		RequestModel(building)
		while not HasModelLoaded(building) do
			Citizen.Wait(0)
		end
		
		local obj = CreateObject(building, self.StashHouses[index].shellPos.x, self.StashHouses[index].shellPos.y, self.StashHouses[index].shellPos.z, false, false, false)
		SetModelAsNoLongerNeeded(building)
		FreezeEntityPosition(obj, true)
		
		while not DoesEntityExist(obj) do
			Citizen.Wait(0)
		end
		
		local data = self.StashHouses[index]
		data.exitPos = GetOffsetFromEntityInWorldCoords(obj, upgrade.exitPos)
		data.vaultPos = GetOffsetFromEntityInWorldCoords(obj, upgrade.vaultPos)
		data.upgradePos = GetOffsetFromEntityInWorldCoords(obj, upgrade.upgrade)
		
		if upgrade.carPort then
			data.carPos = GetOffsetFromEntityInWorldCoords(obj, upgrade.carPort)
		else
		data.carPos = nil
	end
	data.shellName = type
	
	SetEntityAsMissionEntity(obj)
	DeleteObject(obj)
	obj = nil

	TSE('opod-stash:UpgradeStash', index, data, price)
end, self.StashHouses[index].placeId)
end

function Opod:ExitStash(index, onFoot)
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	DisplayRadar(1)

	local v = self.StashHouses[index]

	SetEntityAsMissionEntity(self.Shell)
	DeleteObject(self.Shell)

	v.shell = nil
	
	if onFoot then
		SetEntityCoords(Opod.PlayerPed, vector3(v.footEntrance.x, v.footEntrance.y, v.footEntrance.z - 0.9))
	else
		local vehicle = GetVehiclePedIsIn(self.PlayerPed, 0)
		FreezeEntityPosition(vehicle, false)
		SetEntityCoords(vehicle, vector3(v.carEntrance.x, v.carEntrance.y, v.carEntrance.z - 0.9))
		TSE('opod-stash:SetPortActive', v.placeId, false)
		self.StashHouses[index].carPortVehicle = nil
	end
	
	self:SetSync(true)
	
	self.Shell = nil
	
	self.InsideStash = nil

	Citizen.Wait(1000)
	DoScreenFadeIn(500)
end

function Opod:SetSync(sync)
    if not sync then
        if Config.UseVSync then
            TE('vSync:toggleSync',false)
        end
		SetWeatherTypeNow('CLEAR')
		SetWeatherTypePersist('CLEAR')
		SetWeatherTypeNowPersist('CLEAR')
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetRainFxIntensity(0.0)
		SetBlackout(false)
		NetworkOverrideClockTime(22,0,0)
    else
        if Config.UseVSync then
            TE('vSync:toggleSync', true)
            TSE('vSync:requestSync')
        else
            NetworkOverrideClockTime(GetClockHours(),GetClockMinutes(),GetClockSeconds())
        end
	end
end


function Opod:ShowNotification(str, type)
	TE('opod-stash:ShowNotification', str, type)
end

function Opod:ToggleKeypad(code, index, onFoot)
	self.keypadOpen = (not self.keypadOpen)
	self.isBusy = self.keypadOpen
	SendNUIMessage({
		setOpen = self.keypadOpen,
		setCode = tostring(code),
		onFoot = onFoot,
		stashIndex = index
	})
	SetNuiFocus(self.keypadOpen, self.keypadOpen)
end

function Opod:RaidStash(duration, index)
	local result = nil
	self.isBusy = true
	FreezeEntityPosition(self.PlayerPed, true)
	if Config.UseSkillbar then
		TE('opod-skillbar:startSkillbar', function(success)
			result = success
		end, 5)
	elseif Config.UseProgbar then
		exports['progressBars']:startUI(duration, 'Raiding House')
		Citizen.Wait(duration)
		result = true
	elseif Config.UseHacking then
		TaskStartScenarioInPlace(self.PlayerPed, 'WORLD_HUMAN_STAND_MOBILE_UPRIGHT', 0, true)
		TE("mhacking:show")
		TE("mhacking:start", 5, 35, function(success)
			TE('mhacking:hide')
			result = success
		end)
	else
		local timer = 200 * (duration / 1000) -- 1 SECCONDS
		while timer > 0 do
			Citizen.Wait(5)
			timer = timer - 2
			if IsPlayerDead(PlayerId()) then
				return
			end
			self:CreateText("You have ~y~" .. math.ceil(timer / 200) .. "~w~ seconds remaining")
			DrawText(0.5, 0.5)
		end
		result = true
	end
	while result == nil do Citizen.Wait(0) end
	FreezeEntityPosition(self.PlayerPed, false)
	ClearPedTasks(self.PlayerPed)
	self.isBusy = false
	if result then
		TSE('opod-stash:SetDoorStatus', false, self.StashHouses[index].placeId)
	end
	return result
end