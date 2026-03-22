local _R = debug.getregistry()
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local togglelegs = CreateClientConVar("Union_legs_toggle", "1", true, false)
local Legs = {
	FixedModelNames = {
		-- Broken model path = key, fixed model path = value
		["models/humans/group01/female_06.mdl"] = "models/player/group01/female_06.mdl",
		["models/humans/group01/female_01.mdl"] = "models/player/group01/female_01.mdl",
		["models/alyx.mdl"] = "models/player/alyx.mdl",
		["models/humans/group01/female_07.mdl"] = "models/player/group01/female_07.mdl",
		["models/charple01.mdl"] = "models/player/charple01.mdl",
		["models/humans/group01/female_04.mdl"] = "models/player/group01/female_04.mdl",
		["models/humans/group03/female_06.mdl"] = "models/player/group03/female_06.mdl",
		["models/gasmask.mdl"] = "models/player/gasmask.mdl",
		["models/humans/group01/female_02.mdl"] = "models/player/group01/female_02.mdl",
		["models/gman_high.mdl"] = "models/player/gman_high.mdl",
		["models/humans/group03/male_07.mdl"] = "models/player/group03/male_07.mdl",
		["models/humans/group03/female_03.mdl"] = "models/player/group03/female_03.mdl",
		["models/police.mdl"] = "models/player/police.mdl",
		["models/breen.mdl"] = "models/player/breen.mdl",
		["models/humans/group01/male_01.mdl"] = "models/player/group01/male_01.mdl",
		["models/zombie_soldier.mdl"] = "models/player/zombie_soldier.mdl",
		["models/humans/group01/male_03.mdl"] = "models/player/group01/male_03.mdl",
		["models/humans/group03/female_04.mdl"] = "models/player/group03/female_04.mdl",
		["models/humans/group01/male_02.mdl"] = "models/player/group01/male_02.mdl",
		["models/kleiner.mdl"] = "models/player/kleiner.mdl",
		["models/humans/group03/female_01.mdl"] = "models/player/group03/female_01.mdl",
		["models/humans/group01/male_09.mdl"] = "models/player/group01/male_09.mdl",
		["models/humans/group03/male_04.mdl"] = "models/player/group03/male_04.mdl",
		["models/player/urban.mbl"] = "models/player/urban.mdl", -- It fucking returns the file type wrong as "mbl" D:
		["models/humans/group03/male_01.mdl"] = "models/player/group03/male_01.mdl",
		["models/mossman.mdl"] = "models/player/mossman.mdl",
		["models/humans/group01/male_06.mdl"] = "models/player/group01/male_06.mdl",
		["models/humans/group03/female_02.mdl"] = "models/player/group03/female_02.mdl",
		["models/humans/group01/male_07.mdl"] = "models/player/group01/male_07.mdl",
		["models/humans/group01/female_03.mdl"] = "models/player/group01/female_03.mdl",
		["models/humans/group01/male_08.mdl"] = "models/player/group01/male_08.mdl",
		["models/humans/group01/male_04.mdl"] = "models/player/group01/male_04.mdl",
		["models/humans/group03/female_07.mdl"] = "models/player/group03/female_07.mdl",
		["models/humans/group03/male_02.mdl"] = "models/player/group03/male_02.mdl",
		["models/humans/group03/male_06.mdl"] = "models/player/group03/male_06.mdl",
		["models/barney.mdl"] = "models/player/barney.mdl",
		["models/humans/group03/male_03.mdl"] = "models/player/group03/male_03.mdl",
		["models/humans/group03/male_05.mdl"] = "models/player/group03/male_05.mdl",
		["models/odessa.mdl"] = "models/player/odessa.mdl",
		["models/humans/group03/male_09.mdl"] = "models/player/group03/male_09.mdl",
		["models/humans/group01/male_05.mdl"] = "models/player/group01/male_05.mdl",
		["models/humans/group03/male_08.mdl"] = "models/player/group03/male_08.mdl",
		--Thanks Jvs
		["models/monk.mdl"] = "models/player/monk.mdl",
		["models/eli.mdl"] = "models/player/eli.mdl",
	},
	BoneHoldTypes = {
		-- Can change to whatever you want, I think these two look best
		["none"] = {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Neck1", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine2",},
		["default"] = {
			-- The default bones to be hidden if there is no hold type bones
			"ValveBiped.Bip01_Head1",
			"ValveBiped.Bip01_Neck1",
			"ValveBiped.Bip01_Spine4",
			"ValveBiped.Bip01_Spine2",
			"ValveBiped.Bip01_L_Hand",
			"ValveBiped.Bip01_L_Forearm",
			"ValveBiped.Bip01_L_Upperarm",
			"ValveBiped.Bip01_L_Clavicle",
			"ValveBiped.Bip01_R_Hand",
			"ValveBiped.Bip01_R_Forearm",
			"ValveBiped.Bip01_R_Upperarm",
			"ValveBiped.Bip01_R_Clavicle",
			"ValveBiped.Bip01_L_Finger4",
			"ValveBiped.Bip01_L_Finger41",
			"ValveBiped.Bip01_L_Finger42",
			"ValveBiped.Bip01_L_Finger3",
			"ValveBiped.Bip01_L_Finger31",
			"ValveBiped.Bip01_L_Finger32",
			"ValveBiped.Bip01_L_Finger2",
			"ValveBiped.Bip01_L_Finger21",
			"ValveBiped.Bip01_L_Finger22",
			"ValveBiped.Bip01_L_Finger1",
			"ValveBiped.Bip01_L_Finger11",
			"ValveBiped.Bip01_L_Finger12",
			"ValveBiped.Bip01_L_Finger0",
			"ValveBiped.Bip01_L_Finger01",
			"ValveBiped.Bip01_L_Finger02",
			"ValveBiped.Bip01_R_Finger4",
			"ValveBiped.Bip01_R_Finger41",
			"ValveBiped.Bip01_R_Finger42",
			"ValveBiped.Bip01_R_Finger3",
			"ValveBiped.Bip01_R_Finger31",
			"ValveBiped.Bip01_R_Finger32",
			"ValveBiped.Bip01_R_Finger2",
			"ValveBiped.Bip01_R_Finger21",
			"ValveBiped.Bip01_R_Finger22",
			"ValveBiped.Bip01_R_Finger1",
			"ValveBiped.Bip01_R_Finger11",
			"ValveBiped.Bip01_R_Finger12",
			"ValveBiped.Bip01_R_Finger0",
			"ValveBiped.Bip01_R_Finger01",
			"ValveBiped.Bip01_R_Finger02"
		},
		["vehicle"] = {
			-- Bones that are deflated while in a vehicle
			"ValveBiped.Bip01_Head1",
			"ValveBiped.Bip01_Neck1",
			"ValveBiped.Bip01_Spine4",
			"ValveBiped.Bip01_Spine2",
		}
	},
}

local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")
local GetModel = ENTITY.GetModel
function PLAYER:GetFixedModel() -- For some reason, the client returns the original HL2 version model of the player, not the player model.. Weird right? Only applies to the default player models.
	local mdl = GetModel(self)
	return Legs.FixedModelNames[mdl] or mdl
end
local GetFixedModel = PLAYER.GetFixedModel

local LegsMeta = {}
LegsMeta.__index = LegsMeta
RegisterMetaTable("Legs", LegsMeta)
local function CreateLegs() -- Creates our legs
	local ply = LocalPlayer()
	local ent = ClientsideModel(GetFixedModel(ply), RENDER_GROUP_OPAQUE_ENTITY)
	ent:SetNoDraw(true) -- We render the model differently
	ent:SetSkin(ply:GetSkin())
	ent:SetMaterial(ply:GetMaterial())
	ent.GetPlayerColor = function() return ply:GetPlayerColor() end

	return setmetatable({
		Entity = ent,
		NextBreath = CurTime(),
		LastTick = CurTime(),
		LastWeapon = nil,
		LastSeq = nil,
	}, LegsMeta)
end

local NULL = NULL
function LegsMeta:IsValid()
	return self.Entity ~= NULL
end

function LegsMeta:ShouldDraw()
	local ply = LocalPlayer()
	return togglelegs:GetBool() and self:IsValid() and ply:Alive() and (ply:InVehicle() and togglelegs:GetBool() or not ply:InVehicle()) and GetViewEntity() == ply and not ply:ShouldDrawLocalPlayer() and not IsValid(ply:GetObserverTarget()) and not ply.ShouldDisableLegs
end

local SetPlaybackRate = ENTITY.SetPlaybackRate
local FrameAdvance = ENTITY.FrameAdvance
function LegsMeta:UpdateAnimation(ply, vel, groundSpeed)
	local ent = self.Entity
	vel = vel:Length2D()
	local playRate = 1

	if vel > 0.5 then -- Taken from the SDK, gets the proper play back rate
		if groundSpeed < 0.001 then
			playRate = 0.01
		else
			playRate = vel / groundSpeed
			playRate = math.Clamp(playRate, 0.01, 10)
		end
	end

	SetPlaybackRate(ent, playRate) -- Change the rate of playback. This is for when you walk faster/slower
	FrameAdvance(ent, CurTime() - self.LastTick) -- Advance the amount of frames we need
	self.LastTick = CurTime()
end

local SetPoseParameter = ENTITY.SetPoseParameter
local GetPoseParameter = ENTITY.GetPoseParameter
local SetModel = ENTITY.SetModel
local GetMaterial = ENTITY.GetMaterial
local SetMaterial = ENTITY.SetMaterial
local GetSkin = ENTITY.GetSkin
local SetSkin = ENTITY.SetSkin
local GetSequence = ENTITY.GetSequence
local GetActiveWeapon = PLAYER.GetActiveWeapon
local InVehicle = PLAYER.InVehicle
function LegsMeta:Tick()
	local ply = LocalPlayer()
	if GetActiveWeapon(ply) ~= self.LastWeapon then -- Player switched weapons, change the bones for new weapon
		self.LastWeapon = GetActiveWeapon(ply)
		self:OnSwitchedWeapon(self.LastWeapon)
	end

	local ent = self.Entity
	local fixedModel = GetFixedModel(ply)
	if GetModel(ent) ~= fixedModel then -- Player changed model without spawning?
		SetModel(ent, fixedModel)
		self:OnSwitchedWeapon(self.LastWeapon)
	end

	local seq = GetSequence(ply)
	if self.LastSeq ~= seq then
		self.LastSeq = seq
		ent:ResetSequence(seq) -- If the player changes sequences, change the legs too
	end

	local breathScale = 0.5 -- More compatability for sharpeye. This changes the models breathing paramaters to go off of sharpeyes stamina system
	if self.NextBreath <= CurTime() then -- Only update every cycle, should stop MOST of the jittering
		self.NextBreath = CurTime() + 1.95 / breathScale
		SetPoseParameter(ent, "breathing", breathScale)
	end

	-- Tanks to samm5506 from the Elevator: Source team for updating to the new pose paramaters
	SetPoseParameter(ent, "move_x", GetPoseParameter(ply, "move_x") * 2 - 1) -- Translate the walk x direction
	SetPoseParameter(ent, "move_y", GetPoseParameter(ply, "move_y") * 2 - 1) -- Translate the walk y direction
	SetPoseParameter(ent, "move_yaw", GetPoseParameter(ply, "move_yaw") * 360 - 180) -- Translate the walk direction
	SetPoseParameter(ent, "body_yaw", GetPoseParameter(ply, "body_yaw") * 180 - 90) -- Translate the body yaw
	SetPoseParameter(ent, "spine_yaw", GetPoseParameter(ply, "spine_yaw") * 180 - 90) -- Translate the spine yaw
	if InVehicle(ply) then
		ent:SetColor(color_transparent)
		SetPoseParameter(ent, "vehicle_steer", GetPoseParameter(ply:GetVehicle(), "vehicle_steer") * 2 - 1) -- Translate the vehicle steering
	end
end

vector_down = vector_up * -1
function LegsMeta:Render()
	if not self:ShouldDraw() then -- Should the legs be visible this frame?
		return
	end

	local ply = LocalPlayer()
	local ent = self.Entity

	local renderPos = ply:GetPos()
	local renderAng = ply:EyeAngles()

	if InVehicle(ply) then -- The player is in a vehicle, so we use the vehicles angles, not the LocalPlayer
		renderAng = ply:GetVehicle():GetAngles()
		renderAng:RotateAroundAxis(renderAng:Up(), 90) -- Fix it
	else -- This calculates the offset behind the player, adjust the -22 if you want to move it
		local biaisAngle = sharpeye_focus and sharpeye_focus.GetBiaisViewAngles and sharpeye_focus:GetBiaisViewAngles() or renderAng
		renderAng = Angle(0, biaisAngle.y, 0)
		local radAngle = math.rad(biaisAngle.y)
		renderPos.x = renderPos.x + math.cos(radAngle) * -22
		renderPos.y = renderPos.y + math.sin(radAngle) * -22

		if ply:GetGroundEntity() == NULL then
			renderPos.z = renderPos.z + 8 -- Crappy jump fix
			if ply:KeyDown(IN_DUCK) then -- Crappy duck fix
				renderPos.z = renderPos.z - 28
			end
		end
	end

	local col = ply:GetColor()
	local bEnabled = render.EnableClipping(true)
		render.PushCustomClipPlane(vector_down, vector_down:Dot(EyePos())) -- Clip the model so if we look up we should never see any part of the legs model
		render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255) -- Render the color correctly
		render.SetBlend(col.a / 255)
			hook.Run("PreLegsDraw", ent)
			ent:SetRenderOrigin(renderPos)
			ent:SetRenderAngles(renderAng)
			ent:SetupBones()
			ent:DrawModel()
			hook.Run("PostLegsDraw", ent)
		render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
		render.PopCustomClipPlane()
	render.EnableClipping(bEnabled)
end

local vector_origin = vector_origin
local vector_normal = Vector(1, 1, 1)
local vector_hide = Vector(-5, -10, 0)
function LegsMeta:OnSwitchedWeapon(weap) -- Different bones will be visible for different hold types
	local holdType = "none"
	if IsValid(weap) then holdType = weap:GetHoldType() end
	local ply = LocalPlayer()
	local ent = self.Entity
	for k, v in pairs(ply:GetBodyGroups()) do
		ent:SetBodygroup(v.id, ply:GetBodygroup(v.id))
	end

	for k, v in ipairs(ply:GetMaterials()) do
		ent:SetSubMaterial(k - 1, ply:GetSubMaterial(k - 1))
	end

	SetSkin(ent, GetSkin(ply))
	SetMaterial(ent, GetMaterial(ply))
	-- Tanks to samm5506 from the Elevator: Source team for making this hack to fix the bone scaling issues in GMod13
	-- Reset all bonesc
	for i = 0, ent:GetBoneCount() do
		ent:ManipulateBoneScale(i, vector_normal)
		ent:ManipulateBonePosition(i, vector_origin)
	end

	-- Remove bones from being seen
	local bonesToRemove = {"ValveBiped.Bip01_Head1"}
	if not InVehicle(LocalPlayer()) then
		bonesToRemove = Legs.BoneHoldTypes[holdType] or Legs.BoneHoldTypes["default"]
	else
		bonesToRemove = Legs.BoneHoldTypes["vehicle"]
	end

	for _, v in ipairs(bonesToRemove) do -- Loop through desired bones
		local id = ent:LookupBone(v)
		if id then
			ent:ManipulateBoneScale(id, vector_origin)
			ent:ManipulateBonePosition(id, vector_hide)
		end
	end
end

local localPly = LocalPlayer()
hook.Add("UpdateAnimation", "Legs:UpdateAnimation", function(ply, vel, groundSpeed)
	if ply ~= localPly then return end
	local plyLegs = ply.Legs
	if IsValid(plyLegs) then
		plyLegs:UpdateAnimation(ply, vel, groundSpeed) -- Called every frame. Pass the ground speed for later use
	end
end)

local function legsTick()
	local legs = localPly.Legs
	if legs and legs:IsValid() then
		legs:Tick() -- Called every frame. Pass the ground speed for later use
	else
		localPly.Legs = CreateLegs() -- No legs, create them. Should only be called once
	end
end

hook.Add("InitPostEntity", "Legs:InitPostEntity", function()
	localPly = LocalPlayer()
	hook.Add("Tick", "Legs:Tick", legsTick)
end)

hook.Add("PostDrawTranslucentRenderables", "Legs:Render", function(a, b, c)
	if b then return end
	local ply = LocalPlayer()
	if not ply.Legs or ply:EyeAngles().pitch < 50 then return end
	ply.Legs:Render()
end)
