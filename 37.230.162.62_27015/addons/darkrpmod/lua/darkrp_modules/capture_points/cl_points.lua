local DarkRP = istable(DarkRP) and DarkRP or {}
DarkRP.CPoints = DarkRP.CPoints or {}
local CPoints = DarkRP.CPoints
local p_convar = CreateClientConVar("cpoints_debug", 0, false)

surface.CreateFont("Point_Font", {
	font = "Inter",
	extended = true,
	size = 20,
})

local laser = Material("effects/bluelaser1")
hook.Add("PostDrawOpaqueRenderables", "DebugCapturePoints", function()
	local ply = LocalPlayer()
	if p_convar:GetInt() == 1 and ply:IsSuperAdmin() and ply:Alive() then
		local ang = Angle(0, ply:GetAngles().y - 90, 90)
		for k, v in pairs(CPoints.points) do
			local pos1, pos2 = v.pos[1], v.pos[2]
			local mid = LerpVector(0.5, pos1, pos2)
			local owner = v.owner == "" and "Ничья" or v.owner == "rebels" and "Повстанцы" or "Альянс"
			local kill1 = v.kills.cp
			local kill2 = v.kills.rebel
			local endofcaptures = math.ceil(v.endofcapture and v.endofcapture > 0 and v.endofcapture - CurTime() or 0)
			cam.IgnoreZ(true)
			cam.Start3D2D(mid, ang, 1)
			draw.SimpleTextOutlined("Point: " .. v.name .. ".", "Point_Font", 0, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined("Owner: " .. owner .. ".", "Point_Font", 0, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined("Kills Rebels/Alliance: " .. kill2 .. "/" .. kill1 .. ".", "Point_Font", 0, 80, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined("Time: " .. endofcaptures .. ".", "Point_Font", 0, 110, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			cam.End3D2D()
			cam.IgnoreZ(false)
			render.SetMaterial(laser)
			render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), pos1, pos2, Color(255, 0, 0), false)
		end
	end
end)

netstream.Hook("SyncPoints", function(data)
	local data = data
	CPoints.points[data.id] = data
end)

local i = false
netstream.Hook("CaptureNotify_CP", function(data)
	local data = data
	if i == false then
		i = true
		timer.Simple(1, function()
			surface.PlaySound("npc/overwatch/radiovoice/allunitsdeliverterminalverdict.wav")
			timer.Simple(2, function()
				surface.PlaySound("npc/overwatch/cityvoice/f_localunrest_spkr.wav")
				i = false
			end)
		end)
	end

	CPoints:AddLine(data[1], data[2], data[3], Color(data[4].r, data[4].g, data[4].b, data[4].a))
end)

--[[-------------------------------------------------------------------------
Civil Protection HUD
---------------------------------------------------------------------------]]
surface.CreateFont("pd2_assault_text", {
	font = "Inter",
	size = 30,
	extended = true,
})

surface.CreateFont("pd2_assault_text_shad", {
	font = "Inter",
	size = 20,
	extended = true,
	outline = true
})

local Lines = Lines or {}
function CPoints:AddLine(text, icon, time, color)
	if not LocalPlayer():isCP() then return end
	if not text then return end
	icon = icon or "icon16/shield.png"
	time = time or 5
	color = color or Color(255, 255, 255)
	table.insert(Lines, {text, icon, CurTime() + time, color})
	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
end

local function DrawScrollingText(text, xxx, y, texwide, color)
	surface.SetFont("pd2_assault_text")
	local w, h = surface.GetTextSize(text)
	w = w

	local x = math.fmod(CurTime() * 125, w) * -1
	color = color or Color(255, 255, 255, 255)
	while x < texwide do

		surface.SetTextColor(color)
		surface.SetTextPos(x + xxx, y)
		surface.DrawText(text)

		x = x + w
	end
end

local moar_w = 230
hook.Add("HUDPaint", "CPoints.WarnHUD", function()
	local ply = LocalPlayer()
	if ply:isCP() and ply:Alive() and (istable(Lines) and #Lines > 0) then
		local y = 40
		local height = draw.GetFontHeight("pd2_assault_text")
		local curtime = CurTime()
		local w, h = ScrW(), ScrH()
		for k, v in ipairs(Lines) do
			if v[3] < curtime then
				table.remove(Lines, k)
			else
				moar_w = math.Clamp(moar_w - 7.5, 0, 230)

				surface.SetDrawColor(255, 0, 0, 10 + math.abs(math.sin(CurTime() * 2)) * 45)

				surface.DrawRect(w - 310 + moar_w, y + 22, 265 - moar_w, 46)

				surface.SetDrawColor(v[4])
				surface.DrawRect(w - 310 + moar_w, y + 65, 15, 3)
				surface.DrawRect(w - 310 + moar_w, y + 55, 3, 12)

				surface.DrawRect(w - 310 + moar_w, y + 22, 15, 3)
				surface.DrawRect(w - 310 + moar_w, y + 24, 3, 12)

				surface.DrawRect(w - 60, y + 65, 15, 3)
				surface.DrawRect(w - 48, y + 55, 3, 12)

				surface.DrawRect(w - 60, y + 22, 15, 3)
				surface.DrawRect(w - 48, y + 24, 3, 12)

				surface.DrawRect(w - 40, y + 22, 20, 20)

				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetMaterial(Material(v[2]))
				surface.DrawTexturedRect(w - 38, y + 24, 16, 16)

				if moar_w <= 0 then
					render.SetScissorRect(w - 310, y + 22, w - 45, y + 68, true)
					DrawScrollingText("///     " .. v[1] .. "     ", w - 300, y + 30, 300, v[4])
					render.SetScissorRect(0, 0, 0, 0, false)
				end

				y = y + height + 25
			end
		end
	end
end)
