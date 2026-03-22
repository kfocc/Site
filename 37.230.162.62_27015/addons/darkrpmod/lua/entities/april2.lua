ENT.Type = "anim"
ENT.Base = "april"
ENT.PrintName = "April 2"
ENT.Author = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "UnionRP"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
	AddCSLuaFile()

	function ENT:Use(ply)
		local data = {
			delaytime = 5,
			check = function(_ply) return IsValid(self) and _ply:GetEyeTraceNoCursor().Entity == self end,
			onaction = function(_ply) _ply:EmitSound("buttons/blip1.wav", 35, 100, 0.6) end,
			onfail = function(_ply) end,
			onfinish = function(_ply)
				local exploeffect = EffectData()
				exploeffect:SetRadius(50)
				exploeffect:SetOrigin(self:GetPos())
				exploeffect:SetStart(self:GetPos())
				util.Effect("Explosion", exploeffect, true, true)
				local shake = ents.Create("env_shake")
				shake:SetOwner(self)
				shake:SetPos(self:GetPos())
				shake:SetKeyValue("amplitude", "50")
				shake:SetKeyValue("radius", "250")
				shake:SetKeyValue("duration", "4")
				shake:SetKeyValue("frequency", "255")
				shake:SetKeyValue("spawnflags", "4")
				shake:Spawn()
				shake:Activate()
				shake:Fire("StartShake", "", 0)
				local push = ents.Create("env_physexplosion")
				push:SetOwner(self)
				push:SetPos(self:GetPos())
				push:SetKeyValue("magnitude", 600)
				push:SetKeyValue("radius", 50)
				push:SetKeyValue("spawnflags", 2 + 16)
				push:Spawn()
				push:Activate()
				push:Fire("Explode", "", 0)
				push:Fire("Kill", "", .25)
				self:EmitSound(Sound("C4.Explode"))
				util.BlastDamage(self, self, self:GetPos(), 60, 1000)
				self:Remove()
			end
		}

		ply:AddAction("Открываем", data)
	end
end
