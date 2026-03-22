if CLIENT then
	local function Open(ply)
		if not IsValid(ply) then return end
		local panel_w, panel_h = ScrW() * 0.8, ScrH() * 0.8
		local panel = vgui.Create("DFrame")
		panel:SetSize(panel_w, panel_h)
		panel:Center()
		panel:ShowCloseButton(true)
		panel:SetDraggable(true)
		panel:SetTitle("Изменение бодигрупп")
		panel:MakePopup()

		function panel:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, col.ba)
		end

		local model = panel:Add("DModelPanel")
		model:SetSize(panel_w * .5, panel_h)
		model:Dock(LEFT)
		model:SetModel(ply:GetModel())
		function model:LayoutEntity(ent)
			if not IsValid(ent) then return end
			local mins, maxs = ent:GetModelBounds()
			local center = (mins + maxs) / 2
			local radius = center:Distance(maxs)
			self:SetLookAt(center)
			self:SetCamPos(center + Vector(radius, radius * 2, 0))
		end

		for k, v in pairs(ply:GetBodyGroups()) do
			model.Entity:SetBodygroup(v.id, ply:GetBodygroup(v.id))
		end

		local scroll = panel:Add("DScrollPanel")
		scroll:SetSize(panel_w * .5, panel_h * .95)
		scroll:Dock(RIGHT)

		local name = ply:Name()
		local name_label = scroll:Add("DLabel")
		name_label:SetSize(panel_w, panel_h * .05)
		name_label:SetText(name)
		name_label:SetFont("Trebuchet24")
		name_label:SetContentAlignment(5)
		name_label:Dock(TOP)

		local skins = ply:SkinCount()
		local skin = scroll:Add("DNumSlider")
		skin:SetSize(panel_w * .5, 50)
		skin:SetMin(0)
		skin:SetMax(skins - 1)
		skin:SetDecimals(0)
		skin:SetText("Skin")
		skin:SetValue(ply:GetSkin())
		local last = math.Round(skin:GetValue())
		skin.OnValueChanged = function(self, value)
			local val = math.Round(value)
			if last == val then return end
			last = val
			model.Entity:SetSkin(val)
			netstream.Start("EditBodygroups", ply, nil, val)
		end

		local bodygroups = ply:GetBodyGroups()
		for k, v in ipairs(bodygroups) do
			local bg = scroll:Add("DNumSlider")
			bg:SetSize(panel_w * .5, 50)
			bg:SetMin(0)
			bg:SetMax(v.num - 1)
			bg:SetDecimals(0)
			bg:SetText(v.name)
			bg:SetValue(ply:GetBodygroup(v.id))
			local last = math.Round(bg:GetValue())
			bg.OnValueChanged = function(self, value)
				local val = math.Round(value)
				if last == val then return end
				last = val
				model.Entity:SetBodygroup(v.id, val)
				netstream.Start("EditBodygroups", ply, v.id, val)
			end

			bg:Dock(TOP)
		end
	end

	netstream.Hook("EditBodygroups", Open)
else
	netstream.Hook("EditBodygroups", function(ply, target, id, value)
		local is_valid = IsValid(target) and target:IsPlayer() and target:Alive()
		if not is_valid then return end
		local is_eventer = ply:IsEventer() and ply:Team() == TEAM_ADMIN
		local is_global_eventer = ply:IsGlobalEventer() or ply:IsSuperAdmin()
		if not is_eventer and not is_global_eventer then return end
		if not id then
			target:SetSkin(value)
			return
		end

		target:SetBodygroup(id, value)
	end)
end
