-- luacheck: globals netstream CreateClientConVar surface
include("shared.lua")
surface.CreateFont("radio_1", {
	font = "digital-7",
	size = 45,
	weight = 400,
})

surface.CreateFont("radio_2", {
	font = "digital-7",
	size = 20,
	weight = 500,
})

local function S(v)
	return ScrH() * (v / 900)
end

local radio_mat = Material("unionrp/radio/148.png")
local cur_freq = 1
local old_freqs = {
	"0", --Переключение между групповой и обычной.
	"0",
	"0"
}

local stored_freqs = {
	"0", --Переключение между частотами.
	"0",
	"0"
}

local radio_frame
local function radio_edit(bool)
	net.Start("radio.edit")
	net.WriteBool(bool)
	net.SendToServer()
end

local function radio_menu()
	local lp = LocalPlayer()
	local freq = lp:GetFreq()
	local frame = vgui.Create("DFrame")
	frame:SetSize(256, ScrH())
	frame:Center()
	frame:MakePopup()
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(radio_mat)
		surface.DrawTexturedRect(0, 0, w, h)
		local pos = h * 0.595
		draw.RoundedBox(0, 53, pos, 150, 1, color_black)
	end

	frame.OnClose = function(self)
		radio_edit(false)
		radio_frame = nil
	end

	frame.OnKeyCodePressed = function(self, key) if key == KEY_R then radio_edit(false) end end
	radio_frame = frame
	local fw = frame:GetTall()
	local col_bl = Color(20, 20, 20, 255)
	local lb = frame:Add("DLabel")
	lb:SetPos(73, fw * 0.575)
	lb:SetTextColor(col_bl)
	lb:SetFont("radio_2")
	lb:SetText("CHN: " .. cur_freq)
	lb:SizeToContents()
	local st = lp:isRadioDisabled() and "Off" or "On"
	local lb1 = frame:Add("DLabel")
	lb1:SetPos(130, fw * 0.575)
	lb1:SetTextColor(col_bl)
	lb1:SetFont("radio_2")
	lb1:SetText("ST: " .. st)
	lb1:SizeToContents()
	local dte = frame:Add("DTextEntry")
	dte:SetSize(128, S(50))
	dte:SetPos(65, fw * 0.59)
	dte:SetFont("radio_1")
	dte:SetText(freq)
	dte:SetDrawBackground(false)
	dte:SetNumeric(true)
	dte.OnMousePressed = function(self) if not self:IsEditing() then radio_edit(true) end end
	dte.OnEnter = function(self)
		local text = self:GetText()
		local freq = tonumber(text)
		RunConsoleCommand("radio_set_channel", text)
		if not isnumber(freq) then
			return
		elseif text == "0" and (freq < 111 or freq > 999 or not text:find("^(%d%d%d.%d)$") and not text:find("^(%d%d%d)$")) then
			return
		end

		stored_freqs[cur_freq] = text
		radio_edit(false)
	end

	dte.OnTextChanged = function(self)
		local txt = self:GetText()
		local num = string.len(txt)
		if num > 5 then
			local change_text = txt:sub(1, -2)
			local num_text = string.len(change_text)
			self:SetText(change_text)
			self:SetCaretPos(num_text)
		end
	end

	-- Мод
	local db1 = frame:Add("DButton")
	db1:SetSize(40, S(20))
	db1:SetPos(48, fw * 0.675)
	db1:SetText("")
	db1:SetTooltip("Смена текущей частоты на групповую и обратно")
	db1.Paint = function() end
	db1.DoClick = function(self)
		surface.PlaySound("dradio/radio_soft.wav")
		local freq = tostring(lp:GetFreq())
		local of = old_freqs
		local sf = stored_freqs
		local zero = "0"
		if freq ~= zero then
			of[cur_freq] = freq
			sf[cur_freq] = zero
			RunConsoleCommand("radio_set_channel", zero)
			dte:SetText(0)
		else
			local o_f = of[cur_freq]
			local txt = o_f ~= zero and o_f or "111.1"
			of[cur_freq] = txt
			sf[cur_freq] = txt
			RunConsoleCommand("radio_set_channel", txt)
			dte:SetText(txt)
		end
	end

	-- Выйти
	local db2 = frame:Add("DButton")
	db2:SetSize(40, S(20))
	db2:SetPos(168, fw * 0.675)
	db2:SetText("")
	db2:SetTooltip("Закрыть меню рации")
	db2.Paint = function() end
	db2.DoClick = function(self)
		surface.PlaySound("dradio/radio_soft.wav")
		radio_edit(false)
		if IsValid(radio_frame) then
			radio_frame:Remove()
			radio_frame = nil
		end
	end

	--Частота вниз
	local db3 = frame:Add("DButton")
	db3:SetSize(40, S(20))
	db3:SetPos(48, fw * 0.707)
	db3:SetText("")
	db3:SetTooltip("Быстрый доступ к предыдущей сохраненной частоту")
	db3.Paint = function() end
	db3.DoClick = function(self)
		surface.PlaySound("dradio/radio_switch.wav")
		local freq = tostring(lp:GetFreq())
		cur_freq = cur_freq - 1
		if cur_freq < 1 then cur_freq = 3 end
		local ret = stored_freqs[cur_freq]
		dte:SetText(ret)
		lb:SetText("CHN " .. cur_freq)
		lb:SizeToContents()
		RunConsoleCommand("radio_set_channel", ret)
	end

	--Частота вверх
	local db4 = frame:Add("DButton")
	db4:SetSize(40, S(20))
	db4:SetPos(108, fw * 0.707)
	db4:SetText("")
	db4:SetTooltip("Быстрый доступ к следующей сохраненной частоту")
	db4.Paint = function() end
	db4.DoClick = function(self)
		surface.PlaySound("dradio/radio_switch.wav")
		local freq = tostring(lp:GetFreq())
		cur_freq = cur_freq + 1
		if cur_freq > 3 then cur_freq = 1 end
		local ret = stored_freqs[cur_freq]
		dte:SetText(ret)
		lb:SetText("CHN " .. cur_freq)
		lb:SizeToContents()
		RunConsoleCommand("radio_set_channel", ret)
	end

	-- Установить частоту
	local db5 = frame:Add("DButton")
	db5:SetSize(40, S(20))
	db5:SetPos(168, fw * 0.707)
	db5:SetText("")
	db5:SetTooltip("Установить частоту")
	db5.Paint = function() end
	db5.DoClick = function(self)
		surface.PlaySound("dradio/radio_soft.wav")
		dte:OnEnter()
	end

	-- Выключить рацию
	local db6 = frame:Add("DButton")
	db6:SetSize(40, S(30))
	db6:SetPos(40, fw * 0.74)
	db6:SetText("")
	db6:SetTooltip("Выключить/Включить рацию")
	db6.Paint = function() end
	db6.DoClick = function(self)
		surface.PlaySound("dradio/radio_soft.wav")
		RunConsoleCommand("radio_toggle")
		if lp:isRadioDisabled() then
			local freq = lp:GetFreq()
			dte:SetText(freq)
			dte:SetDisabled(false)
			lb1:SetText("ST: On")
			lb1:SizeToContents()
		else
			dte:SetDisabled(true)
			lb1:SetText("ST: Off")
			lb1:SizeToContents()
		end
	end
end

net.Receive("radio.edit", function()
	if IsValid(radio_frame) then
		radio_frame:Remove()
		radio_frame = nil
	end

	local bool = net.ReadBool()
	if bool then radio_menu() end
end)

function SWEP:PostDrawViewModel(vm, weapon, ply)
	if weapon:GetClass() == "weapon_radio" and IsValid(self) then
		local bone = vm:LookupBone("ValveBiped.Bip01_R_Hand")
		if not bone then return end
		local bonePos, boneAng = vm:GetBonePosition(bone)
		local textPos = bonePos + boneAng:Forward() * 4.9 + boneAng:Right() * 2.66 + boneAng:Up() * -2.89
		local textAngle = boneAng

		textAngle:RotateAroundAxis(textAngle:Right(), 191)
		textAngle:RotateAroundAxis(textAngle:Up(), -3.1)
		textAngle:RotateAroundAxis(textAngle:Forward(), 90)

		cam.Start3D2D(textPos, textAngle, .01)
		surface.SetDrawColor(175, 199, 139, 255)
		surface.DrawRect(0, 0, 140, 60)

		local freq = LocalPlayer():GetFreq()
		draw.SimpleText(freq, "radio_1", 140 / 2, 60 / 2, Color(50, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end

function SWEP:Think()
end
