ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Раздатчик коробок"
ENT.Category = "Завод ГСР"
ENT.Author = "Ferzux, переписал Johnny & JarosLucky"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.DisplayName = "Выдача рационников"
ENT.PrimaryColor = Color(61, 87, 16)
ENT.SecondaryColor = ENT.PrimaryColor:darken(35)

ENT.DropClass = "box"
ENT.DropForce = 15
ENT.DropAngle = Angle()
ENT.Delay = 120

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NextUse")
end
