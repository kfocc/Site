local print = print
local Color = Color
local GetConVar = GetConVar
local debug_getinfo = debug.getinfo
local hook_Add = hook.Add
local util_TraceLine = util.TraceLine
local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local math_min = math.min
local math_Remap = math.Remap
local util_AimVector = util.AimVector
local util_IntersectRayWithPlane = util.IntersectRayWithPlane
local SysTime = SysTime
local Vector = Vector
local math_max = math.max
local unpack = unpack
local debug_traceback = debug.traceback
local string_format = string.format
local string_byte = string.byte
local tonumber = tonumber
local math_ceil = math.ceil
local math_floor = math.floor
local math_pi = math.pi
local math_atan = math.atan
local math_tan = math.tan
local render_GetRenderTarget = CLIENT and render.GetRenderTarget
local vgui_CursorVisible = CLIENT and vgui.CursorVisible
local vgui_GetHoveredPanel = CLIENT and vgui.GetHoveredPanel
local input_LookupBinding = CLIENT and input.LookupBinding
local input_GetKeyCode = CLIENT and input.GetKeyCode
local input_IsButtonDown = CLIENT and input.IsButtonDown
local input_IsMouseDown = CLIENT and input.IsMouseDown
local render_SetBlend = CLIENT and render.SetBlend
local surface_SetAlphaMultiplier = CLIENT and surface.SetAlphaMultiplier
local cam_Start3D2D = CLIENT and cam.Start3D2D
local vgui_IsHoveringWorld = CLIENT and vgui.IsHoveringWorld
local input_GetCursorPos = CLIENT and input.GetCursorPos
local cam_End3D2D = CLIENT and cam.End3D2D
local render_DrawWireframeBox = CLIENT and render.DrawWireframeBox
local draw_SimpleText = CLIENT and draw.SimpleText
local cam_IgnoreZ = CLIENT and cam.IgnoreZ
local surface_SetDrawColor = CLIENT and surface.SetDrawColor
local surface_DrawRect = CLIENT and surface.DrawRect
local surface_DrawLine = CLIENT and surface.DrawLine
local surface_CreateFont = CLIENT and surface.CreateFont
-- print("IMGUI INITIALIZED")
local imgui = {}
imgui.skin = {
	background = Color(0, 0, 0, 0),
	backgroundHover = Color(0, 0, 0, 0),
	border = Color(255, 255, 255),
	borderHover = Color(255, 127, 0),
	borderPress = Color(255, 80, 0),
	foreground = Color(255, 255, 255),
	foregroundHover = Color(255, 127, 0),
	foregroundPress = Color(255, 80, 0),
}

local devCvar = GetConVar("developer")
function imgui.IsDeveloperMode()
	return not imgui.DisableDeveloperMode and devCvar:GetInt() > 0
end

local _devMode = false -- cached local variable updated once in a while
local hookUniqifier = debug_getinfo(3).short_src
function imgui.Hook(name, id, callback)
	hook_Add(name, "IMGUI / " .. id .. " / " .. hookUniqifier, callback)
end

local localPlayer
local isLocked
local gState = {}
timer.Create("imgui_cache_aimvector" .. hookUniqifier, 0, 0, function()
	if localPlayer and gState then
		local aimVector = localPlayer:GetAimVector()
		gState.aimVector = aimVector
		gState.aimVectorAngle = aimVector:Angle()
	end
end)

local function shouldAcceptInput()
	-- don't process input during non-main renderpass
	if render_GetRenderTarget() ~= nil then return false end
	if localPlayer then isLocked = localPlayer.isLocked end
	-- don't process input if we're doing VGUI stuff (and not in context menu)
	if not isLocked and vgui_CursorVisible() and vgui_GetHoveredPanel() ~= g_ContextMenu then return false end
	return true
end

imgui.Hook("PreRender", "Input", function()
	-- calculate mouse state
	if shouldAcceptInput() then
		local isUse = gState.isUse
		local wasPressing = gState.pressing
		gState.pressing = isUse and input_IsButtonDown(KEY_E) or not isUse and input_IsMouseDown(MOUSE_LEFT)
		gState.pressed = not wasPressing and gState.pressing
	end
end)

hook_Add("NotifyShouldTransmit", "IMGUI / ClearRenderBounds", function(ent, shouldTransmit) if shouldTransmit and ent._imguiRBExpansion then ent._imguiRBExpansion = nil end end)
local traceResultTable = {}
local traceQueryTable = {
	output = traceResultTable,
	filter = {}
}

local function isObstructed(eyePos, hitPos, ignoredEntity)
	local q = traceQueryTable
	q.start = eyePos
	q.endpos = hitPos
	q.filter[1] = localPlayer
	q.filter[2] = ignoredEntity
	local tr = util_TraceLine(q)
	if tr.Hit then
		return true, tr.Entity
	else
		return false
	end
end

local fovCvar = GetConVar("fov_desired")
local function fovFix(fov, ratio)
	fov = fov or fovCvar:GetInt()
	ratio = ratio or ScrW() / ScrH()
	return (math_atan(math_tan((fov * math_pi) / 360) * (ratio / (4 / 3))) * 360) / math_pi
end

function imgui.Start3D2D(pos, angles, scale, distanceHide, distanceFadeStart, isUse, fov)
	if not IsValid(localPlayer) then localPlayer = LocalPlayer() end
	if not gState.fov then gState.fov = fovFix(fov) end
	if not gState.scrW then
		gState.scrW = ScrW()
		gState.scrH = ScrH()
	end

	if not gState.aimVector then
		local aimVector = localPlayer:GetAimVector()
		gState.aimVector = aimVector
		gState.aimVectorAngle = aimVector:Angle()
	end

	if not gState.isUse then gState.isUse = isUse end
	if gState.shutdown == true then return end
	if gState.rendering == true then
		print("[IMGUI] Starting a new IMGUI context when previous one is still rendering" .. "Shutting down rendering pipeline to prevent crashes..")
		gState.shutdown = true
		return false
	end

	_devMode = imgui.IsDeveloperMode()
	local eyePos = localPlayer:EyePos()
	local eyePosToPos = pos - eyePos
	-- OPTIMIZATION: Test that we are in front of the UI
	do
		local normal = angles:Up()
		local dot = eyePosToPos:Dot(normal)
		if _devMode then gState._devDot = dot end
		-- since normal is pointing away from surface towards viewer, dot<0 is visible
		if dot >= 0 then return false end
	end

	-- OPTIMIZATION: Distance based fade/hide
	if distanceHide then
		local distance = eyePosToPos:Length()
		if distance > distanceHide then return false end
		if _devMode then
			gState._devDist = distance
			gState._devHideDist = distanceHide
		end

		if distanceHide and distanceFadeStart and distance > distanceFadeStart then
			local blend = math_min(math_Remap(distance, distanceFadeStart, distanceHide, 1, 0), 1)
			render_SetBlend(blend)
			surface_SetAlphaMultiplier(blend)
		end
	end

	gState.rendering = true
	gState.pos = pos
	gState.angles = angles
	gState.scale = scale
	cam_Start3D2D(pos, angles, scale)
	-- calculate mousepos
	if not vgui_CursorVisible() or vgui_IsHoveringWorld() then
		local tr = localPlayer:GetEyeTrace()
		local eyepos = tr.StartPos
		local eyenormal
		if isLocked or vgui_CursorVisible() and vgui_IsHoveringWorld() then
			local x, y = input_GetCursorPos()
			eyenormal = util_AimVector(gState.aimVectorAngle, gState.fov, x, y, gState.scrW, gState.scrH)
		else
			eyenormal = tr.Normal
		end

		local planeNormal = angles:Up()
		local hitPos = util_IntersectRayWithPlane(eyepos, eyenormal, pos, planeNormal)
		if hitPos then
			local obstructed, obstructer = isObstructed(eyepos, hitPos, gState.entity)
			if obstructed then
				gState.mx = nil
				gState.my = nil
				if _devMode then gState._devInputBlocker = "collision " .. obstructer:GetClass() .. "/" .. obstructer:EntIndex() end
			else
				local diff = pos - hitPos
				-- This cool code is from Willox's keypad CalculateCursorPos
				local x = diff:Dot(-angles:Forward()) / scale
				local y = diff:Dot(-angles:Right()) / scale
				gState.mx = x
				gState.my = y
			end
		else
			gState.mx = nil
			gState.my = nil
			if _devMode then gState._devInputBlocker = "not looking at plane" end
		end
	else
		gState.mx = nil
		gState.my = nil
		if _devMode then gState._devInputBlocker = "not hovering world" end
	end

	if _devMode then gState._renderStarted = SysTime() end
	return true
end

function imgui.Entity3D2D(ent, lpos, lang, scale, ...)
	gState.entity = ent
	local ret = imgui.Start3D2D(ent:LocalToWorld(lpos), ent:LocalToWorldAngles(lang), scale, ...)
	if not ret then gState.entity = nil end
	return ret
end

local function calculateRenderBounds(x, y, w, h)
	local pos = gState.pos
	local fwd, right = gState.angles:Forward(), gState.angles:Right()
	local scale = gState.scale
	local firstCorner, secondCorner = pos + fwd * x * scale + right * y * scale, pos + fwd * (x + w) * scale + right * (y + h) * scale
	local minrb, maxrb = Vector(math.huge, math.huge, math.huge), Vector(-math.huge, -math.huge, -math.huge)
	minrb.x = math_min(minrb.x, firstCorner.x, secondCorner.x)
	minrb.y = math_min(minrb.y, firstCorner.y, secondCorner.y)
	minrb.z = math_min(minrb.z, firstCorner.z, secondCorner.z)
	maxrb.x = math_max(maxrb.x, firstCorner.x, secondCorner.x)
	maxrb.y = math_max(maxrb.y, firstCorner.y, secondCorner.y)
	maxrb.z = math_max(maxrb.z, firstCorner.z, secondCorner.z)
	return minrb, maxrb
end

function imgui.ExpandRenderBoundsFromRect(x, y, w, h)
	local ent = gState.entity
	if IsValid(ent) then
		-- make sure we're not applying same expansion twice
		local expansion = ent._imguiRBExpansion
		if expansion then
			local ex, ey, ew, eh = unpack(expansion)
			if ex == x and ey == y and ew == w and eh == h then return end
		end

		local minrb, maxrb = calculateRenderBounds(x, y, w, h)
		ent:SetRenderBoundsWS(minrb, maxrb)
		if _devMode then print("[IMGUI] Updated renderbounds of ", ent, " to ", minrb, "x", maxrb) end
		ent._imguiRBExpansion = {x, y, w, h}
	else
		if _devMode then print("[IMGUI] Attempted to update renderbounds when entity is not valid!! ", debug_traceback()) end
	end
end

local devOffset = Vector(0, 0, 30)
local devColours = {
	background = Color(0, 0, 0, 200),
	title = Color(78, 205, 196),
	mouseHovered = Color(0, 255, 0),
	mouseUnhovered = Color(255, 0, 0),
	pos = Color(255, 255, 255),
	distance = Color(200, 200, 200, 200),
	ang = Color(255, 255, 255),
	dot = Color(200, 200, 200, 200),
	angleToEye = Color(200, 200, 200, 200),
	renderTime = Color(255, 255, 255),
	renderBounds = Color(0, 0, 255)
}

local function developerText(str, x, y, clr)
	draw_SimpleText(str, "DefaultFixedDropShadow", x, y, clr, TEXT_ALIGN_CENTER, nil)
end

local function drawDeveloperInfo()
	local camAng = localPlayer:EyeAngles()
	camAng:RotateAroundAxis(camAng:Right(), 90)
	camAng:RotateAroundAxis(camAng:Up(), -90)
	cam_IgnoreZ(true)
	cam_Start3D2D(gState.pos + devOffset, camAng, 0.15)
	local bgCol = devColours["background"]
	surface_SetDrawColor(bgCol.r, bgCol.g, bgCol.b, bgCol.a)
	surface_DrawRect(-100, 0, 200, 140)
	local titleCol = devColours["title"]
	developerText("imgui developer", 0, 5, titleCol)
	surface_SetDrawColor(titleCol.r, titleCol.g, titleCol.b)
	surface_DrawLine(-50, 16, 50, 16)
	local mx, my = gState.mx, gState.my
	if mx and my then
		developerText(string_format("mouse: hovering %d x %d", mx, my), 0, 20, devColours["mouseHovered"])
	else
		developerText(string_format("mouse: %s", gState._devInputBlocker or ""), 0, 20, devColours["mouseUnhovered"])
	end

	local pos = gState.pos
	developerText(string_format("pos: %.2f %.2f %.2f", pos.x, pos.y, pos.z), 0, 40, devColours["pos"])
	developerText(string_format("distance %.2f / %.2f", gState._devDist or 0, gState._devHideDist or 0), 0, 53, devColours["distance"])
	local ang = gState.angles
	developerText(string_format("ang: %.2f %.2f %.2f", ang.p, ang.y, ang.r), 0, 75, devColours["ang"])
	developerText(string_format("dot %d", gState._devDot or 0), 0, 88, devColours["dot"])
	local angToEye = (pos - localPlayer:EyePos()):Angle()
	angToEye:RotateAroundAxis(ang:Up(), -90)
	angToEye:RotateAroundAxis(ang:Right(), 90)
	developerText(string_format("angle to eye (%d,%d,%d)", angToEye.p, angToEye.y, angToEye.r), 0, 100, devColours["angleToEye"])
	developerText(string_format("rendertime avg: %.2fms", (gState._devBenchAveraged or 0) * 1000), 0, 120, devColours["renderTime"])
	cam_End3D2D()
	cam_IgnoreZ(false)
	local ent = gState.entity
	if IsValid(ent) and ent._imguiRBExpansion then
		local ex, ey, ew, eh = unpack(ent._imguiRBExpansion)
		local minrb, maxrb = calculateRenderBounds(ex, ey, ew, eh)
		render_DrawWireframeBox(vector_origin, angle_zero, minrb, maxrb, devColours["renderBounds"])
	end
end

function imgui.End3D2D()
	if gState then
		if _devMode then
			local renderTook = SysTime() - gState._renderStarted
			gState._devBenchTests = (gState._devBenchTests or 0) + 1
			gState._devBenchTaken = (gState._devBenchTaken or 0) + renderTook
			if gState._devBenchTests == 100 then
				gState._devBenchAveraged = gState._devBenchTaken / 100
				gState._devBenchTests = 0
				gState._devBenchTaken = 0
			end
		end

		gState.rendering = false
		cam_End3D2D()
		render_SetBlend(1)
		surface_SetAlphaMultiplier(1)
		if _devMode then drawDeveloperInfo() end
		gState.entity = nil
	end
end

function imgui.CursorPos()
	local mx, my = gState.mx, gState.my
	return mx, my
end

function imgui.IsHovering(x, y, w, h)
	local mx, my = gState.mx, gState.my
	return mx and my and mx >= x and mx <= x + w and my >= y and my <= y + h
end

function imgui.IsPressing()
	return shouldAcceptInput() and gState.pressing
end

function imgui.IsPressed()
	return shouldAcceptInput() and gState.pressed
end

-- String->Bool mappings for whether font has been created
local _createdFonts = {}
-- Cached IMGUIFontNamd->GModFontName
local _imguiFontToGmodFont = {}
local EXCLAMATION_BYTE = string_byte("!")
function imgui.xFont(font, defaultSize)
	-- special font
	if string_byte(font, 1) == EXCLAMATION_BYTE then
		local existingGFont = _imguiFontToGmodFont[font]
		if existingGFont then return existingGFont end
		-- Font not cached; parse the font
		local name, size = font:match("!([^@]+)@(.+)")
		if size then size = tonumber(size) end
		if not size and defaultSize then
			name = font:match("^!([^@]+)$")
			size = defaultSize
		end

		local fontName = string_format("IMGUI_%s_%d", name, size)
		_imguiFontToGmodFont[font] = fontName
		if not _createdFonts[fontName] then
			surface_CreateFont(fontName, {
				font = name,
				size = size,
				extended = true
			})

			_createdFonts[fontName] = true
		end
		return fontName
	end
	return font
end

function imgui.xButton(x, y, w, h, borderWidth, borderClr, hoverClr, pressColor)
	local bw = borderWidth or 1
	local bgColor = imgui.IsHovering(x, y, w, h) and imgui.skin.backgroundHover or imgui.skin.background
	local borderColor = (imgui.IsPressing() and imgui.IsHovering(x, y, w, h)) and (pressColor or imgui.skin.borderPress) or imgui.IsHovering(x, y, w, h) and (hoverClr or imgui.skin.borderHover) or (borderClr or imgui.skin.border)
	surface_SetDrawColor(bgColor)
	surface_DrawRect(x, y, w, h)
	if bw > 0 then
		surface_SetDrawColor(borderColor)
		surface_DrawRect(x, y + 1, w, bw)
		surface_DrawRect(x, y + bw + 1, bw, h - bw * 2)
		surface_DrawRect(x, y + h - bw + 1, w, bw)
		surface_DrawRect(x + w - bw, y + bw + 1, bw, h - bw * 2)
	end
	return shouldAcceptInput() and imgui.IsHovering(x, y, w, h) and gState.pressed
end

function imgui.xCursor(x, y, w, h)
	local fgColor = imgui.IsPressing() and imgui.skin.foregroundPress or imgui.skin.foreground
	local mx, my = gState.mx, gState.my
	if not mx or not my then return end
	if x and w and (mx < x or mx > x + w) then return end
	if y and h and (my < y or my > y + h) then return end
	local cursorSize = math_ceil(0.3 / gState.scale)
	surface_SetDrawColor(fgColor)
	surface_DrawLine(mx - cursorSize, my, mx + cursorSize, my)
	surface_DrawLine(mx, my - cursorSize, mx, my + cursorSize)
end

function imgui.xTextButton(text, font, x, y, w, h, borderWidth, color, hoverClr, pressColor)
	local fgColor = (imgui.IsPressing() and imgui.IsHovering(x, y, w, h)) and (pressColor or imgui.skin.foregroundPress) or imgui.IsHovering(x, y, w, h) and (hoverClr or imgui.skin.foregroundHover) or (color or imgui.skin.foreground)
	local clicked = imgui.xButton(x, y, w, h, borderWidth, color, hoverClr, pressColor)
	font = imgui.xFont(font, math_floor(h * 0.618))
	draw_SimpleText(text, font, x + w / 2, y + h / 2, fgColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	return clicked
end

local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_drawGradientBox = surface.drawGradientBox
local color_red = Color(255, 0, 0):lighten(100)
local emptyColor = {Color(), Color()}
function imgui.drawGradientBorderRect(x, y, w, h, gradientColor, borderWidth, borderColor)
	local bw = borderWidth or 0
	if IsColor(gradientColor) then
		emptyColor[1] = gradientColor
		emptyColor[2] = gradientColor
		gradientColor = emptyColor
	end

	surface_drawGradientBox(x, y, w, h, 1, unpack(gradientColor))
	if bw > 0 then
		borderColor = borderColor or color_white
		surface_SetDrawColor(borderColor)
		surface_DrawRect(x, y + 1, w, bw)
		surface_DrawRect(x, y + bw + 1, bw, h - bw * 2)
		surface_DrawRect(x, y + h - bw + 1, w, bw)
		surface_DrawRect(x + w - bw, y + bw + 1, bw, h - bw * 2)
	end
end

function imgui.drawBorderRect(x, y, w, h, mainColor, borderWidth, borderColor)
	local bw = borderWidth or 0
	surface_SetDrawColor(mainColor.r, mainColor.g, mainColor.b, mainColor.a)
	surface_DrawRect(x, y, w, h)
	if bw > 0 then
		borderColor = borderColor or color_white
		surface_SetDrawColor(borderColor)
		surface_DrawRect(x, y + 1, w, bw)
		surface_DrawRect(x, y + bw + 1, bw, h - bw * 2)
		surface_DrawRect(x, y + h - bw + 1, w, bw)
		surface_DrawRect(x + w - bw, y + bw + 1, bw, h - bw * 2)
	end
end

function imgui.drawBorderButton(x, y, w, h, color, borderWidth, borderColor, borderHoverColor)
	local isHovering = imgui.IsHovering(x, y, w, h)
	local isPressed = imgui.IsPressed()
	if color then
		local isPressing = imgui.IsPressing()
		if isPressing and isHovering then
			borderColor = color_red
		elseif borderHoverColor and isHovering then
			borderColor = borderHoverColor
		end

		imgui.drawBorderRect(x, y, w, h, color, borderWidth, borderColor)
	end
	return isHovering and isPressed
end

function imgui.drawBorderButtonIcon(x, y, w, h, iconMat, iconColor, color, borderWidth, borderColor, borderHoverColor)
	iconColor = iconColor or color_white
	local pressed = imgui.drawBorderButton(x, y, w, h, color, borderWidth, borderColor, borderHoverColor)
	surface_SetDrawColor(iconColor.r, iconColor.g, iconColor.b, iconColor.a)
	surface_SetMaterial(iconMat)
	surface_DrawTexturedRect(x, y, w, h)
	return pressed
end

function imgui.drawBorderButtonText(text, font, x, y, w, h, textColor, color, borderWidth, borderColor, borderHoverColor)
	if not text or not isstring(text) then return end
	if not font or not isstring(font) then return end
	font = imgui.xFont(font)
	textColor = textColor or color_white
	local pressed = imgui.drawBorderButton(x, y, w, h, color, borderWidth, borderColor, borderHoverColor)
	draw_SimpleText(text, font, x + w / 2, y + h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	return pressed
end

function imgui.drawGradientBorderButton(x, y, w, h, color, borderWidth, borderColor, borderHoverColor)
	local bw = borderWidth or 0
	local isHovering = imgui.IsHovering(x, y, w, h)
	local isPressed = imgui.IsPressed()
	local newColor
	if color then
		local isPressing = imgui.IsPressing()
		if isPressing and isHovering then
			if bw > 0 and borderHoverColor then borderColor = color_red end
			newColor = newColor or {}
			for k, v in ipairs(color) do
				newColor[k] = v:darken(25)
			end
		elseif isHovering then
			if bw > 0 and borderHoverColor then borderColor = borderHoverColor end
			newColor = newColor or {}
			for k, v in ipairs(color) do
				newColor[k] = v:lighten(25)
			end
		end

		imgui.drawGradientBorderRect(x, y, w, h, newColor or color, borderWidth, borderColor)
	end
	return isHovering and isPressed
end

function imgui.drawGradientBorderButtonText(text, font, x, y, w, h, textColor, color, borderWidth, borderColor, borderHoverColor)
	if not text or not isstring(text) then return end
	if not font or not isstring(font) then return end
	font = imgui.xFont(font)
	textColor = textColor or color_white
	local pressed = imgui.drawGradientBorderButton(x, y, w, h, color, borderWidth, borderColor, borderHoverColor)
	draw_SimpleText(text, font, x + w / 2, y + h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	return pressed
end
return imgui
