ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Корзина для предметов"
ENT.Category = "Заключенные"
ENT.Author = ""
ENT.Spawnable = false
ENT.AdminSpawnable = true
if SERVER then
	function ENT:SetItemCount(num)
		self.countItems = num
		self:SetNetVar("itemsCount", num)
	end
end

function ENT:GetItemCount()
	return self:GetNetVar("itemsCount", 0)
end
