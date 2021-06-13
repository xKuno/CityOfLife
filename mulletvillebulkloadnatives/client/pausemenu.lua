print("^2[MVRP] ^3Util Pausemenu Ready")

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end


Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'Welcome to Ozark - You are Id ' ..GetPlayerServerId(PlayerId()).. ' ')
  AddTextEntry('PM_PANE_LEAVE', '~r~Return to the server list.')
  AddTextEntry('PM_PANE_QUIT', '~r~Quit')
  AddTextEntry('PM_SCR_MAP', '~r~Map')
  AddTextEntry('PM_SCR_GAM', '~r~Take the plane')
  AddTextEntry('PM_SCR_INF', '~r~Logs')
  AddTextEntry('PM_SCR_SET', '~r~Settings')
  AddTextEntry('PM_SCR_STA', '~r~Stats')
  SetMissionName_2(true, "Welcome to the city, Have fun dont be a jerk")
  AddTextEntry('PM_SCR_RPL', '~r~∑ Editor')
end)
