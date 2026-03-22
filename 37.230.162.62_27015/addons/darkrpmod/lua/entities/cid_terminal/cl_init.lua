include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH
local combineMat = Material("models/props_combine/combine_intmonitor001_disp")
local colorGray = Color(20, 20, 20, 255)
local colorPWhite = Color(168, 167, 168, 255)

surface.CreateFont("johnnyhats_19", {
	font = "Roboto",
	size = 28,
	weight = 500,
	extented = true,
})

function ENT:Draw(flags)
	self:DrawModel(flags)
	local getPos = self:GetPos()
	local distance, lim = getPos:DistToSqr(EyePos()), 500 * 500
	if distance > lim then return end

	local pos, ang = LocalToWorld(Vector(13, -7, 20), Angle(0, 90, 90), getPos, self:GetAngles())
	cam.Start3D2D(pos, ang, 0.1)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(combineMat)
	surface.DrawTexturedRect(0, 0, 170, 180)
	-- draw.RoundedBox(0, 0, 0, 170, 180, Color(13, 168, 135))
	draw.RoundedBox(0, 0, 60, 170, 60, colorGray)
	draw.SimpleText("Терминал CID", "johnnyhats_19", 15, 75, colorPWhite, 0, 0)
	cam.End3D2D()
end

surface.CreateFont("CID.MainFont", {
	font = "ROBO",
	size = 20,
	extented = true,
})

-- https://github.com/wyozi-gmod/mistdm/blob/master/gamemode/client/scoreboard.lua
local g_grds, g_wgrd, g_sz
local function gradientBox(x, y, w, h, al, ...)
	g_grds = {...}
	al = math.Clamp(math.floor(al), 0, 1)
	if al == 1 then
		local t = w
		w, h = h, t
	end

	g_wgrd = w / (#g_grds - 1)
	local n
	for i = 1, w do
		for c = 1, #g_grds do
			n = c
			if i <= g_wgrd * c then break end
		end

		g_sz = i - g_wgrd * (n - 1)
		surface.SetDrawColor(Lerp(g_sz / g_wgrd, g_grds[n].r, g_grds[n + 1].r), Lerp(g_sz / g_wgrd, g_grds[n].g, g_grds[n + 1].g), Lerp(g_sz / g_wgrd, g_grds[n].b, g_grds[n + 1].b), Lerp(g_sz / g_wgrd, g_grds[n].a, g_grds[n + 1].a))
		if al == 1 then
			surface.DrawRect(x, y + i, h, 1)
		else
			surface.DrawRect(x + i, y, 1, h)
		end
	end
end

-- local gradient = Material("gui/gradient")
local interfaceMaterial = Material("unionrp/ui/if.jpg", "smooth")
-- local interfaceButton = Material("testshit1.png", "noclamp smooth")
local SScale = util.SScale
local cidMenu, locked, accepted
local colorGradient1, colorGradient2 = Color(0, 207, 235, 255), Color(38, 145, 190, 255)
local colorGradient3, colorGradient4 = Color(0, 207, 235, 165), Color(38, 145, 190, 165)
-- local colorGradient3, colorGradient4 = Color(0, 181, 253, 165), Color(38, 145, 190, 200)
local color_green = Color(0, 122, 31)
local color_red = Color(255, 0, 0)
local color_lightgray = Color(220, 220, 220)
local color_lightdark = Color(0, 0, 0, 140)
local color_lightdarkbg = Color(0, 0, 0, 100)
netstream.Hook("CID.openMenu", function(curCID, isVIP, checked, t1, t2)
	local wSize, hSize = SScale(800), SScale(600)
	if not IsValid(cidMenu) then
		local mn = vgui.Create("DFrame")
		mn:SetSize(wSize, hSize)
		mn:Center()
		mn:MakePopup()
		mn:SetTitle("")
		mn:ShowCloseButton(false)
		mn:SetDraggable(false)
		mn.Paint = function(self, w, h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(interfaceMaterial)
			surface.DrawTexturedRect(0, 0, w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_lightdarkbg)
		end

		cidMenu = mn
		local closer = mn:Add("DButton")
		closer:SetSize(40, 18)
		closer:SetPos(mn:GetWide() - 35, 2)
		closer:SetText("")
		closer.Paint = function(self, w, h) draw.SimpleText("X", "CID.MainFont", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
		closer.DoClick = function(self) mn:Remove() end
		local dp1 = mn:Add("DPanel")
		dp1:Dock(TOP)
		dp1:SetTall(hSize * 0.1)
		dp1.Paint = function() end

		local label = vgui.Create("DLabel", dp1)
		label:Dock(RIGHT)
		label:SetWide(wSize * 0.3)
		-- label:SetFont("CID.MainFont")
		-- label:SetText("Current CID: " .. curCID)
		label:SetText("")
		-- label:SetTextColor(color_lightgray)
		local labelText = "Current CID: " .. curCID
		label.Paint = function(self, w, h)
			-- label2Text
			draw.SimpleTextOutlined(labelText, "CID.MainFont", 0, h * 0.3, color_lightgray, nil, nil, 0.5, color_lightdark)
		end

		local dp2 = mn:Add("DPanel")
		dp2:Dock(TOP)
		local lrMargin = wSize * 0.03
		dp2:DockMargin(lrMargin, lrMargin, lrMargin * 1.6, 0)
		dp2:SetTall(hSize * 0.75)
		dp2.Paint = function() end

		local dp3 = dp2:Add("DPanel")
		dp3:Dock(RIGHT)
		dp3:SetWide(wSize * 0.6)
		dp3.Paint = function() end

		local label1 = dp3:Add("DLabel")
		label1:Dock(TOP)
		label1:DockMargin(wSize * 0.23, hSize * 0.01, 0, 0)
		label1:SetTall(hSize * 0.1)
		-- label1:SetFont("CID.MainFont")
		-- label1:SetText("Selected CID: " .. curCID)
		label1:SetText("")
		-- label1:SetTextColor(color_lightgray)
		local label1Text = "Selected CID: " .. curCID
		local label1TextColor = color_lightgray
		label1.Paint = function(self, w, h)
			-- label2Text
			draw.SimpleTextOutlined(label1Text, "CID.MainFont", 0, h * 0.2, label1TextColor, nil, nil, 0.5, color_lightdark)
		end

		local label2 = dp3:Add("DLabel")
		label2:Dock(TOP)
		label2:DockMargin(wSize * 0.05, 0, 0, 0)
		label2:SetTall(hSize * 0.05)
		-- label2:SetFont("CID.MainFont")
		-- label2:SetText("Change price: " .. DarkRP.formatMoney(CID.changeTempPrice))
		label2:SetText("")

		local textColor = not LocalPlayer():canAfford(CID.changeTempPrice) and color_red or color_lightgray
		-- label2:SetTextColor(textColor)
		-- label2:SetContentAlignment(1)
		local label2Text = "Change price: " .. DarkRP.formatMoney(CID.changeTempPrice)
		label2.Paint = function(self, w, h)
			-- label2Text
			draw.SimpleTextOutlined(label2Text, "CID.MainFont", 0, h * 0.3, textColor, nil, nil, 0.5, color_lightdark)
		end

		local butg = dp3:Add("DButton")
		butg:Dock(TOP)
		butg:DockMargin(wSize * 0.05, hSize * 0.01, wSize * 0.1, 0)
		butg:SetTall(hSize * 0.1)
		butg:SetText("")
		butg.DoClick = function(self)
			mn:Remove()
			netstream.Start("CID.apply")
		end

		butg.Paint = function(self, w, h)
			-- surface.SetDrawColor(255, 255, 255, 255)
			-- surface.SetMaterial(interfaceButton)
			-- surface.DrawTexturedRect(0, 0, w, h)
			-- draw.RoundedBox(0, 0, 0, w, h, Color(62, 165, 208, 255))
			local col1, col2 = colorGradient1, colorGradient2
			if self:IsDown() then
				col1, col2 = col1:darken(100), col2:lighten(50)
			elseif self:IsHovered() then
				col1, col2 = col1:lighten(50), col2:darken(25)
			end

			gradientBox(0, 0, w, h, 1, col1, col2)
			draw.SimpleText("G E N E R A T E", "CID.MainFont", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(0, 0, 0, 155)
			surface.DrawOutlinedRect(0, 0, w, h, 1.5)
		end

		local label3 = dp3:Add("DLabel")
		label3:Dock(TOP)
		label3:DockMargin(wSize * 0.1, hSize * 0.04, 0, 0)
		label3:SetTall(hSize * 0.05)
		-- label3:SetFont("CID.MainFont")
		-- label3:SetText("Change price: " .. DarkRP.formatMoney(CID.changePrice))
		label3:SetText("")
		local textColor = not LocalPlayer():canAfford(CID.changePrice) and color_red or color_lightgray
		-- label3:SetTextColor(textColor)
		-- label3:SetContentAlignment(1)
		local label3Text = "Change price: " .. DarkRP.formatMoney(CID.changePrice)
		label3.Paint = function(self, w, h)
			-- label2Text
			draw.SimpleTextOutlined(label3Text, "CID.MainFont", 0, h * 0.2, textColor, nil, nil, 0.5, color_lightdark)
		end

		local dtext = dp3:Add("DTextEntry")
		dtext:Dock(TOP)
		dtext:SetTall(hSize * 0.1)
		dtext:DockMargin(wSize * 0.1, hSize * 0.01, 0, 0)
		dtext:SetFont("CID.MainFont")
		dtext:SetNumeric(true)
		dtext:SetTabbingDisabled(true)
		dtext:SetEnterAllowed(false)
		dtext.PaintOver = function(self, w, h) gradientBox(0, 0, w, h, 1, colorGradient3, colorGradient4) end
		dtext.OnChange = function(self)
			local text = self:GetValue()
			text = text ~= "" and text or curCID
			-- label1:SetText("Selected CID: " .. text)
			label1Text = "Selected CID: " .. text
		end

		dtext.AllowInput = function(self, strValue)
			if not string.match(strValue, "^(%d+)$") then return true end
			if #self:GetValue() >= CID.defaultLen then return true end
		end

		function locked()
			-- label1:SetTextColor(color_red)
			label1TextColor = color_red
			if dp3.buttonAccept then dp3.buttonAccept:SetDisabled(true) end
			dp3.buttonCheck:SetDisabled(true)
			butg:SetDisabled(true)
			dtext:SetEditable(false)
			surface.PlaySound("buttons/combine_button_locked.wav")
			timer.Simple(2, function()
				if IsValid(label1) then
					-- label1:SetTextColor(color_lightgray)
					label1TextColor = color_lightgray
					if dp3.buttonAccept then dp3.buttonAccept:SetDisabled(false) end
					dp3.buttonCheck:SetDisabled(false)
					butg:SetDisabled(false)
					dtext:SetEditable(true)
				end
			end)
		end

		function accepted()
			-- label1:SetTextColor(color_green)
			label1TextColor = color_green
			if dp3.buttonAccept then dp3.buttonAccept:SetDisabled(true) end
			dp3.buttonCheck:SetDisabled(true)
			butg:SetDisabled(true)
			dtext:SetEditable(false)
			surface.PlaySound("buttons/combine_button1.wav")
			timer.Simple(2, function()
				if IsValid(label1) then
					-- label1:SetTextColor(color_lightgray)
					label1TextColor = color_lightgray
					if dp3.buttonAccept then dp3.buttonAccept:SetDisabled(false) end
					dp3.buttonCheck:SetDisabled(false)
					butg:SetDisabled(false)
					dtext:SetEditable(true)
				end
			end)
		end

		local butc = dp3:Add("DButton")
		butc:Dock(TOP)
		butc:DockMargin(wSize * 0.1, hSize * 0.015, wSize * 0.05, 0)
		butc:SetTall(hSize * 0.1)
		butc:SetText("")
		butc.DoClick = function(self)
			local cid = dtext:GetValue()
			local cidLen = #cid
			local cidAccepted = CID.acceptedCID[cidLen]
			if not cidAccepted or not string.match(cid, cidAccepted) then
				locked(self)
				return
			end

			if dp3.buttonAccept then dp3.buttonAccept:SetDisabled(true) end
			self:SetDisabled(true)
			butg:SetDisabled(true)
			dtext:SetEditable(false)
			netstream.Start("CID.check", cid)
		end

		butc.Paint = function(self, w, h)
			-- surface.SetDrawColor(255, 255, 255, 255)
			-- surface.SetMaterial(interfaceButton)
			-- surface.DrawTexturedRect(0, 0, w, h)
			-- draw.RoundedBox(0, 0, 0, w, h, Color(62, 165, 208, 255))
			local col1, col2 = colorGradient1, colorGradient2
			if self:IsDown() then
				col1, col2 = col1:darken(100), col2:lighten(50)
			elseif self:IsHovered() then
				col1, col2 = col1:lighten(50), col2:darken(25)
			end

			gradientBox(0, 0, w, h, 1, col1, col2)
			draw.SimpleText("C H E C K", "CID.MainFont", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(0, 0, 0, 155)
			surface.DrawOutlinedRect(0, 0, w, h, 1.5)
		end

		dp3.buttonCheck = butc
		local dp4 = dp2:Add("DPanel")
		dp4:Dock(BOTTOM)
		-- local lrMargin = wSize * 0.03
		-- dp4:DockMargin(lrMargin, lrMargin, lrMargin * 1.6, 0)
		-- dp4:SetTall(hSize * 0.75)
		dp4:SetTall(hSize * 0.1)
		dp4.Paint = function() end
		local reset = dp4:Add("DButton")
		reset:Dock(FILL)
		-- reset:DockMargin(wSize * 0.2, hSize * 0.015, wSize * 0.05, 0)
		reset:DockMargin(wSize * 0.05, 0, wSize * 0.05, 0)
		reset:SetTall(hSize * 0.1)
		reset:SetText("")
		reset.DoClick = function(self)
			mn:Remove()
			netstream.Start("CID.reset")
		end

		reset.Paint = function(self, w, h)
			-- surface.SetDrawColor(255, 255, 255, 255)
			-- surface.SetMaterial(interfaceButton)
			-- surface.DrawTexturedRect(0, 0, w, h)
			-- draw.RoundedBox(0, 0, 0, w, h, Color(62, 165, 208, 255))
			local col1, col2 = colorGradient1, colorGradient2
			if self:IsDown() then
				col1, col2 = col1:darken(100), col2:lighten(50)
			elseif self:IsHovered() then
				col1, col2 = col1:lighten(50), col2:darken(25)
			end

			gradientBox(0, 0, w, h, 1, col1, col2)
			draw.SimpleText("R E S E T", "CID.MainFont", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(0, 0, 0, 155)
			surface.DrawOutlinedRect(0, 0, w, h, 1.5)
		end

		dp4.buttonReset = reset
		if not isVIP then return end
		local buta = dp3:Add("DButton")
		buta:Dock(TOP)
		buta:DockMargin(wSize * 0.15, hSize * 0.015, wSize * 0.05, 0)
		buta:SetTall(hSize * 0.1)
		buta:SetText("")
		buta.DoClick = function(self)
			local cid = dtext:GetValue()
			if not string.match(cid, CID.acceptedCID[CID.defaultLen]) or CID.restrictedCID[cid] then
				locked(self)
				return
			end

			mn:Remove()
			netstream.Start("CID.apply", cid, isVIP)
		end

		buta.Paint = function(self, w, h)
			-- surface.SetDrawColor(255, 255, 255, 255)
			-- surface.SetMaterial(interfaceButton)
			-- surface.DrawTexturedRect(0, 0, w, h)
			-- draw.RoundedBox(0, 0, 0, w, h, Color(62, 165, 208, 255))
			local col1, col2 = colorGradient1, colorGradient2
			if self:IsDown() then
				col1, col2 = col1:darken(100), col2:lighten(50)
			elseif self:IsHovered() then
				col1, col2 = col1:lighten(50), col2:darken(25)
			end

			gradientBox(0, 0, w, h, 1, col1, col2)
			draw.SimpleText("A C C E P T", "CID.MainFont", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(0, 0, 0, 155)
			surface.DrawOutlinedRect(0, 0, w, h, 1.5)
		end

		dp3.buttonAccept = buta
	else
		if checked then
			locked()
		else
			accepted()
		end
	end
end)
