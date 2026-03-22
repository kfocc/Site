local meta = FindMetaTable("Player")
function meta:GetLocalPlayerRelativeTeam()
	local lp = LocalPlayer()
	local lpJobTbl = lp:getJobTable()
	local targetTeam = self:Team()

	local targetJobTbl = self:getJobTable()
	local targetDisguiseTeam = self:GetNetVar("TeamNum")
	local isTargetDisguised = targetDisguiseTeam ~= nil
	local targetDisguiseTeamTab = isTargetDisguised and RPExtraTeams[targetDisguiseTeam]

	if lpJobTbl.rebel and targetJobTbl.rebel then
		return targetTeam
	elseif lpJobTbl.gang and targetJobTbl.gang then
		return targetTeam
	elseif targetDisguiseTeamTab and targetDisguiseTeamTab.sname then
		return TEAM_CITIZEN1
	end
	return targetDisguiseTeam or targetJobTbl.sname and TEAM_CITIZEN1 or targetTeam
end

function meta:GetResultTeamName() -- TODO: Make this cached and updated by event
	local lp = LocalPlayer()
	local isAdmin = lp:Team() == TEAM_ADMIN
	local lpGSR, lpRebel, lpRefugee = lp:isGSR(), lp:isRebel(), lp:isRefugee()
	local ignore = isAdmin or lp:isBandit() and self:isBandit() or lpGSR and self:isGSR() or lpRebel and self:isRebel() or lpRefugee and self:isRefugee()
	local cid = "#" .. self:GetID()
	local selfTeam = self:Team()
	local teamNum = self:GetNetVar("TeamNum")

	local tname
	if not ignore then
		tname = self:getDarkRPVar("job", team.GetName(teamNum or selfTeam))
	else
		tname = team.GetName(selfTeam) .. (self:isCP() and not self:isRebel() and " " .. cid or "")
	end

	if teamNum then
		local tbl = RPExtraTeams[teamNum]
		if tbl and (tbl.gsr and lpGSR or tbl.rebel and lpRebel or tbl.refugee and lpRefugee) then
			tname = team.GetName(teamNum)
		end
	end

	return tname, teamNum or selfTeam
end