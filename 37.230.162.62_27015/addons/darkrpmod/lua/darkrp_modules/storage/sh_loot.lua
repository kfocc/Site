hook.Add("loadCustomDarkRPItems", "Loot.loadCustomDarkRPItems", function()
	DarkRP.createFood("Обычный хедкраб", "headcrab_food", {
		model = "models/food_content_rebels/headcrab_food.mdl",
		energy = 10,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(20) end,
	})

	DarkRP.createFood("Быстрый хедкраб", "headcrabfast_food", {
		model = "models/food_content_rebels/headcrabfast_food.mdl",
		energy = 10,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(20) end,
	})

	DarkRP.createFood("Личинка льва", "prawn", {
		model = "models/food_content_rebels/prawn.mdl",
		energy = 5,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(10) end,
	})

	DarkRP.createFood("Крыса", "rat", {
		model = "models/food_content_rebels/rat.mdl",
		energy = 5,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(10) end,
	})

	DarkRP.createFood("Тараканы", "cockroach", {
		model = "models/food_content_rebels/cockroach.mdl",
		energy = 3,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(3) end,
	})

	DarkRP.createFood("Ворона", "crow_food", {
		model = "models/food_content_rebels/crow_food.mdl",
		energy = 5,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(10) end,
	})

	DarkRP.createFood("Голубь", "pigeon_food", {
		model = "models/food_content_rebels/pigeon_food.mdl",
		energy = 5,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(10) end,
	})

	DarkRP.createFood("Грязная вода", "dirtywater", {
		model = "models/food_content_rebels/dirtywater.mdl",
		energy = 8,
		price = 10,
		customCheck = function(ply) return false end,
		onEaten = function(self, ply) ply:TakeHealth(10) end,
	})

	DarkRP.createFood("Консервы", "porknbeans", {
		model = "models/food_content_rebels/porknbeans.mdl",
		energy = 35,
		price = 10,
		customCheck = function(ply) return false end,
	})

	DarkRP.createFood("Чипсы", "potatocrisps", {
		model = "models/food_content_rebels/potatocrisps.mdl",
		energy = 35,
		price = 10,
		customCheck = function(ply) return false end,
	})
end)