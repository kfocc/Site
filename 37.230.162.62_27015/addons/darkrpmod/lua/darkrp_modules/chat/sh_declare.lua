local nonDeclaredCommands = {
	{
		command = "roll",
		description = "Кинуть кубик.",
		delay = 1.5,
	},
	{
		command = "do",
		description = "Действие от третьего лица.",
		delay = 1.5,
	},
	{
		command = "looc",
		description = "Локальный OOC чат.",
		delay = 1.5,
	},
	{
		command = "l",
		description = "Локальный OOC чат.",
		delay = 1.5,
	},
	{
		command = "r",
		description = "Рация.",
		delay = 1.5,
	},
	{
		command = "vipchat",
		description = "Вип чат",
		delay = 1.5,
	},
	{
		command = "v",
		description = "Вип чат",
		delay = 1.5,
	},
	{
		command = "vc",
		description = "Вип чат",
		delay = 1.5,
	},
	{
		command = "achat",
		description = "Админ чат",
		delay = 1.5,
	},
	{
		command = "adm",
		description = "Админ чат",
		delay = 1.5,
	},
	{
		command = "adminchat",
		description = "Админ чат",
		delay = 1.5,
	},
	{
		command = "03",
		description = "Вызвать медика ГСР",
		delay = 1.5,
	},
	{
		command = "calleat",
		description = "Вызвать повара ГСР",
		delay = 1.5,
	},
	{
		command = "fallover",
		description = "Заставляет упасть вашего персонажа.",
		delay = 1.5,
	},
	{
		command = "stopcodes",
		description = "Останавливает все активные коды",
		delay = 1.5,
	},
	{
		command = "drop",
		description = "Выбросить оружие из рук.",
		delay = 1.5,
	},
	{
		command = "dropweapon",
		description = "Выбросить оружие из рук.",
		delay = 1.5,
	},
	{
		command = "weapondrop",
		description = "Выбросить оружие из рук.",
		delay = 1.5,
	},
	{
		command = "telegram",
		description = "Привязка телеграма.",
		delay = 1.5,
	},
	--[[{
		command = "doorkick",
		description = "Выбить дверь",
		delay = 1.5,
	},]]
	{
		command = "startlk",
		description = "Старт комендантского часа.",
		delay = 1.5,
	},
	{
		command = "citizen",
		description = "Стать неопознанным лицом.",
		delay = 2,
	},
	{
		command = "//",
		description = "Подача жалобы.",
		delay = 1.5,
	},
	{
		command = "giveprotocol",
		description = "Выдача протокола.",
		delay = 1.5,
	}
}

for i = 1, #nonDeclaredCommands do
	local data = nonDeclaredCommands[i]
	DarkRP.declareChatCommand({
		command = data.command,
		description = data.description,
		delay = data.delay
	})
end
