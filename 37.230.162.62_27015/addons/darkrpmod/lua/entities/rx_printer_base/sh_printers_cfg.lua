if not RegisterRXPPrinter then return end
--[[
	* uniqueID = "rx_printer_1" -- уникальный ID энтити, который будет доступен зарегистрирован.
	* PrinterName = "UNKNOWN PRINTER"
	* PrinterMasterColor = color_white
	*
	* PrinterHealth = 100 - ХП принтера
	* MaxMoney = 3000 -- максимальное количество денег, которое помещается в принтер.
	*
	* RPM = 7
	* Hull = 2000 - формула получения денег: RPM * Hull = Money
	*
	* BreakDownTimer = 60 
	* BreakDownRate = 25
	* BreakDownDestoryTime = 30
	*
	*	Upgrades = { -- переопределение улучшений принтера, false - чтобы отключить улучшение данного параметра.
	*		armor = { -- название параметра из конфига при создании. RXP_Tuners_CreateStruct("armor")
	*			MaxLevel = 10, -- максимальный лвл.
	*			Price = 50, -- цена за 1 улучшение.
	*		},
	*		booster = false, -- отключаем возможность улучшения.
	*	}
	* ErrorSound = {true,1,"Resource/warning.wav"} -- звук ошибки, 5 - количество повторений.
	* RuningSound = {false,8,"ambient/machines/engine1.wav"} -- звук запущенного принтера. 8 - количество повторений.
	* RuningSoundVolume = 0.5 -- громкость звука принтера.
--]]
RegisterRXPPrinter({
	uniqueID = "rx_printer_1",
	PrinterName = "Бронзовый принтер",
	PrinterMasterColor = Color(255, 100, 0, 255),
	PrinterHealth = 100,
	MaxMoney = 3000,
	RPM = 7,
	Hull = 2000,
	Upgrades = {
		booster = {
			MaxLevel = 4,
			Price = 650,
		},
		hull = {
			MaxLevel = 5,
			Price = 350,
		},
		cooler = false,
	},
	BreakDownTimer = 60,
	BreakDownRate = 25,
	BreakDownDestoryTime = 30,
})

RegisterRXPPrinter({
	uniqueID = "rx_printer_2",
	PrinterName = "Кристальный принтер",
	PrinterMasterColor = Color(0, 100, 255, 255),
	PrinterHealth = 100,
	MaxMoney = 10000,
	RPM = 10,
	Hull = 3000,
	Upgrades = {
		booster = {
			MaxLevel = 4,
			Price = 1400,
		},
		hull = {
			MaxLevel = 5,
			Price = 800,
		},
		cooler = false,
	},
	BreakDownTimer = 100,
	BreakDownRate = 20,
	BreakDownDestoryTime = 40,
})

RegisterRXPPrinter({
	uniqueID = "rx_printer_3",
	PrinterName = "Элитный принтер",
	PrinterMasterColor = Color(255, 215, 0, 255),
	PrinterHealth = 150,
	MaxMoney = 20000,
	RPM = 12,
	Hull = 4500,
	Upgrades = {
		booster = {
			MaxLevel = 4,
			Price = 2600,
		},
		hull = {
			MaxLevel = 5,
			Price = 1300,
		},
		cooler = false,
	},
	BreakDownTimer = 160,
	BreakDownRate = 15,
	BreakDownDestoryTime = 50,
})

---------------------
RegisterRXPPrinter({
	uniqueID = "rx_printer_4",
	PrinterName = "Гражданский принтер",
	PrinterMasterColor = Color(0, 153, 0, 255),
	PrinterHealth = 100,
	MaxMoney = 3000,
	RPM = 7.5,
	Hull = 2300,
	Upgrades = {
		booster = {
			MaxLevel = 4,
			Price = 830,
		},
		hull = {
			MaxLevel = 5,
			Price = 400,
		},
		cooler = false,
	},
	BreakDownTimer = 60,
	BreakDownRate = 25,
	BreakDownDestoryTime = 30,
})
