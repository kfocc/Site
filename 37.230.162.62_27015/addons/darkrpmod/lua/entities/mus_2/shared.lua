ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Приём контрабанды"
ENT.Author = "Johnny"
ENT.Category = "Other NPC"
ENT.Spawnable = true
ENT.ContrabandNPC = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
