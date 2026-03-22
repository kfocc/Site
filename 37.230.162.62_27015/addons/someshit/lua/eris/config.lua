Eris.Config = {}
local cfg = Eris.Config
//-------------------------------------


//Should we use the workshop instead of FastDL?
cfg.UseWorkshop = true
if(SERVER) then return end //do not delete this line


cfg.ServerText = "UnionRP"

//Should we let people click on their names to change them?
cfg.AllowNameChange = true

//Should the tabs be completely rectangular instead of having triangular ends?
cfg.SquareTabs = false

//Should we show items which have failed custom checks instead of hiding them outright?
cfg.ShowCustomChecks = true

//Should we remember which tab the player closed the menu on and re-open that same tab later?
cfg.SaveTab = true

//What is the default theme?
cfg.Theme = "flat"

//Should we let players choose their own themes?
cfg.ThemesEnabled = true

//What ranks should count as online staff?
cfg.StaffRanks = {
	["overwatch"] = true,
	["moderator"] = true,
	["administrator"] = true,
	["administrator_custom"] = true,
	["operator"] = true,
	["operator_nabor"] = true,
	["moderator_nabor"] = true,
	["assistant_nabor"] = true,
	["administrator_nabor"] = true,
	["head_admin_nabor"] = true,
	["advisor_nabor"] = true,
	["event_boss_nabor"] = true,
	["event_nabor"] = true,
}

//Should we display the model at the top, through which the menu and dashboard can be closed and opened?
cfg.ModelEnabled = true

//Should we display a bar with the name of the currently active panel below the model?
cfg.TitleBarEnabled = true

//Should we show the close button on the right of the title bar if it"s enabled?
//Only use this if you have the model disabled, as clicking it closes the menu.
cfg.CloseButtonEnabled = true

//How many staff avatars should be shown in each row on the dashboard?
cfg.StaffRowSize = 5

//Should we have a radial glow in the middle of the pie charts on the dashboard?
cfg.PieGlow = false

//Should we center the website preloader to the entire f4 menu, or jusst the inner container?
cfg.CenterPreloader = true

//Should we use the same color for job backdrops as we do for all other items, instead of the job"s color?
cfg.UnifyJobBackdrops = false


/*---------------------------------------------------------------------------
	Tabs
---------------------------------------------------------------------------*/
Eris.Tabs = {}

--[[Eris:AddTab("Jobs", {
	icon = "jobs",
	jobs = true
})]]

Eris:AddTab("Еда [Голод | ХП]", {
	icon = "food",
	food = true
})

Eris:AddDivider("Оружие", "Shipments")

Eris:AddTab("Оружие", {
	icon = "weapons",
	weapons = true
})

Eris:AddTab("Коробки", {
	icon = "shipments",
	shipments = true
})

Eris:AddDivider("Патроны", "Ammo")

Eris:AddTab("Патроны", {
	icon = "ammo",
	ammo = true
})

Eris:AddTab("Предметы", {
	icon = "entities",
	entities = true
})

--[[Eris:AddTab("Vehicles", {
	icon = "vehicles",
	vehicles = true
})]]


//UNCOMMENT THIS IF YOU WANT A TAB FOR THE DASHBOARD
Eris:AddDivider("Статистика", "Dashboard")
Eris:AddTab("Статистика", {
	icon = "dashboard",
	dashboard = true
})


/*---------------------------------------------------------------------------
	Set info to true on these so they will show in the info pane
---------------------------------------------------------------------------*/
Eris:AddTab("Сайт", {
	website = "https://unionrp.info",
	icon = "website",
	info = true
})

Eris:AddTab("Форум", {
	website = "https://f.unionrp.info",
	icon = "forums",
	info = true
})

Eris:AddTab("Правила", {
	website = "https://f.unionrp.info/forums/rules/",
	icon = "lockdown",
	info = true
})

Eris:AddTab("Discord", {
	website = "https://discord.com/invite/fXPnzkb",
	icon = "advert",
	info = true
})

Eris:AddTab("Группа VK", {
	website = "https://vk.com/union_hl2",
	icon = "lawboard",
	info = true
})

Eris:AddTab("Группа STEAM", {
	website = "https://steamcommunity.com/groups/union_rp",
	icon = "steamgroup",
	info = true
})

Eris:AddTab("Контент", {
	website = "https://steamcommunity.com/sharedfiles/filedetails/?id=1435279271",
	icon = "collection",
	info = true
})

Eris:AddTab("Донат", {
	chat = "/donate",
	icon = "donate",
	info = true
})



/*---------------------------------------------------------------------------
	Commands
---------------------------------------------------------------------------*/
Eris.Commands = {}

Eris:AddCommand("Drop Money", {
	icon = "dropmoney",
	dropmoney = true
})

Eris:AddCommand("Drop Weapon", {
	icon = "dropweapon",
	dropweapon = true
})

Eris:AddCommand("Change Name", {
	icon = "changename",
	changename = true
})

Eris:AddCommand("Change Job", {
	icon = "changejob",
	changejob = true
})

Eris:AddCommand("Sleep/Wake Up", {
	icon = "sleep",
	sleep = true
})

Eris:AddCommand("Request License", {
	icon = "requestlicense",
	requestlicense = true
})

Eris:AddCommand("Advert", {
	icon = "advert",
	advert = true
})

Eris:AddCommand("Want Someone", {
	icon = "wanted",
	wanted = true
})

Eris:AddCommand("Issue a Warrant", {
	icon = "warrant",
	warrant = true
})

Eris:AddCommand("Lockdown", {
	icon = "lockdown",
	lockdown = true
})

Eris:AddCommand("Place Lawboard", {
	icon = "lawboard",
	lawboard = true
})


//Language strings.
cfg.Language = {
	check_failed = "Недостаточно прав.",
	cannot_afford = "Вы не можете себе позволить это.",
	already_have_job = "You already have this job.",
	job_full = "This job is full.",
	staff = "Админы",
	commands = "Команды",
	yes = "Да",
	stats = "Статистика",
	players_online = "Игроки",
	money = "Деньги",
	job_distribution = "Работы",
	game = "Игра",
	info = "Ссылки",
	name_change = "Изменение имени",
	name_change_text = "Какое имя вы хотите?",
	change_name = "Изменить",
	themes = "Темы",
	dashboard = "Статистика",
	cannot_change_theme = "Нужно быть VIP",
	max = "Макс "
}