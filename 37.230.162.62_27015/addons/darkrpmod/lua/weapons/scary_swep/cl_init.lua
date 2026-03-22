include("shared.lua")

function SWEP:DrawHUD()
	local w, h = ScrW(), ScrH()
	local y = h / 2
	local w, h = draw.SimpleText("ЛКМ, чтобы проиграть страшный звук у игрока на прицеле.", "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	y = y + h + 5
	local w, h = draw.SimpleText("ПКМ, чтобы проиграть страшный звук себе.", "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	local use1, use2 = self:GetLastUseL() or 0, self:GetLastUseR() or 0
	if use1 > CurTime() then
		y = y + h + 5
		local time = "ЛКМ перезарядится через " .. math.Round(use1 - CurTime()) .. "c"
		draw.SimpleText(time, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	if use2 > CurTime() then
		y = y + h + 5
		local time = "ПКМ перезарядится через " .. math.Round(use2 - CurTime()) .. "c"
		draw.SimpleText(time, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end
