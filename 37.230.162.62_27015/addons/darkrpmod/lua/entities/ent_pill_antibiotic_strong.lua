AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "disease_base"

ENT.PrintName = "Сильный антибиотик"
ENT.Category = "Diseases"
ENT.Spawnable = true

ENT.ItemModel = "models/props_lab/jar01a.mdl"
ENT.ItemText = "Применение сильного антибиотика..."
ENT.ItemDelay = 10
ENT.ItemSound = "items/medshot4.wav"
ENT.ItemIcon = Material("icon16/pill_add.png")
ENT.ItemName = "Сильный антибиотик"
ENT.ErrorText = "Этот препарат может вылечить все кроме перелома."

ENT.Cures = {
    ["Интоксикация"] = true,
    ["Туберкулез"] = true,
    ["Лихорадка"] = true,
    ["Отравление"] = true,
    ["ОВИ"] = true,
	
    ["Отравление едой"] = true,
    ["Язва"] = true,
    ["Глаукома"] = true,
    ["Простуда"] = true,
    ["Кашель"] = true
}