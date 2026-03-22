local STR = RXP_Tuners_CreateStruct("hull")
STR.PrintName = "Емкость батареи +10%"
STR.Description = "Дает на 10% больше энергии"
STR.MaxLevel = 5
STR.Price = 1000
function STR:OnBuy(ply, printer, newlevel, isStep)
	local boost = printer.Hull * 0.1
	if not isStep then
		local current = printer:GetTuneLevel("hull")
		newlevel = newlevel - current
		boost = boost * newlevel
	end

	printer.V_Hull = printer.V_Hull + boost
	printer.F_Hull = printer.F_Hull + boost
end

STR:Regist()
