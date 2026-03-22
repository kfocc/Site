hook.Add("HUDPaint", "DrawTextRagdolled", function()
	local ply = LocalPlayer()
	if ply:GetNetVar("tempRagdoll") and not ply:GetNetVar("ragdollStanding") then
		draw.SimpleText("Нажмите " .. input.LookupBinding("+jump") .. ", чтобы подняться.", "DermaLarge", ScrW() * 0.5, ScrH() * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

local lerp
local text = "Встаем"
local oldText = text
local nextDot = CurTime() + 0.5
local i = 0
local lastTime = CurTime()
hook.Add("HUDPaint", "UnProgress", function()
	local ply = LocalPlayer()
	local time = ply:GetNetVar("ragdollTime")
	if time then
		local start = time[1]
		time = time[2]

		if time ~= lastTime then
			start = CurTime()
			lastTime = time
		end

		time = math.ceil((100 / time) * (time - ((start + time) - CurTime())))
		local new_time = 600 * time / 100
		if new_time > 0 and new_time < 600 then
			lerp = Lerp(FrameTime() * 10, lerp or 0, new_time)
			local w, h = ScrW() * 0.5, ScrH() * 0.95
			local boxW, boxH = w - 300, h + 20
			draw.RoundedBox(4, boxW, boxH, 592, 6, col.ba)
			draw.RoundedBox(4, boxW, boxH, lerp, 5, col.o)

			if text then
				if nextDot <= CurTime() then
					if i < 3 then
						i = i + 1
						text = text .. "."
					else
						i = 0
						text = oldText
					end

					nextDot = CurTime() + 0.5
				end

				draw.SimpleText(text, "Delay_Font", w, h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end)
