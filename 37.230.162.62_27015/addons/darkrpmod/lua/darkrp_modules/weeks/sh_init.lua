weeks = weeks or {}

weeks.map = {"Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"}

function weeks.Get()
	return netvars.GetNetVar("weekday", 0)
end

local weeks_Get = weeks.Get
function weeks.GetName()
	return weeks.map[weeks_Get() + 1]
end
