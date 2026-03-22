include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/user_female.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "TRANSHUMAN-ARM", 256, col.w, "Делает из вас солдата ОТА", self.Icon)
end

local function has()
	if string.sub(RPExtraTeams[TEAM_MPF1].name, 1, 3) != "C17" then
		return true
	end

	local lp = LocalPlayer()
	for _, v in ipairs(ents.FindByClass("*door*")) do
		if not v:isDoor() then continue end
		if v:isKeysOwnedBy(lp) then return true end
	end
end

local buttons = {
	{
		text = "Я бы хотел отдать свое тело в СЧОПА",
		func = function(npc, menu)
			if LocalPlayer():isWanted() then
				menu.SetText("Какая-то проблема при получении информации из базы жителей. Вы точно не преступник?")
				return
			elseif not has() and not LocalPlayer():isCP() then
				menu.SetText("Бездомные не могут вступать в структуры Альянса")
				return
			elseif not LocalPlayer():CanGetCP() then
				menu.SetText("Сейчас отсутствует активный набор в структуры Альянса")
				return
			end

			menu:Remove()
			OpenJob(npc.npcJobType)
		end
	},
	--check = function(ply, npc) return ply:isCP() end
	{
		text = "[Важно] Расскажите о солдатах ОТА",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433/#post-119097") end
	},
	{
		text = "[Важно] Я хочу изучить специальные коды для ГО и ОТА",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-50352") end
	},
	{
		text = "[Важно] Что означают активируемые коды в городе?",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-50353") end
	},
	{
		text = "[Важно] Как мне реагировать на боевые действия в городе?",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-50356") end
	},
	{
		text = "Расскажите о званиях в Альянсе",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-349152") end
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Хочешь сдать свое тело? Оно послужит на благо всего Альянса!"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
