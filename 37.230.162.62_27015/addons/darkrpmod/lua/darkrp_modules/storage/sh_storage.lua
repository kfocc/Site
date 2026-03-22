Storage = Storage or {}
Storage.pocketable = {
	["spawned_weapon"] = {
		save = {
			class = function(ent) return ent:GetWeaponClass() end,
			clip1 = true,
			clip2 = true,
			WeaponVars = true,
		},
		stack = 3,
		can_stack = function(tbl1, tbl2) return tbl1.class == tbl2.class end,
		interactions = {
			{
				name = "Экипировать",
				func = function(ply, item, tbl, storage, slot)
					if ply:isCP() then
						DarkRP.notify(ply, 1, 5, "Вы не можете использовать этот предмет")
						return
					end

					local ShouldntContinue = hook.Call("PlayerPickupDarkRPWeapon", nil, ply) -- Да, мы все ломаем так, но там ломать нечего.
					if ShouldntContinue then
						DarkRP.notify(ply, 1, 5, "Вы не можете использовать этот предмет")
						return
					end

					local weaponclass = item.class
					if ply:HasWeapon(weaponclass) then
						DarkRP.notify(ply, 1, 5, "У вас уже есть это оружие")
						return
					end

					local weap = ply:Give(weaponclass, true)
					weap:SetClip1(item.clip1 or 0)
					weap:SetClip2(item.clip2 or 0)

					Storage.Remove(storage, slot, 1)
				end
			},
		},
		contraband = true
	},
	["spawned_food"] = {
		save = {
			DarkRPItem = true,
			FoodEnergy = true,
			FoodPrice = true,
			foodItem = true,
			isAlco = true,
			name = function(ent) return ent.FoodName or ent.DarkRPItem and ent.DarkRPItem.name or ent.name end,
			FoodName = function(ent) return ent.FoodName or ent.DarkRPItem and ent.DarkRPItem.name or ent.name end,
		},
		stack = 5,
		can_stack = function(tbl1, tbl2) return tbl1.name == tbl2.name and tbl1.model == tbl2.model end,
		interactions = {
			{
				name = "Употребить",
				func = function(ply, item, tbl, storage, slot)
					local pTeam = ply:Team() -- TODO: Перейти на объект айтема из itemstore, чтобы можно было прокидывать в хуки айтемы нормально. Либо просто подсмотреть как в итемсторе, либо же перейти на итемстор...
					if pTeam == TEAM_GMAN or pTeam == TEAM_ADMIN or ply:isOTA() or ply:isSynth() then
						DarkRP.notify(ply, 1, 5, "Вы не можете использовать этот предмет")
						return
					end

					local darkrp_item = item.foodItem or {}
					local energy = item.FoodEnergy or darkrp_item.energy or 0
					local override = darkrp_item and darkrp_item.onEaten and darkrp_item.onEaten(ply, ply, darkrp_item)
					if override then
						Storage.Remove(storage, slot, 1)
						return
					end

					ply:setSelfDarkRPVar("Energy", math.Clamp(ply:getDarkRPVar("Energy") + energy, 0, 100))
					Storage.Remove(storage, slot, 1)
				end
			}
		}
	},
	["spawned_ammo"] = {
		save = {
			amountGiven = true,
			ammoType = true
		},
		stack = 5,
		can_stack = function(tbl1, tbl2) return tbl1.ammoType == tbl2.ammoType end,
		interactions = {
			{
				name = "Зарядить",
				func = function(ply, item, tbl, storage, slot)
					local weapon = ply:GetActiveWeapon()
					if not IsValid(weapon) then return end

					ply:GiveAmmo(item.amountGiven, item.ammoType)
					Storage.Remove(storage, slot, 1)
				end
			}
		},
		contraband = true,
	},
	["item_health_1"] = {
		stack = 3
	},
	["item_health_2"] = {
		stack = 3
	},
	["item_armor_1"] = {
		stack = 3,
		contraband = true,
	},
	["item_armor_2"] = {
		stack = 3,
		contraband = true,
	},
	["item_armor_3"] = {
		stack = 3,
		contraband = true,
	},
	["ent_pill_antibiotic"] = {
		stack = 3
	},
	["ent_pill_antibiotic_strong"] = {
		stack = 3
	},
	["book_fighters"] = {
		stack = 2
	},
	["paper"] = {
		save = {
			text = true,
			texted = true,
			signed = true,
			signedData = true
		}
	},
	["paper_doc"] = {
		save = {
			text = true,
			texted = true,
			signed = true,
			signedData = true
		},
	},
	["mask1"] = {
		stack = 2,
		interactions = {
			{
				name = "Переодеться",
				func = function(ply, item, items_tbl, storage, slot)
					if not ply:getJobTable().canusemask1 then
						DarkRP.notify(ply, 1, 5, "Вы не можете использовать этот предмет")
						return
					end

					local tListed = {}
					for iJobIndex, tJobInfo in ipairs(RPExtraTeams) do
						if bNotRebel and tJobInfo.cp then continue end
						if tJobInfo.acceptedMaskFor then table.insert(tListed, iJobIndex) end
					end

					deceive.Disguise(ply, tListed[math.random(#tListed)], true)
					Storage.Remove(storage, slot, 1)
				end
			}
		},
		contraband = true,
	},
	["ent_poison"] = {
		contraband = true,
	},
	["ent_pill_poison"] = {},
	["ent_screeds"] = {
		stack = 3,
		contraband = true,
	},
	["ent_flashlight"] = {},
	["ent_bandana"] = {
		contraband = true,
	},
}

hook.Add("canPocket", "Storage.CanPocket", function(ply, item)
	local class = item:GetClass()
	if not Storage.pocketable[class] then return false, "Этот предмет нельзя поднять" end
end)
