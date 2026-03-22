zombie_event = zombie_event or {}
local sounds = {
	{"music/HL1_song10.mp3", 104},
	{"music/HL1_song14.mp3", 90},
	{"music/HL1_song15.mp3", 120},
	{"music/HL2_song1.mp3", 98},
	{"music/HL2_song12_long.mp3", 73},
	{"music/HL2_song14.mp3", 159},
	{"music/HL2_song15.mp3", 69},
	{"music/HL2_song16.mp3", 170},
	{"music/HL2_song20_submix0.mp3", 103},
	{"music/HL2_song20_submix4.mp3", 139},
	{"music/HL2_song25_Teleporter.mp3", 46},
	{"music/HL2_song3.mp3", 131}
}
function zombie_event.SoundQueue()
	if netvars.GetNetVar("zombie_event", false) then
		local event_start_time = netvars.GetNetVar("zombie_event_start", CurTime())
		math.randomseed(event_start_time)

		local snd = sounds[math.random(#sounds)]
		surface.PlaySound(snd[1])
		timer.Create("snd_timer_queue", snd[2], 1, function()
			zombie_event.SoundQueue()
		end)
	end
end

netstream.Hook("zombie.PlaySound", function(snd)
	if isstring(snd) then
		surface.PlaySound(snd)
	elseif istable(snd) then
		local time = 0
		for _, v in ipairs(snd) do
			timer.Simple(time, function() surface.PlaySound(v[1]) end)
			time = time + v[2]
		end
	else
		zombie_event.SoundQueue()
	end
end)

hook.Add("SetupWorldFog", "_zombie.EventFog", function()
	if not netvars.GetNetVar("zombie_event_sky", false) then return end

	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(500)
	render.FogMaxDensity(0.8)
	render.FogColor(240, 30, 30)
	return true
end)

hook.Add("SetupSkyboxFog", "_zombie.EventSkyBoxFog", function()
	if not netvars.GetNetVar("zombie_event_sky", false) then return end

	render.FogMode(1)
	render.FogStart(9999)
	render.FogEnd(500)
	render.FogMaxDensity(0.8)
	render.FogColor(240, 30, 30)
	return true
end)

local disallowKeypadJobs = {
	[TEAM_GMAN] = true,
	[TEAM_ADMIN] = true,
}
hook.Add("CanUseKeypad", "ZombieDisallowUseKeypad", function(ply)
	if disallowKeypadJobs[ply:Team()] or ply:isZombie() then
		return false
	end
end)
-- local tab = {
-- 	["$pp_colour_addr"] = 0,
-- 	["$pp_colour_addg"] = 0,
-- 	["$pp_colour_addb"] = 0,
-- 	["$pp_colour_brightness"] = 0.1,
-- 	["$pp_colour_contrast"] = 1,
-- 	["$pp_colour_colour"] = 1,
-- 	["$pp_colour_mulr"] = 0,
-- 	["$pp_colour_mulg"] = 0,
-- 	["$pp_colour_mulb"] = 0
-- }
-- local function zombie_night_vision()
-- 	if LocalPlayer():Team() == TEAM_ZOMB1 then
-- 		DrawColorModify(tab)
-- 	end
-- end
-- hook.Add("RenderScreenspaceEffects", "zombie.NightVision", zombie_night_vision)
local nvEnabled = CreateClientConVar("union_zombie_nv", 1, true, false)

local DynamicLight = DynamicLight
local EyePos = EyePos
local CurTime = CurTime
local DrawColorModify = DrawColorModify
local DrawBloom = DrawBloom

local bloomMultiply = 0.5
local bloomDarken = 0.5
local bloomBlur = 0.1
local bloomColorMul = 0.25
local bloomPasses = 1

if render.GetDXLevel() < 80 then alphaAdditive = 0.6 end

local colorTable = {
	["$pp_colour_addr"] = -1,
	["$pp_colour_addg"] = -0.4,
	["$pp_colour_addb"] = -1,
	["$pp_colour_brightness"] = 0.8,
	["$pp_colour_contrast"] = 2,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0.1,
	["$pp_colour_mulb"] = 0
}

local function ZombieNightVision()
	local lp = LocalPlayer()
	if not nvEnabled:GetBool() then return end
	if not lp:isZombie() then return end

	local dlight = DynamicLight(lp:EntIndex())
	dlight.brightness = 1
	dlight.Size = 500
	dlight.r = 255
	dlight.g = 255
	dlight.b = 255
	dlight.Decay = 1000
	dlight.pos = EyePos()
	dlight.DieTime = CurTime() + 0.1
	DrawColorModify(colorTable)
	DrawBloom(bloomDarken, bloomMultiply, bloomBlur, bloomBlur, bloomPasses, bloomColorMul, 0, 1, 0)
end
hook.Add("RenderScreenspaceEffects", "zombie.NightVision", ZombieNightVision)
