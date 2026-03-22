local PANEL = {}

function PANEL:Init()
	self:ErisScrollbar()
end

function PANEL:Setup()
	local container = vgui.Create("DIconLayout", self)
	container:Dock(FILL)

	for _, v in pairs(FoodItems) do
		local buyable, visible, reason = hook.Call("CanBuyFood", Eris, v)
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
		name:SetText(v.name)
		name:SetFont("ErisF4Entry")
		name:SetTextColor(Eris:Theme("itemname"))
		name:SetContentAlignment(5)

		local mask = vgui.Create("ErisF4ModelMask", pnl)
		mask:Dock(FILL)
		mask:SetHoverColor(Eris:Theme("itemhover"))
		mask:SetHoverText(DarkRP.formatMoney(v.price))
		mask:SetPaintedOver()

		local mdl = mask:GetModelPanel()
		mdl:SetModel(v.model)
		mdl:SetFOV(30)
		mdl:SetCamPos(Vector(50, 50, 50))
		mdl:SetLookAt(Vector(9, 9, 9))
		
		if(!buyable) then mask:Disable() end

		mask.DoClick = function()
			if(!buyable && reason) then Eris:Notify("Cannot Purchase: "..reason) return end

			RunConsoleCommand("darkrp", "buyfood", v.name)
		end
	end
end

vgui.Register("ErisF4Food", PANEL, "DScrollPanel")