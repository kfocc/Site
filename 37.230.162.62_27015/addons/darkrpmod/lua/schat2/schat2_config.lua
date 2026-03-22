SChat2 = SChat2 or {}
SChat2.BlockedUsers = SChat2.BlockedUsers or {}
SChat2.Config = SChat2.Config or {}

SChat2.Config.maxTextLength = 512
if CLIENT then
	include("cl_schat2_cvars.lua")

	SChat2.Config.posX = 10
	SChat2.Config.posY = ScrH() * 0.5

	SChat2.Config.sizeW = ScrW() / 3
	SChat2.Config.sizeH = ScrH() / 3

	SChat2.Config.minSizeW = 1.2
	SChat2.Config.minSizeH = 1.5

	SChat2.Config.remainTime = 7

	SChat2.Config.showTimestamps = false

	SChat2.Config.richTextFont = "SChat218.RichText_0"

	SChat2.Config.playPMSound = true

	SChat2.Config.closeOnEnter = true
	SChat2.Config.closeOnEnterPM = false

	SChat2.Config.Color = Color(66, 139, 202, 255)

	SChat2.Config.customExclamationCommand = SChat2.Config.customExclamationCommand or {
		["!adadd"] = true,
		["!adremove"] = true,
		["!camadd"] = true,
		["!camremove"] = true,
	}

	SChat2.Config.customSlashCommand = SChat2.Config.customSlashCommand or {
		["cid"] = true,
	}

	local sscale = util.SScale
	surface.CreateFont("SChat218", {
		font = "Inter",
		size = sscale(18),
		weight = 300,
		shadow = true,
		extended = true,
	})

	surface.CreateFont("SChat218Italic", {
		font = "Inter",
		size = sscale(18),
		weight = 500,
		italic = true,
		extended = true
	})

	surface.CreateFont("SChat220", {
		font = "Inter",
		size = 19,
		weight = 500,
		extended = true
	})

	SChat2.richTextFonts = {}
	for i = -3, 6 do
		local fontName = "SChat218.RichText_" .. i
		SChat2.richTextFonts[fontName] = i
		SChat2.richTextFonts[i] = fontName
		surface.CreateFont("SChat218.RichText_" .. i, {
			font = "Inter",
			size = 18 + i,
			weight = 300,
			shadow = true,
			extended = true,
		})
	end

	hook.Add("InitPostEntity", "SChat2.InitCommands", function()
		for k, v in pairs(plogs.cfg.Command) do
			local preffix = string.sub(k, 1, 1)
			if preffix == "!" then
				SChat2.Config.customExclamationCommand[k] = true
			elseif preffix == "/" then
				k = string.utf8sub(k, 2)
				SChat2.Config.customSlashCommand[k] = true
			end
		end
	end)
end

local meta = FindMetaTable("Player")
function meta:IsTyping()
	return self:GetNetVar("IsTyping", false) and not self:GetNetVar("IgnoreIsTalking")
end
