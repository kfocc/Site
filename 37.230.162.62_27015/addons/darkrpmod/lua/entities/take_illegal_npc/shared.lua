ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Скупка нелегала1"
ENT.Author = ""
ENT.Category = "Other NPC"
ENT.Spawnable = true

ENT.NPCName = "Скупщик"
ENT.NPCDesc = "Скупает сомнительные предметы"
ENT.NPCModel = "models/player/tnb/citizens/male_citizen_08.mdl"

ENT.NPCSequenceAnim = "sit"
ENT.ContrabandNPC = true
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:CanSell(ply)
	if not ply:isCt() and not ply:isLoyal() and not ply:isGSR() then return false end
	return true
end
