if IsValid(deceive.GUI) then deceive.GUI:Remove() end

local deceiveConfig = deceive.Config
local cmd = deceiveConfig and deceive.Config.UndisguiseCommand or "undisguise"
surface.CreateFont("deceive.title", {
	font = "Roboto Cn",
	size = 21,
	weight = 0,
	extended = true,
})

surface.CreateFont("deceive.line", {
	font = "Roboto Cn",
	size = 16,
	weight = 0,
	extended = true,
})

surface.CreateFont("deceive.line2", {
	font = "Roboto",
	size = 12,
	weight = 800,
	extended = true,
})

surface.CreateFont("deceive.close", {
	font = "Open Sans",
	size = 14,
	weight = 800,
	extended = true,
})

surface.CreateFont("deceive.close2", {
	font = "Open Sans",
	size = 10,
	weight = 800,
	extended = true,
})

local L = deceive.Translate
local PANEL = {}
function PANEL:Init()
	self:SetSize(400, 368)
	self:Center()

	self.PlayerList = vgui.Create("DListView", self)
	self.PlayerList:Dock(LEFT)
	self.PlayerList:DockMargin(8, 28 + 8, 8, 8)
	self.PlayerList:SetWide(math.ceil(self:GetWide() * 0.58 - 12))

	self.PlayerList:SetMultiSelect(false)
	self.PlayerList:AddColumn("Работа")

	self:RefreshList()
	function self.PlayerList.OnRowSelected(_, _, line)
		local teamtable = line.Player
		self.Player = teamtable
		if not self.PlayerModel:IsVisible() then
			self.PlayerModel:SetVisible(true)
			self.Info:SetVisible(true)
		end

		self.PlayerModel:SetModel(istable(teamtable.model) and table.Random(teamtable.model) or teamtable.model)
		--timer.Simple(.1,function()
		--	if !self or !self.PlayerModel then return end
		--	if teamtable.PlayerSpawn then
		--		teamtable.PlayerSpawn(self.PlayerModel)
		--	end
		--end)

		self.PlayerModel.Entity.GetPlayerColor = function() return teamtable.color end

		local txt = "Имя: " .. LocalPlayer():Name() .. "\n" .. "Работа: " .. team.GetName(LocalPlayer():Team()) .. "\n" .. "Цель: " .. teamtable.name
		--"Маскировка: " .. (LocalPlayer().Disguised and "Активна" or "Неактивна")
		self.Info:SetText(txt)
		self.Info:SizeToContents()

		self.Disguise:SetVisible(true)
	end

	self.RightSide = vgui.Create("EditablePanel", self)
	self.RightSide:Dock(RIGHT)
	self.RightSide:DockMargin(8, 28 + 8, 8, 8)
	self.RightSide:SetWide(math.ceil(self:GetWide() * 0.42 - 12))

	self.PlayerModel = vgui.Create("DModelPanel", self.RightSide)
	self.PlayerModel:Dock(TOP)
	self.PlayerModel:SetTall(150)
	self.PlayerModel:SetVisible(false)
	self.PlayerModel:SetFOV(12.5)
	function self.PlayerModel:LayoutEntity(ent)
		if not IsValid(ent) then return end
		local head = ent:LookupBone("ValveBiped.Bip01_Head1")
		local headPos
		if head then
			headPos = ent:GetBonePosition(head)
			ent:ManipulateBoneAngles(head, Angle(-10, -5, -20))
		else
			local mins, maxs = ent:GetModelBounds()
			headPos = maxs * 0.85 + Vector(-2.5, 0, 0)
		end

		self:SetLookAt(headPos + Vector(0, 0, 1.5))

		local vec = ent:GetAngles():Forward() * 20 + ent:GetAngles():Up() * 62.5 + ent:GetAngles():Right() * 12
		ent:SetEyeTarget(vec)
		ent:SetPos(Vector(0, -2, 0))
		ent:SetAngles(Angle(5, 70, 0))
	end

	self.Info = vgui.Create("DLabel", self.RightSide)
	self.Info:Dock(TOP)
	self.Info:DockMargin(0, 2, 0, 0)
	self.Info:SetVisible(false)
	self.Info:SetFont("deceive.line")
	self.Info:SetTextColor(Color(230, 230, 255, 192))

	self.Disguise = vgui.Create("DButton", self.RightSide)
	self.Disguise:Dock(BOTTOM)
	self.Disguise:SetVisible(false)
	self.Disguise:SetText(L"disguise_ui_action")
	self.Disguise:SetImage("icon16/briefcase.png")
	function self.Disguise.DoClick()
		net.Start("deceive.interface")
		net.WriteUInt(self.Player.team, 32)
		net.WriteString(self.PlayerModel:GetModel())
		net.SendToServer()
		self:Remove()
	end

	self.Close = vgui.Create("DButton", self)
	self.Close:SetSize(40, 20)
	function self.Close.DoClick()
		self:Remove()
	end

	self:Theme()

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(true)

	self:SetVisible(false)
end

function PANEL:PerformLayout()
	self.Close:SetPos(self:GetWide() - self.Close:GetWide() - 16, 1)
end

function PANEL:RefreshList()
	self.PlayerList:Clear()

	local selfTeam = LocalPlayer():Team()
	local allCanMask = deceiveConfig.allCanMask
	local onlyCanList = deceiveConfig.onlyCanMask[selfTeam] or {}
	for k, v in pairs(RPExtraTeams) do
		if allCanMask[k] and onlyCanList[k] ~= false or onlyCanList[k] then
			local line = self.PlayerList:AddLine(v.name, v.name)
			line.Player = v
		end
	end
end

local gradient_u = Material("vgui/gradient-u.png")
function PANEL:Theme()
	function self.Close:Paint(w, h)
		surface.SetDrawColor(255, 64, 64, 64)
		surface.DrawRect(0, 0, w, h - 1)
		surface.DrawRect(1, h - 1, w - 2, 1)

		local col = Color(0, 0, 0, 0)
		if self:IsHovered() and self.Depressed then
			col = Color(0, 0, 0, 64)
		elseif self:IsHovered() then
			col = Color(255, 255, 255, 3)
		end

		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, w, h)

		surface.SetFont("deceive.close")
		local txt = "✕" -- x, ×, X, ✕, ☓, ✖, ✗, ✘, etc.
		local txtW, txtH = surface.GetTextSize(txt)
		draw.SimpleTextOutlined(txt, "deceive.close", -2 + w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5, Color(230, 230, 255, 192), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 127))
		return true
	end

	self.PlayerList:SetHeaderHeight(24)
	function self.PlayerList:Paint(w, h)
		surface.SetDrawColor(47, 47, 65, 127)
		surface.DrawRect(1, 1, w - 2, h - 2)

		surface.SetDrawColor(17, 17, 25, 192)
		surface.DrawRect(0, 1, 1, h - 2) -- left
		surface.DrawRect(w - 1, 1, 1, h - 2) -- right
		surface.DrawRect(1, 0, w - 2, 1) -- top
		surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
	end

	function self.PlayerList.VBar:Paint(w, h)
		surface.SetDrawColor(27, 27, 35, 127)
		surface.DrawRect(0, 0, w, h)
	end

	function self.PlayerList.VBar.btnGrip:Paint(w, h)
		surface.SetDrawColor(45, 45, 64, 192)
		surface.DrawRect(1, 1, w - 2, h - 2)

		if self.Depressed then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(1, 1, w - 2, h - 2)
		elseif self:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 2)
			surface.DrawRect(1, 1, w - 2, h - 2)
		end

		surface.SetDrawColor(17, 17, 25, 225)
		surface.DrawRect(0, 1, 1, h - 2) -- left
		surface.DrawRect(w - 1, 1, 1, h - 2) -- right
		surface.DrawRect(1, 0, w - 2, 1) -- top
		surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
	end

	for k, v in next, {"Up", "Down"} do
		self.PlayerList.VBar["btn" .. v].Paint = function(self, w, h)
			surface.SetDrawColor(45, 45, 64, 192)
			surface.DrawRect(1, 1, w - 2, h - 2)

			if self.Depressed then
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(1, 1, w - 2, h - 2)
			elseif self:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 2)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end

			surface.SetFont("deceive.close2")
			local txt = k == 1 and "▲" or "▼" -- x, ×, X, ✕, ☓, ✖, ✗, ✘, etc.
			local txtW, txtH = surface.GetTextSize(txt)
			draw.SimpleTextOutlined(txt, "deceive.close2", -1 + w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5, Color(230, 230, 255, 192), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 127))

			surface.SetDrawColor(17, 17, 25, 225)
			surface.DrawRect(0, 1, 1, h - 2) -- left
			surface.DrawRect(w - 1, 1, 1, h - 2) -- right
			surface.DrawRect(1, 0, w - 2, 1) -- top
			surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
		end
	end

	for k, column in next, self.PlayerList.Columns do
		function column.Header:Paint(w, h)
			surface.SetDrawColor(27, 27, 47, 192)
			surface.DrawRect(0, 0, w, h)

			surface.SetMaterial(gradient_u)
			surface.SetDrawColor(47, 47, 65, 64)
			surface.DrawTexturedRect(1, 1, w - 2, h - 2)

			if self.Depressed then
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(1, 1, w - 2, h - 2)
			elseif self:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 2)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end

			surface.SetDrawColor(17, 17, 25, 92)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetFont("deceive.line")
			local txt = self:GetText()
			local txtW, txtH = surface.GetTextSize(txt)
			surface.SetTextPos(w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5)
			surface.SetTextColor(240, 240, 255, 192)
			surface.DrawText(txt)
			return true
		end
	end

	for k, line in next, self.PlayerList.Lines do
		function line:Paint(w, h)
			local ply = line.Player
			local col = table.Copy(ply.color)
			col.a = 10
			if self:IsHovered() and self:IsSelected() or self:IsSelected() then
				col.a = 50
			elseif self:IsHovered() or self:IsSelected() then
				col.a = 25
			end

			surface.SetDrawColor(col)
			surface.DrawRect(0, 0, w - 1, h)
		end

		for _, column in next, line.Columns do
			column:SetFont("deceive.line")
			function column:UpdateColours()
				if self:GetParent():IsLineSelected() then return self:SetTextStyleColor(Color(230, 230, 255, 255)) end
				return self:SetTextStyleColor(Color(192, 192, 225, 127))
			end
		end
	end

	function self.PlayerModel:Paint(w, h)
		surface.SetDrawColor(27, 27, 35, 127)
		surface.DrawRect(0, 0, w, h)

		DModelPanel.Paint(self, w, h)

		DisableClipping(true)

		surface.SetDrawColor(17, 17, 25, 192)
		surface.DrawRect(-1, 0, 1, h) -- left
		surface.DrawRect(w, 0, 1, h) -- right
		surface.DrawRect(0, -1, w, 1) -- top
		surface.DrawRect(0, h, w, 1) -- bottom

		DisableClipping(false)
	end

	function self.Disguise:Paint(w, h)
		surface.SetDrawColor(27, 27, 47, 192)
		surface.DrawRect(0, 0, w, h)

		surface.SetMaterial(gradient_u)
		surface.SetDrawColor(47, 47, 65, 64)
		surface.DrawTexturedRect(1, 1, w - 2, h - 2)

		if self.Depressed then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(1, 1, w - 2, h - 2)
		elseif self:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 2)
			surface.DrawRect(1, 1, w - 2, h - 2)
		end

		surface.SetDrawColor(17, 17, 25, 92)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetFont("deceive.line")
		local txt = self:GetText()
		local txtW, txtH = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5)
		surface.SetTextColor(240, 240, 255, 192)
		surface.DrawText(txt)
		return true
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(37, 37, 45, 235)
	surface.DrawRect(1, 1, w - 2, h - 2)

	surface.SetDrawColor(17, 17, 25, 92)
	surface.DrawRect(1, 1, w - 2, 28)

	surface.SetDrawColor(17, 17, 25, 225)
	surface.DrawRect(0, 1, 1, h - 2) -- left
	surface.DrawRect(w - 1, 1, 1, h - 2) -- right
	surface.DrawRect(1, 0, w - 2, 1) -- top
	surface.DrawRect(1, h - 1, w - 2, 1) -- bottom

	surface.SetFont("deceive.title")
	local txt = L"disguise_ui_title"
	local txtW, txtH = surface.GetTextSize(txt)
	surface.SetTextPos(w * 0.5 - txtW * 0.5, 1 + 28 * 0.5 - txtH * 0.5)
	surface.SetTextColor(240, 240, 255, 192)
	surface.DrawText(txt)
end

function PANEL:Show()
	self:SetVisible(true)
end

function PANEL:Hide()
	self:SetVisible(false)
end

function PANEL:Think()
	--if not IsValid(ent) then self:Remove() return end
	--if LocalPlayer():GetPos():Distance(ent:GetPos()) > 95 then
	--	self:Remove()
	--	return
	--end
end

vgui.Register("deceive.interface", PANEL, "EditablePanel")
net.Receive("deceive.interface", function()
	if not IsValid(deceive.GUI) then
		deceive.GUI = vgui.Create("deceive.interface")
	end

	local entIndex = net.ReadUInt(32)
	local ent = Entity(entIndex)
	if not IsValid(ent) then return end

	deceive.GUI.Entity = ent
	deceive.GUI:Show()
end)

net.Receive("deceive.notify", function()
	local str = net.ReadString()
	local typ = net.ReadUInt(8)
	local time = net.ReadUInt(8)
	local extra = net.ReadTable()
	local _str = string.format(L(str), unpack(extra))
	notification.AddLegacy(_str, typ, time)
	print(_str)
end)

concommand.Add(cmd, function()
	-- lazy but should do the trick nicely
	RunConsoleCommand("say", "/" .. cmd)
end)
