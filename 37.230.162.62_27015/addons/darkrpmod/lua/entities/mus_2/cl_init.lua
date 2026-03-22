include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/status_busy.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)

	if self:GetNW2Bool("robbery") then
		self:SetSequence(6)
	else
		self:SetSequence(11)
	end

	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Прием контрабанды", 256, col.w, "Контрабанда в обмен на ОЛ", self.Icon)
end

local function GetPocketContraband(tbl)
	local contraband = {}
	local shipments = CustomShipments
	for k, v in pairs(tbl) do
		local class = v.class
		local pocket_info = Storage.pocketable[class]
		if not pocket_info.contraband and not v.isAlco then continue end
		local entity_class = v.isAlco or v.real_class or v.class
		if GAMEMODE.NoLicense[entity_class] then continue end
		local amount = v.amount or 1
		local price, name = 0, entity_class
		for _, shipment in ipairs(shipments) do
			if shipment.entity == entity_class then
				price = math.max(1, math.ceil(shipment.price / 1000))
				name = shipment.name
			end
		end

		for i = 1, amount do
			table.insert(contraband, {
				class = entity_class,
				id = k,
				price = price,
				name = name
			})
		end
	end
	return contraband
end

local function GetWeaponsContraband(tbl)
	local contraband = {}
	local shipments = CustomShipments
	for k, v in ipairs(tbl) do
		local class = v:GetClass()
		if GAMEMODE.NoLicense[class] then continue end
		for _, shipment in ipairs(shipments) do
			if shipment.entity == class then
				local price = math.max(1, math.ceil(shipment.price / 1000))
				table.insert(contraband, {
					class = class,
					id = k,
					price = price,
					name = shipment.name
				})
			end
		end
	end
	return contraband
end

local function MakeButtons(tbl, npc, is_weapon)
	local buttons = {}
	for k, v in ipairs(tbl) do
		local name = "Сдать " .. v.name .. " за " .. v.price .. " ОЛ"
		table.insert(buttons, {
			text = name,
			func = function(npc, menu)
				for but_id, but in ipairs(buttons) do
					if but.text == name then
						table.remove(buttons, but_id)
						menu.SetButtons(buttons)
						break
					end
				end

				netstream.Start("mus_2.sellcontraband", npc, is_weapon, v.id)
			end
		})
	end
	return buttons
end

local buttons = {
	{
		text = "Кто ты?",
		func = function(npc, menu)
			local ply = LocalPlayer()
			if ply:isCitizen() or ply:isLoyal() or ply:isGSR() then
			if ply:Team() == TEAM_BICH1 or ply:Team() == TEAM_VORT then
				menu.SetText("С тобой я даже разговаривать не собираюсь.")
			elseif ply:isGang() then
				menu.SetText("Ты какой-то подозрительный. Не хочу с тобой иметь дело.")
			elseif ply:isCitizen() or ply:isLoyal() or ply:isGSR() then
				menu.SetText("Я занимаюсь приёмом контрабанды. За Вашу преданность Альянсу можно получить очки лояльности.")
			else
				menu.SetText("Я занимаюсь приёмом контрабанды. Но с тобой у меня разговор короткий.")
			end
		end
		end,
	},
	{
		text = "Хочу сдать контрабанду ( с рук )",
		check = function(ply, npc)
			if ply:isGang() then return false end
			if ply:Team() == TEAM_BICH1 or ply:Team() == TEAM_VORT then return end

			return ply:isCitizen() or ply:isLoyal() or ply:isGSR()
		end,
		func = function(npc, menu)
			local ply = LocalPlayer()
			local pocket = ply:GetWeapons()
			local contraband = GetWeaponsContraband(pocket)
			if #contraband == 0 then
				menu.SetText("У тебя нет контрабанды.")
				return
			end

			local contraband_buttons = MakeButtons(contraband, npc, true)
			menu.SetButtons(contraband_buttons)
		end
	},
	{
		text = "Хочу сдать контрабанду ( из сумки )",
		check = function(ply, npc)
			if ply:isGang() then return false end
			if ply:Team() == TEAM_BICH1 or ply:Team() == TEAM_VORT then return end

			return ply:isCitizen() or ply:isLoyal() or ply:isGSR()
		end,
		func = function(npc, menu)
			local ply = LocalPlayer()
			local weapon = ply:GetActiveWeapon()
			if not IsValid(weapon) or weapon:GetClass() ~= "pocket" then
				menu.SetText("Хорошо, бери сумку в руки и поговорим.")
				return
			end

			local pocket = ply:getPocketItems()
			local contraband = GetPocketContraband(pocket)
			if #contraband == 0 then
				menu.SetText("У тебя нет контрабанды.")
				return
			end

			local contraband_buttons = MakeButtons(contraband, npc, false)
			menu.SetButtons(contraband_buttons)
		end
	},
	{
		text = "Давай сюда свои токены!",
		func = function(npc, menu)
			if npc:GetNW2Bool("Robbery") then
				menu.SetText("Не трогайте меня, у меня ничего нет! Меня недавно грабили!")
				return
			end

			netstream.Start("NPC.Robbery", npc)
			menu:Remove()
		end,
		check = function(ply, npc) return ply:HasGun() and (ply:isGang() or ply:isRebel() or ply:isRefugee() or ply:Team() == TEAM_AFERIST) end
	}
}

function ENT:OnOpen()
	DialogSys.BeginDialogue(self, "Чем могу помочь?", buttons)
end