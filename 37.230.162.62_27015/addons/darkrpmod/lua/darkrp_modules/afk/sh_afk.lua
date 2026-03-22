AFK_TIME = 90

local pMeta = FindMetaTable("Player")
function pMeta:IsAFK()
	return self:GetNetVar("isAFK", false) and not self:GetNW2Bool("Jailed")
end
pMeta.isAFK = pMeta.IsAFK

function pMeta:GetAFKTime()
	return CurTime() - self:GetNetVar("afkTime", 0)
end

if SERVER then
	function pMeta:SetAFK(bool, time)
		if not isbool(bool) then return end
		time = isnumber(time) and time or CurTime()
		self:SetNetVar("isAFK", bool)
		self:SetNetVar("afkTime", time)
	end
end
