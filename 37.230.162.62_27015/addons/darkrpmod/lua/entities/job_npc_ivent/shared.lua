ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Ивент бой"
ENT.Instructions = "Base entity"
ENT.Author = "Union"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Iventboy"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
