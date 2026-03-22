local tres = {}
local trace = {
	start = Vector(),
	endpos = Vector(),
	mask = MASK_SOLID_BRUSHONLY,
	collisiongroup = COLLISION_GROUP_WORLD,
	output = tres,
}

local vector_detect = Vector(0, 0, -224)
local vector_tolerance = Vector(0.25, 0.25, 0.25)
local color_red = Color(255, 0, 0)
local color_green = Color(0, 255, 0)
hook.Add("DrawPhysgunBeam", "CheckCollision", function(ply, wep, enabled, ent, bone, deltaPos)
	if not checkCollideDisplay or ply ~= LocalPlayer() or not IsValid(ent) or ent:IsPlayer() then return end
	local min, max = ent:GetRotatedAABB(ent:GetCollisionBounds())
	min:Sub(vector_tolerance)
	max:Add(vector_tolerance)
	min.z = 0
	-- max.z = 0
	trace.start = ent:GetPos()
	trace.endpos = trace.start + vector_detect
	trace.mins = min
	trace.maxs = max
	util.TraceHull(trace)
	min.z = -0.25
	max.z = 0.25
	render.DrawWireframeBox(tres.HitPos, angle_zero, min, max, tres.Hit and color_green or color_red)
end)

local NULL = NULL
local iPhysgunHalo = CreateConVar( "physgun_halo", "1", { FCVAR_ARCHIVE }, "Draw the physics gun halo?" )

local tPhysgunHalos = {}
hook.Add("DrawPhysgunBeam", "AddPhysgunHalos", function( ply, weapon, bOn, target, boneid, pos )
	if iPhysgunHalo:GetInt() == 0 or not target or target == NULL then return true end

	table.insert(tPhysgunHalos, target)

	return true
end, HOOK_LOW)

local RenderScale 		= 1
local HSVToColor		= HSVToColor
hook.Add( "PreDrawHalos", "AddPhysgunHalos", function()
	if iPhysgunHalo:GetInt() == 0 or #tPhysgunHalos < 1 then return end

	local size = 2 * RenderScale
	halo.Add(tPhysgunHalos, HSVToColor(CurTime()%3 * 120, 0.25, 0.7), size, size, 1, true, false)

	tPhysgunHalos = {}
end )

hook.Add("PreRender", "AddPhysgunHalos", function()
	RenderScale = math.sin(5 * CurTime()) * 0.2 + 0.8
end)

local lastEyePos = vector_origin
local function UpdateEyePos()
	-- A bit of a hack due to EyePos() being affected by other rendering functions
	-- So we cache the value when we know it is the correct value for the frame
	lastEyePos = EyePos()
end

local function GetHovered( eyepos, eyevec )
	local ply = LocalPlayer()
	local filter = ply:GetViewEntity()
	local inPerson = filter == ply

	if inPerson then
		local veh = ply:GetVehicle()

		if veh:IsValid() and ( not veh:IsVehicle() or not veh:GetThirdPersonMode() ) then
			-- A dirty hack for prop_vehicle_crane. util.TraceLine returns the vehicle but it hits phys_bone_follower - something that needs looking into
			filter = { filter, veh, "phys_bone_follower" }
		end
	end

	local tr = {
		start = eyepos,
		endpos = eyepos + eyevec * (inPerson and 196 or 1024),
		filter = filter
	}

	local trace = util.TraceLine( tr )

	-- Hit COLLISION_GROUP_DEBRIS and stuff
	if not trace.Hit or not IsValid( trace.Entity ) then
		tr.mask = MASK_ALL
		trace = util.TraceLine( tr )
	end

	if not trace.Hit or not IsValid( trace.Entity ) then return end

	return trace.Entity, trace
end

hook.Add("PreDrawHalos", "Override.PropertiesHover", function()
	local pnl = vgui.GetHoveredPanel()
	if not IsValid(pnl) or not pnl:IsWorldClicker() then return end

	UpdateEyePos()

	local ent = GetHovered(lastEyePos, gui.ScreenToVector(input.GetCursorPos()))
	if not ent or ent == NULL then return end

	table.insert(tPhysgunHalos, ent)

end, HOOK_HIGH)

hook.Add( "PreDrawEffects", "Override.PropertiesUpdateEyePos", function()
	UpdateEyePos()
end)