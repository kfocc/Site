include("shared.lua")
surface.CreateFont("UtilText", {
	font = "Inter",
	extended = true,
	size = 28,
	weight = 800,
})

local h = 170
local s_w = 185
function ENT:Draw(flags)
	self:DrawModel(flags)

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 135 + 5)
	Ang:RotateAroundAxis(Ang:Right(), 180)

	local end_time = self:GetEndTime()
	local status_text = self:GetAmount() > 0 and "Утилизировано: " .. self:GetAmount() or end_time > 1 and "Утилизация" or "Простой"

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos + Ang:Up() * 20 + Ang:Right() * 10 + Ang:Forward() * 9, Ang, 0.15)
		draw.RoundedBox(6, -60, -170, 215, h, col.ba)
		draw.DrawText("Статус", "BoxText", 47.5, -140, col.w, TEXT_ALIGN_CENTER)
		draw.DrawText(status_text, "UtilText", 47.5, -110, col.o, TEXT_ALIGN_CENTER)

		if end_time > 1 then
			local time = self:GetWorkTime()
			local left = end_time - CurTime()
			local status = left / time
			status = status > 0 and status or 0
			surface.SetAlphaMultiplier(0.275)
			draw.RoundedBox(4, -45, -70, s_w * status, 15, col.o)
			surface.SetAlphaMultiplier(1)
		end

		cam.End3D2D()
	end
end
