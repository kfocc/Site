ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Выдача лекарств"
ENT.Author = ""
ENT.Category = "ГСР"
ENT.Spawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

heals_give_npc = heals_give_npc or {}
heals_give_npc.heals = heals_give_npc.heals or {}

local function init_give_npc()

	heals_give_npc.heals = {}
	local heals = heals_give_npc.heals
	table.insert(heals, {
		name = "Фурацилин",
		points = 10,
		price = 250,
		model = "models/props_junk/glassjug01.mdl",
		desc = "Слабое, противомикробное средство."
	})
	table.insert(heals, {
		name = "Сильный антибиотик",
		points = 15,
		price = 375,
		model = "models/props_junk/GlassBottle01a.mdl",
		desc = "Сильный антибиотик, способный\nвылечить большое количество болезней."
	})
	table.insert(heals, {
		name = "Анестетик",
		points = 20,
		price = 500,
		model = "models/props_lab/jar01b.mdl",
		desc = "Анестетик обеспечивает безболезненное\nи длительное лечение."
	})
	table.insert(heals, {
		name = "Маленький биогель",
		points = 30,
		price = 750,
		model = "models/healthvial.mdl",
		desc = "Произведенный альянсом маленький биогель, является\nуниверсальным средством для лечения."
	})
	table.insert(heals, {
		name = "Биогель",
		points = 50,
		price = 1250,
		model = "models/Items/HealthKit.mdl",
		desc = "Произведенный альянсом биогель, является\nуниверсальным средством для лечения."
	})
end

-- При обновлении нужно убрать -- перед init_give_npc(), сохранить файл и вернуть -- обратно.
-- init_give_npc()
hook.Add("PostGamemodeLoaded", "Initialize_Config_Heals_Give_NPC", init_give_npc)