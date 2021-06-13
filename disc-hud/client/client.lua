ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

local cruiseIsOn = false
local seatbeltIsOn = false
local seatbeltEjectSpeed = 88               -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 100              -- Acceleration threshold to eject player (G's)


function CalculateTimeToDisplay()
    hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

    if hour <= 12 then
        obj.ampm = 'AM'
    elseif hour >= 13 then
        obj.ampm = 'PM'
        hour = hour - 12
    end

    if minute <= 9 then
        minute = "0" .. minute
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function getCardinalDirectionFromHeading(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Northbound" -- North
    elseif (heading >= 45 and heading < 135) then
        return "Eastbound" -- East
    elseif (heading >= 135 and heading < 225) then
        return "Southbound" -- South
    elseif (heading >= 225 and heading < 315) then
        return "Westbound" -- West
    end
end

function ToggleUI()
    showUi = not showUi

    if showUi then
        SendNUIMessage({
            action = 'showui'
        })

        if IsPedInAnyVehicle(PlayerPedId()) then
            SendNUIMessage({
                action = 'showcar'
            })
        end
    else
        SendNUIMessage({
            action = 'hideui'
        })
        SendNUIMessage({
            action = 'hidecar'
        })
    end
end


--General UI Updates
Citizen.CreateThread(function()
    Citizen.Wait(0)
    SendNUIMessage({
        action = 'showui'
    })

    while true do
        local player = PlayerPedId()
        currSpeed = GetEntitySpeed(GetVehiclePedIsIn(player))
        local speed
        local sign
        if ShouldUseMetricMeasurements() then
            speed = currSpeed * 3.6
            sign = 'KPH'
        else
            speed = currSpeed * 2.23694
            sign = 'MPH'
        end
		if currSpeed > 0.0 then speedLimit = exports['linden_outlawalert']:getSpeed() or 100 end
        local time = CalculateTimeToDisplay()
        local heading = getCardinalDirectionFromHeading(GetEntityHeading(player))
        local pos = GetEntityCoords(player)
        local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

        SendNUIMessage({
            action = 'tick',
            show = IsPauseMenuActive(),
            --health = (GetEntityHealth(player) - 100),
            --armor = GetPedArmour(player),
            time = time.hour .. ':' .. time.minute,
            ampm = time.ampm,
            direction = heading,
            street1 = GetStreetNameFromHashKey(var1),
            street2 = GetStreetNameFromHashKey(var2),
            area = current_zone,
            speed = math.ceil(speed),
			speedLimit = speedLimit,
            sign = sign
        })
        Citizen.Wait(200)
    end
end)


RegisterNetEvent('disc-hud:EnteredVehicle')
AddEventHandler('disc-hud:EnteredVehicle', function()
    SendNUIMessage({
        action = 'showcar'
    })

    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player)

    local prevHp = GetEntityHealth(veh)

    DisplayRadar(true)
    cruiseIsOn = false
    seatbeltIsOn = false
    Citizen.CreateThread(function()
        while IsPedInAnyVehicle(player) do
            Citizen.Wait(0)
            -- When player in driver seat, handle cruise control
            if (GetPedInVehicleSeat(veh, -1) == player) then
                -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
                if IsControlJustReleased(2, 19) then
                    if cruiseIsOn then
                        exports['mythic_notify']:SendAlert('inform', 'Cruise Disabled')
                    else
                        exports['mythic_notify']:SendAlert('inform', 'Cruise Activated')
                    end

                    cruiseIsOn = not cruiseIsOn
                    SendNUIMessage({
                        action = 'toggle-cruise'
                    })
                    cruiseSpeed = GetEntitySpeed(veh)
                end
                local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveMaxFlatVel")
                SetEntityMaxSpeed(veh, maxSpeed)
            end
        end
    end)

    Citizen.CreateThread(function()
        local currSpeed = 0
        local prevVelocity = { x = 0.0, y = 0.0, z = 0.0 }
        while true do
            Citizen.Wait(0)
            local prevSpeed = currSpeed
            local position = GetEntityCoords(player)
            currSpeed = GetEntitySpeed(veh)
            if not seatbeltIsOn then
                local vehIsMovingFwd = GetEntitySpeedVector(veh, true).y > 1.0
                local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                if (vehIsMovingFwd and (prevSpeed > seatbeltEjectSpeed) and (vehAcc > (seatbeltEjectAccel * 9.81))) then
                    SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                    SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                else
                    prevVelocity = GetEntityVelocity(veh)
                end
            else
                DisableControlAction(0, 75)
            end
        end
    end)
	
    Citizen.CreateThread(function()
        while IsPedInAnyVehicle(player) do
            Citizen.Wait(0)
            if IsControlJustReleased(0, 29) then
                local vehClass = GetVehicleClass(veh)
                if vehClass ~= 8 and vehClass ~= 13 and vehClass ~= 14 then
                    if seatbeltIsOn then
						Citizen.Wait(100)
						print('seatbelt un-buckled')
						TriggerServerEvent("InteractSound_SV:PlayOnSource", "buckle", 0.4)
						Citizen.Wait(100)
                    else
						Citizen.Wait(100)
						print('seatbelt buckled')
						TriggerServerEvent("InteractSound_SV:PlayOnSource", "unbuckle", 0.4)
						Citizen.Wait(100)
                    end
                    seatbeltIsOn = not seatbeltIsOn
                    SendNUIMessage({
                        action = 'toggle-seatbelt'
                    })
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while IsPedInAnyVehicle(player) do
            Citizen.Wait(1000)
        end
        DisplayRadar(false)
        seatbeltIsOn = false
        cruiseIsOn = false
        SendNUIMessage({
            action = 'hidecar'
        })
    end)

    Citizen.CreateThread(function()
        while IsPedInAnyVehicle(player) do
            SendNUIMessage({
                action = 'update-fuel',
                fuel = math.ceil(GetVehicleFuelLevel(veh))
            })
            Citizen.Wait(5000)
        end
    end)
end)

RegisterNetEvent('disc-hud:EnteringVehicle')
AddEventHandler('disc-hud:EnteringVehicle', function(veh)
    seatbeltIsOn = false
    cruiseIsOn = false
    SendNUIMessage({
        action = "set-seatbelt",
        seatbelt = false
    })
    SendNUIMessage({
        action = "set-cruise",
        cruise = false
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        HideHudComponentThisFrame(7) -- Area Name
        HideHudComponentThisFrame(9) -- Street Name
        HideHudComponentThisFrame(3) -- SP Cash display
        HideHudComponentThisFrame(4)  -- MP Cash display
        HideHudComponentThisFrame(13) -- Cash changesSetPedHelmet(PlayerPedId(), false)
		
        if IsControlJustReleased(0, 344) then
            ToggleUI()
			exports['mythic_notify']:SendAlert('inform', 'Hud toggled with F11.')
        end
    end
end)
