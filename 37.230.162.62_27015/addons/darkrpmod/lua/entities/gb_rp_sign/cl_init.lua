include("shared.lua")
surface.CreateFont("InfoRUS2", {
	font = "Enhanced Dot Digital-7",
	extended = true,
	size = 90,
	weight = 800,
})

surface.CreateFont("InfoRUS3", {
	font = "Enhanced Dot Digital-7",
	extended = true,
	size = 50,
	weight = 800,
})

local font = "InfoRUS2"
local sizetable = {
	[3] = {350, 0.5},
	[4] = {470, -11.5},
	[5] = {590, -11.5},
	[6] = {710, 0.5},
	[7] = {830, 0.5},
	[8] = {950, 0.5},
}

local math_Approach = math.Approach
local Lerp = Lerp
local RealFrameTime = RealFrameTime
local math_random = math.random
local DisableClipping = DisableClipping
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local CurTime = CurTime
local SysTime = SysTime
local draw_SimpleText = draw.SimpleText
local textCol = Color()
function ENT:Initialize()
	self.OldWide = self:GetWide()
	local frame = vgui.Create("DPanel")
	self.frame = frame
	frame:SetSize(sizetable[self:GetWide()][1], 120)
	frame.Text = self:GetText()
	frame.Type = self:GetType()
	frame.col = self:GetTColor()
	frame.damage = 0
	frame.appr = nil
	frame.FX = self:GetFX()
	frame.On = self:GetOn()
	frame.alfa = 0
	frame.speed = self:GetSpeed()
	frame:SetPaintedManually(true)
	frame.LastThink = SysTime()
	frame.Paint = function(self, w, h)
		if self.On <= 0 then
			if self.alfa < 1 then return end
			self.alfa = Lerp(RealFrameTime() * 5, self.alfa, 0)
		else
			if self.FX > 0 then
				self.alfa = math_random(100, 220)
			else
				self.alfa = 255
			end
		end

		surface_SetFont(font)
		local old = DisableClipping(false)
		local text = self.Text
		local ww = surface_GetTextSize(text)
		-- local multiplier = self.speed * 100
		local multiplier = self.speed * 100
		local nType = self.Type
		local col = self.col
		local now = SysTime()
		local approachMult = multiplier * (now - self.LastThink)
		if self.damage < CurTime() and self.On then
			if nType == 1 then
				local xs = now * multiplier % (w + ww) - ww
				textCol:SetUnpacked(col.x * 100, col.y * 100, col.z * 100, self.alfa)
				draw_SimpleText(text, font, xs, 10, textCol, TEXT_ALIGN_LEFT)
			elseif nType == 2 then
				local appr = self.appr
				if not appr or appr > ww then
					appr = -w
				else
					appr = math_Approach(appr, ww + w, approachMult)
				end

				textCol:SetUnpacked(col.x * 100, col.y * 100, col.z * 100, self.alfa)
				draw_SimpleText(text, font, appr * -1, 10, textCol, TEXT_ALIGN_LEFT)
				self.appr = appr
			else
				local appr = self.appr
				if not appr then
					appr = 1
					self.refl = true
				end

				if w > ww then
					if nType == 3 then
						if appr < w - ww and not self.refl then
							appr = math_Approach(appr, ww + w, approachMult)
						else
							if appr <= 0 then
								self.refl = nil
							else
								self.refl = true
								appr = math_Approach(appr, 0, approachMult)
							end
						end
					else
						self.static = true
					end
				else
					if appr > w - ww - 50 and not self.refl then
						appr = math_Approach(appr, w - ww - 50, approachMult)
					else
						if appr >= 50 then
							self.refl = nil
						else
							self.refl = true
							appr = math_Approach(appr, 50, approachMult)
						end
					end
				end

				textCol:SetUnpacked(col.x * 100, col.y * 100, col.z * 100, self.alfa)
				if self.static then
					draw_SimpleText(text, font, w / 2, 10, textCol, TEXT_ALIGN_CENTER)
				else
					draw_SimpleText(text, font, appr, 10, textCol, TEXT_ALIGN_LEFT)
				end

				self.appr = appr
			end
		else
			textCol:SetUnpacked(col.x * 100, col.y * 100, col.z * 100, math_random(0, 255))
			draw_SimpleText(text, font, math_random(0, w - ww), 10, textCol, TEXT_ALIGN_LEFT)
		end

		self.LastThink = now
		DisableClipping(old)
	end
end

function ENT:Think()
	local frame = self.frame
	if frame then
		frame.Text = self:GetText()
		frame.Type = self:GetType()
		frame.col = self:GetTColor()
		frame.FX = self:GetFX()
		frame.On = self:GetOn()
		frame.damage = self:GetNWInt("LastDamaged")
		frame.speed = self:GetSpeed()
	end

	local curWide = self:GetWide()
	if self.OldWide ~= curWide then
		frame:SetSize(sizetable[curWide][1], 120)
		self.OldWide = curWide
	end

	self:SetNextClientThink(CurTime() + 1)
	return true
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	local curWide = self:GetWide()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local hight = 12
	if curWide == 3 then hight = 6 end
	cam.Start3D2D(Pos + Ang:Up() * 1.1 - Ang:Right() * hight + Ang:Forward() * sizetable[curWide][2], Ang, 0.1)
	self.frame:PaintManual()
	cam.End3D2D()
end
