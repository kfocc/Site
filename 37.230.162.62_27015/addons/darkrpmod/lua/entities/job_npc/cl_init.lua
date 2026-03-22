include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/user_add.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Гражданские", 256, col.w, "Выдает гражданскую форму", self.Icon)
end

local buttons = {
	{
		text = "Хочу получить новую форму",
		func = function(npc, menu)
			menu:Remove()
			OpenJob(npc.npcJobType)
		end
	},
	{
		text = "[Важно] Расскажите о гражданских",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433") end
	},
	{
		text = "Моя CID карта была утеряна",
		func = function(npc, menu)
			if LocalPlayer():HasWeapon("cid_new") then
				menu.SetText("Кажется она у вас уже есть.")
			else
				menu.SetText("Вот ваша новая CID карта, постарайтесь больше не терять.")
				netstream.Start("job_npc.recoverycard", npc)
			end
		end,
		check = function(ply, npc)
			local tbl = ply:getJobTable()
			return (tbl.citizen or tbl.loyal or tbl.gsr) and not (tbl.gang or tbl.refugee or tbl.rebel or tbl.vort) and table.HasValue(tbl.weapons, "cid_new")
		end
	},
	{
		text = "Что мне делать дальше?",
		func = function(npc, menu) menu.SetText("Рекомендуется начать с получения рациона, а затем арендовать квартиру в городе. После этого, вы можете рассмотреть возможность устройства на работу в ГСР или Гражданскую оборону, чтобы начать зарабатывать свои первые деньги.") end
	},
	{
		text = "Как мне получить рацион?",
		func = function(npc, menu) menu.SetText("За моей спиной расположен большой зал с аппаратом для выдачи рационов. Вставьте карту CID и возьмите рацион, используя клавишу (E).") end
	},
	{
		text = "Как арендовать квартиру?",
		func = function(npc, menu) menu.SetText("Исследуйте город и найдите подходящее жилье для себя, просто нажмите F2, глядя на свободную дверь.") end
	},
	{
		text = "Где найти Офис ГСР?",
		func = function(npc, menu) menu.SetText("Воспользуйтесь системой GPS. Нажмите (C) - GPS - Важные места - Офис ГСР.") end
	},
	{
		text = "Как вступить в Гражданскую оборону?",
		func = function(npc, menu) menu.SetText("Вам необходимо дождаться набора. Обратите внимание на короткое появление объявления о наборе в правом нижнем углу. Для узнавания текущего статуса набора вы можете воспользоваться следующими шагами: нажмите (C), затем выберите Информация, и затем Набор в Альянс.") end
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Здравствуй, чем могу помочь?"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
