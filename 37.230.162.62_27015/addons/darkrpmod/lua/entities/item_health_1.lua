AddCSLuaFile()

ENT.Base = "health_item_base"

ENT.ItemType = "Health" -- Тип предмета, Health/Armor
ENT.ItemName = "Вскрытые лекарства" -- Название предмета, отображается, когда лежит на полу
ENT.ItemText = "Используем" -- Текст при использовании
ENT.ItemModel = "models/props_lab/jar01b.mdl" -- Модель предмета
ENT.ItemSound = "items/smallmedkit1.wav" -- Звук при использовании
ENT.ItemIcon = Material("icon16/add.png") -- Иконка
ENT.ItemDelay = 2 -- Задержка при использовании
ENT.ItemInt = 25 -- Количество восстанавливаемой статы

ENT.PrintName = ENT.ItemName

ENT.Spawnable = true
ENT.Category = "Лечение"