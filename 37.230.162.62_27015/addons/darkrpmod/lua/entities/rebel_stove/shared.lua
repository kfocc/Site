ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Плита для готовки"
ENT.Category = "Еда"
ENT.Author = "Someone"
ENT.Spawnable = true
ENT.bNoPersist = true
ENT.maxStolenFood = 50
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StolenFood")
	self:NetworkVar("Int", 1, "ReadyFood")
end
