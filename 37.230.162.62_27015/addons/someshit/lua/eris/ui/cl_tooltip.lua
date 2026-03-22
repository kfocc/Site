surface.CreateFont("ErisF4TooltipBody", {font = "Roboto", size = util.ScreenScale(18)})

/*---------------------------------------------------------------------------
	Model panel for the avatar
---------------------------------------------------------------------------*/
local TOOLTIP = {}
AccessorFunc(TOOLTIP, "removePanel", "RemovePanel")

function TOOLTIP:Init()
	self:SetVisible(false)
	self:SetDrawOnTop(true)
	self.AnimSpeed = 15

	-- local scroll = self:GetChild(0)
	-- scroll:Dock(NODOCK)
	-- scroll:Hide()
end


/*---------------------------------------------------------------------------
	Position it in relative to another panel
---------------------------------------------------------------------------*/
function TOOLTIP:Position(pnl)
	pnl.Think = function(s)
		if(!IsValid(self)) then return end

		local x, y = s:LocalToScreen(0, 0)
		self:SetPos(x+s:GetWide()/2-self:GetWide()/2, y+s:GetTall()+2)

		local hovered = s:IsHovered() || s:IsChildHovered()

		if(hovered && !self:IsVisible()) then
			self:Show()
		elseif(!hovered && self:IsVisible()) then
			self:Hide()
		end
	end
end

/*---------------------------------------------------------------------------
	Getting and setting the text
---------------------------------------------------------------------------*/
function TOOLTIP:GetTooltipText()
	return self.TooltipText
end

function TOOLTIP:SetTooltipText(str)
	self.TooltipText = str

	local col = Eris:Theme("tooltiptext")

	self:SetText("")
	self:InsertColorChange(col.r, col.g, col.b, col.a)
	self:AppendText(str)
end

function TOOLTIP:GetFullHeight()
	return self:GetNumLines()*(draw.GetFontHeight("ErisF4TooltipBody")*1.1)
end


/*---------------------------------------------------------------------------
	Showing and hiding
---------------------------------------------------------------------------*/
function TOOLTIP:Show()
	self:SetVisible(true)
	if(self.Anim && self.Anim:Active()) then self.Anim:Stop() end

	self.AnimSmooth = 0
	self.Anim = Derma_Anim("ErisF4TooltipHide", self, function(pnl)
		pnl.AnimSmooth = Lerp(FrameTime()*self.AnimSpeed, self.AnimSmooth, self:GetFullHeight())
		pnl:SetTall(pnl.AnimSmooth)

		if(math.floor(pnl.AnimSmooth) <= 0) then pnl:Remove() end
	end)

	self.Anim:Start(2)
end

function TOOLTIP:Hide()
	if(self.Anim && self.Anim:Active()) then self.Anim:Stop() end

	self.AnimSmooth = self:GetTall()
	self.Anim = Derma_Anim("ErisF4TooltipHide", self, function(pnl)
		pnl.AnimSmooth = Lerp(FrameTime()*self.AnimSpeed, self.AnimSmooth, 0)
		pnl:SetTall(pnl.AnimSmooth)

		if(math.floor(pnl.AnimSmooth) <= 0) then pnl:SetVisible(false) end
	end)

	self.Anim:Start(2)
end


/*---------------------------------------------------------------------------
	Animating
---------------------------------------------------------------------------*/
function TOOLTIP:Think()
	if(!IsValid(self:GetRemovePanel()) || self:GetRemovePanel().Closing) then self:Remove() end
	if(self.Anim && self.Anim:Active()) then self.Anim:Run() end
end


/*---------------------------------------------------------------------------
	Painting
---------------------------------------------------------------------------*/
function TOOLTIP:Paint(w, h)
	draw.RoundedBox(2,0,0,w,h,Eris:Theme("tooltip"..(self.Disabled&&"disabled"||"")))
end


/*---------------------------------------------------------------------------
	Font
---------------------------------------------------------------------------*/
function TOOLTIP:PerformLayout()
	self.m_FontName = "ErisF4TooltipBody"
	self:SetFontInternal("ErisF4TooltipBody")
	self:SetBGColor(Color(0,0,0,0))
end

function TOOLTIP:Enable()
	self.Disabled = false
end

function TOOLTIP:Disable()
	self.Disabled = true
end


/*---------------------------------------------------------------------------
	Registering the panel
---------------------------------------------------------------------------*/
vgui.Register("ErisF4Tooltip", TOOLTIP, "RichText")