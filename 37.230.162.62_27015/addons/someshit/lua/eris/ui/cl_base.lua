/*---------------------------------------------------------------------------
	Fonts
---------------------------------------------------------------------------*/
surface.CreateFont("ErisF4HostName", {font = "Roboto", size = 24, weight = 100})
surface.CreateFont("ErisF4Entry", {font = "Roboto", size = ScreenScaleH(6), weight = 100})
surface.CreateFont("ErisF4EntryCount", {font = "Roboto", size = ScreenScaleH(5), weight = 100})
surface.CreateFont("ErisF4Category", {font = "Roboto", size = 36, weight = 100})

surface.CreateFont("ErisF4Name", {font = "Roboto", size = 32, weight = 100})
surface.CreateFont("ErisF4Money", {font = "Roboto", size = ScreenScaleH(10), weight = 100})
surface.CreateFont("ErisF4SidebarSections", {font = "Roboto", size = 28, weight = 100})


/*---------------------------------------------------------------------------
	Base panel for the F4
---------------------------------------------------------------------------*/
local animSpeed = 15
local tab = 1
local info = false

local PANEL = {}

function PANEL:Init()
  info = false
	/*---------------------------------------------------------------------------
		Positioning
	---------------------------------------------------------------------------*/
	local ph = 0.8
	if(!Eris.Config.ModelEnabled) then ph = 0.7 end
	self:SetSize(ScrW()*0.6, ScrH()*ph)
	self:Center()

	self:MakePopup()

	self:SetKeyboardInputEnabled()


	/*---------------------------------------------------------------------------
		Animating
	---------------------------------------------------------------------------*/
	self.AnimSmooth = 0
	self.Anim = Derma_Anim("ErisF4Open", self, function(pnl)
		pnl.AnimSmooth = Lerp(FrameTime()*animSpeed, pnl.AnimSmooth, ScrH()*ph)
		pnl:SetTall(pnl.AnimSmooth)
		pnl:Center()
	end)
	self.Anim:Start(2)


	/*---------------------------------------------------------------------------
		Upper portion containing the LocalPlayer's model
	---------------------------------------------------------------------------*/
	if(Eris.Config.ModelEnabled) then
		self.TitleBar = vgui.Create("DPanel", self)
		self.TitleBar:Dock(TOP)
		self.TitleBar:InvalidateParent(true)
		self.TitleBar:SetTall(self:GetTall()/6)
		self.TitleBar.Paint = function(s, w, h)
			local l = w/6
			local poly = {
				{x = w/2-l/2, y = h/2},
				{x = w/2+l/2, y = h/2},
				{x = w/2+l, y = h},
				{x = w/2-l, y = h}
			}
			surface.SetDrawColor(Eris:Theme("background"))
			draw.NoTexture()
			surface.DrawPoly(poly)
		end


		/*---------------------------------------------------------------------------
			Model
		---------------------------------------------------------------------------*/
		self.Model = vgui.Create("ErisF4ModelMask", self.TitleBar)
		self.Model:SetTall(self.TitleBar:GetTall())
		self.Model:SetWide(self.Model:GetTall())
		self.Model:Center()

		self.Model:Setup(LocalPlayer():GetModel())
		self.Model:GetEntity():SetSkin(LocalPlayer():GetSkin())
		for k, v in pairs(LocalPlayer():GetBodyGroups()) do
			self.Model:GetEntity():SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
		end
		self.Model:SetHoverColor(team.GetColor(LocalPlayer():Team()))

		self.Model.DoClick = function(s)
			self:CloseAnim()
		end

		self.Model.DoRightClick = function(s)
			self:OpenDashboard()
		end
	end



	/*---------------------------------------------------------------------------
		Main container
	---------------------------------------------------------------------------*/
	self.Container = vgui.Create("DPanel", self)
	self.Container:Dock(FILL)
	self.Container:InvalidateParent(true)
	self.Container.Paint = function(s, w, h)
		if(Eris:Theme("blur")) then Eris:DrawBlur(s) end
		draw.RoundedBox(8,0,0,w,h,Eris:Theme("background"))
	end


	/*---------------------------------------------------------------------------
		Sidebar, used for tabs
	---------------------------------------------------------------------------*/
	self.Sidebar = vgui.Create("DPanel", self.Container)
	self.Sidebar:Dock(LEFT)
	self.Sidebar:InvalidateParent(true)
	self.Sidebar:SetWide(self.Container:GetWide()/5)
	self.Sidebar.Paint = function(s, w, h)
		draw.RoundedBoxEx(8,0,0,w,h,Eris:Theme("sidebar"),true,false,true)
	end

	self.Name = self.Sidebar:Add("DButton")
	self.Name:Dock(TOP)
	self.Name:SetHeight(42)
	self.Name:SetText("")
	self.Name.Paint = function(s, w, h)
		draw.RoundedBoxEx(6,0,0,w,h,ColorAlpha(Eris:Theme("accent"), 30),true)
		draw.SimpleText(LocalPlayer():Name(), "ErisF4Name", w/2, h/2, Eris:Theme("accent"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.Name.DoClick = function(s)
		if(Eris.Config.AllowNameChange) then
			Eris:StringRequest(Eris:Lang("name_change"), Eris:Lang("name_change_text"), LocalPlayer():Name(), function(str)
				RunConsoleCommand("darkrp", "rpname", str)
			end, Eris:Lang("change_name"))
		else
			LocalPlayer():ShowProfile()
		end
	end

	self.Name:ErisHoverEffect(Eris:Theme("accent"), function(s, w, h, a)
		draw.RoundedBoxEx(6,0,0,w,h,ColorAlpha(Eris:Theme("accent"), a),true)
	end)
	self.Name:ErisClickyEffect()

	self.Info = self.Sidebar:Add("DPanel")
	self.Info:Dock(TOP)
	self.Info:SetTall(64)
	self.Info.Paint = function(s, w, h)
		surface.SetDrawColor(Eris:Theme("sidebarinfo"))
		surface.DrawRect(0, 0, w, h)
	end

	self.Avatar = vgui.Create("ErisF4Avatar", self.Info)
	self.Avatar:Dock(LEFT)
	self.Avatar:DockMargin(6, 6, 6, 6)
	self.Avatar:InvalidateParent(true)
	self.Avatar:SetWide(self.Avatar:GetTall())
	self.Avatar:SetPlayer(LocalPlayer(), 64)

	self.Money = vgui.Create("DLabel", self.Info)
	self.Money:Dock(FILL)
	self.Money:DockMargin(4, 0, 0, 0)
	self.Money:SetFont("ErisF4Money")
	self.Money:SetTextColor(Eris:Theme("money"))
	self.Money:SetContentAlignment(4)
	self.Money:SetText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")))

	self.SidebarSections = self.Sidebar:Add("DPanel")
	self.SidebarSections:Dock(TOP)
	self.SidebarSections:InvalidateParent(true)
	self.SidebarSections:SetTall(36)
	self.SidebarSections.Paint = function(s, w, h)
		surface.SetDrawColor(Eris:Theme("sidebarswitch"))
		surface.DrawRect(0, 0, w, h)
	end

	for k, v in pairs({["game"]=false, ["info"]=true}) do
		local but = vgui.Create("DButton", self.SidebarSections)
		but:Dock(v&&RIGHT||LEFT)
		but:SetSize(self.SidebarSections:GetWide()/2)
		but.Paint = nil
		but:SetText("")
		but.DoClick = function(s) info = v self:BuildSidebar(v) end

		but.DepressedAlpha = 0
		but.PaintOver = function(s, w, h)
			local col = Eris:Theme("sidebarswitchtext")
			local accent = Eris:Theme("accent")

			s.DepressedAlpha = Lerp(FrameTime()*6, s.DepressedAlpha, info==v&&1||0)

			surface.SetDrawColor(ColorAlpha(accent, s.DepressedAlpha*30))
			surface.DrawRect(0, 0, w, h)

			s.Color = Color(
				Lerp(s.DepressedAlpha, col.r, accent.r),
				Lerp(s.DepressedAlpha, col.g, accent.g),
				Lerp(s.DepressedAlpha, col.b, accent.b)
			)

			draw.SimpleText(Eris:Lang(k), "ErisF4SidebarSections", w/2, h/2, s.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		but:ErisHoverEffect()
		but:ErisClickyEffect()
	end

	self.SidebarButtons = self.Sidebar:Add("DPanel")
	self.SidebarButtons:Dock(FILL)
	self.SidebarButtons:DockPadding(5,5,5,5)
	self.SidebarButtons.Paint = nil


	/*---------------------------------------------------------------------------
		Title bar
	---------------------------------------------------------------------------*/
	if(Eris.Config.TitleBarEnabled) then
		self.Title = vgui.Create("DPanel", self.Container)
		self.Title:Dock(TOP)
		self.Title:SetTall(42)
		self.Title:InvalidateParent(true)
		self.Title.Paint = function(s, w, h)
			draw.RoundedBoxEx(6,0,0,w,h,Eris:Theme("sidebar"),false,true)

			local x = s:GetPos()
			x = x - s:GetParent():GetWide()/2

			draw.SimpleText(s.Text, "ErisF4Name", -x, h/2, Eris:Theme("sidebarswitchtext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if(Eris.Config.CloseButtonEnabled) then
			self.CloseBut = vgui.Create("DButton", self.Title)
			self.CloseBut:Dock(RIGHT)
			self.CloseBut:DockMargin(4,4,4,4)
			self.CloseBut:InvalidateParent(true)
			self.CloseBut:SetWide(self.CloseBut:GetTall())
			self.CloseBut:SetText("")

			self.CloseBut.Alpha = 0
			self.CloseBut.Paint = function(s, w, h)
				if !Eris.Icons then return end

				s.Alpha = Lerp(FrameTime()*12, s.Alpha, s:IsHovered() && 1 || 0)
				surface.SetDrawColor(Eris:Theme("close"))
				Eris:DrawCircle(w/2, h/2, w/2)

				surface.SetDrawColor(Eris:Theme("closeicon"))
				surface.SetMaterial(Eris.Icons.close)
				surface.DrawTexturedRect(w/2-16, h/2-16, 32, 32)

				surface.SetDrawColor(255, 255, 255, s.Alpha*30)
				Eris:DrawCircle(w/2, h/2, w/2)
			end
			self.CloseBut.DoClick = function() self:CloseAnim() end
		end
	end

	self:BuildSidebar(info)
	self:Select(tab)


	/*---------------------------------------------------------------------------
		Server panel
	---------------------------------------------------------------------------*/
	-- self.Server = vgui.Create("DPanel", self)
	-- self.Server:Dock(BOTTOM)
	-- self.Server:SetTall(36)
	-- self.Server.Paint = function(s, w, h)
	-- 	local text = Eris.Config.ServerText == "" && GetHostName() || Eris.Config.ServerText
	-- 	surface.SetFont("ErisF4HostName")
	-- 	local tw, th = surface.GetTextSize(text)

	-- 	draw.RoundedBoxEx(6,w/2-tw/2-6,0,tw+12,h,Eris:Theme("server"),false,false,true,true)
	-- 	draw.SimpleText(text, "ErisF4HostName", w/2, h/2, Eris:Theme("servertext"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- end
end


/*---------------------------------------------------------------------------
	Building the sidebar
---------------------------------------------------------------------------*/
function PANEL:BuildSidebar(info)
	self.SidebarButtons:Clear()
	self.Tabs = {}

	for k, v in pairs(Eris.Tabs) do
		if(v.canSee && !v.canSee()) then continue end

		if(info) then
			if(!v.info) then continue end
		else
			if(v.info) then continue end
		end

		if(v.divider) then
			local div = self.SidebarButtons:Add("DPanel")
			div:Dock(TOP)
			div:DockMargin(0, 1, 0, 3)
			div:SetTall(1)
			div.Paint = function(s, w, h)
				surface.SetDrawColor(ColorAlpha(Eris:Theme("accent"), 100))
				surface.DrawRect(w/6, 0, w/1.5, h)
			end

			continue
		end

		local num = #self.Tabs+1

		local but = self.SidebarButtons:Add("ErisF4SidebarButton")
		but:Dock(TOP)
		but:DockMargin(0, 0, 0, 2)
		but:SetDisplayText(v.name)
		but:SetIconName(v.icon)
		but:SetSquareTabs(Eris.Config.SquareTabs)

		but.DoClick = function(s)
			if(s:GetDepressed()) then return end

			self:LiftTabs()
			s:SetDepressed(true)
			self:SetTitleText(v.name)

			if(Eris.Config.SaveTab and not v.info) then
				tab = num
			end

			if(v.website) then
				-- self:OpenWebsite(v.website)
				gui.OpenURL(v.website)
				return
			end

			if v.cmd then
				LocalPlayer():ConCommand(v.cmd)
				return
			end

			if v.chat then
				RunConsoleCommand("say", v.chat)
				return
			end

			if(v.func) then v.func(self) return end

			self:SetActivePanel(v.panel)
		end

		table.insert(self.Tabs, but)
	end
end


/*---------------------------------------------------------------------------
	Select a tab
---------------------------------------------------------------------------*/
function PANEL:Select(num)
	local t = self.Tabs[math.min(#self.Tabs, num)]
	if(t) then
		t:DoClick()
	end
end


/*---------------------------------------------------------------------------
	Working with the active panel
---------------------------------------------------------------------------*/
function PANEL:ClearActivePanel()
	if(IsValid(self.ActivePanel)) then self.ActivePanel:Remove() end
end

function PANEL:SetActivePanel(name)
	if(!name) then return end

	self:ClearActivePanel()
	self.ActivePanel = vgui.Create(name, self.Container)
	self.ActivePanel:Dock(FILL)
	self.ActivePanel:DockMargin(15, 15, 15, 15)
	self.ActivePanel:InvalidateParent(true)
	self.ActivePanel:Setup()

	return self.ActivePanel
end


/*---------------------------------------------------------------------------
	Un-depress all tabs
---------------------------------------------------------------------------*/
function PANEL:LiftTabs()
	for k, v in pairs(self.Tabs) do v:SetDepressed(false) end
end


/*---------------------------------------------------------------------------
	Open the dashboard
---------------------------------------------------------------------------*/
function PANEL:OpenDashboard()
	self:SetTitleText(Eris:Lang("dashboard"))
	self:LiftTabs()
	self:SetActivePanel("ErisF4Dashboard")
end


/*---------------------------------------------------------------------------
	Open a URL in the browser
---------------------------------------------------------------------------*/
function PANEL:OpenWebsite(site)
	self:SetTitleText(site)
	self:SetActivePanel("ErisF4WebBrowser"):OpenWebsite(site)
end

function PANEL:SetTitleText(str)
	if(Eris.Config.TitleBarEnabled) then
		self.Title.Text = str
	end
end


/*---------------------------------------------------------------------------
	Close the panel
---------------------------------------------------------------------------*/
function PANEL:CloseAnim()
	self.Closing = true
	self:SetMouseInputEnabled(false)

	if(self.Anim:Active()) then
		self.Anim:Stop()
	end
	self.AnimSmooth = self:GetTall()
	self.Anim = Derma_Anim("ErisF4Close", self, function(pnl)
		pnl.AnimSmooth = Lerp(FrameTime()*animSpeed, self.AnimSmooth, 0)
		pnl:SetTall(pnl.AnimSmooth)
		pnl:Center()
		if(math.floor(pnl.AnimSmooth) <= 0) then pnl:Remove() end
	end)
	self.Anim:Start(2)
end


/*---------------------------------------------------------------------------
	Animation logic
---------------------------------------------------------------------------*/
function PANEL:Think()
	if(self.Anim:Active()) then self.Anim:Run() end
end


/*---------------------------------------------------------------------------
	No painting here
---------------------------------------------------------------------------*/
function PANEL:Paint(w, h) end


/*---------------------------------------------------------------------------
	Allowing the menu to be closed again with F4
---------------------------------------------------------------------------*/
function PANEL:OnKeyCodePressed(code)
	if(code == KEY_F4) then
		DarkRP.toggleF4Menu()
	end
end


/*---------------------------------------------------------------------------
	Registering the panel
---------------------------------------------------------------------------*/
vgui.Register("ErisF4", PANEL, "Panel")