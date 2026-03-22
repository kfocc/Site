include("shared.lua")
local ss = util.ScreenScale
surface.CreateFont("gmanCaseFont", {
	font = "Inter",
	extended = true,
	size = ss(20),
})

local color_black = Color(15, 15, 15)
local function drawShadowText(text, font, x, y, color, align1, align2)
	local w, h = draw.SimpleText(text, font, x, y, color_black, align1, align2)
	draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
	return w, h
end

local stencil = "[ %s ] - %s"
local stepW, stepH = ss(15), ss(30)
function SWEP:DrawHUD()
	local w = ScrW() - stepW
	local h = ScrH() - stepH
	local text = stencil:format(input.LookupBinding("reload"):upper(), "открыть меню")
	drawShadowText(text, "Trebuchet24", w, h, color_white, TEXT_ALIGN_RIGHT)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

local moneyCheckScroll
function SWEP:Reload()
	if not IsFirstTimePredicted() then return true end
	if (self.ReloadDelay or 0) > CurTime() then return true end
	self.ReloadDelay = CurTime() + 0.3
	if moneyCheckScroll then
		moneyCheckScroll:Remove()
		moneyCheckScroll = nil
		gui.EnableScreenClicker(false)
		return true
	end

	local scrollW, scrollH = ss(400), ss(250)
	local w, h = ScrW() * 0.1, ScrH()
	moneyCheckScroll = vgui.Create("DScrollPanel")
	moneyCheckScroll:SetSize(scrollW, scrollH)
	moneyCheckScroll:SetPos(w, h / 1.5 - scrollH * 0.5)
	gui.EnableScreenClicker(true)
	input.SetCursorPos(w, h / 1.5)
	local butSize = ss(35)
	for k, v in ipairs(self.Modes) do
		local button = moneyCheckScroll:Add("DButton")
		-- button:SetText(v[2])
		button:SetText("")
		button:SetTall(butSize)
		-- button:SetFont("moneyCheckerFont")
		-- button:SetTextColor(color_white)
		button:DockMargin(0, 0, 5, 5)
		button:Dock(TOP)
		if k == 2 then
			button.DoClick = function()
				local Menu = DermaMenu()
				Menu.Paint = function(_self, _w, _h) draw.RoundedBox(0, 0, 0, _w, _h, Color(25, 25, 25)) end
				local plysList = player.GetAll()
				table.sort(plysList, function(a, b) return a:Name() < b:Name() end)
				for _, ply in ipairs(plysList) do
					if LocalPlayer() == ply then continue end
					if not ply:Alive() then continue end
					if ply:GetMoveType() == MOVETYPE_NOCLIP or self.notAllowedTeam[ply:Team()] then continue end
					local ident = ply:Name() .. " ( " .. ply:getDarkRPVar("job", "UNKNOWN") .. " )"
					local opt = Menu:AddOption(ident, function()
						if IsValid(moneyCheckScroll) then
							moneyCheckScroll:Remove()
							moneyCheckScroll = nil
						end

						gui.EnableScreenClicker(false)
						netstream.Start("gman.action", k, ply)
					end)

					opt:SetFont("moneyCheckerFont")
					opt:SetTextColor(team.GetColor(ply:Team()))
					Menu:AddSpacer()
				end

				Menu:Open()
			end
		else
			button.DoClick = function()
				surface.PlaySound("UI/buttonclick.wav")
				if IsValid(moneyCheckScroll) then
					moneyCheckScroll:Remove()
					moneyCheckScroll = nil
				end

				gui.EnableScreenClicker(false)
				netstream.Start("gman.action", k)
			end
		end

		button.Paint = function(_self, _w, _h)
			local col = col.o
			if _self:IsDown() then col = col:darken(30) end
			if _self.entered and not _self:IsDown() then col = col:lighten(30) end
			draw.RoundedBox(0, 0, 0, _w, _h, col)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawOutlinedRect(0, 0, _w, _h, 1)
			draw.SimpleTextOutlined(v[2], "gmanCaseFont", scrollW * 0.5, butSize * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end

		button.OnCursorEntered = function(_self) if not _self.entered then _self.entered = true end end
		button.OnCursorExited = function(_self) if _self.entered then _self.entered = nil end end
	end
	return true
end
