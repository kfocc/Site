include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/shield.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Отряд HYDRA", 256, col.w, "Выдает форму отряда HYDRA", self.Icon)
end

local buttons = {
	{
		text = "Привет, я хочу взять форму",
		func = function(npc, menu)
			menu:Remove()
			OpenJob(npc.npcJobType)
		end
	},
	{
		text = "[Важно] Расскажите о элитном сопротивлении",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433/#post-53372") end
	},
	{
		text = "[Важно] Я хочу ознакомиться с золотыми правилами сопротивления",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-250611") end
	},
	{
		text = "[Важно] Каких правил придерживаться на боевых операциях?",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-50356") end
	},
	{
		text = "Расскажите о званиях в сопротивлении",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5430/#post-349152") end
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Решил вступить в HYDRA? Сейчас узнаем готов ли ты..."
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
