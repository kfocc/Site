UTime = UTime or {}

local _R = debug.getregistry()
local meta = _R.Player

function meta:GetUTime()
	return self:GetNetVar("TotalUTime", 0)
end

function meta:GetUTimeStart()
	return self:GetNetVar("UTimeStart", 0)
end

function meta:GetUTimeSessionTime()
	return CurTime() - self:GetUTimeStart()
end

function meta:GetUTimeFirstVisit()
	return self:GetNetVar("UTimeFirstVisit", 0)
end

function meta:GetUTimeTotalTime()
	return self:GetUTime() + CurTime() - self:GetUTimeStart()
end
