AddCSLuaFile()
ENT.Base = "union_base_ent"
ENT.PrintName = "Оружейная повстанцев"
ENT.Category = "Повстанцы"
ENT.Instructions = "Можно взять снаряжение"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.NoZoom = true

ENT.CIDClass = "cid_new"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "DressCount")
	self:NetworkVar("Int", 1, "CIDCount")
end
