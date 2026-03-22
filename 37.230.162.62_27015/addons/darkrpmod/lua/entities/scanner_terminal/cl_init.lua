include("shared.lua")

local photoConVar = CreateClientConVar("unionrp_scanner_photo", "1", true, false)
local IsValid = IsValid
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local vec = Vector(0, 0, 75)
local color_white_draw = Color(255, 255, 255)
local color_black_draw = Color(0, 0, 0)
function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Draw(flags)
	self:DrawModel(flags)

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if dist > 350 then return end

	color_white_draw.a = 350 - dist
	color_black_draw.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	-- ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)

	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
	draw_SimpleTextOutlined("Терминал сканеров", "DermaLarge", 0, 0, color_white_draw, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black_draw)
	cam_End3D2D()
end

local PICTURE_DELAY = 30
surface.CreateFont("nutScannerFont", {
	font = "Autodestruct BB",
	extended = true,
	outline = true,
	weight = 800,
	size = 18
})

local PICTURE_WIDTH, PICTURE_HEIGHT = 480, 320
local PICTURE_WIDTH2, PICTURE_HEIGHT2 = PICTURE_WIDTH * 0.5, PICTURE_HEIGHT * 0.5
local view = {}
local zoom = 0
local deltaZoom = zoom
local nextClick = 0
hook.Add("CalcView", "nutScn_CalcView", function(client, origin, angles, fov)
	if IsValid(client:GetNetVar("Scanner")) and IsValid(client:GetViewEntity()) then

		view.angles = client:EyeAngles()
		view.fov = fov - deltaZoom

		if math.abs(deltaZoom - zoom) > 5 and nextClick < RealTime() then
			nextClick = RealTime() + 0.05
			client:EmitSound("common/talk.wav", 100, 180)
		end
		return view
	end
end)

hook.Add("InputMouseApply", "nutScn_InputMs", function(command, x, y, angle)
	zoom = math.Clamp(zoom + command:GetMouseWheel() * 1.5, 0, 40)
	deltaZoom = Lerp(FrameTime() * 2, deltaZoom, zoom)
end)

-- local color_transparent = Color(255, 255, 255, 0)
local color_white = Color(255, 255, 255, 255)
local hidden = false
hook.Add("PreRender", "nutScn_PreDrawOpaq", function()
	local ply = LocalPlayer()
	local scanner = ply:GetNetVar("Scanner")
	if not IsValid(scanner) then
		hidden = false
		return
	end

	local viewEntity = ply:GetViewEntity()
	if viewEntity == scanner and not hidden then
		scanner:SetNoDraw(true)

		-- scanner:SetRenderMode(RENDERMODE_TRANSCOLOR)
		-- scanner:SetColor(color_transparent)
		hidden = true
	elseif viewEntity ~= scanner and hidden then
		scanner:SetNoDraw(false)

		-- scanner:SetColor(color_white)
		-- scanner:SetRenderMode(RENDERMODE_NORMAL)
		hidden = false
	end
end, HOOK_LOW)

hook.Add("ShouldDrawCrosshair", "nutScn_Crossh", function() if hidden then return false end end)
hook.Add("AdjustMouseSensitivity", "nutScn_AdjustSens", function() if hidden then return 0.5 end end)

local data = {}
hook.Add("HUDPaint", "nutScn_HUD", function()
	local ply = LocalPlayer()
	if not hidden then return end

	local scrW, scrH = ScrW() * 0.5, ScrH() * 0.5
	local x, y = scrW - PICTURE_WIDTH2, scrH - PICTURE_HEIGHT2
	if ply.lastPic and ply.lastPic >= CurTime() then
		local percent = math.Round(math.TimeFraction(ply.lastPic - PICTURE_DELAY, ply.lastPic, CurTime()), 2) * 100
		local glow = math.sin(RealTime() * 15) * 25
		draw.SimpleText("RE-CHARGING: " .. percent .. "%", "nutScannerFont", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
	end

	--local position = ply:GetPos()
	--local angle = ply:GetAimVector():Angle()
	--draw.SimpleText("POS ( " .. math.floor(position[1]) .. ", " .. math.floor(position[2]) .. ", " .. math.floor(position[3]) .. " )", "nutScannerFont", x + 8, y + 8, color_white)
	--draw.SimpleText("ANG ( " .. math.floor(angle[1]) .. ", " .. math.floor(angle[2]) .. ", " .. math.floor(angle[3]) .. " )", "nutScannerFont", x + 8, y + 48, color_white)
	draw.SimpleText("ID  ( " .. "SCN: #" .. ply:GetID() .. " )", "nutScannerFont", x + 8, y + 28, color_white)
	draw.SimpleText("ZM  ( " .. math.Round(zoom / 40, 2) * 100 .. "% )", "nutScannerFont", x + 8, y + 48, color_white)

	local scanner = ply:GetNetVar("Scanner")
	if IsValid(scanner) then

		data.start = scanner:GetPos()
		data.endpos = data.start + ply:GetAimVector() * 1000
		data.filter = scanner

		local entity = util.TraceLine(data).Entity
		local entityname, entityid, wantedreason, zone
		if IsValid(entity) and entity:IsPlayer() then
			zone = entity:GetNiceZone() .. " "
			entityname = entity:Name()
			entityid = "#" .. entity:GetID()
			if entity:getDarkRPVar("wanted") then
				wantedreason = entity:getDarkRPVar("wantedReason")
			else
				wantedreason = "Не в розыске"
			end
		else
			zone = ""
			entityname = "NULL"
			entityid = "NULL"
			wantedreason = "NULL"
		end

		draw.SimpleText("AREA ( City-17 " .. zone .. ")", "nutScannerFont", x + 8, y + 8, color_white)

		local by = scrH + PICTURE_HEIGHT2
		draw.SimpleText("CID ( " .. entityid .. " )", "nutScannerFont", x + 8, by - 68, color_white)
		draw.SimpleText("TRG ( " .. entityname .. " )", "nutScannerFont", x + 8, by - 48, color_white)
		draw.SimpleText("WANTED ( " .. wantedreason .. " )", "nutScannerFont", x + 8, by - 28, color_white)
	end

	surface.SetDrawColor(235, 235, 235, 230)

	surface.DrawLine(0, scrH, x - 128, scrH)
	surface.DrawLine(scrW + PICTURE_WIDTH2 + 128, scrH, ScrW(), scrH)
	surface.DrawLine(scrW, 0, scrW, y - 128)
	surface.DrawLine(scrW, scrH + PICTURE_HEIGHT2 + 128, scrW, ScrH())

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = scrW + PICTURE_WIDTH2 + 1

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y + 128)

	x = scrW - PICTURE_WIDTH2
	y = scrH + PICTURE_HEIGHT2 + 1

	surface.DrawLine(x, y, x + 128, y)
	surface.DrawLine(x, y, x, y - 128)

	x = scrW + PICTURE_WIDTH2 + 1

	surface.DrawLine(x, y, x - 128, y)
	surface.DrawLine(x, y, x, y - 128)

	surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
	surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)

	surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
	surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
end)

local instructions = {{"Опуститься ниже", "Левый Ctrl"}, {"Подняться выше", "Пробел"}, {"Звуки сканера", "E / R"}, {"Включение прожектора", "F"}, {"Включение камеры", "Левый Shift"}, {"Сделать фото", "Левая кнопка мыши"}, {"Выход из сканера", "G"},}
local stencil = "[ %s ] - { %s }"
hook.Add("HUDPaint", "nutScn_drawInstructions", function()
	if IsValid(LocalPlayer():GetNetVar("Scanner")) then
		local h = ScrH() - 25
		local y, _
		for k, v in ipairs(instructions) do
			_, y = draw.SimpleText(stencil:format(v[1], v[2]), "TextFont", 5, h, color_white)
			h = h - y - 10
		end
	end
end)

local screenshot = false
local screenshotBase64
hook.Add("PostRender", "GetClientPhoto", function()
	if not screenshot then return end
	screenshot = false

	if vgui.GetHoveredPanel() or gui.IsGameUIVisible() or gui.IsConsoleVisible() then return end

	local ply = LocalPlayer()
	if (ply.lastPic or 0) >= CurTime() then return end

	ply.lastPic = CurTime() + PICTURE_DELAY
	local flash = DynamicLight(LocalPlayer():EntIndex())
	if not flash then return end

	-- local scanner = ply:GetNetVar("Scanner")
	flash.pos = EyePos()
	flash.r = 255
	flash.g = 255
	flash.b = 255
	flash.brightness = 4
	flash.size = 2000
	flash.decay = 1000
	flash.dietime = CurTime() + 2
	flash.style = 0

	local data = render.Capture({
		format = "jpg",
		h = PICTURE_HEIGHT,
		w = PICTURE_WIDTH,
		quality = 95,
		x = ScrW() * 0.5 - PICTURE_WIDTH2 + 1,
		y = ScrH() * 0.5 - PICTURE_HEIGHT2 + 1
	})

	screenshotBase64 = util.Base64Encode(data, true)
	netstream.Start("Scanner.Request")
end)

netstream.Hook("Scanner.Request", function(link, hash)
	if not screenshotBase64 then return end
	SCR.Upload(screenshotBase64, link, hash, function(result)
		assert(result, "Scanner.Request: Nil result")
		if result.error then return end
		netstream.Start("Scanner.Publish", result.link, hash)
	end)
end)

-- local blackAndWhite = {
-- 	["$pp_colour_addr"] = 0,
-- 	["$pp_colour_addg"] = 0,
-- 	["$pp_colour_addb"] = 0,
-- 	["$pp_colour_brightness"] = 0,
-- 	["$pp_colour_contrast"] = 0.5,
-- 	["$pp_colour_colour"] = 0,
-- 	["$pp_colour_mulr"] = 0,
-- 	["$pp_colour_mulg"] = 0,
-- 	["$pp_colour_mulb"] = 0
-- }
-- hook.Add("RenderScreenspaceEffects", "nutScn_ScreenSpaceEff", function()
-- if hidden then
-- 	blackAndWhite["$pp_colour_brightness"] = 0.05 + math.sin(RealTime() * 10) * 0.01
-- 	DrawColorModify(blackAndWhite)
-- end
-- end)
hook.Add("PlayerButtonDown", "nutScn_BindPress", function(client, key) if key == MOUSE_LEFT and hidden and not gui.IsGameUIVisible() then screenshot = true end end)
local CURRENT_PHOTO
PHOTO_CACHE = PHOTO_CACHE or {}
local htmlStr = [[
	<html>
		<body style="background: black; overflow: hidden; margin: 0; padding: 0;">
			<img src="https://unionrp.info/hl2rp/mine_shit/proxy.php?url=%s" width="]] .. PICTURE_WIDTH .. [[" height="]] .. PICTURE_HEIGHT .. [[" />
		</body>
	</html>
]]
netstream.Hook("Scanner.Publish", function(image)
	local convar = photoConVar:GetInt()
	if convar ~= 1 then return end
	if not isstring(image) then return end
	if IsValid(CURRENT_PHOTO) then
		local panel = CURRENT_PHOTO
		CURRENT_PHOTO:AlphaTo(0, 0.25, 0, function() if IsValid(panel) then panel:Remove() end end)
	end

	local html = string.format(htmlStr, image)
	local w = ScrW()
	local panel = vgui.Create("DPanel")
	panel:SetSize(PICTURE_WIDTH + 8, PICTURE_HEIGHT + 8)
	panel:SetPos(w, 8)
	panel:SetPaintBackground(true)
	panel:SetAlpha(150)
	panel:SetVisible(false)
	timer.Simple(2, function()
		if not IsValid(panel) then return end
		panel:SetVisible(true)
		panel:MoveTo(w - (panel:GetWide() + 8), 8, 0.5)
	end)

	timer.Simple(5.5, function() if IsValid(panel) then panel:MoveTo(w, 8, 0.5, 0, -1, function() panel:Remove() end) end end)
	panel.body = panel:Add("DHTML")
	panel.body:Dock(FILL)
	panel.body:DockMargin(4, 4, 4, 4)
	panel.body:SetHTML(html)
	PHOTO_CACHE[#PHOTO_CACHE + 1] = {
		data = image,
		time = os.time()
	}

	CURRENT_PHOTO = panel
end)

local color_gray = col.b:lighten(50)
local defaultImage = "https://unionrp.info/hl2rp/mine_shit/proxy.php?url=https://i.imgur.com/T3LwqgJ.png"
concommand.Add("union_scannerCache", function()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Кэш фотографий")
	frame:SetSize(900, 360)
	frame:MakePopup()
	frame:Center()
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.ba)
		draw.RoundedBox(0, 0, 0, w, h * 0.06, col.o)
	end

	local leftp = frame:Add(DPanel)
	leftp:Dock(LEFT)
	leftp:DockMargin(0, 0, 5, 0)
	leftp:SetWide(400)
	local rightp = frame:Add(DPanel)
	rightp:Dock(RIGHT)
	rightp:DockMargin(5, 0, 0, 0)
	rightp:SetWide(485)
	local cache = not table.IsEmpty(PHOTO_CACHE) and PHOTO_CACHE[#PHOTO_CACHE].data or defaultImage
	cache = string.format(htmlStr, cache)
	local dhtml = rightp:Add("DHTML")
	dhtml:SetHTML(cache)
	dhtml:Dock(FILL)
	dhtml:DockMargin(4, 4, 4, 4)
	frame.list = leftp:Add("DScrollPanel")
	frame.list:Dock(FILL)
	frame.list:SetDrawBackground(true)
	frame.list.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, color_gray) end
	for i = #PHOTO_CACHE, 1, -1 do
		local v = PHOTO_CACHE[i]
		local button = frame.list:Add("DButton")
		button:SetTall(28)
		button:Dock(TOP)
		button:DockMargin(4, 4, 4, 0)
		button:SetText(os.date("%X - %d/%m/%Y", v.time))
		button.DoClick = function() dhtml:SetHTML(string.format(htmlStr, v.data)) end
	end
end)
