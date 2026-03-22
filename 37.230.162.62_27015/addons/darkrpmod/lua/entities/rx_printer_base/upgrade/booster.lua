local STR = RXP_Tuners_CreateStruct("booster")
STR.PrintName = "Скорость печати +5%"
STR.Description = "Принтер зарабатывает на 5% быстрей."
STR.MaxLevel = 5
STR.Price = 1200
function STR:OnBuy(ply, printer, newlevel)
	local Rate = 5 * newlevel
	Rate = Rate / 100
	Rate = Rate + 1
	printer:SetStat("RPM", printer.Stats_Default["RPM"] * Rate)
end

STR:Regist()
