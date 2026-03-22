SWEP.PrintName = "Снежок"
SWEP.Slot = 1
SWEP.SlotPos = 100
SWEP.Author = "UnionRP"

SWEP.Instructions = "ЛКМ - бросить снежок.\nПКМ - слепить снежок."

SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.AdminSpawnable = false
SWEP.Spawnable = true
SWEP.ViewModelFOV = 45
SWEP.ViewModel = "models/zerochain/props_christmas/snowballswep/zck_c_snowballswep.mdl"
SWEP.WorldModel = "models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true

SWEP.HoldType = "grenade"
SWEP.FiresUnderwater = false

SWEP.Weight = 5

SWEP.DrawCrosshair = true
SWEP.DrawAmmo = false
SWEP.base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Delay = 0.6

SWEP.UseHands = true
SWEP.DisableDuplicator = true

SWEP.MaxSnowballs = 3

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "SnowballCount")
	if SERVER then
		self:SetSnowballCount(1)
	end
end

if SERVER then
	function SWEP:EmitEffect(pos)
		local owner = self:GetOwner()
		timer.Simple(0, function()
			owner:EmitSound("zck_snowball_pickup")
			ParticleEffect("zck_snowball_pickup", pos, angle_zero, NULL)
		end)
	end

	function SWEP:AddSnowballs(num)
		local snowballCount = self:GetSnowballCount()
		local resultCount = math.min(snowballCount + num, self.MaxSnowballs)
		if resultCount <= 0 then
			local owner = self:GetOwner()
			owner:StripWeapon("zck_snowballswep")
			return
		end
		self:SetSnowballCount(resultCount)
	end
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local snowballCount = self:GetSnowballCount()
	local owner = self:GetOwner()
	if snowballCount <= 0 then
		if SERVER then
			owner:StripWeapon("zck_snowballswep")
		end
		return
	end

	if SERVER then
		local ent = ents.Create("zck_snowball")
		ent:SetPos(owner:EyePos() + (owner:GetAimVector() * 25))
		ent:SetAngles(owner:EyeAngles())
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		local velocity = owner:GetAimVector()
		velocity = velocity * phys:GetMass() * 2000
		velocity = velocity + (VectorRand() * 10) -- a random element
		phys:ApplyForceCenter(velocity)

		self:AddSnowballs(-1)
	end

	self:SendWeaponAnim(ACT_VM_THROW)
	owner:SetAnimation(PLAYER_ATTACK1)

	timer.Simple(0.5, function()
		if IsValid(self) and owner:GetActiveWeapon() == self then
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	end)
end

local distToPickup = 80 * 80
function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	local snowballCount = self:GetSnowballCount()
	local owner = self:GetOwner()
	if snowballCount >= self.MaxSnowballs then return end

	local tr = owner:GetEyeTrace()
	if not tr.Hit then return end

	local distance = owner:GetShootPos():DistToSqr(tr.HitPos)
	if distance >= distToPickup then return end

	local trEnt = tr.Entity
	if (IsValid(trEnt) and trEnt:GetClass() == "zck_snowballcrate") or (tr.HitWorld and tr.MatType == 74 and owner:KeyDown(IN_DUCK)) then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		owner:SetAnimation(PLAYER_ATTACK1)

		if not SERVER then return end
		self:AddSnowballs(1)
		self:EmitEffect(tr.HitPos)
	end
end

if CLIENT then
	local wMod = ScrW() / 1920
	local hMod = ScrH() / 1080
	local snowball_icon = Material("materials/zerochain/zck/ui/zck_snowball.png", "smooth")

	local color_white = COLOR_WHITE
	local color_semidark = Color(0, 0, 0, 125)
	function SWEP:DrawHUD()
		surface.SetDrawColor(color_white)
		surface.SetMaterial(snowball_icon)
		surface.DrawTexturedRect(850 * wMod, 880 * hMod, 200 * wMod, 200 * hMod)
		draw.DrawText(self:GetSnowballCount(), "zck_font01", 950 * wMod, 910 * hMod, color_semidark, TEXT_ALIGN_CENTER)
	end
end