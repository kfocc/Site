--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
DarkRP.createEntity("Example entity", {
	ent = "money_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 1000,
	max = 2,
	cmd = "buyexample",
 
	-- The following fields are OPTIONAL. If you do not need them, or do not need to change them from their defaults, REMOVE them.
	allowed = {TEAM_GUN, TEAM_MOB},
	customCheck = function(ply) return ply:GetUserGroup() == "donator" end,
	CustomCheckFailMsg = function(ply, entTable) return "You need to be a donator to buy this entity!" end,
	getPrice = function(ply, price) return ply:GetUserGroup() == "donator" and price * 0.9 or price end,
	getMax = function(ply) return ply:GetUserGroup() == "donator" and 10 or 2 end,
        spawn = function(ply, tr, tblEnt) return ents.Create("prop_physics") end, -- function to override spawning mechanics. MUST return an entity!
        category = "Other", -- The name of the category it is in. Note: the category must be created!
        sortOrder = 100, -- The position of this thing in its category. Lower number means higher up.
})
---------------------------------------------------------------------------]]
AddEntity("Принтер [Бронза]", {
	ent = "rx_printer_1",
	model = "models/props_c17/consolebox01a.mdl",
	price = 2500,
	max = 1,
	cmd = "buymoneyprinter1",
	allowed = {TEAM_FOODSHOP, TEAM_BEGLEC1, TEAM_AGENT, TEAM_BEGLEC2, TEAM_BEGLEC3, TEAM_GSR1, TEAM_GSR2, TEAM_GSR3, TEAM_GSR4, TEAM_GSR5, TEAM_BICH1, TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3, TEAM_BICH2, TEAM_BICH3, TEAM_GANG1, TEAM_GANG2, TEAM_GANG3, TEAM_GANG4, TEAM_GANG5, TEAM_GANG6, TEAM_GANG7, TEAM_GUNSHOP, TEAM_GMED, TEAM_GFAST, TEAM_ARMY, TEAM_GSPY, TEAM_BANG1, TEAM_KLEINER, TEAM_BARNEY, TEAM_ALYX, TEAM_GORDON, TEAM_ELITE1, TEAM_ELITE2, TEAM_ELITE3, TEAM_ELITE4, TEAM_ELITE5, TEAM_BAND1, TEAM_BAND2, TEAM_BAND3, TEAM_BAND4, TEAM_AFERIST, TEAM_GANG8, TEAM_GPYRO}
})

AddEntity("Принтер [Кристал]", {
	ent = "rx_printer_2",
	model = "models/props_c17/consolebox01a.mdl",
	price = 5000,
	max = 1,
	cmd = "buymoneyprinter2",
	allowed = {TEAM_FOODSHOP, TEAM_BEGLEC1, TEAM_AGENT, TEAM_BEGLEC2, TEAM_BEGLEC3, TEAM_GSR1, TEAM_GSR2, TEAM_GSR3, TEAM_GSR4, TEAM_GSR5, TEAM_CITIZEN2, TEAM_BICH1, TEAM_CITIZEN1, TEAM_CITIZEN3, TEAM_BICH2, TEAM_BICH3, TEAM_GANG1, TEAM_GANG2, TEAM_GANG3, TEAM_GANG4, TEAM_GANG5, TEAM_GANG6, TEAM_GANG7, TEAM_GUNSHOP, TEAM_GMED, TEAM_GFAST, TEAM_ARMY, TEAM_GSPY, TEAM_BANG1, TEAM_KLEINER, TEAM_BARNEY, TEAM_ALYX, TEAM_GORDON, TEAM_ELITE1, TEAM_ELITE2, TEAM_ELITE3, TEAM_ELITE4, TEAM_ELITE5, TEAM_BAND1, TEAM_BAND2, TEAM_BAND3, TEAM_BAND4, TEAM_AFERIST, TEAM_GANG8, TEAM_GPYRO}
})

AddEntity(" Принтер", {
	ent = "rx_printer_3",
	model = "models/props_c17/consolebox01a.mdl",
	price = 10000,
	vip = true,
	max = 1,
	cmd = "buymoneyprinter3",
	allowed = {TEAM_FOODSHOP, TEAM_BEGLEC1, TEAM_BEGLEC2, TEAM_AGENT, TEAM_BEGLEC3, TEAM_GSR1, TEAM_GSR2, TEAM_GSR3, TEAM_GSR4, TEAM_GSR5, TEAM_BICH1, TEAM_CITIZEN1, TEAM_CITIZEN3, TEAM_BICH2, TEAM_BICH3, TEAM_GANG1, TEAM_GANG2, TEAM_GANG3, TEAM_GANG4, TEAM_GANG5, TEAM_GANG6, TEAM_GANG7, TEAM_GUNSHOP, TEAM_GMED, TEAM_GFAST, TEAM_ARMY, TEAM_GSPY, TEAM_BANG1, TEAM_KLEINER, TEAM_BARNEY, TEAM_ALYX, TEAM_GORDON, TEAM_ELITE1, TEAM_ELITE2, TEAM_ELITE3, TEAM_ELITE4, TEAM_ELITE5, TEAM_BAND1, TEAM_BAND2, TEAM_BAND3, TEAM_BAND4, TEAM_AFERIST, TEAM_GANG8, TEAM_GPYRO},
	customCheck = function(ply) return CLIENT or table.HasValue({"superadmin", "vip", "operator", "moderator", "administrator", "assistant_nabor", "advisor_nabor", "administrator_custom", "event_boss_nabor", "event_nabor"}, ply:GetUserGroup()) end,
	CustomCheckFailMsg = "Этот принтер только для VIP игроков!",
})

AddEntity("Принтер [Нефрит]", {
	ent = "rx_printer_4",
	model = "models/props_c17/consolebox01a.mdl",
	price = 2500,
	max = 1,
	cmd = "buymoneyprinter4",
	allowed = {TEAM_NONE}
})

AddEntity("Радио", {
	ent = "radio_music",
	model = "models/props_lab/citizenradio.mdl",
	price = 1000,
	max = 1,
	cmd = "buymusicradio",
	allowed = {TEAM_FOODSHOP, TEAM_BEGLEC3, TEAM_BICH3, TEAM_GSR3, TEAM_GSR4, TEAM_GSR5, TEAM_GSR6, TEAM_GUNSHOP, TEAM_KLEINER}
})

AddEntity("Записка", {
	ent = "paper",
	model = "models/props_office/notepad_office.mdl",
	price = 300,
	max = 5,
	cmd = "buypapernudes",
	allowed = {TEAM_FOODSHOP, TEAM_BEGLEC1, TEAM_BEGLEC2, TEAM_AGENT, TEAM_BEGLEC3, TEAM_CITIZEN2, TEAM_GSR1, TEAM_GSR2, TEAM_GSR3, TEAM_GSR4, TEAM_GSR5, TEAM_GSR6, TEAM_BICH1, TEAM_CITIZEN1, TEAM_CITIZEN3, TEAM_BICH2, TEAM_BICH3, TEAM_GANG1, TEAM_GANG2, TEAM_GANG3, TEAM_GANG4, TEAM_GANG5, TEAM_GANG6, TEAM_GANG7, TEAM_GUNSHOP, TEAM_GMED, TEAM_GFAST, TEAM_ARMY, TEAM_GSPY, TEAM_BANG1, TEAM_KLEINER, TEAM_BARNEY, TEAM_ALYX, TEAM_GORDON, TEAM_ELITE1, TEAM_ELITE2, TEAM_ELITE3, TEAM_ELITE4, TEAM_ELITE5, TEAM_BAND1, TEAM_BAND2, TEAM_BAND3, TEAM_BAND4, TEAM_AFERIST, TEAM_GANG8, TEAM_MAYOR, TEAM_CMD1, TEAM_CMD2, TEAM_CMD3, TEAM_CMD4, TEAM_MPF5, TEAM_MPF11, TEAM_GPYRO}
})

AddEntity("Документ", {
	ent = "paper_doc",
	model = "models/props_office/notepad_office.mdl",
	price = 300,
	max = 5,
	cmd = "buypapernudesdoc",
	allowed = {TEAM_MAYOR}
})

AddEntity("Корзина для заключенных", {
	ent = "arrest_spawn_basket",
	model = "models/props_junk/PlasticCrate01a.mdl",
	price = 500,
	max = 1,
	cmd = "buyarrestbasket",
	customCheck = function(ply) return ply:isArrested() end,
	CustomCheckFailMsg = "Этот предмет только для заключенных!",
})
