local STR = RXP_Tuners_CreateStruct("notice")
STR.PrintName = "Оповещение"
STR.Description = "Добавляет модуль оповещения при заполненности, поломке, износе принтера."
STR.MaxLevel = 1
STR.Price = 500
function STR:OnBuy(ply, printer, newlevel)
	printer.notice = true
end

STR:Regist()
