local netvars_GetNetVar = netvars.GetNetVar
local surface_DrawRect = surface.DrawRect
local surface_DrawText = surface.DrawText
local surface_SetTextPos = surface.SetTextPos
local surface_SetMaterial = surface.SetMaterial
local surface_SetTextColor = surface.SetTextColor
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local string_FormattedTime = string.FormattedTime
local render_SetScissorRect = render.SetScissorRect
local LocalPlayer = LocalPlayer
local math_Clamp = math.Clamp
local math_fmod = math.fmod
local math_abs = math.abs
local math_sin = math.sin
local CurTime = CurTime
local surface = surface
local function DrawScrollingText(text, xxx, y, texwide)
	surface.SetFont("pd2_assault_text")
	local w = surface.GetTextSize(text)
	local x = math_fmod(CurTime() * 125, w) * -1
	while x < texwide do
		surface_SetTextPos(x + xxx, y)
		surface_DrawText(text)
		x = x + w
	end
end

local codeman = {
	["KK_Started"] = {
		text = "ОБЪЯВЛЕНА ТРЕВОГА: ВОЕННОЕ ПОЛОЖЕНИЕ.",
		time = 60,
		icon = Material("icon16/user.png"),
		color = col.r
	},
	["KK_Started_Oper"] = {
		text = "ОСОБОЕ ВНИМАНИЕ: БОЕВЫЕ ДЕЙСТВИЯ.",
		time = 0,
		icon = Material("icon16/user.png"),
		color = Color(200, 130, 30)
	},
	["YK_Started"] = {
		text = "Активный Желтый Код.",
		time = 120,
		icon = Material("icon16/user.png"),
		color = Color(255, 255, 0)
	},
	["YK_Started_Gath"] = {
		text = "Активный Желтый Код. Проследуйте на точку сбора: ",
		time = 120,
		icon = Material("icon16/user.png"),
		color = Color(255, 255, 0)
	},
	["DarkRP_LockDown"] = {
		text = "Активный Комендантский час.",
		time = 180,
		icon = Material("icon16/user.png"),
		color = Color(20, 20, 255)
	}
}

local moar_w = 230
local size = 230
hook.Add("HUDPaint", "Codes.Hud", function()
	local ply = LocalPlayer()
	local isOperation = netvars_GetNetVar("KK.IsOperation")
	local active = netvars_GetNetVar("KK_Started") and (isOperation and "KK_Started_Oper" or "KK_Started") or netvars_GetNetVar("YK_Started") and "YK_Started" or netvars_GetNetVar("DarkRP_LockDown") and "DarkRP_LockDown"
	if ply:Alive() and active then
		local height = draw.GetFontHeight("pd2_assault_text")
		local y = height
		local curtime = CurTime()
		local w, h = size * 1.5, ScrH()
		moar_w = math_Clamp(moar_w - 7.5, 0, 230)

		surface_SetDrawColor(255, 0, 0, 10 + math_abs(math_sin(curtime * 2)) * 45)
		surface_DrawRect(w - 310 + moar_w, y + 22, 265 - moar_w, 46)

		local color = codeman[active].color
		surface_SetTextColor(color.r, color.g, color.b)
		surface_DrawRect(w - 310 + moar_w, y + 65, 15, 3)
		surface_DrawRect(w - 310 + moar_w, y + 55, 3, 12)

		surface_DrawRect(w - 310 + moar_w, y + 22, 15, 3)
		surface_DrawRect(w - 310 + moar_w, y + 24, 3, 12)

		surface_DrawRect(w - 60, y + 65, 15, 3)
		surface_DrawRect(w - 48, y + 55, 3, 12)

		surface_DrawRect(w - 60, y + 22, 15, 3)
		surface_DrawRect(w - 48, y + 24, 3, 12)

		surface_DrawRect(12, y + 22, 20, 20)

		surface_SetDrawColor(0, 0, 0, 255)
		surface_SetMaterial(codeman[active].icon)
		surface_DrawTexturedRect(14, y + 24, 16, 16)

		if moar_w <= 0 then
			local isGathering = netvars_GetNetVar("YK.IsGathering")
			active = isGathering and "YK_Started_Gath" or active

			local text = codeman[active].text
			local homeTime = codeman[active].time + netvars_GetNetVar("DarkRP_CodeStartTime", 0)
			local endHomeTime = homeTime - curtime
			if endHomeTime >= 0 then
				if isGathering then
					text = text .. string_FormattedTime(endHomeTime, "%02i:%02i") .. "."
				else
					text = text .. " Проследуйте по домам: " .. string_FormattedTime(endHomeTime, "%02i:%02i") .. "."
				end
			end

			render_SetScissorRect(w - 310, y + 22, w - 45, y + 68, true)
			DrawScrollingText("///     " .. text .. "     ", w - 300, y + 30, 300)
			render_SetScissorRect(0, 0, 0, 0, false)
		end

		y = y + height + 25
	end
end)
