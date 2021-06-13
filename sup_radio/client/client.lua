--===============================================================================
--=== Made by Alcapone aka suprisex. No script distribution! ===
--===================== for LS-Story.pl =================================
--===============================================================================


-- ESX

ESX = nil
local PlayerData                = {}
local myPedId = nil

local phoneProp = 0
local phoneModel = "prop_cs_hand_radio"

local currentStatus = 'out'
local lastDict = nil
local lastAnim = nil
local lastIsFreeze = false
local oIsAnimationOn = false
local oObjectProp = "prop_cs_hand_radio"
local oObject_net = nil

local ANIMS = {
	['cellphone@'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_listen_base',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_call_out',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	},
	['anim@cellphone@in_car@ps'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_in',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_horizontal_exit',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	}
}

function supRadioAnimation()
  local player = PlayerPedId()
  local playerID = PlayerId()
  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
  local phoneRspawned = CreateObject(GetHashKey(oObjectProp), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
  local netid = ObjToNet(phoneRspawned)
  local ad = "amb@world_human_stand_mobile@female@text@enter"
  local ad2 = "amb@world_human_stand_mobile@female@text@base"
  local ad3 = "amb@world_human_stand_mobile@female@text@exit"

  if (DoesEntityExist(player) and not IsEntityDead(player)) then
      loadAnimDict(ad)
      loadAnimDict(ad2)
      loadAnimDict(ad3)
      RequestModel(GetHashKey(oObjectProp))
      if oIsAnimationOn == true then
          --EnableGui(false)
          TaskPlayAnim(player, ad3, "exit", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
          Wait(1840)
          DetachEntity(NetToObj(oObject_net), 1, 1)
          DeleteEntity(NetToObj(oObject_net))
          Wait(750)
          ClearPedSecondaryTask(player)
          oObject_net = nil
          oIsAnimationOn = false
      else
          oIsAnimationOn = true
          Wait(500)
          --SetNetworkIdExistsOnAllMachines(netid, true)
          --NetworkSetNetworkIdDynamic(netid, true)
          --SetNetworkIdCanMigrate(netid, false)
          TaskPlayAnim(player, ad, "enter", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
          Wait(1360)
          AttachEntityToEntity(phoneRspawned,GetPlayerPed(playerID),GetPedBoneIndex(GetPlayerPed(playerID), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
          oObject_net = netid
          Wait(200)
          --EnableGui(true)
      end
  end
end

function newRadioProp()
	deleteRadio()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone = GetPedBoneIndex(myPedId, 28422)
	AttachEntityToEntity(phoneProp, myPedId, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function deleteRadio ()
	if phoneProp ~= 0 then
		Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(phoneProp))
		phoneProp = 0
	end
end

function RadioPlayAnim (status, freeze, force)
	if currentStatus == status and force ~= true then
		return
	end

	myPedId = PlayerPedId()
	local freeze = freeze or false

	local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId, false) then
		dict = "anim@cellphone@in_car@ps"
	end
	loadAnimDict(dict)

	local anim = ANIMS[dict][currentStatus][status]
	if currentStatus ~= 'out' then
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end
	local flag = 50
	if freeze == true then
		flag = 14
	end
	TaskPlayAnim(myPedId, dict, anim, 3.0, -1, -1, flag, 0, false, false, false)

	if status ~= 'out' and currentStatus == 'out' then
		Citizen.Wait(380)
		newRadioProp()
	end

	lastDict = dict
	lastAnim = anim
	lastIsFreeze = freeze
	currentStatus = status

	if status == 'out' then
		Citizen.Wait(180)
		deleteRadio()
		StopAnimTask(myPedId, lastDict, lastAnim, 1.0)
	end

end

function RadioPlayOut ()
	RadioPlayAnim('out')
end

function RadioPlayText ()
	RadioPlayAnim('text')
end

function PhonePlayCall (freeze)
	RadioPlayAnim('call', freeze)
end

function PhonePlayIn () 
	if currentStatus == 'out' then
		RadioPlayText()
	end
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end

function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({

    type = "enableui",
    enable = enable

  })

end

--[[ sprawdza czy komenda /radio jest włączony

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)
]]

-- radio test

RegisterCommand('radiotest', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  --local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  print(tonumber(data))

  if data == "nil" then
    exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
  else
   exports['mythic_notify']:SendAlert('inform', Config.messages['on_radio'] .. data .. '.00 MHz </b>')
 end

end, false)

-- dołączanie do radia

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    --local getPlayerRadioChannel = exports["pma-voice"]:SetRadioChannel("radio:channel")

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        if tonumber(data.channel) <= Config.RestrictedChannels then
          if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire' or PlayerData.job.name == 'security') then
            exports["pma-voice"]:removePlayerFromRadio()
            exports["pma-voice"]:SetRadioChannel(tonumber(data.channel))
            exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
            exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
          elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire' or PlayerData.job.name == 'security') then
            --- info że nie możesz dołączyć bo nie jesteś policjantem
            exports['mythic_notify']:SendAlert('error', Config.messages['restricted_channel_error'])
          end
        end
        if tonumber(data.channel) > Config.RestrictedChannels then
          exports["pma-voice"]:removePlayerFromRadio()
          exports["pma-voice"]:SetRadioChannel(tonumber(data.channel))
          exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
          exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        end
      else
        exports['mythic_notify']:SendAlert('error', Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
      end
      --[[
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
    exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
    PrintChatMessage("radio: " .. data.channel)
    print('radiook')
      ]]--
    cb('ok')
end)

-- opuszczanie radia

RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local isOpen = exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)

    if isOpen then
      exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
        else
          exports["pma-voice"]:removePlayerFromRadio()
          exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
          exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'])
    end

   cb('ok')

end)

function loadAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Citizen.Wait(5)
  end
end


RegisterNUICallback('escape', function(data, cb)
   PlayerData = ESX.GetPlayerData()

   enableRadio(false)
   SetNuiFocus(false, false)

   if PlayerData.job.name == 'police'  then
   supRadioAnimation()
   elseif PlayerData.job.name ~= 'police' then
    RadioPlayOut()
    deleteRadio()
   end


    cb('ok')
end)

-- net eventy

RegisterNetEvent('sup_radio:use')
AddEventHandler('sup_radio:use', function()
  PlayerData = ESX.GetPlayerData()

  if PlayerData.job.name == 'police'  then
  supRadioAnimation()
  enableRadio(true)
  elseif PlayerData.job.name ~= 'police' then
  RadioPlayText()
  newRadioProp()
  enableRadio(true)
  end
end)

RegisterNetEvent('sup_radio:onRadioDrop')
AddEventHandler('sup_radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)

    exports["pma-voice"]:removePlayerFromRadio()
    exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
    --exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'])
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('sup_radio:close-radio')
AddEventHandler('sup_radio:close-radio', function(player)
    local playerName = GetPlayerName(PlayerId())
    local isOpen = exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)

    if isOpen then
        exports["pma-voice"]:removePlayerFromRadio()
        exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
        exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'])
    end
end)

RegisterCommand('connect', function(source, args) 
  local channel = args[1]
  local job = PlayerData.job
  local playerName = GetPlayerName(PlayerId())
  --local getPlayerRadioChannel = exports["pma-voice"]:SetRadioChannel("radio:channel")

  ESX.TriggerServerCallback('sup_radio:getItemAmount', function(quantity, data, cb)
    if quantity > 0 then 
      if args[1] then 
        local number = tonumber(args[1])
          PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name ~= 'police' then
             if number > 10 then
                RadioPlayText()
                newRadioProp()
                exports["pma-voice"]:removePlayerFromRadio()
                --exports.tokovoip_script:setPlayerData(playerName, "radio:channel", number, true);
                exports["pma-voice"]:SetRadioChannel(number)
                exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
                exports['mythic_notify']:SendAlert('inform', 'You joined the radio channel:'.. number.. '.00 MHz')
                Citizen.Wait(1500)
                RadioPlayOut()
                deleteRadio()

                kanalodasi = kanalsayi

             else 
                exports['mythic_notify']:SendAlert('error', 'You cannot access encrypted channels')
             end 
          end
        end
     end 
  end, 'radio')
end)

RegisterCommand('pd', function(source, args) 
  local channel = args[1]
  local job = PlayerData.job
  local playerName = GetPlayerName(PlayerId())
  --local getPlayerRadioChannel = exports["pma-voice"]:SetRadioChannel("radio:channel")

  ESX.TriggerServerCallback('sup_radio:getItemAmount', function(quantity)
    if quantity > 0 then 
      if args[1] then 
        local number = tonumber(args[1])
          if number > 0 then 
            PlayerData = ESX.GetPlayerData()
              if PlayerData.job.name == 'police' then
                supRadioAnimation()
                exports["pma-voice"]:removePlayerFromRadio()
                --exports.tokovoip_script:setPlayerData(playerName, "radio:channel", number, true);
                exports["pma-voice"]:SetRadioChannel(number)
                exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
                exports['mythic_notify']:SendAlert('inform', 'You joined the radio channel: '.. number.. '.00 MHz')
                Citizen.Wait(1500)
                supRadioAnimation()
              else 
                exports['mythic_notify']:SendAlert('error', 'You cannot connect to encrypted channels')
              end 
              else 
                  exports['mythic_notify']:SendAlert('error', 'You cannot connect to encrypted channels')
              end 
          end
      end 
  end, 'radio')
end)

RegisterCommand('ayrıl', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  --local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")
  local kanalsayi = tonumber(kanalodasi)

  PlayerData = ESX.GetPlayerData()
    if PlayerData.job.name == 'police' then
      supRadioAnimation()
      exports["pma-voice"]:removePlayerFromRadio()
      exports['mythic_notify']:SendAlert('inform', 'You left the radio channel: ' .. getPlayerRadioChannel.. '.00 MHz')
      Citizen.Wait(1500)
      supRadioAnimation()
    elseif PlayerData.job.name ~= 'police' then
      RadioPlayText()
      newRadioProp()
      exports["pma-voice"]:removePlayerFromRadio()
      exports['mythic_notify']:SendAlert('inform', 'You left the radio channel: ' .. getPlayerRadioChannel.. '.00 MHz')
      Citizen.Wait(1500)
      RadioPlayOut()
      deleteRadio()
    end
end)