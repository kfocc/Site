surface.CreateFont("CID.donate.menu.big", {
	font = "Roboto",
	size = 25,
	weight = 500,
	extented = true,
})

surface.CreateFont("CID.donate.menu", {
	font = "Roboto",
	size = 17,
	weight = 500,
	extented = true,
})

local function buttonPaintFunc(self, w, h)
	local col1 = col.o
	if self:IsHovered() then col1 = col1:lighten(50) end

	surface.SetDrawColor(col1)
	surface.DrawRect(0, 0, w, h)
	-- surface.SetDrawColor(col.oa)
	-- surface.DrawRect(0, h / 2, w, h / 2)
end

local SScale = util.SScale
local cidMenu, locked, accepted
local color_green = Color(0, 122, 31)
local color_red = Color(255, 0, 0)
local defWarnText = "Проверьте CID перед установкой."
netstream.Hook("CID.donate.openMenu", function(cidLen, cid, isDuplicated)
	if not IsValid(cidMenu) then
		local frame = vgui.Create("DFrame")
		local w, h = SScale(800), SScale(175)
		local wFrame = w * 0.512
		frame:SetSize(wFrame, h)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("Смена CID")
		cidMenu = frame
		frame.Paint = function(_, w, h)
			draw.RoundedBox(0, 0, 0, w, h, col.ba)
			draw.RoundedBox(0, 0, 0, w, 23, col.o)
		end

		local dl = frame:Add("DLabel")
		dl:Dock(TOP)
		dl:SetTall(SScale(25))
		dl:SetFont("CID.donate.menu.big")
		dl:SetText("Введите CID, длиной: " .. cidLen .. ".")
		dl:SetContentAlignment(5)

		local dl1 = frame:Add("DLabel")
		dl1:Dock(TOP)
		dl1:DockMargin(0, SScale(5), 0, 0)
		dl1:SetTall(SScale(25))
		dl1:SetFont("CID.donate.menu")
		dl1:SetText(defWarnText)
		dl1:SetContentAlignment(5)

		local dtext = frame:Add("DTextEntry")
		dtext:Dock(BOTTOM)
		dtext:SetTall(SScale(35))
		-- dtext:SetFont("CID.MainFont")
		dtext:SetNumeric(true)
		dtext:SetTabbingDisabled(true)
		dtext:SetEnterAllowed(false)
		dtext.AllowInput = function(self, strValue)
			if not string.match(strValue, "^(%d+)$") then return true end
			if #self:GetValue() >= cidLen then return true end
		end

		local dp = frame:Add("DPanel")
		dp:Dock(BOTTOM)
		dp:SetTall(SScale(30))
		dp:DockMargin(0, 0, 0, SScale(5))
		dp.Paint = function() end

		local bApply
		local buttonsSize = wFrame * 0.485
		local bCheck = dp:Add("DButton")
		bCheck:SetText("Проверить")
		bCheck:SetTextColor(color_white)
		bCheck:Dock(LEFT)
		bCheck:DockMargin(0, 0, SScale(5), 0)
		bCheck:SetWide(buttonsSize)
		bCheck.Paint = buttonPaintFunc
		bCheck.DoClick = function(self)
			local cid = dtext:GetValue()
			local cidAccepted = CID.acceptedCID[cidLen]
			if #cid ~= cidLen or CID.restrictedCID[cid] or not string.match(cid, cidAccepted) then
				locked("Некорректный CID.")
				return
			end

			bApply:SetDisabled(true)
			self:SetDisabled(true)
			dtext:SetEditable(false)
			netstream.Start("CID.donate.check", cid)
		end

		bApply = dp:Add("DButton")
		bApply:SetText("Установить")
		bApply:SetTextColor(color_white)
		bApply:Dock(RIGHT)
		bApply:DockMargin(SScale(5), 0, 0, 0)
		bApply:SetWide(buttonsSize)
		bApply.Paint = buttonPaintFunc
		bApply.DoClick = function(self)
			local cid = dtext:GetValue()
			local cidAccepted = CID.acceptedCID[cidLen]
			if #cid ~= cidLen or CID.restrictedCID[cid] or not string.match(cid, cidAccepted) then
				locked("Некорректный CID.")
				return
			end

			frame:Remove()
			netstream.Start("CID.donate.apply", cid, isVIP)
		end

		function locked(text)
			dl1:SetTextColor(color_red)
			dl1:SetText(text)
			bCheck:SetDisabled(true)
			bApply:SetDisabled(true)
			dtext:SetEditable(false)
			surface.PlaySound("buttons/combine_button_locked.wav")
			timer.Simple(2, function()
				if IsValid(cidMenu) then
					dl1:SetText(defWarnText)
					dl1:SetTextColor(color_white)
					bCheck:SetDisabled(false)
					bApply:SetDisabled(false)
					dtext:SetEditable(true)
				end
			end)
		end

		function accepted(text)
			dl1:SetTextColor(color_green)
			dl1:SetText(text)
			bCheck:SetDisabled(true)
			bApply:SetDisabled(true)
			dtext:SetEditable(false)
			surface.PlaySound("buttons/combine_button1.wav")
			timer.Simple(2, function()
				if IsValid(cidMenu) then
					dl1:SetText(defWarnText)
					dl1:SetTextColor(color_white)
					bCheck:SetDisabled(false)
					bApply:SetDisabled(false)
					dtext:SetEditable(true)
				end
			end)
		end
	else
		if isDuplicated then
			locked("CID " .. cid .. " занят.")
		else
			accepted("CID " .. cid .. " свободен.")
		end
	end
end)
