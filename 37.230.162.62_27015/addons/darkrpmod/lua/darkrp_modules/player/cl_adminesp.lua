surface.CreateFont("esp_font1", {
	font = "Inter",
	size = 16,
	weight = 500,
	extended = true
})

surface.CreateFont("esp_font2", {
	font = "Inter",
	size = 18,
	weight = 500,
	extended = true
})

local turned_on_wallhack = CreateClientConVar("unionrp_admin_wallhack", "1", true, false, "")
local turned_on_wallhack_fd = CreateClientConVar("unionrp_admin_wallhack_fd", "1", false, false, "")
do
	local surface_SetDrawColor = surface.SetDrawColor
	local surface_SetTextColor = surface.SetTextColor
	local surface_SetTextPos = surface.SetTextPos
	local surface_SetFont = surface.SetFont
	local surface_DrawOutlinedRect = surface.DrawOutlinedRect
	local surface_DrawRect = surface.DrawRect
	local surface_DrawText = surface.DrawText

	local color_lightred = Color(255, 100, 100)
	local color_lightblue = Color(200, 200, 255)

	local function DrawText(text, x, y, color)
		surface_SetTextColor(color.r, color.g, color.b, color.a)
		local text_x, text_y = surface.GetTextSize(text)
		y = y - text_y
		surface_SetTextPos(x - text_x * 0.5, y)
		surface_DrawText(text)
	end

	local vec1 = Vector()
	local vec2 = Vector()
	hook.Add("HUDPaint", "AdmEsp", function()
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:Alive() then return end
		if ply:Team() ~= TEAM_ADMIN and not ply:IsSuperAdmin() then return end

		if not turned_on_wallhack:GetBool() then return end
		if ply:GetMoveType() ~= MOVETYPE_NOCLIP or ply:InVehicle() then return end
		if ply:GetNetVar("IgnoreESP") then return end

		local clientPos = ply:GetPos()
		for _, v in player.Iterator() do
			local dist = clientPos:Distance(v:GetPos())
			if v == ply or dist > 50 then
				if v:IsSuperAdmin() and not ply:IsSuperAdmin() then continue end
				local pos = v:GetPos()
				vec1:SetUnpacked(pos.x, pos.y, pos.z + 60)
				local head = vec1
				local screenPos = pos:ToScreen()
				local headPos = head:ToScreen()
				vec2:SetUnpacked(head.x, head.y, head.z + 40)
				local textPos = vec2:ToScreen()
				local x, y = headPos.x, headPos.y
				if (x < 0 or x > ScrW()) or (y < 0 or y > ScrH()) then continue end
				local size = 52 * math.abs(350 / dist)
				local teamn = v:Team()
				local teamColor = team.GetColor(teamn) or color_white
				local name = ""
				if v:GetMoveType() == MOVETYPE_NOCLIP then name = " (Noclip)" end
				name = v:Name() .. name
				surface_SetFont("esp_font2")
				DrawText(name, textPos.x, textPos.y, teamColor)
				surface_SetFont("esp_font1")
				DrawText(v:SteamName(), textPos.x, textPos.y + 14, color_lightblue)
				DrawText(team.GetName(teamn), textPos.x, textPos.y + 28, teamColor)
				if v:Alive() and dist < 1000 then
					surface_SetDrawColor(teamColor)
					surface_DrawOutlinedRect(x - size * 0.5, y - size * 0.5, size, (screenPos.y - y) * 1.25)
				elseif not v:Alive() then
					DrawText("*DEAD*", textPos.x, textPos.y + 42, color_lightred)
				end

				if dist < 1000 then
					local bx, by = x - size * 0.5, y - size * 0.5 + (screenPos.y - y) * 1.25
					local hpM = math.Clamp((v:Health() or 0) / v:GetMaxHealth(), 0, 1)
					if hpM > 0 then
						surface_SetDrawColor(100, 100, 100) -- color_gray
						surface_DrawRect(bx, by, size, 2)
						surface_SetDrawColor(255, 0, 0) -- color_red
						surface_DrawRect(bx, by, size * hpM, 2)
					end

					local arM = math.Clamp((v:Armor() or 0) / 100, 0, 1)
					if arM > 0 then
						surface_SetDrawColor(100, 100, 100) -- color_gray
						surface_DrawRect(bx, by + 3, size, 2)
						surface_SetDrawColor(0, 0, 255) -- color_blue
						surface_DrawRect(bx, by + 3, size * arM, 2)
					end
				end
			end
		end
	end)

	local fdEnts = {}
	function DarkRP.adminGetClosestFadingDoors()
		return fdEnts
	end

	timer.Create("admEsp", 0.5, 0, function()
		table.Empty(fdEnts)
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:Alive() then return end
		if ply:Team() ~= TEAM_ADMIN and not ply:IsSuperAdmin() then return end
		if not turned_on_wallhack:GetBool() then return end
		if not turned_on_wallhack_fd:GetBool() then return end
		if ply:GetMoveType() ~= MOVETYPE_NOCLIP or ply:InVehicle() then return end
		if ply:GetNetVar("IgnoreESP") then return end

		local clientPos = LocalPlayer():EyePos()
		for id, v in ipairs(ents.FindInSphere(clientPos, 300)) do
			if v:GetNetVar("fading") ~= false then continue end
			table.insert(fdEnts, v)
		end
	end)

	hook.Add("HUDPaint", "AdmEspFD", function()
		if table.IsEmpty(fdEnts) then return end

		for id, v in ipairs(fdEnts) do
			if not IsValid(v) then continue end

			local center = v:LocalToWorld(v:OBBCenter()):ToScreen()
			local x, y = center.x, center.y
			if (x < 0 or x > ScrW()) or (y < 0 or y > ScrH()) then continue end

			surface_SetFont("esp_font2")
			DrawText(v:EntIndex(), center.x, center.y, color_white)
		end
	end)
end
