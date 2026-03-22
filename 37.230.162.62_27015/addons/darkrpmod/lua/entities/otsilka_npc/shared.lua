ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Гражданин на вокзале"
ENT.Instructions = "Base entity"
ENT.Author = "Johnny"
ENT.Category = "Other NPC"
ENT.Spawnable = true
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
