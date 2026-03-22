/*---------------------------------------------------------------------------
	Circle Avatar
---------------------------------------------------------------------------*/
local AVATAR = {}

function AVATAR:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)

    self.Avatar:SetCursor("hand")
    self.Avatar:SetMouseInputEnabled(true)
    self.Avatar.OnMousePressed = function(s, code)
        if(code != MOUSE_LEFT) then return end
        surface.PlaySound("ui/buttonclick.wav")
        self.Player:ShowProfile()
    end
   
    self.Alpha = 0
end

function AVATAR:PerformLayout()
	self.Avatar:SetSize(self:GetSize())
end

function AVATAR:Paint(w, h)
	surface.SetDrawColor(Eris:Theme("accent"))
	Eris:DrawCircle(w/2, h/2, w/2)

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

 	surface.SetDrawColor(255,255,255,255)
    Eris:DrawCircle(w/2, h/2, w/2-1)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

function AVATAR:PaintOver(w, h)
    self.Alpha = Lerp(FrameTime()*8, self.Alpha, self:IsHovered()&&1||0)
    surface.SetDrawColor(255, 255, 255, self.Alpha*30)
    Eris:DrawCircle(w/2, h/2, w/2)
end

function AVATAR:IsHovered()
    local w, h = self:GetSize()
    local x, y = self:CursorPos()

    if(x<0 || y<0 || x>w || y>h) then return false end
    return (x-w/2)^2 + (y-h/2)^2 < (w/2)^2
end

function AVATAR:SetPlayer(ply, size)
	self.Player = ply
	self.Avatar:SetPlayer(ply, size)
end

vgui.Register("ErisF4Avatar", AVATAR)
