ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Category = "Other NPC"

ENT.Spawnable = true
ENT.PrintName = "Тюряжник"
ENT.Author = "Union"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
