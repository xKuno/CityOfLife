RegisterNetEvent('playershield:Client:SetPlayerArmour')
AddEventHandler('playershield:Client:SetPlayerArmour', function(armour)
    Citizen.Wait(9000)  -- Give ESX time to load their stuff. Because some how ESX remove the armour when load the ped.
                        -- If there is a better way to do this, make an pull request with 'Tu eres una papa' (you are a potato) as a subject
    SetPedArmour(PlayerPedId(), tonumber(armour))
end)

local TimeFreshCurrentArmour = 10000  -- 1s

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        TriggerServerEvent('playershield:Server:RefreshCurrentArmour', GetPedArmour(PlayerPedId()))
        Citizen.Wait(TimeFreshCurrentArmour)
    end
end)