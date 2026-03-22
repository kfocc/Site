include("shared.lua")
local rot = Angle(0, 0.6, 0)
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetAngles(self:GetAngles() + rot)
end

local pumpkins = {}
timer.Create("StoragePumpkins", 1, 0, function() pumpkins = ents.FindByClass("halloween_pumpkin") end)
local color_red = Color(255, 200, 0)
hook.Add("SetupOutlines", "AddPumpkinHalos", function(f) f(pumpkins, color_red, OUTLINE_MODE_VISIBLE) end)
