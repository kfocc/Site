local surface_GetTextureID = surface.GetTextureID
local LocalPlayer = LocalPlayer
local ScrW = ScrW
local ScrH = ScrH
local Color = Color
local CurTime = CurTime
local IsValid = IsValid
local tostring = tostring
local Material = Material
local FrameTime = FrameTime
local DrawColorModify = DrawColorModify
local math_random = math.random
local math_Approach = math.Approach
local math_Clamp = math.Clamp
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetTexture = surface.SetTexture
local surface_DrawTexturedRect = surface.DrawTexturedRect
local hook_Add = hook.Add
local surface_CreateFont = surface.CreateFont
local surface_SetMaterial = surface.SetMaterial

-- CreateClientConVar("lowhp_status", 1, true, true)

local intensity = 0
local swait, hpwait, hpalpha = 0, 0, 0
local vig = surface_GetTextureID("vgui/vignette_w")

local clr = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local crmSounds = {"amb_mad.wav", "alert_object.wav", "alert_player.wav",}
local function getSound()
	local lp = LocalPlayer()
	local lpTeam = lp:Team()
	if lpTeam == TEAM_CREMATOR then
		return crmSounds[math_random(#crmSounds)]
	elseif lpTeam == TEAM_BARNEY then
		return "vo/npc/Barney/ba_pain0" .. math_random(1, 9) .. ".wav"
	elseif lp:isOTA() then
		return "npc/combine_soldier/pain" .. math_random(1, 3) .. ".wav"
	elseif lp:isCP() then
		return "npc/metropolice/pain" .. math_random(1, 4) .. ".wav"
	elseif lp:isVort() then
		return "npc/alien_slave/vort_bm_pain0" .. math_random(1, 4) .. ".wav"
	elseif lpTeam == TEAM_STALKER then
		return "npc/combine_soldier/pain" .. math_random(1, 3) .. ".wav"
	elseif lp:isZombie() then
		return "npc/zombie/zombie_pain" .. math_random(1, 6) .. ".wav"
	else
		if lp:IsFemale() then
			return "vo/npc/female01/pain0" .. math_random(1, 9) .. ".wav"
		else
			return "vo/npc/male01/pain0" .. math_random(1, 9) .. ".wav"
		end
	end
end

local lowhpthreshold = 40
local function LowHP_HUDPaint()
	-- if GetConVarNumber("lowhp_status") <= 0 then return end
	local x, y = ScrW(), ScrH()
	local ply = LocalPlayer()
	local hp = ply:Health()
	local FT = FrameTime()
	if not ply:Alive() then return end

	local percent = ply:GetMaxHealth() * lowhpthreshold / 100
	intensity = math_Approach(intensity, 1 - math_Clamp(hp / percent, 0, 1), FT * 3)
	if intensity > 0 then
		local intensity = intensity * 2
		surface_SetDrawColor(0, 0, 0, 200 * intensity)
		surface_SetTexture(vig)
		surface_DrawTexturedRect(0, 0, x, y)

		clr["$pp_colour_colour"] = 1 - intensity
		DrawColorModify(clr)

		surface_SetDrawColor(255, 0, 0, (50 * intensity) * hpalpha)
		surface_DrawTexturedRect(0, 0, x, y)

		local CT = CurTime()
		local TS = CurTime()
		if CT > hpwait then
			ply:EmitSound("lowhp/hbeat.wav", 45 * intensity, 100 + 20 * intensity)
			hpwait = CT + 0.5
		end

		if CT < hpwait - 0.4 then
			hpalpha = math_Approach(hpalpha, 1, FrameTime() * 10)
		else
			hpalpha = math_Approach(hpalpha, 0.33, FrameTime() * 10)
		end

		if TS > swait and ply:Health() > 0 and ply:Health() < 20 then
			local getSound = getSound()
			if getSound then ply:EmitSound(getSound, 100, 100) end
			swait = TS + math_random(10, 20)
		end
	end
end
hook_Add("RenderScreenspaceEffects", "LowHP_HUDPaint", LowHP_HUDPaint)

surface_CreateFont("healthkitFont", {
	size = 14,
	weight = 900,
	extended = true,
	-- italic = true,
	font = "Lucida Console"
})

local function drawTexturedRect(posX, posY, width, height, icon, color)
	if not color then color = color_white end
	surface_SetDrawColor(color)
	surface_SetMaterial(icon)
	surface_DrawTexturedRect(posX, posY, width, height)
end

local maxDistance = 150 * 150
local stepY = 10
local iconHP, iconAP = Material("union/heart_full.png"), Material("union/1armor.png")
local coloHP, colorAP = Color(255, 100, 100), Color(0, 235, 235)
local infoHPColor, infoAPColor = Color(0, 0, 0), Color(0, 0, 0)
local whitelistWep = {
	["swep_vortigaunt_beam"] = true,
	["armor_kit_tech"] = true,
	["armor_kit"] = true,
	["med_kit"] = true,
	["weapon_medkit"] = true,
	["weapon_medkit_rebel"] = true,
	["weapon_medkit_low"] = true
}

local function calcucaltePercents(percent, color)
	local green = 255 * percent
	local red = 255 - green
	color.r = red
	color.g = green
	return color
end

local trEnt
timer.Create("checkEntityTrace", 0.2, 0, function()
	local pl = LocalPlayer()
	local getEyeTrace = pl.GetEyeTrace
	if not IsValid(pl) or not getEyeTrace then return end
	local tr = getEyeTrace(pl).Entity
	if IsValid(tr) then
		if tr ~= trEnt then trEnt = tr end
	else
		trEnt = nil
	end
end)

hook.Add("HUDPaint", "healthkit.DrawInfo", function()
	local ply = LocalPlayer()
	if not IsValid(trEnt) or not trEnt:IsPlayer() then return end
	local weapon = ply:GetActiveWeapon()
	if not IsValid(weapon) or not whitelistWep[weapon:GetClass()] then return end
	local dist = trEnt:GetPos():DistToSqr(ply:GetPos())
	if dist > maxDistance then return end
	local hp, ap = trEnt:Health(), trEnt:Armor()
	local maxHP, maxAP = trEnt:GetMaxHealth(), trEnt:GetMaxArmor()
	local posX, posY = ScrW() * 0.53, ScrH() * 0.5
	if maxAP == 0 then
		ap = 100
		maxAP = 100
	end

	local hpPercent = hp / maxHP
	local apPercent = ap / maxAP
	local textHPColor = calcucaltePercents(hpPercent, infoHPColor)
	local textAPColor = calcucaltePercents(apPercent, infoAPColor)
	hpPercent = math.floor(hpPercent * 100)
	apPercent = math.floor(apPercent * 100)
	local hp_text = hpPercent .. "%"
	local ap_text = apPercent .. "%"
	local _, y = draw.SimpleText(hp_text, "healthkitFont", posX, posY, textHPColor)
	drawTexturedRect(posX - 24, posY, 16, 16, iconHP, coloHP)
	posY = posY + y + stepY
	draw.SimpleText(ap_text, "healthkitFont", posX, posY, textAPColor)
	drawTexturedRect(posX - 24, posY, 16, 16, iconAP, colorAP)
end)
