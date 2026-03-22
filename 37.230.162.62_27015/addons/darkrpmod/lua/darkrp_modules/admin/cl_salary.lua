local include = include
local Material = Material
local Color = Color
local Vector = Vector
local Angle = Angle
local LocalPlayer = LocalPlayer
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local CurTime = CurTime
local string_FormattedTime = string.FormattedTime
local netstream = netstream
local netstream_Start = netstream.Start

local DarkRP = DarkRP
local DarkRP_formatMoney = DarkRP.formatMoney

local imgui = include("lib/client/imgui.lua")
local imgui_Start3D2D = imgui.Start3D2D
local imgui_xFont = imgui.xFont
local imgui_End3D2D = imgui.End3D2D
local imgui_drawBorderRect = imgui.drawBorderRect
local imgui_drawGradientBorderRect = imgui.drawGradientBorderRect
local imgui_drawGradientBorderButtonText = imgui.drawGradientBorderButtonText

local ranknames = {
	["operator_nabor"] = {
		name = "[Н] Оператор",
		icon = Material("icon16/medal_bronze_2.png")
	},
	["moderator_nabor"] = {
		name = "[Н] Модератор",
		icon = Material("icon16/medal_silver_2.png")
	},
	["administrator_nabor"] = {
		name = "[Н] Администратор",
		icon = Material("icon16/medal_gold_2.png")
	},
	["head_admin_nabor"] = {
		name = "[Н] Смотритель",
		icon = Material("icon16/award_star_bronze_2.png")
	},
	["advisor_nabor"] = {
		name = "Advisor",
		icon = Material("icon16/award_star_silver_2.png")
	},
	["event_boss_nabor"] = {
		name = "Гл. Ивентолог",
		icon = Material("icon16/controller.png")
	},
	["event_nabor"] = {
		name = "Ивентолог",
		icon = Material("icon16/controller.png")
	},
	["assistant_nabor"] = {
		name = "Assistant",
		icon = Material("icon16/award_star_gold_2.png")
	},
	["overwatch"] = {
		name = "OverWatch",
		icon = Material("icon16/shield.png")
	},
	["superadmin"] = {
		name = "Велоцираптор",
		icon = Material("icon16/ruby.png")
	}
}

local color_white = color_white
local color_semiblack = Color(0, 0, 0, 75)
local color_blue = Color(132, 192, 222)
local color_blue2 = color_blue:darken(150)
local color_blue3 = color_blue:darken(100)
local color_lightgreen = Color(85, 255, 85)
local color_green = Color(0, 134, 0)

local color_orange = Color(255, 126, 20)
local color_orange2 = color_orange:darken(150)

local green_gradient = {color_lightgreen, color_green}
local blue_gradient2 = {color_blue2, color_blue, color_blue, color_blue, color_blue3, color_blue2}
-- local blue_gradient3 = {color_blue, color_blue2}
local blue_gradient4 = {color_blue2, color_blue}

local orange_gradient = {color_orange, color_orange2}

local vec = Vector(-2638, 7827, 5832)
local ang = Angle(0, 270, 90)
local selfCoolDown = 0
local function PostDrawTranslucentRenderables(bDrawingSkybox, bDrawingDepth, c)
	if bDrawingSkybox or bDrawingDepth or c then return end

	local localPlayer = LocalPlayer()
	if not localPlayer:IsNabor() or localPlayer:Team() ~= TEAM_ADMIN then return end

	if imgui_Start3D2D(vec, ang, 0.1, 450, 400, true) then

		local maxX, maxY = 650, 700
		surface_SetDrawColor(15, 15, 15, 155)
		surface_DrawRect(0, 0, maxX, maxY)

		imgui_drawBorderRect(0, 0, maxX, maxY, color_semiblack, 2, col.o)

		imgui_drawGradientBorderRect(10, 10, 630, 155, blue_gradient4, 3, col.ba)

		local _money = DarkRP_formatMoney(localPlayer:GetLocalVar("admin.Salary", 0))
		draw_SimpleText(_money, imgui_xFont("!Roboto@75"), 325, 50, color_white, TEXT_ALIGN_CENTER)

		imgui_drawGradientBorderRect(10, 175, 630, 360, blue_gradient2, 3, col.ba)

		local group = localPlayer:GetUserGroup()
		local info = ranknames[group]
		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(info.icon)
		surface_DrawTexturedRect(293, 200, 64, 64)

		draw_SimpleText(info.name, imgui_xFont("!Roboto@75"), 325, 260, color_white, TEXT_ALIGN_CENTER)

		surface_SetDrawColor(col.ba)
		surface_DrawRect(10, 355, 630, 5)

		draw_SimpleText("Время администрирования:", imgui_xFont("!Roboto@50"), 325, 390, color_white, TEXT_ALIGN_CENTER)

		local time = CurTime() - localPlayer:GetLocalVar("admin.SalaryBecome", CurTime())
		local adminTime = string_FormattedTime(time, "%02i:%02i")
		draw_SimpleText(adminTime, imgui_xFont("!Roboto@50"), 325, 455, color_white, TEXT_ALIGN_CENTER)

		local bPressed = imgui_drawGradientBorderButtonText("ПОЛУЧИТЬ", "!Roboto@75", 10, 545, 630, 145, color_white, orange_gradient, 3, col.ba)
		if bPressed and not coolDown and selfCoolDown <= CurTime() then
			selfCoolDown = CurTime() + 5
			netstream_Start("admin.WithdrawSalary")
		end

		if selfCoolDown >= CurTime() then
			local percent = 624 * ((selfCoolDown - CurTime()) / 5)
			imgui_drawGradientBorderRect(13, 667, percent, 20, green_gradient, 3, col.ba)
		end

		imgui_End3D2D()
	end
end

hook.Add("OnPlayerChangedTeam", "PaintIMGUI", function(ply, old, new)
	if ply ~= LocalPlayer() then return end
	if new == TEAM_ADMIN then
		hook.Add("PostDrawTranslucentRenderables", "PaintIMGUI", PostDrawTranslucentRenderables)
	elseif old == TEAM_ADMIN then
		hook.Remove("PostDrawTranslucentRenderables", "PaintIMGUI")
	end
end)
