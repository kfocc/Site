ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Беглецы"
ENT.Instructions = "Base entity"
ENT.Spawnable = true
ENT.Category = "JobNPC"
ENT.npcJobType = "Sector6"
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

ENT.AvailableArmors = {
	{
		name = "легкую бронепластину",
		amount = 25,
		price = 350
	},
	{
		name = "усиленную бронепластину",
		amount = 50,
		price = 700
	},
	{
		name = "бронежилет",
		amount = 100,
		price = 1400
	},
}

function ENT.CheckAvailableArmors(ply)
	local job = ply:getJobTable()
	return job.refugee or job.gang or ply:Team() == TEAM_AFERIST
end
