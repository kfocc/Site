ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Склад еды ГО"
ENT.Category = "Еда"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT._initialCount = 15 -- Еда в ящике при запуске сервера
ENT._maxCount = 50 -- Максимум в ящике
ENT._reward = 2000 -- Награда повару ГСР за полное пополнение ящика
function ENT:GetFoodCount()
	return self:GetNetVar("foodCount", self._initialCount)
end
