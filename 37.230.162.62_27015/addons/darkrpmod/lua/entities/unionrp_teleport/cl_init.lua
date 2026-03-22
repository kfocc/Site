include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self:SetNextClientThink(CurTime() + 1)
end

local csTeleportRing, csGate = nil, nil
local function validateCSModels()
	if not IsValid(csTeleportRing) then
		csTeleportRing = ClientsideModel("models/props_lab/teleportring.mdl")
		csTeleportRing:SetModelScale(1.2)
		csTeleportRing:SetNoDraw(true)
	end

	if not IsValid(csGate) then
		csGate = ClientsideModel("models/props_lab/teleportgate.mdl")
		csGate:SetNoDraw(true)
	end
end


ENT.gates = {
  0,
  0,
  0,
}
ENT.cursound = -1

local gateSpeed = 140
local gateHeight = 96
function ENT:DrawGates(flags)
	local pos = self:GetPos() + self:GetForward() * 84 - self:GetRight() * 0.5 + self:GetUp() * 10

	local dt = CurTime() - self:GetNetVar("StartTime", 0)
	csGate:SetAngles(self:GetAngles())
	for i=1,3 do
    if dt < 4.5 then
      	csGate:SetPos(pos + self:GetUp() * (i * 19 + gateHeight - math.Clamp(gateSpeed * (dt - 0 - 0.25 * (i - 1)), 0, gateHeight)))
    else
		csGate:SetPos(pos + self:GetUp() * (i * 19 + math.Clamp(gateSpeed * (dt - 4.5 - 0.25 * (3 - i)), 0, gateHeight)))
    end
		csGate:SetupBones()
		csGate:DrawModel(flags)
	end
end

function ENT:ThinkGates()
  local dt = CurTime() - self:GetNetVar("StartTime", 0)

	/*for i=1,3 do
    if dt < 4.5 then
      gate:SetPos(pos + self:GetUp() * (i * 19 + 86 - math.Clamp(gateSpeed * (dt - 0 - 0.25 * (i - 1)), 0, 86)))
    else
		  gate:SetPos(pos + self:GetUp() * (i * 19 + math.Clamp(gateSpeed * (dt - 4.5 - 0.25 * (3 - i)), 0, 86)))
    end
		gate:SetupBones()
		gate:DrawModel(flags)
	end*/

	if dt < 4.5 then
		for i=1, 3 do
			if gateHeight / gateSpeed + 0.25 * (i - 1) < dt and self.gates[i] == 1 then
				self.gates[i] = 2
				self:EmitSound("k_lab.cagedoorsopen", nil, nil, nil, nil, SND_STOP)
				self:EmitSound("Doors.FullClose8")
			elseif dt >= 0.25 * (i - 1) and self.gates[i] == 0 then
				self.gates[i] = 1
				self:EmitSound("k_lab.cagedoorsopen")
			end
		end
	elseif dt < 4.5 + gateHeight / gateSpeed + 0.25*3 then
		for i=1, 3 do
			if gateHeight / gateSpeed + 4.5 + 0.25 * (i - 1) < dt and self.gates[i] == 3 then
				self.gates[i] = 0
				self:EmitSound("k_lab.cagedoorsopen", nil, nil, nil, nil, SND_STOP)
				self:EmitSound("Doors.FullClose8")
			elseif dt >= 4.5 + 0.25 * (i - 1) and self.gates[i] == 2 then
				self.gates[i] = 3
				self:EmitSound("k_lab.cagedoorsopen")
			end
    	end
	else
		for i=1, 3 do
			self.gates[i] = 0
		end
	end
end

local tbl = {0.023, 0.019, 0.016, 0.015}

ENT.tbl = {
  180,
  180,
  180,
  180,
  0
}

local angPresent = Angle(0, 0, 0)
function ENT:DrawRings(flags)
	local csModel = self:GetPlatform()
	if not IsValid(csModel) then return end

	local pos = csModel:GetPos() + csModel:GetForward() * 9 - csModel:GetUp() * 6
	csTeleportRing:SetSkin(self.tbl[5])

	local y = self:GetAngles()[2]
		for i=1,4 do
		angPresent:SetUnpacked(0, self.tbl[i] + y, 0)
		pos:Add(csModel:GetUp() * 12)
			csTeleportRing:SetPos( pos )
			csTeleportRing:SetAngles(angPresent)
			csTeleportRing:SetupBones()
			csTeleportRing:DrawModel(flags)
		end
end

local ringSpeed = 2750
local vecLight = Vector(-30, 0, 180)
local DynamicLight, math = DynamicLight, math
local vecPresent = Vector(0, 0, 0)
function ENT:ThinkRings()
	if self:GetNetVar("UsingTeleport") then
		local dt = CurTime() - self:GetNetVar("StartTime", 0)
		if dt < 8 then
			for i=1,4 do
				self.tbl[i] = 180
			end
			self.tbl[5] = 0
		elseif dt < 20 then
			for i=1,4 do
				local A = ringSpeed * tbl[i]
				self.tbl[i] = (180 + 0.1 * A * (dt^4 / 12 - 32 * dt^2)) % 360
			end
			self.tbl[5] = dt > 10.5 and 1 or 0
		elseif dt < 28 then
			for i=1,4 do
				if self.tbl[i] == 180 and dt > 25 then continue end

				local A = ringSpeed * tbl[i]
				local dt2 = 20
				local old_speed = 0.1 * A * (dt2^2 - 8^2)
				local old_angle = (180 + 0.1 * A * (dt2^4 / 12 - 32 * dt2^2)) % 360
				local new_angle = (old_angle + (old_speed + 20 * 2 * A) * dt - (0.1 * A * dt^3) / 3) % 360

				if dt > 25 and new_angle > 179 and new_angle < 180 + 20 then
					new_angle = 180
				end
				self.tbl[i] = new_angle
			end
			self.tbl[5] = dt < 23.5 and 1 or 0
		end
	else
		for i=1,4 do
			self.tbl[i] = 180
		end
		self.tbl[5] = 0
	end

	local csModel = self:GetPlatform()
	if not IsValid(csModel) or self:IsDormant() then return end

	// Lights
	//if not self:GetNetVar("Destroyed") then
		local index = self:EntIndex()
		local dietime = CurTime() + 1
		local dlight = DynamicLight( index )
		if ( dlight ) then
			dlight.pos = self:LocalToWorld(vecLight)
			dlight.r = 105
			dlight.g = 203
			dlight.b = 250
			dlight.brightness = 6
			dlight.decay = 0
			dlight.size = 64
			dlight.dietime = dietime
		end

		local pos = csModel:GetPos() + csModel:GetForward() * 9 - csModel:GetUp() * 6
		local y = self:GetAngles()[2]
		for i=1,4 do
			pos:Add(csModel:GetUp() * 12)
			local dlight = DynamicLight( index + i )
			if ( dlight ) then
				local rad = math.rad(self.tbl[i] + y)
				vecPresent:SetUnpacked(math.cos(rad) * 20, math.sin(rad) * 20, 0)
				dlight.pos = pos + vecPresent
				dlight.r = 105
				dlight.g = 203
				dlight.b = 250
				dlight.brightness = 3
				dlight.decay = 0
				dlight.size = 36
				dlight.dietime = dietime
			end
		end
	//end
end

local teleports
function ENT:ThinkSounds()
	if not self:GetNetVar("UsingTeleport") and self.cursound ~= 7 then
		self.cursound = 0
		return
	end

	local csModel = self:GetPlatform()
	if not IsValid(csModel) then return end

	local dt = CurTime() - self:GetNetVar("StartTime", 0)
	local snd = self.cursound
	if dt >= 30 and snd ~= 8 then
		self.cursound = 8
		csModel:EmitSound("ambient/machines/engine4.wav", nil, nil, nil, nil, SND_STOP)
		if not self:IsDormant() or teleports then
			csModel:EmitSound("Doors.FullOpen11")
		end
	elseif dt >= 27 and dt < 30 and snd ~= 7 then
		self.cursound = 7
		csModel:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav", nil, nil, nil, nil, SND_STOP)
		if not self:IsDormant() or teleports then
			csModel:EmitSound("ambient/machines/engine4.wav", 80, 85, 0.45)
		end
	elseif dt >= 20 and dt < 27 and snd ~= 6 then
		self.cursound = 6
		csModel:EmitSound("ambient/levels/labs/teleport_active_loop1.wav", nil, nil, nil, nil, SND_STOP)
		csModel:EmitSound("ambient/levels/labs/teleport_rings_loop2.wav", nil, nil, nil, nil, SND_STOP)
		if not self:IsDormant() or teleports then
			csModel:EmitSound("unionrp.teleport_sound", SNDLVL_85dB, 100)
			csModel:EmitSound("ambient/levels/labs/teleport_postblast_thunder1.wav", SNDLVL_45dB, 100)
			csModel:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav", SNDLVL_90dB, 100)
		end
	elseif dt > 20 - 4.366 and dt < 20 and snd ~= 5 then
		self.cursound = 5
		if not self:IsDormant() or teleports then
			csModel:EmitSound("hl1/ambience/particle_suck2.wav")
		end
	elseif dt > 20 - 8.63 and dt < 20 - 4.366 and snd ~= 4 then
		self.cursound = 4
		if not self:IsDormant() or teleports then
			csModel:EmitSound("ambient/levels/labs/teleport_mechanism_windup3.wav")
		end
	elseif dt > 10.5 and dt < 20 - 8.63 and snd ~= 3 then
		self.cursound = 3
		if not self:IsDormant() or teleports then
			csModel:EmitSound("ambient/levels/labs/teleport_rings_loop2.wav", SNDLVL_55dB, 100)
		end
	elseif dt > 8 and dt < 10.5 and snd ~= 2 then
		self.cursound = 2
		csModel:EmitSound("ambient/machines/engine4.wav", nil, nil, nil, nil, SND_STOP)
		if not self:IsDormant() or teleports then
			csModel:EmitSound("Doors.FullOpen11")
		end
	elseif dt > 5 and dt < 8 and snd ~= 1 then
		self.cursound = 1
		if not self:IsDormant() or teleports then
			csModel:EmitSound("ambient/levels/labs/teleport_active_loop1.wav", SNDLVL_55dB, 100)
			csModel:EmitSound("ambient/machines/engine4.wav", SNDLVL_80dB, 85, 0.45)
		end
	end
end

local tglow=CreateMaterial("glow3", "UnlitGeneric", {["$basetexture"] = "sprites/redglow2", ["$spriterendermode"] = 9, ["$additive"] = 1, ["$vertexcolor"] = 1, ["$vertexalpha"] = 1})
local tflash=CreateMaterial("glow1", "UnlitGeneric", {["$basetexture"] = "sprites/light_glow02", ["$ignorez"]=1,["$illumfactor"]=8,["$spriterendermode"] = 9,  ["$additive"] = 1, ["$vertexcolor"] = 1, ["$vertexalpha"] = 1})
local vecSprite = Vector(9, 0, 42)
local colSprite = Color(255, 255, 255, 255)
function ENT:Draw(flags)
	self:DrawModel(flags)

	validateCSModels()

	self:DrawRings(flags)
	self:DrawGates(flags)

	render.RenderFlashlights(function(flags)
		self:DrawRings(flags)
		self:DrawGates(flags)
	end)
end

function ENT:DrawTranslucent(flags)
  self:DrawGates(flags)

	render.RenderFlashlights(function(flags)
		self:DrawGates(flags)
	end)

	if not self:GetNetVar("UsingTeleport") then return end

	local mid = self:GetNetVar("StartTime", 0) + 20 -- Teleport time
	local start = mid - 4.366
	local stop = mid + 0.5
	local pos = self:GetPlatform():LocalToWorld(vecSprite)
	local curtime = CurTime()
	if curtime < mid then
		-- we're before the teleport
		if curtime > start then
			local form = (curtime - start) / 4.366
			render.SetMaterial(tglow)
			colSprite.r = 0
			colSprite.a = 255
			render.DrawSprite(pos, form * 150, form * 200, colSprite)
		end
		if curtime > mid - 0.5 then
			local form = (curtime - mid - 0.5) * 2
			render.SetMaterial(tflash)
			colSprite.a = form * 255
			render.DrawSprite(pos, 300, 300, colSprite)
		end
		if curtime > mid - 0.2 then
			local form = (curtime - mid - 0.2) * 5
			colSprite.r = 255 - form * 255
			colSprite.a = form * 255
			render.DrawSprite(pos, 4000, 4000, colSprite)
		end
	else
		--we just teleported
		if curtime < stop then
			local form = (stop - curtime) * 2
			render.SetMaterial(tflash)
			colSprite.r = 0
			colSprite.a = 255
			render.DrawSprite(pos, form * 150, form * 200, colSprite)
			colSprite.r = 255
			colSprite.a = form * 255
			render.DrawSprite(pos, 200, 200, colSprite)
			colSprite.r = 0
			render.DrawSprite(pos, 4000, 4000, colSprite)
		end
	end
end

local sounds = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav", "ambient/energy/spark5.wav", "ambient/energy/spark6.wav"}
local offset = Vector(0, 0, -250)
function ENT:Think()
	self:ThinkSounds()

  if self:IsDormant() then
		self:SetNextClientThink(CurTime() + 1)
    return
  end

	self:ThinkRings()
  self:ThinkGates()

	if not self:GetNetVar("Destroyed") then
		self:SetNextClientThink(CurTime() + 0.016) // Target 60 fps
		return
	end

	local min, max = self:GetModelBounds()
	local lerp = LerpVector(0.5, min, max)
	local pos = self:LocalToWorld(lerp)
	local emitter = ParticleEmitter(pos)
	for i = 0, 25 do
		local part = emitter:Add("effects/spark", pos)
		if part then
			part:SetDieTime(1)

			part:SetStartAlpha(255)
			part:SetEndAlpha(0)

			part:SetStartSize(7)
			part:SetEndSize(0)

			part:SetGravity(offset)
			part:SetVelocity(VectorRand() * 100)
		end
	end

	emitter:Finish()
	self:EmitSound(sounds[math.random(#sounds)], 60, 100, 0.8)
	local rand = math.random(1, 4)
	self:SetNextClientThink(CurTime() + rand)
	return true
end

local NULL = NULL
hook.Add("FinishMove", "fixParentGround", function(ply, mv)
	local parent = ply:GetParent()
	if parent and parent ~= NULL then
		ply:SetGroundEntity(parent)
		ply:AddFlags(FL_ONGROUND)
	end
end)

net.Receive("TeleportSounds", function()
	local teleport = net.ReadTable()
	if not istable(teleport) then return end
	for _, v in ipairs(teleport) do
		v.cursound = 0
	end

	teleports = teleport
end)

hook.Add("HUDPaint","UnionRP:Teleport", function()
	if not teleports then return end

	local teleport_time = teleports[1]:GetNetVar("StartTime", 0) + 20
	local curtime = CurTime()
	if curtime >= teleport_time and IsValid(teleports[2]) and teleports[2].SetNextClientThink then
		teleports[2]:SetNextClientThink(CurTime() + 0.016) // Target 60 fps
	end
	if curtime >= teleport_time + 0.5 or not teleports[1]:GetNetVar("UsingTeleport") then
		teleports = nil
		return
	end

	if curtime > teleport_time - 4.366 and curtime < teleport_time then
		DrawMaterialOverlay("effects/tp_eyefx/tpeye2", math.max(0, (curtime - teleport_time + 4.366) / 4.366)) // 20 - 4.366 flash
	end

	local form = math.max(0, 1 - 2 * math.abs(teleport_time - curtime))
	surface.SetDrawColor(255, 255, 255, form * 255)
	surface.DrawRect(0, 0, ScrW(), ScrH())
end, HOOK_LOW)