--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
http://wiki.darkrp.com/index.php/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]
DarkRP.createCategory{
	name = "Business", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(0, 107, 0, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "Police", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(0, 56, 255, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 50, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "Others", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(255, 0, 0, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 51, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "Fugitive", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(255, 0, 0, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 52, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "Ganger", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(255, 0, 0, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 60, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "Администрация",
	categorises = "jobs",
	startExpanded = true,
	color = Color(0, 25, 255, 255),
	canSee = function(ply)
		return table.HasValue({"superadmin", "admin", "Owner", "Zam Owner", "Uber Admin", "moderator"}, ply:GetUserGroup())
	end,
	sortOrder = 25,
}

DarkRP.createCategory{
	name = "Synth", -- The name of the category.
	categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
	startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
	color = Color(75, 75, 75, 255), -- The color of the category header.
	canSee = function(ply)
		return true -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
	end,
	sortOrder = 70, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}

DarkRP.createCategory{
	name = "VIP",
	categorises = "jobs",
	startExpanded = true,
	color = Color(20, 255, 0, 255),
	canSee = function(ply)
		return table.HasValue({"superadmin", "admin", "Owner", "Zam Owner", "Uber Admin", "VIP", "premium", "moderator"}, ply:GetUserGroup())
	end,
	sortOrder = 26,
}

DarkRP.createCategory{
	name = "Денежные принтеры",
	categorises = "entities",
	startExpanded = true,
	color = Color(19, 176, 186, 255),
	canSee = function(ply) return true end,
	sortOrder = 25,
}

--[[]DarkRP.createCategory{
   name = "VIP Денежные принтеры",
   categorises = "entities",
   startExpanded = true,
   color = Color(19, 176, 186, 255),
   canSee = function(ply) return table.HasValue({"superadmin","admin","Owner","Zam Owner","Uber Admin","VIP","premium","moderator"}, ply:GetUserGroup()) end,
   sortOrder = 26,
}]]

DarkRP.createCategory{
	name = "Безопасность",
	categorises = "entities",
	startExpanded = true,
	color = Color(25, 21, 175, 255),
	canSee = function(ply) return true end,
	sortOrder = 22,
}
