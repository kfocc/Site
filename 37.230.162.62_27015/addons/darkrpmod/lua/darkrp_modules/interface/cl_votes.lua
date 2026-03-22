surface.CreateFont("VoteFont1", {
	font = "Roboto Bold",
	extended = true,
	size = 15,
	weight = 300,
})

surface.CreateFont("VoteFont2", {
	font = "Roboto Bold",
	extended = true,
	size = 20,
	weight = 500,
})

local PANEL = {}
local color = Color(216, 101, 74)
local config = {
	endtime = 0,
	starttime = 0,
	multiple = false,
	voteend = false
}

local questions = {}
function PANEL:Init()
	self:SetPos(15, ScrH() / 4)
	self:SetSize(300, 300)
	self:SetTitle("")
	self:ShowCloseButton(false)
	self.Paint = function(self, w, h)
		surface.SetDrawColor(30, 30, 30, 150)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, w, 24)

		surface.SetTextColor(255, 255, 255)
		surface.SetFont("VoteFont2")

		local x, y = surface.GetTextSize("Голосование") --uff ya
		surface.SetTextPos(150 - x * 0.5, 2)
		surface.DrawText("Голосование")

		local time = math.floor(config.endtime - CurTime())
		if time > 0 then
			local x, y = surface.GetTextSize(time) --uff ya
			surface.SetTextPos(300 - x - 10, 2)
			surface.DrawText(time)
		end

		surface.SetDrawColor(color)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 55, w, 1)
	end

	surface.PlaySound("garrysmod/content_downloaded.wav")

	local main = self
	main.closebutton = main:Add("DButton")
	main.closebutton:SetPos(5, 3)
	main.closebutton:SetSize(16, 16)
	main.closebutton:SetFont("VoteFont2")
	main.closebutton:SetTextColor(Color(255, 255, 255))
	main.closebutton:SetText("×")
	main.closebutton:SetTooltip("Закрыть")
	main.closebutton.Paint = function() end
	main.closebutton.DoClick = function()
		main:Close()
		hook.Run("ShowSpare1")
	end

	main.main_panel = main:Add("DPanel")
	main.main_panel:Dock(FILL)
	main.main_panel.Paint = function() end

	local main_panel = main.main_panel
	main_panel.head = main_panel:Add("DPanel")
	main_panel.head:Dock(TOP)
	main_panel.head:SetTall(30)
	main_panel.head.Paint = function() end

	main_panel.head.label = main_panel.head:Add("DLabel")
	main_panel.head.label:SetFont("VoteFont1")
	main_panel.head.label:SetTextColor(Color(255, 255, 255))
	main_panel.head.label:SetText("Тема: ")
	main_panel.head.label:SetPos(6, 2)

	main_panel.head.label1 = main_panel.head:Add("DLabel")
	main_panel.head.label1:SetFont("VoteFont1")
	main_panel.head.label1:SetText("")
	main_panel.head.label1:SetPos(45, 4)

	main_panel.body = main_panel:Add("DPanel")
	main_panel.body:Dock(FILL)
	main_panel.body:DockMargin(0, 3, 0, 0)
	main_panel.body.Paint = function() end

	local boxes = {}
	for k, v in ipairs(questions) do
		local box_id = "box" .. k
		main_panel.body[box_id] = main_panel.body:Add("DCheckBoxLabel")
		main_panel.body[box_id]:Dock(TOP)
		main_panel.body[box_id]:DockMargin(7, 5, 0, 0)
		main_panel.body[box_id]:SetFont("VoteFont1")
		main_panel.body[box_id]:SetText(v.key)
		main_panel.body[box_id]:SetValue(0)
		main_panel.body[box_id]:SizeToContents()

		boxes[k] = main_panel.body[box_id]
	end

	main_panel.bottom = main_panel:Add("DPanel")
	main_panel.bottom:Dock(BOTTOM)
	main_panel.bottom:DockMargin(0, 3, 0, 0)
	main_panel.bottom:SetTall(35)
	main_panel.bottom.Paint = function(self, w, h)
		surface.SetDrawColor(color)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local button_color = color
	main_panel.bottom.button = main_panel.bottom:Add("DButton")
	main_panel.bottom.button:Dock(FILL)
	main_panel.bottom.button:SetFont("VoteFont2")
	main_panel.bottom.button:SetTextColor(Color(255, 255, 255))
	main_panel.bottom.button:SetText("Проголосовать")
	main_panel.bottom.button.OnCursorEntered = function(self) if not self.kek then self.kek = true end end
	main_panel.bottom.button.OnCursorExited = function(self) if self.kek then self.kek = false end end
	main_panel.bottom.button.Paint = function(self, w, h)
		if not self:GetDisabled() then
			if self.kek then
				button_color = color:lighten(50)
			else
				button_color = color
			end
		else
			button_color = Color(15, 15, 15, 200)
		end

		surface.SetDrawColor(button_color)
		surface.DrawRect(0, 0, w, h)
	end

	main_panel.bottom.button.DoClick = function(self)
		surface.PlaySound("garrysmod/ui_click.wav")
		local multiple = config.multiple
		local tbl = {}
		local i = 0
		for k, v in ipairs(boxes) do
			if v:GetChecked() == true then
				i = i + 1
				tbl[k] = v:GetChecked()
			end
		end

		if not multiple and i > 1 then
			self:SetText("Выберите один ответ!")
			self:SetDisabled(true)
			button_color = Color(15, 15, 15, 200)
			timer.Simple(3, function()
				if IsValid(self) then
					self:SetText("Проголосовать")
					self:SetDisabled(false)
					button_color = color
				end
			end)
			return
		end

		if i < 1 then
			self:SetText("Выберите ответ!")
			self:SetDisabled(true)
			button_color = Color(15, 15, 15, 200)
			timer.Simple(3, function()
				if IsValid(self) then
					self:SetText("Проголосовать")
					self:SetDisabled(false)
					button_color = color
				end
			end)
			return
		end

		self:SetDisabled(true)
		self:SetText("Вы уже проголосовали !")

		button_color = Color(15, 15, 15, 200)

		netstream.Start("Vote::Sync", tbl)

		main:RefreshVote()
	end
end

local players = 1
function PANEL:RefreshVote()
	if IsValid(self.main_panel.body) then self.main_panel.body:Remove() end
	local main_panel = self.main_panel
	if config.voteend then
		surface.PlaySound("garrysmod/save_load" .. math.random(1, 4) .. ".wav")
		if IsValid(main_panel.vote_body) then main_panel.vote_body:Remove() end
		if IsValid(main_panel.bottom) then
			main_panel.bottom:Remove()
			self:SetSize(300, 150 + table.Count(questions) * 15)
		end

		main_panel.vote_body = main_panel:Add("DPanel")
		main_panel.vote_body:Dock(FILL)
		main_panel.vote_body:DockMargin(0, 3, 0, 0)
		main_panel.vote_body.Paint = function() end

		local i = 0
		local voteWinnerStr = "{answerNum}. {answerText} ({voteCount} | {percent}%){isWinner}"
		local string_Interpolate = string.Interpolate
		for _, v in SortedPairsByMemberValue(questions, "num", true) do
			i = i + 1
			local i = i --uff
			local box = "box" .. i
			main_panel.vote_body[box] = main_panel.vote_body:Add("DPanel")
			main_panel.vote_body[box]:Dock(TOP)
			main_panel.vote_body[box]:SetTall(15)
			main_panel.vote_body[box]:DockMargin(0, 5, 0, 0)

			local voteCount = v.num
			local percent = math.Round((voteCount / players) * 100)
			local key = i == 1 and " *" or ""
			local drawStr = string_Interpolate(voteWinnerStr, {
				answerNum = i,
				answerText = v.key,
				voteCount = voteCount,
				percent = percent,
				isWinner = key,
			})

			main_panel.vote_body[box].Paint = function()
				surface.SetTextColor(255, 255, 255)
				surface.SetFont("VoteFont1")
				surface.SetTextPos(5, 0)
				surface.DrawText(drawStr)
			end
		end
		return
	end

	if not IsValid(main_panel.vote_body) then
		main_panel.vote_body = main_panel:Add("DPanel")
		main_panel.vote_body:Dock(FILL)
		main_panel.vote_body:DockMargin(0, 3, 0, 0)
		main_panel.vote_body.Paint = function() end
		local random = {}
		for k, v in ipairs(questions) do
			random[k] = v.num
		end

		local biggest = math.max(unpack(random))
		for k, v in ipairs(questions) do
			local lcolor = color
			local box = "box" .. k
			if biggest == v.num then lcolor = color:lighten(50) end
			local lrandom = v.num
			local percent = math.Round((lrandom / players) * 100)
			main_panel.vote_body[box] = main_panel.vote_body:Add("DPanel")
			main_panel.vote_body[box]:Dock(TOP)
			main_panel.vote_body[box]:SetTall(15)
			main_panel.vote_body[box]:DockMargin(0, 5, 0, 0)
			main_panel.vote_body[box].Paint = function(self, w, h)
				surface.SetDrawColor(58, 58, 58)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(lcolor)
				surface.DrawRect(0, 0, (percent * 0.01) * w, h)

				surface.SetTextColor(255, 255, 255)
				surface.SetFont("VoteFont1")

				surface.SetTextPos(5, 0)
				surface.DrawText(v.key)

				local x, y = surface.GetTextSize(percent .. "%") --uff ya
				surface.SetTextPos(w * 0.5 - x * 0.5, 0)
				surface.DrawText(percent .. "%")
			end
		end
	end
end

function PANEL:Sync()
	if IsValid(self.main_panel.vote_body) then
		local random = {}
		for k, v in ipairs(questions) do
			random[k] = v.num
		end

		local biggest = math.max(unpack(random))
		for k, v in ipairs(questions) do
			local lcolor = color
			local box = "box" .. k
			local percent = math.Round((v.num / players) * 100)
			if biggest == v.num then lcolor = color:lighten(50) end
			self.main_panel.vote_body[box].Paint = function(self, w, h)
				surface.SetDrawColor(58, 58, 58)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(lcolor)
				surface.DrawRect(0, 0, (percent * 0.01) * w, h)

				surface.SetTextColor(255, 255, 255)
				surface.SetFont("VoteFont1")

				surface.SetTextPos(5, 0)
				surface.DrawText(v.key)

				local x, y = surface.GetTextSize(percent .. "%") --uff ya
				surface.SetTextPos(w * 0.5 - x * 0.5, 0)
				surface.DrawText(percent .. "%")
			end
		end
	end
end
vgui.Register("VoteShit", PANEL, "DFrame")

netstream.Hook("Vote::Create", function(data)
	if IsValid(g_vote_panel) then g_vote_panel:Remove() end
	questions = data.questions
	config = {
		endtime = CurTime() + data.endtime,
		multiple = data.multiple,
		endvote = false
	}

	g_vote_panel = vgui.Create("VoteShit")
	g_vote_panel.main_panel.head.label1:SetText(data.name)
	g_vote_panel.main_panel.head.label1:SizeToContents()
	g_vote_panel.main_panel.head.label1:SetTextColor(Color(255, 255, 255))
end)

netstream.Hook("Vote::Sync", function(plys, data)
	if IsValid(g_vote_panel) then
		questions = data
		players = plys
		g_vote_panel:Sync()
	end
end)

netstream.Hook("Vote::End", function(name, plys, data)
	config.voteend = true

	questions = data
	players = plys

	if not IsValid(g_vote_panel) then
		config.voteend = true

		g_vote_panel = vgui.Create("VoteShit")
		g_vote_panel.main_panel.head.label1:SetText(name)
		g_vote_panel.main_panel.head.label1:SizeToContents()
		g_vote_panel.main_panel.head.label1:SetTextColor(Color(255, 255, 255))
	end

	g_vote_panel:RefreshVote()

	timer.Simple(8, function() if IsValid(g_vote_panel) then g_vote_panel:Remove() end end)
end)

concommand.Add("CreateVote", function(ply)
	if not ply:IsSuperAdmin() then return end
	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 500)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(30, 30, 30, 150)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, w, 24)

		surface.SetTextColor(255, 255, 255)
		surface.SetFont("VoteFont2")

		local x, y = surface.GetTextSize("Создать голосование") --uff ya
		surface.SetTextPos(100 - x / 2, 2)
		surface.DrawText("Создать голосование")

		surface.SetDrawColor(color)
		surface.DrawOutlinedRect(0, 0, w, h)

	end

	local p = frame:Add("DPanel")
	p:Dock(FILL)
	p.Paint = function() end

	local d = p:Add("DTextEntry")
	d:Dock(TOP)
	d:DockMargin(2, 3, 0, 0)
	d:SetText("Введите тему голосования")

	local p1 = p:Add("DPanel")
	p1:Dock(FILL)
	p1:DockMargin(0, 3, 0, 0)
	p1.Paint = function() end

	local d0 = p1:Add("DTextEntry")
	d0:Dock(TOP)
	d0:DockMargin(2, 3, 0, 0)
	d0:SetNumeric(true)
	d0:SetText("Время до окончания голосования ( в секундах )")

	local d1 = p1:Add("DTextEntry")
	d1:SetSize(200, 20)
	d1:SetPos(2, 26)
	d1:SetNumeric(true)
	d1:SetText("Введите количество ответов")

	local b1 = p1:Add("DButton")
	b1:SetSize(85, 20)
	b1:SetPos(203, 26)
	b1:SetText("Применить")
	b1:SetFont("VoteFont1")
	b1:SetTextColor(Color(255, 255, 255))
	b1.Paint = function(self, w, h)
		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, w, h)
	end

	b1.DoClick = function(self)
		if IsValid(p1.dt1) then
			for i = 1, 10 do
				if IsValid(p1["dt" .. i]) then
					p1["dt" .. i]:Remove()
					p1["bt" .. i]:Remove()
				end
			end
		end

		local num = tonumber(d1:GetValue())
		if not num then return end
		if num > 0 and num < 11 then
			for i = 1, num do
				p1["dt" .. i] = p1:Add("DTextEntry")
				p1["dt" .. i]:SetSize(265, 20)
				p1["dt" .. i]:SetPos(2, 26 + 23 * i)
				p1["dt" .. i]:SetText("Введите текст ответа")

				p1["bt" .. i] = p1:Add("DButton")
				p1["bt" .. i]:SetSize(20, 20)
				p1["bt" .. i]:SetPos(265, 26 + 23 * i)
				p1["bt" .. i]:SetText("X")
				p1["bt" .. i].DoClick = function(self)
					p1["dt" .. i]:Remove()
					self:Remove()
					local key = 0
					for i = 1, 10 do
						if IsValid(p1["dt" .. i]) then
							key = key + 1
							p1["dt" .. i]:SetPos(2, 26 + 23 * key)
							p1["bt" .. i]:SetPos(265, 26 + 23 * key)
						end
					end
				end
			end
		end

		self:SetDisabled(true)
		timer.Simple(0.5, function() if IsValid(self) then self:SetDisabled(false) end end)
	end

	local c = frame:Add("DCheckBoxLabel")
	c:SetPos(10, 445)
	c:SetFont("VoteFont1")
	c:SetTextColor(Color(255, 255, 255))
	c:SetText("Можно ли выбрать несколько ответов?")
	c:SizeToContents()

	local bcolor = color
	local b2 = p1:Add("DButton")
	b2:Dock(BOTTOM)
	b2:DockMargin(2, 0, 2, 2)
	b2:SetTall(25)
	b2:SetFont("VoteFont2")
	b2:SetTextColor(Color(255, 255, 255))
	b2:SetText("Начать")
	b2.Paint = function(self, w, h)
		surface.SetDrawColor(bcolor)
		surface.DrawRect(0, 0, w, h)
	end

	b2.DoClick = function(self)
		local tbl = {}
		local num = 0
		for i = 1, 10 do
			if IsValid(p1["dt" .. i]) then
				num = num + 1
				tbl[num] = {}
				tbl[num].key = p1["dt" .. i]:GetValue()
			end
		end

		if num < 2 then
			self:SetText("Ответов должно быть больше 1!")
			self:SetDisabled(true)
			bcolor = Color(15, 15, 15, 200)
			timer.Simple(3, function()
				if IsValid(self) then
					self:SetText("Начать")
					self:SetDisabled(false)
					bcolor = color
				end
			end)
			return
		end

		if not isnumber(tonumber(d0:GetValue())) then
			self:SetText("Укажите время!")
			self:SetDisabled(true)
			bcolor = Color(15, 15, 15, 200)
			timer.Simple(3, function()
				if IsValid(self) then
					self:SetText("Начать")
					self:SetDisabled(false)
					bcolor = color
				end
			end)
			return
		end

		netstream.Start("Vote::Create", {
			name = d:GetValue(),
			multiple = c:GetChecked(),
			endtime = d0:GetValue(),
			questions = tbl
		})

		frame:Remove()
	end
end)
