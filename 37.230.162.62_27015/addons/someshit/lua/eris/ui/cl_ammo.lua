local PANEL = {}

function PANEL:Init()
	self:ErisScrollbar()
end

function PANEL:Setup()
	--[[---------------------------------------------------------------------------
		Getting and sorting the categories
	---------------------------------------------------------------------------]]
	local cats = table.Copy(DarkRP.getCategories().ammo)
	table.sort(cats, function(a, b) return (a.sortOrder or 0) < (b.sortOrder or 0) end)

	for _, cat in pairs(cats) do
		--[[---------------------------------------------------------------------------
			Ensuring there is something to see in the category
		---------------------------------------------------------------------------]]
		local count = #cat.members
		if not cat.members or count < 1 then continue end
		if cat.canSee and not cat.canSee(LocalPlayer()) then continue end

		local bad = 0
		for k, v in pairs(cat.members) do
			local buyable, visible = hook.Call("CanBuyAmmo", Eris, v)
			if not buyable and not visible then
				bad = bad + 1
			end
		end

		if bad >= count then continue end
		--[[---------------------------------------------------------------------------
			The category's header
		---------------------------------------------------------------------------]]
		local header = self:Add("ErisF4CategoryHeader")
		header:Dock(TOP)
		header:SetCategory(cat)
		--[[---------------------------------------------------------------------------
			Container for the category members
		---------------------------------------------------------------------------]]
		local container = self:Add("DIconLayout")
		container:Dock(TOP)
		container:DockMargin(0, 12, 0, 25)
		header:SetContents(container)

		--[[---------------------------------------------------------------------------
			Looping through
		---------------------------------------------------------------------------]]
		for _, v in pairs(cat.members) do
			local buyable, visible, reason, price = hook.Call("CanBuyAmmo", Eris, v)
			if not buyable and not visible then continue end

			local pnl = container:Add("DPanel")
			pnl:SetSize(self:GetWide() / 6, self:GetTall() / 6)
			pnl.Paint = nil

			if reason then
				local tooltip = vgui.Create("ErisF4Tooltip")
				tooltip:SetWide(self:GetWide() / 5)
				tooltip:SetTooltipText(reason)
				tooltip:SetRemovePanel(self:GetParent():GetParent())
				tooltip:Disable()
				tooltip:Position(pnl)
			end

			local name = vgui.Create("DLabel", pnl)
			name:Dock(BOTTOM)
			name:SetText(v.name)
			name:SetFont("ErisF4Entry")
			name:SetTextColor(Eris:Theme("itemname"))
			name:SetContentAlignment(5)

			local mask = vgui.Create("ErisF4ModelMask", pnl)
			mask:Dock(FILL)
			mask:SetHoverColor(Eris:Theme("itemhover"))
			mask:SetHoverText(DarkRP.formatMoney(price))
			mask:SetPaintedOver()

			local mdl = mask:GetModelPanel()
			mdl:SetModel(v.model)
			mdl:SetFOV(15)
			mdl:SetCamPos(Vector(100, 90, 65))
			mdl:SetLookAt(Vector(9, 9, 15))

			if not buyable then mask:Disable() end
			mask.DoClick = function()
				if not buyable and reason then
					Eris:Notify("Невозможно приобрести: " .. reason)
					return
				end

				-- RunConsoleCommand("darkrp", "buyammo", v.id or v.ammoType)
				netstream.Start("DarkRP.BuyAmmo", v.id or v.ammoType)
			end

			mask.DoRightClick = function()
				if not buyable and reason then
					Eris:Notify("Невозможно приобрести: " .. reason)
					return
				end

				local ask = UI_Request("Покупка - " .. v.name, "Введите желаемое количество. " .. DarkRP.formatMoney(price) .. " за 1 шт.", function(val)
					val = tonumber(val)
					if not val then
						return
					end

					val = math.Clamp(val, 1, 32)
					UI_Derma_Query(
						"Вы уверены, что хотите купить \"" .. v.name .. "\" в количестве " .. val .. " за " .. DarkRP.formatMoney(price * val) .. "?",
						"Подтверждение:",
						"Да",
						function()
							netstream.Start("DarkRP.BuyAmmo", v.id or v.ammoType, val)
						end,
						"Нет",
						function() end
					)()
				end)

				ask()
			end
		end
	end
end

vgui.Register("ErisF4Ammo", PANEL, "DScrollPanel")