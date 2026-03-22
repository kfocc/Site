arrestSystem = arrestSystem or {}
arrestSystem.recipes = Stack()

local function insertRecipe(name, id, data)
	if string.utf8len(name) > 35 then
		name = string.utf8sub(name, 1, 35) .. "..."
	end

	local index = arrestSystem.recipes:Size() + 1
	data.name = name
	data.id = id
	data.index = index

	arrestSystem.recipes:Push(data)
end

--[[
insertRecipe(
	"Название",
	"id рецепта",
	{
		timeToMake = 60, -- время на создание в сек
		timeToMaker = 5, -- время, которое отнимается при сдаче на склад в сек.
		model = {"models/props_junk/garbage_newspaper001a.mdl", "models/props_c17/FurnitureFabric003a"}, -- модель, материал(не обязательно) - через запятую
		itemsRequired = { -- айтемы, которые нужны для создания рецетпа.
			{"tkan", 3},
			{"nit", 1},
			{"rezina", 3},
		}
	}
)
--]]

insertRecipe(
	"Устройство вызова",
	"call_device",
	{
		timeToMake = 15,
		timeToMaker = 60,
		model = {"models/gibs/shield_scanner_gib1.mdl"},
		itemsRequired = {
			{"metal", 1},
			{"elektro", 1},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Бюст Брина",
	"breenbust",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/props_combine/breenbust.mdl"},
		itemsRequired = {
			{"metal", 3},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Сертифицированная сумка",
	"pocketstandart",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/props_c17/SuitCase_Passenger_Physics.mdl"},
		itemsRequired = {
			{"metal", 2},
			{"wood", 2},
			{"plastic", 1},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Фирменный напиток",
	"breensoda",
	{
		timeToMake = 15,
		timeToMaker = 60,
		model = {"models/props_junk/PopCan01a.mdl"},
		itemsRequired = {
			{"metal", 1},
			{"ximia", 1},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Коробка деталей",
	"repairbox",
	{
		timeToMake = 55,
		timeToMaker = 220,
		model = {"models/props_junk/cardboard_box003a.mdl"},
		itemsRequired = {
			{"metal", 4},
			{"elektro", 3},
			{"wood", 2},
			{"color", 2},
		}
	}
)

insertRecipe(
	"Легкая бронепластина",
	"metalarmor",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/plates/plate_light.mdl"},
		itemsRequired = {
			{"metal", 3},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Средняя бронепластина",
	"titanarmor",
	{
		timeToMake = 35,
		timeToMaker = 140,
		model = {"models/plates/plate_medium.mdl"},
		itemsRequired = {
			{"metal", 4},
			{"plastic", 1},
			{"elektro", 2},
		}
	}
)

insertRecipe(
	"Биогель",
	"biomed",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/healthvial.mdl"},
		itemsRequired = {
			{"metal", 1},
			{"plastic", 2},
			{"ximia", 3},
		}
	}
)

insertRecipe(
	"Кнопка Альянса",
	"button",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/props_combine/combinebutton.mdl"},
		itemsRequired = {
			{"metal", 2},
			{"elektro", 3},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Батарея Альянса",
	"battery",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/items/battery.mdl"},
		itemsRequired = {
			{"metal", 2},
			{"elektro", 2},
			{"plastic", 1},
			{"ximia", 1},
		}
	}
)

insertRecipe(
	"Коробка агитплакатов",
	"bannerbox",
	{
		timeToMake = 35,
		timeToMaker = 140,
		model = {"models/props_junk/cardboard_box001a.mdl"},
		itemsRequired = {
			{"wood", 1},
			{"paper", 4},
			{"color", 2},
		}
	}
)

insertRecipe(
	"Сертифицированное радио",
	"radio",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/props_lab/citizenradio.mdl"},
		itemsRequired = {
			{"elektro", 3},
			{"metal", 1},
			{"plastic", 2},
		}
	}
)

insertRecipe(
	"Специальный бланк",
	"blank",
	{
		timeToMake = 10,
		timeToMaker = 40,
		model = {"models/props_office/notepad_office.mdl"},
		itemsRequired = {
			{"paper", 1},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Литература Альянса",
	"book1",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/props_lab/binderbluelabel.mdl"},
		itemsRequired = {
			{"paper", 2},
			{"wood", 1},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Методичка Альянса",
	"book2",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/props_lab/bindergraylabel01a.mdl"},
		itemsRequired = {
			{"paper", 2},
			{"wood", 1},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Одобренные новости",
	"newspaper",
	{
		timeToMake = 10,
		timeToMaker = 40,
		model = {"models/props_c17/paper01.mdl"},
		itemsRequired = {
			{"paper", 1},
			{"color", 1},
		}
	}
)

insertRecipe(
	"Коробка ключей",
	"keys",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/props_junk/cardboard_box004a.mdl"},
		itemsRequired = {
			{"metal", 2},
			{"wood", 2},
		}
	}
)

insertRecipe(
	"Сертифицированная камера",
	"camera",
	{
		timeToMake = 40,
		timeToMaker = 160,
		model = {"models/maxofs2d/camera.mdl"},
		itemsRequired = {
			{"elektro", 3},
			{"plastic", 2},
			{"metal", 1},
			{"color", 1},
			{"paper", 1},
		}
	}
)

insertRecipe(
	"Простейший ПК",
	"pc",
	{
		timeToMake = 45,
		timeToMaker = 180,
		model = {"models/props_lab/harddrive02.mdl"},
		itemsRequired = {
			{"elektro", 5},
			{"plastic", 3},
			{"metal", 1},
		}
	}
)

insertRecipe(
	"Станция лечения",
	"healstation",
	{
		timeToMake = 55,
		timeToMaker = 220,
		model = {"models/props_combine/health_charger001.mdl"},
		itemsRequired = {
			{"elektro", 3},
			{"ximia", 4},
			{"metal", 4},
		}
	}
)

insertRecipe(
	"Пищевые добавки",
	"foodxim",
	{
		timeToMake = 15,
		timeToMaker = 60,
		model = {"models/food_content/vm_sneckol.mdl"},
		itemsRequired = {
			{"ximia", 2},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Заготовка для сыворотки Альянса",
	"infestation",
	{
		timeToMake = 20,
		timeToMaker = 80,
		model = {"models/props_lab/jar01b.mdl"},
		itemsRequired = {
			{"ximia", 3},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Сертифицированный телевизор",
	"tvstation",
	{
		timeToMake = 35,
		timeToMaker = 140,
		model = {"models/props_c17/tv_monitor01.mdl"},
		itemsRequired = {
			{"elektro", 3},
			{"plastic", 2},
			{"wood", 2},
		}
	}
)

insertRecipe(
	"Одобренная бытовая химия",
	"homexim",
	{
		timeToMake = 15,
		timeToMaker = 60,
		model = {"models/props_junk/garbage_plasticbottle002a.mdl"},
		itemsRequired = {
			{"ximia", 2},
			{"plastic", 1},
		}
	}
)

insertRecipe(
	"Картридж для манипринтера",
	"moneyprinter",
	{
		timeToMake = 30,
		timeToMaker = 120,
		model = {"models/props_vents/vent_small_straight002.mdl"},
		itemsRequired = {
			{"ximia", 2},
			{"elektro", 1},
			{"metal", 1},
			{"color", 2},
		}
	}
)