ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Spawned Money"
ENT.Author = "FPtje"
ENT.Spawnable = false
ENT.IsSpawnedMoney = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "amount")
	self:NetworkVar("Entity", 0, "owning_ent")
end