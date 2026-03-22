local STR = RXP_Tuners_CreateStruct("software")
STR.PrintName = "Шанс поломки -20%"
STR.Description = "Уменьшает на 20 процентов шанс ломания принтера"
STR.MaxLevel = 5
STR.Price = 450
function STR:OnBuy(ply, printer, newlevel)
	local Rate = 20 * newlevel
	Rate = 100 - Rate
	Rate = Rate / 100
	printer:SetStat("BreakDownRate", printer.Stats_Default["HullDecreSpeed"] * Rate)
end

STR:Regist()
