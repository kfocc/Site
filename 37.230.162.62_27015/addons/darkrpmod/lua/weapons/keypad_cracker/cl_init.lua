include("shared.lua")

SWEP.DownAngle = Angle(-10, 0, 0)

SWEP.LowerPercent = 1
-- SWEP.SwayScale = 0

function SWEP:GetViewModelPosition(pos, ang)
	if self:GetCracking() then
		local delta = FrameTime() * 3.5
		self.LowerPercent = math.Clamp(self.LowerPercent - delta, 0, 1)
	else
		local delta = FrameTime() * 5
		self.LowerPercent = math.Clamp(self.LowerPercent + delta, 0, 1)
	end

	ang:RotateAroundAxis(ang:Forward(), self.DownAngle.p * self.LowerPercent)
	ang:RotateAroundAxis(ang:Right(), self.DownAngle.p * self.LowerPercent)
	return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end
