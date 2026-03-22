include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/status_offline.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Беглец", 256, col.w, "Что тебе тут надо?", self.Icon)
end

local buttons = {
	{
		text = "Хочу податься в беглецы",
		func = function(npc, menu)
			menu:Remove()
			OpenJob(npc.npcJobType)
		end
	},
	{
		text = "[Важно] Расскажите о беглецах",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433/#post-152463") end
	},
	{
		text = "Хочу приобрести защиту для тела",
		func = function(npc, menu)
			if LocalPlayer():Armor() >= LocalPlayer():GetMaxArmor() then
				menu.SetText("Ты уже имеешь максимальную защиту")
				menu.SetButtons()
				return
			end

			menu.SetText("Вот несколько вариантов, выбирай")
			local buttonsArmor = {}
			for i, v in ipairs(npc.AvailableArmors) do
				buttonsArmor[i] = {
					text = string.format("Хочу приобрести %s [%d брони]", v.name, v.amount),
					func = function(npc, menu)
						menu.SetText(string.format("Цена вопроса %d токенов", v.price))
						menu.SetButtons({
							{
								text = "Держи",
								func = function(npc, menu)
									netstream.Start("ArmorBuy.JobNPC8", npc, i)
									menu.SetText("Отличное вложение средств! Если, что ты знаешь где меня найти")
									menu.SetButtons()
								end,
								check = function(ply, npc) return ply:canAfford(v.price) end
							}
						})
					end
				}
			end

			menu.SetButtons(buttonsArmor)
		end,
		check = ENT.CheckAvailableArmors
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Что тебе тут надо? Не вздумай шутить, у меня пушка есть!"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
