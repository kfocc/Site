
/*---------------------------------------------------------------------------
	Icons
---------------------------------------------------------------------------*/
local base = "materials/erisf4/"
local icons = file.Find(base.."*.png", "GAME")

for k, v in pairs(icons) do
	local path = base..v

	if(SERVER && !Eris.Config.UseWorkshop) then
		resource.AddFile(path)
	else
		Eris.Icons = Eris.Icons || {}
		Eris.Icons[string.StripExtension(v)] = Material(path, "unlitgeneric")
	end
end


/*---------------------------------------------------------------------------
	Themes
---------------------------------------------------------------------------*/
local base = "eris/themes/"
local themes = file.Find(base.."*.lua", "LUA")

for k, v in pairs(themes) do
	local path = base..v

	if(SERVER) then
		AddCSLuaFile(path)
	else
		include(path)
	end
end