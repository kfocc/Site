include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/user_red.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "C17.MPF.ASSISTANT", 256, col.w, "Выдает форму высшего состава", self.Icon)
end

local buttons = {
	{
		text = "Служить! Разрешите взять форму командного состава?",
		func = function(npc, menu)
			menu:Remove()
			OpenJob(npc.npcJobType)
		end,
		check = function(ply, npc) return ply:isCP() end
	},
	{
		text = "[Важно] Расскажите о командующем составе гражданской обороны",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433/#post-119096") end
	},
	{
		text = "[Важно] Я хочу изучить устав Гражданской обороны",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/18020/") end
	},
	{
		text = "[Важно] За что я могу наказать гражданина?",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-50351") end
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

local nice_text = "За повышением? Надеюсь вы проявите себя с лучшей стороны, как командующий юнит"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
