-- To-do recode this mess.
surface.CreateFont("plogs.ui.26", {
	font = "Inter",
	extented = true,
	size = 26,
	weight = 400
})

surface.CreateFont("plogs.ui.24", {
	font = "Inter",
	extented = true,
	size = 24,
	weight = 400
})

surface.CreateFont("plogs.ui.22", {
	font = "Inter",
	extented = true,
	size = 22,
	weight = 400
})

surface.CreateFont("plogs.ui.20", {
	font = "Inter",
	extented = true,
	size = 20,
	weight = 400
})

surface.CreateFont("plogs.ui.19", {
	font = "Inter",
	extented = true,
	size = 19,
	weight = 400
})

surface.CreateFont("plogs.ui.18", {
	font = "Inter",
	extented = true,
	size = 18,
	weight = 400
})

surface.CreateFont("plogs.ui.16", {
	font = "Inter",
	extented = true,
	size = 16,
	weight = 400
})

local SEARCH_PER_SECOND = 100
local ADDLOG_PER_SECOND = 100
-- local function Search(command)
--   local w, h = ScrW() * .3, 120
--   local posx, posy = ScrW()/2 - w/2, ScrH()/2 - h/2
--   if IsValid(plogs.SearchMenu) then
--     plogs.SearchMenu:Remove()
--   end
--   if IsValid(plogs.Menu) then
--     local x, y = plogs.Menu:GetPos()
--     posy = plogs.Menu:GetTall() + y + 10
--   end
--   local fr = vgui.Create("plogs_frame")
--   fr:SetTitle("Search")
--   fr:SetSize(w, h)
--   fr:SetPos(posx, posy)
--   plogs.SearchMenu = fr
--   local lbl = vgui.Create("DLabel", fr)
--   lbl:SetPos(5, 35)
--   lbl:SetText("Enter a SteamID to search")
--   lbl:SetFont("plogs.ui.20")
--   lbl:SetTextColor(plogs.ui.Close)
--   lbl:SizeToContents()
--   local txt = vgui.Create("DTextEntry", fr)
--   txt:SetPos(5, 60)
--   txt:SetSize(w - 10, 25)
--   txt:SetFont("plogs.ui.22")
--   local srch = vgui.Create("DButton", fr)
--   srch:SetPos(5, 90)
--   srch:SetSize(w - 10, 25)
--   srch:SetText("Search")
--   srch.DoClick = function(self)
--     LocalPlayer():ConCommand("plogs \"" .. command .. "\" \"" .. txt:GetValue() .. "\"")
--     fr:Close()
--   end
-- end
-- local function LogMenu(title, data)
--   if IsValid(plogs.Menu) then
--     plogs.Menu:SetVisible(false)
--   end
--   if IsValid(plogs.LogMenu) then
--     plogs.LogMenu:Remove()
--   end
--   local w, h = plogs.cfg.Width * ScrW(), plogs.cfg.Height * ScrH()
--   local fr = vgui.Create("plogs_frame")
--   fr:SetTitle("Search")
--   fr:SetSize(w, h)
--   fr:SetTitle(title)
--   fr:Center()
--   fr._Close = fr.Close
--   fr.Close = function(self)
--     if IsValid(plogs.Menu) then
--       plogs.Menu:SetVisible(true)
--     end
--     fr:_Close()
--   end
--   plogs.LogMenu = fr
--   local logList = vgui.Create("DListView", fr)
--   logList:SetPos(0, 29)
--   logList:SetSize(fr:GetWide(), fr:GetTall() - 29)
--   logList:SetMultiSelect(false)
--   logList:AddColumn("Date"):SetFixedWidth(175)
--   logList:AddColumn("Data")
--   logList.OnRowSelected = function(parent, line)
--     local column   = logList:GetLine(line)
--     local log     = column:GetColumnText(2)
--     local menu     = DermaMenu()
--     menu:SetSkin("pLogs")
--     menu:AddOption("Copy Line", function()
--       SetClipboardText(log)
--       LocalPlayer():ChatPrint("Copied Line")
--     end)
--     menu:Open()
--   end
--   for k, v in ipairs(data) do
--     logList:AddLine(isstring(v.Date) and v.Date or os.date("%X - %d/%m/%Y", v.Date), v.Data)
--   end
-- end
local string_find = string.find
local string_lower = string.utf8lower
local c = 1
local saveList
local first
local function OpenMenu()
	local w, h = plogs.cfg.Width * ScrW(), plogs.cfg.Height * ScrH()
	c = 1
	local fr = plogs.Menu
	if IsValid(fr) then fr:Remove() end
	local count = table.Count(plogs.data)
	local fr = vgui.Create("plogs_frame")
	fr:SetSize(w, h)
	fr:Center()
	fr._Close = fr.Close
	fr.Close = function(self)
		if IsValid(plogs.SearchMenu) then plogs.SearchMenu:Close() end
		fr:_Close()
	end

	fr.PaintOver = function(self, w, h) if c < count then plogs.draw.Box(0, 0, w * c / count, 4, plogs.ui.ProgressBar) end end
	plogs.Menu = fr
	local tabs = vgui.Create("plogs_tablist", fr)
	tabs:SetPos(0, 29)
	tabs:SetSize(w, h - 29)
	plogs.Menu.Tabs = tabs
	local logsRow = {}
	for typeName, logData in pairs(plogs.data) do
		local pnl = vgui.Create("DPanel", tabs)
		local bool
		if not IsValid(first) then
			bool = true
			first = pnl
		end

		tabs:AddTab(typeName, pnl, bool)
		local lbl = Label("Search:", pnl)
		lbl:SetFont("plogs.ui.22")
		lbl:SetTextColor(plogs.ui.Close)
		lbl:SetPos(5, pnl:GetTall() - 28)
		local txt = vgui.Create("DTextEntry", pnl)
		txt:SetPos(75, pnl:GetTall() - 30)
		txt:SetSize(pnl:GetWide() - 80, 25)
		txt:SetFont("plogs.ui.22")
		txt:SetUpdateOnType(true)
		local lastSearchTyped = 0
		txt.OnValueChange = function(self, value) lastSearchTyped = CurTime() end
		local logList = vgui.Create("DListView", pnl)
		logList:SetPos(0, 0)
		logList:SetSize(pnl:GetWide(), pnl:GetTall() - 35)
		logList:SetMultiSelect(false)
		logList:AddColumn("Time"):SetFixedWidth(75)
		logList:AddColumn("Data")
		logList.logType = typeName
		logList.OnRowRightClick = function(parent, line)
			local column = logList:GetLine(line)
			local log = column:GetColumnText(2)
			local time = column:GetColumnText(1)
			local menu = DermaMenu()
			local logData = column.log
			menu:SetSkin("pLogs")
			menu:AddOption("Copy Line", function()
				SetClipboardText("[" .. time .. "] " .. log)
				LocalPlayer():ChatPrint("Copied Line")
			end)

			for name, value in SortedPairs(logData.Copy or {}) do
				menu:AddOption("Copy " .. name, function()
					SetClipboardText(value or "ERROR")
					LocalPlayer():ChatPrint("Copied " .. name)
				end)
			end

			if logData.params then
				menu:AddSpacer()
				menu:AddSpacer()
				menu:AddSpacer()
				for k, data in ipairs(logData.params) do
					menu:AddOption(data.text, function() netstream.Start("plogs.Action", logList.logType, k, {logData.Date, logData.Data}) end)
				end
			end

			menu:Open()
		end

		logList.LastSearch = ""
		pnl.Data = {}
		logList.Clear = function(self)
			local lines = self:GetLines()
			for i = 1, #lines do
				self:RemoveLine(i)
			end

			-- for k, v in pairs(self:GetLines()) do
			--   self:RemoveLine(k)
			-- end
			pnl.Data = {}
		end

		logList.AddLog = function(self, log)
			local line = self:AddLine(log.Date, log.Data)
			line.log = log
			pnl.Data[#pnl.Data + 1] = log
		end

		logList.AddLogs = function(self, data)
			-- for _, log in SortedPairs(data) do
			--   self.AddLog(self, log)
			-- end
			local dataLength = #data
			local i = 0
			local hookName = "addLogs" .. typeName
			hook.Deferred(hookName, ADDLOG_PER_SECOND, function()
				if not IsValid(plogs.Menu) or self.Searched and self:GetParent() == tabs.CurrentTab then return true end
				i = i + 1
				if i >= dataLength then return true end
				self:AddLog(data[i])
			end)
		end

		logList.Search = function(self, find)
			local data = plogs.data[typeName]
			if table.IsEmpty(data) then return end
			local dataLength = #data
			local i = 0
			local selfParent = self:GetParent()
			hook.Deferred("searchPlogs_" .. find, SEARCH_PER_SECOND, function()
				if not IsValid(plogs.Menu) or selfParent ~= tabs.CurrentTab or not self.Searched or self.LastSearch ~= find then return true end
				i = i + 1
				if i >= dataLength then return true end
				local log = data[i]
				if string_find(string_lower(log.Data), string_lower(find), 1, true) then
					local line = self:AddLine(log.Date, log.Data)
					line.log = log
					pnl.Data[#pnl.Data + 1] = log
				end
			end)
		end

		logList.Think = function(self)
			if CurTime() - lastSearchTyped <= 0.5 then return end
			local tosearch = string.Trim(txt:GetValue())
			if tosearch ~= "" and tosearch ~= self.LastSearch then
				self:Clear()
				self.LastSearch = tosearch
				self.Searched = true
				self:Search(tosearch)
			elseif tosearch == "" and tosearch ~= self.LastSearch then
				self:Clear()
				self.LastSearch = tosearch
				self.Searched = false
				self:AddLogs(plogs.data[typeName])
			end
		end

		logList:AddLogs(logData)
		logsRow[typeName] = {
			logList = logList
		}

		c = c + 1
	end

	tabs.logsRow = logsRow
	if plogs.cfg.EnableMySQL then
		tabs:AddButton("Player Events", function() Search("playerevents") end)
		if plogs.cfg.IPUserGroups[string_lower(LocalPlayer():GetUserGroup())] then tabs:AddButton("IP logs", function() Search("ipsearch") end) end
	end
end

local function loadMenuStream(streamData)
	streamData = pon.decode(streamData)
	for name, data in pairs(streamData) do
		local plogsData = plogs.data[name]
		if not plogsData then
			plogs.data[name] = data
		else
			local plogsCache = plogs.logCache
			for k, v in ipairs(data) do
				local concat = v.Date .. v.Data
				if not plogsCache[concat] then table.insert(plogsData, 1, v) end
			end
		end
	end

	plogs.logCache = nil
	if not IsValid(plogs.Menu) then OpenMenu() end
end

-- netstream.Hook("send_plogs_menu", function(name, data)
net.Receive("plogs.FirstOpenMenu", function() net.ReadStream(nil, loadMenuStream) end)
-- local logsCount = net.ReadUInt(6)
-- for i = 1, logsCount do
--   local logType = net.ReadString()
--   net.ReadStream(nil, function(streamData)
--     loadMenuStream(logType, streamData)
--     if i == logsCount then
--       if not IsValid(plogs.Menu) then OpenMenu() end
--     end
--   end)
-- end
net.Receive("plogs.OpenMenu", function() if not IsValid(plogs.Menu) then OpenMenu() end end)
-- net.Receive("plogs.LogData", function()
--   local title = net.ReadString()
--   local size = net.ReadUInt(16)
--   local data = plogs.Decode(net.ReadData(size))
--   LogMenu(title, data)
-- end)
-- netstream.Hook("send_plogs_data", function()
--   -- local title = net.ReadString()
--   -- local size = net.ReadUInt(16)
--   -- local data = plogs.Decode(net.ReadData(size))
--   LogMenu(title, data)
-- end)
