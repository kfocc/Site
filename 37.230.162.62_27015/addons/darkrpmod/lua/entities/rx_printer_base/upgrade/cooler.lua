local STR = RXP_Tuners_CreateStruct("cooler")
STR.PrintName = "Расход батареи -10%"
STR.Description = "Скорость уменьшения энергии на 10%"
STR.MaxLevel = 5
STR.Price = 1500
function STR:OnBuy(ply, printer, newlevel)
	local Rate = 10 * newlevel
	Rate = 100 - Rate
	Rate = Rate / 100
	printer:SetStat("HullDecreSpeed", printer.Stats_Default["HullDecreSpeed"] * Rate)
end

STR:Regist()
