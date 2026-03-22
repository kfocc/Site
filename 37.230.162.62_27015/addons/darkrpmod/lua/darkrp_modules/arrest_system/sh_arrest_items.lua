arrestSystem = arrestSystem or {}
arrestSystem.items = Stack()

local idToName = {}
local function insertItem(name, id, icon, model)
	if string.utf8len(name) > 19 then
		name = string.utf8sub(name, 1, 19) .. "..."
	end

	icon = Material("unionrp/ui/arrest/" .. icon .. ".png")
	local index = arrestSystem.items:Size() + 1
	local itemTab = {
		index = index,
		name = name,
		id = id,
		icon = icon,
		model = model
	}

	arrestSystem.items:Push(itemTab)
	idToName[id] = itemTab
end

function arrestSystem.GetItemByID(id)
	return idToName[id]
end

--[[
	insertItem("Название", "ID айтема", "Иконка айтема", "Модель айтема")
--]]
insertItem("Электроника", "elektro", "cpu", "models/props_lab/reciever01d.mdl")
insertItem("Химикаты", "ximia", "chemistry", "models/props_junk/garbage_milkcarton001a.mdl")
insertItem("Металл", "metal", "iron-bar", "models/gibs/metal_gib2.mdl")
insertItem("Древесина", "wood", "wood-plank", "models/items/item_item_crate_chunk02.mdl")
insertItem("Бумага", "paper", "documents", "models/props_lab/binderblue.mdl")
insertItem("Краска", "color", "paint", "models/props_junk/plasticbucket001a.mdl")
insertItem("Пластик", "plastic", "holder", "models/props_junk/garbage_plasticbottle002a.mdl")
--insertItem("Камень", "rock", "tab", "models/props_debris/concrete_chunk09a.mdl")
