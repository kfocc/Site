SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Достать CID-карту"
SWEP.PrintName = "Багаж"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawWeaponInfoBox = true

SWEP.AnimPrefix = "rpg"
SWEP.HoldType = "none"

SWEP.ViewModel = "models/weapons/c_nsuitcase.mdl"
SWEP.WorldModel = "models/weapons/w_nsuitcase.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.SlotPos = 4
SWEP.Slot = 1
SWEP.nowarn = true
SWEP.Category = "UnionRP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("normal")
	self:DrawShadow(false)
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	if not SERVER then return end
	if self.using then return end

	self:SetNextPrimaryFire(CurTime() + 30)

	local owner = self:GetOwner()
	if owner:HasWeapon("cid_new") then
		DarkRP.talkToRange(owner, "[CID] " .. owner:GetName(), "Пытается найти CID карту в сумке, но попытки неудачные", 90)
		return
	end

	self.using = true
	self:EmitSound("items/ammocrate_open.wav")

	timer.Simple(1, function()
		if not IsValid(self) then return end
		self:SetHoldType("slam")
		self:EmitSound("physics/wood/wood_crate_impact_soft3.wav")

		timer.Simple(1, function()
			if not IsValid(self) then return end
			self:SetHoldType("normal")

			DarkRP.talkToRange(owner, "[CID] " .. owner:GetName(), "Достает CID карту из сумки.", 90)
			owner:Give("cid_new").given = true

			self.using = false
		end)
	end)
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end

function SWEP:TranslateActivity(act)
	return -1
end

if CLIENT then
	function SWEP:DrawHUD()
		local w = ScrW()
		local h = ScrH()
		local y, height = h * 0.5, h / 3
		draw.SimpleText("Нажмите ЛКМ чтобы достать CID-карту", "Trebuchet24", w * 0.5, y + height / 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
