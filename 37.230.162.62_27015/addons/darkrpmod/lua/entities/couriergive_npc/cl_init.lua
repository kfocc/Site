include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/clock_add.png", "noclamp smooth")

function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(4)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Агент доставок", 256, col.w, "Посылки для курьеров", self.Icon)
end

local buttons = {
	{
		text = "Кто ты?",
		func = function(npc, menu) menu.SetText("Приветствую. Я ищу курьеров для доставки посылок в разные части города!") end
	},
	{
		text = "Я хочу поработать грузчиком",
		func = function(npc, menu) menu.SetText("Отлично, тогда иди на завод ГСР. Там ты найдешь коробку с упакованными рационами, возьми коробку и тащи сюда. Видишь справа от меня коробку? Складывай рационы сюда. Только пожалуйста ОСТОРОЖНО! Не бегай и не прыгай с коробкой в руках, а то уронишь!") end
	},
	{
		text = "Что делать если на заводе нет рационников?",
		func = function(npc, menu) menu.SetText("Это значит, что фасовщики еще не произвели их. Иди займись пока обычными заказами!") end
	},
	{
		text = "Есть сейчас заказы?",
		func = function(npc, menu)
			if LocalPlayer():GetNetVar("IsCourier", false) then
				menu.SetText("Отнеси предыдущую посылку, а потом приходи")
				return
			end

			if LocalPlayer():GetNetVar("GSR.CourierCD", 0) > CurTime() then
				menu.SetText("Увы, сейчас ничего нету. Приходи позже")
				return
			end

			npc:aUse()
		end,
		check = function(ply, npc) return ply:Team() == TEAM_GSR2 end
	},
	{
		text = "Давай сюда свои токены!",
		func = function(npc, menu)
			if npc:GetNW2Bool("Robbery") then
				menu.SetText("У меня нет денег! Последние недавно отобрали!")
				return
			end

			npc:Robbery()
			menu:Remove()
		end,
		check = function(ply, npc) return ply:HasGun() and (ply:isGang() or ply:isRebel() or ply:Team() == TEAM_AFERIST) end
	}
}

local nice_text = "Чем могу помочь?"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
