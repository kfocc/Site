--[[
	Do not edit the code below unless you know what you are doing
]]
if SERVER then
	AddCSLuaFile("shared.lua")
	util.AddNetworkString("RemovePropgressBar")
	util.AddNetworkString("DrawProgressBar")
end

if CLIENT then
	SWEP.PrintName = "BaseWeapon"
	SWEP.Slot = 1
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "UnionRP"
SWEP.Instructions = ""
SWEP.Category = "DarkRP (Utility)"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.HoldType = "normal"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.CheckTime = 10
SWEP.AllowedClass = "player"
SWEP.SoundDelay = 0.5
SWEP.ModelDraw = false

function net.SendSingleMessage(name, ply)
	if CLIENT then
		net.Start(name)
		net.SendToServer()
	else
		if ply then
			net.Start(name)
			net.Send(ply)
		else
			net.Start(name)
			net.Broadcast()
		end
	end
end

if CLIENT then
	local ProgressBar
	net.Receive("DrawProgressBar", function()
		if ProgressBar and ProgressBar:IsValid() then ProgressBar:Remove() end
		local kc = 0
		local maxTime = net.ReadFloat()
		local wep = net.ReadString()
		local lp = LocalPlayer()
		ProgressBar = vgui.Create("MProgressBar")
		ProgressBar:SetMin(0)
		ProgressBar:SetMax(maxTime)
		ProgressBar:Center()
		ProgressBar.lastTime = CurTime()
		ProgressBar.Think = function(self)
			self:SetValue(self:GetValue() + CurTime() - self.lastTime)
			self.lastTime = CurTime()
			if kc <= CurTime() then
				kc = CurTime() + 1
				if not lp:HasWeapon(wep) then
					ProgressBar.Think = function() end
					ProgressBar:FadeOut(FADE_DELAY, true)
				end
			end
		end

		ProgressBar:FadeIn(FADE_DELAY)
	end)

	net.Receive("RemovePropgressBar", function()
		if ProgressBar and ProgressBar:IsValid() then
			ProgressBar.Think = function() end
			ProgressBar:FadeOut(FADE_DELAY, true)
		end
	end)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
	if not self.ModelDraw then
		self:GetOwner():DrawViewModel(false)
		if SERVER then self:GetOwner():DrawWorldModel(false) end
	end
end

function SWEP:EntityCheck(ent)
	if not (IsValid(ent) and ent:GetClass() == self.AllowedClass and ent:GetPos():Distance(self:GetOwner():GetPos()) < 100) then return true end
	return false
end

function SWEP:GetSounds()
	return "npc/combine_soldier/gear" .. math.random(6) .. ".wav"
end

function SWEP:CalculateTime(ent)
	return self.CheckTime
end

function SWEP:PlaySound()
	self:GetOwner():EmitSound(self:GetSounds(), 100, 100)
end

function SWEP:PrimaryAttack()
	if CLIENT or self.InProgress then return end
	self:SetNextPrimaryFire(CurTime() + 0.2)
	local trace = self:GetOwner():GetEyeTrace().Entity
	if self:EntityCheck(trace) then return end
	self.InProgress = true
	if SERVER then
		local time = self:CalculateTime(trace)
		self.EndCheck = CurTime() + time
		net.Start("DrawProgressBar", self:GetOwner())
		net.WriteFloat(time)
		net.WriteString(self:GetClass())
		net.Send(self:GetOwner())
		timer.Create("WeaponCheckSounds", self.SoundDelay, 0, function() self:PlaySound() end)
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Reload()
	self:PrimaryAttack()
end

function SWEP:Holster()
	if SERVER then
		self.InProgress = false
		timer.Remove("WeaponCheckSounds")
		net.SendSingleMessage("RemovePropgressBar", self:GetOwner())
	end
	return true
end

function SWEP:OnRemove()
	if SERVER then timer.Remove("WeaponCheckSounds") end
end

function SWEP:Done(ent)
end

function SWEP:Succeed()
	self.InProgress = false
	local trace = self:GetOwner():GetEyeTrace().Entity
	if self:EntityCheck(trace) then return end
	net.SendSingleMessage("RemovePropgressBar", self:GetOwner())
	timer.Remove("WeaponCheckSounds")
	self:Done(trace)
end

function SWEP:Fail()
	self.InProgress = false
	timer.Remove("WeaponCheckSounds")
	net.SendSingleMessage("RemovePropgressBar", self:GetOwner())
end

function SWEP:Think()
	if self.InProgress and SERVER then
		local trace = self:GetOwner():GetEyeTrace().Entity
		if self:EntityCheck(trace) then
			self:Fail()
		elseif self.EndCheck <= CurTime() then
			self:Succeed()
		end
	end
end

FADE_DELAY = 0.3
if CLIENT then
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

	function DrawOutlinedRoundedRect(width, height, color, x, y)
		x = x or 0
		y = y or 0
		surface.SetDrawColor(color)
		surface.DrawLine(x + 1, y, x + width - 2, y)
		surface.DrawLine(x, y + 1, x, y + height - 2)
		surface.DrawLine(x + width - 1, y + 2, x + width - 1, y + height - 2)
		surface.DrawLine(x + 1, y + height - 1, x + width - 2, y + height - 1)
	end

	function DrawRect(x, y, width, height, color)
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
		surface.DrawRect(x, y, width, height)
	end

	--[[
	MProgressBar
]]
	local PANEL = {}

	AccessorFunc(PANEL, "Min", "Min")
	AccessorFunc(PANEL, "Max", "Max")
	AccessorFunc(PANEL, "Value", "Value")
	AccessorFunc(PANEL, "OldValue", "OldValue")
	AccessorFunc(PANEL, "Color", "Color")

	function PANEL:Init()
		self:SetSize(500, 32)
		self:SetMax(100)
		self:SetMin(0)
		self:SetValue(0)
		self:SetColor(col.oa)
	end

	function PANEL:SetValue(value)
		self:SetOldValue(value)
		self.Value = value
	end

	function PANEL:Paint()
		DrawOutlinedRoundedRect(self:GetWide(), self:GetTall(), col.w)
		DrawRect(1, 1, self:GetWide() - 2, self:GetTall() - 2, self:GetColor())
		local width = math.min(math.Round(self:GetWide() * (self:GetOldValue() - self:GetMin()) / (self:GetMax() - self:GetMin())), self:GetWide())
		local height = self:GetTall()
		DrawOutlinedRoundedRect(width, height, col.o, 0, (self:GetTall() - height) / 2)
		DrawRect(1, (self:GetTall() - height) / 2 + 1, width - 2, height - 2, self:GetColor())
	end

	derma.DefineControl("MProgressBar", "", PANEL)
end
