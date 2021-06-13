local FirstSpawn, PlayerLoaded, EMSCount = true, false, nil, 0

thecount = 0
isCop = false
isEMS = false
ragdol = 1    
local IsDead = false
inwater = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SetPlayerInvincible(PlayerId(), false)
	end
end)

RegisterNetEvent('nowCopDeathOff')
AddEventHandler('nowCopDeathOff', function()
    isCop = false
end)

RegisterNetEvent('nowCopDeath')
AddEventHandler('nowCopDeath', function()
    isCop = true
    mymodel = GetEntityModel(PlayerPedId())
end)

RegisterNetEvent('nowEMSDeathOff')
AddEventHandler('nowEMSDeathOff', function()
    isEMS = false
end)

RegisterNetEvent('hasSignedOnEms')
AddEventHandler('hasSignedOnEms', function()
    isEMS = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
	IsDead = false
	ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
		if isDead and Config.AntiCombatLog then
			OnPlayerDeath()
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)



function GetDeath()
    if IsDead then
        return true
    elseif not IsDead then
        return false
    end
end

exports('GetDeath', GetDeath)

-- Create blips
--[[ Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
	end
end) ]]


function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.40, 0.40)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_ambulancejob:EMSCount')
AddEventHandler('esx_ambulancejob:EMSCount', function(count)
	EMSCount = count
end)

function OnPlayerDeath(doNotCount)
	TriggerServerEvent('esx_ambulancejob:getEMSCount')
	IsDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    TriggerEvent('mythic_hospital:client:RemoveBleed')
	deathTimer()
end

Citizen.CreateThread(function()
    IsDead = false
    ragdol = 0
    while true do
        Wait(100)
        if IsEntityDead(PlayerPedId()) then 
            --print(GetPedCauseOfDeath(PlayerPedId()))
            if not IsDead then
                IsDead = true
                deathTimer()
				SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
				plyPos = GetEntityCoords(PlayerPedId())
            end
        end
    end
end)


RegisterNetEvent('doTimer')
AddEventHandler('doTimer', function()
    while IsDead do
        Citizen.Wait(0)
        if thecount > 0 then
            drawTxt(0.94, 1.44, 1.0,1.0,0.6, "Respawn: ~r~" .. math.ceil(thecount) .. "~w~ seconds remaining", 255, 255, 255, 255)
        else
            drawTxt(0.94, 1.44, 1.0,1.0,0.6, "~w~ PRESS ~r~E ~w~TO ~r~RESPAWN ~w~OR WAIT FOR A ~r~MEDIC", 255, 255, 255, 255)
        end
    end
end)

dragged = false
RegisterNetEvent('deathdrop')
AddEventHandler('deathdrop', function(beingDragged)
    dragged = beingDragged
    if beingDragged and IsDead then
        --TriggerEvent('resurrect:relationships')
    end
      if not beingDragged and IsDead then
        SetEntityHealth(PlayerPedId(), 200.0)
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 1.0) )
    end 
end)


RegisterNetEvent('resurrect:relationships')
AddEventHandler('resurrect:relationships', function()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    NetworkResurrectLocalPlayer(plyPos, true, true, false)
    resetrelations()
end)


RegisterNetEvent('ressurection:relationships:norevive')
AddEventHandler('ressurection:relationships:norevive', function()
    resetrelations()
end)

deathanims = {
    [1] = "dead_a",
    [2] = "dead_b",
    [3] = "dead_c",
    [4] = "dead_d",
    [5] = "dead_e",
    [6] = "dead_f",
    [7] = "dead_g",
    [8] = "dead_h",

}

myanim = "dead_a"

function InVeh()
  if IsPedSittingInAnyVehicle(PlayerPedId()) then
    return true
  else
    return false
  end
end

function resetrelations()
    Citizen.Wait(1000)
    if isCop or isEMS then
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),GetHashKey('MISSION2'))
        SetPedRelationshipGroupHash(PlayerPedId(),GetHashKey('MISSION2'))
    else
        SetPedRelationshipGroupDefaultHash(PlayerPedId(),GetHashKey('PLAYER'))
        SetPedRelationshipGroupHash(PlayerPedId(),GetHashKey('PLAYER'))
    end
end

local disablingloop = false
RegisterNetEvent('disableAllActions')
AddEventHandler('disableAllActions', function()
    if not disablingloop then
        disablingloop = true
        Citizen.Wait(100)
        while GetEntitySpeed(PlayerPedId()) > 0.5 do
            Citizen.Wait(1)
        end 
        Citizen.Wait(100)
        TriggerEvent("resurrect:relationships")
      --  SetPedCanRagdoll(PlayerPedId(), false)
	  	TriggerEvent("deathAnim")
        local inveh = 0
		local DeathKeys = {24, 257, 25, 263, 45, 22, 44, 37, 23, 288, 170, 167, 73, 36, 264, 257, 140, 141, 142, 143, 75}
        while IsDead do
            Citizen.Wait(3) 

			for i=1, #DeathKeys do
				DisableControlAction(0, DeathKeys[i], true)
			end

            if IsEntityInWater(PlayerPedId()) then
                inwater = true
            else
                inwater = false
            end
            if InVeh() then
                if not inveh then
                    inveh = true
                end
            elseif not InVeh() and inveh and GetEntityHeightAboveGround(PlayerPedId()) < 2.0 or inveh == 0 and GetEntityHeightAboveGround(PlayerPedId()) < 2.0 then
                inveh = false
			end
            TriggerEvent("deathAnim")
        end
      --  SetPedCanRagdoll(PlayerPedId(), true)
        disablingloop = false
    end
end)

local tryingAnim = false
local enteringveh = false
RegisterNetEvent('respawn:sleepanims')
AddEventHandler('respawn:sleepanims', function()
    if not enteringveh then
        enteringveh = true
        ClearPedTasksImmediately(PlayerPedId())
        Citizen.Wait(1000)
        enteringveh = false   
    end
end)
function deadcaranim()
   loadAnimDict( "veh@low@front_ps@idle_duck" ) 
   TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 8.0, -8, -1, 1, 0, 0, 0, 0)
end
myanim = "dead_a"
RegisterNetEvent('deathAnim')
AddEventHandler('deathAnim', function()
    if not dragged and not tryingAnim and not enteringveh and not InVeh() and IsDead then
		local playerPed = PlayerPedId()
        tryingAnim = true
        while GetEntitySpeed(playerPed) > 0.5 and not inwater do
            Citizen.Wait(3)
        end        
        if inwater then
			SetPedCanRagdoll(playerPed, true)
            SetEntityCoords(GetEntityCoords(playerPed))
            SetPedToRagdoll(playerPed, 1000, 1000, 3, 0, 0, 0) 
        else
			if GetResourceState('linden_animals') ~= 'started' or exports.linden_animals:animal() == false then
				loadAnimDict( "dead" ) 
				if IsEntityPlayingAnim(playerPed, "dead", myanim, 3) == false then
					SetPedCanRagdoll(playerPed, false)
					ClearPedTasks(playerPed)
					SetEntityCoords(playerPed,GetEntityCoords(playerPed))
					TaskPlayAnim(playerPed, "dead", myanim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
				end
			end
        end
		Citizen.Wait(2000)
        tryingAnim = false
    end
end)

function loadAnimDict( dict )
    RequestAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        
        Citizen.Wait( 3 )
    end
end

function deathTimer()
    thecount = 300
    TriggerEvent("doTimer")
    IsDead = true
	SetPlayerInvincible(PlayerId(), true)
	StartDistressSignal()



    TriggerEvent("disableAllActions")
    while IsDead do
        
        Citizen.Wait(100)
        thecount = thecount - 0.1

        if thecount == 60 or thecount == 120 or thecount == 180 or thecount == 240 then
            TriggerEvent("civilian:alertPolice",100.0,"death",0)
        end
        --SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        while thecount < 0 do
            Citizen.Wait(1)
             
            if IsControlJustPressed(1,38) then
              thecount = 99999999
			  RemoveItemsAfterRPDeath()
            end
        end      
    end
end

local canSendDistress = true
function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer
		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30
			if not EMSCount then EMSCount = 0 end
			local distressText = _U('distress_send').. ' ('..EMSCount..' EMS available)'

			SetTextFont(4)
			SetTextScale(0.40, 0.40)
			SetTextColour(185, 185, 185, 255)
			SetTextCentre(1)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(distressText)
			EndTextCommandDisplayText(0.5, 0.90)

			if IsControlJustReleased(0, 47) then
				if canSendDistress then
					SendDistressSignal()
				end
 			end
		end
	end)
end

function SendDistressSignal()
	if EMSCount > 0 and canSendDistress then
		canSendDistress = false
		local netId = NetworkGetNetworkIdFromEntity(PlayerPedId())
		local data = {dispatchCode = 'persondown', 'Local', coords = GetEntityCoords(PlayerPedId()), netId = netId, length = 15000}
		if ESX.PlayerData.job.name == 'police' then data.dispatchCode = 'officerdown' end
		TriggerServerEvent('wf-alerts:svNotify', data)
		exports['mythic_notify']:SendAlert('error', 'EMS Have been called and are on route to your location. <br /><br /> Sit tight and they will be with you as soon as possible.<br />', 5000)
		Citizen.Wait(40000)
		canSendDistress = true
	elseif not canSendDistress then
		exports['mythic_notify']:SendAlert('error', 'You need to wait before sending another distress signal', 5000)
	else
		exports['mythic_notify']:SendAlert('error', 'No EMS are available to receive your signal<br/>You can safely go to the hospital without losing anything', 5000)
		Citizen.Wait(1000)
		canSendDistress = true
	end
end


function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function releaseBody()
    thecount = 240
    IsDead = false   
    ragdol = 1
    ClearPedTasksImmediately(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)

    ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
            SetEntityCoords(PlayerPedId(), 1798.75, 2482.944, -122.69)
            exports['mythic_notify']:SendAlert('inform', 'You have been revived by medical staff in jail.')
        else
            if isCop then
                SetEntityCoords(PlayerPedId(), 441.60, -982.37, 30.67)
            else
                SetEntityCoords(PlayerPedId(), 355.0, -585.7, 43.3)
            end
            exports['mythic_notify']:SendAlert('inform', 'You have been revived by medical staff.')
        end

	end)


    
    ClearPedBloodDamage(PlayerPedId())
    local plyPos = GetEntityCoords(PlayerPedId(),true)
    TriggerEvent("resurrect:relationships")
    SetCurrentPedWeapon(PlayerPedId(),2725352035,true)
    Citizen.CreateThread(function()
        Citizen.Wait(4000)
    end)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.95)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, 38) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()

					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
			
		if bleedoutTimer < 1 and IsDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(PlayerPedId()) then
		ragdol = 1
		SetPedCanRagdoll(PlayerPedId(), true)
		end
	end
end)

function RemoveItemsAfterRPDeath()
	SetPlayerInvincible(PlayerId(), false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		
		thecount = 240
		IsDead = false   
		ragdol = 1
		ClearPedTasksImmediately(PlayerPedId())
		ClearPedBloodDamage(PlayerPedId())
		local plyPos = GetEntityCoords(PlayerPedId(),true)
		TriggerEvent("resurrect:relationships")
		SetCurrentPedWeapon(PlayerPedId(),2725352035,true)

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local playerpos = GetEntityCoords( PlayerPedId() )
			StopScreenEffect('DeathFailOut')
			RespawnPed(PlayerPedId(), playerpos, Config.RespawnPoint.heading)

			--[[ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
				if inJail then
					TriggerServerEvent('mythic_hospital:server:RequestBed', 'prison')
				else
					TriggerServerEvent('mythic_hospital:server:RequestBed', 'hospital')
				end
			end)]]
			TriggerServerEvent('mythic_hospital:server:RequestBed', 'hospital')
			DoScreenFadeIn(800)

			TriggerServerEvent('esx:updateLastPosition', playerpos)
		end, EMSCount)
	end)
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
    }
    
	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	ClearPedBloodDamage(ped)

	TriggerEvent('mythic_hospital:client:RemoveBleed', ped) 
	TriggerEvent('mythic_hospital:client:ResetLimbs', ped)

	ESX.UI.Menu.CloseAll()
end

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

RegisterNetEvent('reviveFunction')
AddEventHandler('reviveFunction', function()
    attemptRevive(true)
end)

function attemptRevive(noanim)
    if IsDead then
        ragdol = 1
        IsDead = false
        thecount = 240
        TriggerEvent("Heal")
        ClearPedBloodDamage(PlayerPedId())        
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        TriggerEvent("resurrect:relationships")
        ClearPedTasksImmediately(PlayerPedId())
        Citizen.Wait(500)
		SetPlayerInvincible(PlayerId(), false)
        getup(noanim)
    end
end

function getup(noanim)
    ClearPedSecondaryTask(PlayerPedId())
    SetPedCanRagdoll(PlayerPedId(), true)
	--[[if noanim ~= false then
		loadAnimDict( "random@crash_rescue@help_victim_up" ) 
		TaskPlayAnim( PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
		--SetCurrentPedWeapon(PlayerPedId(),2725352035,true)
		Citizen.Wait(3000)
		endanimation()
	end]]
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	TriggerEvent('esx:onPlayerSpawn')
end

function endanimation()
    ClearPedSecondaryTask(PlayerPedId())
end

RegisterNetEvent("heal")
AddEventHandler('heal', function()
	local ped = PlayerPedId()
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
		TriggerEvent('mythic_hospital:client:ResetLimbs')
		TriggerEvent('mythic_hospital:client:RemoveBleed')
		ragdol = 0
	end
end)

RegisterNetEvent('tp_ambulancejob:revive')
AddEventHandler('tp_ambulancejob:revive', function()
	attemptRevive()
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end


--curDist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), 0), 2438.3266601563,4960.3046875,47.27229309082,true)
