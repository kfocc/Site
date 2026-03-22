/*---------------------------------------------------------------------------
	Panel for the headers of categories
---------------------------------------------------------------------------*/
local HEADER = {}
AccessorFunc(HEADER, "text", "Text", FORCE_STRING)
AccessorFunc(HEADER, "color", "Color")

function HEADER:Init()
	self:SetLabel("")
	self.Spacing = ScreenScale(10)

	self.Header:SetTall(36)
	self.Header.Alpha = 0
	self.Header.Paint = function(s, w, h)
		local text = self:GetText()
		surface.SetFont("ErisF4Category")
		local tw, th = surface.GetTextSize(text)

		local x = 20

		draw.SimpleText(text, "ErisF4Category", x, h/2, Eris:Theme("header"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(self:GetColor())
		surface.DrawRect(x, h-2, tw+3, 2)

		s.Alpha = Lerp(FrameTime()*8, s.Alpha, s:IsHovered()&&1||0)
		if(s.Alpha>0.01) then
			local w = tw+x*2
			local aw, ah = math.Round(s.Alpha*w), math.Round(s.Alpha*h)
			
			surface.SetDrawColor(ColorAlpha(self:GetColor(), s.Alpha*100))
			surface.DrawRect(1, 0, aw-1, 1)
			surface.DrawRect(0, 0, 1, ah-1)
			surface.DrawRect(w-aw, h-1, aw, 1)
			surface.DrawRect(w, h-ah, 1, ah)
		end
	end
end


/*---------------------------------------------------------------------------
	Setting the header to a category
---------------------------------------------------------------------------*/
function HEADER:SetCategory(cat)
	if(cat.startExpanded) then
		self:SetExpanded(true)
		self:DockPadding(0, 0, 0, self.Spacing)
	end

	self:SetText(cat.name)
	self:SetColor(cat.color)
end


/*---------------------------------------------------------------------------
	Proper padding under the category
---------------------------------------------------------------------------*/
function HEADER:OnToggle()
	self:DockPadding(0, 0, 0, self:GetExpanded() && self.Spacing || 0)
end


/*---------------------------------------------------------------------------
	Clearing the paint function
---------------------------------------------------------------------------*/
function HEADER:Paint(w, h) end


/*---------------------------------------------------------------------------
	Registering the panel
---------------------------------------------------------------------------*/
vgui.Register("ErisF4CategoryHeader", HEADER, "DCollapsibleCategory")