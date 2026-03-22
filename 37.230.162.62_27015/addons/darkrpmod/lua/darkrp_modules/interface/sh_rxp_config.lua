RXPrinters_Config = {}
--================ FONTS ================//
if CLIENT then
	surface.CreateFont("RXP_Header", {
		font = "Inter",
		size = 22,
		weight = 300,
		extended = true,
	})

	surface.CreateFont("RXP_Money", {
		font = "Inter",
		size = 36,
		weight = 300,
		extended = true,
	})

	surface.CreateFont("RXP_Hull", {
		font = "Inter",
		size = 15,
		weight = 100,
		extended = true,
		outline = true
	})

	-- VGUI
	surface.CreateFont("RXPV_Header", {
		font = "Inter",
		size = 25,
		weight = 300,
		extended = true
	})

	surface.CreateFont("RXPV_Text1", {
		font = "Inter",
		size = 23,
		weight = 300,
		extended = true
	})
end

--================ ADVANCED ================//
-- Define Admin
function RXP_IsAdmin(ply)
	local ULXRank = ply:GetUserGroup()
	local VIPs = {
		"superadmin", -- you can add more.
		"admin",
		"owner"
	}

	if table.HasValue(VIPs, ULXRank) then return true end
	return false
end

--================ PERFORMANCE SETTING ================//
-- Since RXPrinter is made with many small props, It is recommended to optimize them. so save FPS
RXPrinters_Config.RenderDist = 200 * 200 -- Maximim Render Distance.

--================ PRINTERS COMMON SETTING ================//
RXPrinters_Config.CanStealMoney = true -- ( true / false )
--People can steal money from others printers.

RXPrinters_Config.ErrorCodeMessage = {}
RXPrinters_Config.ErrorCodeMessage[1] = "Полный"
RXPrinters_Config.ErrorCodeMessage[2] = "Сломан"
RXPrinters_Config.ErrorCodeMessage[3] = "Изношен"

-- NOTICE
RXPrinters_Config.Notice_BreakDown = true -- Send a message to owner if printer is breakdown
RXPrinters_Config.Notice_Explode = true -- Send a message to owner if printer is exploded

function RXPrinters_Config.CheckLocalUpgrades(printer, name)
	local lu = printer.Upgrades[name]
	if lu == false then
		return true -- is restricted?
	elseif lu then
		return false, lu.Price, lu.MaxLevel
	end
end
