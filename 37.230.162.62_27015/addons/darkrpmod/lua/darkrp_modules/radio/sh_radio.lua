local _R = debug.getregistry()
local pMeta = _R.Player
function pMeta:canRadioSpeak(ply)
	local a, b = hook.Run("CanRadioSpeak", self, ply)
	return a, b
end

function pMeta:isRadioDisabled()
	return self:GetNetVar("radio_disabled", false)
end

function pMeta:isRadioForceDisabled()
	return self:GetNetVar("radio_force_disabled", false)
end

function pMeta:isRadioRestricted()
	return self:GetNetVar("radio_restricted", false)
end

function pMeta:isSpeakToAll()
	if not self:r_isCmD() then return false end
	return self:GetNetVar("speak_to_all", false)
end

function pMeta:r_isCPCmD()
	return self:getJobTable().can_edit_cp_radio or false
end

function pMeta:r_isRebCmD()
	return self:getJobTable().can_edit_rebel_radio or false
end

function pMeta:r_isCmD()
	return self:r_isCPCmD() or self:r_isRebCmD()
end

function pMeta:GetFreq()
	return self:GetNetVar("freq", 0)
end

hook.Add("CanRadioSpeak", "Radio:DefaultHook", function(speaker, listener)
	if not speaker:Alive() then return false end
	if speaker:isArrested() then return false end
	if listener then
		if listener:isArrested() then return false end
		local isAdmin = listener:Team() == TEAM_ADMIN
		if speaker:isCP() and (listener:isCP() or isAdmin) or speaker:isRebel() and (listener:isRebel() or isAdmin) or speaker:isGSR() and (listener:isGSR() or isAdmin) then return true end
	else
		if speaker:isCP() or speaker:isRebel() or speaker:isGSR() then return true end
	end
end)
