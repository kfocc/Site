ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Прототипы"
ENT.Author = "Google / edit by Johnny"
ENT.Category = "Other NPC"
ENT.Spawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
