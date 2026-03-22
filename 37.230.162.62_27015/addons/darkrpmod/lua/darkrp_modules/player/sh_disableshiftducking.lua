local function RemoveKeys(mvd, keys)
	local newbuttons = bit.band(mvd:GetButtons(), bit.bnot(keys))
	mvd:SetButtons(newbuttons)
end

local pressed = false
local cd = 0
hook.Add("SetupMove", "DisableShiftDucking", function(ply, mvd, cmd)
	if not pressed and mvd:KeyPressed(IN_DUCK) then
		pressed = true
	elseif pressed and mvd:KeyReleased(IN_DUCK) then
		pressed = false
		cd = CurTime() + 1
	end

	if pressed and cd > CurTime() and mvd:KeyDown(IN_SPEED) then RemoveKeys(mvd, IN_DUCK) end
end)
