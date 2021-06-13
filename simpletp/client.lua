key_to_teleport = 38

positions = {
    --[[
    {{Teleport1 X, Teleport1 Y, Teleport1 Z, Teleport1 Heading}, {Teleport2 X, Teleport 2Y, Teleport 2Z, Teleport2 Heading}, {Red, Green, Blue}, "Text for Teleport"}
    ]]
    {{330.32, -600.92, 42.28, 0}, {338.52, -583.88, 73.16, 0},{36,237,157}, ""},
	{{327.15, -603.58, 42.28, 345}, {344.47, -586.22, 27.79, 245},{36,237,157}, ""},
    {{338.52, -583.88, 73.16, 0}, {330.32, -600.92, 42.28, 0},{255, 157, 0}, ""},
    {{-305.32, -721.4, 27.04, 0}, {-287.72, -722.72, 124.48, 0},{36,237,157}, ""}, 
    {{-287.72, -722.72, 124.48, 0}, {-305.32, -721.4, 27.04, 0},{255, 157, 0}, ""},
    {{134.64, -130.52, 59.56, 0}, {134.76, -133.96, 53.92, 0},{36,237,157}, ""}, 
    {{134.76, -133.96, 53.92, 0}, {134.64, -130.52, 59.56, 0},{255, 157, 0}, ""},	
    {{279.52, -1349.76, 23.52, 0}, {332.32, -595.68, 42.28, 0},{36,237,157}, ""}, 
    {{332.32, -595.68, 42.28, 0}, {279.52, -1349.76, 23.52, 0},{255, 157, 0}, ""},
    {{136.04, -761.72, 241.16, 0}, {136.28, -761.56, 44.76, 0},{36,237,157}, ""}, 
    {{136.28, -761.56, 44.76, 0}, {136.04, -761.72, 241.16, 0},{255, 157, 0}, ""}, 
    {{507.76, 5491.72, 756.44, 0}, {505.36, 5490.88, 749.56, 0},{255, 157, 0}, ""},
    {{-1545.36, -246.96, 47.28, 0}, {-1545.28, -247.04, 50.6, 0},{255, 157, 0}, ""},
    {{-1562.52, -272.32, 50.6, 0}, {-1562.56, -272.36, 53.64, 0},{255, 157, 0}, ""},
    {{-1581.8, -263.12, 47.28, 0}, {-1581.08, -280.6, 50.64, 0},{255, 157, 0}, ""},
    {{-1582.72, -262.68, 50.64, 0}, {-1581.16, -280.36, 53.68, 0},{255, 157, 0}, ""},
    {{-969.44, -1318.2, 17.0, 0}, {-954.84, -1302.32, 18.2, 0},{255, 157, 0}, ""},
    {{-969.16, -1321.72, 18.2, 0}, {-970.2, -1322.04, 45.48, 0},{255, 157, 0}, ""},
    {{-976.48, -1293.48, 17.0, 0}, {-988.24, -1307.28, 18.2, 0},{255, 157, 0}, ""},
    {{-977.56, -1290.28, 18.2, 0}, {-977.16, -1289.96, 45.52, 0},{255, 157, 0}, ""},
    {{-896.16, -1271.04, 17.0, 0}, {-876.64, -1266.12, 18.2, 0},{255, 157, 0}, ""},
    {{-898.92, -1273.56, 18.2, 0}, {-876.64, -1266.6, 45.48, 0},{255, 157, 0}, ""},
    {{-888.92, -1245.88, 17.0, 0}, {-907.56,-1255.96, 18.2, 0},{255, 157, 0}, ""},
    {{-888.92, -1243.44, 18.2, 0}, {-888.24,-1242.6, 45.48, 0},{255, 157, 0}, ""},
	{{-613.9286, -1612.81, 12.977, 342.54}, {-613.2274, -1624.871, 32.09, 176.2978}, {60, 204, 60}, ""},--gruppe sechs
}


-----------------------------------------------------------------------------
-------------------------DO NOT EDIT BELOW THIS LINE-------------------------
-----------------------------------------------------------------------------

local player = PlayerPedId()

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player)
		local draw = false

        for _,location in ipairs(positions) do
			local check = false
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]

			local dist1, dist2 = #(playerLoc - vector3(loc1.x, loc1.y, loc1.z)), #(playerLoc - vector3(loc2.x, loc2.y, loc2.z))

            if dist1 < 12.0 then check, draw = true, true DrawMarker(1, loc1.x, loc1.y, loc1.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0) end
            if dist2 < 12.0 then check, draw = true, true DrawMarker(1, loc2.x, loc2.y, loc2.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, Red, Green, Blue, 200, 0, 0, 0, 0) end

            if check and CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 2) then 
                alert(teleport_text)
                
                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end

            elseif check and CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 2) then
                alert(teleport_text)

                if IsControlJustReleased(1, key_to_teleport) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end            
        end
		if not draw then Citizen.Wait(100) end
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end