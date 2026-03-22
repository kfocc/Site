plogs.Register("Смерти", true, Color(255, 0, 0))
local data = {}
local format = "%s наносит %s %s урона с помощью %s"
local function GetWeaponClass(weapon)
	if IsValid(weapon) and weapon:IsPlayer() then weapon = weapon:GetActiveWeapon() end
	if not IsValid(weapon) then return "Unknown" end
	local print_name = weapon.PrintName or weapon:GetClass()
	if print_name == "Scripted Weapon" then print_name = weapon:GetClass() end
	return print_name
end

local function GetDamageInfo(dmg)
	local damage = dmg:GetDamage()
	local inflictor = dmg:GetInflictor()
	local inf_name = GetWeaponClass(inflictor)
	return inf_name, damage
end

local function PostDamage(data)
	local v_name, v_sid = data.victim.name, data.victim.steamid
	local a_name, a_sid = data.attacker.name, data.attacker.steamid
	local weapon, damage = tostring(data.weapon), tostring(data.damage)
	local copy = {
		["Жертва"] = v_sid,
		["Нападающий"] = a_sid,
		["Оружие"] = weapon,
		["Урона"] = damage
	}

	local str = format:format(a_name, v_name, damage, weapon)
	plogs.Log("Урон", str, copy)
end

local death_format = "%s убивает %s с помощью %s"
plogs.AddHook("PlayerDeath", function(ply, inflictor, attacker)
	local isRagdollFinished = ply.isRagdollFinished
	if isRagdollFinished then
		attacker = isRagdollFinished[1]
		inflictor = isRagdollFinished[2]
	end

	local plyPos, attackerPos = ply:GetPos(), IsValid(attacker) and attacker:GetPos()
	local posTab = {}
	if plyPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию жертвы",
			data = plyPos
		})
	end

	if attackerPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию атакующего",
			data = attackerPos
		})
	end

	if not IsValid(attacker) or not attacker:IsPlayer() or ply == attacker then
		plogs.PlayerLog(ply, "Смерти", ply:NameID() .. " умер")
		return
	end

	local weapon = IsValid(inflictor) and (inflictor.PrintName or inflictor:GetClass()) or "Unknown"
	if weapon == "player" then
		local wep = attacker:GetActiveWeapon()
		if IsValid(wep) then weapon = wep.PrintName or wep:GetClass() end
	end

	local sid = ply:SteamID()
	for id, info in pairs(data) do
		if info.victim.steamid == sid or info.attacker.steamid == sid then
			PostDamage(info)
			data[id] = nil
		end
	end

	local str = death_format:format(attacker:NameID(), ply:NameID(), weapon)
	plogs.Log("Смерти", str, {
		["Жертва"] = sid,
		["Убийца"] = attacker:SteamID(),
		["Оружие"] = weapon
	}, posTab)
end)

plogs.Register("Урон", false)
plogs.AddHook("PostEntityTakeDamage", function(ent, dmginfo)
	if not ent:IsPlayer() then return end
	local ply = dmginfo:GetAttacker()
	if not IsValid(ply) or not ply:IsPlayer() or ply == ent then return end
	local weapon, damage = GetDamageInfo(dmginfo)
	if damage < 1 then return end
	local id = ply:SteamID() .. ":" .. ent:SteamID()
	if not data[id] then
		data[id] = {
			victim = {
				name = ent:NameID(),
				steamid = ent:SteamID()
			},
			attacker = {
				name = ply:NameID(),
				steamid = ply:SteamID()
			},
			damage = 0,
			weapon = "Unknown"
		}
	end

	if weapon ~= "Unknown" then data[id].weapon = weapon end
	data[id].damage = math.ceil(data[id].damage + damage)
end)

timer.Create("plogs.PostEntityTakeDamage", 10, 0, function()
	for id, info in pairs(data) do
		PostDamage(info)
	end

	data = {}
end)
