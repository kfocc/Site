AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Телепорт"
ENT.Author = "Johnny & Jaros"
ENT.Category = "Повстанцы"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Platform")
end

sound.Add({
	level   = SNDLVL_85dB,
	channel = 6,
	pitch   = { 95, 110 },
	sound   = {
		'ambient/machines/teleport1.wav',
		'ambient/machines/teleport3.wav',
		'ambient/machines/teleport4.wav',
	},
	volume  = 0.89990234375,
	name    = 'unionrp.teleport_sound',
})