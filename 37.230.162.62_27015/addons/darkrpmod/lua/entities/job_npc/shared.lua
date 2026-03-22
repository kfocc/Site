ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Гражданские"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Commerce"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
