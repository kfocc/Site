local PANEL = {}

function PANEL:Setup()
	self.HTML = vgui.Create("DHTML", self)
	self.HTML:Dock(FILL)
end

local size = 10
function PANEL:Paint(w, h)
	local frac = (math.cos(CurTime()*5)+1)/2
	local op = math.abs(frac-1)

	local x, y
	if(Eris.Config.CenterPreloader) then
		x, y = self:GetPos()
		x = x - self:GetParent():GetWide()/2
		y = y - self:GetParent():GetTall()/2
	else
		x = -w/2
		y = -h/2
	end

	surface.SetDrawColor(Eris:Theme("accent"))
	Eris:DrawCircle(-x-size*2+op*10, -y, size*frac+5)
	Eris:DrawCircle(-x+size*2-frac*10, -y, size*op+5)
end

function PANEL:OpenWebsite(site)
	self.HTML:OpenURL(site || "https://www.google.com")
end

vgui.Register("ErisF4WebBrowser", PANEL, "Panel")