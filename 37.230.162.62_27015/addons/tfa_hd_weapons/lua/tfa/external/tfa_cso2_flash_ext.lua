cso2_flashtime = 5
cso2_flashfade = 2
cso2_flashdistance = 1000
cso2_flashdistancefade = 500

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.0,
	["$pp_colour_contrast"] = 1.0,
	["$pp_colour_colour"] = 1.0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "TFA_CSO2_FLASHBANG", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply.HasCheckedNW2 then
		ply.GetNW2Float = ply.GetNW2Float or ply.GetNWFloat
		ply.HasCheckedNW2 = true
	end
	local flashtime = ply:GetNW2Float("LastFlashCSO2", -999)
	local flashdistance = ply:GetNW2Float("FlashDistanceCSO2", 0)
	local flashfac = ply:GetNW2Float("FlashFactorCSO2", 1)
	local distancefac = 1 - math.Clamp((flashdistance - cso2_flashdistance + cso2_flashdistancefade) / cso2_flashdistancefade, 0, 1)
	local intensity = 1 - math.Clamp(((CurTime() - flashtime) / distancefac - cso2_flashtime + cso2_flashfade) / cso2_flashfade, 0, 1)
	intensity = intensity * distancefac
	intensity = intensity * math.Clamp(flashfac + 0.1, 0.35, 1)

	if intensity > 0.01 then
		tab["$pp_colour_brightness"] = math.pow(intensity, 3)
		tab["$pp_colour_colour"] = 1 - intensity * 0.33
		DrawColorModify(tab) --Draws Color Modify effect
		DrawMotionBlur(0.2, intensity, 0.03)
	end
end)