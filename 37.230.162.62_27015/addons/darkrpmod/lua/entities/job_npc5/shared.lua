ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Боевые единицы"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Police3"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
