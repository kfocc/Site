local meta = FindMetaTable("Player")

function meta:Team()
	return self:GetNetVar("iTeam", 0)
end