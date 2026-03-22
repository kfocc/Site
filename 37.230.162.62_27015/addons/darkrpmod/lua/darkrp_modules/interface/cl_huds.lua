local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local TS, swait = CurTime(), 0
hook.Add("RenderScreenspaceEffects", "DeathAgony", function()
	if not introPressed then return end
	local ply = LocalPlayer()
	if ply:Alive() then
		if TS > swait and ply:Health() < 50 then
			if ply:getGender() == "female" then
				ply:EmitSound("vo/npc/female01/pain0" .. math.random(1, 9) .. ".wav", 100, 100)
			elseif ply:getGender() == "male" then
				ply:EmitSound("vo/npc/male01/pain0" .. math.random(1, 9) .. ".wav", 100, 100)
			end

			swait = TS + math.random(10, 20)
		end
	else
		DrawColorModify(tab)
	end
end)

hook.Add("HUDPaint", "DeathAgony", function()
	if not introPressed and ESCMenu then
        local w, h = ScrW(), ScrH()
        ESCMenu.drawBackground(w, h)
        surface.SetAlphaMultiplier(0.8 ^ 2.2)
        tw, th = ESCMenu.drawLabel(utf8.upper("НАЖМИТЕ КЛАВИШУ ЧТОБЫ ПРОДОЛЖИТЬ"), "ESCMenuCrashscreenText", "ESCMenuCrashscreenTextBlur", w / 2, h * 0.72, col.w, 0.5, 0)
        surface.SetAlphaMultiplier(1)
        return
	end

	local ply = LocalPlayer()
	if not ply:Alive() then
		local resp_time = ply:GetNetVar("respawntime", 0)
		draw.SimpleText(resp_time > CurTime() and "Подождите " .. math.ceil(resp_time - CurTime()) .. " секунд" or "Нажмите клавишу для возрождения!", "UnionHUD30", ScrW() / 2, ScrH() / 2, col.w, TEXT_ALIGN_CENTER)
	end
end, HOOK_MONITOR_LOW)

hook.Add("RenderScreenspaceEffects", "BlurDrinking", function()
	local ply = LocalPlayer()
	if ply:Alive() and ply:GetNetVar("drinking", false) then DrawMotionBlur(0.1, 0.8, 0.01) end
end)
