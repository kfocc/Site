ENT.Type = "anim"
function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "model")
	self:NetworkVar("Bool", 0, "dodraw")
	self:NetworkVar("Bool", 1, "doblur")
	self:NetworkVar("Bool", 2, "issprite")
	self:NetworkVar("Float", 0, "collisionsize")
	self:NetworkVar("Int", 0, "rcolor")
	self:NetworkVar("Int", 1, "bcolor")
	self:NetworkVar("Int", 2, "gcolor")
	self:NetworkVar("Int", 3, "acolor")
end
