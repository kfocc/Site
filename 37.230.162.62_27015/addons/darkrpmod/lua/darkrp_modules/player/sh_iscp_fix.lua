local meta = FindMetaTable("Player")
function meta:isCP()
	return GAMEMODE.CivilProtection[self:Team()] or self:GetNetVar("JobCP", false)
end
