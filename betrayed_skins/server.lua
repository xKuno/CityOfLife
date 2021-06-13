ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function()
    local src = source
    TriggerClientEvent('betrayed_skins:guardarSkin',src)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local jobSkin = {
  skin_male   = xPlayer.job.skin_male,
  skin_female = xPlayer.job.skin_female}
  cb(nil, jobSkin)
end)


ESX.RegisterServerCallback('betrayed_skins:getSex', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT sex FROM users WHERE identifier = @identifier", {["identifier"] = xPlayer.identifier}, function(result)
        cb(result[1].sex)
    end)
  end)

local function checkExistenceClothes(identifier, cb)
    MySQL.Async.fetchAll("SELECT identifier FROM character_current WHERE identifier = @identifier LIMIT 1;", {["identifier"] = identifier}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

local function checkExistenceFace(identifier, cb)
    MySQL.Async.fetchAll("SELECT identifier FROM character_face WHERE identifier = @identifier LIMIT 1;", {["identifier"] = identifier}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

RegisterServerEvent("betrayed_skins:insert_character_current")
AddEventHandler("betrayed_skins:insert_character_current",function(data)
    if not data then return end
    local src = source
    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier
    if not characterId then return end
    checkExistenceClothes(characterId, function(exists)
        local values = {
            ["identifier"] = characterId,
            ["model"] = json.encode(data.model),
            ["drawables"] = json.encode(data.drawables),
            ["props"] = json.encode(data.props),
            ["drawtextures"] = json.encode(data.drawtextures),
            ["proptextures"] = json.encode(data.proptextures),
        }

        if not exists then
            local cols = "identifier, model, drawables, props, drawtextures, proptextures"
            local vals = "@identifier, @model, @drawables, @props, @drawtextures, @proptextures"

            MySQL.Async.execute("INSERT INTO character_current ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
        MySQL.Async.execute("UPDATE character_current SET "..set.." WHERE identifier = @identifier", values)
    end)
end)

RegisterServerEvent("betrayed_skins:insert_character_face")
AddEventHandler("betrayed_skins:insert_character_face",function(data)
    if not data then return end
    local src = source

    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    checkExistenceFace(characterId, function(exists)
        if data.headBlend == "null" or data.headBlend == nil then
            data.headBlend = '[]'
        else
            data.headBlend = json.encode(data.headBlend)
        end
        local values = {
            ["identifier"] = characterId,
            ["hairColor"] = json.encode(data.hairColor),
            ["headBlend"] = data.headBlend,
            ["headOverlay"] = json.encode(data.headOverlay),
            ["headStructure"] = json.encode(data.headStructure),
        }

        if not exists then
            local cols = "identifier, hairColor, headBlend, headOverlay, headStructure"
            local vals = "@identifier, @hairColor, @headBlend, @headOverlay, @headStructure"

            MySQL.Async.execute("INSERT INTO character_face ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "hairColor = @hairColor,headBlend = @headBlend, headOverlay = @headOverlay,headStructure = @headStructure"
        MySQL.Async.execute("UPDATE character_face SET "..set.." WHERE identifier = @identifier", values )
    end)
end)

RegisterServerEvent("betrayed_skins:get_character_face")
AddEventHandler("betrayed_skins:get_character_face",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT cc.model, cf.hairColor, cf.headBlend, cf.headOverlay, cf.headStructure FROM character_face cf INNER JOIN character_current cc on cc.identifier = cf.identifier WHERE cf.identifier = @identifier", {['identifier'] = characterId}, function(result)
        if (result ~= nil and result[1] ~= nil) then
            local temp_data = {
                hairColor = json.decode(result[1].hairColor),
                headBlend = json.decode(result[1].headBlend),
                headOverlay = json.decode(result[1].headOverlay),
                headStructure = json.decode(result[1].headStructure),
            }
            local model = tonumber(result[1].model)
            if model == 1885233650 or model == -1667301416 then
                TriggerClientEvent("betrayed_skins:setpedfeatures", src, temp_data)
            end
        else
            TriggerClientEvent("betrayed_skins:setpedfeatures", src, false)
        end
	end)
end)

RegisterServerEvent("betrayed_skins:get_character_current")
AddEventHandler("betrayed_skins:get_character_current",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT * FROM character_current WHERE identifier = @identifier", {['identifier'] = characterId}, function(result)
        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }
        TriggerClientEvent("betrayed_skins:setclothes", src, temp_data,0)
	end)
end)

RegisterServerEvent("betrayed_skins:retrieve_tats")
AddEventHandler("betrayed_skins:retrieve_tats", function(pSrc)
    local src = (not pSrc and source or pSrc)
	local user = ESX.GetPlayerFromId(src)
	MySQL.Async.fetchAll("SELECT * FROM playerstattoos WHERE identifier = @identifier", {['identifier'] = user.identifier}, function(result)
        if(#result == 1) then
			TriggerClientEvent("betrayed_skins:settattoos", src, json.decode(result[1].tattoos))
		else
			local tattooValue = "{}"
			MySQL.Async.execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['identifier'] = user.identifier, ['tattoo'] = tattooValue})
			TriggerClientEvent("betrayed_skins:settattoos", src, {})
		end
	end)
end)

RegisterServerEvent("betrayed_skins:set_tats")
AddEventHandler("betrayed_skins:set_tats", function(tattoosList)
	local src = source
	local user = ESX.GetPlayerFromId(src)
	MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['tattoos'] = json.encode(tattoosList), ['identifier'] = user.identifier})
end)


RegisterServerEvent("betrayed_skins:get_outfit")
AddEventHandler("betrayed_skins:get_outfit",function(slot)
    if not slot then return end
    local src = source

    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT * FROM character_outfits WHERE identifier = @identifier and slot = @slot", {
        ['identifier'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            if result[1].model == nil then
                --TriggerClientEvent("DoLongHudText", src, "Can not use.",2)
                return
            end

            local data = {
                model = result[1].model,
                drawables = json.decode(result[1].drawables),
                props = json.decode(result[1].props),
                drawtextures = json.decode(result[1].drawtextures),
                proptextures = json.decode(result[1].proptextures),
                hairColor = json.decode(result[1].hairColor)
            }

            TriggerClientEvent("betrayed_skins:setclothes", src, data,0)

            local values = {
                ["identifier"] = characterId,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
            }

            local set = "model = @model, drawables = @drawables, props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            MySQL.Async.execute("UPDATE character_current SET "..set.." WHERE identifier = @identifier",values)

        else
			TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'No outfit in slot '..slot, length = 5000})
            return
        end
	end)
end)

RegisterServerEvent("betrayed_skins:set_outfit")
AddEventHandler("betrayed_skins:set_outfit",function(slot, name, data)
    if not slot then return end
    local src = source

    local user = ESX.GetPlayerFromId(src)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchAll("SELECT slot FROM character_outfits WHERE identifier = @identifier and slot = @slot", {
        ['identifier'] = characterId,
        ['slot'] = slot
    }, function(result)
        if result and result[1] then
            local values = {
                ["identifier"] = characterId,
                ["slot"] = slot,
                ["name"] = name,
                ["model"] = json.encode(data.model),
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor),
            }

            local set = "model = @model,name = @name,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures,hairColor = @hairColor"
            MySQL.Async.execute("UPDATE character_outfits SET "..set.." WHERE identifier = @identifier and slot = @slot",values)
        else
            local cols = "identifier, model, name, slot, drawables, props, drawtextures, proptextures, hairColor"
            local vals = "@identifier, @model, @name, @slot, @drawables, @props, @drawtextures, @proptextures, @hairColor"

            local values = {
                ["identifier"] = characterId,
                ["name"] = name,
                ["slot"] = slot,
                ["model"] = data.model,
                ["drawables"] = json.encode(data.drawables),
                ["props"] = json.encode(data.props),
                ["drawtextures"] = json.encode(data.drawtextures),
                ["proptextures"] = json.encode(data.proptextures),
                ["hairColor"] = json.encode(data.hairColor)
            }

            MySQL.Async.execute("INSERT INTO character_outfits ("..cols..") VALUES ("..vals..")", values, function()
				TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Saved outfit to slot '..slot, length = 5000})
            end)
        end
	end)
end)


RegisterServerEvent("betrayed_skins:remove_outfit")
AddEventHandler("betrayed_skins:remove_outfit",function(slot)

    local src = source
    local user = ESX.GetPlayerFromId(src)
    local identifier = user.identifier
    local slot = slot

    if not identifier then return end

    MySQL.Async.execute( "DELETE FROM character_outfits WHERE identifier = @identifier AND slot = @slot", { ['identifier'] = identifier,  ["slot"] = slot } )
	TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'Removed outfit '..slot, length = 5000})
end)

RegisterServerEvent("betrayed_skins:list_outfits")
AddEventHandler("betrayed_skins:list_outfits",function()
    local src = source
    local user = ESX.GetPlayerFromId(src)
    local identifier = user.identifier
    local slot = slot
    local name = name

    if not identifier then return end

    MySQL.Async.fetchAll("SELECT slot, name FROM character_outfits WHERE identifier = @identifier", {['identifier'] = identifier}, function(skincheck)
    	TriggerClientEvent("betrayed_skins:listOutfits",src, skincheck)
	end)
end)


RegisterServerEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function()
    local src = source
    local user = ESX.GetPlayerFromId(src)
    local identifier = user.identifier

    MySQL.Async.fetchAll("SELECT * FROM character_current WHERE identifier = @identifier LIMIT 1", {
        ['identifier'] = identifier
    }, function(result)
        local isService = false;
        if user.job.name == "police" or user.job.name == "ambulance" then isService = true end

        if result[1] == nil then
            MySQL.Async.fetchAll("SELECT skin FROM users WHERE identifier = @identifier", {["identifier"] = identifier}, function(result)
                if result[1].skin then
                    TriggerClientEvent('betrayed_skins:setclothes',src,{},json.decode(result[1].skin))
                else
                    TriggerClientEvent('betrayed_skins:setclothes',src,{},nil)
                end
                return
            end)
        else
            TriggerEvent("betrayed_skins:get_character_current", src)
        end
        TriggerClientEvent("betrayed_skins:inService",src,isService)
    end)
end)

RegisterServerEvent("clothing:checkMoney")
AddEventHandler("clothing:checkMoney", function(menu,askingPrice)
    local src = source
    local target = ESX.GetPlayerFromId(src)

    if not askingPrice
    then
        askingPrice = 0
    end

    if (tonumber(target.getMoney()) >= askingPrice) then
        target.removeMoney(askingPrice)
        TriggerClientEvent("DoShortHudText",src, "You Paid $"..askingPrice,8)
        TriggerClientEvent("betrayed_skins:hasEnough",src,menu)
    else
        TriggerClientEvent("DoShortHudText",src, "You need $"..askingPrice.." + Tax.",2)
    end
end)

ESX.RegisterCommand({'dress'}, 'superadmin', function(xPlayer, args, showError)
	local identifier = args.playerId.identifier

	MySQL.Async.fetchAll("SELECT * FROM character_current WHERE identifier = @identifier", {['identifier'] = identifier}, function(result)
        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }
        TriggerClientEvent("setClothes", xPlayer.source, temp_data)
	end)

end, true, {help = 'dress as another player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'}
}})
