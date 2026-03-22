include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)

	local origin = self:WorldSpaceCenter()
	local _, max = self:WorldSpaceAABB()
	origin.z = max.z
	if (LocalPlayer():GetPos():Distance(origin) >= 768) then
		return end
	if not nameplates then return end
	nameplates.DrawEnt(self, origin)
end
