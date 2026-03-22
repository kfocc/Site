local panelMeta = FindMetaTable("Panel")
function panelMeta:FadeOut(time, removeOnEnd, callback)
	self:AlphaTo(0, time, 0, function()
		if removeOnEnd then
			if self.OnRemove then self:OnRemove() end
			self:Remove()
		end

		if callback then callback(self) end
	end)
end

function panelMeta:FadeIn(time, callback)
	self:SetAlpha(0)
	self:AlphaTo(255, time, 0, function() if callback then callback(self) end end)
end

function panelMeta:OnClick(leftClick, rightClick)
	self.OnMousePressed = function(self, type)
		if type == MOUSE_LEFT then
			leftClick(self)
		elseif rightClick and type == MOUSE_RIGHT then
			rightClick(self)
		end
	end
end

--[[
	MButton
]]
local PANEL = {}
AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "OldColor", "OldColor")
AccessorFunc(PANEL, "Uppercase", "Uppercase")
function PANEL:Init()
	self:SetColor(COLOR_WHITE)
	self:SetFont("HeaderFont")
	self:SetUppercase(false)
	self:SetCursor("hand")
	self:SetColor(COLOR_WHITE)
end

function PANEL:SetText(text)
	if self:GetUppercase() or string.find(self:GetFont(), "HeaderFont") then text = string.upper(text) end
	self:SetSize(surface.GetTextWidth(text, self:GetFont()))
	self.Text = text
end

function PANEL:SetColor(color)
	self:SetOldColor(self:GetColor() or color)
	self.Color = color
end

function PANEL:OnCursorEntered()
	self:SetColor(COLOR_HOVER)
end

function PANEL:OnCursorExited()
	self:SetColor(COLOR_WHITE)
end

function PANEL:Paint()
	self:SetOldColor(LerpColor(0.1, self:GetOldColor(), self:GetColor()))
	surface.DrawShadowText(self:GetText(), self:GetFont(), 0, 0, self:GetOldColor(), COLOR_BLACK, TEXT_ALIGN_LEFT)
end
derma.DefineControl("MButton", "", PANEL)

--[[
	MLabel
]]
local PANEL = {}
AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "Uppercase", "Uppercase")
AccessorFunc(PANEL, "TextAlign", "TextAlign")
function PANEL:Init()
	self:SetColor(COLOR_WHITE)
	self:SetFont("HeaderFont")
	self:SetUppercase(false)
	self:SetTextAlign(TEXT_ALIGN_LEFT)
end

function PANEL:SetText(text)
	if self:GetUppercase() or string.find(self:GetFont(), "HeaderFont") then text = string.upper(text) end
	self:SetSize(surface.GetTextWidth(text, self:GetFont()))
	self.Text = text
end

function PANEL:SetTextColor(col)
end

function PANEL:Paint()
	-- (text, font, posX, posY, textColor, shadowColor, align, shadowOffsetX, shadowOffsetY)
	surface.DrawShadowText(self:GetText(), self:GetFont(), 0, 0, self:GetColor(), COLOR_BLACK, self:GetTextAlign())
end
derma.DefineControl("MLabel", "", PANEL)

local lastItem
function RemoveLastItem()
	if lastItem and lastItem:IsValid() then lastItem:FadeOut(FADE_DELAY, true) end
end

hook.Add("VGUIMousePressed", "RemoveLastItem", function(panel)
	if lastItem and lastItem:IsValid() and not (panel == lastItem or panel:GetParent() and panel:GetParent():IsValid() and panel:GetParent() == lastItem) then
		RemoveLastItem()
	end
end)

--[[
	MList
]]
local PANEL = {}
AccessorFunc(PANEL, "Parent", "Parent")
AccessorFunc(PANEL, "Hover", "Hover")
function PANEL:Init()
	self.Items = {}
	self:SetSize(0, 0)
	self:FadeIn(FADE_DELAY / 2)
	--self:MakePopup()
	RemoveLastItem()
	lastItem = self
	self:MakePopup()
end

function PANEL:SetParent(parent)
	self.Parent = parent
end

function PANEL:AddItem(text, func)
	local button
	if func then
		button = vgui.Create("MButton")
		button:SetFont("TextFont")
		button:SetUppercase(false)
		button:SetText(text)
		button:OnClick(function(self)
			func(self)
			self:GetParent():FadeOut(FADE_DELAY, true)
		end)
	else
		button = vgui.Create("MLabel")
		button:SetFont("TextFont")
		button:SetUppercase(false)
		button:SetText(text)
	end

	button:SetParent(self)
	table.insert(self.Items, button)
	self:Rebuild()
end

function PANEL:Clear()
	for k, v in pairs(self.Items) do
		v:Remove()
	end

	self:Rebuild()
end

function PANEL:Rebuild()
	local posY = 7
	for k, v in pairs(self.Items) do
		v:SetPos(8, posY)
		posY = posY + v:GetTall() + 1
		if v:GetWide() > self:GetWide() - 16 then self:SetWide(v:GetWide() + 16) end
	end

	self:SetSize(self:GetWide(), posY + 7)
	self:SetPos(math.Clamp(gui.MouseX() + 1, 0, ScrW() - self:GetWide()), math.Clamp(gui.MouseY() - self:GetTall() / 2, 0, ScrH() - self:GetTall()))
end

function PANEL:OnRemove()
	for k, v in pairs(self.Items) do
		v:Remove()
	end
end

function PANEL:Paint()
	--[[surface.SetDrawColor( 255, 0, 0, 255)
	local verts = {}
	verts[1] = {x = 10, y = 0, u = 1, v = 1}
	verts[2] = {x = 0, y = 10 u = 1, v = 1}
	verts[3] = {x = 10 , y = 20 u = 1, v = 1}
	surface.DrawPoly(verts)]]
	draw.DrawRect(0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 250))
end

derma.DefineControl("MList", "", PANEL, "EditablePanel")
