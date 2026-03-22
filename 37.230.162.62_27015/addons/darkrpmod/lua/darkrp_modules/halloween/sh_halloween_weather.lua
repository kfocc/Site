if not union.cvars.halloween:GetBool() then return end

local rad = StormFox2.Weather.Add( "Halloween" )
if CLIENT then
	function rad:GetName(nTime, nTemp, nWind, bThunder, nFraction )
		return "Halloween", "Halloween"
	end
else
	function rad:GetName(nTime, nTemp, nWind, bThunder, nFraction )
		return "Halloween", "Halloween"
	end
end

local m_def = Material("icons/fa32/calendar.png")
function rad.GetSymbol( nTime ) -- What the menu should show
	return m_def
end
function rad.GetIcon( nTime, nTemp, nWind, bThunder, nFraction) -- What symbol the weather should show
	return m_def
end

-- Day --
	rad:SetSunStamp("topColor",HexToColor("#901336"),SF_SKY_DAY)
	rad:SetSunStamp("bottomColor",Color(20, 55, 25),		SF_SKY_DAY)
	rad:SetSunStamp("duskColor",HexToColor("#783A23"),		SF_SKY_DAY)
	rad:SetSunStamp("duskScale",1,							SF_SKY_DAY)
	rad:SetSunStamp("HDRScale",0.33,						SF_SKY_DAY)
-- Night
	rad:SetSunStamp("topColor",HexToColor("#590700"),SF_SKY_NIGHT)
	rad:SetSunStamp("bottomColor",Color(2.25, 25,2.25),SF_SKY_NIGHT)
	rad:SetSunStamp("duskColor",HexToColor("#3F2600"),		SF_SKY_NIGHT)
	rad:SetSunStamp("duskScale",0,							SF_SKY_NIGHT)
	rad:SetSunStamp("HDRScale",0.1,							SF_SKY_NIGHT)
-- Sunset/rise
	rad:SetSunStamp("duskScale",0.26,	SF_SKY_SUNSET)
	rad:SetSunStamp("duskScale",0.26,	SF_SKY_SUNRISE)

if SERVER then
	hook.Add("InitPostEntity", "union.halloween.StormFox2", function()
		StormFox2.Setting.Set("auto_weather", false, true)
		StormFox2.Weather.Set("Halloween", 1)
	end)
end