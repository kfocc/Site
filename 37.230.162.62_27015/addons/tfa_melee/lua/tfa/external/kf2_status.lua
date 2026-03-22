TFA.AddStatus( "sawing" )
TFA.AddStatus( "sawing_end" )
TFA.Enum.HUDDisabledStatus = TFA.Enum.HUDDisabledStatus or TFA.Enum.ReadyStatus or {}
if not TFA.Enum.HUDDisabledStatus[ TFA.GetStatus("sawing") ] then
	TFA.Enum.HUDDisabledStatus[ TFA.GetStatus("sawing") ] = true
end
if not TFA.Enum.HUDDisabledStatus[ TFA.GetStatus("sawing_end") ] then
	TFA.Enum.HUDDisabledStatus[ TFA.GetStatus("sawing_end") ] = true
end