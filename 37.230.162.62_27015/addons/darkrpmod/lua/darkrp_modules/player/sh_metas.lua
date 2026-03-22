local meta = FindMetaTable("Player")
function meta:GetLoyalPoints()
	return self:GetNetVar("LoyalPoints", 0)
end

local otas, citizens, gangs, loyals, gsrs, rebels, refugees, zombies, vorts, synths, stalkers = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
-- local function FetchJobs() -- Адекватнее ничего не придумал
-- if not RPExtraTeams then return end
-- otas, citizens, gangs, loyals, gsrs, rebels, refugees, zombies, vorts, synths = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

timer.Simple(0.1, function()
	for k, v in ipairs(RPExtraTeams) do
		if v.ota then otas[k] = true end
		if v.citizen then citizens[k] = true end
		if v.gang then gangs[k] = true end
		if v.loyal then loyals[k] = true end
		if v.gsr then gsrs[k] = true end
		if v.rebel then rebels[k] = true end
		if v.refugee then refugees[k] = true end
		if v.zombie then zombies[k] = true end
		if v.vort then vorts[k] = true end
		if v.synth then synths[k] = true end
		if v.stalker then stalkers[k] = true end
	end
end)

-- end
-- FetchJobs()
-- hook.Add("DarkRPFinishedLoading", "FetchMetas", FetchJobs)
function meta:isOTA()
	local t = self:Team()
	return otas[t]
end

function meta:isCitizen()
	local t = self:GetNetVar("TeamNum", self:Team())
	return citizens[t]
end

function meta:isGang()
	local t = self:Team()
	return gangs[t]
end

function meta:isLoyal()
	local t = self:GetNetVar("TeamNum", self:Team())
	return loyals[t]
end

function meta:isGSR()
	local t = self:GetNetVar("TeamNum", self:Team())
	return gsrs[t]
end

function meta:isRebel()
	local t = self:Team()
	return rebels[t]
end

function meta:isRefugee()
	local t = self:GetNetVar("TeamNum", self:Team())
	return refugees[t]
end

function meta:isZombie()
	return zombies[self:Team()]
end

function meta:isVort()
	return vorts[self:Team()]
end

function meta:isSynth()
	return synths[self:Team()]
end

function meta:isStalker()
	return stalkers[self:Team()]
end

meta.isBandit = meta.isGang
meta.isCt = meta.isCitizen
meta.isCombine = meta.isOTA
meta.isVortigaunt = meta.isVort

function meta:isMP()
	return self:isCP() and not self:isMayor() and not self:isOTA()
end

function meta:isGman()
	return self:Team() == TEAM_GMAN
end

function meta:isCrm()
	return self:Team() == TEAM_CREMATOR
end

function meta:isCMD()
	return self:getJobTable().cmd
end

function meta:isCPCMD()
	local jobtbl = self:getJobTable()
	return jobtbl.cp and jobtbl.cmd
end

function meta:isOTACMD()
	local jobtbl = self:getJobTable()
	return jobtbl.ota and jobtbl.cmd
end

function meta:isRebelCMD()
	local jobtbl = self:getJobTable()
	return jobtbl.rebel and jobtbl.cmd
end

function meta:isGSRCMD()
	local jobtbl = self:getJobTable()
	return jobtbl.gsr and jobtbl.cmd
end

-- function meta:GetID()
--   return self:GetNW2String("CID")
-- end
-- meta.GetCID = meta.GetID
function meta:IsFemale()
	return string.find(string.lower(self:GetModel()), "female", 1, true) or self:GetNetVar("IsFemale", false)
end

function meta:isFemale()
	return self:IsFemale() or false
end

function meta:BadIdea(ply)
	return (self:isCP() and ply:isCP() or (self:isCitizen() or self:isLoyal() or self:isGSR() or self:Team() == TEAM_CITIZEN) and (ply:isCitizen() or ply:isLoyal() or ply:isCP() or ply:isGSR() or ply:Team() == TEAM_CITIZEN) or self:isRebel() and ply:isRebel()) or false
end

local notVIP = {
	user = true,
	noaccess = true
}

function meta:isVIP()
	return not notVIP[self:GetUserGroup()]
end

function meta:GetMaxArmor()
	return self:GetNetVar("maxarmor", 100)
end

if SERVER then
	meta._SetMaxArmor = meta._SetMaxArmor or meta.SetMaxArmor
	function meta:SetMaxArmor(arm)
		self:SetNetVar("maxarmor", arm)
		self:_SetMaxArmor(arm)
	end
end

local team_GetColor = team.GetColor
function meta:GetTeamColor()
	local teamColor = self:GetNetVar("TeamCol", team_GetColor(self:Team()))
	return teamColor
end

function meta:isEnabledMask()
	return (self:isMP() and self:Alive()) and self:GetBodygroup(2) ~= 0
end
meta.isMaskEnabled = meta.isEnabledMask

function meta:DoMask()
	if not self:isMP() then return end
	if self:GetBodygroup(2) == 0 then
		self:SetBodygroup(2, self:getJobTable().maskid and self:getJobTable().maskid or 1)
		self:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav")
		hook.Run("PlayerMaskOn", self)
	else
		self:SetBodygroup(2, 0)
		self:EmitSound("npc/metropolice/vo/off" .. math.random(1, 4) .. ".wav")
		hook.Run("PlayerMaskOff", self)
	end
end

if SERVER then
	util.AddNetworkString("Mask")
	util.AddNetworkString("CPNotify")
	net.Receive("mask", function(_, ply)
		if not ply:isMP() then return end
		ply:DoMask()
	end)
end

function meta:CanUsePhrases()
	return self:getJobTable().sounds and (not self:isMP() or self:isEnabledMask() or self:Team() == TEAM_BARNEY)
end

function meta:CanUseVIPPhrases()
	if not self:isVIP() then return false end
	return not self:isEnabledMask() and not self:isOTA() and not self:isZombie()
end

function meta:CPNotify(text, color)
	net.Start("CPNotify")
	net.WriteString(text or "ERROR")
	net.WriteColor(color or col.w)
	net.Send(self)
end

function CPNotifyAll(text, color)
	local rcp = RecipientFilter(true)
	for _, ply in player.Iterator() do
		if ply:isCP() and ply:Team() ~= TEAM_MAYOR then
			rcp:AddPlayer(ply)
		end
	end

	net.Start("CPNotify")
	net.WriteString(text or "ERROR")
	net.WriteColor(color or col.w)
	net.Send(rcp)
end

-- if not meta.getDarkRPVar then
--   function meta:getDarkRPVar(...)
--     return self:GetNetVar(...)
--   end
-- end
-- if not meta.setDarkRPVar and SERVER then
--   function meta:setDarkRPVar(...)
--     return self:SetNetVar(...)
--   end
-- end
local function cpHasCmd()
	for _, ply in player.Iterator() do
		if ply:isCPCMD() then return true end
	end
	return false
end
_G.allianceRecruitingHasCmd = cpHasCmd

function meta:CanGetCP()
	if self:isCP() or self:GetNetVar("HasPass") or netvars.GetNetVar("Nabor_Active") then
		return true
	elseif not cpHasCmd() then
		return true
	end
	return false
end

local event_groups = {
	["superadmin"] = true,
	["overwatch"] = true,
	["assistant_nabor"] = true,
	["advisor_nabor"] = true,
	["event_boss_nabor"] = true,
	["event_nabor"] = true
}

function meta:IsEventer()
	return event_groups[self:GetUserGroup()]
end

local global_event_groups = {
	["superadmin"] = true,
	["overwatch"] = true,
	["assistant_nabor"] = true,
	["event_boss_nabor"] = true
}

function meta:IsGlobalEventer()
	return global_event_groups[self:GetUserGroup()]
end
