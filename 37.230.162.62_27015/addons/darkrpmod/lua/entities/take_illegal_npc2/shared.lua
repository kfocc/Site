ENT.Base = "take_illegal_npc"

ENT.PrintName = "Скупка нелегала2"
ENT.Author = ""
ENT.Category = "Other NPC"
ENT.Spawnable = true

ENT.NPCName = "C17.MPF.UTILIZER"
ENT.NPCDesc = "Прием изъятой контрабанды"
ENT.NPCModel = "models/ggl/cp/cp_male_9.mdl"

ENT.NPCSequenceAnim = "sit"
ENT.ContrabandNPC = true
function ENT:CanSell(ply)
	return ply:isCP()
end
