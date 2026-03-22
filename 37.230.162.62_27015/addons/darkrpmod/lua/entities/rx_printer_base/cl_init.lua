include("shared.lua")
include("sh_upgrader.lua")
include("sh_printers.lua")

local tM = FindMetaTable("Angle")
local RotateAroundAxis = tM.RotateAroundAxis
local Right, Up = tM.Right, tM.Up
tM = FindMetaTable("Entity")
local GetPos, GetAngles = tM.GetPos, tM.GetAngles
local cERROR = Color(255, 0, 0, 200)
local cWHITE = Color(255, 255, 255, 200)
local function Render3D2DInfo(Ent, DIST)
	local ang = GetAngles(Ent)
	RotateAroundAxis(ang, Up(ang), 90)

	local Owner = Ent:GetPrinterOwner()
	Owner = IsValid(Owner) and Owner:Nick() or ""

	cam.Start3D2D(GetPos(Ent) + Ent:GetUp() * 10.6 - Ent:GetForward() * 2, ang, 0.15)

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(-90, 0, 180, 40)
	draw.SimpleText(Ent.PrinterName, "RXP_Header", 0, 2, cWHITE, TEXT_ALIGN_CENTER)
	draw.SimpleText(Owner, "RXP_Hull", 0, 25, cWHITE, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local function Render3D2DInfo2(Ent, DIST)
	local H, HM = Ent:GetHull()
	local ang = GetAngles(Ent)
	RotateAroundAxis(ang, Right(ang), 270)
	RotateAroundAxis(ang, Up(ang), 90)

	cam.Start3D2D(GetPos(Ent) + Ent:GetForward() * 16.2 + Ent:GetUp() * 5, ang, 0.1)
	surface.SetDrawColor(Ent.PrinterMasterColor)
	surface.DrawRect(-134, 6, 200, 26)
	surface.SetDrawColor(0, 0, 0, 200)

	surface.DrawRect(-132, 8, 196, 22)
	surface.SetDrawColor(0, 255, 0, 200)

	surface.DrawRect(-130, 10, 192 * math.min(1, H / HM), 18)
	local storedMoney = math.floor(Ent:GetStoredMoney())
	storedMoney = DarkRP.formatMoney(storedMoney)

	local TEXT = Ent:IsDisabled() and "Отключен" or storedMoney
	local bError, iErrorCode = Ent:IsError()
	if bError and CurTime() % 1 < 0.5 then TEXT = RXPrinters_Config.ErrorCodeMessage[iErrorCode] or "ERROR" end

	draw.SimpleText(TEXT, "RXP_Money", -35, -42.5, bError and cERROR or cWHITE, TEXT_ALIGN_CENTER)
	-- draw.SimpleText(H .. " / " .. HM, "RXP_Hull", -30,5, cWHITE,TEXT_ALIGN_CENTER)

	draw.SimpleText(math.floor(H), "RXP_Hull", -30, 11, cWHITE, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:GetPrinterOwner()
	return self:Getowning_ent()
end

function ENT:OnRemove()
	self.RunningSoundOBJ:Stop()
	local emitter = self.Emitter
	if emitter and emitter:IsValid() then emitter:Finish() end
end

function ENT:Initialize()
	self.RunningSoundOBJ = CreateSound(self, self.RuningSound[3])
	self.RunningSoundOBJ:ChangeVolume(self.RuningSoundVolume, 0)
	-- self.Emitter = ParticleEmitter(GetPos(self))
end

local bit = bit
local EXCLUDED_PASSES = bit.bnot(STUDIO_RENDER + STUDIO_DRAWTRANSLUCENTSUBMODELS)
function ENT:Draw(flags)
	self:DrawModel(flags)
	if bit.band(flags, EXCLUDED_PASSES) > 0 then return end
	local vPrinterPos = GetPos(self)
	local curDist = GetPos(LocalPlayer()):DistToSqr(vPrinterPos)
	if curDist <= RXPrinters_Config.RenderDist then
		Render3D2DInfo(self, curDist)
		Render3D2DInfo2(self, curDist)
	end
end

local vSmokeGravity = Vector(-100, 0, 70)
function ENT:Think()
	self:SetNextClientThink(CurTime() + 1)
	if self:IsDormant() then return end
	local vPrinterPos = GetPos(self)
	local DIST = GetPos(LocalPlayer()):DistToSqr(vPrinterPos)
	if DIST > RXPrinters_Config.RenderDist then return end

	local _, errorCode = self:IsError()
	local emitter = self.Emitter
	if errorCode == 2 then
		-- if (self.lastEmit or 0) <= CurTime() then
		-- 	self.lastEmit = CurTime() + math.random(2, 3)
		if not IsValid(emitter) then
			emitter = ParticleEmitter(vPrinterPos)
			self.Emitter = emitter
		end

		local p = emitter:Add("particle/particle_smokegrenade", vPrinterPos)
		p:SetDieTime(1)
		p:SetGravity(vSmokeGravity)
		p:SetVelocity(Vector(math.random(-10, 50), math.random(-10, 50), 50))
		p:SetAirResistance(20)
		p:SetStartSize(0)
		p:SetEndSize(math.Rand(25, 35))
		p:SetRoll(math.Rand(-5, 5))
		p:SetColor(100, 100, 100, 255)
		p:SetEndAlpha(0)
		-- end
	elseif IsValid(emitter) then
		emitter:Finish()
	end

	local soundObj = self.RunningSoundOBJ
	if self:GetNetVar("mute") then
		if soundObj then soundObj:Stop() end
		-- self:SetNextClientThink(CurTime() + 180)
		return true
	end

	if self:IsError() then
		if self.ErrorSound[1] and (self.ErrorSoundTime or 0) < CurTime() then
			self.ErrorSoundTime = CurTime() + self.ErrorSound[2]
			self:EmitSound(self.ErrorSound[3])
			-- self:EmitSound(self.ErrorSound[3])
			soundObj:Stop()
		end
	elseif self.RuningSound[1] and (self.RunningSoundTime or 0) < CurTime() then
		self.RunningSoundTime = CurTime() + self.RuningSound[2]
		soundObj:Stop()
		soundObj:Play()
	end
end
