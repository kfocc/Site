AddCSLuaFile()


SWEP.PrintName = "Отмычка"
SWEP.Slot = 5
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true


-- Variables that are used on both client and server
SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Начать взлом"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPLockpick = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "DarkRP (Utility)"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = 0 -- Default number of bullets in a clip
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1 -- Size of a clip
SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

SWEP.hackTime = {
	min = 10,
	max = 30
}

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsLockpicking")
	self:NetworkVar("Float", 0, "LockpickStartTime")
	self:NetworkVar("Float", 1, "LockpickEndTime")
	self:NetworkVar("Float", 2, "NextSoundTime")
	self:NetworkVar("Int", 0, "TotalLockpicks")
	self:NetworkVar("Entity", 0, "LockpickEnt")
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)

	if self:GetIsLockpicking() then return end

	local owner = self:GetOwner()
	owner:LagCompensation(true)
	local trace = owner:GetEyeTrace()
	owner:LagCompensation(false)

	local ent = trace.Entity
	if not IsValid(ent) or ent.DarkRPCanLockpick == false then return end

	local canLockpick = hook.Call("canLockpick", nil, owner, ent, trace)
	if canLockpick == false then return end
	if canLockpick ~= true and not ent.RXPrinter and (trace.HitPos:DistToSqr(owner:GetShootPos()) > 10000 or (not GAMEMODE.Config.canforcedooropen and ent:getKeysNonOwnable()) or (not ent:isDoor() and not ent:IsVehicle() and not string.find(string.lower(ent:GetClass()), "vehicle", nil, true) and (not GAMEMODE.Config.lockpickfading or not ent.isFadingDoor))) then return end

	self:SetHoldType("pistol")
	self:SetIsLockpicking(true)
	self:SetLockpickEnt(ent)
	self:SetLockpickStartTime(CurTime())

	local endDelta = hook.Call("lockpickTime", nil, owner, ent) or util.SharedRandom("DarkRP_Lockpick" .. self:EntIndex() .. "_" .. self:GetTotalLockpicks(), self.hackTime.min, self.hackTime.max)
	self:SetLockpickEndTime(CurTime() + endDelta)
	self:SetTotalLockpicks(self:GetTotalLockpicks() + 1)

	if IsFirstTimePredicted() then
		hook.Call("lockpickStarted", nil, owner, ent, trace)
	end

	if CLIENT then
		self.Dots = ""
		self.NextDotsTime = SysTime() + 0.5
		return
	end

	local onFail = function(ply)
		if ply == owner then
			hook.Call("onLockpickCompleted", nil, ply, false, ent)
		end
	end

	-- Lockpick fails when dying or disconnecting
	hook.Add("PlayerDeath", self, fc{onFail, fn.Flip(fn.Const)})
	hook.Add("PlayerDisconnected", self, fc{onFail, fn.Flip(fn.Const)})

	-- Remove hooks when finished
	hook.Add("onLockpickCompleted", self, fc{fp{hook.Remove, "PlayerDisconnected", self}, fp{hook.Remove, "PlayerDeath", self}})
end

function SWEP:Holster()
	if self:GetIsLockpicking() and self:GetLockpickEndTime() ~= 0 then
		self:Fail()
	end
	return true
end

function SWEP:Succeed()
	self:SetHoldType("normal")

	local ent = self:GetLockpickEnt()
	self:SetIsLockpicking(false)
	self:SetLockpickEnt(nil)
	if not IsValid(ent) then return end

	local owner = self:GetOwner()
	local override = hook.Call("onLockpickCompleted", nil, owner, true, ent)
	if override then return end

	if ent.isFadingDoor and ent.fadeActivate and not ent.fadeActive then
		ent:fadeActivate()
		if IsFirstTimePredicted() then
			timer.Simple(5, function()
				if IsValid(ent) and ent.fadeActive then
					ent:fadeDeactivate()
				end
			end)
		end
	elseif ent.RXPrinter and SERVER then

		ent:Hack(owner)

	elseif ent.Fire then
		ent:keysUnLock()

		ent:Fire("Open", "", .6)
		ent:Fire("SetAnimation", "open", .6)
		if owner:Crouching() and Stealth_IsDoor(ent) then
			ent:StealthOpenDoor()
		end
	end
end

function SWEP:Fail()
	self:SetIsLockpicking(false)
	self:SetHoldType("normal")

	hook.Call("onLockpickCompleted", nil, self:GetOwner(), false, self:GetLockpickEnt())

	self:SetLockpickEnt(nil)
end

local dots = {
	[0] = ".",
	[1] = "..",
	[2] = "...",
	[3] = ""
}

function SWEP:Think()
	if not self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end

	if CurTime() >= self:GetNextSoundTime() then
		self:SetNextSoundTime(CurTime() + 1)

		local snd = {1, 3, 4}

		self:EmitSound("weapons/357/357_reload" .. tostring(snd[math.Round(util.SharedRandom("DarkRP_LockpickSnd" .. CurTime(), 1, #snd))]) .. ".wav", 50, 100)
	end

	if CLIENT and (not self.NextDotsTime or SysTime() >= self.NextDotsTime) then
		self.NextDotsTime = SysTime() + 0.5
		self.Dots = self.Dots or ""

		local len = string.len(self.Dots)
		self.Dots = dots[len]
	end

	local trace = self:GetOwner():GetEyeTrace()
	local trEnt = trace.Entity
	if not IsValid(trEnt) or trEnt ~= self:GetLockpickEnt() or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
		self:Fail()
	elseif self:GetLockpickEndTime() <= CurTime() then
		self:Succeed()
	end
end

function SWEP:DrawHUD()
	if not self:GetIsLockpicking() or self:GetLockpickEndTime() == 0 then return end

	self.Dots = self.Dots or ""

	local w = ScrW()
	local h = ScrH()

	local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
	draw.RoundedBox(8, x, y, width, height, Color(10, 10, 10, 120))

	local time = self:GetLockpickEndTime() - self:GetLockpickStartTime()
	local curtime = CurTime() - self:GetLockpickStartTime()
	local status = math.Clamp(curtime / time, 0, 1)
	local BarWidth = status * (width - 16)
	local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)
	draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(255 - (status * 255), 0 + (status * 255), 0, 255))
	draw.DrawNonParsedSimpleText((string.find(self:GetLockpickEnt():GetClass(), "rx_*") and "Взлом принтера" or DarkRP.getPhrase("picking_lock")) .. self.Dots, "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

DarkRP.hookStub{
	name = "canLockpick",
	description = "Whether an entity can be lockpicked.",
	parameters = {
		{
			name = "ply",
			description = "The player attempting to lockpick an entity.",
			type = "Player"
		},
		{
			name = "ent",
			description = "The entity being lockpicked.",
			type = "Entity"
		},
		{
			name = "trace",
			description = "The trace result.",
			type = "table"
		}
	},
	returns = {
		{
			name = "allowed",
			description = "Whether the entity can be lockpicked",
			type = "boolean"
		}
	},
	realm = "Shared"
}

DarkRP.hookStub{
	name = "lockpickStarted",
	description = "Called when a player is about to pick a lock.",
	parameters = {
		{
			name = "ply",
			description = "The player that is about to pick a lock.",
			type = "Player"
		},
		{
			name = "ent",
			description = "The entity being lockpicked.",
			type = "Entity"
		},
		{
			name = "trace",
			description = "The trace result.",
			type = "table"
		}
	},
	returns = {},
	realm = "Shared"
}

DarkRP.hookStub{
	name = "onLockpickCompleted",
	description = "Result of a player attempting to lockpick an entity.",
	parameters = {
		{
			name = "ply",
			description = "The player attempting to lockpick the entity.",
			type = "Player"
		},
		{
			name = "success",
			description = "Whether the player succeeded in lockpicking the entity.",
			type = "boolean"
		},
		{
			name = "ent",
			description = "The entity that was lockpicked.",
			type = "Entity"
		},
	},
	returns = {
		{
			name = "override",
			description = "Return true to override default behaviour, which is opening the (fading) door.",
			type = "boolean"
		}
	},
	realm = "Shared"
}

DarkRP.hookStub{
	name = "lockpickTime",
	description = "The length of time, in seconds, it takes to lockpick an entity.",
	parameters = {
		{
			name = "ply",
			description = "The player attempting to lockpick an entity.",
			type = "Player"
		},
		{
			name = "ent",
			description = "The entity being lockpicked.",
			type = "Entity"
		},
	},
	returns = {
		{
			name = "time",
			description = "Seconds in which it takes a player to lockpick an entity",
			type = "number"
		}
	},
	realm = "Shared"
}