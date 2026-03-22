local NULL = NULL
local pMeta = FindMetaTable("Player")
local IsAlive = pMeta.Alive
function pMeta:crm_SetModelScale(scale)
	if scale then
		local mat = Matrix()
		local x, y, z = scale.x, scale.y, scale.z
		mat:Scale(Vector(x, y, z))
		self:EnableMatrix("RenderMultiply", mat)
	else
		self:DisableMatrix("RenderMultiply")
	end
end

-- local function DrawName(ply)
--   if not IsValid(ply) then return end
--   -- if ply == LocalPlayer() then return end
--   if not ply:Alive() then return end
--   local dist = LocalPlayer():GetPos():DistToSqr(ply:GetPos())
--   if dist < 1000 * 1000 then
--     local ang = LocalPlayer():EyeAngles()
--     local pos = ply:GetPos()
--     local min, max = ply:GetHull()
--     local min1, max1 = ply:GetHullDuck()
--     render.DrawWireframeBox(pos, Angle(), min, max, color_white)
--     render.DrawWireframeBox(pos, Angle(), min1, max1, Color(255, 0, 0))
--   end
-- end
-- hook.Add("PostPlayerDraw", "test", DrawName)
local eMeta = FindMetaTable("Entity")
local math_random = math.random

local crmFootSounds = {"npc/cremator/foot1.wav", "npc/cremator/foot2.wav", "npc/cremator/foot3.wav"}

local stalkerFootSounds = {{"npc/stalker/stalker_footstep_left1.wav", "npc/stalker/stalker_footstep_left2.wav",}, {"npc/stalker/stalker_footstep_right1.wav", "npc/stalker/stalker_footstep_right2.wav",}}


hook.Add("PlayerFootstep", "CrematorFoots", function(ply, vec, foot, sound, volume, recipientFilter)
	if not IsAlive(ply) or not ply:isSynth() then return end
	if ply:isCrm() then
		if foot == 1 then
			local snd = crmFootSounds[math_random(#crmFootSounds)]
			EmitSound(snd, vec, ply:EntIndex(), CHAN_BODY, volume * 0.4, 75, 0, math.random(95, 105))
		end
		return true
	elseif ply:isStalker() then
		local snd = stalkerFootSounds[foot + 1][math_random(#stalkerFootSounds)]
		EmitSound(snd, vec, ply:EntIndex(), CHAN_BODY, volume * 0.4, 70, 0, math.random(95, 105))
		return true
	end
end)


if pMeta.isJeff then
	local jeffFootSounds = {"jeff_topot/jeff_topot1.wav", "jeff_topot/jeff_topot2.wav", "jeff_topot/jeff_topot3.wav", "jeff_topot/jeff_topot4.wav"}
	hook.Add("PlayerFootstep", "jeffFoots", function(player, position, foot, sound, volume, recipientFilter)
		if not IsAlive(player) then return end
		if not player:isJeff() then return end
		if foot == 1 then
			local snd = jeffFootSounds[math_random(#jeffFootSounds)]
			EmitSound(player, snd, 75, 100, 1)
		end
		return true
	end)
end

local hullSets = {
	default = {
		viewOffset = Vector(0, 0, 64),
		viewOffsetDucked = Vector(0, 0, 28)
	},
	custom = {
		scale = Vector(1.2, 1.2, 1.2),
		hull = {Vector(-18, -18, 0), Vector(18, 18, 89)},
		hullDuck = {Vector(-18, -18, 0), Vector(18, 18, 53)},
		viewOffset = Vector(0, 0, 81),
		viewOffsetDucked = Vector(0, 0, 45)
	}
}

local function setHull(ply)
	local custom = hullSets.custom
	-- ply:SetModelScale(1.2)
	ply:crm_SetModelScale(custom.scale)
	ply:SetHull(custom.hull[1], custom.hull[2])
	ply:SetHullDuck(custom.hullDuck[1], custom.hullDuck[2])
	-- ply:SetViewOffset(custom.viewOffset)
	-- ply:SetViewOffsetDucked(custom.viewOffsetDucked)
end

netstream.Hook("crm_fix_hull", function(ply, bool)
	if not IsValid(ply) then return end
	if bool then
		setHull(ply)
	else
		-- local default = hullSets.default
		-- ply:SetModelScale(1)
		ply:crm_SetModelScale()
		ply:ResetHull()
		-- ply:SetViewOffset(default.viewOffset)
		-- ply:SetViewOffsetDucked(default.viewOffsetDucked)
	end
end)

netstream.Hook("crm_fix_hull_all", function(arr)
	for ply in pairs(arr) do
		if not IsValid(ply) then continue end
		setHull(ply)
	end
end)

local max_min_vector = Vector(-8, -8, -8)
local util_TraceHull = util.TraceHull
local trOutput = {}
local tr = {
	start = Vector(),
	endpos = Vector(),
	filter = NULL,
	output = trOutput,
	mins = max_min_vector,
	maxs = -max_min_vector,
}

local checkJobsOffset = Vector(0, 0, 17)
local viewTab = {}
local viewVectorOffset
local bDisable = true
local function CalcViewCrem(ply, pos, angles, fov)
	if bDisable then return end

	tr.start = pos
	tr.endpos = pos + checkJobsOffset
	tr.filter = ply
	util_TraceHull(tr)

	viewVectorOffset = trOutput.HitPos
	viewTab.origin = viewVectorOffset
	viewTab.angles = angles
	viewTab.fov = fov
	viewTab.drawviewer = ply:ShouldDrawLocalPlayer()
	return viewTab
end

local function CalcViewModelViewCrem(wep, vm, oldPos, oldAng, pos, ang)
	if bDisable or not viewVectorOffset then return end

	-- tr.start = pos
	-- tr.endpos = pos + checkJobsOffset
	-- tr.filter = ply
	-- util_TraceHull(tr)

	return viewVectorOffset, ang
end

local function TickCrem()
	bDisable = ThirdPerson.IsEnabled()
end

hook.Add("OnPlayerChangedTeam", "Cremator", function(ply, old, new)
	if ply ~= LocalPlayer() then return end

	if new == TEAM_CREMATOR or new == TEAM_JEFF then
		hook.Add("Tick", "CalcViewCrem", TickCrem)
		hook.Add("CalcViewModelView", "CalcViewCrem", CalcViewModelViewCrem)
		hook.Add("CalcView", "CalcViewCrem", CalcViewCrem)
	else
		hook.Remove("Tick", "CalcViewCrem")
		hook.Remove("CalcViewModelView", "CalcViewCrem")
		hook.Remove("CalcView", "CalcViewCrem")
	end
end)
