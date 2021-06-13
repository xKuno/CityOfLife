-----------------Unlimited stamana-----------
print("^2[MVRP] ^3Util unlimited stamina Ready")
Citizen.CreateThread(function()
	while true do
		RestorePlayerStamina(PlayerId(), 1.0)
		Citizen.Wait(0)
	end
end)
-----------------End of unlimited stamana-----------
----------------------Disable crosshair ----------------
print("^2[MVRP] ^3Util Disable crosshair Ready")
Citizen.CreateThread(function()
    local isSniper = false
    while true do
        Citizen.Wait(3)

        local ped = PlayerPedId()
        local currentWeaponHash = GetSelectedPedWeapon(ped)

        if currentWeaponHash == 100416529 then
            isSniper = true
        elseif currentWeaponHash == 205991906 then
            isSniper = true
        elseif currentWeaponHash == -952879014 then
            isSniper = true
        elseif currentWeaponHash == `WEAPON_HEAVYSNIPER_MK2` then
            isSniper = true
        else
            isSniper = false
        end

        if not isSniper then
            HideHudComponentThisFrame(14)
        end
    end
end)
----------------------End of disable crosshair and ammo counter ----------------
----------------------Start of disable vehicle rollover?------------------------
print("^2[MVRP] ^3Util disable vehicle rollover Ready")
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
        if IsEntityUpsidedown(veh) then
            DisableControlAction(0, 59) -- leaning left/right
            DisableControlAction(0, 60) -- leaning up/down
        end               
    end
end)
----------------------End of start of disable vehicle rollover?------------------------
----------------------Calm water -----------------------------------------------

print("^2[MVRP] ^3Util Calm water Ready")
Citizen.CreateThread(function()
	while true do
		Wait(0)
		Citizen.InvokeNative(0xC54A08C85AE4D410, 0.6)
	end
end)
----------------------End of calm water -----------------------------------------------
-----------------Weapon damage overrides------------------------
print("^2[MVRP] ^3Util Weapon damage nerf Ready")
Citizen.CreateThread(function()
	SetWeaponDamageModifier(`WEAPON_UNARMED`, 0.25)
	SetWeaponDamageModifier(`WEAPON_NIGHTSTICK`, 0.3)
	SetWeaponDamageModifier(`WEAPON_GRENADE`, 0.3)
	SetWeaponDamageModifier(`WEAPON_MOLOTOV`, 0.3)
	SetWeaponDamageModifier(`WEAPON_STICKYBOMB`, 0.3)
	SetWeaponDamageModifier(`WEAPON_PIPEBOMB`, 0.3)
	SetWeaponDamageModifier(`WEAPON_BALL`, 0.3)
	SetWeaponDamageModifier(`WEAPON_FLARE`, 0.3)
	SetWeaponDamageModifier(`WEAPON_RPG`, 0.1)
end)
-----------------End of weapon damage overrides------------------------
------------------Remove vehicle rewards ----------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)
------------------ End Remove vehicle rewards ----------
----------------  Weapon smack disabled / unlimited fire extinguisher :D------------
--[[Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed( -1 )
        local weapon = GetSelectedPedWeapon(ped)

		if weapon ~= GetHashKey("WEAPON_UNARMED") then
			if IsPedArmed(ped, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") or  weapon == GetHashKey("WEAPON_PETROLCAN") then
				if IsPedShooting(ped) then
					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
				end
			end
		else
			Citizen.Wait(500)
		end

        Citizen.Wait(7)
    end
end)]]
----------------  End of weapon smack disabled / unlimited fire extinguisher :D------------
---------------- Enable PVP--------------------
AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
    StatSetInt(`MP0_STAMINA`, 100, true)
    StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
end)

-----------------Custom plates--------------------------------
--[[imageUrl = "https://i.imgur.com/YPJdOTT.png" -- Paste your image URL here (doesn't have to be from imgur)

local textureDic = CreateRuntimeTxd('duiTxd')
for i = 1, 10 do

    local object = CreateDui(imageUrl, 540, 300)
    _G.object = object

    local handle = GetDuiHandle(object)
    local tx = CreateRuntimeTextureFromDuiHandle(textureDic, 'duiTex', handle)

    AddReplaceTexture('vehshare', 'plate01', 'duiTxd', 'duiTex')

end

local textureDic = CreateRuntimeTxd('duiTxd')
for i = 1, 10 do
	RemoveAllPedWeapons(player)
    local object = CreateDui('https://i.imgur.com/Q3uw6V7.png', 540, 300)-- this URL doesn't need to be edited, its just the 2d model for the plate
    _G.object = object

    local handle = GetDuiHandle(object)
    local tx = CreateRuntimeTextureFromDuiHandle(textureDic, 'duiTex', handle)

    AddReplaceTexture('vehshare', 'plate01_n', 'duiTxd', 'duiTex')

end]]
-----------------End of custom plates--------------------------------