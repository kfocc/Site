local PANEL = {}

surface.CreateFont("ErisF4DashboardCardTitle", {font = "Roboto", size = 16})
surface.CreateFont("ErisF4DashboardCardMain", {font = "Roboto", size = ScreenScaleH(17), weight = 100})
surface.CreateFont("ErisF4PieTitle", {font = "Roboto", size = ScreenScaleH(10), weight = 100})
surface.CreateFont("ErisF4PieMain", {font = "Roboto", size = ScreenScaleH(15)})

local function drawArc(x, y, ang, seg, p, rad, color)
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {x = x, y = y})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
	end

	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circle)
end

local function text(x, y, title, main)
	surface.SetFont("ErisF4PieTitle")
	local tw, th = surface.GetTextSize(title)

	surface.SetFont("ErisF4PieMain")
	local mw, mh = surface.GetTextSize(main)

	draw.SimpleText(title, "ErisF4PieTitle", x, y-mh/3-3, Eris:Theme("pietext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(main, "ErisF4PieMain", x, y+th/3+3, Eris:Theme("pietext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local glowMat = Material("particle/Particle_Glow_04_Additive")
local function graph(x, y, rad, title, main, func)
	surface.SetDrawColor(Eris:Theme("pie"))
	Eris:DrawCircle(x, y, rad)

	func(x, y, rad)

	if(Eris.Config.PieGlow) then
		surface.SetDrawColor(Eris:Theme("pieglow"))
		surface.SetMaterial(glowMat)
		surface.DrawTexturedRect(x-rad, y-rad, rad*2, rad*2)
	end

	surface.SetDrawColor(Eris:Theme("pieoverlay"))
	Eris:DrawCircle(x, y, rad*0.8)

	if(main) then
		text(x, y, title, main)
	else
		draw.SimpleText(title, "ErisF4PieTitle", x, y, Eris:Theme("pietext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Setup()
	self.StatContainer = vgui.Create("DPanel", self)
	self.StatContainer:Dock(TOP)
	self.StatContainer:DockMargin(0, 0, 0, ScreenScale(15))
	self.StatContainer:SetTall(self:GetTall()/2)
	self.StatContainer:InvalidateParent(true)
	self.StatContainer.Paint = nil

	self.StatHeader = vgui.Create("ErisF4CategoryHeader", self.StatContainer)
	self.StatHeader:Dock(TOP)
	self.StatHeader:DockMargin(0,0,0,ScreenScale(5))
	self.StatHeader:SetCategory({name = Eris:Lang("stats"), color = Eris:Theme("accent")})
	self.StatHeader.Header.DoClick = function() end

	local countSmooth = 0
	local moneySmooth = 0
	local jobSmooth = 0

	self.Stats = vgui.Create("DPanel", self.StatContainer)
	self.Stats:Dock(FILL)
	self.Stats:InvalidateParent(true)
	self.Stats.Paint = nil

	self.Players = vgui.Create("DPanel", self.Stats)
	self.Players:Dock(LEFT)
	self.Players:SetWide(self.Stats:GetWide()/3)
	self.Players.Paint = function(s, w, h)
		local min = math.min(w, h)

		local count = player.GetCount()
		local max = game.MaxPlayers()

		graph(w/2, h/2, min/2, Eris:Lang("players_online"), count.."/"..max, function(x, y, rad)
			countSmooth = Lerp(FrameTime()*8, countSmooth, count)
			drawArc(x, y, 0, 360, countSmooth/max*360, rad, Eris:Theme("accent"))
		end)
	end

	self.Money = vgui.Create("DPanel", self.Stats)
	self.Money:Dock(LEFT)
	self.Money:SetWide(self.Stats:GetWide()/3)
	self.Money.Paint = function(s, w, h)
		local min = math.min(w, h)

		local money = 0
		for k, v in player.Iterator() do
			money = money + (v:getDarkRPVar("money") || 0)
		end

		graph(w/2, h/2, min/2, Eris:Lang("money"), DarkRP.formatMoney(money), function(x, y, rad)
			moneySmooth = Lerp(FrameTime()*8, moneySmooth, 360)
			drawArc(x, y, 0, 360, moneySmooth, rad, Eris:Theme("piemoney"))
		end)
	end

	-- self.Jobs = vgui.Create("DPanel", self.Stats)
	-- self.Jobs:Dock(LEFT)
	-- self.Jobs:SetWide(self.Stats:GetWide()/3)
	-- self.Jobs.Paint = function(s, w, h)
	-- 	local min = math.min(w, h)

	-- 	local max = player.GetCount()
	-- 	local ang = 0

	-- 	local plys = player.GetAll()
	-- 	table.sort(plys, function(a, b) return a:Team() > b:Team() end)

	-- 	graph(w/2, h/2, min/2, Eris:Lang("job_distribution"), nil, function(x, y, rad)
	-- 		jobSmooth = Lerp(FrameTime()*8, jobSmooth, 360/max)

	-- 		local jAnim = FrameTime()*6

	-- 		for k, v in pairs(plys) do
	-- 			local col = team.GetColor(v:Team())
	-- 			v.ErisJobChartColor = v.ErisJobChartColor || col
	-- 			v.ErisJobChartColor = Color(
	-- 				Lerp(jAnim, v.ErisJobChartColor.r, col.r),
	-- 				Lerp(jAnim, v.ErisJobChartColor.g, col.g),
	-- 				Lerp(jAnim, v.ErisJobChartColor.b, col.b)
	-- 			)
	-- 			drawArc(x, y, ang, 360, jobSmooth, rad, v.ErisJobChartColor)
	-- 			ang = ang + jobSmooth
	-- 		end
	-- 	end)
	-- end

	self.StaffContainer = vgui.Create("DPanel", self)
	self.StaffContainer:Dock(LEFT)
	self.StaffContainer:DockMargin(0,0,1,0)
	self.StaffContainer:SetWide(self:GetWide()/3)
	self.StaffContainer:InvalidateParent(true)
	self.StaffContainer.Paint = nil

	self.StaffHeader = vgui.Create("ErisF4CategoryHeader", self.StaffContainer)
	self.StaffHeader:Dock(TOP)
	self.StaffHeader:DockMargin(0,0,0,ScreenScale(5))
	self.StaffHeader:SetCategory({name = Eris:Lang("staff"), color = Eris:Theme("accent")})
	self.StaffHeader.Header.DoClick = function() end

	self.StaffScroll = vgui.Create("DScrollPanel", self.StaffContainer)
	self.StaffScroll:Dock(FILL)
	self.StaffScroll:ErisScrollbar()

	self.Staff = vgui.Create("DIconLayout", self.StaffScroll)
	self.Staff:Dock(FILL)
	self.Staff:SetSpaceX(5)
	self.Staff:SetSpaceY(5)

	surface.SetFont("ErisF4TooltipBody")
	for k, v in player.Iterator() do
		local usergroup = v:GetNetVar("FakeGroup", v:GetUserGroup())
		if(!Eris.Config.StaffRanks[usergroup]) then continue end

		local lbl = self.StaffScroll:Add("DLabel")
		lbl:Dock(TOP)
		lbl:SetFont("ErisF4TooltipBody")
		lbl:SetTextColor(Eris:Theme("accent"))
		lbl:SetText(v:Nick())
		lbl:DockMargin(0, 5, 0, 0)

		lbl:SetTall(draw.GetFontHeight("ErisF4TooltipBody"))
	end

	--[[self.CommandContainer = vgui.Create("DPanel", self)
	self.CommandContainer:Dock(FILL)
	self.CommandContainer:DockMargin(1, 0, 0, 0)
	self.CommandContainer:InvalidateParent(true)
	self.CommandContainer.Paint = nil

	self.CommandHeader = vgui.Create("ErisF4CategoryHeader", self.CommandContainer)
	self.CommandHeader:Dock(TOP)
	self.CommandHeader:DockMargin(0,0,0,ScreenScale(5))
	self.CommandHeader:SetCategory({name = Eris:Lang("commands"), color = Eris:Theme("accent")})
	self.CommandHeader.Header.DoClick = function() end

	self.CommandScroll = vgui.Create("DScrollPanel", self.CommandContainer)
	self.CommandScroll:Dock(FILL)
	self.CommandScroll:ErisScrollbar()

	self.Commands = vgui.Create("DIconLayout", self.CommandScroll)
	self.Commands:Dock(FILL)
	self.Commands:SetSpaceX(5)
	self.Commands:SetSpaceY(5)

	local iconSize = 32
	for k, v in pairs(Eris.Commands) do
		if(v.visible && !v.visible()) then continue end

		local but = self.Commands:Add("DButton")
		but:SetWide(self.CommandContainer:GetWide()/2-self.CommandScroll:GetVBar():GetWide()/2-2)
		but:SetTall(42)
		but:SetText("")
		but.HoverAlpha = 0

		but.DoClick = v.func

		but.Paint = function(s, w, h)
			s.HoverAlpha = Lerp(FrameTime()*8, s.HoverAlpha, s:IsHovered()&&1||0)

			draw.RoundedBox(8, 0, 0, w, h, Eris:Theme("commands"))
			draw.RoundedBox(8, 0, 0, w, h, ColorAlpha(Eris:Theme("accent"), s.HoverAlpha*150))

			local y = h/2-iconSize/2

			surface.SetDrawColor(Eris:Theme("commandtext"))
			surface.SetMaterial(Eris.Icons[v.icon])
			surface.DrawTexturedRect(y, y, iconSize, iconSize)

			draw.SimpleText(v.name, "ErisF4Button", y*2+iconSize, h/2, Eris:Theme("commandtext"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		but:ErisClickyEffect()
	end]]

	if(Eris.Config.ThemesEnabled) then
		self.Themes = vgui.Create("DButton", self)
		self.Themes:SetSize(42, 42)
		self.Themes:SetPos(self:GetWide()-self.Themes:GetWide(), 0)
		self.Themes:SetText("")
		self.Themes.Paint = function(s, w, h)
			if !Eris.Icons then return end

			draw.RoundedBox(6,0,0,w,h,Eris:Theme("commands"))

			surface.SetDrawColor(Eris:Theme("commandtext"))
			surface.SetMaterial(Eris.Icons.themes)
			surface.DrawTexturedRect(w/2-16, h/2-16, 32, 32)
		end
		self.Themes.DoClick = function()
			local m = self:GetParent():GetParent()
			m:SetTitleText(Eris:Lang("themes"))
			m:SetActivePanel("ErisF4Themes")
			self:GetParent():GetParent():SetActivePanel("ErisF4Themes")
		end

		self.Themes:ErisHoverEffect()
	end
end

vgui.Register("ErisF4Dashboard", PANEL, "Panel")