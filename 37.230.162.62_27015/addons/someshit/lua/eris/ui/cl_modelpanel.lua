/*---------------------------------------------------------------------------
	Model panel for the avatar
---------------------------------------------------------------------------*/
local MODEL = {}
AccessorFunc(MODEL, "hoverColor", "HoverColor")
AccessorFunc(MODEL, "hoverText", "HoverText", FORCE_STRING)

function MODEL:Init()
	self.Model = vgui.Create("DModelPanel", self)
	self.Model.LayoutEntity = function() end

	self.Model.OnMousePressed = function(s, code)
		if(self:IsHovered()) then
			if(code == MOUSE_LEFT && self.DoClick) then self:DoClick() end
			if(code == MOUSE_RIGHT && self.DoRightClick) then self:DoRightClick() end
			if(code == MOUSE_MIDDLE && self.DoMiddleClick) then self:DoMiddleClick() end
		end
	end

	self.Alpha = 0
end


/*---------------------------------------------------------------------------
	Set the panel up with a model
---------------------------------------------------------------------------*/
function MODEL:Setup(model, size)
	local mdl = self:GetModelPanel()
	mdl:SetModel(model)

	if(size) then
		local mn, mx = mdl.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

		mdl:SetFOV(45)
		mdl:SetCamPos(Vector(size, size, size))
		mdl:SetLookAt((mn+mx)/2)
	else
		if not IsValid(mdl.Entity) then return end
		local bone = mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
		if(!bone) then return end
		local eyepos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 2)
		mdl:SetLookAt(eyepos)
		mdl:SetCamPos(eyepos + Vector(select(2, mdl.Entity:GetRenderBounds()).x, 0, 0))
		mdl.Entity:SetEyeTarget(mdl:GetCamPos())
	end
end

function MODEL:GetModelPanel()
	return self.Model	
end

function MODEL:GetEntity()
	return self:GetModelPanel().Entity
end


/*---------------------------------------------------------------------------
	Distance calculation for proper circle hovering
---------------------------------------------------------------------------*/
function MODEL:IsHovered()
	local w, h = self:GetSize()
	local x, y = self:CursorPos()

	if(x<0 || y<0 || x>w || y>h) then return false end
	return (x-w/2)^2 + (y-h/2)^2 < (w/2)^2
end

function MODEL:PerformLayout()
	self.Model:SetSize(self:GetWide(), self:GetTall())
end


/*---------------------------------------------------------------------------
	Backdrop on hover
---------------------------------------------------------------------------*/
surface.CreateFont("ErisF4ModelText", {font = "Coolvetica", size = ScreenScale(12)})
function MODEL:Paint(w, h)
	local x, y = self:CursorPos()

	self.Alpha = Lerp(FrameTime()*10, self.Alpha, self:IsHovered() && 1 || 0)

	if(self.Alpha >= 0.01) then
		local tw = w/2*self.Alpha

		if(!self.Disabled) then
			surface.SetDrawColor(ColorAlpha(self:GetHoverColor(), self.Alpha*50))
			Eris:DrawCircle(w/2, h/2, tw)
		end

		local txt = self:GetHoverText()
		if(txt && txt != "") then
			draw.SimpleText(txt, "ErisF4ModelText", w/2-tw*0.9, h/2, ColorAlpha(self:GetHoverColor(), self.Alpha*100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end


/*---------------------------------------------------------------------------
	Enabling/Disabling
---------------------------------------------------------------------------*/
function MODEL:Enable()
	self.Disabled = false
end

function MODEL:Disable()
	self.Disabled = true
end

surface.CreateFont("ErisF4ModelDisabled", {font = "Open Sans", size = ScreenScale(30)})
function MODEL:PaintOver(w, h)
	if(!self.Disabled) then return end

	local alpha = self.Alpha*200
	surface.SetDrawColor(ColorAlpha(Eris:Theme("modeldisabled"), alpha))
	Eris:DrawCircle(w/2, h/2, w/2*self.Alpha)
	draw.SimpleText("×", "ErisF4ModelDisabled", w/2, h/2, ColorAlpha(Eris:Theme("modeldisabledtext"), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end


/*---------------------------------------------------------------------------
	Painting the backdrop over the panel vs behind it selectively
---------------------------------------------------------------------------*/
function MODEL:SetPaintedOver()
	local paint = self.Paint
	local paintOver = self.PaintOver

	self.Paint = nil
	self.PaintOver = function(s, w, h)
		paint(s, w, h)
		paintOver(s, w, h)
	end
end

vgui.Register("ErisF4ModelMask", MODEL)