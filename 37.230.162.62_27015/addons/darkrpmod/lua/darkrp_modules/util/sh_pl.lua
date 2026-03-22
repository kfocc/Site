local function plural_type(i)
	return i % 10 == 1 and i % 100 ~= 11 and 1 or (i % 10 >= 2 and i % 10 <= 4 and (i % 100 < 10 or i % 100 >= 20) and 2 or 3)
end

PL = PL or setmetatable({
	list = {}
}, {
	__call = function(self, name, i) return self.Get(name, i) end
})

local mt = {
	__call = function(self, i)
		local pl = self[plural_type(i)]
		return i .. " " .. pl, pl
	end
}

function PL.Add(name, plurals)
	PL.list[name] = setmetatable(plurals, mt)
	return PL.list[name]
end

function PL.Get(name, i)
	return PL.list[name](i)
end

-----------------
local function r(e)
	local tmp = math.ceil(e)
	local s = tmp % 60
	tmp = math.floor(tmp / 60)
	local m = tmp % 60
	tmp = math.floor(tmp / 60)
	local h = tmp % 24
	tmp = math.floor(tmp / 24)
	local d = tmp % 7
	tmp = math.floor(tmp / 7)
	local w = tmp
	return w, d, h, m, s
end

local SECONDS = PL.Add("seconds", {"секунда", "секунды", "секунд"})
local MINUTES = PL.Add("minutes", {"минута", "минуты", "минут"})
local HOURS = PL.Add("hours", {"час", "часа", "часов"})
local DAYS = PL.Add("days", {"день", "дня", "дней"})
local WEEKS = PL.Add("weeks", {"неделя", "недели", "недель"})
function util.TimeToStr(timing)
	timing = tonumber(timing) or 0
	if timing == 0 then return "Вечность" end
	local w, d, h, min, sec = r(timing)
	w = w ~= 0 and WEEKS(w) .. " " or ""
	d = d ~= 0 and DAYS(d) .. " " or ""
	h = h ~= 0 and HOURS(h) .. " " or ""
	min = min ~= 0 and MINUTES(min) .. " " or ""
	sec = sec ~= 0 and SECONDS(sec) or ""
	return w .. d .. h .. min .. sec
end
