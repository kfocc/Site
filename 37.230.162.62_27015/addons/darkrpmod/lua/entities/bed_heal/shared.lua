ENT.Type = "anim"
ENT.Base = "bed_base"

ENT.PrintName = "Кровать для лечения"
ENT.Author = ""
ENT.Category = "UnionRP"
ENT.Spawnable = true

ENT.MainBoard = true
ENT.MaxHealPoints = 50
ENT.RewardCoefficient = 50

function ENT:SetupDataTables()
  self:NetworkVar("Int", 0, "HealPoints")
end