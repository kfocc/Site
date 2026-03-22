hook.Add("PlayerSwitchWeapon", "RPG.NextShotTiming", function(ply, oldWeapon, newWeapon)
	if CLIENT and ply ~= LocalPlayer() then return end
	if not IsValid(newWeapon) then return end
	if newWeapon:GetClass() ~= "weapon_rpg" then return end
	newWeapon:SetNextPrimaryFire(CurTime() + 1.5)
end)

if CLIENT then
	local color_red = Color(255, 20, 20, 255)
	local color_gray = Color(200, 200, 200, 255)
	function DarkRP.notify(notifyType, time, text)
		notifyType = math.Clamp(notifyType, 0, 4)
		GAMEMODE:AddNotify(text, notifyType, time)
		surface.PlaySound("buttons/lightswitch2.wav")
		MsgC(color_red, "[DarkRP] ", color_gray, text, "\n")
	end
end
