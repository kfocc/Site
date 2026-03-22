AddCSLuaFile()

--[[
	registerItem("ID предмета, должен быть уникальным", {
		name = "Комплект одежды",
		swep = "mask1",
		price = 900,
		model = "models/weapons/w_packatm.mdl",
		desc = "Новая, упакованная униформа..",
		jobs = {
			[TEAM_BAND1] = true,
			[TEAM_BAND2] = true,
			[TEAM_BAND3] = true,
			[TEAM_BAND4] = true,
			[TEAM_GANG1] = true
		},
    customCheck = function(ply)
      return true
    end,
    func = function(ply)
      local listed = {}
      for k,v in pairs(RPExtraTeams) do
        if v.cp then continue end
        if v.acceptedMaskFor then
          table.insert(listed,k)
        end
      end
      deceive.Disguise(ply, table.Random(listed))
    end,
	})
--]]
local wepsList = weapons_give_npc.weps
local itemsByID = {}
local function registerItem(id, data)
	data.id = id
	data.index = itemsByID[id] and itemsByID[id].index or #wepsList + 1
	wepsList[data.index] = data
	itemsByID[id] = data
end

function ENT:GetItemByID(id)
	return itemsByID[id]
end

weapons_give_npc.jobs = {
	[TEAM_BICH1] = true,
	[TEAM_BAND1] = true,
	[TEAM_BAND2] = true,
	[TEAM_BAND3] = true,
	[TEAM_BAND4] = true,
	[TEAM_AFERIST] = true
}

-- БАНДИТЫ ХОЛОДНОЕ
registerItem("hammer", {
	name = "Молоток",
	swep = "tfa_nmrih_bcd",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 150,
	model = "models/weapons/tfa_nmrih/w_tool_barricade.mdl",
	desc = "Где нужно забить гвоздь?"
})

registerItem("pipe", {
	name = "Труба",
	swep = "tfa_nmrih_lpipe",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 200,
	model = "models/weapons/tfa_nmrih/w_me_pipe_lead.mdl",
	desc = "А ты точно сантехник?"
})

registerItem("machete", {
	name = "Мачете",
	swep = "tfa_nmrih_machete",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 400,
	model = "models/weapons/tfa_nmrih/w_me_machete.mdl",
	desc = "Мачете убивает!"
})

registerItem("sledge", {
	name = "Молот",
	swep = "tfa_nmrih_sledge",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 700,
	model = "models/weapons/tfa_nmrih/w_me_sledge.mdl",
	desc = "Опасная штучка..."
})

-- БАНДИТЫ ПИСТОЛЕТЫ
registerItem("g_beretta", {
	name = "Beretta",
	swep = "tfa_svencoop_handgun",
	jobs = {
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 300,
	model = "models/weapons/svencoop/w_9mmhandgun.mdl",
	desc = "Страна производитель: Италия"
})

registerItem("g_m1911", {
	name = "M1911",
	swep = "tfa_svencoop_th_1911",
	jobs = {
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 350,
	model = "models/weapons/svencoop/th/w_1911.mdl",
	desc = "Страна производитель: США"
})

registerItem("g_k5", {
	name = "Daewoo K5",
	swep = "tfa_cso2_k5",
	jobs = {
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 400,
	model = "models/weapons/tfa_cso2/w_k5.mdl",
	desc = "Страна производитель: Корея"
})

registerItem("g_revolver", {
	name = "Colt Detective",
	swep = "tfa_svencoop_th_revolver",
	jobs = {
		-- [TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 800,
	model = "models/weapons/svencoop/th/w_th_38.mdl",
	desc = "Труднодоступный товар! Цена завышена"
})

registerItem("g_deagle", {
	name = "Desert Eagle",
	swep = "tfa_svencoop_deagle",
	jobs = {
		-- [TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 900,
	model = "models/weapons/svencoop/w_desert_eagle.mdl",
	desc = "Труднодоступный товар! Цена завышена"
})

registerItem("g_anaconda", {
	name = "Colt Anaconda",
	swep = "tfa_cso2_anaconda",
	jobs = {
		-- [TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 1000,
	model = "models/weapons/tfa_cso2/w_anaconda.mdl",
	desc = "Труднодоступный товар! Цена завышена"
})

-- БАНДИТЫ ПП
registerItem("g_uzi", {
	name = "UZI",
	swep = "tfa_svencoop_uzi",
	jobs = {
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 700,
	model = "models/weapons/svencoop/w_uzi.mdl",
	desc = "Страна производитель: Израиль"
})

registerItem("g_tmp", {
	name = "Steyr TMP",
	swep = "tfa_cso2_tmp",
	jobs = {
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 800,
	model = "models/weapons/tfa_cso2/w_tmp.mdl",
	desc = "Страна производитель: Австрия"
})

registerItem("g_greasegun", {
	name = "M3 Grease",
	swep = "tfa_svencoop_th_greasegun",
	jobs = {
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 900,
	model = "models/weapons/svencoop/th/w_greasegun.mdl",
	desc = "Страна производитель: США"
})

registerItem("g_mp7", {
	name = "MP7A1",
	swep = "tfa_cso2_mp7",
	jobs = {
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 1000,
	model = "models/weapons/tfa_cso2/w_mp7.mdl",
	desc = "Страна производитель: Германия"
})

registerItem("g_p90", {
	name = "FN P90",
	swep = "tfa_cso2_p90",
	jobs = {
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 1800,
	model = "models/weapons/tfa_cso2/w_p90.mdl",
	desc = "Труднодоступный товар! Цена завышена"
})

-- БАНДИТЫ ВИНТОВКИ
registerItem("g_m16", {
	name = "Colt AR-15",
	swep = "tfa_svencoop_th_m16",
	jobs = {
		[TEAM_BAND4] = true
	},
	price = 1500,
	model = "models/weapons/svencoop/th/w_th_m16.mdl",
	desc = "Страна производитель: США"
})

registerItem("g_mk18", {
	name = "MK-18",
	swep = "tfa_cso2_mk18",
	jobs = {
		[TEAM_BAND4] = true
	},
	price = 1500,
	model = "models/weapons/tfa_cso2/w_mk18.mdl",
	desc = "Страна производитель: Китай"
})

registerItem("g_m3", {
	name = "Benelli M3",
	swep = "tfa_cso2_m3",
	jobs = {
		[TEAM_BAND4] = true
	},
	price = 2000,
	model = "models/weapons/tfa_cso2/w_m3.mdl",
	desc = "Страна производитель: Италия"
})

registerItem("g_scout", {
	name = "Scout",
	swep = "tfa_cso2_scout",
	jobs = {
		[TEAM_BAND4] = true
	},
	price = 2500,
	model = "models/weapons/tfa_cso2/w_scout.mdl",
	desc = "Страна производитель: Австрия"
})

-- БАНДИТЫ ВЗЛОМ
registerItem("g_lockpick", {
	name = "Отмычка",
	swep = "lockpick",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 500,
	model = "models/weapons/w_crowbar.mdl",
	desc = "Просто вставь ее в нужную щель"
})

registerItem("g_cracker", {
	name = "Взломщик барьеров",
	swep = "keypad_cracker",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 500,
	model = "models/weapons/w_emptool.mdl",
	desc = "Странная штука... Но ей можно взломать силовое поле."
})

-- БАНДИТЫ РАЗНОЕ
registerItem("cid_new", {
	name = "CID-Карта",
	swep = "cid_new",
	jobs = {
		[TEAM_BICH1] = true,
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 500,
	model = "models/dorado/tarjeta3.mdl",
	desc = "Фальшивая CID-карта гражданина"
})

/*registerItem("armor_3", {
	name = "Усиленная пластина",
	swep = "item_armor_3",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 1400,
	model = "models/plates/plate_heavy.mdl",
	desc = "Пластина, устанавливает 100 единиц брони"
})*/

registerItem("armor_2", {
	name = "Средняя пластина",
	swep = "item_armor_2",
	jobs = {
		-- [TEAM_BAND1] = true,
		-- [TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 700,
	model = "models/plates/plate_medium.mdl",
	desc = "Пластина, устанавливает 50 единиц брони"
})

registerItem("armor_1", {
	name = "Легкая пластина",
	swep = "item_armor_1",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 350,
	model = "models/plates/plate_light.mdl",
	desc = "Пластина, устанавливает 25 единиц брони"
})

registerItem("flashlight", {
	name = "Фонарик",
	customCheck = function(ply) if ply:GetNetVar("flashlight") then return false, "У Вас уже есть фонарик." end end,
	func = function(ply)
		ply:SetNetVar("flashlight", true)
		DarkRP.notify(ply, 0, 4, "Теперь Вы можете использовать фонарик.")
	end,
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 300,
	model = "models/raviool/flashlight.mdl",
	desc = "Обычный фонарик на батарейках"
})

registerItem("maska", {
	name = "Маска",
	customCheck = function(ply)
		if not ply:getJobTable().canusebandmask then return false, "Кажется, эта вещь бесполезна для Вас." end
		if ply:GetNetVar("bandana.CanUse") then return false, "У Вас уже есть это." end
	end,
	func = function(ply)
		ply:SetNetVar("bandana.CanUse", true)
		DarkRP.notify(ply, 0, 4, "Теперь Вы можете надевать и снимать маску.")
	end,
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 300,
	model = "models/tnb/items/facewrap.mdl",
	desc = "Поможет скрыть вашу личность"
})

registerItem("disguise_briefcase", {
	name = "Маскировка",
	swep = "swep_disguise_briefcase",
	jobs = {
		[TEAM_AFERIST] = true
	},
	price = 500,
	model = "models/props_c17/SuitCase_Passenger_Physics.mdl",
	desc = "Поможет сменить образ"
})

registerItem("cuff_screeds", {
	name = "Стяжки",
	swep = "ent_screeds",
	jobs = {
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true
	},
	price = 1000,
	model = "models/props_junk/cardboard_box004a.mdl",
	desc = "Одноразовые наручники"
})

-- ПОВСТАНЦЫ ПИСТОЛЕТЫ
registerItem("beretta", {
	name = "Beretta",
	swep = "tfa_svencoop_handgun",
	jobs = {
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 100,
	model = "models/weapons/svencoop/w_9mmhandgun.mdl",
	desc = "Страна производитель: Италия"
})

registerItem("m1911", {
	name = "M1911",
	swep = "tfa_svencoop_th_1911",
	jobs = {
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 110,
	model = "models/weapons/svencoop/th/w_1911.mdl",
	desc = "Страна производитель: США"
})

registerItem("k5", {
	name = "Daewoo K5",
	swep = "tfa_cso2_k5",
	jobs = {
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 120,
	model = "models/weapons/tfa_cso2/w_k5.mdl",
	desc = "Страна производитель: Корея"
})

registerItem("usp_match", {
	name = "USP Match",
	swep = "tfa_usp_match",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		--[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 130,
	model = "models/weapons/w_pistol.mdl",
	desc = "Производитель: Альянс"
})

registerItem("usp_kmatch", {
	name = "USP Kmatch",
	swep = "tfa_usp_kmatch",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		--[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 140,
	model = "models/weapons/metropolice_smg/usp/w_usp_match.mdl",
	desc = "Производитель: Альянс"
})

registerItem("mk23", {
	name = "MK23",
	swep = "tfa_cso2_mk23",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 150,
	model = "models/weapons/tfa_cso2/w_mk23.mdl",
	desc = "Страна производитель: Германия, США"
})

registerItem("revolver", {
	name = "Colt Detective",
	swep = "tfa_svencoop_th_revolver",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 160,
	model = "models/weapons/svencoop/th/w_th_38.mdl",
	desc = "Страна производитель: США"
})

registerItem("deagle", {
	name = "Desert Eagle",
	swep = "tfa_svencoop_deagle",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 170,
	model = "models/weapons/svencoop/w_desert_eagle.mdl",
	desc = "Страна производитель: США, Израиль"
})

registerItem("anaconda", {
	name = "Colt Anaconda",
	swep = "tfa_cso2_anaconda",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 180,
	model = "models/weapons/tfa_cso2/w_anaconda.mdl",
	desc = "Страна производитель: США"
})

registerItem("alyxgun", {
	name = "Alyx Gun",
	swep = "tfa_alyxgun",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		[TEAM_ALYX] = true -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true -- Шпион [HYDRA]
		--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 190,
	model = "models/weapons/w_alyx_gun.mdl",
	desc = "Производитель: Сопротивление"
})

-- ПОВСТАНЦЫ ПП
registerItem("uzi", {
	name = "UZI",
	swep = "tfa_svencoop_uzi",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 240,
	model = "models/weapons/svencoop/w_uzi.mdl",
	desc = "Страна производитель: Израиль"
})

registerItem("tmp", {
	name = "Steyr TMP",
	swep = "tfa_cso2_tmp",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true -- Шпион [HYDRA]
	},
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 260,
	model = "models/weapons/tfa_cso2/w_tmp.mdl",
	desc = "Страна производитель: Австрия"
})

registerItem("smg", {
	name = "MP7 CMB",
	swep = "tfa_mp7_l",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true -- Шпион [HYDRA]
	},
	price = 280,
	model = "models/weapons/w_smg1.mdl",
	desc = "Производитель: Альянс"
})

registerItem("m3greasegun", {
	name = "M3 Grease",
	swep = "tfa_svencoop_th_greasegun",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 300,
	model = "models/weapons/svencoop/th/w_greasegun.mdl",
	desc = "Страна производитель: США"
})

registerItem("mp7", {
	name = "MP7A1",
	swep = "tfa_cso2_mp7",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 320,
	model = "models/weapons/tfa_cso2/w_mp7.mdl",
	desc = "Страна производитель: Германия"
})

registerItem("p90", {
	name = "FN P90",
	swep = "tfa_cso2_p90",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 340,
	model = "models/weapons/tfa_cso2/w_p90.mdl",
	desc = "Страна производитель: Бельгия"
})

registerItem("smg2", {
	name = "MP7 CMB+",
	swep = "tfa_mp7_pdw",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	},
	price = 360,
	model = "models/weapons/w_mp7+.mdl",
	desc = "Производитель: Альянс"
})

registerItem("smg3", {
	name = "MP9 CMB",
	swep = "tfa_mp9_cqc",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	},
	price = 380,
	model = "models/weapons/w_smg3.mdl",
	desc = "Производитель: Альянс"
})

-- ПОВСТАНЦЫ ДРОБОВИКИ
registerItem("m3", {
	name = "Benelli M3",
	swep = "tfa_cso2_m3",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 340,
	model = "models/weapons/tfa_cso2/w_m3.mdl",
	desc = "Страна производитель: Италия"
})

registerItem("xm1014", {
	name = "XM-1014",
	swep = "tfa_cso2_xm1014",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 360,
	model = "models/weapons/tfa_cso2/w_xm1014.mdl",
	desc = "Страна производитель: Италия"
})

registerItem("spas12", {
	name = "SPAS-12",
	swep = "tfa_spas12",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true -- Техник сопротивления
	},
	--[TEAM_GORDON] = true -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 380,
	model = "models/weapons/w_shotgun.mdl",
	desc = "Производитель: Альянс"
})

registerItem("m870", {
	name = "M870",
	swep = "tfa_cso2_m870",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 400,
	model = "models/weapons/tfa_cso2/w_m870.mdl",
	desc = "Страна производитель: США"
})

registerItem("spas14", {
	name = "SPAS-14",
	swep = "tfa_spas14",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		[TEAM_ALYX] = true -- Техник сопротивления
	},
	--[TEAM_GORDON] = true -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 420,
	model = "models/weapons/metropolice_smg/spas12/w_spas12.mdl",
	desc = "Производитель: Альянс"
})

registerItem("dbarrel", {
	name = "Double Defence",
	swep = "tfa_cso2_dbarrel",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true -- Ученый сопротивления
	},
	--[TEAM_BARNEY] = true, -- Коммандер сопротивления
	--[TEAM_ALYX] = true -- Техник сопротивления
	--[TEAM_GORDON] = true, -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 500,
	model = "models/weapons/tfa_cso2/w_dbarrel.mdl",
	desc = "Страна производитель: Турция"
})

-- ПОВСТАНЦЫ ВИНТОВКИ
registerItem("m16", {
	name = "Colt AR-15",
	swep = "tfa_svencoop_th_m16",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 300,
	model = "models/weapons/svencoop/th/w_th_m16.mdl",
	desc = "Страна производитель: США"
})

registerItem("m1903a3", {
	name = "Springfield",
	swep = "tfa_cso2_m1903a3",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	},
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 320,
	model = "models/weapons/tfa_cso2/w_m1903a3.mdl",
	desc = "Страна производитель: США"
})

registerItem("mk18", {
	name = "MK-18",
	swep = "tfa_cso2_mk18",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 340,
	model = "models/weapons/tfa_cso2/w_mk18.mdl",
	desc = "Страна производитель: Китай"
})

registerItem("acr", {
	name = "Masada",
	swep = "tfa_cso2_acr",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 360,
	model = "models/weapons/tfa_cso2/w_acr.mdl",
	desc = "Страна производитель: США"
})

registerItem("m4a1", {
	name = "M4A1",
	swep = "tfa_cso2_m4a1",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 380,
	model = "models/weapons/tfa_cso2/w_m4a1.mdl",
	desc = "Страна производитель: США"
})

registerItem("scopedar2", {
	name = "AR2",
	swep = "tfa_hl2_scopedar2",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
	},
	--[TEAM_ALYX] = true, -- Техник сопротивления
	--[TEAM_GORDON] = true, -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 400,
	model = "models/weapons/w_irifle.mdl",
	desc = "Производитель: Альянс"
})

registerItem("ak12", {
	name = "AK-12",
	swep = "tfa_cso2_ak12",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 400,
	model = "models/weapons/tfa_cso2/w_ak12.mdl",
	desc = "Страна производитель: Россия"
})

registerItem("m16m203", {
	name = "M16M203",
	swep = "tfa_cso2_m16m203",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true -- Повстанец [Подрывник]
	},
	--[TEAM_KLEINER] = true, -- Ученый сопротивления
	--[TEAM_BARNEY] = true, -- Коммандер сопротивления
	--[TEAM_ALYX] = true, -- Техник сопротивления
	--[TEAM_GORDON] = true, -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 440,
	model = "models/weapons/tfa_cso2/w_m16m203.mdl",
	desc = "Страна производитель: США"
})

registerItem("k2c", {
	name = "K2C",
	swep = "tfa_cso2_k2c",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 460,
	model = "models/weapons/tfa_cso2/w_k2c.mdl",
	desc = "Страна производитель: Южная Корея"
})

registerItem("scarh", {
	name = "SCAR-H",
	swep = "tfa_cso2_scarh",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 480,
	model = "models/weapons/tfa_cso2/w_scarh.mdl",
	desc = "Страна производитель: Бельгия, США"
})

registerItem("k12", {
	name = "K12",
	swep = "tfa_cso2_k12",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true -- Ученый сопротивления
		--[TEAM_BARNEY] = true -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/weapons/tfa_cso2/w_k12.mdl",
	desc = "Страна производитель: Южная Корея"
})

-- ПОВСТАНЦЫ СНАЙПЕРКИ
registerItem("dragunov", {
	name = "Dragunov",
	swep = "cod4_dragunov_c",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
	},
	--[TEAM_GANG7] = true, -- Повстанец [Мастер]
	--[TEAM_GSPY] = true, -- Партизан
	--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
	--[TEAM_KLEINER] = true, -- Ученый сопротивления
	--[TEAM_BARNEY] = true, -- Коммандер сопротивления
	--[TEAM_ALYX] = true, -- Техник сопротивления
	--[TEAM_GORDON] = true, -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 400,
	model = "models/weapons/w_cod4_drag.mdl",
	desc = "Страна производитель: СССР"
})

registerItem("barrett", {
	name = "Barrett M82",
	swep = "cod4_barrett_new",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_GANG8] = true -- Повстанец [Подрывник]
		--[TEAM_GORDON] = true -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true -- Снайпер [HYDRA]
	},
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 440,
	model = "models/weapons/w_cod4_barrett50cal.mdl",
	desc = "Страна производитель: США"
})

registerItem("fireshot", {
	name = "Поджигающий арбалет",
	swep = "tfa_crossbow_fire",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
	},
	--[TEAM_GANG7] = true, -- Повстанец [Мастер]
	--[TEAM_GSPY] = true, -- Партизан
	--[TEAM_GANG8] = true -- Повстанец [Подрывник]
	--[TEAM_KLEINER] = true -- Ученый сопротивления
	--[TEAM_BARNEY] = true -- Коммандер сопротивления
	--[TEAM_ALYX] = true, -- Техник сопротивления
	--[TEAM_GORDON] = true -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 480,
	model = "models/weapons/w_crossbow.mdl",
	desc = "Производитель: Сопротивление"
})

-- ВЗРЫВНОЕ
registerItem("m79", {
	name = "M79",
	swep = "tfa_cso2_m79",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true -- Повстанец [Подрывник]
	},
	--[TEAM_KLEINER] = true, -- Ученый сопротивления
	--[TEAM_BARNEY] = true, -- Коммандер сопротивления
	--[TEAM_ALYX] = true -- Техник сопротивления
	--[TEAM_GORDON] = true, -- Лидер сопротивления
	--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
	--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
	--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
	--[TEAM_ELITE4] = true -- Шпион [HYDRA]
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 500,
	model = "models/weapons/tfa_cso2/w_m79.mdl",
	desc = "Страна производитель: США"
})

registerItem("smg_grenade", {
	name = "Подствольная граната",
	func = function(ply)
		local ammo = "SMG1_Grenade"
		if ply:GetAmmoCount(ammo) >= 10 then return false, "Достигнут лимит" end
		ply:GiveAmmo(1, ammo, true)
	end,
	customCheck = function(ply)
		local ammo = "SMG1_Grenade"
		if ply:GetAmmoCount(ammo) >= 10 then return false, "Достигнут лимит" end
	end,
	jobs = {
		[TEAM_GANG8] = true -- Повстанец [Подрывник]
	},
	price = 300,
	model = "models/items/ar2_grenade.mdl",
	desc = "Производитель: Альянс"
})

registerItem("frag", {
	name = "Граната",
	func = function(ply)
		local class, ammo = "weapon_frag", "Grenade"
		if not ply:HasWeapon(class) then
			local wep = ply:Give(class, true)
			wep.given = true
		end

		if ply:GetAmmoCount(ammo) >= 3 then return false, "Достигнут лимит" end
		ply:GiveAmmo(1, ammo, true)
	end,
	customCheck = function(ply)
		local ammo = "Grenade"
		if ply:GetAmmoCount(ammo) >= 3 then return false, "Достигнут лимит" end
	end,
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/weapons/w_grenade.mdl",
	desc = "Производитель: Альянс"
})

registerItem("slam", {
	name = "SLAM",
	func = function(ply)
		local class, ammo = "weapon_slam", "slam"
		if not ply:HasWeapon(class) then
			local wep = ply:Give(class, true)
			wep.given = true
		end

		if ply:GetAmmoCount(ammo) >= 5 then return false, "Достигнут лимит" end
		ply:GiveAmmo(1, ammo, true)
	end,
	customCheck = function(ply)
		local ammo = "slam"
		if ply:GetAmmoCount(ammo) >= 5 then return false, "Достигнут лимит" end
	end,
	jobs = {
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_GPYRO] = true, -- Пиротехник
	},
	--[TEAM_ALYX] = true, -- Техник сопротивления
	price = 200,
	model = "models/weapons/w_slam.mdl",
	desc = "Производитель: Альянс"
})

-- ПОВСТАНЦЫ РАЗНОЕ
registerItem("cracker", {
	name = "Взломщик барьеров",
	swep = "keypad_cracker",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/weapons/w_emptool.mdl",
	desc = "Позволяет взламывать силовые поля"
})

registerItem("lockpick", {
	name = "Отмычка",
	swep = "lockpick",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/weapons/w_crowbar.mdl",
	desc = "Медленный взлом замков"
})

registerItem("lockpick_pro", {
	name = "Проф. отмычка",
	swep = "lockpick_pro",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	},
	price = 1000,
	model = "models/weapons/w_crowbar.mdl",
	desc = "Ускоренный взлом замков"
})

registerItem("poison", {
	name = "Яд - Отрава",
	swep = "ent_poison",
	jobs = {
		[TEAM_AGENT] = true
	},
	price = 500,
	model = "models/props_lab/jar01a.mdl",
	desc = "Яд можно подмешать в рационы ГО"
})

registerItem("pill_poison", {
	name = "Капсула с ядом",
	swep = "ent_pill_poison",
	jobs = {
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		--[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true -- Шпион [HYDRA]
	},
	--[TEAM_ELITE5] = true -- Коммандер [HYDRA]
	price = 4000,
	model = "models/props_lab/box01a.mdl",
	desc = "Капсула с ядом на крайний случай"
})

registerItem("scanner_guns", {
	name = "Устройство досмотра",
	swep = "weapon_scanner",
	jobs = {
		[TEAM_GUNSHOP] = true, -- Оружейник
		[TEAM_FOODSHOP] = true, -- Пищевой
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/items/item_item_crate.mdl",
	desc = "Позволяет досматривать незванных гостей"
})

registerItem("sledge", {
	name = "Молот",
	swep = "tfa_nmrih_sledge",
	jobs = {
		[TEAM_ALYX] = true
	},
	price = 300,
	model = "models/weapons/tfa_nmrih/w_me_sledge.mdl",
	desc = "Круши, ломай!"
})

-- ПАТРОНЫ
registerItem("ammo_pistol", {
	name = "Патроны для пистолета",
	swep = "item_ammo_pistol_large",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true,
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 500,
	model = "models/Items/BoxSRounds.mdl",
	desc = "100 патрон для пистолета"
})

registerItem("ammo_357", {
	name = "Патроны для револьвера",
	swep = "item_ammo_357_large",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true,
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 400,
	model = "models/Items/357ammo.mdl",
	desc = "20 патрон для пистолета"
})

registerItem("ammo_smg1", {
	name = "Патроны для ПП",
	swep = "item_ammo_smg1",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true,
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 450,
	model = "models/Items/BoxMRounds.mdl",
	desc = "45 патрон для ПП"
})

registerItem("box_buckshot", {
	name = "Патроны для дробовика",
	swep = "item_box_buckshot",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true,
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 400,
	model = "models/Items/BoxBuckshot.mdl",
	desc = "20 патрон для дробовика"
})

registerItem("ammo_ar2", {
	name = "Патроны для винтовки",
	swep = "item_ammo_ar2_large",
	jobs = {
		[TEAM_BAND1] = true,
		[TEAM_BAND2] = true,
		[TEAM_BAND3] = true,
		[TEAM_BAND4] = true,
		[TEAM_AFERIST] = true,
		[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		[TEAM_GANG3] = true, -- Повстанец [Солдат]
		[TEAM_GANG4] = true, -- Повстанец [Медик]
		[TEAM_GMED] = true, -- Опытный Медик
		[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		[TEAM_GFAST] = true, -- Вербовщик
		[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		[TEAM_GANG7] = true, -- Повстанец [Мастер]
		[TEAM_GSPY] = true, -- Партизан
		[TEAM_AGENT] = true, -- Спецагент
		[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		[TEAM_KLEINER] = true, -- Ученый сопротивления
		[TEAM_BARNEY] = true, -- Коммандер сопротивления
		[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 1500,
	model = "models/Items/combine_rifle_cartridge01.mdl",
	desc = "100 патрон для винтовки"
})

registerItem("crossbow", {
	name = "Болты",
	swep = "item_ammo_crossbow",
	jobs = {
		--[TEAM_BAND1] = true,
		--[TEAM_BAND2] = true,
		--[TEAM_BAND3] = true,
		--[TEAM_BAND4] = true,
		--[TEAM_AFERIST] = true,
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
	},
	price = 300,
	model = "models/Items/CrossbowRounds.mdl",
	desc = "6 болтов"
})

registerItem("rpg_round", {
	name = "Ракета",
	swep = "item_rpg_round",
	jobs = {
		--[TEAM_BAND1] = true,
		--[TEAM_BAND2] = true,
		--[TEAM_BAND3] = true,
		--[TEAM_BAND4] = true,
		--[TEAM_AFERIST] = true,
		--[TEAM_GANG2] = true, -- Повстанец [Новобранец]
		--[TEAM_GANG3] = true, -- Повстанец [Солдат]
		--[TEAM_GANG4] = true, -- Повстанец [Медик]
		--[TEAM_GMED] = true, -- Опытный Медик
		--[TEAM_GANG5] = true, -- Повстанец [Штурмовик]
		--[TEAM_GFAST] = true, -- Вербовщик
		--[TEAM_GANG6] = true, -- Повстанец [Ветеран]
		--[TEAM_ARMY] = true, -- Рейнджер
		--[TEAM_GPYRO] = true, -- Пиротехник
		--[TEAM_GANG7] = true, -- Повстанец [Мастер]
		--[TEAM_GSPY] = true, -- Партизан
		--[TEAM_AGENT] = true, -- Спецагент
		--[TEAM_GANG8] = true, -- Повстанец [Подрывник]
		--[TEAM_KLEINER] = true, -- Ученый сопротивления
		--[TEAM_BARNEY] = true, -- Коммандер сопротивления
		--[TEAM_ALYX] = true, -- Техник сопротивления
		[TEAM_GORDON] = true, -- Лидер сопротивления
		--[TEAM_ELITE1] = true, -- Рекрут [HYDRA]
		--[TEAM_ELITE2] = true, -- Повстанец [HYDRA]
		--[TEAM_ELITE3] = true, -- Снайпер [HYDRA]
		--[TEAM_ELITE4] = true, -- Шпион [HYDRA]
		--[TEAM_ELITE5] = true, -- Коммандер [HYDRA]
	},
	price = 800,
	model = "models/weapons/w_missile_closed.mdl",
	desc = "1 ракета"
})

local allowedJobs = weapons_give_npc.jobs
for i = 1, #wepsList do
	local wepData = wepsList[i].jobs
	if istable(wepData) then
		for t in pairs(wepData) do
			allowedJobs[t] = true
		end
	end
end