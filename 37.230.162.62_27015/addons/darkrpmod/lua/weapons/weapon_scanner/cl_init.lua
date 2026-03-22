include("shared.lua")

local ss = util.ScreenScale
surface.CreateFont("weaponCheckerFont", {
	font = "Inter",
	extended = true,
	size = ss(15),
})

local color_black = Color(15, 15, 15)
local function drawShadowText(text, font, x, y, color, align1, align2)
	local w, h = draw.SimpleText(text, font, x, y, color_black, align1, align2)
	draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
	return w, h
end

local stencil = "[ %s ] - %s"
local stepW, stepH, stepY = ss(15), ss(25), ss(10)
function SWEP:DrawHUD()
	local w = ScrW() - stepW
	local h = ScrH() - stepH
	local _, y = drawShadowText(stencil:format("ЛКМ", "проверка на оружие"), "weaponCheckerFont", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	h = h - y - stepY

	local use1 = self:GetLastUseL() or 0
	if use1 > CurTime() then
		local time = stencil:format("ЛКМ", "перезарядится через " .. math.Round(use1 - CurTime()) .. " c")
		_, y = drawShadowText(time, "weaponCheckerFont", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() return end

local function wepsToName(arr)
	local str = ""
	local ml = #arr
	if ml > 0 then
		for k, v in ipairs(arr) do
			local wep = weapons.Get(v)
			local name = wep and (wep.PrintName or wep.Name) or language.GetPhrase(v)
			str = str .. name
			if ml ~= k then
				str = str .. ", "
			else
				str = str .. "."
			end
		end
	else
		str = str .. "Пусто."
	end

	return str
end
netstream.Hook("weps:SendWeaponScanner", function(mapWeps, mapPocketWeps)
	chat.AddText(col.o, "\n[Проверка на оружие] ", col.ga, "Оружие в руках: ", col.w, wepsToName(mapWeps))
	chat.AddText(col.o, "[Проверка на оружие] ", col.ga, "Оружие в сумке: ", col.w, wepsToName(mapPocketWeps))
end)