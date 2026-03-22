local key = Material("unionrp/ui/key_ref.png", "noclamp smooth")

local convars = {
	"union_radio_bind_key",
	"union_radio_settings_key",
	"union_radio_mute_key",
	"union_voice_proximity_key",
	"union_vote_y_key",
	"union_vote_n_key",
	"union_pda_bind_key"
}

local function CollectKeys()
	local convar_values = {}
	for _, convar in ipairs(convars) do
		local c = GetConVar(convar)
		if not c then
			continue
		end
		local value = c:GetInt()
		convar_values[value] = convar
	end
	local keys = {}
	for i = 1, 36 do
		if not convar_values[i] and not input.LookupKeyBinding(i) then
			table.insert(keys, i)
		end
	end

	netstream.Start("QTE.Receive", keys)
end

for _, convar in ipairs(convars) do
	cvars.AddChangeCallback(convar, CollectKeys)
end

netstream.Hook("QTE.Success", function() surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav") end)
netstream.Hook("QTE.Receive", function(gen_time)
	if not gen_time then
		hook.Remove("HUDPaint", "QTE.Draw")
		return
	end

	local ss = util.SScale

	local w, h = ScrW(), ScrH()
	local progress_w, progress_h = ss(480), 32
	local progress_rounding = 8
	local x, y = (w - progress_w) / 2, h * 0.75
	local key_x, key_y = w / 2, y - progress_h * 4
	local key_box_w, key_box_h = 128, 128
	local key_box_x, key_box_y = key_x - key_box_w * .5, key_y - key_box_h * .5 * .75

	local lp = LocalPlayer()
	local time_end = CurTime() + gen_time

	hook.Add("HUDPaint", "QTE.Draw", function()
		local key_id = lp:GetNetVar("QTE.Key")
		if not key_id then return end
		local key_name = string.upper(input.GetKeyName(key_id))

		local now = CurTime()
		local progress = 1 - Lerp((time_end - now) / gen_time, 0, 1)

		draw.RoundedBox(progress_rounding, x, y, progress_w, progress_h, col.ba)
		draw.RoundedBox(progress_rounding, x, y, progress_w * progress, progress_h, col.o)

		surface.SetMaterial(key)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(key_box_x, key_box_y, key_box_w, key_box_h)

		draw.SimpleText(key_name, "DermaLarge", key_x, key_y, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end)

hook.Add("Think", "QTE.CollectKeys", function()
	if not IsValid(LocalPlayer()) then return end
	hook.Remove("Think", "QTE.CollectKeys")
	CollectKeys()
end)
