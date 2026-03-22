if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName = "Медкит"
SWEP.Author = "UnionRP"
SWEP.Slot = 5
SWEP.SlotPos = 7
SWEP.Description = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "ЛКМ: Лечить игрока напротив\nПКМ: Лечить себя"
SWEP.IsDarkRPMedKit = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "Лечение/Броня"

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 0.1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType( "slam" )
	self.Restored = 0
end

function SWEP:Deploy()
	self.Restored = 0
	return true
end

function SWEP:Holster()
	self:GiveReward()
	return true
end

function SWEP:GiveReward()
	if self.Restored == 0 then return end
	local ply = self:GetOwner()
	if ply:Team() != TEAM_GMED then return end
	local reward = math.floor(self.Restored / 2)
	ply:addMoney(reward, "Лечение")
	DarkRP.notify(ply, 0, 4, "Вы получили " .. DarkRP.formatMoney(reward) .. " за лечение.")
	self.Restored = 0
end

function SWEP:PrimaryAttack()

	if not IsValid(self:GetOwner()) then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if CLIENT then return end

	local ply = self:GetOwner()

	ply:LagCompensation(true)
	local found = ply:GetEyeTrace().Entity
	ply:LagCompensation(false)

	if not found or not IsValid(found) or not found:IsPlayer() or not found:Alive() or not ply:Alive() or ply:GetPos():Distance(found:GetPos()) > 85 or found:Team() == TEAM_ADMIN or found:Team() == TEAM_GMAN then
		self:GiveReward()
		return
	end

	local health = found:Health() or 100
	local armor = found:Armor() or 100
	local maxhealth = found:GetMaxHealth() or 100
	local maxarmor = found:GetMaxArmor() or 100
	if health < maxhealth then
		self.Restored = self.Restored + 1
		found:SetHealth(health + 1)
		ply:EmitSound("hl1/fvox/boop.wav", 50, health / maxhealth * 100, 1, CHAN_AUTO)
	elseif armor < maxarmor and --[[not--]] found:Team() != TEAM_GORDON --[[and not found:isOTA()--]] then
	self.Restored = self.Restored + 1
		found:SetArmor(armor + 1)
		ply:EmitSound("HL1/fvox/buzz.wav", 50, armor / maxarmor * 100, 1, CHAN_AUTO)
	elseif self.Restored > 0 then
		self:GiveReward()
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	if CLIENT then return end
	local ply = self:GetOwner()
	if ply:Alive() then
		local maxhealth = ply:GetMaxHealth() or 100
		local maxarmor = ply:GetMaxArmor() or 100
		local health = ply:Health() or 100
		local armor = ply:Armor() or 100
		if health < maxhealth then
			ply:SetHealth(health + 1)
			ply:EmitSound("hl1/fvox/boop.wav", 50, health / maxhealth * 100, 1, CHAN_AUTO)
		elseif armor < maxarmor then
			ply:SetArmor(armor + 1)
			ply:EmitSound("HL1/fvox/buzz.wav", 50, armor / maxarmor * 100, 1, CHAN_AUTO)
		end
	end
end
