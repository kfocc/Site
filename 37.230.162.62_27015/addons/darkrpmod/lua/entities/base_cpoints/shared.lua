ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Base Capture Point"
ENT.Author = "Someone"
ENT.Spawnable = false
ENT.PhysgunDisabled = true
function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PointID")
end
