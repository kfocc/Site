include("shared.lua")
local include = include
local Color = Color
local Vector = Vector
local Angle = Angle
local ClientsideModel = ClientsideModel
local IsValid = IsValid
local CurTime = CurTime
local Material = Material
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local string_FormattedTime = string.FormattedTime
local math_max = math.max
local ipairs = ipairs
local arrestSystem = arrestSystem
local netstream = netstream
local surface_PlaySound = surface.PlaySound

local color_white = color_white
local color_semiblack = Color(0, 0, 0, 75)
local color_blue = Color(132, 192, 222)
local color_blue2 = color_blue:darken(150)
local color_blue3 = color_blue:darken(100)
local color_lightgreen = Color(85, 255, 85)
local color_green = Color(0, 134, 0)
local color_lightred = Color(180, 0, 0)
local color_gray = Color(120, 132, 138)
local color_gray3 = color_gray:darken(100)

local green_gradient = {color_lightgreen, color_green}
local blue_gradient = {color_blue3, color_blue}
local blue_gradient2 = {color_blue, color_blue3}
local blue_gradient3 = {color_blue, color_blue2}
local gray_gradient = {color_gray, color_gray3}

local imgui = include("lib/client/imgui.lua")
local imgui_Entity3D2D = imgui.Entity3D2D
local imgui_End3D2D = imgui.End3D2D
local imgui_drawBorderRect = imgui.drawBorderRect
local imgui_drawGradientBorderRect = imgui.drawGradientBorderRect
local imgui_xFont = imgui.xFont
local imgui_drawGradientBorderButtonText = imgui.drawGradientBorderButtonText
local imgui_xCursor = imgui.xCursor

ENT.RenderGroup = RENDERGROUP_BOTH

local boardLocalPos = Vector(0, -15, 55)
local boardLocalAng = Angle(90, 0, 90)
local color_transparent = Color(0, 0, 0, 0)
local function createBoard(self)
	local mainBoard = ClientsideModel("models/hunter/plates/plate1x2.mdl")
	mainBoard:SetMaterial("models/debug/debugwhite")
	mainBoard:SetColor(color_gray)
	mainBoard:SetParent(self)
	mainBoard:SetLocalAngles(boardLocalAng)
	mainBoard:SetLocalPos(boardLocalPos)
	mainBoard:Spawn()
	self.mainBoard = mainBoard
end

function ENT:Initialize()
	createBoard(self)
end

function ENT:Think()
	if not IsValid(self.mainBoard) then createBoard(self) end
	self:SetNextClientThink(CurTime() + 1)
	return true
end

function ENT:OnRemove()
	local mainBoard = self.mainBoard
	if IsValid(mainBoard) then mainBoard:Remove() end
end

local coolDown = 0
local interfaceMaterial = Material("unionrp/ui/arrest/interface.jpg", "noclamp smooth")

local recycleMaterial = Material("unionrp/ui/arrest/cycle.png", "noclamp smooth")
local vecOffset, angOffset = Vector(-23.73, 47.46, -1.6), Angle(180, 90, 0)
function ENT:DrawTranslucent()
	local mainBoard = self.mainBoard
	if not IsValid(mainBoard) then return end
	if imgui_Entity3D2D(mainBoard, vecOffset, angOffset, 0.05, 320, 256, true) then
		--[[
			MAIN FRAME
		--]]
		local maxX, maxY = 1897, 949
		local halfMaxX = maxX * 0.5
		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(interfaceMaterial)
		surface_DrawTexturedRect(0, 0, maxX, maxY)

		imgui_drawBorderRect(0, 0, maxX, maxY, color_semiblack, 2, col.o)

		local currentRecipe = self:GetCurrentRecipe()
		local isWorking = self:IsWorking()
		if currentRecipe then
			local bx, tx = halfMaxX - 650, halfMaxX + 125
			if isWorking then bx, tx = bx - 130, tx - 125 end
			imgui_drawGradientBorderRect(bx, 30, 1550, 150, blue_gradient, 3, col.ba)
			draw_SimpleText(currentRecipe.name, imgui_xFont("!Roboto@95"), tx, 55, color_white, TEXT_ALIGN_CENTER)
			if isWorking then
				local ang = CurTime() * 200 % 360
				surface_SetDrawColor(color_blue)
				surface_SetMaterial(recycleMaterial)
				surface_DrawTexturedRectRotated(halfMaxX, maxY * 0.56, 384, 384, ang)

				local workingTime = self:GetNetVar("timeToMake", 0) - CurTime()
				local timeToMake = currentRecipe.timeToMake or 10
				if workingTime > 0 then
					local percent = maxX * (1 - workingTime / timeToMake)
					imgui_drawGradientBorderRect(5, maxY - 22, percent, 20, green_gradient, 3, col.ba)
				end
			else

				imgui_drawGradientBorderRect(halfMaxX - 900, 30, 210, 150, blue_gradient, 3, col.ba)

				local nextQuestTime = self:GetNetVar("newQuestTime", 0) + 300
				nextQuestTime = string_FormattedTime(math_max(nextQuestTime - CurTime(), 0), "%02i:%02i")
				draw_SimpleText(nextQuestTime, imgui_xFont("!Roboto@65"), halfMaxX - 800, 75, color_white, TEXT_ALIGN_CENTER)

				imgui_drawGradientBorderRect(halfMaxX - 900, 215, 1800, 550, blue_gradient2, 3, col.ba)
				local currentNeeds = self:GetCurrentNeeds()
				local needs = currentRecipe.itemsRequired
				local y = 215
				for k, v in ipairs(needs) do
					imgui_drawBorderRect(halfMaxX - 900, y, 1800, 85, color_transparent, 1, color_black)

					local itemName = arrestSystem.GetItemByID(v[1]).name
					local hasNeed = currentNeeds[v[1]]
					local needSuccess = hasNeed and hasNeed >= v[2]
					local _x, _y = draw_SimpleText(k .. ". " .. itemName .. " - " .. v[2] .. " шт. / ", imgui_xFont("!Roboto@85"), halfMaxX - 850, y, color_white, TEXT_ALIGN_LEFT)
					local textColor = needSuccess and color_green or color_lightred
					local text = (hasNeed or 0) .. " шт."
					if needSuccess then text = text .. " - ✔" end

					draw_SimpleText(text, imgui_xFont("!Roboto@85"), halfMaxX - 850 + _x, y, textColor, TEXT_ALIGN_LEFT)
					y = y + _y
				end

				local readyToWorking = self:IsReadyToWorking()
				local butColor = readyToWorking and blue_gradient3 or gray_gradient
				local textColor = readyToWorking and color_white or color_gray
				local bPressed = imgui_drawGradientBorderButtonText("НАЧАТЬ СБОРКУ", "!Roboto@75", halfMaxX - 550, 790, 1100, 130, textColor, butColor, 3, col.ba)
				if readyToWorking and bPressed and coolDown < CurTime() then
					coolDown = CurTime() + 1
					netstream.Start("arrestSystem.Spawn.StartWorking", self)
					surface_PlaySound("UI/buttonclick.wav")
				end
			end
		end

		imgui_xCursor(0, 0, maxX, maxY)
		imgui_End3D2D()
	end
end
