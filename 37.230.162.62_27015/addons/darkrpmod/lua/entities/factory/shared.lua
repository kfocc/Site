ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Обработка Рациона"
ENT.Category = "Завод ГСР"
ENT.Author = "Johnny & JarosLucky"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.WorkTime = 60 -- время работы (в секундах) / working time (in sec)
ENT.ProcessTime = 45 -- Не знаю почему так, но придержимся этой логики
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NextUse")
	self:NetworkVar("Bool", 0, "Working")
end
