local LocalPlayer = LocalPlayer
local pairs = pairs
local timer_Create = timer.Create
local timer_Exists = timer.Exists
local timer_Remove = timer.Remove
local ScrW = ScrW
local ScrH = ScrH
local Material = Material
local math_atan2 = math.atan2
local hook_Add = hook.Add
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated

local gps = gps or {}
_G.gps = gps

gps.config = gps.config or {}
local cfg = gps.config

function gps:IsActive()
	return self.activePoint
end

function gps:GetCategories()
	return cfg.points
end

function gps:GetPoints()
	return cfg.pointsList
end

function gps:GetCategory(category)
	return self:GetCategories()[category]
end

function gps:GetAccessedCategories()
	local categories = self:GetCategories()
	local res = {}
	local ply = LocalPlayer()
	for categoryName, categoryData in pairs(categories) do
		local check = categoryData.check
		if check then
			if check(ply) then res[categoryName] = categoryData end
		else
			res[categoryName] = categoryData
		end
	end
	return res
end

function gps:GetPoint(id)
	local point = self:GetPoints()[id]
	return point and point.pointData
end

function gps:GetPointCategory(id)
	local point = self:GetPoints()[id]
	return point and point.category
end

function gps:Activate(id)
	local point = self:GetPoint(id)
	if not point then return end
	if self.activePoint then self:Deactivate() end

	if self.activePoint == id then return end
	self.activePoint = id

	local icon = point.icon or cfg.defaultIcon
	local pos = point.pos
	Marks:AddPoint(id, "gps_point", pos, 0, icon, cfg.pointSound)

	timer_Create("gps_think", 1, 0, function()
		local ply = LocalPlayer()
		local plyPos = ply:GetPos()
		if not ply:Alive() or not self.activePoint or plyPos:DistToSqr(pos) <= cfg.distanceToRemove then self:Deactivate() end
	end)
end

function gps:Deactivate()
	local activePoint = self.activePoint
	if not activePoint then return end
	Marks:RemovePoint("gps_point")

	if timer_Exists("gps_think") then timer_Remove("gps_think") end
	self.activePoint = nil
end

local scrW, scrH = ScrW(), ScrH()
local w, h = scrW * 0.5, scrH * 0.1
local material = Material("unionrp/ui/gps_cursor.png", "smooth")
local radtodeg = 180 / math.pi
local function calculateDeegres(x1, y1, x2, y2)
	local slope = math_atan2(y2 - y1, x2 - x1)
	local res = slope * radtodeg
	return res
end

hook_Add("HUDPaint", "TestGPS", function()
	local isActive = gps:IsActive()
	if not isActive then return end
	local point = gps:GetPoint(isActive)
	if not point then return end

	surface_SetDrawColor(color_white:Unpack())
	surface_SetMaterial(material)

	local toScr = point.pos:ToScreen()
	local x, y = toScr.x, toScr.y
	local deegres = -calculateDeegres(x, y, w, h) + 90
	surface_DrawTexturedRectRotated(w, h, 64, 64, deegres)
end)
-- local triangle = {
--     {
--         x = w - 25,
--         y = h + 35
--     },
--     {
--         x = w,
--         y = h - 35
--     },
--     {
--         x = w + 25,
--         y = h + 35
--     }
-- }
-- local resultTable = table.Copy(triangle)
-- local radtodeg = 180 / math.pi
-- local function calculateDeegres(x1, y1, x2, y2)
--     local slope = math.atan2(y2 - y1, x2 - x1)
--     local res = slope * radtodeg
--     return res
-- end
-- timer.Create("calculateRotation", 0.05, 0, function()
--     local isActive = gps:IsActive()
--     if not isActive then return end
--     local cfg = gps.config.points[isActive]
--     if not cfg then return end
--     local scrVec = cfg.pos:ToScreen()
--     local pPosX, pPosY = scrVec.x, scrVec.y
--     for k, v in ipairs(triangle) do
--         local x, y = v.x, v.y
--         local deegres = math.rad(calculateDeegres(pPosX, pPosY, x, y) - 90)
--         local cosA, sinA = math.cos(deegres), math.sin(deegres)
--         local row = resultTable[k]
--         row.x = w + (x - w) * cosA - (y - h) * sinA
--         row.y = h + (y - h) * cosA + (x - w) * sinA
--     end
-- end)
-- hook.Add("HUDPaint", "TestGPS", function()
--     local isActive = gps:IsActive()
--     if not isActive then return end
--     local cfg = gps.config.points[isActive]
--     if not cfg then return end
--     surface.SetDrawColor(col.o:Unpack())
--     draw.NoTexture()
--     surface.DrawPoly(resultTable)
--     for k, v in ipairs(resultTable) do
--         surface.DrawCircle(v.x, v.y, 2, 255, 255, 255)
--         surface.SetFont("Default")
--         surface.SetTextColor(255, 255, 255)
--         surface.SetTextPos(v.x, v.y + 3)
--         surface.DrawText(k)
--     end
--     surface.DrawCircle(w, h, 2, color_red)
--     surface.SetFont("Default")
--     surface.SetTextColor(255, 255, 255)
--     surface.SetTextPos(w, h)
--     surface.DrawText("center")
-- end)
