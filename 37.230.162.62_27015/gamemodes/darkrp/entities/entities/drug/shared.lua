ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Drugs"
ENT.Author = "Rickster"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 1, "owning_ent")
end

