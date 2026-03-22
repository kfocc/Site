include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(self:LookupSequence("d1_t01_Clutch_Chainlink_Idle")) -- sitccouchtv1
end

local buttons = {
	{
		text = "Что случилось?",
		func = function(npc, menu)
			local ct = CurTime()
			if (menu.whatHappenedCD or 0) >= ct then return end
			menu.whatHappenedCD = ct + 17
			npc:EmitSound("vo/trainyard/cit_fence_woods.wav")
			menu.SetText("Патруль остановил наш поезд в лесу и моего мужа увели на допрос. Они сказали, что он приедет на следующем поезде. Не знаю, когда это было. Хорошо, что они разрешили его подождать...")
		end
	},
	{
		text = "Пока",
		func = function(npc, menu) menu:Remove() end
	}
}

function ENT:OnOpen()
	DialogSys.BeginDialogue(self, "Кроме вас на поезде никого не было?", buttons)
end
