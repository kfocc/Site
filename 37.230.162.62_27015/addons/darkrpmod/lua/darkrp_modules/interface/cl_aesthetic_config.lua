AS = AS or {}
local ScreenHeight
if CLIENT then
	ScreenHeight = ScrH()
else
	ScreenHeight = 20
end

--CONFIG--
AS.BoxSize = ScreenHeight / 12 -- Change the default box size. It depends on your screen height.
AS.HeightOffset = ScreenHeight / 5 -- Change vertical position of the hud. It also depends on your screens height.
AS.Spacing = 10 -- Change spacing between the boxes
AS.SideSpacing = 14 -- Change the spacing between the screen edge and the hud
AS.RectMul = 3 -- How long should the weapon boxes be
AS.AutoHideTime = 4 -- Time after the hud hides (in seconds)

AS.SelectedColor = col.o -- Selected box color
AS.OutlineColor = col.oa -- Outline color
AS.UnselectedColor = col.ba -- Unselected box color
AS.UnselectedAltColor = col.ba -- Unselected color used in additional weapon boxes
AS.EmptyColor = col.b -- Empty box color
AS.WepBoxOutlineColor = col.ba -- Color of the border around weapon icon box
AS.WepBoxBackgroundColor = col.baw -- Color of the weapon icon box
AS.UnselectedFontColor = col.wka -- Font color used in unselected boxes
AS.SelectedFontColor = col.wk -- Font color used in selected boxes
AS.AllowDisabling = 1 -- Allow players to disable the hud through the menu or the command. (aesthetic_menu 0)

AS.WeaponRotationSpeed = 50
AS.WeaponModelColor = col.w --[[Color(200, 200, 200, 55)]] -- Change the displayed weapons color
AS.WeaponMaterialOverride = "" --[["models/wireframe"]] -- Change to "" if you don't want to override material / "models/wireframe" for the default wireframe look

AS.DefaultWeaponModel = "" -- If a weapon doesn't have a world model what should we use?

AS.MovingSound = "UI/buttonrollover.wav" -- Sound when switching weapons
AS.SelectionSound = "UI/buttonclickrelease.wav" -- Weapon selection sound

-- Header font
surface.CreateFont("AS.HeaderFont", {
	font = "Courier New",
	size = ScreenHeight / 28,
	weight = 10,
	scanlines = 2,
	strikeout = true,
	outline = true,
	extended = true,
})

-- Main font
surface.CreateFont("AS.NormalSizeFont", {
	font = "Segoe UI",
	size = ScreenHeight / 54,
	weight = 100,
	strikeout = true,
	additive = true,
	outline = true,
	extended = true,
})
