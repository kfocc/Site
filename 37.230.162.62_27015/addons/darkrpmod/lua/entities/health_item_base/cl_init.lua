include("shared.lua")
surface.CreateFont("Items_Font", {
	font = "Robot Regular",
	size = 20,
	weight = 500,
	extended = true,
})

local colB, colW = Color(15, 15, 15), Color(255, 255, 255)
local defIcon = Material("icon16/add.png")
local vecOffset, angOffset = Vector(5, 0, 6), Angle(0, 90, 90)
function ENT:Draw(flags)
	self:DrawModel(flags)

	if not IsValid(self) then return end

	local distance, lim = self:GetPos():DistToSqr(EyePos()), 500 * 500
	if distance > lim then return end

	local pos, ang = LocalToWorld(vecOffset, angOffset, self:GetPos(), self:GetAngles())
	ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)

	cam.Start3D2D(pos, ang, 0.25)
	local text = self.ItemName or "UKNOWN"
	-- local int = self.ItemInt or "1"
	local icon = self.ItemIcon or defIcon
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(-5, -30, 16, 16)

	draw.SimpleText(text, "Items_Font", 0, -4, colB, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText(int, "Items_Font", 0, -4, colB, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText(text, "Items_Font", 0, -5, colW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- draw.SimpleText(int, "Items_Font", 0, -5, colW, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
