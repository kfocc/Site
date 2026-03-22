ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Выдача посылок"
ENT.Instructions = "Base entity"
ENT.Author = "UnionRP"
ENT.Spawnable = true
ENT.Category = "ГСР"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
