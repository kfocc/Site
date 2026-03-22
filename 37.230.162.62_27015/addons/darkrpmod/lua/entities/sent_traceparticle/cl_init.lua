include('shared.lua')
function ENT:Initialize()
	self.Color = Color(255, 255, 255, 255)
end

function ENT:Draw(flags)
	--To draw, or not to draw?
	local dodraw = dodraw or self:Getdodraw()
	if not dodraw then return false end

	--We need to get all of our NW vars and store them as locals to prevent lagness.
	local issprite = issprite or self:Getissprite()
	local doblur = doblur or self:Getdoblur()
	local model = model or self:Getmodel()
	local color = color or Color(self:Getrcolor(), self:Getgcolor(), self:Getbcolor(), self:Getacolor())
	local collisionsize = collisionsize or self:Getcollisionsize() * 2
	if issprite then
		local pos = self:GetPos()
		local vel = self:GetVelocity()
		render.SetMaterial(Material(model))
		if doblur then
			local lcolor = render.GetLightColor(pos) * 2
			lcolor.x = color.r * mathx.Clamp(lcolor.x, 0, 1)
			lcolor.y = color.g * mathx.Clamp(lcolor.y, 0, 1)
			lcolor.z = color.b * mathx.Clamp(lcolor.z, 0, 1)
			--Fake motion blur
			for i = 1, 7 do
				local col = Color(lcolor.x, lcolor.y, lcolor.z, 200 / i)
				render.DrawSprite(pos + vel * (i * -0.004), collisionsize, collisionsize, col)
			end
		end

		render.DrawSprite(pos, collisionsize, collisionsize, color)
	else
		self:DrawModel(flags)
	end

	self:DrawShadow(false)
end
