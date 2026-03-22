local fonts = {}
fonts.big = "UnionHUDO50"
fonts.medium = "UnionHUD25"
local icons = {}
icons.crosshairs = {}
icons.crosshairs[1] = Material("vgui/visor/asset.png", "noclamp smooth") -- Стандарт
icons.crosshairs[2] = Material("vgui/visor/green.png", "noclamp smooth") -- Тиммейт
icons.crosshairs[3] = Material("vgui/visor/deviant.png", "noclamp smooth") -- В розыске
icons.crosshairs[4] = Material("vgui/visor/blue.png", "noclamp smooth") -- Синий
icons.crosshairs[5] = Material("vgui/visor/target-priority.png", "noclamp smooth") -- Приоритет / Цель #1
icons.crosshairs[6] = Material("vgui/visor/target.png", "noclamp smooth") -- АК
icons.scan = Material("vgui/visor/scan.png", "noclamp smooth")
icons.white = Material("vgui/visor/white.jpg", "noclamp smooth")
-- helper funcs
local function DrawTOutlinedRect(x, y, w, h, texture, outline, color, coloro)
	texture = texture or icons.white
	if color then
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
	else
		surface.SetDrawColor(255, 255, 255)
	end

	surface.SetMaterial(texture)
	surface.DrawTexturedRect(x - 2, y, w + 4, h)
	if outline == true then
		if coloro then
			surface.SetDrawColor(coloro.r, coloro.g, coloro.b, coloro.a)
		else
			surface.SetDrawColor(0, 0, 0)
		end

		surface.SetDrawColor(coloro)
		surface.DrawOutlinedRect(x - 2, y, w + 4, h)
	end
end

local function DrawRotated(x, y, w, h, texture, color, rot)
	texture = texture or icons.white
	if color then
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
	else
		surface.SetDrawColor(255, 255, 255, 255)
	end

	surface.SetMaterial(texture)
	surface.DrawTexturedRectRotated(x - 2, y, w + 4, h, rot)
end

local function GetTTextSize(text, font)
	font = font or "Default"
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text or "")
	return w, h
end

local function DrawTOutlinedText(x, y, text, font, color, back, texture, coloro)
	texture = texture or icons.white
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text or "")
	if back == true then
		surface.SetDrawColor(coloro.r, coloro.g, coloro.b, coloro.a)
		surface.SetMaterial(texture)
		surface.DrawTexturedRect(x - 2, y, w + 4, h)
	end

	draw.SimpleText(text, font, x, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	return w, h
end

local function can_wanted(ply)
	return ply:getJobTable().can_see_visor_detailed_info
end

local color_outline100 = Color(0, 0, 0, 100)
local color_outline150 = Color(0, 0, 0, 150)
local color_outline255 = Color(0, 0, 0, 255)
local color_200white = Color(200, 200, 200)
local color_white10 = Color(255, 255, 255, 10)
local visor_text_size = 16
local box_size1 = visor_text_size * 12
local box_size2 = visor_text_size * 8
local box_size3 = visor_text_size * 5
function nameplates.DrawVisor(ply, pos, cache)
	local lp = LocalPlayer()
	local presentAngle = (CurTime() * 90) % 360

	local mat = cache.mat
	local text = cache.text
	local status = cache.status
	local must = cache.must
	local name = cache.name
	local id = cache.id
	local main = cache.main
	local w, h = cache.w, cache.h
	local box_w = cache.box_w


	nameplates.DrawNameplate({
		ent = ply,
		position = pos,
		angle = lp:GetAngles(),
		maxDistance = 256,
		lookCenter = ply:LocalToWorld(ply:OBBCenter() + Vector(0, 0, 10)),
		aimThreshold = math.pi / 6,
		func = function(uiSize)
			DrawRotated(0, 32, 128, 128, mat, nil, presentAngle)
			local xbase, ybase = 100, 50
			local stndx, stndy = xbase, ybase
			DrawTOutlinedRect(xbase, ybase, box_w, box_size2, icons.scan, true, nil, color_outline100)
			DrawTOutlinedRect(xbase, ybase, box_w, box_size2, icons.white, false, color_outline100)
			ybase = ybase - h + 2
			DrawTOutlinedRect(xbase, ybase, w, h, icons.white, false, color_outline150)
			DrawTOutlinedText(xbase, ybase, text, fonts.big, main, true, icons.scan, color_outline255)
			------------- Inside Box stuff ---------
			xbase, ybase = stndx, stndy
			xbase = xbase + 2
			ybase = ybase + 2
			DrawTOutlinedRect(xbase, ybase, box_w - 4, box_size3, nil, false, color_white10)
			ybase = ybase + 2
			w, h = DrawTOutlinedText(xbase, ybase, "ИМЯ: ", fonts.medium, color_200white, false)
			DrawTOutlinedText(xbase + w, ybase, name, fonts.medium, color_200white, true, icons.white, color_outline255)
			ybase = ybase + h + 2
			w, h = DrawTOutlinedText(xbase, ybase, "CID: ", fonts.medium, color_200white, false)
			DrawTOutlinedText(xbase + w, ybase, "#" .. id, fonts.medium, color_200white)
			ybase = ybase + h + 2
			w, h = DrawTOutlinedText(xbase, ybase, "СТАТУС: ", fonts.medium, color_200white, false)
			DrawTOutlinedText(xbase + w, ybase, status, fonts.medium, color_200white)
			xbase = stndx + 2
			ybase = ybase + h * 2
			w, h = DrawTOutlinedText(xbase, ybase, "СОВЕТ: ", fonts.medium, color_200white, false)
			DrawTOutlinedText(xbase + w, ybase, must, fonts.medium, color_white, true, icons.white, main)
		end
	})
end

local fixTeam = {
	[TEAM_CREMATOR] = Vector(0, 0, 4),
}
if TEAM_JEFF then
	fixTeam[TEAM_JEFF] = Vector(0, 0, -4)
end

local function OTAVisor(ply, cache)
	local lply = LocalPlayer()
	local head = ply:LookupBone("ValveBiped.Bip01_Head1")
	local plypos, eyepos = ply:GetPos(), ply:EyePos()
	local pos = head and ply:GetBonePosition(head) or eyepos
	local diff = (lply:GetPos() - plypos):Angle()
	diff.p = 0
	diff.r = 0
	if head and pos == plypos then
		pos = eyepos + diff:Forward() * 5
	end
	pos = pos + diff:Forward() * 7
	local fixData = fixTeam[ply:Team()]
	if fixData then pos = pos + fixData end
	nameplates.DrawVisor(ply, pos, cache)
end
local player_targets = {}

hook.Add("PostDrawTranslucentRenderables", "Union::OTA::Visor", function(a, b, c)
	if a or b or c then return end
	for _, cache in ipairs(player_targets) do
		local ply = cache.ply
		if not IsValid(ply) then
			continue
		end
		OTAVisor(ply, cache)
	end
end)

timer.Create("Union::OTA::Visor", 1, 0, function()
	player_targets = {}
	local lp = LocalPlayer()
	if not IsValid(lp) then return end
	if not lp:isOTA() or not lp:Alive() then return end
	local can_see_wanted = can_wanted(lp)
	for _, ply in player.Iterator() do
		if lp == ply or not ply:Alive() then continue end
		if ply:GetNoDraw() or ply:IsDormant() then continue end

		local name = ply:Name()
		local cache = {
			ply = ply,
			name = name,
			id = ply:GetID(),
		}

		local status = ply:GetNetVar("Visor:Status", "НЕИЗВЕСТНО")
		local must = ply:GetNetVar("Visor:Advice", "НЕИЗВЕСТНО")
		local main = ply:GetNetVar("Visor:Color", col.o)
		local text = ply:GetNetVar("Visor:Text", "Гражданин")
		local wanted = ply:GetNetVar("Visor:Wanted")
		local icon = ply:GetNetVar("Visor:Material", 1)

		if wanted and can_see_wanted then
			status = wanted
			text = "СУБЪЕКТ"
			must = "ДОПРОС"
			main = col.o
			icon = 3
		end
		cache.mat = icons.crosshairs[icon]
		cache.text = text
		cache.status = status

		cache.must = must
		cache.main = main
		cache.icon = icon

		local name_text = "ИМЯ: " .. name
		local status_text = "СТАТУС: " .. status
		local name_w = GetTTextSize(name_text, fonts.medium)
		cache.name_w = name_w
		local status_w = GetTTextSize(status_text, fonts.medium)
		cache.status_w = status_w
		cache.w, cache.h = GetTTextSize(text, fonts.big)

		cache.box_w = math.max(name_w + visor_text_size, box_size1, status_w + visor_text_size)

		table.insert(player_targets, cache)
	end
end)
hook.Remove("RenderScreenspaceEffects", "RenderColorModify")