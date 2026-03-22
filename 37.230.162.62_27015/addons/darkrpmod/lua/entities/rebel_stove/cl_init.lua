include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH
local draw, surface = draw, surface
local entIcon = Material("icon16/cup_add.png", "noclamp smooth")
ENT.Icon = entIcon
local vecOffset = Vector(0, 0, 60)
local font = "nameplates"
local cBackground1 = Color(32, 30, 32, 255)
local cBackground2 = Color(40, 38, 40, 255)
local cTextPrimary = Color(168, 167, 168, 255)
local cTextSecondary = Color(113, 111, 113, 255)
local options
options = {
	ent = nil,
	position = nil,
	angle = nil,
	maxDistance = 256,
	lookCenter = nil,
	aimThreshold = math.pi / 6,
	func = function(uiSize)
		draw.RoundedBox(0, -130, 10, 300, 80, cBackground1)
		draw.RoundedBox(0, -130, 10, 300, 28, cBackground2)
		surface.SetDrawColor(150, 150, 150, 255)
		surface.SetMaterial(entIcon)
		surface.DrawTexturedRect(-20, 16, 16, 16)
		draw.SimpleText("Плита", font, 0, 25, cTextPrimary, 0, 1)
		draw.SimpleText("Пищевой снабдитель тут готовит еду", font, 20, 51, cTextSecondary, 1, 1)
		local ent = options.ent
		if ent then
			local readyFood, stolenFood = ent:GetReadyFood(), ent:GetStolenFood()
			draw.SimpleText("Заполненность: " .. readyFood .. "/" .. stolenFood .. ".", font, 20, 74, cTextSecondary, 1, 1)
		end

		surface.SetDrawColor(77, 75, 77, 255)
		surface.DrawOutlinedRect(-130, 10, 300, 80)
	end
}

function ENT:Draw()
	self:DrawModel()
	local origin = self:GetPos()
	local lp = LocalPlayer()
	if lp:GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	options.ent = self
	options.position = origin + vecOffset
	options.angle = lp:GetAngles()
	options.lookCenter = self:LocalToWorld(self:OBBCenter())
	nameplates.DrawNameplate(options)
end
