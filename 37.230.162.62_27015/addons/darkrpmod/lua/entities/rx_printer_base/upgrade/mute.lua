local STR = RXP_Tuners_CreateStruct("mute")
STR.PrintName = "Шумоизоляция"
STR.Description = "Подавляет шум от принтера и отключает звуковые элементы системы"
STR.MaxLevel = 1
STR.Price = 500
function STR:OnBuy(ply, printer, newlevel)
	printer:SetNetVar("mute", true)
end

STR:Regist()
