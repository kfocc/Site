--[[-------------------------------------------------------------------------
	Цены в .Add указываются в рублях
---------------------------------------------------------------------------]]

-- Уровни сработают только, если не произойдет ошибки при пополнении счета
-- Она может случиться, если вы не пользуетесь мгновенным пополнением

IGS.LVL.Add(1)
	:SetName("Неопознанное лицо")
	:SetBonus(function(pl)
		local bonus = pl:IGSFunds() * .1
		pl:AddIGSFunds(bonus,"Бонус за первое пополнение")
		IGS.Notify(pl,"Вы получили " .. PL_IGS(bonus) .. "\nв качестве бонуса за первое пополнение счета")
	end)
	:SetDescription("При первом пополнении счета получите 10% в подарок автоматически и бесплатно") -- выше в catchDSHints еще


IGS.LVL.Add(100):SetName("Гражданин")
IGS.LVL.Add(500):SetName("Примерный гражданин")
IGS.LVL.Add(1000):SetName("Сотрудник ГСР")
IGS.LVL.Add(1500):SetName("Лоялист")
IGS.LVL.Add(2000):SetName("Доверенный лоялист")

IGS.LVL.Add(2500):SetName("Смотрящий лоялист")
	:SetDescription("Бонус 20% на пополнение счета")
	:SetBonus(function(pl)
		local bonus = pl:IGSFunds() * .2 -- на самом деле бонус начислит на всю имеющуюся сумму, а не сумму пополнения. Так что ахтунг
		pl:AddIGSFunds(bonus,"Бонус за 2500 руб транзакций")
		IGS.Notify(pl,"Вы получили " .. PL_IGS(bonus) .. "\nв качестве бонуса за новый бизнес ЛВЛ")
	end)


IGS.LVL.Add(3000):SetName("Глава ГСР")
	--:SetDescription("Премиум поддержка от правительства")
	--:SetBonus(function(pl)
	--	IGS.Notify(pl,"Обратитесь к нам, чтобы договориться о прайм поддержке")
	--	IGS.Notify(pl,"Не забудьте сказать, что это предложение с автодоната и назовите уникальную секретную комбинацию: FVL0YT0VELFR")
	--end)


IGS.LVL.Add(4000):SetName("Инспектор")
IGS.LVL.Add(5000):SetName("Элитный юнит")
IGS.LVL.Add(6000):SetName("Дивизионный лидер")
IGS.LVL.Add(7000):SetName("Секториальный лидер")
IGS.LVL.Add(8000):SetName("Посол Альянса")
IGS.LVL.Add(9000):SetName("Комендант Земли")
IGS.LVL.Add(10000):SetName("Советник Альянса")
IGS.LVL.Add(12000):SetName("Консул Альянса")
IGS.LVL.Add(15000):SetName("Комендант Альянса")
IGS.LVL.Add(20000):SetName("Повелитель Альянса")
IGS.LVL.Add(25000):SetName("Уничтожитель миров")
IGS.LVL.Add(30000):SetName("Почетный Граф UnionRP")
IGS.LVL.Add(35000):SetName("Настоящая элита UnionRP")
IGS.LVL.Add(40000):SetName("Cуперэлита UnionRP")
IGS.LVL.Add(50000):SetName("Избранный советниками UnionRP")
IGS.LVL.Add(60000):SetName("Великий оракул высшего ранга")
IGS.LVL.Add(70000):SetName("Легендарная элита максимального ранга")
IGS.LVL.Add(80000):SetName("Божество")