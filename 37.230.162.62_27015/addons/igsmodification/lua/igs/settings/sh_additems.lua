local vip_description = [[
✔ Доступ к VIP профессиям
✔ Доступ к VIP предметам (F4 - предметы)
✔ Доступ к установке личного CID в Терминале
✔ Доступ к VIP чату (/v текст)
✔ Голод тратится медленнее
✔ 80 единиц голода при спавне
✔ Доступ к анимации "Дэб"
]]

local operator_description = [[
(В оператора также входит VIP)

• Взять профессию администрации можно командой "!adm" в чат
• Открыть админ меню можно командой "!menu" в чат

✔ Заглушить чат
✔ Заглушить микрофон
✔ Заморозить игрока
✔ Телепортация
✔ Посадить в джайл (600 сек)
✔ Выдача бана (3 часа)
✔ Выдача кика
✔ Полет
✔ Невидимость
✔ Выпустить из тюрьмы
✔ Логи
✔ Админское ESP
✔ Спавн НПС при наборе 600 жалоб в месяц
]]


local moder_description = [[
(В Модератора также входит VIP)

• Взять профессию администрации можно командой "!adm" в чат
• Открыть админ меню можно командой "!menu" в чат

✔ Заглушить чат
✔ Заглушить микрофон
✔ Заморозить игрока
✔ Телепортация
✔ Посадить в джайл (800 сек)
✔ Выдача бана (6 часов)
✔ Выдача кика
✔ Полет
✔ Изменять имена
✔ Невидимость
✔ Отключать КОДЫ (КК, ЖК, КЧ)
✔ Выпустить из тюрьмы
✔ Логи
✔ Админское ESP
✔ Спавн НПС при наборе 600 жалоб в месяц
]]


local admin_description = [[
(В Админа также входит VIP)

• Взять профессию администрации можно командой "!adm" в чат
• Открыть админ меню можно командой "!menu" в чат

✔ Заглушить чат
✔ Заглушить микрофон
✔ Заморозить игрока
✔ Телепортация
✔ Посадить в джайл (1000 сек)
✔ Выдача бана (12 часов)
✔ Выдача кика
✔ Полет
✔ Изменять имена
✔ Невидимость
✔ Отключать КОДЫ (КК, ЖК, КЧ)
✔ Выпустить из тюрьмы
✔ Логи
✔ Админское ESP
✔ Спавн НПС при наборе 600 жалоб в месяц
]]

----------------------------------------------------------------

local cfg_groups = {
	{
		group = "vip",
		priority = 1,
		name  = "VIP аккаунт ★",
		alias = "VIP аккаунт ★",
		desc  = vip_description,
		icon  = "https://i.ibb.co/BnC96ps/zelenaja-galochka.png",
		{270, 30}, {470, 60}, {660, 90}, -- цена и срок
		{2190},
	},{
		group = "operator",
		priority = 2,
		name  = "Оператор ★",
		alias = "Оператор ★",
		desc  = operator_description,
		icon  = "https://i.ibb.co/YLDQ4xB/operatorgm.png",
		{420, 30}, {750, 60}, {1060, 90},
		{3490},
	},{
		group = "moderator",
		priority = 3,
		name  = "Модератор ★",
		alias = "Модератор ★",
		desc  = moder_description,
		icon  = "https://i.ibb.co/8gZLSPF/moderatorgm.png",
		{560, 30}, {1000, 60}, {1400, 90},
		{4590},
	},{
		group = "administrator",
		priority = 4,
		name  = "Админ ★",
		alias = "Админ ★",
		desc  = admin_description,
		icon  = "https://i.ibb.co/b2RkGL2/administratorgm.png",
		{700, 30}, {1260, 60}, {1680, 90},
		{5490},
	},
}
for _, tbl in ipairs(cfg_groups) do
    local group_name = tbl.name
	local GROUP = IGS.NewGroup(group_name)
	GROUP:SetIcon(tbl.icon)

	for _, v in ipairs(tbl) do
	    local ITEM = IGS(group_name, "group_" .. tbl.group .. "_" .. (v[2] or "~") .. "d")
            :SetPrice(v[1])
            :SetTerm(v[2])
            :SetCategory("♛ ПРИВИЛЕГИИ ♛")
            :SetDescription(tbl.desc)
            :SetIcon(tbl.icon)
			:SetULXGroup(tbl.group, tbl.priority)
			:SetCanActivate(function(ply)
				return (ply:HasPurchase("pidor") or ply:IsNabor()) and "Вы не можете активировать привилегию"
			end)
			if tbl.can_buy then
				ITEM:SetCanBuy(tbl.can_buy)
			end
        GROUP:AddItem(ITEM, tbl.alias)
	end
end

--[[-------------------------------------------------------------------------
	Игровая валюта для DarkRP
	Срок нет смысла указывать
	Для удобства суммы объединены в группу (Не категорию)
---------------------------------------------------------------------------]]
local GROUP = IGS.NewGroup("Токены ₮")
GROUP:AddItem(
	IGS("10.000 ₮", "10k")
	:SetPrice(10)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(10000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 10.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("30.000 ₮", "30k")
	:SetPrice(30)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(30000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 30.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("50.000 ₮", "50k")
	:SetPrice(50)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(50000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 50.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("100.000 ₮", "100k")
	:SetPrice(100)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(100000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 100.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("200.000 ₮", "200k")
	:SetPrice(200)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(200000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 200.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("300.000 ₮", "300k")
	:SetPrice(300)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(300000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 300.000 токенов!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("550.000 (+10% ₮)", "500k")
	:SetPrice(500)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(550000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 550.000 токенов! Вам будет начислено 500.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 50.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("840.000 (+20% ₮)", "700k")
	:SetPrice(700)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(840000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 840.000 токенов! Вам будет начислено 700.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 140.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("1.040.000 (+30% ₮)", "1kk")
	:SetPrice(800)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(1040000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 1.040.000 токенов! Вам будет начислено 800.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 240.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("1.400.000 (+40% ₮)", "1000k")
	:SetPrice(1000)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(1400000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 1.400.000 токенов! Вам будет начислено 1.000.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 400.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("1.800.000 (+50% ₮)", "1200k")
	:SetPrice(1200)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(1800000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 1.800.000 токенов! Вам будет начислено 1.200.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 600.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("2.400.000 (+60% ₮)", "1500k")
	:SetPrice(1500)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(2400000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 2.400.000 токенов! Вам будет начислено 1.500.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 900.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("2.720.000 (+70% ₮)", "1600k")
	:SetPrice(1600)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(2720000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 2.720.000 токенов! Вам будет начислено 1.600.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 1.120.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("3.240.000 (+80% ₮)", "1800k")
	:SetPrice(1800)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(3240000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 3.240.000 токенов! Вам будет начислено 1.800.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 1.440.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("3.800.000 (+90% ₮)", "2000k")
	:SetPrice(2000)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(3800000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 3.800.000 токенов! Вам будет начислено 2.000.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 1.800.000 токенов за большое пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

GROUP:AddItem(
	IGS("10.000.000 (+100% ₮)", "10kk")
	:SetPrice(5000)
	:SetIcon("https://i.ibb.co/5Y2t00G/token.png")
	:SetDarkRPMoney(10000000)
	:SetDescription("Мгновенно и без проблем пополняет баланс внутриигровой валюты на 10.000.000 токенов! Вам будет начислено 5.000.000 токенов по прайсу 1 рубль = 1000 токенов. А также вы получите бонусные 5.000.000 токенов за крупное пожертвование!")
	:SetCategory("♜ ИГРОВАЯ ВАЛЮТА ♜")
)

local GROUP = IGS.NewGroup("Ивенты ♠")
GROUP:AddItem(
    IGS("Зомби ивент", "zombie_event")
    :SetPrice(790)
    :SetTerm(0)
    :SetIcon("https://i.ibb.co/4jgyLcr/iventgm.png")
    :SetDescription("Дает возможность единоразово провести зомби ивент на 25 минут. Вы станете нулевым пациентом с 1500 HP (При возрождении вы вновь получите 1500 HP). Каждый убитый вами или другим зомби человек становится вашим приспешником. Сможете ли вы заразить весь город? По окончанию ивента, все профессии будут возвращены. ИВЕНТ МОЖНО ПРОВЕСТИ 1 РАЗ ЗА ДЕНЬ!")
    :SetCategory("♞ ИВЕНТЫ ♞")
	:SetStackable(true)
    :SetOnActivate(function(pl)
        if SERVER then
            zombie_event:Start(pl)
        end
    end)
)
--local msges = {"Просто захотел знать о себе","Решил помочь серверу", "Наслаждается игрой, пока ты читаешь это"}
--IGS("Оповещение", "notify")
--	:SetPrice(40)
--	:SetCategory("Дополнительное")
--	:SetDescription("Просто дать всем знать о себе")
--	:SetOnActivate(function(pl)
--		umsg.Start("AdminTell")
 --       	umsg.String(pl:Name().." "..table.Random(msges))
 --   	umsg.End()
--	end)


-- CID changes.

local function activateDonateCID(ply, number)
    if not SERVER then return end

    ply:SetDBVar("Change.CID", number)

    ply:ChatPrint("[CID] Введите /cid в чат, чтобы сменить CID.")
    DarkRP.notify(ply, 3, 60, "[CID] Введите /cid в чат, чтобы сменить CID.")
end

local GROUP = IGS.NewGroup("CID номера ♣")
GROUP:AddItem(
    IGS("Пятизначный CID", "cid5")
    :SetPrice(240)
    :SetIcon("https://i.ibb.co/SVvwnhg/cidgm.png")
    :SetDescription("После покупки, вы сможете выбрать и установить пятизначный номер CID НАВСЕГДА. ВНИМАНИЕ! Проверить доступность номера можно в Терминале CID на вокзале!")
    :SetCategory("♣ CID НОМЕРА ♣")
    :SetOnActivate(function(ply)
        activateDonateCID(ply, 5)
    end)
)

GROUP:AddItem(
    IGS("Четырехзначный CID", "cid4")
    :SetPrice(480)
    :SetIcon("https://i.ibb.co/SVvwnhg/cidgm.png")
    :SetDescription("После покупки, вы сможете выбрать и установить четырехзначный номер CID НАВСЕГДА. ВНИМАНИЕ! Проверить доступность номера можно в Терминале CID на вокзале!")
    :SetCategory("♣ CID НОМЕРА ♣")
    :SetOnActivate(function(ply)
        activateDonateCID(ply, 4)
    end)
)

GROUP:AddItem(
    IGS("Трехзначный CID", "cid3")
    :SetPrice(970)
    :SetIcon("https://i.ibb.co/SVvwnhg/cidgm.png")
    :SetDescription("После покупки, вы сможете выбрать и установить трехзначный номер CID НАВСЕГДА. ВНИМАНИЕ! Проверить доступность номера можно в Терминале CID на вокзале!")
    :SetCategory("♣ CID НОМЕРА ♣")
    :SetOnActivate(function(ply)
        activateDonateCID(ply, 3)
    end)
)

-- При нажатии ведет на товар вконтакте!
GROUP:AddItem(
    IGS("Лимитированный CID", "cidlimited")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/SVvwnhg/cidgm.png")
    :SetDescription("Вы сможете выбрать и установить лимитированный номер CID НАВСЕГДА! Список лимитированных CID можно узнать у продавца.")
    :SetCategory("♣ CID НОМЕРА ♣")
    :SetCanBuy(function()
        return "Цена - 1390 руб. Информация продублируется в чат. Чтобы приобрести этот CID, вам нужно написать: ВКонтакте - vk.com/aleksanderperm ИЛИ Telegram - t.me/Zondo59"
    end)
)


local GROUP = IGS.NewGroup("Другие способы ✈")
GROUP:AddItem(
    IGS("Донат - Беларусь", "helpdonate1")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/RgbSB1W/bygm.png")
    :SetDescription([[Если у вас возникли сложности при пополнение счета, вы можете пополнить его напрямую.

	► Отправьте свой STEAM ID (или ссылку на STEAM аккаунт).
	► Укажите сервер на который вы хотите получить донат.
	► Укажите, что донат из Беларуси.]])
    :SetCategory("✈ Донат напрямую")
    :SetCanBuy(function()
        return "Информация продублируется в чат. Чтобы пополнить счет, вам нужно написать: ВКонтакте - vk.com/aleksanderperm ИЛИ Telegram - t.me/Zondo59 | Не забудьте указать страну."
    end)
)

GROUP:AddItem(
    IGS("Донат - Казахстан", "helpdonate2")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/Wgy6ybC/kzgm.png")
    :SetDescription([[Если у вас возникли сложности при пополнение счета, вы можете пополнить его напрямую.

	► Отправьте свой STEAM ID (или ссылку на STEAM аккаунт).
	► Укажите сервер на который вы хотите получить донат.
	► Укажите, что донат из Казахстана.]])
    :SetCategory("✈ Донат напрямую")
    :SetCanBuy(function()
        return "Информация продублируется в чат. Чтобы пополнить счет, вам нужно написать: ВКонтакте - vk.com/aleksanderperm ИЛИ Telegram - t.me/Zondo59 | Не забудьте указать страну."
    end)
)

GROUP:AddItem(
    IGS("Донат - Россия", "helpdonate3")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/tp5zZmy/rugm.png")
    :SetDescription([[Если у вас возникли сложности при пополнение счета, вы можете пополнить его напрямую.

	► Отправьте свой STEAM ID (или ссылку на STEAM аккаунт).
	► Укажите сервер на который вы хотите получить донат.
	► Укажите, что донат из России.]])
    :SetCategory("✈ Донат напрямую")
    :SetCanBuy(function()
        return "Информация продублируется в чат. Чтобы пополнить счет, вам нужно написать: ВКонтакте - vk.com/aleksanderperm ИЛИ Telegram - t.me/Zondo59 | Не забудьте указать страну."
    end)
)

GROUP:AddItem(
    IGS("Донат - Украина", "helpdonate4")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/XbxVhMk/uagm.png")
    :SetDescription([[Если у вас возникли сложности при пополнение счета, вы можете пополнить его напрямую.

	► Отправьте свой STEAM ID (или ссылку на STEAM аккаунт).
	► Укажите сервер на который вы хотите получить донат.
	► Укажите, что донат из Украины.]])
    :SetCategory("✈ Донат напрямую")
    :SetCanBuy(function()
        return "Информация продублируется в чат. Чтобы пополнить счет, вам нужно написать: Telegram - t.me/Zondo59 | Не забудьте указать страну."
    end)
)

GROUP:AddItem(
    IGS("Донат - PayPal", "helpdonate5")
	:SetPrice(0)
    :SetIcon("https://i.ibb.co/fGRY2Bj/PPgm.png")
    :SetDescription([[Если у вас возникли сложности при пополнение счета, вы можете пополнить его напрямую.

	► Отправьте свой STEAM ID (или ссылку на STEAM аккаунт).
	► Укажите сервер на который вы хотите получить донат.
	► Укажите, что будем использовать PayPal.]])
    :SetCategory("✈ Донат напрямую")
    :SetCanBuy(function()
        return "Информация продублируется в чат. Чтобы пополнить счет, вам нужно написать: Telegram - t.me/Zondo59 | Не забудьте сказать, что будет использоваться PayPal."
    end)
)