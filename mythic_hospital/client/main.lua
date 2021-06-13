local hospitalCheckin = { x = 312.3239, y = -592.8648, z = 43.2848, h = 180.4409942627 }
--local pillboxTeleports = {
--    { x = 325.48892211914, y = -598.75372314453, z = 43.291839599609, h = 64.513374328613, text = 'Press ~INPUT_CONTEXT~ ~s~to go to lower Pillbox Entrance' },
--    { x = 355.47183227539, y = -596.26495361328, z = 28.773477554321, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
--    { x = 359.57849121094, y = -584.90911865234, z = 28.817169189453, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
--}

local bedOccupying = nil
local bedObject = nil
local bedOccupyingData = nil

function playerInBed()
	return bedOccupying
end
exports('playerInBed', playerInBed)

local cam = nil

local inBedDict = "anim@gangops@morgue@table@"
local inBedAnim = "ko_front"
local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end

    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    SetPlayerInvincible(PlayerId(), false)
    coords = GetEntityCoords(PlayerPedId())

    SetEntityHeading(PlayerPedId(), bedOccupyingData.h - 90)
    TaskPlayAnimAdvanced(PlayerPedId(), getOutDict , getOutAnim , coords.x , coords.y , coords.z-0.8 , GetEntityRotation(PlayerPedId()) , 8.0, -8.0, -1, 0, 0, false, false )
    Citizen.Wait(9000)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('mythic_hospital:server:LeaveBed', bedOccupying)

    FreezeEntityPosition(bedObject, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
end

RegisterNetEvent('mythic_hospital:client:RPCheckPos')
AddEventHandler('mythic_hospital:client:RPCheckPos', function()
    TriggerServerEvent('mythic_hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('mythic_hospital:client:RPSendToBed')
AddEventHandler('mythic_hospital:client:RPSendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data

    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)

    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), data.h + 180)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)

    SetPlayerInvincible(PlayerId(), true)
	TriggerEvent('reviveFunction')


    Citizen.CreateThread(function()
        while bedOccupyingData ~= nil do
            Citizen.Wait(1)
            PrintHelpText('Press ~INPUT_VEH_DUCK~ to get up')
            if IsControlJustReleased(0, 73) then
                LeaveBed()
            end
        end
    end)
end)


RegisterNetEvent('mythic_hospital:client:SendToBed')
AddEventHandler('mythic_hospital:client:SendToBed', function(id, data, type)
    bedOccupying = id
    bedOccupyingData = data
    bedType = type

    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)
	TriggerEvent('reviveFunction')

    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)

    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end
    
    bedHeading = data.h

    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, true, true, true )
    if bedType == 'prison' then
        print('Spawning in Bolingbrook hospital')
        SetEntityHeading(PlayerPedId(), bedHeading -180)
    elseif bedType == 'hospital' or not bedType then
        print('Spawning at Pillbox hospital')
        SetEntityHeading(PlayerPedId(), bedHeading - 180)
    end
    SetPlayerInvincible(PlayerId(), true)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)

    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()

        exports['mythic_notify']:SendAlert('inform', 'You are being treated')
        Citizen.Wait(Config.AIHealTimer * 1000)
        TriggerServerEvent('mythic_hospital:server:EnteredBed')
		TriggerEvent('mythic_hospital:client:ResetLimbs')
		TriggerEvent('mythic_hospital:client:RemoveBleed')
		ClearPedBloodDamage(PlayerPedId())  
		SetPlayerInvincible(PlayerId(), false)  
    end)
end)

RegisterNetEvent('mythic_hospital:client:FinishServices')
AddEventHandler('mythic_hospital:client:FinishServices', function()
	local player = PlayerPedId()
	
	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
	end	
	SetEntityHealth(player, GetEntityMaxHealth(player))
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)
    TriggerEvent('mythic_hospital:client:RemoveBleed')
    TriggerEvent('mythic_hospital:client:ResetLimbs')

    Citizen.CreateThread(function()
        while bedOccupyingData ~= nil do
            Citizen.Wait(1)
            PrintHelpText('Press ~INPUT_VEH_DUCK~ to get up')
            if IsControlJustReleased(0, 73) then
                LeaveBed()
                TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
                exports['mythic_notify']:SendAlert('inform', 'You have been treated')
            end
        end
    end)
end)

RegisterNetEvent('mythic_hospital:client:ForceLeaveBed')
AddEventHandler('mythic_hospital:client:ForceLeaveBed', function()
    LeaveBed()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local distance = #(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z) - plyCoords)
        if distance < 10 then
            --DrawMarker(27, hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 1, 157, 0, 155, false, false, 2, false, false, false, false)

            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    --PrintHelpText('Press ~INPUT_CONTEXT~ ~s~to check in')
                    ESX.Game.Utils.DrawText3D(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z + 0.5), '[E] Check in', 0.4)
					if IsControlJustReleased(0, 54) then
                        --if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                            exports['mythic_progbar']:Progress({
                                name = "hospital_action",
                                duration = 10500,
                                label = "Checking In",
                                useWhileDead = true,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "missheistdockssetup1clipboard@base",
                                    anim = "base",
                                    flags = 49,
                                },
                                prop = {
                                    model = "p_amb_clipboard_01",
                                    bone = 18905,
                                    coords = { x = 0.10, y = 0.02, z = 0.08 },
                                    rotation = { x = -80.0, y = 0.0, z = 0.0 },
                                },
                                propTwo = {
                                    model = "prop_pencil_01",
                                    bone = 58866,
                                    coords = { x = 0.12, y = 0.0, z = 0.001 },
                                    rotation = { x = -150.0, y = 0.0, z = 0.0 },
                                },
                            }, function(status)
                                if not status then
                                    TriggerServerEvent('mythic_hospital:server:RequestBed', 'hospital')
                                end
                            end)
                        --else
                        --    exports['mythic_notify']:SendAlert('error', 'You do not require medical attention')
                        --end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
