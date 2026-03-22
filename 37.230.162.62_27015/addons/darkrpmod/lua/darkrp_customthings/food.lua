--[[---------------------------------------------------------------------------
DarkRP custom food
---------------------------------------------------------------------------

This file contains your custom food.
This file should also contain food from DarkRP that you edited.

THIS WILL ONLY LOAD IF HUNGERMOD IS ENABLED IN darkrp_config/disabled_defaults.lua.
IT IS DISABLED BY DEFAULT.

Note: If you want to edit a default DarkRP food, first disable it in darkrp_config/disabled_defaults.lua
  Once you've done that, copy and paste the food item to this file and edit it.

The default food can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/hungermod/sh_init.lua#L33

Add food under the following line:
---------------------------------------------------------------------------]]
local isnil = fn.Curry(fn.Eq, 2)(nil)
local validFood = {
	"name",
	model = isstring,
	"energy",
	"price",
	onEaten = fn.FOr{isnil, isfunction},
	isAlco = fn.FOr{isnil, isstring}
}

FoodItems = {}
local foodItemsCacheByName = {}
local foodItemsCacheByStringID = {}
function DarkRP.createFood(name, stringId, mdl, energy, price, isAlco)
	local foodItem = istable(mdl) and mdl or {
		model = mdl,
		energy = energy,
		price = price,
		isAlco = isAlco
	}

	foodItem.name = name
	foodItem.stringId = stringId
	if DarkRP.DARKRP_LOADING and DarkRP.disabledDefaults["food"][name] then return end
	for k, v in pairs(validFood) do
		local isFunction = isfunction(v)
		if isFunction and not v(foodItem[k]) or not isFunction and foodItem[v] == nil then ErrorNoHalt("Corrupt food \"" .. (name or "") .. "\": element " .. (isFunction and k or v) .. " is corrupt.\n") end
	end

	local insertKey = table.insert(FoodItems, foodItem)
	foodItemsCacheByName[name] = insertKey
	foodItemsCacheByStringID[stringId] = insertKey
end

AddFoodItem = DarkRP.createFood
DarkRP.getFoodItems = fp{fn.Id, FoodItems}
function DarkRP.removeFoodItem(i)
	local food = FoodItems[i]
	foodItemsCacheByName[food.name] = nil
	foodItemsCacheByStringID[food.stringId] = nil
	FoodItems[i] = nil
	hook.Run("onFoodItemRemoved", i, food)
end

function DarkRP.getFoodIDByName(name)
	return foodItemsCacheByName[name]
end

function DarkRP.getFoodTableByName(name)
	local foodID = foodItemsCacheByName[name]
	if not foodID then return end
	return FoodItems[foodID]
end

function DarkRP.getFoodIDByStringID(stringID)
	return foodItemsCacheByStringID[stringID]
end

function DarkRP.getFoodTableByStringID(stringID)
	local foodID = foodItemsCacheByStringID[stringID]
	if not foodID then return end
	return FoodItems[foodID]
end

local plyMeta = FindMetaTable("Player")
plyMeta.isCook = fn.Compose{fn.Curry(fn.GetValue, 2)("cook"), plyMeta.getJobTable}
--[[
Valid members:
  model = string, -- the model of the food item
  energy = int, -- how much energy it restores
  price = int, -- the price of the food
  requiresCook = boolean, -- whether only cooks can buy this food
  customCheck = function(ply) return boolean end, -- customCheck on purchase function
  customCheckMessage = string -- message to people who cannot buy it because of the customCheck
]]
DarkRP.DARKRP_LOADING = true

--[[ -- Старая еда

DarkRP.createFood("Старые консервы", "food_old_canned_food", {
	model = "models/props_junk/garbage_metalcan001a.mdl",
	energy = 20,
	price = 300,
	customCheck = function(ply) return table.HasValue({TEAM_BEGLEC1, TEAM_FOODSHOP}, ply:Team()) end,
	onEaten = function(_, ply) ply:TakeHealth(5) end,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Грязная вода", "food_dirty_water", {
	model = "models/props_junk/garbage_plasticbottle003a.mdl",
	energy = 30,
	price = 470,
	customCheck = function(ply) return table.HasValue({TEAM_BEGLEC1, TEAM_FOODSHOP}, ply:Team()) end,
	onEaten = function(_, ply) ply:TakeHealth(4) end,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Тухлая лапша", "food_rotten_noodle", {
	model = "models/props_junk/garbage_takeoutcarton001a.mdl",
	energy = 40,
	price = 640,
	customCheck = function(ply) return table.HasValue({TEAM_BEGLEC1, TEAM_FOODSHOP}, ply:Team()) end,
	onEaten = function(_, ply) ply:TakeHealth(3) end,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Жаренный грызун", "food_fried_rodent", {
	model = "models/props_junk/garbage_bag001a.mdl",
	energy = 50,
	price = 810,
	customCheck = function(ply) return table.HasValue({TEAM_BEGLEC1, TEAM_FOODSHOP}, ply:Team()) end,
	onEaten = function(_, ply) ply:TakeHealth(2) end,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Жареный лев", "food_fried_ants", {
	model = "models/Gibs/Antlion_gib_Large_2.mdl",
	energy = 60,
	price = 980,
	customCheck = function(ply) return table.HasValue({TEAM_BEGLEC1, TEAM_FOODSHOP}, ply:Team()) end,
	onEaten = function(_, ply) ply:TakeHealth(1) end,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

--]]

----------
local canBuyGSRTab = {
	[TEAM_GSR3] = true,
}

local function canBuyFoodGSR(ply)
	return canBuyGSRTab[ply:Team()]
end

DarkRP.createFood("Мука", "food_combirationa", {
	model = "models/food_content/combirationa.mdl",
	energy = -5,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	onEaten = function(_, ply) ply:TakeHealth(5) end,
	price = 30,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Приправы", "food_vm_sneckol", {
	model = "models/food_content/vm_sneckol.mdl",
	energy = -5,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	onEaten = function(_, ply) ply:TakeHealth(3) end,
	price = 20,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Шоколад. порошок", "food_vm_sneckol2", {
	model = "models/food_content/vm_sneckol2.mdl",
	energy = 1,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 30,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Молочная смесь", "food_milkcarton002a", {
	model = "models/props_junk/garbage_milkcarton002a.mdl",
	energy = 1,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 40,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Сырое мясо", "food_steak1", {
	model = "models/food_content/steak1.mdl",
	energy = -10,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	onEaten = function(_, ply) ply:TakeHealth(10) end,
	price = 70,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Салат", "food_lettuce", {
	model = "models/food_content/lettuce.mdl",
	energy = 1,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Сырный продукт", "food_cheese01c", {
	model = "models/food_content/meal_cheese01c.mdl",
	energy = 2,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 50,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Помидор", "food_tomato", {
	model = "models/food_content/tomato.mdl",
	energy = 3,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Яблоко", "food_apple2", {
	model = "models/food_content/apple2.mdl",
	energy = 3,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Яйцо", "food_egg1", {
	model = "models/food_content/egg1.mdl",
	energy = 1,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 20,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Картофель", "food_potato", {
	model = "models/food_content/potato.mdl",
	energy = -10,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	onEaten = function(_, ply) ply:TakeHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Апельсин", "food_orange", {
	model = "models/food_content/orange.mdl",
	energy = 3,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Лук", "food_leek", {
	model = "models/food_content/leek.mdl",
	energy = 1,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Морковь", "food_carrot", {
	model = "models/food_content/carrot.mdl",
	energy = 2,
	--onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 25,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

--[[

DarkRP.createFood("Шоколад [10 | 9]", "food_chocolate", {
	model = "models/bioshockinfinite/hext_candy_chocolate.mdl",
	energy = 10,
	onEaten = function(_, ply) ply:AddHealth(9) end,
	price = 185,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Яблоко [35 | 7]", "food_apple", {
	model = "models/bioshockinfinite/hext_apple.mdl",
	energy = 35,
	onEaten = function(_, ply) ply:AddHealth(7) end,
	price = 280,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Апельсин [25 | 7]", "food_orange", {
	model = "models/bioshockinfinite/hext_orange.mdl",
	energy = 25,
	onEaten = function(_, ply) ply:AddHealth(7) end,
	price = 230,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Банан [30 | 7]", "food_banana", {
	model = "models/bioshockinfinite/hext_banana.mdl",
	energy = 30,
	onEaten = function(_, ply) ply:AddHealth(7) end,
	price = 255,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Груша [20 | 8]", "food_pear", {
	model = "models/bioshockinfinite/hext_pear.mdl",
	energy = 20,
	onEaten = function(_, ply) ply:AddHealth(8) end,
	price = 220,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Ананас [100 | 10]", "food_pineapple", {
	model = "models/bioshockinfinite/hext_pineapple.mdl",
	energy = 100,
	onEaten = function(_, ply) ply:AddHealth(10) end,
	price = 650,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Картошка [40 | 1]", "food_potato", {
	model = "models/bioshockinfinite/hext_potato.mdl",
	energy = 40,
	onEaten = function(_, ply) ply:AddHealth(1) end,
	price = 215,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Батон [70 | 3]", "food_loaf", {
	model = "models/bioshockinfinite/dread_loaf.mdl",
	energy = 70,
	onEaten = function(_, ply) ply:AddHealth(3) end,
	price = 395,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Хлопья [80 | 2]", "food_cornflakes", {
	model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl",
	energy = 80,
	onEaten = function(_, ply) ply:AddHealth(2) end,
	price = 430,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Сыр [85 | 6]", "food_cheese", {
	model = "models/bioshockinfinite/pound_cheese.mdl",
	energy = 85,
	onEaten = function(_, ply) ply:AddHealth(6) end,
	price = 515,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Шпроты [50 | 4]", "food_sprats", {
	model = "models/bioshockinfinite/cardine_can_open.mdl",
	energy = 50,
	onEaten = function(_, ply) ply:AddHealth(4) end,
	price = 310,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

DarkRP.createFood("Кукуруза [60 | 5]", "food_corn", {
	model = "models/bioshockinfinite/porn_on_cob.mdl",
	energy = 60,
	onEaten = function(_, ply) ply:AddHealth(5) end,
	price = 375,
	customCheck = canBuyFoodGSR,
	CustomCheckFailMsg = "У вас нет доступа к этому.",
})

--]]

local alcohol_list, restrictions, alcohol_func
if SERVER then
	alcohol_list = {
		sidr = {
			time = 60,
			hp = 5,
			random_vomit = 10,
		},
		pivo = {
			time = 120,
			hp = 10,
			random_vomit = 20,
			use = function(ply)
				if not ply._j_speed then
					local speed = ply:GetRunSpeed()
					ply._j_speed = speed
					ply:SetRunSpeed(speed + 50)
				end
			end,
			backup = function(ply)
				if ply._j_speed then
					ply:SetRunSpeed(ply._j_speed)
					ply._j_speed = nil
				end
			end,
			death_event = function(ply)
				if ply._j_speed then
					ply:SetRunSpeed(ply._j_speed)
					ply._j_speed = nil
				end
			end
		},
		whiskey = {
			time = 180,
			hp = 20,
			random_vomit = 20,
			use = function(ply)
				if not ply._j_power then
					local power = ply:GetJumpPower()
					ply._j_power = power
					ply:SetJumpPower(power + 50)
				end
			end,
			backup = function(ply)
				if ply._j_power then
					ply:SetJumpPower(ply._j_power)
					ply._j_power = nil
				end
			end,
			death_event = function(ply)
				if ply._j_power then
					ply:SetJumpPower(ply._j_power)
					ply._j_power = nil
				end
			end
		},
		vodka = {
			time = 240,
			random_vomit = 50,
			use = function(ply)
				ply:SetHealth(ply:Health() + 80)
				local ply_sid = ply:SteamID()
				timer.Create("ply_vodka_drinking_effect_" .. ply_sid, 1, 120, function()
					if IsValid(ply) and ply:Alive() and ply._drinking["vodka"] then
						local hp = ply:Health() - 1
						if hp <= 0 then
							ply:Kill()
						else
							ply:SetHealth(hp)
						end
					else
						timer.Remove("ply_vodka_drinking_effect_" .. ply_sid)
					end
				end)
			end,
			already = function(ply)
				local hp = ply:Health()
				if hp > 10 then
					ply:SetHealth(10)
					ply:Vomit()
				end
			end,
		},
		magicmilk = {
			noeffect = true,
			random_vomit = 0,
			use = function(ply)
				ply:SetHealth(ply:GetMaxHealth() or 100)
				ply:SetArmor(ply:GetMaxArmor() or 100)
				ply:setSelfDarkRPVar("Energy", 100)
				ply:SetRunSpeed(290)
				ply:SetJumpPower(290)
			end
		}
	}

	local teams = {
		[TEAM_ADMIN] = true,
		[TEAM_GMAN] = true
	}

	function restrictions(ply)
		return teams[ply:Team()] or ply:isOTA() or ply:isSynth() or ply:isZombie()
	end

	function alcohol_func(ply, kind)
		if IsValid(ply) and ply:Alive() then
			if restrictions(ply) then return end
			if ply:isVort() or ply:Team() == TEAM_GORDON then
				DarkRP.notify(ply, 0, 4, "Это на вас не действует.")
				return
			end

			if not ply._drinking then ply._drinking = {} end
			local alco_table = alcohol_list[kind]
			if not alco_table.noeffect then ply:SetLocalVar("drinking", true) end
			if alco_table.hp then
				local hp = ply:Health() - alco_table.hp
				if hp <= 0 then
					ply:Kill()
				else
					ply:SetHealth(hp)
				end
			end

			local rand = math.random(1, 100)
			if rand <= alco_table.random_vomit then ply:Vomit() end
			if not ply._drinking[kind] then
				ply._drinking[kind] = true
				if alco_table.use then alco_table.use(ply) end
				if alco_table.time and alco_table.time > 0 then
					local identifier = "alko_drinking_" .. kind .. "_" .. ply:SteamID()
					timer.Create(identifier, alco_table.time, 1, function()
						if IsValid(ply) and ply:Alive() and ply._drinking[kind] then
							if alco_table.backup then alco_table.backup(ply) end
							ply._drinking[kind] = nil
							ply:SetLocalVar("drinking", nil)
						else
							timer.Remove(identifier)
						end
					end)
				end
			else
				if alco_table.already then alco_table.already(ply) end
			end
		end
	end

	local function resetAlcoFunc(ply)
		if table.Count(ply._drinking or {}) > 0 then
			for k, v in pairs(ply._drinking) do
				local identifier = "alko_drinking_" .. k .. "_" .. ply:SteamID()
				timer.Remove(identifier)
				local alco_table = alcohol_list[k]
				if alco_table and alco_table.death_event then alco_table.death_event(ply) end
				ply._drinking[k] = nil
			end

			ply:SetLocalVar("drinking", nil)
		end
	end

	hook.Add("PlayerDeath", "resetAlcoholTimer", resetAlcoFunc)
	hook.Add("PlayerSilentDeath", "resetAlcoholTimer", resetAlcoFunc)
	hook.Add("OnPlayerChangedTeam", "resetAlcoholTimer", resetAlcoFunc)
end

local canBuyAlcoTab = {
	[TEAM_BICH3] = true,
	[TEAM_GSR3] = true,
	[TEAM_BEGLEC1] = true,
	[TEAM_FOODSHOP] = true,
}

local function canBuyAlco(ply)
	return canBuyAlcoTab[ply:Team()]
end

DarkRP.createFood("Сидр [20 | -5]", "alco_cider", {
	model = "models/props_junk/garbage_glassbottle003a.mdl",
	isAlco = "sidr",
	energy = 20,
	price = 200,
	requiresCook = false,
	customCheck = canBuyAlco,
	onEaten = function(_, ply) alcohol_func(ply, "sidr") end
})

DarkRP.createFood("Пиво [35 | -10]", "alco_beer", {
	model = "models/props_junk/garbage_glassbottle001a.mdl",
	isAlco = "pivo",
	energy = 35,
	price = 400,
	requiresCook = false,
	customCheck = canBuyAlco,
	onEaten = function(_, ply) alcohol_func(ply, "pivo") end
})

DarkRP.createFood("Виски [45 | -20]", "alco_whiskey", {
	model = "models/props_junk/glassjug01.mdl",
	isAlco = "whiskey",
	energy = 45,
	price = 500,
	requiresCook = false,
	customCheck = canBuyAlco,
	onEaten = function(_, ply) alcohol_func(ply, "whiskey") end
})

DarkRP.createFood("Водка [50 | ?]", "alco_vodka", {
	model = "models/props_junk/GlassBottle01a.mdl",
	isAlco = "vodka",
	energy = 55,
	price = 700,
	requiresCook = false,
	customCheck = canBuyAlco,
	onEaten = function(_, ply) alcohol_func(ply, "vodka") end
})

---[[
DarkRP.createFood("Волшебное молоко", "event_magic_milk", {
	model = "models/props_junk/garbage_milkcarton002a.mdl",
	energy = 100,
	price = 1,
	requiresCook = false,
	customCheck = function(ply) return false end,
	onEaten = function(_, ply) alcohol_func(ply, "magicmilk") end
})

--]]
DarkRP.DARKRP_LOADING = nil
