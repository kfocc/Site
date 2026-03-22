unionrp = unionrp or {}
unionrp.sounds = unionrp.sounds or {}

local MODULE = unionrp.sounds
MODULE.classes = MODULE.classes or {}
MODULE.stored = MODULE.stored or {}

function MODULE.Add(class, key, phrase, sounds, global)
	class = string.lower(class)
	key = string.lower(key)

	MODULE.stored[class] = MODULE.stored[class] or {}
	MODULE.stored[class][key] = {
		phrase = phrase,
		sounds = sounds,
		global = global
	}
end

function MODULE.Get(class, key)
	class = string.lower(class)
	key = string.lower(key)

	if MODULE.stored[class] then
		return MODULE.stored[class][key]
	end
end

function MODULE.AddClass(class, condition, max)
	class = string.lower(class)

	MODULE.classes[class] = {
		condition = condition,
		max = max,
	}
end

function MODULE.GetClass(client)
	local classes = {}

	for k, v in pairs(MODULE.classes) do
		if v.condition(client) then
			classes[#classes + 1] = k
		end
	end

	return classes
end

do
	local files, _ = file.Find("darkrp_modules/chat/phrases/*.lua", "LUA")
	for k, v in ipairs(files) do
		include("darkrp_modules/chat/phrases/" .. v)
		AddCSLuaFile("darkrp_modules/chat/phrases/" .. v)
	end
end