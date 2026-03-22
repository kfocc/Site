ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Бандиты"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.clientTimeout = 60
ENT.requestTimeoutTime = 60
ENT.npcJobType = "Bandits"
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "SearchCooldown")
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end
