surface.CreateFont("NLR_Font1", {
	font = "Inter",
	size = 35,
	weight = 500,
	extended = true
})

surface.CreateFont("NLR_Font", {
	font = "Inter",
	size = 28,
	weight = 500,
	extended = true
})

--debug box
--[[
local vec = Vector(500, 500, 500)
local vec1 = -Vector(500, 500, 10)
local color_red = Color(255, 0, 0)
local mat = Material("cable/cable2")
hook.Add("PostDrawTranslucentRenderables", "nlr.DrawNLRBox", function()
    render.SetMaterial(mat)
    local ply = LocalPlayer()
    local row = ply:GetNetVar("nlr.info", {})
    if table.IsEmpty(row) then return end
    local ply_pos = ply:GetPos()
    for _, v in ipairs(row) do
        local pos = v.pos or Vector()
        -- if pos:DistToSqr(ply_pos) >= 1500 * 1500 then continue end
        render.DrawWireframeBox(pos, Angle(), vec, vec1, color_red)
    end
end)]]

local color_red = Color(255, 0, 0)
local max_dist = 600 * 600
hook.Add("HUDPaint", "nlr.DrawNLRBox", function()
	local ply = LocalPlayer()
	local row = ply:GetNetVar("nlr.info", {})
	if table.IsEmpty(row) then return end

	local ply_pos = ply:GetPos()
	local w, h = ScrW(), ScrH()
	color_red.a = TimedSin(1.5, 0, 255, 5)
	for _, v in ipairs(row) do
		if not v.time then continue end
		local pos = v.pos or Vector()
		local time = string.FormattedTime(math.max(v.time - CurTime(), 0), "%02i:%02i")

		if pos:DistToSqr(ply_pos) >= max_dist then continue end
		draw.SimpleTextOutlined("В зоне смерти оружие недоступно!", "NLR_Font1", w * 0.5, h * 0.2, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

		draw.SimpleTextOutlined(time, "NLR_Font", w * 0.5, h * 0.24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		return
	end
end)
