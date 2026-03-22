include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)

	local origin = self:WorldSpaceCenter()
	local _, max = self:WorldSpaceAABB()
	origin.z = max.z
	if (LocalPlayer():GetPos():Distance(origin) >= 768) then
		return end
	if not nameplates then return end
	nameplates.DrawEnt(self, origin)
end


--[[---------------------------------------------------------------------------
Create a shipment from a spawned_weapon
---------------------------------------------------------------------------]]
properties.Add("createShipment",
	{
		MenuLabel   =   DarkRP.getPhrase("createshipment"),
		Order	   =   2002,
		MenuIcon	=   "icon16/add.png",

		Filter	  =   function(self, ent, ply)
							if not IsValid(ent) then return false end
							return ent.IsSpawnedWeapon
						end,

		Action	  =   function(self, ent)
							if not IsValid(ent) then return end
							RunConsoleCommand("darkrp", "makeshipment", ent:EntIndex())
						end
	}
)

--[[---------------------------------------------------------------------------
Interface
---------------------------------------------------------------------------]]
DarkRP.hookStub{
	name = "onDrawSpawnedWeapon",
	description = "Draw spawned weapons.",
	realm = "Client",
	parameters = {
		{
			name = "weapon",
			description = "The weapon to perform drawing operations on.",
			type = "Player"
		}
	},
	returns = {
		{
			name = "value",
			description = "Return a value to completely override drawing",
			type = "any"
		}
	}
}
