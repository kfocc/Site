local PANEL = {}

function PANEL:Init()
	self:ErisScrollbar()
end

function PANEL:Setup()
	/*---------------------------------------------------------------------------
		Getting and sorting the categories
	---------------------------------------------------------------------------*/
	local cats = table.Copy(DarkRP.getCategories().jobs)
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
			local joinable, visible = hook.Call("CanSwitchJob", Eris, v)
			if(!joinable && !visible) then bad = bad + 1 end
		end
		if(bad >= count) then continue end


		/*---------------------------------------------------------------------------
			The category's header
		---------------------------------------------------------------------------*/
		local header = self:Add("ErisF4CategoryHeader")
		header:Dock(TOP)
		header:SetCategory(cat)


		/*---------------------------------------------------------------------------
			Container for the jobs
		---------------------------------------------------------------------------*/
		local container = self:Add("DIconLayout")
		container:Dock(TOP)
		container:DockMargin(0, 12, 0, 25)
		header:SetContents(container)


		/*---------------------------------------------------------------------------
			Looping through
		---------------------------------------------------------------------------*/
		for _, v in pairs(cat.members) do
			local joinable, visible, reason = hook.Call("CanSwitchJob", Eris, v)
			if(!joinable && !visible) then continue end

			local pnl = container:Add("DPanel")
			pnl:SetSize(self:GetWide()/6, self:GetTall()/6)
			pnl.Paint = nil

			local tooltip = vgui.Create("ErisF4Tooltip")
			tooltip:SetWide(self:GetWide()/5)
			tooltip:SetTooltipText(joinable && v.description || reason)
			tooltip:SetRemovePanel(self:GetParent():GetParent())

			tooltip:Position(pnl)
			if(!joinable) then tooltip:Disable() end

			local count = vgui.Create("DPanel", pnl)
			count:Dock(BOTTOM)
			count:SetTall(6)
			count:DockMargin(6, 0, 6, 0)
			count.Paint = function(s, w, h)
				local count = team.NumPlayers(v.team)
				local max = v.max && math.max(v.max, 0) || 0
				if(max < 1) then return end

				local colFull = v.color
				local colEmpty = Eris:Theme("slots")

				local seg = w/max
				for i = 1, max do
					local sx, sy, sw, sh = seg*(i-1)+1, 1, seg-2, h
					local clr = i <= count && colFull || colEmpty
					draw.RoundedBox(2, sx, sy, sw, sh, clr)
				end
			end

			local name = vgui.Create("DLabel", pnl)
			name:Dock(BOTTOM)
			name:SetText(v.name .. (v.vip && " | VIP" || ""))
			name:SetFont("ErisF4Entry")
			name:SetTextColor(Eris:Theme("itemname"))
			name:SetContentAlignment(5)

			local mask = vgui.Create("ErisF4ModelMask", pnl)
			mask:Dock(FILL)
			mask:SetHoverColor(Eris.Config.UnifyJobBackdrops && Eris:Theme("itemhover") || v.color)

			if(istable(v.model)) then mask.modelKey = 1 end
			mask:Setup(istable(v.model) && v.model[mask.modelKey] || v.model)

			if(!joinable) then mask:Disable() else mask:SetHoverText(DarkRP.formatMoney(v.salary)) end

			mask.DoClick = function()
				if(!joinable && reason) then Eris:Notify("Cannot Switch: "..reason) return end

				DarkRP.setPreferredJobModel(v.team, mask.Model:GetModel())
				RunConsoleCommand("darkrp", (v.vote&&"vote"||"")..v.command)
				DarkRP.closeF4Menu()
			end

			mask.DoRightClick = function()
				if(!istable(v.model)) then return end
				local model = v.model[mask.modelKey + 1]
				if(model) then mask:Setup(model) mask.modelKey = mask.modelKey + 1 else
					mask.modelKey = 1
					mask:Setup(v.model[1])
				end

				surface.PlaySound("buttons/button9.wav")
			end
		end
	end
end

vgui.Register("ErisF4Jobs", PANEL, "DScrollPanel")