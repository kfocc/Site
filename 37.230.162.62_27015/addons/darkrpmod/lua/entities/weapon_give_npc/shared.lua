AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Продавец оружия"
ENT.Author = ""
ENT.Category = "Other NPC"
ENT.Spawnable = true
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

weapons_give_npc = weapons_give_npc or {}
weapons_give_npc.weps = weapons_give_npc.weps or {}
weapons_give_npc.jobs = weapons_give_npc.jobs or {}

include("cfg.lua")