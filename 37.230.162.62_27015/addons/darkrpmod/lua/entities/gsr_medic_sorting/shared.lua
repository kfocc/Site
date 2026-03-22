AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Мед сортировка"
ENT.Category = "ГСР"
ENT.Author = "Johnny"
ENT.Spawnable = true
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EndTime")
	self:NetworkVar("Int", 1, "WorkTime")
	self:NetworkVar("Int", 2, "Amount")
end
