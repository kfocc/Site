if SERVER then AddCSLuaFile("ent_c4.lua") end

ENT.Type = "anim"
ENT.PrintName = "C4"
ENT.Spawnable = false
ENT.Category = "UnionRP"
ENT.nonfreeze = true
ENT.nofreeze = true

local models = {"models/props_junk/cardboard_box003a.mdl", "models/props_c17/SuitCase001a.mdl", "models/props_junk/cardboard_box004a.mdl", "models/props_junk/plasticbucket001a.mdl", "models/props_c17/BriefCase001a.mdl", "models/props_interiors/pot01a.mdl", "models/props_lab/citizenradio.mdl", "models/props_lab/jar01a.mdl", "models/props_lab/reciever01b.mdl", "models/props_junk/garbage_bag001a.mdl", "models/props_c17/SuitCase_Passenger_Physics.mdl",}
function ENT:Initialize()
	if SERVER then
		self:SetMode(0)
		self:SetModel(models[math.random(1, #models)])
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
		self:SetStartTime(CurTime())
		self:SetTimeToExplode(300)
		timer.Simple(self:GetTimeToExplode(), function()
			if IsValid(self) then
				self:Explosion()
			else
				return
			end
		end)

		timer.Create(self:EntIndex() .. "explode_sound", 1, self:GetTimeToExplode(), function()
			if not IsValid(self) then return timer.Remove(self:EntIndex() .. "explode_sound") end
			self:EmitSound("C4.PlantSound")
		end)
	end

	self:EmitSound("C4.Plant")
	hook.Run("Bomb.Planted", self)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Int", 1, "StartTime")
	self:NetworkVar("Int", 2, "TimeToExplode")
	self:NetworkVar("Bool", 0, "Defusing")
end

if CLIENT then
	function ENT:Draw(flags)
		self:DrawModel(flags)
		if self:GetMode() == 1 then
			if IsValid(self) then
				local Pos = self:GetPos() + self:GetUp() * 9 + self:GetForward() * 4.05 + self:GetRight() * 4.40
				local Ang = self:GetAngles()
				local starttime = self:GetStartTime()
				local toexplode = starttime + self:GetTimeToExplode()
				local TimeEnd = math.floor(math.abs(CurTime() - toexplode))
				local ply = LocalPlayer()
				if ply:GetPos():Distance(self:GetPos()) <= 200 then
					Ang:RotateAroundAxis(Ang:Up(), -90)
					cam.Start3D2D(Pos, Ang, 0.15)
					if self:GetDefusing() == true then
						local text = math.random(1, 9) .. "" .. math.random(1, 9) .. "" .. math.random(1, 9) .. "" .. math.random(1, 9)
						draw.DrawText(tostring(text), "Default", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
					else
						draw.DrawText(string.FormattedTime(TimeEnd, "%2i:%02i"), "Default", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
					end

					cam.End3D2D()
				end
			end
		end
	end
else
	function ENT:Use(ply)
		if not ply:isCP() or self:GetDefusing() == true then return end
		if self:GetMode() == 0 then
			DarkRP.notify(ply, 2, 4, "Вы нашли и демаскировали бомбу! Начинайте разминирование!")
			self:SetModel("models/weapons/w_c4_planted.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
			self:PhysWake()
			self:SetMode(1)
		elseif self:GetMode() == 1 then
			if self:GetPos():Distance(ply:GetPos()) > 100 or not ply:Alive() then return end
			DarkRP.notify(ply, 2, 4, "Вы начали разминирование.")
			local i = 0
			local chance = 0
			if ply:isOTA() or ply:isSynth() or ply:Team() == TEAM_MPF7 then
				chance = 0
			else
				chance = math.random(1, 2)
			end

			if chance == math.random(1, 2) then
				timer.Simple(1, function()
					self:Explosion()
					DarkRP.notify(ply, 1, 4, "Вы не смогли разминировать бомбу и взорвались.")
					ply:Freeze(false)
				end)
			else
				--self.SetDefusing = true
				ply:Freeze(true)
				self:SetDefusing(true)
				self:GetPhysicsObject():EnableMotion(false)
				if IsValid(self) and ply:Alive() and ply:isCP() then
					hook.Run("Bomb.Defuse", ply)
					timer.Create("DefuseBomb" .. self:EntIndex(), 1, 16, function()
						if IsValid(self) then
							if self:GetPos():Distance(ply:GetPos()) > 100 or not ply:Alive() then
								self:SetDefusing(false)
								ply:Freeze(false)
								timer.Remove("DefuseBomb" .. self:EntIndex())
								self:Explosion()
								return
							end

							i = i + 1
							self:EmitSound("weapons/357/357_reload1.wav")
							if i >= 15 then
								ply:Freeze(false)
								self:Remove()
								--self:SetNW2Bool("Defusing", false)
								DarkRP.notify(ply, 3, 4, "Вы успешно разминировали бомбу и получили награду.")
								ply:addMoney(15000)
								hook.Run("Bomb.Defused", ply)
							end
						else
							ply:Freeze(false)
							return timer.Remove("DefuseBomb" .. self:EntIndex())
						end
					end)
				else
					return
				end
			end
		end
	end

	function ENT:Explosion()
		if not IsValid(self) then return end
		--for k,v in player.Iterator() do
		--	if v:isCP() and v:Team() != TEAM_MAYOR then v:EmitSound("radio/terwin.wav") end
		--end
		local ItemOwner = self.ItemOwner or self
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetRadius(5000)
		effectdata:SetMagnitude(1500)
		util.Effect("HelicopterMegaBomb", effectdata)

		local exploeffect = EffectData()
		exploeffect:SetOrigin(self:GetPos())
		exploeffect:SetStart(self:GetPos())
		util.Effect("Explosion", exploeffect, true, true)

		local shake = ents.Create("env_shake")
		shake:SetOwner(ItemOwner)
		shake:SetPos(self:GetPos())
		shake:SetKeyValue("amplitude", "500")
		shake:SetKeyValue("radius", "5000")
		shake:SetKeyValue("duration", "4")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

		local push = ents.Create("env_physexplosion")
		push:SetOwner(ItemOwner)
		push:SetPos(self:GetPos())
		push:SetKeyValue("magnitude", 6000)
		push:SetKeyValue("radius", 1000)
		push:SetKeyValue("spawnflags", 2 + 16)
		push:Spawn()
		push:Activate()
		push:Fire("Explode", "", 0)
		push:Fire("Kill", "", .25)

		self:EmitSound(Sound("C4.Explode"))
		hook.Run("Bomb.Defused", self)

		util.BlastDamage(self, ItemOwner, self:GetPos(), 500, 200)

		self:Remove()
	end
end
