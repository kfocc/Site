local meta = FindMetaTable("Player")
function meta:IsRagdolled()
	return self:GetNetVar("IsRagdolled")
end
