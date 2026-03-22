include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/gun.png", "noclamp smooth")
local vecUp = Vector(0, 0, 75)
function ENT:Draw(flags)
	self:DrawModel(flags)

	local origin = self:GetPos()
	local lp = LocalPlayer()
	if lp:GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + vecUp, lp:GetAngles(), "Джордж", 256, col.w, "Местный авторитет", self.Icon)
end

function ENT:Initialize()
	self.requestTimeout = 0
end

-- local laughs = {
-- 	"vo/npc/Barney/ba_laugh01.wav",
-- 	"vo/npc/Barney/ba_laugh02.wav",
-- 	"vo/npc/Barney/ba_laugh03.wav",
-- 	"vo/npc/Barney/ba_laugh04.wav"
-- }
local function searchThiefOrSmuggler(npc, menu, isRequest)
	local keyWord = isRequest and "запросить" or "найти"
	menu.SetText("Кого ты хочешь " .. keyWord .. "?")
	menu.SetButtons({
		{
			text = "Я хочу " .. keyWord .. " контрабандиста.",
			func = function(_npc, _menu)
				UI_Derma_Query("Вы уверены, что хотите " .. keyWord .. " контрабандиста?", "Поиск", "Да", function()
					if not IsValid(_npc) then return end
					_npc.requestTimeout = CurTime() + _npc.clientTimeout
					if not IsValid(_menu) then return end
					_menu.SetText("Я донёс информацию о тебе, подожди немного и может быть тебе ответят.")
					_menu.SetButtons()
					netstream.Start("job_npc6.searchOrRequest", _npc, isRequest, true)
				end, "Нет", function()
					if not IsValid(_npc) then return end
					_npc.requestTimeout = CurTime() + _npc.clientTimeout
					if not IsValid(_menu) then return end
					_menu.SetText("Приходи как надумаешь.")
					_menu.SetButtons()
				end)()
			end
		},
		{
			text = "Я хочу " .. keyWord .. " вора.",
			func = function(_npc, _menu)
				UI_Derma_Query("Вы уверены, что хотите " .. keyWord .. " вора?", "Поиск", "Да", function()
					if not IsValid(_npc) then return end
					_npc.requestTimeout = CurTime() + _npc.clientTimeout
					if not IsValid(_menu) then return end
					_menu.SetText("Я донёс информацию о тебе, подожди немного и может быть тебе ответят.")
					_menu.SetButtons()
					netstream.Start("job_npc6.searchOrRequest", _npc, isRequest, false)
				end, "Нет", function()
					if not IsValid(_npc) then return end
					_npc.requestTimeout = CurTime() + _npc.clientTimeout
					if not IsValid(_menu) then return end
					_menu.SetText("Приходи как надумаешь.")
					_menu.SetButtons()
				end)()
			end
		},
	})
end

local rumors_or_huckster_npc_class, rumors_or_huckster_buttons
rumors_or_huckster_buttons = {
	{
		text = "Держи",
		func = function(npc, menu)
			netstream.Start("PassMarkerNPC.JobNPC6", npc, rumors_or_huckster_npc_class)
			menu.SetText("Отличное вложение средств! Моя информация стоит своих денег, если, что ты знаешь где меня найти")
			rumors_or_huckster_npc_class = nil
			menu.SetButtons()
		end,
		check = function(ply, npc)
			if not rumors_or_huckster_npc_class then return false end
			return ply:canAfford(250)
		end
	}
}

local buttons = {
	{
		text = "Хочу примкнуть к вам",
		func = function(npc, menu)
			menu:Remove()
			OpenJob(npc.npcJobType)
		end
	},
	{
		text = "[Важно] Расскажите о бандитах",
		func = function(npc, menu) gui.OpenURL("https://f.unionrp.info/threads/5433/#post-50372") end
	},
	--	{
	--		text = "Я жду свою долю",
	--		func = function(npc, menu)
	--			if not LocalPlayer():GetNetVar("NeedToPay") then
	--				menu.SetText("Ты кого обдурить захотел? Думаешь, что я тебе поверю? Ха-ха")
	--				npc:EmitSound(laughs[math.random(#laughs)])
	--				return
	--			end
	--			netstream.Start("NeedToPay.Receive")
	--			menu.SetText("Держи свою долю")
	--		end
	--	},
	{
		text = "Где бандиты берут оружие?",
		func = function(npc, menu) menu.SetText("Пушки бандосам продает снабдитель с черного рынка. Может ты видел уже его в городе? Он никогда не остается на одном месте, чтобы приобрести у него товар - тебе придется поискать его. Но поверь, товар у него отменный!") end
	},
	{
		text = "Где сейчас находится барыга?",
		func = function(npc, menu)
			if not weapons_give_npc.jobs[LocalPlayer():Team()] then
				menu.SetText("Я не знаю никаких барыг, катись отсюда")
				rumors_or_huckster_npc_class = nil
			else
				menu.SetText("Цена вопроса 250 токенов")
				rumors_or_huckster_npc_class = "weapon_give_npc"
			end

			menu.SetButtons(rumors_or_huckster_buttons)
		end
	},
	{
		text = "Где я могу пустить слухи по городу?",
		func = function(npc, menu)
			menu.SetText("Цена вопроса 250 токенов")
			rumors_or_huckster_npc_class = "advert_npc"
			menu.SetButtons(rumors_or_huckster_buttons)
		end
	},
	{
		text = "Я хочу найти человека.",
		func = function(npc, menu)
			local lp = LocalPlayer()
			if lp:isCP() and not lp:isRebel() then
				menu.SetText("Я не поисковое бюро для Альянса. Мне и так не очень хорошо живётся.")
				return
			end

			if npc.requestTimeout >= CurTime() or npc:GetSearchCooldown() >= CurTime() then
				menu.SetText("Подожди немного перед этим. Я не настолько быстрый.")
				return
			end

			searchThiefOrSmuggler(npc, menu, false)
		end
	},
	{
		text = "Я хочу вызвать человека.",
		func = function(npc, menu)
			local lp = LocalPlayer()
			if lp:isCP() and not lp:isRebel() then
				menu.SetText("Я не поисковое бюро для Альянса. Мне и так не очень хорошо живётся.")
				return
			end

			if npc.requestTimeout >= CurTime() or npc:GetSearchCooldown() >= CurTime() then
				menu.SetText("Подожди немного перед этим. Я не настолько быстрый.")
				return
			end

			searchThiefOrSmuggler(npc, menu, true)
		end
	}
}

local nice_text = "Что тебе нужно?"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end
