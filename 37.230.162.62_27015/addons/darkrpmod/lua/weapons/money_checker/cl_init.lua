include("shared.lua")

local ss = util.ScreenScale
surface.CreateFont("moneyCheckerFont", {
	font = "Inter",
	extended = true,
	size = ss(15),
})

local color_black = Color(15, 15, 15)
local function drawShadowText(text, font, x, y, color, align1, align2)
	local w, h = draw.SimpleText(text, font, x, y, color_black, align1, align2)
	draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
	return w, h
end

local stencil = "[ %s ] - %s"
local stepW, stepH, stepY = ss(15), ss(25), ss(10)
function SWEP:DrawHUD()
	local mode = self.Modes[self:GetMode()]
	if not mode then return end

	local w = ScrW() - stepW
	local h = ScrH() - stepH
	local _, y = drawShadowText(stencil:format(mode[2], mode[3]), "moneyCheckerFont", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	h = h - y - stepY

	local use1 = self:GetLastUseL() or 0
	if use1 > CurTime() then
		local time = stencil:format("ЛКМ", "перезарядится через " .. math.Round(use1 - CurTime()) .. " c")
		_, y = drawShadowText(time, "moneyCheckerFont", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		h = h - y - stepY * 2
	end

	h = h - stepY * 2
	local text = stencil:format(input.LookupBinding("reload"):upper(), "сменить мод")
	drawShadowText(text, "Trebuchet24", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
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

	local w, h = ScrW() * 0.1, ScrH()
	moneyCheckScroll = vgui.Create("DScrollPanel")
	moneyCheckScroll:SetSize(350, 500)
	moneyCheckScroll:SetPos(w, h / 1.5)

	gui.EnableScreenClicker(true)
	input.SetCursorPos(w, h / 1.5)

	for k, v in ipairs(self.Modes) do
		local button = moneyCheckScroll:Add("DButton")
		button:SetText(v[4])
		button:DockMargin(0, 0, 5, 5)
		button:Dock(TOP)

		button.DoClick = function()
			surface.PlaySound("UI/buttonclick.wav")

			if IsValid(moneyCheckScroll) then
				moneyCheckScroll:Remove()
				moneyCheckScroll = nil
			end

			gui.EnableScreenClicker(false)
			netstream.Start("moneyCheck_setmode", k)
		end
	end
	return true
end
