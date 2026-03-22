include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/ipod_cast.png", "noclamp smooth")

local function Request(title, text, func)
	local painter = Derma_StringRequest(title, text, '', function(s) func(s) end)
	painter.Paint = function(s, w, h)
		Derma_DrawBackgroundBlur(s, s.start)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(0, 0, w, h)
	end
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(4)

	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Франц", 256, col.w, "Творит информационную магию", self.Icon)
end

local buttons = {
	{
		text = "Хочу пустить слух",
		func = function(npc, menu)
			if LocalPlayer():getJobTable().cantAdvert then
				local tbl = {
					{
						text = "Пока",
						func = function(n, m) m:Remove() end
					}
				}

				menu.SetButtons(tbl)
				menu.SetText("Неее, с тобой я сотрудничать не хочу, извиняй.")
				return
			end

			local tbl = {
				{
					text = "Хочу чтобы все узнали",
					func = function(n, m)
						m:Remove()
						Request("Подача слухов ( 1.500Т )", "Введите текст для подачи слуха", function(a) netstream.Start("Advert", a) end)
					end
				},
				{
					text = "Альянс не должен узнать об этом",
					func = function(n, m)
						m:Remove()
						Request("Подача слухов ( 2.000Т )", "Введите текст для подачи слуха", function(a) netstream.Start("Advert", a, true) end)
					end
				}
			}

			menu.SetButtons(tbl)
			menu.SetText("Что на счёт получателей? Сколько людей должно узнать?")
		end,
		check = function(ply) return not ply:isCP() end
	},
	{
		text = "Хочу найти человека",
		func = function(npc, menu)
			Request("Поиск человека ( 1.500Т )", "Введите имя для поиска", function(a)
				local ply = DarkRP.findPlayer(a)
				if not IsValid(ply) then
					DialogSys.BeginDialogue(npc, "Мне передали, что такого не видели")
					return
				end

				netstream.Start("FindPlayer", ply)
			end)
		end,
		check = function(ply) return not ply:isCP() end
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Что же привело вас ко мне в этот чудный день?"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
