ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Склад еды повстанцев"
ENT.Category = "Еда"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT._initialCount = 15 -- Еда в ящике при запуске сервера
ENT._maxCount = 50 -- Максимум в ящике
function ENT:GetFoodCount()
	return self:GetNetVar("foodCount", self._initialCount)
end
