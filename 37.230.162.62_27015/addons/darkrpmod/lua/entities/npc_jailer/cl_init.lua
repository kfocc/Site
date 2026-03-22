include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/wand.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "C17.MPF.PSNR", 256, col.w, "Тюремный надзиратель", self.Icon)
end

netstream.Hook("RHC_Jailer_Menu", function(ply, npc)
	if JailerMenu and IsValid(JailerMenu) then JailerMenu:Remove() end
	JailerMenu = vgui.Create("rhc_jailernpc_menu")
	JailerMenu:SetAPlayer(ply)
	JailerMenu.npc = npc
end)

surface.CreateFont("rhc_bailer_pheader", {
	font = "Arial Black",
	extended = true,
	weight = 300,
	size = 20,
})

surface.CreateFont("rhc_bailer_sit", {
	font = "Arial Black",
	extended = true,
	weight = 300,
	size = 14,
})

surface.CreateFont("rhc_bailer_title", {
	font = "Arial Black",
	extended = true,
	weight = 300,
	size = 28,
})

local MainPanelColor = col.ba
local MainPanelOutline = col.oa
local HeaderH = 30
local HeaderColor = col.o
local HeaderOutline = col.r
local ButtonColor = Color(50, 50, 50, 200)
local ButtonColorHovering = Color(75, 75, 75, 200)
local ButtonColorPressed = Color(150, 150, 150, 200)
local ButtonOutline = col.r
local COLOR_WHITE = col.w
local PANEL = {}
function PANEL:Init()
	self.ButtonText = ""
	self.BColor = ButtonColor
	self:SetText("")
	self:SetFont("rhc_bailer_sit")
	self:SetTextColor(color_white)
end

function PANEL:UpdateColours()
	if self:IsDown() or self.m_bSelected then
		self.BColor = ButtonColorPressed
		return
	end

	if self.Hovered then
		self.BColor = ButtonColorHovering
		return
	end

	self.BColor = ButtonColor
	return
end

function PANEL:Paint(W, H)
	surface.SetDrawColor(self.BColor)
	surface.DrawRect(0, 0, W, H)
	surface.SetDrawColor(ButtonOutline)
	surface.DrawOutlinedRect(0, 0, W, H)
end

vgui.Register("rhc_button", PANEL, "DButton")
local PANEL = {}
function PANEL:Init()
	self:ShowCloseButton(false)
	self:SetTitle("")
	self:MakePopup()

	self.JailNick = "Подведите человека"
	self.TopDPanel = vgui.Create("DPanel", self)

	self.TopDPanel.Paint = function(selfp, W, H)
		surface.SetDrawColor(HeaderColor)
		surface.DrawRect(0, 0, W, H)
		surface.SetDrawColor(HeaderOutline)
		surface.DrawOutlinedRect(0, 0, W, H)
		draw.SimpleText("C17.MPF.PSNR", "rhc_bailer_title", W / 2, H / 2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local jailSlider = vgui.Create("DNumSlider", self)
	jailSlider:SetText("Срок")
	jailSlider:SetMinMax(1, 15)
	jailSlider:SetDark(false)
	jailSlider:SetDecimals(0)
	jailSlider:SetDefaultValue(1)
	jailSlider:ResetToDefaultValue()

	jailSlider.Scratch:SetCursor("none")
	jailSlider.Scratch:SetMouseInputEnabled(false)
	jailSlider.TextArea:SetTextColor(HeaderOutline)
	jailSlider.TextArea:SetFont("rhc_bailer_pheader")
	jailSlider.Label:SetFont("rhc_bailer_pheader")
	jailSlider.Label:SetTextColor(col.w)
	jailSlider.OnValueChanged = function(_self, value) _self:SetValue(math.Round(value, 0)) end

	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua#L15
	jailSlider.TextArea.OnEnter = function(_self, value) _self:SetText(slider.Scratch:GetTextValue()) end
	self.JailSlider = jailSlider

	self.JailButton = vgui.Create("rhc_button", self)
	self.JailButton:SetText("Посадить")
	self.JailButton.DoClick = function()
		if not IsValid(self.APlayer) then
			self:Remove()
			return
		end

		netstream.Start("RHC_Jailer_Menu", self.APlayer, jailSlider:GetValue(), self.JailReason:GetValue(), self.npc)
		self:Remove()
	end

	self.JailReason = vgui.Create("DTextEntry", self)
	self.CloseButton = vgui.Create("rhc_button", self)
	self.CloseButton:SetText("X")
	self.CloseButton.DoClick = function() self:Remove() end
end

function PANEL:SetAPlayer(Player)
	if not IsValid(Player) or not Player:IsPlayer() then return end
	self.JailNick = "Цель: " .. Player:Name()
	self.APlayer = Player
end

function PANEL:Paint(W, H)
	surface.SetDrawColor(MainPanelColor)
	surface.DrawRect(0, 0, W, H)
	surface.SetDrawColor(MainPanelOutline)
	surface.DrawOutlinedRect(0, 0, W, H)
	draw.SimpleText(self.JailNick, "rhc_bailer_pheader", W / 2, HeaderH + 5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("Причина:", "rhc_bailer_pheader", 5, HeaderH + 55, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

local Width, Height = 600, 180
function PANEL:PerformLayout()
	self:SetPos(ScrW() / 2 - Width / 2, ScrH() / 2 - Height / 2)
	self:SetSize(Width, Height)
	self.TopDPanel:SetPos(0, 0)
	self.TopDPanel:SetSize(Width, HeaderH + 2)
	self.JailSlider:SetPos(5, HeaderH + 25)
	self.JailSlider:SetSize(Width - 10, 25)
	self.JailReason:SetPos(140, HeaderH + 55)
	self.JailReason:SetSize(Width - 150, 20)
	self.JailButton:SetPos(Width / 2 - 37.5, Height - 30)
	self.JailButton:SetSize(75, 25)
	self.CloseButton:SetPos(Width - HeaderH / 2 - 7.5, HeaderH / 2 - 7.5)
	self.CloseButton:SetSize(15, 15)
end

vgui.Register("rhc_jailernpc_menu", PANEL, "DFrame")
