ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Слухи Франц"
ENT.Author = "Johnny"
ENT.Spawnable = true
ENT.Category = "Other NPC"

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
