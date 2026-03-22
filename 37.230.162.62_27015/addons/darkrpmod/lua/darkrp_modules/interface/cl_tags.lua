nameplates = nameplates or {}
surface.CreateFont("nameplates", {
	font = "Inter",
	size = 17,
	weight = 500,
	extended = true
})

surface.CreateFont("UnionPlayerHUD25", {
	font = "Inter",
	size = 23,
	weight = 400,
	extended = true
})

surface.CreateFont("UnionPlayerHUD30", {
	font = "Inter",
	size = 30,
	weight = 900,
	extended = true
})

surface.CreateFont("UnionPlayerHUD50", {
	font = "Inter",
	size = 50,
	weight = 900,
	extended = true
})

surface.CreateFont("UnionPlayerHUDChat", {
	font = "Inter",
	size = 25,
	weight = 900,
	extended = true
})


function nameplates.CalculateDecayInterpolation(percentPerTime)
	local frameTime = RealFrameTime() * game.GetTimeScale()
	local frac = math.pow(1 - percentPerTime, frameTime)
	return 1 - frac
end

function ShitDrawTexture(mat, x, y, w, h, color)
	if not color then
		surface.SetDrawColor(255, 255, 255)
	else
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
	end

	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x, y, w, h)
end

local ShitDrawTexture = ShitDrawTexture
local traceOut = {}
local traceCache = {
	output = traceOut
}

function nameplates.DrawNameplate(options)
	if not options then return end

	local ent = options.ent
	local position = options.position
	local angle = options.angle
	local maxDistance = options.maxDistance
	local aimThreshold = options.aimThreshold
	local ignoreZ = options.ignoreZ
	local lookCenter = options.lookCenter
	local func = options.func
	local uiScale = options.uiScale or 0.1

	local lp = LocalPlayer()
	if not IsValid(lp) then return end

	local lpEye = lp:EyePos()
	if not lookCenter then lookCenter = position end

	local dot = lp:GetAimVector():Dot((lookCenter - lpEye):GetNormalized())
	local dotThreshold = math.cos(aimThreshold or math.pi / 10)

	local bounds = ent:OBBMaxs() - ent:OBBMins()
	local radius = bounds:Length() / 2
	local dist = lpEye:Distance(position)
	if dist < radius * 3 then
		local f = math.Clamp((dist - radius) / (radius * 2), 0, 1)
		dotThreshold = Lerp(f, 0, dotThreshold)
	end

	local flags = dot >= dotThreshold and (not maxDistance or dist <= maxDistance)
	if ignoreZ and options.trace then
		local traceStart = options.traceStart
		if not traceStart then
			traceStart = ent:LocalToWorld(ent:OBBCenter())
			if ent:IsPlayer() then traceStart = ent:GetShootPos() end
		end

		traceCache.start = traceStart
		traceCache.endpos = lpEye
		traceCache.filter = options.traceFilter or { lp, ent }
		util.TraceLine(traceCache)
		flags = flags and not traceOut.Hit
	end

	if flags then
		ent.UISize = Lerp(nameplates.CalculateDecayInterpolation(0.975), ent.UISize or 0,
			(dot - dotThreshold) / (1 - dotThreshold))
	else
		ent.UISize = math.Clamp(Lerp(nameplates.CalculateDecayInterpolation(0.975), ent.UISize or 0, -0.1), 0, 1)
	end

	local uiSize = ent.UISize or 0
	if uiSize <= 0 then return end
	if not angle then angle = (position - lpEye):Angle() end

	local rotatedAngle = Angle(0, angle.y - 90, 90)
	local pitch = math.NormalizeAngle(angle.p)
	rotatedAngle:RotateAroundAxis(rotatedAngle:Forward(), math.Clamp(-pitch / 2, -25, 25))
	local camScale = uiScale * uiSize
	local camOffset = Vector(0, 0, 5 * uiSize)
	if options.offset then
		camOffset = camOffset + rotatedAngle:Up() * options.offset.x
		camOffset = camOffset + rotatedAngle:Forward() * options.offset.y
		camOffset = camOffset + rotatedAngle:Right() * -options.offset.z
	end

	if ignoreZ then cam.IgnoreZ(true) end
	cam.Start3D2D(position + camOffset, rotatedAngle, camScale)
	func(uiSize)
	cam.End3D2D()
	if ignoreZ then cam.IgnoreZ(false) end
end

local font = "nameplates"
local user = Material("icon16/user_add.png")
local cBackground = Color(20, 20, 20, 120)
local cTextPrimary = Color(168, 167, 168, 150)
local cTextSecondary = Color(150, 150, 150, 150)
function nameplates.DrawNPC(ent, position, angle, printName, maxDistance, textColor, firsttext, icon)
	local text = firsttext or "Продавец"
	local txt = printName or ent.name or ent:GetNW2String("PrintName", ent.PrintTable or ent:GetClass())
	local drawer = icon or user
	nameplates.DrawNameplate({
		ent = ent,
		position = position,
		angle = angle,
		maxDistance = maxDistance,
		lookCenter = ent:LocalToWorld(ent:OBBCenter()),
		aimThreshold = math.pi / 6,
		func = function(uiSize)
			draw.RoundedBox(0, -130, 10, 260, 60, cBackground)
			draw.RoundedBox(0, -130, 10, 260, 28, cBackground)
			surface.SetDrawColor(150, 150, 150, 150)
			surface.SetMaterial(drawer)
			surface.DrawTexturedRect(-120, 16, 16, 16)
			draw.SimpleText(txt, font, -103, 23, cTextPrimary, 0, 1)
			draw.SimpleText(text, font, -120, 51, cTextSecondary, 0, 1)
			surface.SetDrawColor(col.ba)
			surface.DrawOutlinedRect(-130, 10, 260, 60)
		end
	})
end

local font = "UnionPlayerHUD50"
local icons = {
	[1] = Material("icons/fa32/hand-stop-o.png", "noclamp smooth"),        -- me
	[2] = Material("icons/fa32/street-view.png", "noclamp smooth"),        -- do
	[3] = Material("icons/fa32/cube.png", "noclamp smooth"),               -- roll
	[4] = Material("icons/fa32/volume-control-phone.png", "noclamp smooth"), -- 911
	[5] = Material("icons/fa32/mobile-phone.png", "noclamp smooth"),       -- r
	[6] = Material("icons/fa32/comments.png", "noclamp smooth"),           -- ooc
	[7] = Material("icons/fa32/commenting.png", "noclamp smooth"),         -- looc
	[8] = Material("icons/fa32/terminal.png", "noclamp smooth"),           -- admin/vip
	[9] = Material("icons/fa32/pencil.png", "noclamp smooth"),             -- whistle
	[10] = Material("icons/fa32/bullhorn.png", "noclamp smooth")           -- yell

}
icons.texting = Material("icons/fa32/comment-o.png", "noclamp smooth")
icons.muted = Material("icons/fa32/volume-off.png", "noclamp smooth")
local icons_text_col = Color(255, 255, 0)
local players_chat_col = Color(200, 200, 200)
local function restricted(ply)
	local lp = LocalPlayer()
	return lp:isBandit() and ply:isBandit() or lp:isRebel() and ply:isRebel() or lp:isRefugee() and ply:isRefugee()
end

local players_chat = {}
local players_chat_time = 10
local players_chat_fadeout = 1
function nameplates.DrawPlayer(ply, pos, cache, is_being_looked, lp)
	local now = CurTime()
	local pname = cache.pname
	local tname = cache.tname
	local tcol = cache.tcol
	local hideName = cache.hideName
	local isAFK = cache.isAFK
	local protocol = cache.protocol
	local distance = cache.distance
	local texts = cache.texts
	local tname_looked = cache.tname_looked
	if is_being_looked and not hideName then tname = tname_looked end

	nameplates.DrawNameplate({
		ent = ply,
		position = pos,
		angle = lp:GetAngles(),
		maxDistance = distance,
		lookCenter = ply:LocalToWorld(ply:OBBCenter() + Vector(0, 0, 10)),
		aimThreshold = math.pi / 6,
		func = function(uiSize)
			local y = 0

			--if not ply:GetNetVar("HideJob") or should_see then
			local _, text_h = draw.SimpleText(tname, font, 0, y, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			y = y - text_h
			--end

			--if not hideName or should_see then
			local text_w, text_h = draw.SimpleText(pname, font, 0, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- В связи с системой знакомств нет смысла
			if ply:IsSpeaking() then
				local icon_y_pos = text_h - 32 - 32
				local icon = ply:_IsMuted() and icons.muted or ply:GetVoiceDistanceIcon()
				ShitDrawTexture(icon, text_w * .5 + 5, y + icon_y_pos, 32, 32)
			elseif ply:IsTyping() then
				local t = ply:GetNetVar("chat.Type", 0)
				local icon_y_pos = text_h - 32 - 32
				local icon = icons[t] or icons.texting
				ShitDrawTexture(icon, text_w * .5 + 5, y + icon_y_pos, 32, 32, icons_text_col)
			end
			y = y - text_h
			--end

			local text_h, _ = 0
			if protocol then
				_, text_h = draw.SimpleText(protocol, font, 0, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				y = y - text_h
			end

			if isAFK then
				_, text_h = draw.SimpleText(isAFK, font, 0, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				y = y - text_h
			end

			if texts then
				for k, v in ipairs(texts) do
					local text, remove_time = v[1], v[2]
					local time_left = remove_time - now
					local alpha = 255

					if time_left < players_chat_fadeout then
						alpha = math.Clamp((time_left / players_chat_fadeout) * 255, 0, 255)
					end

					_, text_h = draw.SimpleText(text, "UnionPlayerHUDChat", 0, y, ColorAlpha(players_chat_col, alpha),
						TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					y = y - text_h

					if remove_time < now then
						table.remove(texts, k)
					end
				end
			end
		end
	})
end

local font = "UnionPlayerHUD30"
function nameplates.DrawEnt(ent, position, maxDistance, curfont)
	local pname = ent:GetNetVar("PrintName", ent.PrintName or ent:GetClass())
	local desc = ent:GetNetVar("Description", ent.Description or "")
	curfont = curfont or font
	if not pname then return end
	nameplates.DrawNameplate({
		ent = ent,
		position = position,
		maxDistance = maxDistance,
		lookCenter = ent:LocalToWorld(ent:OBBCenter()),
		aimThreshold = math.pi / 6,
		func = function(uiSize)
			--draw.RoundedBox(0,-130,10,260,64,Color(20, 20, 20, 120))
			--draw.RoundedBox(0,-130,10,260,28,Color( 20, 20, 20, 120) )
			--surface.SetDrawColor( 150, 150, 150, 150 )
			--surface.SetMaterial(drawer)
			--surface.DrawTexturedRect( -85, 16, 16, 16 )
			draw.SimpleText(pname, curfont, 0, 16, Color(200, 200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(desc, curfont, 0, 58, Color(150, 150, 150, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	})
end

local function OverHeadHUD(ply, cache, is_being_looked, lp)
	local origin = ply:WorldSpaceCenter()
	local _, max = ply:WorldSpaceAABB()
	origin.z = max.z + 1

	nameplates.DrawPlayer(ply, origin, cache, is_being_looked, lp)
end

local player_targets = {}

hook.Add("PostDrawTranslucentRenderables", "OverHead", function(a, b, c)
	if a or b or c then return end
	local lp = LocalPlayer()
	local looking_at = lp:GetEyeTraceNoCursor().Entity
	for _, cache in ipairs(player_targets) do
		local ply = cache.ply
		if not IsValid(ply) then
			continue
		end
		OverHeadHUD(ply, cache, ply == looking_at, lp)
	end
end)

local function CanSeePlayer(lp, ply)
	if not ply:Alive() then return false end
	if ply:GetNoDraw() or ply:IsDormant() then return false end
	if ply:GetNW2Bool("hidden") then return false end
	if ply:GetCollisionGroup() ~= COLLISION_GROUP_DEBRIS then
		traceCache.start = lp:EyePos()
		traceCache.endpos = ply:EyePos()
		if not traceCache.filter then traceCache.filter = { lp } end
		traceCache.filter[2] = ply
		util.TraceLine(traceCache)
		if traceOut.Hit then return false end
	end
	return true
end


timer.Create("OverHead", 1, 0, function()
	local lp = LocalPlayer()
	if not IsValid(lp) then return end

	local isAdmin = lp:Team() == TEAM_ADMIN
	local lpPos = lp:GetPos()
	local lpCPCMD, lpOTA = lp:isCPCMD(), lp:isOTA()
	player_targets = {}

	for _, ply in player.Iterator() do
		if ply == lp or not CanSeePlayer(lp, ply) then continue end

		local plyPos = ply:GetPos()
		if plyPos:Distance(lpPos) > 1024 then continue end

		local cid = "#" .. ply:GetID()
		local pname = ply:GetResultNickname()
		local tname = ply:GetResultTeamName()

		local tname_looked = string.sub(tname, - #cid) ~= cid and (tname .. " | " .. cid) or tname

		local protocol
		if ply:isOTA() and (lpCPCMD or lpOTA or isAdmin) then
			protocol = ply:GetNetVar("ota.protocol", ply:getJobTable().defaultProtocol or "Без указаний")
		end

		table.insert(player_targets, {
			ply = ply,
			protocol = protocol,
			pname = pname,
			tname = tname,
			tcol = ply:GetTeamColor(),
			hideName = ply:GetNetVar("HideName") or ply:GetNetVar("HideCPName"),
			isAFK = isAdmin and ply:isAFK() and "AFK: " .. string.ToMinutesSeconds(ply:GetAFKTime()),
			distance = ply:Crouching() and 128 or 256,
			tname_looked = tname_looked,
			texts = players_chat[ply:EntIndex()] or {}
		})
	end
end)

hook.Add("OnPlayerChat", "OverHead", function(ply, text)
	if not IsValid(ply) then return end
	if not players_chat[ply:EntIndex()] then players_chat[ply:EntIndex()] = {} end
	table.insert(players_chat[ply:EntIndex()], 1, { text, CurTime() + players_chat_time + players_chat_fadeout })
end)


local last_chat_cmd = ""
hook.Add("ChatTextChanged", "OverHead", function(text)
	if string.sub(text, 1, 1) == "/" and text ~= "/" then
		local args = string.Explode(" ", text)
		local cmd = args[1]
		if cmd == last_chat_cmd then return end
		last_chat_cmd = cmd
		netstream.Start("chat.Cmd", last_chat_cmd)
	elseif last_chat_cmd ~= "" then
		last_chat_cmd = ""
		netstream.Start("chat.Cmd", last_chat_cmd)
	end
end)