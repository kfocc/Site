include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/status_busy.png", "noclamp smooth")

function ENT:Draw(flags)
	self:SetSequence(self.NPCSequenceAnim)
	self:DrawModel(flags)

	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), self.NPCName, 256, col.w, self.NPCDesc, self.Icon)
end

local function GetPocketContraband(tbl)
	local contraband = {}
	local shipments = CustomShipments
	for k, v in pairs(tbl) do
		local class = v.class
		local pocket_info = Storage.pocketable[class]
		local is_alco = v.isAlco
		if not pocket_info.contraband and not is_alco then continue end
		local entity_class = is_alco or v.real_class or v.class
		if GAMEMODE.NoLicense[entity_class] then continue end
		local amount = v.amount or 1
		local price, name = 0, entity_class
		for _, shipment in ipairs(shipments) do
			if shipment.entity == entity_class then
				price = shipment.price * .5
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
				table.insert(contraband, {
					class = class,
					id = k,
					price = shipment.price * .5,
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
		local name = "Сдать " .. v.name .. " за " .. DarkRP.formatMoney(v.price)
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

				netstream.Start("take_illegal_npc.sellcontraband", npc, is_weapon, v.id)
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
			if not npc:CanSell(ply) then
				menu.SetText("Я занимаюсь скупкой контрабанды. Куда она идёт дальше - уже не твоё дело.")
			else
				menu.SetText("Чего ты хочешь от меня?")
			end
		end
	},
	{
		text = "Хочу продать контрабанду ( с рук )",
		check = function(ply, npc) return npc:CanSell(ply) end,
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
		text = "Хочу продать контрабанду ( из сумки )",
		check = function(ply, npc) return npc:CanSell(ply) end,
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
	}
}

function ENT:OnOpen()
	DialogSys.BeginDialogue(self, "Чем могу помочь?", buttons)
end
