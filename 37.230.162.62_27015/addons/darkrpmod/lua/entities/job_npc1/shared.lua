ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Сотрудники ГСР"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Commerce2"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
