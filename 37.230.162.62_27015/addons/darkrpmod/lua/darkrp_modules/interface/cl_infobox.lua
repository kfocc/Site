local function needArmory(ply)
	local tbl = ply:getJobTable()
	return tbl.weaponsinbox and not ply:HasWeapon(tbl.weaponsinbox[1])
end

local time = 2
timer.Create("MarksInfoBox", time, 0, function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local scn = ply:GetNetVar("Scanner")
	if IsValid(scn) then return end
	if ply:Team() == TEAM_CITIZEN and not ply:HasWeapon("briefcase") then
		for _, ent in ipairs(ents.FindByClass("caseshere")) do
			Marks:AddPoint("Багаж", "briefcase" .. ent:EntIndex(), ent, time + 0.5, "briefcase")
		end
	elseif ply:isCP() and not ply:isMayor() and not ply.Disguised and needArmory(ply) then
		for _, ent in ipairs(ents.FindByClass("aliancedrawer")) do
			Marks:AddPoint("Оружейная", "aliancedrawer" .. ent:EntIndex(), ent, time + 0.5, "joystick")
		end
	elseif ply:isOTA() and ply:Armor() == 0 then
		for i, ent in ipairs(ents.FindByClass("otamaker")) do
			Marks:AddPoint("Сборка", "otamaker" .. ent:EntIndex(), ent, time + 0.5, "shield")
		end
	elseif ply:isRebel() and not ply:isVort() and not ply:GetNetVar("openedRebelDrawer") then
		for i, ent in ipairs(ents.FindByClass("rebeldrawer")) do
			Marks:AddPoint("Оружейная", "rebeldrawer" .. ent:EntIndex(), ent, time + 0.5, "joystick")
		end
	end
end)
