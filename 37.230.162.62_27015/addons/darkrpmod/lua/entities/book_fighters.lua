AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Учебник по боксу"
ENT.Category = "UnionRP"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true

if SERVER then
	local booksModel = {"models/props_lab/binderredlabel.mdl"}
	--"models/props_lab/binderbluelabel.mdl",
	--"models/props_lab/bindergraylabel01a.mdl",
	--"models/props_lab/bindergreen.mdl",
	--"models/props_lab/bindergreenlabel.mdl",
	--"models/props_lab/binderredlabel.mdl"
	function ENT:Initialize()
		if SERVER then
			self:SetModel(booksModel[math.random(#booksModel)])
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetUseType(SIMPLE_USE)
			-- self:DropToFloor()
			self:PhysWake()
		end
	end

	local dist = 50 * 50
	function ENT:Use(ply)
		if ply:isOTA() or ply:isSynth() then return end
		local data = {
			delaytime = 30,
			check = function(client) return IsValid(self) and client:Alive() and client:GetPos():DistToSqr(self:GetPos()) <= dist end,
			onfinish = function(client)
				self:Remove()
				-- client:Give("weapon_fists")
				-- timer.Simple(1, function()
				-- 	if IsValid(client) then
				-- 		client:SelectWeapon("weapon_fists")
				-- 	end
				-- end)
				client._CanFight = true
			end
		}

		ply:AddAction("Изучаем учебник по боксу", data)
	end

	hook.Add("SpawnAfterDeath", "FighterSpawn", function(ply) if ply._CanFight then ply._CanFight = nil end end)
	hook.Add("CanPlayerKnock", "FighterArrest", function(ply) if ply:isArrested() then return false end end)
	hook.Add("GetPlayerPunchDamage", "FighterArrest", function(ply) if ply:isArrested() then return 0 end end)
else
	function ENT:Draw(flags)
		self:DrawModel(flags)
	end
end
