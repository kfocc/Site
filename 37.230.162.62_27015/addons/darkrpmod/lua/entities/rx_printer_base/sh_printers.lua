AddCSLuaFile("sh_printers_cfg.lua")
local defaultStructure = {
	Base = "rx_printer_base",
	PrinterName = "UNKNOWN PRINTER",
	PrinterMasterColor = color_white,

	PrinterHealth = 100,
	MaxMoney = 3000,

	RPM = 7,
	Hull = 2000,

	BreakDownTimer = 60,
	BreakDownRate = 25,
	BreakDownDestoryTime = 30,

	Upgrades = {},

	ErrorSound = {true, 5, "Resource/warning.wav"},
	RuningSound = {false, 8, "ambient/machines/engine4.wav"},
	RuningSoundVolume = 0.001,
}

local printersList = Stack()
local function RegisterRXPPrinter(data)
	printersList:Push(data)
end

_G.RegisterRXPPrinter = RegisterRXPPrinter
include("sh_printers_cfg.lua")
_G.RegisterRXPPrinter = nil

local arrayLength = printersList:Size()
for i = 1, arrayLength do
	local data = printersList[i]
	local uniqueID = data.uniqueID
	data.uniqueID = nil
	for defaultCfgName, defaultCfgInfo in pairs(defaultStructure) do
		if data[defaultCfgName] == nil then data[defaultCfgName] = defaultCfgInfo end
	end

	scripted_ents.Register(data, uniqueID)
end
