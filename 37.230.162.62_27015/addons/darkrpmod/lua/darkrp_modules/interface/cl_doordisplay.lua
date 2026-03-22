local TitleColor = Color(255, 255, 255, 255)
local TitleOutlineColor = Color(0, 0, 0, 200)

local OwnerColor = Color(255, 255, 255, 255)
local OwnerOutlineColor = Color(0, 0, 0, 200)

local CoownerColor = Color(255, 255, 255, 255)
local CoownerOutlineColor = Color(0, 0, 0, 200)

local AllowedGroupsColor = Color(255, 255, 255, 255)
local AllowedGroupsOutlineColor = Color(0, 0, 0, 200)

local PurchaseColor = Color(255, 255, 255, 255)
local PurchaseOutlineColor = Color(0, 0, 0, 255)

local DrawDistance = 250
surface.CreateFont("DoorDisplayTitleFont", {
	font = "Trebuchet24",
	size = 30,
	weight = 900,
	extended = true,
})

surface.CreateFont("DoorDisplayTrebuchetSmall", {
	font = "Trebuchet24",
	size = 22,
	extended = true,
})

local doorInfo = {}
local function computeFadeAlpha(time, dur, sa, ea, start)
	time = time - (start or 0)
	if time < 0 then return sa end
	if time > dur then return ea end
	return sa + math.sin((time / dur) * (math.pi / 2)) ^ 2 * (ea - sa)
end

local doorClass = {
	["func_door"] = true,
	["func_door_rotating"] = true,
	["prop_door_rotating"] = true
}

local function isDoor(door)
	return doorClass[door:GetClass()]
end

local function isOwnable(doorData)
	return doorData and doorData.nonOwnable ~= true
end

local function getOwner(doorData)
	local owner = doorData.owner and Player(doorData.owner)
	return IsValid(owner) and owner or nil
end

local function getCoowners(doorData)
	local coents = {}
	for id, _ in pairs(doorData.extraOwners or {}) do
		local ply = Player(id)
		if IsValid(ply) then table.insert(coents, ply) end
	end
	return coents
end

local function isAllowedToCoown(doorData, ply)
	return doorData.allowedToOwn and doorData.allowedToOwn[ply:UserID()] and doorData.entity and not doorData.entity:isKeysOwnedBy(ply)
end

local function getAllowedGroupNames(door)
	local ret = {}
	if door:getKeysDoorGroup() then
		table.insert(ret, door:getKeysDoorGroup())
	else
		for tid in pairs(door:getKeysDoorTeams() or {}) do
			local tname = team.GetName(tid)
			if tname then table.insert(ret, tname) end
		end
	end
	return ret
end

hook.Add("HUDDrawDoorData", "sh_doordisplay_hudoverride", function(door)
	if isDoor(door) then
		local doorData = door:getDoorData()
		if not isOwnable(doorData) then return end
		if #getAllowedGroupNames(door) < 1 then
			local dist = door:GetPos():Distance(LocalPlayer():GetShootPos())
			local admul = math.cos((dist / DrawDistance) * (math.pi / 2)) ^ 2
			local bind = input.LookupBinding("gm_showteam") or "NONE"
			surface.SetAlphaMultiplier(admul)
			if not getOwner(doorData) then
				draw.SimpleTextOutlined("Нажмите \"" .. bind:upper() .. "\", чтобы купить.", "DoorDisplayTrebuchetSmall", ScrW() / 2, ScrH() / 2, PurchaseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, PurchaseOutlineColor)
			elseif isAllowedToCoown(doorData, LocalPlayer()) then
				draw.SimpleTextOutlined("Нажмите \"" .. bind:upper() .. "\", чтобы купить.", "DoorDisplayTrebuchetSmall", ScrW() / 2, ScrH() / 2, PurchaseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, PurchaseOutlineColor)
			end

			surface.SetAlphaMultiplier(1)
		end
		return true
	end
end)

hook.Add("PostDrawTranslucentRenderables", "sh_doordisplay_drawdisplay", function(a, b, c)
	if a or b or c then return end
	local shoot_pos = LocalPlayer():GetShootPos()
	for index, dinfo in pairs(doorInfo) do

		local door = dinfo.entity
		if not IsValid(door) or door:IsDormant() then continue end
		local dist = door:GetPos():Distance(shoot_pos)
		if dist <= DrawDistance then
			doorData = DarkRP.doorData[index]
			dinfo.viewStart = dinfo.viewStart or CurTime()

			local title = dinfo.title
			local owner = getOwner(doorData)
			local coowners = getCoowners(doorData) or {}
			local allowedgroups = getAllowedGroupNames(door)
			local lpos, lang = Vector(), Angle()
			lpos:Set(dinfo.lpos)
			lang:Set(dinfo.lang)

			local ang = door:LocalToWorldAngles(lang)
			local dot = ang:Up():Dot(shoot_pos - door:WorldSpaceCenter())
			if dot < 0 then
				lang:RotateAroundAxis(lang:Right(), 180)

				lpos = lpos - 2 * lpos * -lang:Up()
				ang = door:LocalToWorldAngles(lang)
			end

			local pos = door:LocalToWorld(lpos)
			local scale = 0.14
			local vst = dinfo.viewStart
			local ct = CurTime()
			cam.Start3D2D(pos, ang, scale)
			local admul = math.cos((dist / DrawDistance) * (math.pi / 2)) ^ 2
			local amul = computeFadeAlpha(ct, 0.75, 0, 1, vst) * admul
			if #allowedgroups < 1 then
				if title and string.utf8len(title) > 16 then title = string.utf8sub(title, 1, 16) .. "..." end
				if not owner then
					surface.SetAlphaMultiplier(amul)
					draw.SimpleTextOutlined("Свободно", "DoorDisplayTitleFont", 17, 10, TitleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, TitleOutlineColor)
				else
					amul = computeFadeAlpha(ct, 0.75, 0, 1, vst + 0.35) * admul
					surface.SetAlphaMultiplier(amul)
					draw.SimpleTextOutlined(owner:Nick(), "Trebuchet24", 0, 50, OwnerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, OwnerOutlineColor)
					if #coowners > 0 then
						if not dinfo.coownCollapsed then
							local conames = {}
							for i = 1, #coowners do
								table.insert(conames, coowners[i]:Nick())
							end

							table.sort(conames)
							for i = 1, #conames do
								amul = computeFadeAlpha(ct, 0.75, 0, 1, dinfo.coownExpandStart + 0.2 * i) * admul
								surface.SetAlphaMultiplier(amul)
								draw.SimpleTextOutlined(conames[i], "DoorDisplayTrebuchetSmall", 0, 60 + 25 * i, CoownerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CoownerOutlineColor)
							end
						else
							amul = computeFadeAlpha(ct, 1, 0, 1, vst + 1.0) * admul
							local whitpos = util.IntersectRayWithPlane(LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(), pos, ang:Up())
							local cy = 0
							local cactive = false
							if whitpos and LocalPlayer():GetEyeTrace().Entity == door then
								local hitpos = door:WorldToLocal(whitpos) - lpos
								cy = -hitpos.z / scale
								cactive = true
							end

							if ct - vst >= 2 and cactive and cy >= 80 and cy <= 80 + 25 then
								dinfo.coownExpandRequestStart = dinfo.coownExpandRequestStart or CurTime()
								if CurTime() - dinfo.coownExpandRequestStart >= 0.75 then
									dinfo.coownCollapsed = false
									dinfo.coownExpandStart = CurTime()
									dinfo.coownExpandRequestStart = nil
								end

								amul = computeFadeAlpha(ct, 0.75, 1, 0, dinfo.coownExpandRequestStart) * admul --fade out
							else
								dinfo.coownExpandRequestStart = nil
							end

							surface.SetAlphaMultiplier(amul)
							draw.SimpleTextOutlined("И " .. #coowners .. " других.", "DoorDisplayTrebuchetSmall", 0, 80, CoownerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, CoownerOutlineColor)
						end
					end
				end
			else
				for i = 1, #allowedgroups do
					amul = computeFadeAlpha(ct, 0.75, 0, 1, vst + 0.2 * i) * admul
					surface.SetAlphaMultiplier(amul)
					draw.SimpleTextOutlined(allowedgroups[i], "Trebuchet24", 0, 50 + 30 * (i - 1), AllowedGroupsColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, AllowedGroupsOutlineColor)
				end
			end

			cam.End3D2D()
			surface.SetAlphaMultiplier(1)
		else
			dinfo.viewStart = nil
			dinfo.coownCollapsed = true
		end
	end
end)

local NULL = NULL
timer.Create("sh_doordisplay_drawdisplay", 5, 0, function()
	if LocalPlayer() == NULL then return end
	for index, doorData in pairs(DarkRP.doorData) do
		if not isOwnable(doorData) then continue end

		local dinfo = doorInfo[index]
		if not dinfo then
			local door = Entity(index)
			if door == NULL then continue end
			dinfo = {
				coownCollapsed = true,
				entity = door
			}

			local dimens = door:OBBMaxs() - door:OBBMins()
			local center = door:OBBCenter()
			local min, j
			for i = 1, 3 do
				if not min or dimens[i] <= min then
					j = i
					min = dimens[i]
				end
			end

			local norm = Vector()
			norm[j] = 1
			local lang = Angle(0, norm:Angle().y + 90, 90)
			if door:GetClass() == "prop_door_rotating" then
				dinfo.lpos = Vector(center.x, center.y, 30) + lang:Up() * (min / 6)
			else
				dinfo.lpos = center + Vector(0, 0, 20) + lang:Up() * (min / 2 - 0.1)
			end

			dinfo.lang = lang
			doorInfo[index] = dinfo
		end
	end
end)
