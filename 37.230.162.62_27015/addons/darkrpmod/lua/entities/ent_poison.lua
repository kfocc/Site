AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Отрава"
ENT.Category = "Повстанцы"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true
ENT.health = 50

if SERVER then
	function ENT:Initialize()
		if SERVER then
			self:SetModel("models/props_lab/jar01a.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetUseType(SIMPLE_USE)
			self:PhysWake()
		end
	end

	-- function ENT:FindFoodBox()
	-- 	local entsList = ents.FindInSphere(self:GetPos(), 50)
	-- 	for _, ent in ipairs(entsList) do
	-- 		if ent:GetClass() == "union_fooddispenser" then
	-- 			return ent
	-- 		end
	-- 	end
	-- end
	function ENT:ScanPoison(ply)
		local poisoner = self.poisoner
		if IsValid(poisoner) then
			if poisoner:Alive() and poisoner.poisoned then
				poisoner:PingPlayer(ply, "poison_id_" .. poisoner:SteamID(), 3, 20, "Отравитель еды", "error")
				ply:EmitSound("buttons/button1.wav", 45, 100, 1, CHAN_AUTO)
				DarkRP.notify(ply, 1, 4, "Вы нашли улики на отравителя.")
			else
				DarkRP.notify(ply, 1, 4, "Вы нашли улики на отравителя. Но он уже мёртв.")
			end
		else
			DarkRP.notify(ply, 0, 4, "Улик не найдено.")
		end

		self:Remove()
	end

	function ENT:Use(ply)
		if ply:Team() ~= TEAM_OBS then
			DarkRP.notify(ply, 1, 4, "Не стоит это трогать, вызовите MPF.OBS.")
			return
		end
	end

	function ENT:OnTakeDamage(dmg)
		if self.health then
			local iHealth = self.health - dmg:GetDamage() * 0.5
			if iHealth <= 0 then self:Remove() end
			self.health = iHealth
		end
	end
else
	local icon = Material("icon16/error.png")
	local text = "Отрава"
	function ENT:Draw(flags)
		self:DrawModel(flags)
		local distance, lim = self:GetPos():DistToSqr(EyePos()), 500 * 500
		if distance > lim then return end

		local pos = LocalToWorld(Vector(0, 0, 10), Angle(0, 90, 90), self:GetPos(), self:GetAngles())
		local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)

		cam.Start3D2D(pos, ang, 0.25)
		surface.SetDrawColor(255, 255, 255, 255)

		surface.SetMaterial(icon)
		surface.DrawTexturedRect(-5, -30, 16, 16)

		draw.SimpleText(text, "Items_Font", 0, -4, Color(15, 15, 15), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "Items_Font", 0, -5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
