ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "NPC Декор1(Сидят М)"
ENT.Instructions = "Base entity"
ENT.Author = "Johnny"
ENT.Spawnable = true
ENT.Category = "Decor NPC"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
