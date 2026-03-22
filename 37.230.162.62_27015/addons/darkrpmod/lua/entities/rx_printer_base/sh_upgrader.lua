RXP_Tuners = {}
local CheckLocalUpgrades = RXPrinters_Config.CheckLocalUpgrades
if SERVER then
	hook.Add("KeyPress", "RXPrinter Upgrade", function(ply, key)
		if key == 8192 then
			local TR = ply:GetEyeTrace()
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and wep:GetClass() == "hl2_hands" and IsValid(wep.heldEntity) then return end
			if TR.Hit and TR.Entity and TR.Entity:IsValid() and TR.Entity.RXPrinter and TR.Entity:GetPos():Distance(ply:GetPos()) < 300 then TR.Entity:OpenTuneGUI(ply) end
		end
	end)
end

if SERVER then
	function ENT:SetTuneLevel(luaname, amount)
		self.TuneLevel[luaname] = amount
		self:SetNetVar("tlv_" .. luaname, amount)
	end

	function ENT:AddTuneLevel(luaname, amount)
		local A = self:GetTuneLevel(luaname)
		A = A + amount
		A = math.max(A, 0)
		self:SetTuneLevel(luaname, A)
	end
end

function ENT:GetTuneLevel(luaname)
	return self:GetNetVar("tlv_" .. luaname, 0)
end

function RXP_Tuners_CreateStruct(LuaName)
	local STR = {}
	STR.LuaName = LuaName
	STR.MaxLevel = 5
	STR.Price = 100
	STR.PrintName = "Tune"
	STR.Description = "Description"
	function STR:OnBuy(ply, printer, newlevel)
	end

	function STR:Regist()
		RXP_Tuners[self.LuaName] = self
	end
	return table.Copy(STR)
end

function RXPTunerElement_Include()
	local path = ENT.Folder .. "/upgrade/"
	for _, file in pairs(file.Find(ENT.Folder .. "/upgrade/*.lua", "LUA")) do
		if SERVER then AddCSLuaFile(path .. file) end
		include(path .. file)
		-- MsgN(path .. file)
	end
end

RXPTunerElement_Include()
--=============================//
if SERVER then
	util.AddNetworkString("RXP_OpenTuneGUI_S2C")
	util.AddNetworkString("RXP_OpenAccessGUI_S2C")
	util.AddNetworkString("RXP_ApplyTune_C2S")
	util.AddNetworkString("RXP_ApplyTune_C2SAll")
	util.AddNetworkString("RXP_AccessAction_C2S")
	function ENT:OpenTuneGUI(ply)
		net.Start("RXP_OpenTuneGUI_S2C")
		net.WriteTable({
			Ent = self,
			Stat = self.Stats,
			DefaultStat = self.Stats_Default,
			Boosts = self.Boosts,
			TuneLevel = self.TuneLevel
		})

		net.Send(ply)
	end

	function ENT:OpenAccessGUI(ply)
		net.Start("RXP_OpenAccessGUI_S2C")
		net.WriteTable(self.CoOwners)
		net.Send(ply)
	end

	local validActions = {
		add = function(ent, ply)
			local sid = net.ReadString()
			if not isstring(sid) then return end
			local target = player.GetBySteamID(sid)
			if not target then
				DarkRP.notify(ply, 2, 4, "Игрок не найден!")
				return
			end

			if target == ply then
				DarkRP.notify(ply, 2, 4, "Вы не можете добавить себя!")
				return
			end

			local entCoOwners = ent.CoOwners
			if entCoOwners[sid] then
				DarkRP.notify(ply, 2, 4, "У '" .. target:Name() .. "' уже есть доступ к этому принтеру!")
				return
			end

			entCoOwners[sid] = true
			DarkRP.notify(ply, 1, 4, "Вы добавили '" .. target:Name() .. "' доступ к '" .. ent.PrinterName .. "'.")
		end,
		delete = function(ent, ply)
			local sid = net.ReadString()
			if not isstring(sid) then return end
			local target = player.GetBySteamID(sid)
			if not target then
				DarkRP.notify(ply, 2, 4, "Игрок не найден!")
				return
			end

			if target == ply then
				DarkRP.notify(ply, 2, 4, "Вы не можете удалить себя!")
				return
			end

			local entCoOwners = ent.CoOwners
			if not entCoOwners[sid] then
				DarkRP.notify(ply, 2, 4, "У '" .. target:Name() .. "' нет доступа к этому принтеру!")
				return
			end

			entCoOwners[sid] = nil
			DarkRP.notify(ply, 1, 4, "Вы забрали у '" .. target:Name() .. "' доступ к '" .. ent.PrinterName .. "'.")
		end,
		clear = function(ent, ply)
			local entCoOwners = ent.CoOwners
			if table.IsEmpty(entCoOwners) then
				DarkRP.notify(ply, 2, 4, "Никто не имеет легального доступа к этому принтеру, кроме Вас.")
				return
			end

			table.Empty(entCoOwners)
			DarkRP.notify(ply, 1, 4, "Вы забрали у всех доступ к '" .. ent.PrinterName .. "'.")
		end
	}

	net.Receive("RXP_AccessAction_C2S", function(len, ply)
		local trEntity = ply:GetEyeTrace().Entity
		if not IsValid(trEntity) or not trEntity.RXPrinter or trEntity:GetPrinterOwner() ~= ply then
			DarkRP.notify(ply, 2, 4, "Вам нужно смотреть на Ваш принтер.")
			return
		end

		local action = net.ReadString()
		if not isstring(action) then return end
		local actionFunc = validActions[action]
		if not actionFunc then return end
		actionFunc(trEntity, ply)
	end)

	net.Receive("RXP_ApplyTune_C2S", function(len, ply)
		local TB = net.ReadTable()
		if not istable(TB) then return end
		local Ent = TB.Ent
		if Ent then Ent = ents.GetByIndex(Ent) end
		if not IsValid(Ent) or not Ent.RXPrinter then
			local trentity = ply:GetEyeTrace().Entity
			if not IsValid(trentity) or not trentity.RXPrinter then
				DarkRP.notify(ply, 2, 5, "Принтер не найден или что-то пошло не так.")
				return
			else
				Ent = trentity
			end
		end

		local StatLuaName = TB.StatLuaName
		local STB = RXP_Tuners[StatLuaName]
		if not STB then
			DarkRP.notify(ply, 2, 5, "Что-то пошло не так.")
			return
		end

		local localUpgrades = Ent.Upgrades[StatLuaName]
		if localUpgrades == false then
			DarkRP.notify(ply, 2, 5, "Данная модификация отключена на этом принтере!")
			return
		end

		local price, maxLevel = STB.Price, STB.MaxLevel
		if localUpgrades then
			price = localUpgrades.Price
			maxLevel = localUpgrades.MaxLevel
		end

		if not ply:canAfford(price) then
			DarkRP.notify(ply, 2, 5, "Не хватает токенов!")
			return
		end

		local currentLevel = Ent:GetTuneLevel(StatLuaName)
		if currentLevel >= maxLevel then
			DarkRP.notify(ply, 2, 5, "Уже максимум!")
			return
		end

		ply:addMoney(-price, "Улучшение принтера")
		STB:OnBuy(ply, Ent, currentLevel + 1, true)
		Ent:AddTuneLevel(StatLuaName, 1)
		Ent:OpenTuneGUI(ply)
		DarkRP.notify(ply, 1, 4, "Вы улучшили принтер за " .. price .. " токенов!")
	end)

	net.Receive("RXP_ApplyTune_C2SAll", function(len, ply)
		if not RXP_Tuners then return end
		local Ent = net.ReadEntity()
		if not IsValid(Ent) or not Ent.RXPrinter then -- DarkRP.notify(ply, 2, 5, "Error : Printer is missing or something is wrong. " .. Ent:GetClass())
			return
		end

		local tbl = Stack()
		local price = 0
		local tunName = net.ReadString()
		local tunInfo = RXP_Tuners[tunName]
		local toUpdate = false
		if not tunInfo then
			for name, data in pairs(RXP_Tuners) do
				local isRestricted, localPrice, localMaxLevel = CheckLocalUpgrades(Ent, name)
				if isRestricted then continue end
				local curLevel, maxLevel = Ent:GetTuneLevel(name), localMaxLevel or data.MaxLevel
				if curLevel < maxLevel then
					local needLevel = maxLevel - curLevel
					tbl:Push(name)
					price = price + needLevel * (localPrice or data.Price)
					toUpdate = true
				end
			end
		else
			local isRestricted, localPrice, localMaxLevel = CheckLocalUpgrades(Ent, tunName)
			if isRestricted then
				DarkRP.notify(ply, 2, 5, "Данная модификация отключена на этом принтере!")
				return
			end

			local curLevel, maxLevel = Ent:GetTuneLevel(tunName), localMaxLevel or tunInfo.MaxLevel
			if curLevel < maxLevel then
				local needLevel = maxLevel - curLevel
				tbl:Push(tunName)
				price = price + (localPrice or tunInfo.Price) * needLevel
				toUpdate = true
			end
		end

		if not ply:canAfford(price) then
			local divide = math.floor(price - (ply:getDarkRPVar("money") or 0))
			DarkRP.notify(ply, 2, 5, "Не хватает " .. divide .. " токенов!")
			return
		end

		if not toUpdate then
			DarkRP.notify(ply, 2, 5, "Нет улучшений для этого принтера!")
			return
		end

		ply:addMoney(-price, "Полное или модульное улучшение принтера")
		for i = 1, tbl:Size() do
			local name = tbl[i]
			local cfg = RXP_Tuners[name]
			local _, _, localMaxlevel = CheckLocalUpgrades(Ent, name)
			local maxLevel = localMaxlevel or cfg.MaxLevel
			cfg:OnBuy(ply, Ent, maxLevel)
			Ent:SetTuneLevel(name, maxLevel)
		end

		Ent:OpenTuneGUI(ply)
		DarkRP.notify(ply, 1, 4, "Вы улучшили принтер за " .. price .. " токенов!")
	end)
else
	net.Receive("RXP_OpenTuneGUI_S2C", function(len, ply)
		local TB = net.ReadTable()
		local Ent = TB.Ent
		local Stat = TB.Stat
		local DefaultStat = TB.DefaultStat
		local Boosts = TB.Boosts
		if RXP_PrinterPanel and RXP_PrinterPanel:IsValid() then RXP_PrinterPanel:Remove() end
		if RXP_PrinterAccessPanel and RXP_PrinterAccessPanel:IsValid() then RXP_PrinterAccessPanel:Remove() end
		RXP_PrinterPanel = vgui.Create("RXP_PrinterPanel")
		RXP_PrinterPanel:SetSize(750, 400)
		RXP_PrinterPanel:Center()
		RXP_PrinterPanel:SetUp(Ent, Stat, DefaultStat, Boosts, TB)
		RXP_PrinterPanel:MakePopup()
	end)

	function RXP_DoUpgrade(Ent, StatLuaName)
		net.Start("RXP_ApplyTune_C2S")
		net.WriteTable({
			Ent = Ent:EntIndex(),
			StatLuaName = StatLuaName
		})

		net.SendToServer()
	end

	local sscale = util.SScale
	net.Receive("RXP_OpenAccessGUI_S2C", function(len, ply)
		local CoOwners = net.ReadTable()
		if RXP_PrinterPanel and RXP_PrinterPanel:IsValid() then RXP_PrinterPanel:Remove() end
		if RXP_PrinterAccessPanel and RXP_PrinterAccessPanel:IsValid() then RXP_PrinterAccessPanel:Remove() end
		RXP_PrinterAccessPanel = vgui.Create("RXP_PrinterAccessPanel")
		RXP_PrinterAccessPanel:SetSize(sscale(300), sscale(400))
		RXP_PrinterAccessPanel:Center()
		RXP_PrinterAccessPanel:SetUp(CoOwners)
		RXP_PrinterAccessPanel:MakePopup()
	end)
end
