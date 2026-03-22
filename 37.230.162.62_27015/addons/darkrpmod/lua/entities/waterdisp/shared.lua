ENT.Type = "anim"
ENT.Base = "union_base_ent"
ENT.PrintName = "Автомат"
ENT.Instructions = "Можно купить воду"
ENT.Category = "Еда"
ENT.Spawnable = true
ENT.AdminSpawnable = true

DarkRP.createFood("Вода", "waterd", {
	model = "models/props_junk/popcan01a.mdl",
	energy = 15,
	price = 180,
	customCheck = function(ply) return ply.usedWaterDisp end,
	onEaten = function(self, ply)
		timer.Simple(math.random(2, 30), function()
			if not IsValid(ply) or not ply:Alive() then return true end
			local chance = math.random(1, 100)
			if chance == 2 then
				ply:Vomit()
			elseif chance == 1 and not ply:GetDisease() then
				ply:SetDisease("Язва", true)
			end
		end)

		local cur_energy = ply:getDarkRPVar("Energy", 0)
		local new_energy = math.min(20, cur_energy + math.random(8, 15))
		if cur_energy < new_energy then
			ply:setSelfDarkRPVar("Energy", new_energy)
		end

		net.Start("AteFoodIcon")
    net.Send(ply)
    ply:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)

		return true
	end,
})