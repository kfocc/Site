local table_insert = table.insert
local table_remove = table.remove
local tostring = tostring
local ScrW = ScrW
local ScrH = ScrH
local Material = Material
local CurTime = CurTime
local isstring = isstring
local isnumber = isnumber
local isentity = isentity
local istable = istable
local ipairs = ipairs
local SoundDuration = SoundDuration
local timer_Simple = timer.Simple
local surface_PlaySound = surface.PlaySound
local math_ceil = math.ceil
local math_sqrt = math.sqrt
local math_random = math.random
local LocalPlayer = LocalPlayer
local NULL = NULL
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local FrameTime = FrameTime
surface.CreateFont("Marks_Font", {
	font = "Inter",
	extended = true,
	size = 15,
	weight = 500,
})

local unit = 26
local function ConvertDist(num)
	return math_ceil(math_sqrt(num) / unit)
end

local function NiceDist(distToSqr)
	local nice_pos = ConvertDist(distToSqr)
	return "Расстояние: " .. nice_pos .. " м."
end
_G.ConvertDist = ConvertDist
_G.NiceDist = NiceDist

local Marks = Marks or {}
_G.Marks = Marks

Marks.List = Marks.List or {}

function Marks:AddPoint(text, id, pos, time, icon, dist, sounds, removeOnDist)
	if not icon then icon = "add" end
	icon = Material("icon16/" .. icon .. ".png")
	if time ~= 0 then time = CurTime() + time end
	if not id then
		local rand1, rand2 = math_random(11111, 99999), math_random(11111, 99999)
		id = tostring(rand1 + rand2)
	end

	if isnumber(sounds) then
		removeOnDist = sounds * sounds
		sounds = nil
	elseif isnumber(removeOnDist) then
		removeOnDist = removeOnDist * removeOnDist
	end

	if isstring(dist) or istable(dist) then
		sounds = dist
		dist = nil
	elseif isnumber(dist) then
		dist = dist * dist
	end

	local posIsEnt = isentity(pos)
	if posIsEnt and pos == NULL then return end
	local temp_pos = posIsEnt and pos:GetPos() or pos
	local temp_dist = EyePos():DistToSqr(temp_pos)
	table_insert(self.List, {
		id = id,
		text = text,
		pos = pos,
		time = time,
		icon = icon,
		dist = dist,
		posIsEnt = posIsEnt,
		removeOnDist = removeOnDist,
		temp_pos = temp_pos,
		temp_dist = temp_dist,
		temp_text = NiceDist(temp_dist)
	})

	if sounds then
		if istable(sounds) then
			local i = 0
			for _, v in ipairs(sounds) do
				local duration = SoundDuration(v)
				timer_Simple(i, function() surface_PlaySound(v) end)
				i = i + 1 + duration
			end
		else
			surface_PlaySound(sounds)
		end
	end
end

function Marks:RemovePoint(id)
	if id == false then
		table.Empty(Marks.List)
		return
	end

	if not id then return end
	local List = Marks.List
	for k, v in ipairs(List) do
		if v.id == id then table_remove(List, k) end
	end
end

netstream.Hook("union.SendMark", function(text, id, pos, time, icon, dist, sounds, removeOnDist) Marks:AddPoint(text, id, pos, time, icon, dist, sounds, removeOnDist) end)
netstream.Hook("union.RemoveMark", function(id) Marks:RemovePoint(id) end)
hook.Add("HUDPaint", "Un.Marks", function()
	local List = Marks.List
	if #List == 0 then return end
	local ply = LocalPlayer()
	if not ply:Alive() then return end
	local plyPos = ply:EyePos()
	local plyVec = ply:GetAimVector()
	local scrW, scrH = ScrW(), ScrH()
	surface_SetDrawColor(255, 255, 255, 255)
	for k, v in ipairs(List) do
		local dist = v.dist
		local distToSqr = v.temp_dist
		if dist and distToSqr >= dist then continue end
		local vPos = v.temp_pos
		local position = vPos:ToScreen()
		local posX, posY = position.x, position.y
		if (posX <= 0 or posX >= scrW) or (posY <= 0 or posY >= scrH) then continue end
		-- surface_SetFont("Marks_Font")
		-- local textW, textH = surface_GetTextSize(text)
		-- posX = math_max(math_min(posX, scrW - textW - 50), textW + 50)
		-- posY = math_max(math_min(posY, scrH - textH - 50), te xtH + 50)
		surface_SetMaterial(v.icon)
		surface_DrawTexturedRect(posX, posY, 16, 16)
		local diff = vPos - plyPos
		if plyVec:Dot(diff) / diff:Length() < 0.75 then continue end
		draw_SimpleTextOutlined(v.text, "Marks_Font", posX + 5, posY - 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw_SimpleTextOutlined(v.temp_text, "Marks_Font", posX + 5, posY - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end
end)

local currect_mark = 1
hook.Add("Think", "Un.Marks", function()
	local List = Marks.List
	if #List == 0 then return end
	local plyPos = LocalPlayer():EyePos()
	local v
	local i = 0
	while i < math_ceil(#List * FrameTime()) do
		i = i + 1
		v = List[currect_mark]
		if not v then
			currect_mark = 1
			break
		end

		if v.posIsEnt and v.pos == NULL then
			table_remove(List, currect_mark)
			continue
		end

		local pos = v.pos
		if v.posIsEnt then pos = pos:GetPos() end
		v.temp_pos = pos
		v.temp_dist = plyPos:DistToSqr(pos)
		v.temp_text = NiceDist(v.temp_dist)
		local time = v.time
		local removeOnDist = v.removeOnDist
		if removeOnDist and v.temp_dist < removeOnDist or time ~= 0 and time < CurTime() then
			table_remove(List, currect_mark)
			continue
		end

		currect_mark = currect_mark % #List + 1
	end
end)
