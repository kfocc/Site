include"sh_init.lua"
include"cl_maths.lua"
include"cl_panel.lua"
local mat = CreateMaterial("aeypad_baaaaaaaaaaaaaaaaaaase", "VertexLitGeneric", {
	["$basetexture"] = "white",
	["$color"] = "{ 36 36 36 }",
})

function ENT:Draw()
	render.SetMaterial(mat)
	render.DrawBox(self:GetPos(), self:GetAngles(), self.Mins, self.Maxs, color_white, true)

	local pos, ang = self:CalculateRenderPos(), self:CalculateRenderAng()
	local w, h = self.Width2D, self.Height2D
	local x, y = self:CalculateCursorPos()
	local scale = self.Scale -- A high scale avoids surface call integerising from ruining aesthetics
	cam.Start3D2D(pos, ang, self.Scale)
	self:Paint(w, h, x, y)
	cam.End3D2D()
end

function ENT:SendCommand(command, data)
	if not IsValid(self) then return end
	local lp = LocalPlayer()
	local pTeam = lp:Team()
	if pTeam == TEAM_GMAN or pTeam == TEAM_ADMIN then return end
	if lp.nexttime and lp.nexttime > CurTime() then return end

	net.Start("Keypad")
	net.WriteEntity(self)
	net.WriteUInt(command, 4)
	if data then net.WriteUInt(data, 8) end
	net.SendToServer()
	lp.nexttime = CurTime() + 1
end
