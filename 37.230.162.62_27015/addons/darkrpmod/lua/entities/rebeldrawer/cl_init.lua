include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)
end

local buttons = {
	{
		text = "Взять оружие",
		func = function(npc, menu) netstream.Start("RebelDrawer", npc, "Get Weapons") end
	},
	{
		text = "Взять маскировочную форму",
		func = function(npc, menu) netstream.Start("RebelDrawer", npc, "Get Dress") end
	},
	{
		text = "Взять CID-карту",
		func = function(npc, menu)
			if LocalPlayer():HasWeapon(npc.CIDClass) then return end
			netstream.Start("RebelDrawer", npc, "Get CID")
		end
	},
	{
		text = "Положить маскировочную форму",
		func = function(npc, menu) netstream.Start("RebelDrawer", npc, "Put Dress") end
	},
	{
		text = "Положить CID-карту",
		func = function(npc, menu) netstream.Start("RebelDrawer", npc, "Put CID") end
	},
	{
		text = "Закрыть",
		func = function(npc, menu) menu:Remove() end
	}
}

local cp_buttons = {
	{
		text = "Очистить шкафчик",
		func = function(npc, menu) netstream.Start("RebelDrawer", npc, "Delete Items") end
	},
	{
		text = "Закрыть",
		func = function(npc, menu) menu:Remove() end
	}
}

local nice_text = "Выберите действие"
function ENT:OnOpen()
	local need = buttons
	if LocalPlayer():isCP() and not LocalPlayer():isRebel() then
		need = cp_buttons
		return
	end

	DialogSys.BeginDialogue(self, nice_text, need)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	if self:GetPos():Distance(LocalPlayer():GetPos()) < 150 and LocalPlayer():GetEyeTrace().Entity == self then
		local ang = self:GetAngles()
		ang[3] = ang[3] + 90
		ang[2] = ang[2] + 90
		cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 12 + self:GetAngles():Forward() * 8.5, ang, 0.1)
		draw.SimpleTextOutlined("Оружейная", "BoxText", 0, -130, col.o, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("На складе CID: " .. self:GetCIDCount(), "BoxText", 0, -50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Кол-во форм: " .. self:GetDressCount(), "BoxText", 0, -20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Нажмите E для", "BoxText", 0, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("взаимодействия", "BoxText", 0, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		cam.End3D2D()
	end
end
