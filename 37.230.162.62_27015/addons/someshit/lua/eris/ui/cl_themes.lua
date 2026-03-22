local PANEL = {}

surface.CreateFont("ErisF4Theme", {font = "Roboto", size = ScreenScale(30), weight = 100})
surface.CreateFont("ErisF4ThemeSmall", {font = "Roboto", size = ScreenScale(6)})

function PANEL:Setup()
	self.Header = vgui.Create("ErisF4CategoryHeader", self)
	self.Header:Dock(TOP)
	self.Header:DockMargin(0,0,0,ScreenScale(5))
	self.Header:SetCategory({name = Eris:Lang("themes"), color = Eris:Theme("accent")})
	self.Header.Header.DoClick = function() end

	self.Scroll = vgui.Create("DScrollPanel", self)
	self.Scroll:Dock(FILL)
	self.Scroll:InvalidateParent(true)
	self.Scroll:ErisScrollbar()

	self.Layout = vgui.Create("DIconLayout", self.Scroll)
	self.Layout:Dock(FILL)
	self.Layout:SetSpaceX(10)
	self.Layout:SetSpaceY(10)

	for k, v in pairs(Eris.Themes) do
		local pnl = self.Layout:Add("DButton", self)
		pnl:SetText("")
		pnl:SetSize(self.Scroll:GetWide()/3-7, self.Scroll:GetTall()/3)
		pnl.Paint = function(s, w, h)
			local sb = w/5
			local name = h/10
			local info = name*2
			local switch = name*0.8
			local tab = math.floor(name)

			draw.RoundedBox(6,0,0,w,h,v.background) //background

			surface.SetDrawColor(v.accent) //scrollbar
			surface.DrawRect(w-12, h/4, 4, h/2)

			local conw = w-sb //models
			local rad = h/4
			local cx, cy = sb+conw/2, h/2
			surface.SetDrawColor(v.accent)
			Eris:DrawCircle(cx, cy, rad)

			surface.SetDrawColor(v.slots)
			surface.DrawRect(cx-rad-1, cy+rad+10, rad, 4)
			surface.DrawRect(cx+1, cy+rad+10, rad, 4)

			draw.RoundedBoxEx(6,0,0,sb,h,v.sidebar,true,false,true) //sidebar

			local y = 0
			draw.RoundedBoxEx(6,0,y,sb,name,v.accent,true) //name
			y = y + name

			surface.SetDrawColor(v.sidebarinfo) //info
			surface.DrawRect(0, y, sb, info)
			y = y + info/2

			surface.SetDrawColor(v.accent) //avatar
			Eris:DrawCircle(sb/3.5, y, info/3)

			draw.SimpleText("$$", "ErisF4ThemeSmall", sb*0.6, y, v.money, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) //money

			y = y + info/2

			surface.SetDrawColor(ColorAlpha(v.accent, 30)) //sidebar switches
			surface.DrawRect(0, y, sb, switch)
			surface.SetDrawColor(v.sidebarswitchtext)

			surface.DrawRect(sb/2-6, y+switch/2-2, 12, 4)

			y = y + switch

			for i=0,3 do //tabs
				local pos = 4+y+tab*i
				local height = tab-2

				surface.SetDrawColor(v.tabs)
				surface.DrawRect(4, pos, sb-8, height)

				surface.SetDrawColor(v.accent)
				surface.DrawRect(4, pos, 2, height)

				surface.SetDrawColor(v.tabtext)
				surface.DrawRect(12, pos+height/2-2, 12, 4)
			end
		end
		pnl.DoClick = function()
			if(v.allowed && !v.allowed[LocalPlayer():GetUserGroup()]) then
				Eris:Notify(Eris:Lang("cannot_change_theme"))
				return
			end
			Eris:SetTheme(k)
		end
		pnl:ErisClickyEffect()

		pnl.Alpha = 0
		local old = pnl.PaintOver
		pnl.PaintOver = function(s, w, h)
			old(s, w, h)
			s.Alpha = Lerp(FrameTime()*8, s.Alpha, s:IsHovered()&&1||0)

			if(s.Alpha > 0.01) then
				Eris:DrawBlur(s, s.Alpha*6)
				surface.SetDrawColor(0, 0, 0, s.Alpha*150)
				surface.DrawRect(0, 0, w, h)

				local hover = Lerp(s.Alpha, h, h/2)
				draw.SimpleText(k:sub(1,1):upper()..k:sub(2):lower(), "ErisF4Theme", w/2, hover, Color(255, 255, 255, s.Alpha*255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end

vgui.Register("ErisF4Themes", PANEL, "Panel")