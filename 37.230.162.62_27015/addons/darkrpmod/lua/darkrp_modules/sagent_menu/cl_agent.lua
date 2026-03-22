local hackMenu
netstream.Hook("sAgent.StartHacking", function(startTime, endTime)
	if IsValid(hackMenu) then
		local buttons = hackMenu.buttons
		for _, v in ipairs(buttons) do
			v.DoClick = function(_self)
				_self:SetDisabled(true)
				for _, v in ipairs(buttons) do
					v:SetDisabled(true)
				end

				local answer = _self.answer
				if answer then netstream.Start("sAgent.ManageAnswer", _self.answer) end
			end

			local dProgress = hackMenu.dProgress
			dProgress.startTime = startTime
			dProgress.endTime = endTime
			dProgress:SetVisible(true)
		end
	end
end)

netstream.Hook("sAgent.ManageAnswer", function(expression, answers)
	expression = "Ре�шите: " .. expression .. " = ?\n"
	if IsValid(hackMenu) then
		local buttons = hackMenu.buttons
		hackMenu:AppendText(expression)
		for k, v in ipairs(answers) do
			local answer = k .. "�) " .. v
			hackMenu:AppendText(answer)
			buttons[k].answer = v
		end

		hackMenu:AppendText("\n\n\n")
		for _, v in ipairs(buttons) do
			v:SetDisabled(false)
		end
	end
end)

netstream.Hook("sAgent.OpenHackMenu", function(ent)
	if IsValid(hackMenu) then hackMenu:Remove() end
	hackMenu = vgui.Create("UnSAgentMenu")
	hackMenu.ent = ent
end)

netstream.Hook("sAgent.menuNotify", function(text, color, newLine, sound)
	if not IsValid(hackMenu) then return end
	if istable(text) then
		for _, v in ipairs(text) do
			hackMenu:AppendText(v[1], v[2], v[3])
		end
		return
	end

	hackMenu:AppendText(text, color, newLine)
	if sound then surface.PlaySound(sound) end
end)

local lp
local glitchPeriod = 2
local glitchTime = 16
local glitchStart = 0
local glitchCountX, glitchCountY = 8, 4
local glitchCountMinX, glitchCountMinY = 2, 1
local glitchCountMin = math.min(glitchCountX, glitchCountY)
local function GlitchEffect()
	local time = SysTime() - glitchStart
	if time > glitchTime or not lp:isOTA() then hook.Remove("RenderScreenspaceEffects", "HackGlitches") end
	local frac = 0
	--if time < glitchTime then
	frac = math.min(1 - (time % (glitchPeriod * 2) - glitchPeriod) / glitchPeriod, (glitchCountMin - 1) / glitchCountMin)
	if frac < 0.5 then
		frac = math.ease.OutBounce(frac * 2)
	else
		frac = 1 - (frac - 0.5) * 2
	end

	--end
	renderGlith(0, 0, ScrW(), ScrH(), math.max(math.ceil(frac ^ 2 * glitchCountX), glitchCountMinX), math.max(math.ceil(frac ^ 2 * glitchCountY), glitchCountMinY), 4 * math.min((glitchTime - time) / glitchTime * 0.25 + 0.75, 1) ^ 2 * math.max(frac ^ 2, 0.5))
end

netstream.Hook("sAgent.EndHacking", function()
	surface.PlaySound("npc/overwatch/cityvoice/fprison_interfacebypass.wav")
	lp = LocalPlayer()
	glitchStart = SysTime()
	hook.Add("RenderScreenspaceEffects", "HackGlitches", GlitchEffect)
end)
--[[function testcode()
  lp = LocalPlayer()
  glitchStart = SysTime()
  hook.Add("RenderScreenspaceEffects", "HackGlitches", GlitchEffect)
end
testcode()]]
