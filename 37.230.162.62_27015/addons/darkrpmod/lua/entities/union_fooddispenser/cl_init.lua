include("shared.lua")
local colDark = Color(15, 15, 15)
local function shadowText(text, font, x, y, col)
	draw.SimpleText(text, font, x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(text, font, x, y - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local camStart, camEnd = cam.Start3D2D, cam.End3D2D
local dist = 200 * 200
function ENT:Draw(flags)
	self:DrawModel(flags)
	if not IsValid(self) then return end

	local distance, lim = self:GetPos():DistToSqr(EyePos()), dist
	if distance > lim then return end

	local pos = LocalToWorld(Vector(5, 0, 70), Angle(0, 90, 90), self:GetPos(), self:GetAngles())

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local count, max = self:GetFoodCount(), self._maxCount
	local text = "(" .. count .. "/" .. max .. ")"

	camStart(pos, ang, 0.25)
	shadowText("Склад еды", "food_box_rebel", 0, -20, colDark)
	shadowText(text, "food_box_rebel", 0, 0, colDark)
	camEnd()
end
