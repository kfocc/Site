--[[-------------------------------------------------------------------------
-- PROPS and DOORS
---------------------------------------------------------------------------]]
local function getID(ent)
	return IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner() or ent:getDoorOwner()
end

local dist = 256
local function checkDistance(ent, ply, allowScan)
	return IsValid(ent) and (allowScan and IsValid(ply:GetLocalVar("Scanner"))) or ent:GetPos():Distance(ply:GetPos()) <= dist
end

properties.Add("prop_copy_sid", {
	MenuLabel = "Скопировать SteamID",
	Order = 0,
	MenuIcon = "icon16/page_copy.png",
	Filter = function(self, ent, ply) return IsValid(ent) and (IsValid(ent:CPPIGetOwner()) or IsValid(ent:getDoorOwner())) end,
	Action = function(self, ent)
		if not IsValid(ent) then
			DarkRP.notify(LocalPlayer(), 1, 4, "Предмет не найден")
			return
		end

		local ply = getID(ent)
		if not IsValid(ply) then
			DarkRP.notify(LocalPlayer(), 1, 4, "Владелец не найден")
			return
		end

		SetClipboardText(ply:SteamID())
	end
})

properties.Add("prop_warrant", {
	MenuLabel = "Запросить ордер",
	Order = 1,
	MenuIcon = "icon16/door_in.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply) and (IsValid(ent:CPPIGetOwner()) or IsValid(ent:getDoorOwner())) end,
	Action = function(self, ent) Derma_StringRequest("Запросить ордер на обыск владельца: " .. getID(ent):Name(), "Введите причину ордера", nil, function(text) RunConsoleCommand("darkrp", "warrant", getID(ent):UserID(), text) end) end
})

properties.Add("prop_wanted", {
	MenuLabel = "Объявить в розыск",
	Order = 2,
	MenuIcon = "icon16/flag_red.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply, true) and (IsValid(ent:CPPIGetOwner()) or IsValid(ent:getDoorOwner())) end,
	Action = function(self, ent) Derma_StringRequest("Обявить в розыск владельца: " .. getID(ent):Name(), "Введите причину розыска", nil, function(text) RunConsoleCommand("darkrp", "wanted", getID(ent):UserID(), text) end) end
})

properties.Add("prop_unwanted", {
	MenuLabel = "Прекратить розыск",
	Order = 3,
	MenuIcon = "icon16/flag_green.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply, true) and (IsValid(ent:CPPIGetOwner()) or IsValid(ent:getDoorOwner())) end,
	Action = function(self, ent) RunConsoleCommand("darkrp", "unwanted", getID(ent):UserID()) end
})

--[[-------------------------------------------------------------------------
-- PLAYERS
---------------------------------------------------------------------------]]
properties.Add("copy_sid", {
	MenuLabel = "Скопировать SteamID",
	Order = 0,
	MenuIcon = "icon16/page_copy.png",
	Filter = function(self, ent, ply) return IsValid(ent) and ent:IsPlayer() and ent:Alive() end,
	Action = function(self, ent)
		if not IsValid(ent) then
			DarkRP.notify(LocalPlayer(), 1, 4, "Игрок не найден")
			return
		end

		SetClipboardText(ent:SteamID())
	end
})

properties.Add("copy_cid", {
	MenuLabel = "Скопировать CID",
	Order = 0,
	MenuIcon = "icon16/page_copy.png",
	Filter = function(self, ent, ply) return IsValid(ent) and ent:IsPlayer() and ent:Alive() and not ent:GetNetVar("HideName") end,
	Action = function(self, ent)
		if not IsValid(ent) then
			DarkRP.notify(LocalPlayer(), 1, 4, "Игрок не найден")
			return
		end

		if ent:GetNetVar("HideName") then
			DarkRP.notify(LocalPlayer(), 1, 4, "Игрок в маске")
			return
		end

		SetClipboardText(ent:GetCID())
	end
})

properties.Add("warrant", {
	PrependSpacer = true,
	MenuLabel = "Запросить ордер",
	Order = 2,
	MenuIcon = "icon16/door_in.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply) and ent:IsPlayer() end,
	Action = function(self, ent) Derma_StringRequest("Запросить ордер на обыск: " .. ent:Name(), "Введите причину ордера", nil, function(text) RunConsoleCommand("darkrp", "warrant", ent:UserID(), text) end) end
})

properties.Add("wanted", {
	MenuLabel = "Объявить в розыск",
	Order = 3,
	MenuIcon = "icon16/flag_red.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply, true) and ent:IsPlayer() end,
	Action = function(self, ent) Derma_StringRequest("Обявить в розыск: " .. ent:Name(), "Введите причину розыска", nil, function(text) RunConsoleCommand("darkrp", "wanted", ent:UserID(), text) end) end
})

properties.Add("unwanted", {
	MenuLabel = "Прекратить розыск",
	Order = 4,
	MenuIcon = "icon16/flag_green.png",
	Filter = function(self, ent, ply) return ply:isCP() and checkDistance(ent, ply, true) and ent:IsPlayer() end,
	Action = function(self, ent) RunConsoleCommand("darkrp", "unwanted", ent:UserID()) end
})

properties.Add("give_money", {
	MenuLabel = "Передать деньги",
	Order = 1,
	MenuIcon = "icon16/money.png",
	Filter = function(self, ent, ply) return ply:Alive() and checkDistance(ent, ply) and ent:IsPlayer() and ent:Alive() end,
	Action = function(self, ent)
		local selfMaxMoney = LocalPlayer():getDarkRPVar("money", 0)
		local formattedAmount = DarkRP.formatMoney(selfMaxMoney)
		local sr = Derma_StringRequest("Введите сумму", "Введите сумму, которую хотите передать. От 100 до " .. formattedAmount, '', function(s)
			local int = tonumber(s)
			if not int or int < 100 or int > selfMaxMoney then
				local txt = "Сумма должна быть от 100 до " .. formattedAmount
				GAMEMODE:AddNotify(txt, 1, 4)
				surface.PlaySound("buttons/lightswitch2.wav")
				MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
				return
			end

			self:MsgStart()
			net.WriteEntity(ent)
			net.WriteUInt(int, 31)
			self:MsgEnd()
		end)

		local title = sr:GetTitle()
		sr:SetTitle("")
		sr.Paint = function(s, w, h)
			Derma_DrawBackgroundBlur(s, s.start)
			surface.SetDrawColor(col.ba)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(col.o)
			surface.DrawRect(0, 0, w, 24)

			draw.SimpleText(title, "DermaDefault", 8, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end,
	Receive = function(self, len, ply)
		-- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()
		if not IsValid(ent) then return false end
		if not self:Filter(ent, ply) then return false end

		local amount = net.ReadUInt(31)
		if not isnumber(amount) then return false end

		ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
		DarkRP.TransferMoney(ply, ent, amount, true)
	end
})

properties.Add("edit_bgroup", {
	MenuLabel = "Изменить бодигруппы",
	Order = 10,
	MenuIcon = "icon16/monkey.png",
	Filter = function(self, ent, ply)
		local is_valid = IsValid(ent) and ent:IsPlayer() and ent:Alive()
		local is_eventer = ply:IsEventer() and ply:Team() == TEAM_ADMIN
		local is_global_eventer = ply:IsGlobalEventer() or ply:IsSuperAdmin()
		return is_valid and (is_eventer or is_global_eventer)
	end,
	Action = function(self, ent)
		self:MsgStart()
		net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, len, ply)
		-- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()
		if not IsValid(ent) then return false end
		if not self:Filter(ent, ply) then return false end

		netstream.Start(ply, "EditBodygroups", ent)
	end
})

--[[-------------------------------------------------------------------------
-- PLAYERS
---------------------------------------------------------------------------]]
local dist = 200 * 200
local breakSounds = {
	"physics/wood/wood_crate_break1.wav",
"physics/wood/wood_crate_break2.wav",
"physics/wood/wood_crate_break3.wav",
"physics/wood/wood_crate_break4.wav",
"physics/wood/wood_crate_break5.wav",
"physics/wood/wood_furniture_break1.wav",
"physics/wood/wood_furniture_break2.wav",
"physics/wood/wood_panel_break1.wav",
"physics/wood/wood_plank_break1.wav",
"physics/wood/wood_plank_break2.wav",
"physics/wood/wood_plank_break3.wav",
"physics/wood/wood_plank_break4.wav"
}
local weps = {
	["tfa_nmrih_asaw"] = true,
	["tfa_nmrih_sledge"] = true,
	["tfa_nmrih_bcd"] = true,
	["tfa_nmrih_fubar"] = true,
	["tfa_nmrih_pickaxe"] = true
}

properties.Add("destroy_prop", {
	MenuLabel = "Разрушить",
	PrependSpacer = true,
	Order = 5000,
	MenuIcon = "icon16/flag_green.png",
	Filter = function(self, ent, ply)
		if not ply:Alive() then return false end

		if ply:Team() ~= TEAM_ALYX then return false end
		if ent:GetClass() ~= "prop_physics" then return false end
		if ent:GetPos():DistToSqr(ply:GetShootPos()) > dist then return false end

		local plyWep = ply:GetActiveWeapon()
		if not IsValid(plyWep) or not weps[plyWep:GetClass()] then return false end

		local owner = ent:CPPIGetOwner()
		if IsValid(owner) and (owner:isCP() and not owner:isRebel()) or owner:isRefugee() or owner:isBandit() or owner:isCitizen() then return true end

		return false
	end,
	Action = function(self, ent)
		self:MsgStart()
		net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, len, ply)
		-- The action to perform upon using the property ( Serverside )
		local ent = net.ReadEntity()
		if not IsValid(ent) then return false end
		if not self:Filter(ent, ply) then return false end
		local data = {
			delaytime = 5,
			check = function(_ply)
				if _ply:Team() ~= TEAM_ALYX then return false end
				if not _ply:Alive() or not IsValid(ent) or ent:GetPos():DistToSqr(_ply:GetShootPos()) > dist then return false end

				local plyWep = ply:GetActiveWeapon()
				if not IsValid(plyWep) or not weps[plyWep:GetClass()] then return false end

				local trace = _ply:GetEyeTraceNoCursor()
				if trace.Entity ~= ent then return false end
				return true
			end,
			onaction = function(_ply, _ent)
				_ply:EmitSound(breakSounds[math.random(#breakSounds)], 35, 100, 0.6)
				-- _ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
				_ply:SetAnimation(PLAYER_ATTACK1)
			end,
			onfinish = function(_ply)
				if IsValid(ent) then
					ent:Remove()
					_ply:EmitSound("physics/metal/metal_box_break" .. math.random(1, 2) .. ".wav", 35, 100, 0.6)
				end
			end
		}

		ply:AddAction("Разрушаем", data)
	end
})

properties.Add("robbery_player", {
	MenuLabel = "Ограбление",
	PrependSpacer = true,
	Order = 5000,
	MenuIcon = "icon16/gun.png",
	Filter = function(self, target, ply)
		if not ply:Alive() then return false end
		if not IsValid(target) or not target:IsPlayer() then return false end
		if not DarkRP.RobberyStuff:canShowMenu(ply, target) then return false end
		return true
	end,
	Action = function(self, target)
		local sr = Derma_StringRequest("Введите сумму", "Введите сумму ограбления. От 100 до 3000.", '', function(s)
			local int = tonumber(s)
			if not int or int < 100 or int > 3000 then
				local txt = "Сумма должна быть от 100 до 3000"
				GAMEMODE:AddNotify(txt, 1, 4)
				surface.PlaySound("buttons/lightswitch2.wav")
				MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
				return
			end

			self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(int, 12)
			self:MsgEnd()
		end)

		local title = sr:GetTitle()
		sr:SetTitle("")
		sr.Paint = function(s, w, h)
			Derma_DrawBackgroundBlur(s, s.start)
			surface.SetDrawColor(col.ba)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(col.o)
			surface.DrawRect(0, 0, w, 24)

			draw.SimpleText(title, "DermaDefault", 8, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end,
	Receive = function(self, len, ply)
		local target = net.ReadEntity()
		local int = tonumber(net.ReadUInt(12))
		if not int or int < 100 or int > 3000 then return end
		if not self:Filter(target, ply) then return false end
		DarkRP.RobberyStuff:startRobberry(ply, target, int)
	end
})

--[[-------------------------------------------------------------------------
-- ADMINS
---------------------------------------------------------------------------]]

properties.Add("open_warns", {
	MenuLabel = "Открыть предупреждения",
	PrependSpacer = false,
	Order = 9001,
	MenuIcon = "icon16/error.png",
	Filter = function(self, target, ply)
		if not ply:Alive() or ply:Team() ~= TEAM_ADMIN then return false end
		if not IsValid(target) or not target:IsPlayer() then return false end
		return true
	end,
	Action = function(self, target)
		RunConsoleCommand("ulx", "warnlist", "$" ..target:SteamID64())
	end
})

properties.Add("open_bans", {
	MenuLabel = "Открыть банлист",
	PrependSpacer = true,
	Order = 9000,
	MenuIcon = "icon16/lock.png",
	Filter = function(self, target, ply)
		if not ply:Alive() or ply:Team() ~= TEAM_ADMIN then return false end
		if not IsValid(target) or not target:IsPlayer() then return false end
		return true
	end,
	Action = function(self, target)
		gui.OpenURL("https://unionrp.info/hl2rp/bans/" .. target:SteamID64())
	end
})