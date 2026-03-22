hook.Add("PlayerBindPress", "Keypad", function(ply, bind, pressed)
	if not pressed then return end
	if hook.Run("CanUseKeypad", ply) == false then return end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	local ent = tr.Entity
	if not IsValid(ent) or not ent.IsKeypad then return end
	if string.find(bind, "+use", nil, true) then
		local element = ent:GetHoveredElement()
		if not element or not element.click then return end
		element.click(ent)
	end
end)

local physical_keypad_commands = {
	[KEY_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,
	[KEY_PAD_ENTER] = function(self)
		self:SendCommand(self.Command_Accept)
	end,
	[KEY_PAD_MINUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end,
	[KEY_PAD_PLUS] = function(self)
		self:SendCommand(self.Command_Abort)
	end
}

for i = KEY_PAD_1, KEY_PAD_9 do
	physical_keypad_commands[i] = function(self)
		self:SendCommand(self.Command_Enter, i - KEY_PAD_1 + 1)
	end
end

local last_press = 0
local enter_strict = CreateConVar("keypad_willox_enter_strict", "0", FCVAR_ARCHIVE, "Only allow the numpad's enter key to be used to accept keypads' input")
hook.Add("CreateMove", "Keypad", function(cmd)
	if RealTime() - 0.1 < last_press then return end

	for key, handler in pairs(physical_keypad_commands) do
		if input.WasKeyPressed(key) then
			if enter_strict:GetBool() and key == KEY_ENTER then continue end
			local ply = LocalPlayer()
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:GetAimVector() * 65,
				filter = ply
			})

			local ent = tr.Entity
			if not IsValid(ent) or not ent.IsKeypad then return end
			last_press = RealTime()
			handler(ent)
			return
		end
	end
end)

local hideHUD = {
	["DarkRP_HUD"] = true,
	["DarkRP_EntityDisplay"] = true,
	["DarkRP_ZombieInfo"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Hungermod"] = true,
	["DarkRP_Agenda"] = true,
	["CMapOverview"] = true,
	["DarkRP_LockdownHUD"] = true,
	["DarkRP_ArrestedHUD"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudBattery"] = true,
	["CHudDamageIndicator"] = true
}

hook.Add("HUDShouldDraw", "HideHUDEnc", function(name)
	if hideHUD[name] then
		return false
	end
end)

cvars.AddChangeCallback("mat_texture_list", function(_, _, new)
	if new == "1" then
		RunConsoleCommand("-mat_texture_list")
	end
end)

cvars.AddChangeCallback("lookstrafe", function(_, _, new)
	if new == "1" then
		net.Start("CvarInfo")
		net.WriteString("lookstrafe")
	end
end)

hook.Add("PlayerBindPress", "disableStrafe", function(ply, bind, pressed)
	local alias = input.TranslateAlias("+strafe")
	if string.find(bind, "+strafe", nil, true) or alias and string.find(alias, "+strafe", nil, true) then return true end
end)

hook.Add("InitPostEntity", "DEBUG_SEND_BRANCH", function()
	net.Start("debug_send_branch")
	net.WriteString(BRANCH)
	net.SendToServer()
end)
