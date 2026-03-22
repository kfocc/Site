ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Зомби"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Zombienpc"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
