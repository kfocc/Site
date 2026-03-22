ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Радио CSS"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "UnionRP"
ENT.Spawnable = true
ENT.nonfreeze = true
ENT.DoNotDuplicate = true
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 1, "owning_ent")
end
