AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Диспенсер рационов"
ENT.Category = "Альянс"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.PhysgunAllowAdmin = true
ENT.Money = 2500 -- Игровые деньги
ENT.NextTime = 1800 -- в секундах

local COLOR_RED = 1
local COLOR_ORANGE = 2
local COLOR_BLUE = 3
local COLOR_GREEN = 4

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "DispColor")
	self:NetworkVar("String", 1, "Text")
	self:NetworkVar("Bool", 0, "Disabled")
	self:NetworkVar("Bool", 0, "Busy")
	self:NetworkVar("Int", 1, "Amount")
end

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("rationdispencer")
	entity:SetPos(trace.HitPos)
	entity:SetAngles(trace.HitNormal:Angle())
	entity:Spawn()
	entity:Activate()
	return entity
end

function ENT:GetEmpty()
	return self:GetAmount() == 0
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_junk/gascan001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetText("Ожидаю CID")
		self:DrawShadow(false)
		self:SetDispColor(COLOR_GREEN)
		self:SetAmount(25)
		self.canUse = true

		self.dummy = ents.Create("prop_dynamic")
		self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
		self.dummy:SetPos(self:GetPos())
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:SetParent(self)
		self.dummy:Spawn()
		self.dummy:Activate()

		self:DeleteOnRemove(self.dummy)

		local physObj = self:GetPhysicsObject()
		if IsValid(physObj) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

if CLIENT then
	local mx = Matrix({{0.5615, 0, 0, 0}, {0, 1.4, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}})
	local color_white = color_white
	local color_black = color_black
	local function pretty(val)
		return (val < 10 and "0" .. val or val) .. "/50"
	end

	function ENT:Draw()
		local position, angles = self:GetPos(), self:GetAngles()

		angles:RotateAroundAxis(angles:Forward(), 90)
		angles:RotateAroundAxis(angles:Right(), 270)

		cam.Start3D2D(position + self:GetForward() * 7.6 + self:GetRight() * 8.5 + self:GetUp() * 3, angles, 0.1)
		render.PushFilterMag(TEXFILTER.POINT)
		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(0, 0, 66, 60)

		surface.SetAlphaMultiplier(math.abs(math.cos(RealTime() * 1.5)))
		draw.SimpleText(self:GetDisabled() and "Отключен" or self:GetEmpty() and "Пустой" or self:GetText() or "", "Default", 33, 0, color_white, 1, 0)
		surface.SetAlphaMultiplier(1)

		surface.SetDrawColor(colors[self:GetDisabled() and COLOR_RED or self:GetEmpty() and COLOR_ORANGE or self:GetDispColor()] or color_white)
		surface.DrawRect(4, 14, 58, 42)

		surface.SetDrawColor(60, 60, 60)
		surface.DrawOutlinedRect(4, 14, 58, 42)
		cam.PushModelMatrix(mx, true)
		surface.SetAlphaMultiplier(0.4)
		draw.SimpleText(pretty(self:GetAmount()), "Trebuchet48", 109, 1, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		surface.SetAlphaMultiplier(1)
		cam.PopModelMatrix()
		render.PopFilterMag()
		cam.End3D2D()
	end
else
	function ENT:setUseAllowed(state)
		self.canUse = state
	end

	function ENT:error(text)
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetText(text)
		self:SetDispColor(COLOR_RED)
		timer.Create("123noname_DispenserError" .. self:EntIndex(), 1.5, 1, function()
			if IsValid(self) then
				self:SetText("Вставьте CID")
				self:SetDispColor(COLOR_GREEN)
				timer.Simple(0.5, function()
					if not IsValid(self) then return end
					self:setUseAllowed(true)
				end)
			end
		end)
	end

	function ENT:createRation(activator)
		local entity = ents.Create("prop_physics")
		entity:SetAngles(self:GetAngles())
		entity:SetModel("models/weapons/w_package.mdl")
		entity:SetPos(self:GetPos())
		entity:Spawn()
		entity:SetNotSolid(true)
		entity:SetParent(self.dummy)
		entity:Fire("SetParentAttachment", "package_attachment")
		timer.Simple(1.2, function()
			if IsValid(self) and IsValid(entity) then
				entity:Remove()
				activator:Give("rationswep")
				self:SetNW2Bool(activator:SteamID() .. "_Gived", true)
				timer.Create(activator:SteamID() .. "_123noname_DispenserTimeOut_" .. self:EntIndex(), self.NextTime, 1, function() if activator:IsValid() then self:SetNW2Bool(activator:SteamID() .. "_Gived", false) end end)
			end
		end)
	end

	function ENT:dispense(amount, activator)
		self:setUseAllowed(false)
		self:SetText("Выдаю")
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
		self:createRation(activator)
		self.dummy:Fire("SetAnimation", "dispense_package", 0)
		local iAmount = self:GetAmount() - 1
		self:SetAmount(iAmount)
		if iAmount == 0 then
			local eTarget = ents.FindByClass("gsr_courier_target")[1]
			if not IsValid(eTarget) then return end
			local rcp = RecipientFilter()
			local iGST3, iGST6 = TEAM_GSR3, TEAM_GSR6
			for k, v in player.Iterator() do
				local iTeam = v:Team()
				if iTeam == iGST3 or iTeam == iGST6 then rcp:AddPlayer(v) end
			end

			local sMarkName = "rationdispencer_" .. self:EntIndex()
			Marks:AddMark(rcp, "Требуется пополнение диспенсера рационов. Отнесите эти коробки на вокзал!", sMarkName, eTarget:GetPos(), 120, "add", "Friends/message.wav")
			timer.Create(sMarkName, 120, 0, function()
				local eTarget = ents.FindByClass("gsr_courier_target")[1]
				if not IsValid(eTarget) then timer.Remove(sMarkName) end
				local rcp = RecipientFilter()
				for _, v in player.Iterator() do
					local iTeam = v:Team()
					if iTeam == iGST3 or iTeam == iGST6 then rcp:AddPlayer(v) end
				end

				Marks:AddMark(rcp, "Требуется пополнение диспенсера рационов. Отнесите эти коробки на вокзал!", sMarkName, eTarget:GetPos(), 120, "add", "Friends/message.wav")
			end)
		end

		timer.Simple(3.5, function()
			if IsValid(self) then
				self:SetText("Ждите...")
				self:SetDispColor(COLOR_ORANGE)
				self:EmitSound("buttons/combine_button7.wav")
				timer.Simple(7, function()
					if not IsValid(self) then return end
					self:SetText("Рацион")
					self:SetDispColor(COLOR_GREEN)
					self:EmitSound("buttons/combine_button1.wav")
					timer.Simple(0.75, function()
						if not IsValid(self) then return end
						self:setUseAllowed(true)
					end)
				end)
			end
		end)
	end

	function ENT:Use(activator)
		if (self.nextUse or 0) >= CurTime() then return end
		if activator:isCitizen() or activator:isGSR() or activator:isLoyal() or activator:Team() == TEAM_CITIZEN then
			if not self.canUse or self:GetDisabled() then return end
			if activator:GetNetVar("Rac.HasRation", 0) > 0 then
				local count = activator:GetNetVar("Rac.HasRation")
				activator:SetLocalVar("Rac.HasRation", nil)
				self:setUseAllowed(false)
				self:SetText("Получение")
				self:SetDispColor(COLOR_BLUE)
				self.dummy:Fire("SetAnimation", "dispense_package", 0)
				self:EmitSound("ambient/machines/combine_terminal_idle3.wav")
				self:SetAmount(self:GetAmount() + count)
				local money = count * 160 -- Count - рандом от 5 до 15, то есть макс сумма - 2400 за раз
				activator:addMoney(money, "Пополнение рациона")
				DarkRP.notify(activator, 3, 4, "Вы получили " .. DarkRP.formatMoney(money) .. " за пополнение рациона")
				SetGlobalInt("Rac.Count.Transported", GetGlobalInt("Rac.Count.Transported", 1) - count)
				timer.Simple(5, function()
					self:SetText("Принято")
					self:EmitSound("buttons/button14.wav", 100, 50)
					timer.Simple(1, function()
						self:SetText("Вставьте CID")
						self:SetDispColor(COLOR_GREEN)
						self:setUseAllowed(true)
					end)
				end)

				--self:EmitSound("buttons/combine_button_locked.wav")
				local sMarkName = "rationdispencer_" .. self:EntIndex()
				Marks:RemoveMark(nil, sMarkName)
				timer.Remove(sMarkName)
				return
			end

			if activator:GetActiveWeapon():GetClass() ~= "cid_new" then
				self:setUseAllowed(false)
				self:SetText("Проверяю")
				self:SetDispColor(COLOR_BLUE)
				self:EmitSound("ambient/machines/combine_terminal_idle2.wav")
				self:error("Нужна CID")
				--self:EmitSound("buttons/combine_button_locked.wav")
				return
			end

			self:setUseAllowed(false)
			self:SetText("Проверяю")
			self:SetDispColor(COLOR_BLUE)
			self:EmitSound("ambient/machines/combine_terminal_idle2.wav")
			timer.Simple(1, function()
				if not IsValid(self) or not IsValid(activator) then return self:setUseAllowed(true) end
				if self:GetNW2Bool(activator:SteamID() .. "_Gived", false) then
					return self:error("Ошибка")
				elseif self:GetEmpty() then
					return self:error("Пусто")
				else
					self:SetText("Принято")
					self:EmitSound("buttons/button14.wav", 100, 50)
					timer.Simple(1, function() if IsValid(self) then self:dispense(0, activator) end end)
				end
			end)
			-- elseif activator:getJobTable().cmd and activator:isCP() then
			--   self:SetDisabled(!self:GetDisabled())
			--   self:EmitSound(self:GetDisabled() and "buttons/combine_button1.wav" or "buttons/combine_button2.wav")
			--   self.nextUse = CurTime() + 1
		end
	end

	function ENT:OnRemove()
	end

	function ENT:Hack(ply)
		self._nextHack = CurTime() + 900
		local reward = math.random(1000, 3000)
		ply:addMoney(reward, "Взлом рационника")
		ply:setSelfDarkRPVar("Energy", 100)
		DarkRP.notify(ply, 2, 4, "Теперь вы сыты и получили: " .. DarkRP.formatMoney(reward))
		if not ply:GetNetVar("HideName") then ply:wanted(nil, "Взлом рационника", GAMEMODE.Config.wantedtime) end
		local rcp = RecipientFilter()
		for k, v in player.Iterator() do
			if v:isCP() and not v:isRebel() then rcp:AddPlayer(v) end
		end

		Marks:AddMark(rcp, "!!ВЗЛОМ РАЦИОННИКА!!", nil, self:GetPos(), 30, "error", "npc/metropolice/vo/on2.wav")
	end
end
