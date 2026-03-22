ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Приём посылок"
ENT.Instructions = "Base entity"
ENT.Author = "UnionRP"
ENT.Spawnable = true
ENT.Category = "ГСР"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "UName")
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
