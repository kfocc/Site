include("shared.lua")

local Color = Color
local include = include
local surface_CreateFont = surface.CreateFont
local Material = Material
local Vector = Vector
local Angle = Angle
local surface_PlaySound = surface.PlaySound
local draw_SimpleText = draw.SimpleText
local CurTime = CurTime
local netstream = netstream
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawTexturedRect = surface.DrawTexturedRect

local color_white = color_white
local color_semiblack = Color(0, 0, 0, 75)
local color_blue = Color(132, 192, 222)
local color_blue2 = color_blue:darken(150)
local color_blue3 = color_blue:darken(100)
local color_lightgreen = Color(85, 255, 85)
local color_green = Color(0, 100, 0)

local green_gradient = {color_lightgreen, color_green}
local blue_gradient = {color_blue3, color_blue}
local blue_gradient2 = {color_blue, color_blue3}
local blue_gradient3 = {color_blue, color_blue2}

local imgui = include("lib/client/imgui.lua")
local imgui_Entity3D2D = imgui.Entity3D2D
local imgui_End3D2D = imgui.End3D2D
local imgui_drawBorderRect = imgui.drawBorderRect
local imgui_drawGradientBorderRect = imgui.drawGradientBorderRect
local imgui_xFont = imgui.xFont
local imgui_drawBorderButtonIcon = imgui.drawBorderButtonIcon
local imgui_drawGradientBorderButtonText = imgui.drawGradientBorderButtonText
local imgui_xCursor = imgui.xCursor

ENT.RenderGroup = RENDERGROUP_BOTH

surface_CreateFont("arrestsystem.Main", {
	font = "Roboto",
	size = 35,
	weight = 500,
	extended = true,
})

function ENT:Initialize()
	self.index = 1
end

local arrowLeft = Material("icon16/arrow_left.png")
local arrowRight = Material("icon16/arrow_right.png")
local interfaceMaterial = Material("unionrp/ui/arrest/interface.jpg", "noclamp smooth")
local loadingMaterial = Material("unionrp/ui/arrest/loading.png", "noclamp smooth")
local selfCoolDown = 0
local vecOffset, angOffset = Vector(-19, -24, 43), Angle(0, 0, 90)
function ENT:DrawTranslucent()
	if imgui_Entity3D2D(self, vecOffset, angOffset, 0.05, 320, 256, true) then
		--[[
			MAIN FRAME
		--]]
		local maxX, maxY = 768, 768
		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(interfaceMaterial)
		surface_DrawTexturedRect(0, 0, maxX, maxY)

		imgui_drawBorderRect(0, 0, maxX, maxY, color_semiblack, 2, col.o)
		if imgui_drawBorderButtonIcon(10, 25, 192, 192, arrowLeft) then
			self.index = self.index - 1
			if self.index < 1 then self.index = arrestSystem.items:Size() end

			surface_PlaySound("UI/buttonclick.wav")
		end

		if imgui_drawBorderButtonIcon(maxX - 10 - 192, 25, 192, 192, arrowRight) then
			self.index = self.index + 1
			if self.index > arrestSystem.items:Size() then self.index = 1 end

			surface_PlaySound("UI/buttonclick.wav")
		end

		imgui_drawGradientBorderRect(252, 20, 256, 192, blue_gradient, 3, col.ba)

		local index = self.index
		local item = arrestSystem.items[index]
		local icon = item.icon
		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(icon)
		surface_DrawTexturedRect(252 + 64, 54, 128, 128)

		local name = item.name
		imgui_drawGradientBorderRect(10, 240, 745, 156, blue_gradient2, 3, col.ba)
		draw_SimpleText(name, imgui_xFont("!Roboto@75"), 380, 280, color_white, TEXT_ALIGN_CENTER)

		local coolDownTime = self:GetNetVar("spawnCooldown", 0) - CurTime()
		local coolDown = coolDownTime >= 0
		local bPressed = imgui_drawGradientBorderButtonText("СОЗДАТЬ", "!Roboto@75", 53, 580, 660, 156, color_white, blue_gradient3, 3, col.ba)
		if bPressed and not coolDown and selfCoolDown <= CurTime() then
			netstream.Start("arrestSystem.Ent.Action", self, index)
			selfCoolDown = CurTime() + 1
		end

		if coolDown then
			local percent = 758 * (coolDownTime / 1)
			imgui_drawGradientBorderRect(5, 745, percent, 20, green_gradient, 3, col.ba)
		end

		local ang = -(CurTime() * 200) % 360
		surface_SetDrawColor(color_blue)
		surface_SetMaterial(loadingMaterial)
		surface_DrawTexturedRectRotated(maxX * 0.5, maxY * 0.64, 128, 128, ang)

		imgui_xCursor(0, 0, maxX, maxY)
		imgui_End3D2D()
	end
end

function ENT:Think()
end
