local ignore_mask = CreateClientConVar("unionrp_ignore_mask", "0", true)
local blur = Material("pp/blurscreen")
local mWheelMat = Material( "gui/mwheel.png" )

function kblur(panel, layers, density, alpha)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / layers) * density)
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end

local teams = {
	[TEAM_GFAST] = true,
	[TEAM_GSPY] = true,
	[TEAM_AGENT] = true,
	[TEAM_ELITE4] = true
}

local ranknames = {
	["user"] = {
		name = "Игрок",
		icon = "icon16/user.png"
	},
	["vip"] = {
		name = "VIP",
		icon = "icon16/ruby.png"
	},
	["operator"] = {
		name = "Оператор",
		icon = "icon16/medal_bronze_1.png"
	},
	["moderator"] = {
		name = "Модератор",
		icon = "icon16/medal_silver_1.png"
	},
	["administrator"] = {
		name = "Администратор",
		icon = "icon16/medal_gold_1.png"
	},
	["administrator_custom"] = {
		name = "Администратор",
		icon = "icon16/medal_gold_2.png"
	},
	["operator_nabor"] = {
		name = "[Н] Оператор",
		icon = "icon16/medal_bronze_2.png"
	},
	["moderator_nabor"] = {
		name = "[Н] Модератор",
		icon = "icon16/medal_silver_2.png"
	},
	["administrator_nabor"] = {
		name = "[Н] Администратор",
		icon = "icon16/medal_gold_2.png"
	},
	["head_admin_nabor"] = {
		name = "[Н] Смотритель",
		icon = "icon16/award_star_bronze_2.png"
	},
	["advisor_nabor"] = {
		name = "Advisor",
		icon = "icon16/award_star_silver_2.png",
		ignore_smask = true
	},
	["event_boss_nabor"] = {
		name = "Главный ивентолог",
		icon = "icon16/controller.png",
		ignore_smask = true
	},
	["event_nabor"] = {
		name = "Ивентолог",
		icon = "icon16/controller.png",
		ignore_smask = true
	},
	["assistant_nabor"] = {
		name = "Assistant",
		icon = "icon16/award_star_gold_2.png",
		ignore_smask = true
	},
	["overwatch"] = {
		name = "OverWatch",
		icon = "icon16/shield.png",
		ignore_smask = true
	},
	["superadmin"] = {
		name = "SA",
		icon = "icon16/ruby.png",
		ignore_smask = true
	}
}

surface.CreateFont("ScoreboardHeader", {
	font = "Inter",
	size = 16,
	weight = 700,
	extended = true,
})

surface.CreateFont("PlayerText", {
	font = "Inter",
	size = 20,
	weight = 500,
	extended = true,
})

surface.CreateFont("Title", {
	font = "Inter",
	size = 35,
	weight = 800,
	extended = true,
})

surface.CreateFont("Title2", {
	font = "Inter Light",
	size = 35,
	weight = 300,
	extended = true,
})

local function CanSeeRealTarget(localPlayer, targetPlayer)
		local my_rank = ranknames[localPlayer:GetUserGroup()] or ranknames["user"]
		local player_rank = ranknames[targetPlayer:GetUserGroup()] or ranknames["user"]

		local can_see_nabor_smask = localPlayer:IsNabor() and ignore_mask:GetBool()
		local can_ignore_mask = can_see_nabor_smask and (not player_rank.ignore_smask or my_rank.ignore_smask)

		return can_ignore_mask
end

local blockWide = 760
do
	local PANEL = {}
	AccessorFunc(PANEL, "Player", "Player")

	function PANEL:Init()
		self:Dock(TOP)
		self:DockMargin(0, 2, 0 , 0)
		self:SetTall(30)
		self:SetText("")
		self:SetCursor("arrow")

		local function OpenProfile()
				local _player = self.Player
				if not IsValid(_player) then
						gui.OpenURL("https://steamcommunity.com/profiles/" .. self.LastID64)
						return
				end

				local is_fake = _player:GetNetVar("FakePlayer")
				if not is_fake then
						_player:ShowProfile()
						return
				end

				local localPlayer = LocalPlayer()
				local can = CanSeeRealTarget(localPlayer, _player)

				if can then
						_player:ShowProfile()
						return
				end

				local allPlayers = player.GetAll()

				local validTargets = {}
				for _, ply in ipairs(allPlayers) do
						if ply ~= _player then
								table.insert(validTargets, ply)
						end
				end

				if #validTargets == 0 then
						return
				end

				local index = _player:EntIndex() % #validTargets + 1
				local fake_target = validTargets[index]

				fake_target:ShowProfile()
		end

		self:SetTooltip("ПКМ - открыть меню")

		function self.DoRightClick()
			local _player = self.Player
			local d_menu = DermaMenu()

			local sid = IsValid(_player) and _player:SteamID() or util.SteamIDFrom64(self.LastID64)
			d_menu:AddOption("Скопировать имя", function()
				local name = IsValid(_player) and _player:Name() or self.Name:GetText()
				SetClipboardText(name)
			end):SetIcon("icon16/page_copy.png")

			d_menu:AddOption("Скопировать SteamID", function() SetClipboardText(sid) end):SetIcon("icon16/page_world.png")
			d_menu:AddOption("Открыть профиль", function() OpenProfile() end):SetIcon("icon16/world.png")
			d_menu:AddSpacer()
			d_menu:AddOption("Скопировать CID", function() SetClipboardText(self.CID) end):SetIcon("icon16/vcard.png")
			d_menu:AddOption("Скопировать профессию", function()
				local job = self.TeamName
				SetClipboardText(job)
			end):SetIcon("icon16/user_suit.png")

			d_menu:AddOption("Скопировать профессию и CID", function()
				local job = self.TeamName
				local cid = self.CID
				SetClipboardText(job .. " " .. cid)
			end):SetIcon("icon16/vcard_add.png")

			if sid ~= LocalPlayer():SteamID() then
				local isBlocked = SChat2.BlockedUsers[sid]
				local blockedName = isBlocked and "Разблокировать PM" or "Заблокировать PM"
				local blockedIcon = isBlocked and "icon16/lock_open.png" or "icon16/lock_delete.png"
				d_menu:AddOption(blockedName, function()
					if isBlocked then
						SChat2.BlockedUsers[sid] = nil
					else
						SChat2.BlockedUsers[sid] = true
					end
				end):SetIcon(blockedIcon)
			end

			d_menu:AddOption("Закрыть", function() end):SetIcon("icon16/cross.png")
			d_menu:Open()
		end

		self.Name = self:Add("DLabel")
		self.Name:Dock(LEFT)
		self.Name:DockMargin(16, 0, 0, 0)
		self.Name:SetFont("PlayerText")
		self.Name:SetText("Unnamed")
		self.Name:SetWide(200)
		self.Name:SetTextColor(color_white)

		self.Mute = self:Add("DImageButton")
		local Mute = self.Mute
		Mute:SetImage("icon32/unmuted.png")
		Mute:SetSize(30, 30)
		Mute:Dock(RIGHT)
		Mute:DockMargin(0, 0, 8, 0)
		-- Mute:SetTooltip("")
		Mute:SetMouseInputEnabled(true)
		Mute:NoClipping( true )

		-- Mute:SetVisible(false)
		function Mute.CalculateIcon(_self)
			local ply = self:GetPlayer()
			local img = ply:_IsMuted() and "icon32/muted.png" or "icon32/unmuted.png"
			_self:SetImage(img)
		end

		function Mute.DoClick(_self)
			local ply = self:GetPlayer()
			if not IsValid(ply) then return end
			ply:_SetMuted(not ply:_IsMuted())
			_self:CalculateIcon()
		end

		function Mute.OnMouseWheeled(_self, delta)
			local ply = self:GetPlayer()
			if not IsValid(ply) then return end
			if ply == LocalPlayer() then return end
			local volume = math.max(0.2, ply:GetVoiceVolumeScale() + delta / 100 * 5)
			volume = math.Round(volume, 2)

			if delta < 0 and volume <= 0.2 then
				if not ply:_IsMuted() then
					ply:_SetMuted(true)
					_self:CalculateIcon()
					-- ply:SetVoiceVolumeScale(0.2)
				end
				return true
			elseif delta > 0 and ply:_IsMuted() then
				ply:_SetMuted(false)
				_self:CalculateIcon()
				return true
			end

			ply:SetVoiceVolumeScale(volume)
			_self.LastWheelTick = CurTime()
			return true
		end

		function Mute.PaintOver(_self, w, h)
			w, h = 32, 32
			local ply = self:GetPlayer()
			if not IsValid(ply) then return end

			if ( _self.Hovered ) then _self.LastWheelTick = CurTime() end

			 local time = math.Clamp( CurTime() - ( _self.LastWheelTick or 0 ), 0, 0.75 ) / 0.75

			 local bgAlpha = 255 - time * 255
			 if ( bgAlpha <= 0 ) then return end

			local x = w + 8
			w = w * 1.5

			surface.SetAlphaMultiplier(bgAlpha / 255 * 0.8)
			draw.RoundedBox( 4, x, 0, w, h, color_black )
			surface.SetAlphaMultiplier(bgAlpha / 255)
			draw.SimpleText( math.Round( ply:GetVoiceVolumeScale() * 100 ) .. "%", "DermaDefault",
				x + ( w / 2 ) + 5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.SetAlphaMultiplier(255)

			if mWheelMat:IsError() then return end
			surface.SetMaterial( mWheelMat )
			surface.SetDrawColor( 255, 255, 255, bgAlpha )
			surface.DrawTexturedRect( x, h / 2 - 8, 16, 16 )
		end
	end

	surface.SetFont("PlayerText")
	local twCID = surface.GetTextSize("#00000")
	function PANEL:Paint(w, h)
		local ply = self:GetPlayer()
		if not IsValid(ply) or not IsValid(LocalPlayer()) and not self.Hidden then
			self.Hidden = true
			self:AlphaTo(112, 2, 1, function() end) --self:Remove()
		end

		local padding, _block, block = (w - blockWide) / 5, 200, 190
		local x = padding + _block + block / 2

		surface.SetAlphaMultiplier(0.03)
		draw.RoundedBox(6, 0, 0, w, h, self.TeamCol)
		surface.SetAlphaMultiplier(1)

		local wt = draw.SimpleText(self.RankName, "PlayerText", x, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self.RankIcon then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.RankIcon)
			surface.DrawTexturedRect(x - wt / 2 - 16 - 4, h / 2 - 8, 16, 16)
		end
		_block, block = block, 190
		x = x + padding + _block / 2 + block / 2

		local tw, th = draw.SimpleText(self.TeamName, "PlayerText", x, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		tw = tw + 8
		render.SetScissorRect( 0, 0, self:LocalToScreen(3, 0), ScrH(), true )
		draw.RoundedBox(6, 0, 0, 6, h, self.TeamCol)
		render.SetScissorRect( 0, 0, 0, 0, false )
		surface.SetAlphaMultiplier(0.65)
		draw.RoundedBox(2, x - tw / 2, h / 2 + th / 2, tw, 3, self.TeamCol)
		surface.SetAlphaMultiplier(1)

		_block, block = block, 60
		x = x + padding + _block / 2 + block / 2
		draw.SimpleText(self.CID, "PlayerText", x - twCID / 2, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		_block, block = block, 60
		x = x + padding + _block / 2 + block / 2
		if LocalPlayer():Team() == TEAM_ADMIN then
			draw.SimpleText(self.Kills, "PlayerText", x - 6, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText("/", "PlayerText", x, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(self.Deaths, "PlayerText", x + 6, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(self.Kills, "PlayerText", x, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local ping = IsValid(ply) and ply:Ping() or "Вышел"
		draw.SimpleText(ping, "PlayerText", self.Mute.x, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		-- draw.SimpleText( ply:_IsMuted(), "PlayerText", w-35, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	function PANEL:SetupPlayerRank(ply, rank_tbl, ignore_mask)
		local group = ignore_mask and ply:GetUserGroup() or ply:GetNetVar("FakeGroup", ply:GetUserGroup())
		local rank = ranknames[group] or ranknames["user"]
		local rank_name = ignore_mask and rank.name or ply:GetNetVar("Rank.Name", rank.name)
		self.RankName = rank_name ~= "Игрок" and rank_name or ""
		self.RankIcon = self.RankName ~= "" and Material(ignore_mask and rank.icon or ply:GetNetVar("Rank.Icon", rank.icon))
		return self
	end

	function PANEL:SetupPlayer(ply)
		self:SetPlayer(ply)
		self.Name:SetText(ply:Name())
		self.LastID64 = ply:SteamID64()
		self.CID = "#" .. ply:GetCID()
		local should_see_real_job = LocalPlayer():Team() == TEAM_ADMIN
		local player_team = should_see_real_job and ply:Team() or ply:GetLocalPlayerRelativeTeam()
		self.TeamCol = team.GetColor(player_team)
		self.TeamName = team.GetName(player_team)
		local ent = ply:GetObserverTarget()
		if IsValid(ent) and ent:GetClass() == "npc_cscanner" then self.TeamName = string.gsub(self.TeamName, "(%.%w-)$", ".SCAN%1", 1) end
		self.Kills = ply:Frags()
		self.Deaths = ply:Deaths()
		self.Mute:CalculateIcon()
		if ply == LocalPlayer() then self.Mute:SetEnabled(false) end
		return self
	end

	vgui.Register("ScoreboardPlayer", PANEL, "DButton")
end

do
	local PANEL = {}
	function PANEL:UpdateList(sort)
		self:Clear()
		local tbl = player.GetAll()
		local localPlayer = LocalPlayer()
		if not IsValid(localPlayer) then return end

		table.sort(tbl, sort or function(ply, pl)
			if ply == localPlayer then return true end
			if pl == localPlayer then return false end

			local fteam = localPlayer:Team() == TEAM_ADMIN and ply:Team() or ply:GetLocalPlayerRelativeTeam()
			local lteam = localPlayer:Team() == TEAM_ADMIN and pl:Team() or pl:GetLocalPlayerRelativeTeam()

			return fteam > lteam
		end)

		for k, v in ipairs(tbl) do
			local player_rank = ranknames[v:GetUserGroup()] or ranknames["user"]
			local hidden = v:GetNetVar("MaskMe", false)
			local can_ignore_mask = CanSeeRealTarget(localPlayer, v)
			if hidden and not can_ignore_mask then continue end
if (
        (localPlayer:isCP()
        or localPlayer:isCitizen()
        or localPlayer:isLoyal()
        or localPlayer:isGSR()
        or localPlayer:Team() == TEAM_CITIZEN)
        and not localPlayer:isRebel()
    )
    and teams[v:Team()]
    and not v:GetNetVar("TeamNum")
then
    continue
end
			self:Add("ScoreboardPlayer"):SetupPlayer(v):SetupPlayerRank(v, player_rank, can_ignore_mask)
		end
	end

	vgui.Register("ScoreboardList", PANEL, "DScrollPanel")
end

do
	local background = Color(0, 0, 0, 175)
	local PANEL = {}
	function PANEL:Init()
		self:SetSize(math.max(ScrW() * 0.73, 800), ScrH() * 0.9)
		self:MakePopup()
		self:SetTitle("")
		self:Center()
		self:DockPadding(5, 67 + 16, 5, 5)
		self:ShowCloseButton(false)
		self.PlayerList = self:Add("ScoreboardList")
		self.PlayerList:Dock(FILL)
		self.PlayerList:UpdateList()
		ApplyScrollPanelStyle(self.PlayerList)
	end

	function PANEL:Paint(w, h)
		kblur(self, 5, 10, 150)
		draw.RoundedBox(0, 0, 0, w, h, background)
		local tw, th = draw.SimpleText("UnionRP", "Title", 16, 16, col.o)
		draw.SimpleText(" | HλLF-LIFE 2 ROLEPLAY", "Title2", 16 + tw, 16, color_white)
		tw, th = draw.SimpleText("ОНЛАЙН", "ScoreboardHeader", w - 16, 16, col.o, TEXT_ALIGN_RIGHT)
		draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers(), "ScoreboardHeader", w - 16, 16 + th, color_white, TEXT_ALIGN_RIGHT)

		surface.SetAlphaMultiplier(0.25)
		draw.SimpleText("ИМЯ", "ScoreboardHeader", 5, 67, color_white, TEXT_ALIGN_LEFT)

		w = self.PlayerList:InnerWidth()
		local padding, _block, block = (w - blockWide) / 5, 200, 190
		local x = 5 + padding + _block + block / 2

		draw.SimpleText("ПРИВИЛЕГИЯ", "ScoreboardHeader", x, 67, color_white, TEXT_ALIGN_CENTER)
		_block, block = block, 190
		x = x + padding + _block / 2 + block / 2

		draw.SimpleText("ПРОФЕССИЯ", "ScoreboardHeader", x, 67, color_white, TEXT_ALIGN_CENTER)
		_block, block = block, 60
		x = x + padding + _block / 2 + block / 2

		draw.SimpleText("CID", "ScoreboardHeader", x, 67, color_white, TEXT_ALIGN_CENTER)
		_block, block = block, 60
		x = x + padding + _block / 2 + block / 2

		draw.SimpleText("УБИЙСТВА", "ScoreboardHeader", x, 67, color_white, TEXT_ALIGN_CENTER)

		draw.SimpleText("ПИНГ", "ScoreboardHeader", w, 67, color_white, TEXT_ALIGN_RIGHT)
		surface.SetAlphaMultiplier(1)
	end

	function PANEL:Think()
		if not vgui.CursorVisible() then
			self.CursorActivatedFromTab = true
			gui.EnableScreenClicker(true)
		end
	end

	function PANEL:HideOverride()
		self:Hide()

		if self.CursorActivatedFromTab then
			self.CursorActivatedFromTab = nil
			gui.EnableScreenClicker(false)
		end
	end

	vgui.Register("Scoreboard", PANEL, "DFrame")
end

if IsValid(Scoreboard) then Scoreboard:Remove() end
hook.Add("ScoreboardShow", "CustomScoreboard", function()
	if not IsValid(Scoreboard) then
		Scoreboard = vgui.Create("Scoreboard")
	else
		Scoreboard:Show()
		Scoreboard.PlayerList:UpdateList()
		Scoreboard:InvalidateChildren(true)
	end
	return false
end)

hook.Add("ScoreboardHide", "CustomScoreboard", function()
	if IsValid(Scoreboard) then Scoreboard:HideOverride() end
	return false
end)
