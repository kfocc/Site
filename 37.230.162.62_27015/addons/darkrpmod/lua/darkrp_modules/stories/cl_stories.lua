local function paintFrame(s, w, h)
	Derma_DrawBackgroundBlur(s, s.startTime)
	draw.RoundedBox(10, 0, 0, w, h, col.ba)
end

local function paintHeader(_, w, h)
	draw.RoundedBox(10, 0, 0, w, h, col.o)
	draw.RoundedBox(0, 0, h - 10, w, 10, col.o) -- убирает нижнее скругление
end

local color_control = Color(80, 100, 200)
local function paintControl(_, w, h)
	draw.RoundedBox(0, 0, 0, w, h, col.ba)
end

local CROSS = Material("materials/icons/fa32/times.png", "smooth")
local function paintClose(_, w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(CROSS)
	surface.DrawTexturedRect(0, 0, w, h)
end

local function paintPublish(_, w, h)
	draw.RoundedBox(5, 0, 0, w, h, col.o)
	draw.RoundedBox(5, 1, 1, w - 2, h - 2, col.ba)
end

local ICON = Material("materials/icons/fa32/camera.png", "smooth")
local function paintIcon(_, w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(ICON)
	surface.DrawTexturedRect(0, 0, w, h)
end

local function publishScreenshot(name, description)
	netstream.Start("Stories.Publish", name, description)
end

local function publishConfirm(scr, btn, name)
	UI_Request("Публикация скриншота", "Текст, который будет вместе со скриншотом", function(description)
		publishScreenshot(name, description)
		btn:GetParent():GetParent():Remove() -- controls > frame
	end)()
end

local function getLatestScreenshotName()
	local mapscreens = file.Find("screenshots/" .. game.GetMap() .. "*.jpg", "MOD")
	table.sort(mapscreens, function(a, b) return file.Time("screenshots/" .. a, "MOD") > file.Time("screenshots/" .. b, "MOD") end)
	return mapscreens[1]
end

local function getLatestScreenshot()
	local name = getLatestScreenshotName()
	if name then
		local scr = file.Read("screenshots/" .. name, "MOD")
		return scr, "screenshots/" .. name
	end
end

local FONT_TITLE = "TLG.Title"
local FONT_PUBLISH = "TLG.Publish"
surface.CreateFont(FONT_TITLE, {
	font = "Inter",
	extended = true,
	size = 25,
	weight = 500,
})

surface.CreateFont(FONT_PUBLISH, {
	font = "Inter",
	extended = true,
	size = 20,
	weight = 500,
})

local function screenFrame(scr, name)
	local fr = vgui.Create("DPanel")
	fr:SetSize(1000, 700)
	fr:Center()
	fr:MakePopup()
	fr.Paint = paintFrame
	fr.startTime = SysTime()

	local header = vgui.Create("Panel", fr)
	header:Dock(TOP)
	header:DockPadding(10, 10, 10, 10)
	header:SetTall(40)
	header.Paint = paintHeader

	local close = vgui.Create("DButton", header)
	close:Dock(RIGHT)
	close:SetText("")
	close:SetWide(header:GetTall() - 20) -- 10 padding
	close.Paint = paintClose
	close.DoClick = function() fr:Remove() end

	local controls = vgui.Create("Panel", fr)
	controls:Dock(TOP)
	controls:DockPadding(20, 20, 20, 20)
	controls:SetTall(80)
	controls.Paint = paintControl

	local icon = vgui.Create("Panel", controls)
	icon:Dock(LEFT)
	icon:DockMargin(0, 0, 20, 0)
	icon:SetWide(controls:GetTall() - 35) -- 20 padding
	icon.Paint = paintIcon

	local title = vgui.Create("DLabel", controls)
	title:Dock(FILL)
	title:SetFont(FONT_TITLE)
	title:SetTextColor(color_white)
	title:SetText("Публикация в t.me/thehub_stories")

	local base64 = util.Base64Encode(scr)
	local publish = vgui.Create("DButton", controls)
	publish:SetText("Опубликовать")
	publish:SetFont(FONT_PUBLISH)
	publish:SetTextColor(color_white)
	publish:Dock(RIGHT)
	publish:DockMargin(50, 0, 0, 0)
	publish:SetWide(150)
	publish.DoClick = function(self)
		print("Нажал")
		publishConfirm(base64, self, name)
	end

	publish.Paint = paintPublish

	local html = string.format([[<center>
	<img src='data:image/jpeg; base64, %s' alt='ERROR' width='%d' height='%d' />
	</center>]], base64, 1000 - 30, 700 - 40 - 20 - 80)
	local view = vgui.Create("DHTML", fr)
	view:Dock(FILL)
	view:SetHTML(html)
	return fr
end

local function suggestPublishLatest()
	if IsValid(STORIES) then STORIES:Remove() end
	local scr, name = getLatestScreenshot()
	STORIES = screenFrame(scr, name)
end

local function hookcmd()
	local meta = FindMetaTable("Player")
	meta.oConCommand = meta.oConCommand or meta.ConCommand
	function meta:ConCommand(...)
		if select(1, ...) == "jpeg" then
			meta:oConCommand("jpeg")
			timer.Simple(1, function() suggestPublishLatest() end)
			return
		end
		return meta:oConCommand(...)
	end
end

hookcmd()
