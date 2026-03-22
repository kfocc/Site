include("shared.lua")
local h = 70
function ENT:Draw(flags)
	self:DrawModel(flags)

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	local end_time = self:GetEndTime()
	local status_text = self:GetAmount() > 0 and "В наличии: " .. self:GetAmount() or end_time > 1 and "Обработка" or "Без дела"
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos + Ang:Up() * 12.98 - Ang:Right() * 12, Ang, 0.11)
		draw.RoundedBox(6, -69, -145, 215, h, col.ba)
		draw.DrawText("Статус", "BoxText", 38.5, -140, col.w, TEXT_ALIGN_CENTER)
		draw.DrawText(status_text, "BoxText", 38.5, -110, col.o, TEXT_ALIGN_CENTER)

		if end_time > 1 then
			local time = self:GetWorkTime()
			local left = end_time - CurTime()
			local status = left / time
			status = status > .075 and status or .075
			local status_h = status * (h - 2)
			surface.SetAlphaMultiplier(0.275)
			draw.RoundedBox(4, -66, -145 + h - status_h - 1, 15, status_h, col.o)
			draw.RoundedBox(4, -72 + 215 - 15, -145 + h - status_h - 1, 15, status_h, col.o)

			surface.SetAlphaMultiplier(1)
		end

		cam.End3D2D()
	end
end
