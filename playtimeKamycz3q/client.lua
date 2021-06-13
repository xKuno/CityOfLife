

playtime = 0
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1000)
        playtime = playtime + 1

    end

end)

RegisterNetEvent("playtimeKamycz3q:check")
AddEventHandler("playtimeKamycz3q:check", function() 
    if playtime > 59 and playtime < 120 then
        TriggerEvent("chat:addMessage", {
            args = {
                "PlayTime",
                "Your playtime on this session is " .. math.floor((playtime/60)+0.5) .. " minute"
            },
            color = { 5, 255, 255 }
        })
    elseif playtime > 59 then
        TriggerEvent("chat:addMessage", {
            args = {
                "PlayTime",
                "Your playtime on this session is " .. math.floor((playtime/60)+0.5) .. " minutes"
            },
            color = { 5, 255, 255 }
        })
    else
        TriggerEvent("chat:addMessage", {
            args = {
                "PlayTime",
                "Your playtime on this session is " .. playtime .. " seconds"
            },
            color = { 5, 255, 255 }
        })
    end
    
end)