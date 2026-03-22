ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Campfire"
ENT.Author = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "UnionRP"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Active")
end
