ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Местро стрельбы"
ENT.Author = "UnionRP"
ENT.Spawnable = true
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "HP")
	self:NetworkVar("Bool", 0, "Active")
end
