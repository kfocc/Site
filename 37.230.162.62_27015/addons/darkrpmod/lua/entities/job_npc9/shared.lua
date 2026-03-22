ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Элитное сопротивление"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Crime3"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
