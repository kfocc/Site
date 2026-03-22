local bool, text, float, start
local i, next_dot, lerp = 0, CurTime() + 0.5
local old_text = ""
net.Receive("Un.Actions", function(len)
	bool = net.ReadBool() or false
	if not bool then return end
	text = net.ReadString() or nil
	old_text = text
	float = net.ReadFloat() - CurTime() or 0
	start = CurTime() or 0
	lerp = 0
end)

surface.CreateFont("Delay_Font", {
	font = "Inter",
	size = 23,
	weight = 500,
	extended = true,
})

hook.Add("HUDPaint", "Un.Actions", function()
	if bool == true and float then
		local frac = math.ceil((100 / float) * (float - ((start + float) - CurTime())))
		local new_float = 600 * frac / 100
		if new_float > 0 and new_float < 600 then
			lerp = Lerp(FrameTime() * 10, lerp or 0, new_float)
			local w, h = ScrW() * 0.5, ScrH() * 0.78
			local boxW, boxH = w - 300, h + 20
			draw.RoundedBox(4, boxW, boxH, 592, 6, col.ba)
			draw.RoundedBox(4, boxW, boxH, lerp, 5, col.o)
			if text then
				if next_dot <= CurTime() then
					if i < 3 then
						i = i + 1
						text = text .. "."
					else
						i = 0
						text = old_text
					end

					next_dot = CurTime() + 0.5
				end

				draw.SimpleText(text, "Delay_Font", w, h + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end)
