include("shared.lua")
local models = {"models/christmas_gift/christmas_gift.mdl", "models/christmas_gift2/christmas_gift2.mdl"}
function ENT:Initialize()
	self.csModel = ClientsideModel(table.Random(models))
	self.csModel:SetModelScale(1.3, 0)
	self.csModel:SetPos(self:GetPos())
end

function ENT:Draw()
	-- self:DrawModel()
	local presentAngle = (CurTime() * 90) % 360
	-- local presentHeight = math.sin(CurTime() * 3) * 5
	self.csModel:SetPos(self:GetPos())
	self.csModel:SetAngles(Angle(0, presentAngle, 0))
	self.csModel:AddEffects(EF_ITEM_BLINK)
	self.mysound = CreateSound(self, "music/HL2_song23_SuitSong3.mp3")
	self.mysound:SetSoundLevel(70)
	self.mysound:Play()
end

function ENT:OnRemove()
	self.csModel:Remove()
	if self.mysound then self.mysound:Stop() end
end

net.Receive("ReceiveTextd", function()
	local ply = LocalPlayer()
	local presentloot = net.ReadString()
	chat.AddText(col.o, "[UnionRP] ", col.w, ply, ", вы получили ", col.o, presentloot .. " руб с подарка")
end)

net.Receive("ReceiveTextdNoCash", function()
	local ply = LocalPlayer()
	chat.AddText(col.o, "[UnionRP] ", col.w, ply, ", вам не повезло. Подарок ", col.o, "пуст")
end)
