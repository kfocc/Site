local function PlayerBindPress(ply, b, p)
	if not p then return end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.IsTFAWeapon and wep:GetIronSights() and wep:GetStatL("Secondary.ScopeZoom") and wep.Secondary.MinZoom then
		local CT = CurTime()

		if b == "invnext" then
			if CT > (wep.ZoomWait or 0) and wep:GetStatRawL("Secondary.ScopeZoom") > wep.Secondary.MinZoom then
				wep:SetStatRawL("Secondary.ScopeZoom", math.Clamp(wep:GetStatRawL("Secondary.ScopeZoom") - 1, wep.Secondary.MinZoom, wep.Secondary.MaxZoom))
				wep:SetStatRawL("Secondary.OwnerFOV", nil)
				wep:ClearStatCacheL("Secondary.OwnerFOV")
				wep:ClearStatCacheL("Secondary.ScopeZoom")
				wep:CorrectScopeFOV()
				wep:ClearStatCacheL("Secondary.OwnerFOV")
				surface.PlaySound("weapons/zoom.wav")
				wep.ZoomWait = CT + 0.15
			end

			return true
		elseif b == "invprev" then
			if CT > (wep.ZoomWait or 0) and wep:GetStatRawL("Secondary.ScopeZoom") < wep.Secondary.MaxZoom then
				wep:SetStatRawL("Secondary.ScopeZoom", math.Clamp(wep:GetStatRawL("Secondary.ScopeZoom") + 1, wep.Secondary.MinZoom, wep.Secondary.MaxZoom))
				wep:SetStatRawL("Secondary.OwnerFOV", nil)
				wep:ClearStatCacheL("Secondary.OwnerFOV")
				wep:ClearStatCacheL("Secondary.ScopeZoom")
				wep:CorrectScopeFOV()
				wep:ClearStatCacheL("Secondary.OwnerFOV")
				surface.PlaySound("weapons/zoom.wav")
				wep.ZoomWait = CT + 0.15
			end

			return true
		end
	end
end

hook.Add("PlayerBindPress", "SWEP.PlayerBindPress (TFA)", PlayerBindPress, HOOK_HIGH)