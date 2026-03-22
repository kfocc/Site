ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Коробка"
ENT.Category = "UnionRP"
ENT.Author = "Ferzux, переписал Johnny"
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.nonfreeze = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ReadyToSell")
end
