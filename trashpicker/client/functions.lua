
showPercent = function(time)
	percent = true
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1
	Citizen.Wait(time)
	until(TimeLeft == 100)
	percent = false
end

openBin = function(entity)
	searching = true
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
	showPercent(100)
    cachedBins[entity] = true
    TriggerServerEvent('esx_sopletare:getItem')
	ClearPedTasks(PlayerPedId())
	searching = false
end

openScrap = function(entity)
	searching = true
	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
	showPercent(100)
    cachedScrap[entity] = true
    TriggerServerEvent('esx_sopletare:getItem2')
	ClearPedTasks(PlayerPedId())
	searching = false
end
