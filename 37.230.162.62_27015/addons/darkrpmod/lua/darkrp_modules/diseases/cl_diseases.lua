net.Receive("D_ChatText", function()
	local player = LocalPlayer()
	local text = net.ReadString()
	local color = net.ReadColor()
	if IsValid(player) then chat.AddText(color, text) end
end)

hook.Add("RenderScreenspaceEffects", "BlurDisease", function()
	local ply = LocalPlayer()
	if ply:Alive() then
		local dis = ply:GetDisease()
		if dis and isfunction(dis.vis_effect) then dis.vis_effect(ply) end
		--[[
		local freezing = ply:GetNetVar("freezing", 0) / 50
		if freezing > 0 then
			local tab = {
				[ "$pp_colour_addr" ] = 0,
				[ "$pp_colour_addg" ] = 0.1 * freezing,
				[ "$pp_colour_addb" ] = 0.2 * freezing,
				[ "$pp_colour_brightness" ] = 0,
				[ "$pp_colour_contrast" ] = 1,
				[ "$pp_colour_colour" ] = 1 - freezing * 0.5,
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			}
			DrawColorModify(tab)
		end
		--]]
	end
end)

--[[
local color_black = Color(15, 15, 15)
local frost = Material("unionrp/ui/frost.png", "smooth")
hook.Add("HUDPaint", "zFreezingText", function()

	local ply = LocalPlayer()
	if ply:Alive() then

		local w, h = ScrW(), ScrH()
		local freezing = ply:GetNetVar("freezing", 0)
		if freezing >= 40 then
			local percent = (freezing - 30) / 100
			local effectAlpha = 255 * percent
			surface.SetDrawColor(255, 255, 255, effectAlpha) -- Set the drawing color
			surface.SetMaterial(frost) -- Use our cached material
			surface.DrawTexturedRect(0, 0, w, h) -- Actually draw the rectangle
		end

		if freezing >= 80 then
			local alpha = 255 * math.abs(math.sin(CurTime() * 1.5))
			local al = math.Clamp(255, 0, alpha)
			draw.DrawText("Вы замерзаете! Зайдите в помещение.", "Point_Font", w / 2, h - 25, ColorAlpha(color_black, al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.DrawText("Вы замерзаете! Зайдите в помещение.", "Point_Font", w / 2 - 1, h - 25 - 0.5, ColorAlpha(color_white, al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)

local dist = 1500 * 1500
local nextSighCooldown = setmetatable({}, {__mode = "k"})

-- Визуал пара из рта
--[[
local function sighFunc(target)
	if (nextSighCooldown[target] or 0) > CurTime() then return end
	nextSighCooldown[target] = CurTime() + math.random(3, 6)

	if not StormFox2 or not StormFox2.Wind or diseases.config:Immune(target) or not StormFox2.Wind.IsEntityInWind(target) then return end

	local localPlayer = LocalPlayer()
	local pos = localPlayer:GetPos():DistToSqr(target:GetPos())
	if pos > dist then return end

	local pe = ParticleEmitter(Vector())
	for i = 0, 9 do
		timer.Simple(0.5 + i * 0.1, function()
			if not IsValid(target) then return end

			local att = target:GetAttachment(target:LookupAttachment("mouth") or 0)
			if not att then return end
			local attPos = att.Pos
			if target == localPlayer and not target:ShouldDrawLocalPlayer() then
				attPos = EyePos() - Vector(0, 0, 3)
			end

			local part = pe:Add(string.format("particle/smokesprites_00%02d", math.random(7,16)), attPos)
			if not part then return end
			part:SetColor(255,255,255)
			part:SetVelocity(att.Ang:Forward() * (15 - i * 0.5) + part:GetVelocity())
			part:SetGravity(Vector(0,0,1))
			part:SetDieTime(1)
			part:SetLifeTime(0)
			part:SetStartSize(1)
			part:SetEndSize(6)
			part:SetStartAlpha(25)
			part:SetEndAlpha(0)
			part:SetCollide(false)
			part:SetRoll(math.random(360))
			part:SetRollDelta(math.random() - 0.5)
			part:SetAirResistance(50)
			part:SetLighting(false)
		end)
	end
	timer.Simple(1.5, function()
		if IsValid(pe) then
			pe:Finish()
		end
	end)
end

timer.Create("SighAllPlayers", 1, 0, function()
	for _, target in player.Iterator() do
		sighFunc(target)
	end
end)
--]]