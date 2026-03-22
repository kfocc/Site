ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Spawned Food"
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.IsSpawnedFood = true
ENT.pickup = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end
