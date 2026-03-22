local PANEL = {}

function PANEL:Init()
	self:ErisScrollbar()
end

function PANEL:Setup()
	/*---------------------------------------------------------------------------
		Getting and sorting the categories
	---------------------------------------------------------------------------*/
	local cats = table.Copy(DarkRP.getCategories().entities)
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
			local buyable, visible = hook.Call("CanBuyEntity", Eris, v)
			if(!buyable && !visible) then bad = bad + 1 end
		end
		if(bad >= count) then continue end



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
			local buyable, visible, reason, price = hook.Call("CanBuyEntity", Eris, v)
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
			name:SetText(v.vip and "[VIP]"..v.name or v.name)
			name:SetFont("ErisF4Entry")
			name:SetTextColor(Eris:Theme("itemname"))
			name:SetContentAlignment(5)

			local mask = vgui.Create("ErisF4ModelMask", pnl)
			mask:Dock(FILL)
			mask:SetHoverColor(Eris:Theme("itemhover"))
			mask:SetHoverText(DarkRP.formatMoney(price))
			mask:SetPaintedOver()

			local old = mask.PaintOver
			mask.PaintOver = function(s, w, h)
				old(s, w, h)

				local text = Eris:Lang("max")..(v.max || "--")
				surface.SetFont("Trebuchet18")
				local tw, th = surface.GetTextSize(text)
				tw, th = tw+15, th

				draw.RoundedBoxEx(4,w/2-tw/2,h-th,tw,th,Eris:Theme("tabs"),true,true)
				draw.SimpleText(text, "Trebuchet18", w/2, h-th/2, Eris:Theme("tabtext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local mdl = mask:GetModelPanel()
			mdl:SetModel(v.model)
			mdl:SetFOV(30)
			mdl:SetCamPos(Vector(100, 90, 65))
			mdl:SetLookAt(Vector(9, 9, 15))

			if(!buyable) then mask:Disable() end

			mask.DoClick = function()
				if(!buyable && reason) then Eris:Notify("Cannot Purchase: "..reason) return end

				RunConsoleCommand("darkrp", v.cmd)
			end
		end
	end
end

vgui.Register("ErisF4Entities", PANEL, "DScrollPanel")