ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Spawned Weapon"
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.IsSpawnedWeapon = true
ENT.pickup = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "WeaponClass")
	self:NetworkVar("Entity", 0, "owning_ent")
end
