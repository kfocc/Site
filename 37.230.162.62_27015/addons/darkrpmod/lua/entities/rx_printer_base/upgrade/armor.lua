local STR = RXP_Tuners_CreateStruct("armor")
STR.PrintName = "Прочность +100"
STR.Description = "Увеличивает прочность принтера"
STR.MaxLevel = 4
STR.Price = 100
function STR:OnBuy(ply, printer, newlevel)
	printer:SetStat("HP", printer.Stats_Default["HP"] + 100 * newlevel)
end

STR:Regist()
