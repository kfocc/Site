AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "disease_base"

ENT.PrintName = "Антибиотик"
ENT.Category = "Diseases"
ENT.Spawnable = true

ENT.ItemModel = "models/props_lab/jar01b.mdl"
ENT.ItemText = "Применение антибиотика..."
ENT.ItemDelay = 10
ENT.ItemSound = "items/medshot4.wav"
ENT.ItemIcon = Material("icon16/pill_add.png")
ENT.ItemName = "Антибиотик"
ENT.ErrorText = "Этот препарат может вылечить только: кашель, простуду, глаукому, язву и отравление едой."

ENT.Cures = {
    ["Отравление едой"] = true,
    ["Язва"] = true,
    ["Глаукома"] = true,
    ["Простуда"] = true,
    ["Кашель"] = true
}