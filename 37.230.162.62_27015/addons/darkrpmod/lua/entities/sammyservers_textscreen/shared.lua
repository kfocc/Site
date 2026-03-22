ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "SammyServers Textscreen"
ENT.Author = "SammyServers"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPersisted")
end
