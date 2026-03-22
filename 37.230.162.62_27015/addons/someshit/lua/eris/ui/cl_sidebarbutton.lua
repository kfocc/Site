/*---------------------------------------------------------------------------
	Font for our buttons
---------------------------------------------------------------------------*/
surface.CreateFont("ErisF4Button", {font = "Roboto", size = 24, weight = 100, extended = true})


/*---------------------------------------------------------------------------
	Custom panel for our sidebar buttons
---------------------------------------------------------------------------*/
local BUTTON = {}
AccessorFunc(BUTTON, "depressed", "Depressed", FORCE_BOOL)
AccessorFunc(BUTTON, "text", "DisplayText", FORCE_STRING)
AccessorFunc(BUTTON, "iconName", "IconName", FORCE_STRING)
AccessorFunc(BUTTON, "squareTabs", "SquareTabs", FORCE_BOOL)

function BUTTON:Init()
	self:SetTall(42)
	self:SetText("")

	self.HoverAlpha = 0
	self.SelectedProgress = 0
end

function BUTTON:GetPoly(w, h)
	local corner = h/2
	return {
		{x = 0, y = 0},
		{x = w-corner, y = 0},
		{x = w, y = corner},
		{x = w, y = corner},
		{x = w-corner, y = h},
		{x = 0, y = h}
	}
end

local iconSize = 32

function BUTTON:Paint(w, h)
	if !Eris.Icons then return end

	self.HoverAlpha = Lerp(FrameTime()*10, self.HoverAlpha, self:IsHovered() && 30 || 0)
	self.SelectedProgress = Lerp(FrameTime()*10, self.SelectedProgress, self:GetDepressed() && w || 0)

	surface.SetDrawColor(Eris:Theme("tabs"))

	local poly
	if(self:GetSquareTabs()) then
		surface.DrawRect(0, 0, w, h)
	else
		poly = self:GetPoly(w, h)

		draw.NoTexture()
		surface.DrawPoly(poly)
	end

	local margin = h/2-iconSize/2
	surface.SetDrawColor(self:IsHovered() and Eris:Theme("accent") or Eris:Theme("tabtext"))
	surface.SetMaterial(Eris.Icons[self:GetIconName()])
	surface.DrawTexturedRect(0, margin, iconSize, iconSize)


	surface.SetDrawColor(Eris:Theme("accent"))
	surface.DrawRect(iconSize + 4, 0, 4, h)

	surface.SetDrawColor(255, 255, 255, self.HoverAlpha)

	if(self:GetSquareTabs()) then
		surface.DrawRect(0, 0, w, h)
	else
		draw.NoTexture()
		surface.DrawPoly(poly)
	end

	surface.SetDrawColor(ColorAlpha(Eris:Theme("accent"), 100))

	if(self:GetSquareTabs()) then
		surface.DrawRect(0, 0, math.Round(self.SelectedProgress), h)
	else
		surface.DrawPoly(self:GetPoly(math.Round(self.SelectedProgress), h))
	end

	draw.SimpleText(self:GetDisplayText(), "ErisF4Button", margin*2+iconSize+4, h/2, Eris:Theme("tabtext"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("ErisF4SidebarButton", BUTTON, "DButton")