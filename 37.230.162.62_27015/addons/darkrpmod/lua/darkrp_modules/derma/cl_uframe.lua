surface.CreateFont("UFont.Big", {
	font = "Roboto",
	size = ScreenScale(16),
	weight = 100,
	extended = true,
})

surface.CreateFont("UFont.Main", {
	font = "Roboto",
	size = ScreenScale(10),
	extended = true,
})

surface.CreateFont("UFont.HUD", {
	font = "Roboto",
	size = ScreenScale(9),
	weight = 200,
	extended = true,
})

local makeColor = Color(0, 18, 10)
function NiceBlur(panel, thickness, xpos, ypos, width, height)
	local x, y = nil
	local w, h = nil
	local xe, ye = nil
	if IsValid(panel) then
		x, y = panel:GetPos()
		w, h = panel:GetSize()
		xe, ye = panel:ScreenToLocal(x, y)
	else
		x, y = 0, 0
		w, h = width, height
		xe, ye = xpos, ypos
	end

	for i = 0, thickness do
		makeColor.a = 25 + i * 4
		draw.RoundedBox(8, xe + i * 2, ye + i * 2, w - i * 4, h - i * 4, makeColor)
	end

	makeColor.a = 25 + thickness * 4
	draw.RoundedBox(8, xe + thickness * 2, ye + thickness * 2, w - thickness * 4, h - thickness * 4, makeColor)
end

local PANEL = {}
function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self.OnKeyCodeReleased = function(me, key) if key == KEY_E or key == KEY_ESCAPE then if me.CloseButton then me.CloseButton:DoClick() end end end
	self:CloseOnEscape()
end

function PANEL:ShowClose(bool)
	if bool then
		local back = DialogSys.CreateButton(self, "ЗКРТЬ E)", "UFont.Main")
		back:SizeToContents()
		local off = self:GetWide() * .05
		back:SetPos(self:GetWide() - off * .3 - back:GetWide(), self:GetTall() * .825)
		back.DoClick = function()
			surface.PlaySound("ui/ok.mp3")
			self:Remove()
		end

		self.CloseButton = back
	else
		if IsValid(self.CloseButton) then self.CloseButton:Remove() end
	end
end

function PANEL:SetTitle1(t1)
	if IsValid(self.Title) then self.Title:Remove() end
	if IsValid(self.TitleBlur) then self.TitleBlur:Remove() end

	self.Title, self.TitleBlur = Fallout_DLabel(self, self:GetWide() * .075, 0, t1, "UFont.Big", col.o)
end

function PANEL:Paint(w, h)
	local title = self.Title
	NiceBlur(self, 10)
	--draw.RoundedBox( 8, 0, 0, w, h, col.ba )
end

vgui.Register("UnionFrame", PANEL, "DFrame")
local PANEL = {}
function PANEL:DefaultPaint()
	self.VBar.Paint = function(self) draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(70, 70, 70, 100)) end

	local col = self.DrawColor or col.o
	self.VBar.btnUp.Paint = function(self)
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(col.r, col.g, col.b, 100)) --0,154,255
	end

	self.VBar.btnDown.Paint = function(self) draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(col.r, col.g, col.b, 100)) end

	self.VBar.btnGrip.Paint = function(me)
		local half = self.HalfPaint
		if half then
			local w = me:GetWide() * .3
			draw.RoundedBox(0, me:GetWide() / 2 - w / 2, 0, w, me:GetTall(), col)
			return
		end

		draw.RoundedBox(4, 0, 0, me:GetWide(), me:GetTall(), col)
	end
end

function PANEL:Init()
	--self:EnableVerticalScrollbar(true)
	self:ErisScrollbar()
	--self:DefaultPaint()
	hook.Run("U.PanelList_Open", self)
end

vgui.Register("UnionPanelList", PANEL, "DScrollPanel")
