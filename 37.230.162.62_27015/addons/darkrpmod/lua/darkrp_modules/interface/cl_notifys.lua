local ScreenPos = ScrH() - 200

local Colors = {}
Colors[NOTIFY_GENERIC] = Color(20, 100, 20)
Colors[NOTIFY_ERROR] = Color(215, 20, 20)
Colors[NOTIFY_UNDO] = Color(25, 25, 125)
Colors[NOTIFY_HINT] = Color(100, 100, 100)
Colors[NOTIFY_CLEANUP] = Color(215, 100, 75)

local LoadingColor = Color(50, 50, 50)
local Icons = {}
Icons[NOTIFY_GENERIC] = Material("vgui/notices/generic")
Icons[NOTIFY_ERROR] = Material("vgui/notices/error")
Icons[NOTIFY_UNDO] = Material("vgui/notices/undo")
Icons[NOTIFY_HINT] = Material("vgui/notices/hint")
Icons[NOTIFY_CLEANUP] = Material("vgui/notices/cleanup")

local LoadingIcon = Material("vgui/notices/hint")
local Notifications = {}
surface.CreateFont("UnionNotification", {
	font = "Inter",
	size = 20,
	extended = true,
})

local Theme = {
	BG = Color(0, 0, 0, 200),
	Outline = Color(0, 0, 0, 255),
	Text = Color(255, 255, 255, 255),
}

local function DrawNotification(x, y, w, h, text, icon, col, progress, notif)
	if not notif or not notif.start then return end
	local frac = (notif.time - CurTime()) / (notif.time - notif.start)

	draw.RoundedBoxEx(0, x, y, h, h, col, true, false, true, false)
	draw.RoundedBoxEx(0, x + h - 1, y, 1, h, color_white, true, false, true, false)
	draw.RoundedBoxEx(0, x + h, y, w - h, h, Color(20, 20, 20, 220), false, true, false, true)
	draw.RoundedBoxEx(0, x + h, y, (w - h) * frac, h, Color(col.r, col.g, col.b, 20) or Color(215, 100, 75, 20), false, true, false, true)
	--draw.RoundedBox( 0, x + h, y + h - 3, (w - h) * frac, 3, Color(215, 100, 75))

	draw.SimpleText(text, "UnionNotification", x + 32 + 10, y + h / 2, Theme.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetDrawColor(Theme.Text)
	surface.SetMaterial(icon)

	if progress then
		surface.DrawTexturedRectRotated(x + 16, y + h / 2, 16, 16, -CurTime() * 360 % 360)
	else
		surface.DrawTexturedRect(x + 8, y + 8, 16, 16)
	end
end

function notification.AddLegacy(text, type, time)
	surface.SetFont("UnionNotification")

	local w = surface.GetTextSize(text) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos
	table.insert(Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[type],
		icon = Icons[type],
		start = CurTime(),
		time = CurTime() + time,

		progress = false,
	})
end

function notification.AddProgress(id, text)
	surface.SetFont("UnionNotification")
	local w = surface.GetTextSize(text) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos
	table.insert(Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		icon = LoadingIcon,
		time = math.huge,

		progress = true,
	})
end

function notification.Kill(id)
	for k, v in ipairs(Notifications) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add("HUDPaint", "DrawNotifications", function()
	for k, v in ipairs(Notifications) do
		DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, col.o or v.col, v.progress, v)

		v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
		v.y = Lerp(FrameTime() * 10, v.y, ScreenPos - (k - 1) * (v.h + 5))
	end

	for k, v in ipairs(Notifications) do
		if v.x >= ScrW() and v.time < CurTime() then table.remove(Notifications, k) end
	end
end)

local msg = {
	"Проблемы? Идеи? Вопросы? Жалоба? Нашли баг? Заходите на форум! f.unionrp.info",
	"Все правила и тен-коды можно найти на сайте UnionRP.info",
	"Желаете помочь серверу и получить бонус? Нажмите F6",
	--"Вступите в группу Steam и получите бонус! /rewards",
	--"Много друзей? Пригласи их и дай им свой реферальный код! /rewards",
	--"За ввод реферального кода вы получите 5.000 токенов! /rewards",
	"Вы можете подать заявку на администратора на сайте UnionRP.info/req",
	--"За ввод вашого реферального кода человек получит 5.000 токенов, а вы 10.000 + бонусы! /rewards",
	"Присоединяйся к нашей Telegram беседе! Общайтесь и будьте в курсе всех обновлений первыми! /telegram",
	"Настроить интерфейс, чат, рацию, включить вид от 3-го лица и многое другое можно через Q - UnionRP (Справа, сверху) - Настройки",
	"Скриншоты сделанные на фотоаппарат автоматически публикутся в телеграм канале! Подписывайся t.me/thehub_stories",
	"Хотите узнавать про обновления первыми? Подписывайся на наш телеграм канал - t.me/thehubclick",
	"Вступайте в нашу группу Вконтакте. Общайтесь, смотрите мемы и публикуйте скриншоты! vk.com/union_hl2",
	"Вступи в группу STEAM! Важные объявление и новости публикуются тут - steamcommunity.com/groups/union_rp",
	"Присоединяйся к нашему Discord серверу и общайся! discord.com/invite/fXPnzkb",
	"Использование стороннего ПО / читов приведет к НЕСНИМАЕМОЙ блокировке на проекте!",
	"Купить донат со скидкой, а также бесконечные привилегии можно в группе ВК - vk.com/union_hl2"
}

timer.Create("notifyme", 300, 0, function() chat.AddText(col.o, "[UnionRP] ", Color(255, 255, 255), msg[math.random(#msg)]) end)
