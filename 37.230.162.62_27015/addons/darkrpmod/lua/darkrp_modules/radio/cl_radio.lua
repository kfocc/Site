-- luacheck: globals netstream CreateClientConVar surface
local bind_key_convar = CreateClientConVar("union_radio_bind_key", KEY_V, true, false, "Биндит вашу кнопку на рацию.")
local bind_key_mute = CreateClientConVar("union_radio_mute_key", KEY_L, true, false, "Биндит вашу кнопку для мута рации.")
local bind_settings_convar = CreateClientConVar("union_radio_settings_key", KEY_B, true, false, "Биндит вашу кнопку настройки рации ( для ГО и ОТА ).")

surface.CreateFont("radio_3", {
	font = "digital-7",
	size = 60,
	weight = 600,
})

surface.CreateFont("radio_4", {
	font = "digital-7",
	size = 20,
	weight = 500,
})

surface.CreateFont("radio_5", {
	font = "digital-7",
	size = 55,
	weight = 600,
})

local function S(v)
	return ScrH() * (v / 900)
end

local radio_mat = Material("unionrp/radio/microdagr.png")
local cur_freq = 1

--Переключение между групповой и обычной.
local old_freqs = {"0", "0", "0"}

--Переключение между частотами.
local stored_freqs = {"0", "0", "0"}

local radio_frame
local function radio_menu()
	local lp = LocalPlayer()
	if not (lp:isCP() and lp:isEnabledMask()) and not lp:isOTA() and not lp:isSynth() and lp:Team() ~= TEAM_MAYOR then return end
	local freq = lp:GetFreq()
	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW(), ScrH())
	frame:SetPos(0, ScrW() / 2)
	--frame:Center()
	frame:MakePopup()
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:SetTitle("")

	frame.Paint = function(_, w, h)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(radio_mat)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	frame.OnClose = function(_) radio_frame = nil end

	frame.OnKeyCodePressed = function(self, key) if key == bind_settings_convar:GetInt() then self:RemoveMePls() end end

	frame.RemoveMePls = function(self)
		self:MoveTo(0, ScrH(), 0.3, 0, -1)
		timer.Simple(0.3, function() self:Remove() end)
	end

	radio_frame = frame
	local fw, fh = frame:GetWide(), frame:GetTall()
	local col_bl = Color(20, 20, 20, 255)
	local lb = frame:Add("DLabel")
	lb:SetPos(fw * .384, fh * .43)
	lb:SetTextColor(col_bl)
	lb:SetFont("radio_5")
	lb:SetText("CHN " .. cur_freq)
	lb:SizeToContents()

	local st = lp:isRadioDisabled() and "Off" or "On"
	local lb1 = frame:Add("DLabel")
	lb1:SetPos(fw * .534, fh * .43)
	lb1:SetTextColor(col_bl)
	lb1:SetFont("radio_5")
	lb1:SetText("ST " .. st)
	lb1:SizeToContents()

	local dte = frame:Add("DTextEntry")
	dte:SetSize(S(380), S(50))
	dte:SetPos(fw * .382, fh * .27)
	dte:SetFont("radio_3")
	dte:SetText(freq)
	dte:SetDrawBackground(false)
	dte:SetNumeric(true)

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
		frame:RemoveMePls()
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
	db1:SetSize(S(128), S(45))
	db1:SetPos(fw * .559, fh * .571)
	db1:SetTextColor(color_black)
	db1:SetText("")
	db1:SetTooltip("Смена текущей частоты на групповую и обратно")
	db1.Paint = function() end

	db1.DoClick = function()
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
	db2:SetSize(S(128), S(45))
	db2:SetPos(fw * .559, fh * .097)
	db2:SetText("")
	db2:SetTooltip("Закрыть меню рации")
	db2.Paint = function() end

	db2.DoClick = function()
		surface.PlaySound("dradio/radio_soft.wav")
		frame:RemoveMePls()
	end

	--Частота влево
	local db3 = frame:Add("DButton")
	db3:SetSize(S(60), S(45))
	db3:SetPos(fw * .362, fh * .571)
	db3:SetText("")
	db3:SetTooltip("Быстрый доступ к предыдущей сохраненной частоту")
	db3.Paint = function() end

	db3.DoClick = function()
		surface.PlaySound("dradio/radio_switch.wav")
		cur_freq = cur_freq - 1
		if cur_freq < 1 then cur_freq = 3 end

		local ret = stored_freqs[cur_freq]
		dte:SetText(ret)
		lb:SetText("CHN " .. cur_freq)
		lb:SizeToContents()
		RunConsoleCommand("radio_set_channel", ret)
	end

	--Частота вправо
	local db4 = frame:Add("DButton")
	db4:SetSize(S(60), S(45))
	db4:SetPos(fw * .405, fh * .571)
	db4:SetText("")
	db4:SetTooltip("Быстрый доступ к следующей сохраненной частоту")
	db4.Paint = function() end

	db4.DoClick = function()
		surface.PlaySound("dradio/radio_switch.wav")

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
	db5:SetSize(S(128), S(45))
	db5:SetPos(fw * .46, fh * .571)
	db5:SetText("")
	db5:SetTooltip("Установить частоту")
	db5.Paint = function() end

	db5.DoClick = function()
		surface.PlaySound("dradio/radio_soft.wav")
		dte:OnEnter()
	end

	-- Выключить рацию
	local db6 = frame:Add("DButton")
	db6:SetSize(S(128), S(45))
	db6:SetPos(fw * .4585, fh * .097)
	db6:SetText("")
	db6:SetTooltip("Выключить/Включить рацию")
	db6.Paint = function() end

	db6.DoClick = function()
		surface.PlaySound("dradio/radio_soft.wav")
		RunConsoleCommand("radio_toggle")

		if lp:isRadioDisabled() then
			local freq = lp:GetFreq()
			dte:SetText(freq)
			dte:SetDisabled(false)
			lb1:SetText("ST On")
			lb1:SizeToContents()
		else
			dte:SetDisabled(true)
			lb1:SetText("ST Off")
			lb1:SizeToContents()
		end
	end

	frame:MoveTo(0, 0, 0.5, 0, 1)
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local radio_sounds = {
	on = {"npc/combine_soldier/vo/on1.wav", "npc/combine_soldier/vo/on2.wav"},
	off = {"npc/combine_soldier/vo/off1.wav", "npc/combine_soldier/vo/off2.wav"}
}

local on = radio_sounds.on
local off = radio_sounds.off
local use_radio = false
local time
hook.Add("PlayerButtonDown", "Radio_Bind", function(ply, key)
	if not IsFirstTimePredicted() then return end
	local bind = bind_key_convar:GetInt() or KEY_V
	local sets_bind = bind_settings_convar:GetInt() or KEY_B
	local mute_bind = bind_key_mute:GetInt() or KEY_L

	if key == bind then
		if ply:isRadioDisabled() or ply:isRadioRestricted() or ply:isRadioForceDisabled() or not ply:canRadioSpeak() then return end

		if not use_radio then
			surface.PlaySound(on[math.random(1, #on)])
			RunConsoleCommand("+radio")

			if permissions and permissions.EnableVoiceChat then
				permissions.EnableVoiceChat(true)
			else
				RunConsoleCommand("+voicerecord")
			end

			use_radio = true
		end
	elseif key == sets_bind then
		if ply:isCP() and ply:isEnabledMask() or ply:isOTA() or ply:isSynth() or ply:Team() == TEAM_MAYOR and not ply:isRadioRestricted() then
			time = CurTime() + 0.5

			timer.Create("open_radio_menu", 0.5, 1, function()
				local time_check = time and time - CurTime() or 1
				if time_check <= 0 then
					if not IsValid(radio_frame) then
						radio_menu()
					else
						radio_frame:Remove()
					end

					time = nil
				end
			end)
		end
	elseif key == mute_bind then
		surface.PlaySound("dradio/radio_soft.wav")
		RunConsoleCommand("radio_toggle")
	end
end)

hook.Add("PlayerButtonUp", "Radio_Bind", function(ply, key)
	if not IsFirstTimePredicted() then return end
	local bind = bind_key_convar:GetInt() or KEY_V
	local sets_bind = bind_settings_convar:GetInt() or KEY_B
	if key == bind then
		if use_radio then
			use_radio = false
			RunConsoleCommand("-radio")

			if permissions and permissions.EnableVoiceChat then
				permissions.EnableVoiceChat(false)
			else
				RunConsoleCommand("-voicerecord")
			end

			surface.PlaySound(off[math.random(1, #off)])
		end
	elseif key == sets_bind then
		if ply:isCP() and ply:isEnabledMask() or ply:isOTA() or ply:isSynth() or ply:Team() == TEAM_MAYOR and not ply:isRadioRestricted() then time = nil end
	end
end)

hook.Add("PlayerBindPress", "Radio_Bind_Override", function(_, bind) if bind:find("voicerecord", 1, true) and use_radio then return true end end)
local function restriction(ply)
	local lp = LocalPlayer()
	local listener_freq = lp:GetFreq()
	local speaker_freq = ply:GetFreq()
	if ply:canRadioSpeak(lp) and (speaker_freq == listener_freq or ply:isSpeakToAll()) then return true end
end

hook.Add("PlayerStartVoice", "StartVoiceRadio", function(ply)
	local lp = LocalPlayer()
	if not IsValid(ply) then return end
	local dist = lp:GetPos():DistToSqr(ply:GetPos()) > 313600 -- 560, but darkrp has 550 ( 302500 ).
	if dist and restriction(ply) then surface.PlaySound(on[math.random(1, #on)]) end
end)

hook.Add("PlayerEndVoice", "StopVoiceRadio", function(ply)
	local lp = LocalPlayer()
	if not IsValid(ply) then return end
	local dist = lp:GetPos():DistToSqr(ply:GetPos()) > 313600 -- 560, but darkrp has 550 ( 302500 ).
	if dist and restriction(ply) then surface.PlaySound(off[math.random(1, #off)]) end
end)

hook.Add("InitPostEntity", "RequestVoiceChat", function() timer.Simple(10, function() if (permissions and permissions.EnableVoiceChat) and not permissions.IsGranted("voicerecord") then permissions.EnableVoiceChat(true) end end) end)
