local PANEL = {}

function PANEL:Init()
	self:ErisScrollbar()
end

function PANEL:Setup()
	/*---------------------------------------------------------------------------
		Getting and sorting the categories
	---------------------------------------------------------------------------*/
	local vehicles = DarkRP.getCategories().vehicles
	if(!vehicles) then return end

	local cats = table.Copy(vehicles)
	table.sort(cats, function(a, b) return (a.sortOrder || 0) < (b.sortOrder || 0) end)

	for _, cat in pairs(cats) do
		/*---------------------------------------------------------------------------
			Ensuring there is something to see in the category
		---------------------------------------------------------------------------*/
		local count = #cat.members
		if(!cat.members || count < 1) then continue end
		if(cat.canSee && !cat.canSee(LocalPlayer())) then continue end

		local bad = 0
		for k, v in pairs(cat.members) do
			local buyable, visible = hook.Call("CanBuyVehicle", Eris, v)
			if(!buyable && !visible) then bad = bad + 1 end
		end
		if(bad >= count) then continue end


		/*---------------------------------------------------------------------------
			The category's header
		---------------------------------------------------------------------------*/
		local header = self:Add("ErisF4CategoryHeader")
		header:Dock(TOP)
		header:SetCategory(cat)


		/*---------------------------------------------------------------------------
			Container for the weapons
		---------------------------------------------------------------------------*/
		local container = self:Add("DIconLayout")
		container:Dock(TOP)
		container:DockMargin(0, 12, 0, 25)
		header:SetContents(container)


		/*---------------------------------------------------------------------------
			Looping through
		---------------------------------------------------------------------------*/
		for _, v in pairs(cat.members) do
			local buyable, visible, reason, price = hook.Call("CanBuyVehicle", Eris, v)
			if(!buyable && !visible) then continue end

			local pnl = container:Add("DPanel")
			pnl:SetSize(self:GetWide()/6, self:GetTall()/6)
			pnl.Paint = nil

			if(reason) then
				local tooltip = vgui.Create("ErisF4Tooltip")
				tooltip:SetWide(self:GetWide()/5)
				tooltip:SetTooltipText(reason)
				tooltip:SetRemovePanel(self:GetParent():GetParent())

				tooltip:Disable()
				tooltip:Position(pnl)
			end

			local name = vgui.Create("DLabel", pnl)
			name:Dock(BOTTOM)
			name:SetText(v.label || v.name)
			name:SetFont("ErisF4Entry")
			name:SetTextColor(Eris:Theme("itemname"))
			name:SetContentAlignment(5)

			local mask = vgui.Create("ErisF4ModelMask", pnl)
			mask:Dock(FILL)
			mask:SetHoverColor(Eris:Theme("itemhover"))
			mask:SetHoverText(DarkRP.formatMoney(price))
			mask:SetPaintedOver()

			mask:Setup(v.model, true)
			
			if(!buyable) then mask:Disable() end

			mask.DoClick = function()
				if(!buyable && reason) then Eris:Notify("Cannot Purchase: "..reason) return end

				RunConsoleCommand("darkrp", "buyvehicle", v.name)
			end
		end
	end
end

vgui.Register("ErisF4Vehicles", PANEL, "DScrollPanel")