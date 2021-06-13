ESX = nil

local personalmenu = {}

local billItem, mainMenu = {}, nil

local playerGroup, noclip, godmode, visible = nil, false, false, false

local societymoney, societymoney2 = nil, nil


Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(3)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(3)
	end

	if Config.doublejob then
		while ESX.GetPlayerData().job2 == nil do
			Citizen.Wait(3)
		end
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while playerGroup == nil do
		ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(group) playerGroup = group end)
		Citizen.Wait(3)
	end

	RefreshMoney()

	if Config.doublejob then
		RefreshMoney2()
	end

	_menuPool = NativeUI.CreatePool()

	mainMenu = NativeUI.CreateMenu(GetPlayerName(PlayerId()), _U('mainmenu_subtitle'))
	_menuPool:Add(mainMenu)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('esx:onPlayerDeath', function()
	_menuPool:CloseAllMenus()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('personalmenu:clear', function()
	mainMenu:Clear()
	_menuPool:Clear()
	_menuPool:Remove()
	personalmenu = {}
	billItem = {}
	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu(GetPlayerName(PlayerId()), _U('mainmenu_subtitle'))
	_menuPool:Add(mainMenu)
	TriggerEvent('chat:toggleChat', false)
	menuopen = false
end)


AddEventHandler('playerSpawned', function()
	isDead = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSociety2Money(money)
		end, ESX.PlayerData.job2.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		UpdateSociety2Money(money)
	end
end)

function UpdateSocietyMoney(money)
	societymoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	societymoney2 = ESX.Math.GroupDigits(money)
end

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(3)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

-- Admin Menu --

RegisterNetEvent('KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('KorioZ-PersonalMenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput("KORIOZ_BOX_XYZ", _U('dialogbox_xyz'), "", 50)

	local _, _, x, y, z = string.find(pos, "([%d%.]+) ([%d%.]+) ([%d%.]+)")
			
	if x ~= nil and y ~= nil and z ~= nil then
		SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
	end
end
-- FIN TP A POSITION

-- FONCTION NOCLIP 
function admin_no_clip()
	noclip = not noclip

	if noclip then
		SetEntityInvincible(plyPed, true)
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_noclipon'))
	else
		SetEntityInvincible(plyPed, false)
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_noclipoff'))
	end
end

function getPosition()
	local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

	return x, y, z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading * math.pi/180.0)
	local y = math.cos(heading * math.pi/180.0)
	local z = math.sin(pitch * math.pi/180.0)

	local len = math.sqrt(x * x + y * y + z * z)

	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x, y, z
end

function isNoclip()
	return noclip
end
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification(_U('admin_godmodeon'))
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification(_U('admin_godmodeoff'))
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_ghoston'))
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_ghostoff'))
	end
end
-- FIN INVISIBLE

-- SUPER JUMP
function admin_mode_kangaroo()
	superjump = not superjump

	if superjump then
		ESX.ShowNotification(_U('admin_superjumpon'))
		Citizen.CreateThread(function()
			while superjump do
				Citizen.Wait(3)
				SetPedMoveRateOverride(plyPed, 1.2)
				SetSuperJumpThisFrame(PlayerId())
			end
		end)
	else
		ESX.ShowNotification(_U('admin_superjumpoff'))
	end
end
-- FIN SUPER JUMP

-- Réparer vehicule
function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KORIOZ_BOX_VEHICLE_NAME", _U('dialogbox_vehiclespawner'), "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(3)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
				SetModelAsNoLongerNeeded(car)
			end)
		end
	end
end
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords['x'], plyCoords['y'], plyCoords['z'], 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)

	ESX.ShowNotification(_U('admin_vehicleflip'))
end
-- FIN flipVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
			TriggerServerEvent("scrambler:AdminGiveArgent", amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
			TriggerServerEvent("scrambler:AdminGiveArgent", amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT EN BANQUE

-- Afficher Coord
function modo_showcoord()
	showcoord = not showcoord
end
-- FIN Afficher Coord

-- Afficher Nom
function modo_showname()
	showname = not showname
end
-- FIN Afficher Nom

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(3)
		end

		ESX.ShowNotification(_U('admin_tpmarker'))
	else
		ESX.ShowNotification(_U('admin_nomarker'))
	end
end
-- FIN TP MARKER

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('tp_ambulancejob:revive', plyId)
		end
	end
end
-- FIN HEAL JOUEUR


function AddMenuWalletMenu(menu)
	personalmenu.moneyOption = {
		_U('wallet_option_give'),
		_U('wallet_option_drop')
	}

	walletmenu = _menuPool:AddSubMenu(menu, _U('wallet_title'), 'Mon Portefeuille')

	local walletJob = NativeUI.CreateItem(_U('wallet_job_button', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), "")
	walletmenu.SubMenu:AddItem(walletJob)

	local walletJob2 = nil

	if Config.doublejob then
		walletJob2 = NativeUI.CreateItem(_U('wallet_job2_button', ESX.PlayerData.job2.label, ESX.PlayerData.job2.grade_label), "")
		walletmenu.SubMenu:AddItem(walletJob2)
	end
	
	local showID = nil
	local showDriver = nil
	local showFirearms = nil
	local checkID = nil
	local checkDriver = nil
	local checkFirearms = nil

	if Config.EnableJsfourIDCard then
		showID = NativeUI.CreateItem(_U('wallet_show_idcard_button'), "")
		walletmenu.SubMenu:AddItem(showID)

		checkID = NativeUI.CreateItem(_U('wallet_check_idcard_button'), "")
		walletmenu.SubMenu:AddItem(checkID)
       
        showDriver = NativeUI.CreateItem(_U('wallet_show_driver_button'), "")
        walletmenu.SubMenu:AddItem(showDriver)
       
        checkDriver = NativeUI.CreateItem(_U('wallet_check_driver_button'), "")
        walletmenu.SubMenu:AddItem(checkDriver)
           
        showFirearms = NativeUI.CreateItem(_U('wallet_show_firearms_button'), "")
        walletmenu.SubMenu:AddItem(showFirearms)
       
        checkFirearms = NativeUI.CreateItem(_U('wallet_check_firearms_button'), "")
        walletmenu.SubMenu:AddItem(checkFirearms)
	end

	walletmenu.SubMenu.OnItemSelect = function(sender, item, index)
		if Config.EnableJsfourIDCard then
			if item == showID then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkID then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			elseif item == showDriver then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'driver')
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkDriver then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
			elseif item == showFirearms then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'weapon')
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkFirearms then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
			end
		end
	end
end

function AddMenuFacturesMenu(menu)
	billMenu = _menuPool:AddSubMenu(menu, _U('bills_title'))
	billItem = {}

	ESX.TriggerServerCallback('KorioZ-PersonalMenu:Bill_getBills', function(bills)
		for i = 1, #bills, 1 do
			local label = bills[i].label
			local amount = bills[i].amount
			local value = bills[i].id

			table.insert(billItem, value)

			billItem[value] = NativeUI.CreateItem(label, "")
			billItem[value]:RightLabel("$" .. ESX.Math.GroupDigits(amount))
			billMenu.SubMenu:AddItem(billItem[value])
		end

		billMenu.SubMenu.OnItemSelect = function(sender, item, index)
			for i = 1, #bills, 1 do
				local label  = bills[i].label
				local value = bills[i].id

				if item == billItem[value] then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						_menuPool:CloseAllMenus()
					end, value)
				end
			end
		end
	end)
end

RegisterCommand("card", function(source, args, rawCommand)
	if item == showID then
		personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
									
		if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
		else
			ESX.ShowNotification(_U('players_nearby'))
		end
	end	
end)

	
function loadAnimDict(dict)

	while (not HasAnimDictLoaded(dict)) do

		RequestAnimDict(dict)

		Citizen.Wait(5)

	end

end

function AddMenuVehicleMenu(menu)
	personalmenu.frontLeftDoorOpen = false
	personalmenu.frontRightDoorOpen = false
	personalmenu.backLeftDoorOpen = false
	personalmenu.backRightDoorOpen = false
	personalmenu.hoodDoorOpen = false
	personalmenu.trunkDoorOpen = false
	personalmenu.doorList = {
		_U('vehicle_door_frontleft'),
		_U('vehicle_door_frontright'),
		_U('vehicle_door_backleft'),
		_U('vehicle_door_backright')
	}

	vehicleMenu = _menuPool:AddSubMenu(menu, _U('vehicle_title'))

	local vehEngineItem = NativeUI.CreateItem(_U('vehicle_engine_button'), "")
	vehicleMenu.SubMenu:AddItem(vehEngineItem)
	local vehDoorListItem = NativeUI.CreateListItem(_U('vehicle_door_button'), personalmenu.doorList, 1)
	vehicleMenu.SubMenu:AddItem(vehDoorListItem)
	local vehHoodItem = NativeUI.CreateItem(_U('vehicle_hood_button'), "")
	vehicleMenu.SubMenu:AddItem(vehHoodItem)
	local vehTrunkItem = NativeUI.CreateItem(_U('vehicle_trunk_button'), "")
	vehicleMenu.SubMenu:AddItem(vehTrunkItem)

	vehicleMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehEngineItem then
				if GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, false, false, true)
					SetVehicleUndriveable(plyVehicle, true)
				elseif not GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, true, false, true)
					SetVehicleUndriveable(plyVehicle, false)
				end
			elseif item == vehHoodItem then
				if not personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 4, false, false)
				elseif personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 4, false, false)
				end
			elseif item == vehTrunkItem then
				if not personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 5, false, false)
				elseif personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 5, false, false)
				end
			end
		end
	end

	vehicleMenu.SubMenu.OnListSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehDoorListItem then
				if index == 1 then
					if not personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 0, false, false)
					elseif personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 0, false, false)
					end
				elseif index == 2 then
					if not personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 1, false, false)
					elseif personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 1, false, false)
					end
				elseif index == 3 then
					if not personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 2, false, false)
					elseif personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 2, false, false)
					end
				elseif index == 4 then
					if not personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 3, false, false)
					elseif personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 3, false, false)
					end
				end
			end
		end
	end
end

function AddMenuBossMenu(menu)
	bossMenu = _menuPool:AddSubMenu(menu, _U('bossmanagement_title', ESX.PlayerData.job.label))

	local coffreItem = nil

	if societymoney ~= nil then
		coffreItem = NativeUI.CreateItem(_U('bossmanagement_chest_button'), "")
		coffreItem:RightLabel("$" .. societymoney)
		bossMenu.SubMenu:AddItem(coffreItem)
	end

	local recruterItem = NativeUI.CreateItem(_U('bossmanagement_hire_button'), "")
	bossMenu.SubMenu:AddItem(recruterItem)
	local virerItem = NativeUI.CreateItem(_U('bossmanagement_fire_button'), "")
	bossMenu.SubMenu:AddItem(virerItem)
	local promouvoirItem = NativeUI.CreateItem(_U('bossmanagement_promote_button'), "")
	bossMenu.SubMenu:AddItem(promouvoirItem)
	local destituerItem = NativeUI.CreateItem(_U('bossmanagement_demote_button'), "")
	bossMenu.SubMenu:AddItem(destituerItem)

	bossMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruterItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.job.name, 0)
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == virerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == promouvoirItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == destituerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		end
	end
end

function AddMenuAdminMenu(menu)
	adminMenu = _menuPool:AddSubMenu(menu, _U('admin_title'))

	if playerGroup == 'moderator' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			end
		end
	elseif playerGroup == 'admin' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), "")
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	elseif playerGroup == 'superadmin' or playerGroup == 'owner' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local tptoXYZItem = NativeUI.CreateItem(_U('admin_tpxyz_button'), "")
		adminMenu.SubMenu:AddItem(tptoXYZItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local godmodeItem = NativeUI.CreateItem(_U('admin_godmode_button'), "")
		adminMenu.SubMenu:AddItem(godmodeItem)
		local ghostmodeItem = NativeUI.CreateItem(_U('admin_ghostmode_button'), "")
		adminMenu.SubMenu:AddItem(ghostmodeItem)
		local superjumpItem = NativeUI.CreateItem(_U('admin_superjump_button'), "")
		adminMenu.SubMenu:AddItem(superjumpItem)
		local spawnVehItem = NativeUI.CreateItem(_U('admin_spawnveh_button'), "")
		adminMenu.SubMenu:AddItem(spawnVehItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), "")
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == tptoXYZItem then
				admin_tp_pos()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == godmodeItem then
				admin_godmode()
			elseif item == ghostmodeItem then
				admin_mode_fantome()
			elseif item == superjumpItem then
				admin_mode_kangaroo()
			elseif item == spawnVehItem then
				admin_vehicle_spawn()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	end
end

function GeneratePersonalMenu()
	menuopen = true
	TriggerEvent('chat:toggleChat', true)
	AddMenuWalletMenu(mainMenu)

	if IsPedSittingInAnyVehicle(plyPed) then
		if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
			AddMenuVehicleMenu(mainMenu)
		end
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		AddMenuBossMenu(mainMenu)
	end

	AddMenuFacturesMenu(mainMenu)

	if playerGroup ~= nil and (playerGroup == 'moderator' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
		AddMenuAdminMenu(mainMenu)
	end

	_menuPool:RefreshIndex()
end

RegisterCommand('personalmenu', function()
	if mainMenu ~= nil and not mainMenu:Visible() then
		ESX.PlayerData = ESX.GetPlayerData()
		GeneratePersonalMenu()
		mainMenu:Visible(true)
	end
end, false)
RegisterKeyMapping('personalmenu', 'Open personal menu', 'keyboard', 'F5')

Citizen.CreateThread(function()
	while true do
		if _menuPool ~= nil and menuopen then
			_menuPool:ProcessMenus()
			Citizen.Wait(3)
		else Citizen.Wait(10) end
		
	end
end)

Citizen.CreateThread(function()
	while true do
		if ESX ~= nil then
			ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(group) playerGroup = group end)

			Citizen.Wait(30 * 1000)
		else
			Citizen.Wait(100)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 100
		plyPed = PlayerPedId()

		if showcoord then
			sleep = 2
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end

		if noclip then
			sleep = 2
			local x, y, z = getPosition()
			local dx, dy, dz = getCamDirection()
			local speed = Config.noclip_speed

			SetEntityVelocity(plyPed, 0.0001, 0.0001, 0.0001)

			if IsControlPressed(0, 32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(0, 269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			SetEntityCoordsNoOffset(plyPed, x, y, z, true, true, true)
		end

		if showname then
			sleep = 2
			for id = 0, 255 do
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= plyPed then
					local headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(id), (GetPlayerServerId(id) .. ' - ' .. GetPlayerName(id)), false, false, "", false)
				end
			end
		end
		
		Citizen.Wait(sleep)
	end
end)