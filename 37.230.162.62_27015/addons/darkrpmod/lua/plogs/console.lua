local color_white = Color(245, 245, 245)
-- net.Receive('plogs.Console', function()
-- 	local id 	= net.ReadString()
-- 	local str 	= net.ReadString()
-- 	local log = plogs.types[id]
-- 	if log then
-- 		MsgC(log.Color, '[' .. id .. ' | ' .. os.date('%H:%M:%S', os.time()) ..  ']', color_white, str .. '\n')
-- 	end
-- end)
plogs.logCache = {}
netstream.Hook("plogs.Console", function(isNetwork, tabData)
	local type, date, str, copy, params = tabData[1], tabData[2], tabData[3], tabData[4], tabData[5]
	if isNetwork then
		local log = plogs.types[id]
		if log then MsgC(log.Color, "[" .. id .. " | " .. os.date("%H:%M:%S", os.time()) .. "]", color_white, str .. "\n") end
	end

	local logsData = plogs.data[type]
	local fmtTab = {
		Date = date,
		Data = str,
		Copy = copy,
		params = params
	}

	if plogs.logCache then plogs.logCache[date .. str] = true end
	if logsData then
		table.insert(logsData, 1, fmtTab)
		local plogsMenu = plogs.Menu
		if IsValid(plogsMenu) then
			local tabs = plogsMenu.Tabs
			local dataRow = tabs.logsRow[type]
			local logList = dataRow and dataRow.logList
			if logList and not logList.Searched then
				logList:AddLog(fmtTab)
				if logList:GetParent() == tabs.CurrentTab then logList:SortByColumn(1, true) end
			end
		end
	else
		plogs.data[type] = fmtTab
	end
end)
