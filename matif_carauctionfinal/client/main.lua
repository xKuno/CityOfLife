ESX = nil
valor = nil
running = false
blipon = false
leilao = nil
got = false
tdisplay = 'Loading..'
temporestante = 0
licitacoes = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(100)
		if temporestante ~= 0 then
			temporestante = temporestante - 1000
			if temporestante > 60000 and temporestante < 120000 then
				tdisplay = math.floor((temporestante / 10000) / 6) .. ' minute e ' .. math.floor((temporestante / 1000) - (math.floor((temporestante / 10000) / 6)*60)) .. ' seconds'
			elseif temporestante > 120000 then
				tdisplay = math.floor((temporestante / 10000) / 6) .. ' minutes e ' .. math.floor((temporestante / 1000) - (math.floor((temporestante / 10000) / 6)*60)) .. ' seconds'
			elseif temporestante == 0 then
				tdisplay = 'Wait..'
			else
				tdisplay = math.floor(temporestante / 1000) .. ' seconds'
			end
			Citizen.Wait(1000)
		end
	end	
end)


Citizen.CreateThread(function()
  while true do
	Citizen.Wait(10)
	local pedcoord = GetEntityCoords(PlayerPedId())
	local dist = GetDistanceBetweenCoords(pedcoord.x, pedcoord.y, pedcoord.z, Config.Coords["Marker"].x, Config.Coords["Marker"].y, Config.Coords["Marker"].z, false)
	local dist2 = GetDistanceBetweenCoords(pedcoord.x, pedcoord.y, pedcoord.z, Config.Coords["FloatingText"].x, Config.Coords["FloatingText"].y, Config.Coords["FloatingText"].z, false)
	
    if dist < 8 then
      DrawText3Ds(Config.Coords["Marker"].x, Config.Coords["Marker"].y, Config.Coords["Marker"].z, 'Click [~g~E~s~] to access the auction house.', 0.4)
	end

	if got == false then
		TriggerServerEvent('matif_leilaocarros:server:forcesync')
		got = true
	end

	if dist2 < 20 and running == true then
		DrawText3DsB(Config.Coords["FloatingText"].x, Config.Coords["FloatingText"].y, Config.Coords["FloatingText"].z + 0.75, '~b~Item Auctioned: ~s~' .. leilao.nome, 0.4)
		DrawText3DsB(Config.Coords["FloatingText"].x, Config.Coords["FloatingText"].y, Config.Coords["FloatingText"].z + 0.35, '~b~Time Left: ~s~' .. tdisplay, 0.4)
		DrawText3DsB(Config.Coords["FloatingText"].x, Config.Coords["FloatingText"].y, Config.Coords["FloatingText"].z, '~b~Current Value: ~s~' .. leilao.valor, 0.4)
	end
	
	if dist < 3 then
		if IsControlJustPressed(0, 38) then
			abrirmenu()
		end
	end

	if dist2 < 20 and dist > 3 and running == true then
		if blipon == false then
			exports['mythic_notify']:PersistentAlert('START', '1','success','Click Y to bid')
			blipon = true
		end
		--ESX.ShowHelpNotification('Clica [~g~Y~s~] para licitares!')
		if IsControlJustPressed(0, 246) then
			if temporestante > 0 then
				TriggerServerEvent('matif_leilaocarros:sv:licitar')
			end
		end
	else
		if blipon == true then
			exports['mythic_notify']:PersistentAlert('END', '1')
			blipon = false
		end
	end

	
  end
end)

function abrirmenu()
	local elements = {}
	if running == false then
		table.insert(elements, {label = 'No auction happening now', value = 'ne'})
		table.insert(elements, {label = 'Start new auction', value = 'comecarleilao'})
	else
		table.insert(elements, {label = 'Item Auctioned: ' .. leilao.nome, value = 'ne2'})
		table.insert(elements, {label = 'Last bids', value = 'ulicitacoes'})
	end


	ESX.UI.Menu.Open(

		'default', GetCurrentResourceName(), 'matif_leilaocarros',
		{
		  title    = 'Auction House',
		  align    = 'top-left',
		  elements = elements
		},

		function(data, menu)
			--if data.current.value == 'licitar' then
				--TriggerEvent('matif_leilaocarros:client:licitar')
			if data.current.value == 'comecarleilao' then
				--print('a')
				menu.close()
				abrirmenucomecar()
			elseif data.current.value == 'ulicitacoes' then
				abrirmenulicitacoes()
			end
		end,

	  	function(data, menu)
			menu.close()
	  	end
	)
end

function abrirmenulicitacoes()
	local elements = {}

	if not table.empty(licitacoes) then
		for k,v in pairs(licitacoes) do
			local lb = v.nome .. ' - <span style="color:limegreen;">' .. v.valor .. '$</span>'
			--print(lb)
			table.insert(elements, {label = lb, preco = v.valor, value = 'ez'})
		end
	else
		table.insert(elements, {label = 'No one has bid yet!', preco = 1, value = 'ez'})
	end

	Citizen.Wait(100)

	--table.sort(elements)
	
	for k,v in pairs(elements) do
		--print(v.label)
	end

	ESX.UI.Menu.Open(

		'default', GetCurrentResourceName(), 'matif_leilaocarross',
		{
		  title    = 'Last bids',
		  align    = 'top-left',
		  elements = elements
		},

		function(data, menu)
			if data.current.value == 'ez' then
				--print('teste sucess')
			end
		end,

	  function(data, menu)
		menu.close()
		--abrirmenu()
	  end
	)
end

function abrirmenucomecar()
	local elements = {}
	local vehiclePropsList = {}

	ESX.TriggerServerCallback('matif_leilaocarros:cb:getcarros', function(vehicles)
		if not table.empty(vehicles) then
			for k,v in ipairs(vehicles) do
				local vehicleProps = json.decode(v.vehicle)
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleHash = vehicleProps.model
				local vehicleName
				vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
				table.insert(elements, {label = vehicleName, plate = vehicleProps.plate, props = vehicleProps})
			end
		else
			table.insert(elements, {label = "You don't own any vehicle."})
		end
	end)

	Citizen.Wait(500)

	ESX.UI.Menu.Open(

		'default', GetCurrentResourceName(), 'matif_leilaocarros',
		{
		  title    = 'Choose vehicle',
		  align    = 'top-left',
		  elements = elements
		},

		function(data, menu)
			local vehicleProps = vehiclePropsList[data.current.plate]
			if data.current.plate ~= nil then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'escolhernome', {
					title = 'Auction Title'
				}, function(data2, menu2)
					local nome = data2.value
					if nome ~= nil then
						menu2.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'precoinical', {
							title = 'Starting bid'
						}, function(dataa, menuu)
							local preco = dataa.value
							if tonumber(preco) ~= nil and tonumber(preco) >= 5000 then
								menuu.close()
								ESX.UI.Menu.CloseAll()
								comecarleilaoo(data.current.label, data.current.plate, nome, preco, data.current.props)
							else
								ESX.ShowNotification('Starting bid has to be more than $5,000')
							end
						end, function(dataa, menuu)
							menuu.close()
						end)
					else
						--print('nao pode estar vazio')
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end,

	  	function(data, menu)
			menu.close()
	  	end
	)

end


function comecarleilaoo(vehicleName, plate, nome, preco, props)
	--print(vehicleName)
	tabcomeco = {}

	tabcomeco.vehicleName = vehicleName 
	tabcomeco.plate = plate
	tabcomeco.nome = nome
	tabcomeco.valor = preco
	tabcomeco.props = props

	TriggerServerEvent('matif_leilaocarros:sv:comecarleilao', tabcomeco)

	ESX.Game.SpawnVehicle(props.model, { x = Config.Coords["CarSpawn"].x, y = Config.Coords["CarSpawn"].y, z = Config.Coords["CarSpawn"].z + 1}, 306.6, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, props)
	end)

	Citizen.Wait(1000)

	local vehicle = GetClosestVehicle(Config.Coords["CarSpawn"].x, Config.Coords["CarSpawn"].y, Config.Coords["CarSpawn"].z, 2.0, 0, 71)
	--print('------')
	--print(vehicle)
	FreezeEntityPosition(vehicle, true)
	SetEntityInvincible(vehicle, true)
end


RegisterNetEvent('matif_leilaocarros:client:apagarcarro')
AddEventHandler('matif_leilaocarros:client:apagarcarro', function()

	local vehicle = GetClosestVehicle(Config.Coords["CarSpawn"].x, Config.Coords["CarSpawn"].y, Config.Coords["CarSpawn"].z, 2.0, 0, 71)
	FreezeEntityPosition(vehicle, false)
	SetEntityInvincible(vehicle, false)
end)

RegisterNetEvent('matif_leilaocarros:client:apagarcarrol')
AddEventHandler('matif_leilaocarros:client:apagarcarrol', function()

	local vehicle = GetClosestVehicle(Config.Coords["CarSpawn"].x, Config.Coords["CarSpawn"].y, Config.Coords["CarSpawn"].z, 2.0, 0, 71)
	
	DeleteVehicle(vehicle)
end)

RegisterNetEvent('matif_leilaocarros:client:forcesync')
AddEventHandler('matif_leilaocarros:client:forcesync', function(auction, bidding)
	if auction.running then
		if temporestante == 0 then
			temporestante = auction.temporestante
		end
		running = true
	else
		running = false
	end
	licitacoes = bidding
end)

function table.empty(parsedTable)
	for _, _ in pairs(parsedTable) do
		return false
	end

	return true
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0, 0, 0, 0.0)
end

function DrawText3DsB(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	SetTextScale(0.6, 0.6)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0, 0, 0, 0.0)
end

