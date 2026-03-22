local pMeta = FindMetaTable("Player")
local voiceDistanceIcons = {
	whisper = Material("materials/unionrp/ui/voice_icon_1.png", "noclamp smooth"),
	talk = Material("materials/unionrp/ui/voice_icon_2.png", "noclamp smooth"),
	yell = Material("materials/unionrp/ui/voice_icon_3.png", "noclamp smooth"),
}

local voiceDistance = {
	whisper = GAMEMODE.Config.whisperDistance,
	yell = GAMEMODE.Config.yellDistance,
	talk = GAMEMODE.Config.talkDistance,
}

local voiceDistanceSqr = {
	whisper = GAMEMODE.Config.whisperDistance,
	yell = GAMEMODE.Config.yellDistance,
	talk = GAMEMODE.Config.talkDistance,
}

for k, v in pairs(voiceDistanceSqr) do -- make dist sqr
	voiceDistanceSqr[k] = v * v
end

local voiceTextMap = {
	whisper = DarkRP.getPhrase("whisper"),
	yell = DarkRP.getPhrase("yell"),
	talk = "",
}

DarkRP.voiceTextMap = voiceTextMap
DarkRP.voiceDistance = voiceDistance
DarkRP.voiceDistanceSqr = voiceDistance
DarkRP.voiceDistanceCycle = {
	[1] = "whisper",
	[2] = "talk",
	[3] = "yell",
	whisper = 1,
	talk = 2,
	yell = 3,
}

function pMeta:GetVoiceTextMap()
	return voiceTextMap[self:GetVoiceDistanceStr()]
end

function pMeta:GetVoiceDistanceStr()
	return self:GetNetVar("voice.Distance", "talk")
end

function pMeta:GetVoiceDistanceIcon()
	return voiceDistanceIcons[self:GetNetVar("voice.Distance", "talk")]
end

function pMeta:GetVoiceDistanceInt()
	return voiceDistance[self:GetNetVar("voice.Distance", "talk")]
end

function pMeta:GetVoiceDistanceIntSqr()
	return voiceDistanceSqr[self:GetNetVar("voice.Distance", "talk")]
end

if CLIENT then
	local buttonKeyBind = CreateClientConVar("union_voice_proximity_key", KEY_T, true, false)
	cvars.AddChangeCallback("union_voice_proximity_key", function(convar_name, value_old, value_new)
		local newValue = tonumber(value_new)
		if not newValue then
			buttonKeyBind:SetInt(KEY_T)
			net.Start("voice.StoreHotkey")
			net.WriteUInt(KEY_T, 8)
			net.SendToServer()
			return
		end

		local validateName = input.GetKeyName(newValue)
		if not validateName or validateName == "" then
			buttonKeyBind:SetInt(KEY_T)
			net.Start("voice.StoreHotkey")
			net.WriteUInt(KEY_T, 8)
			net.SendToServer()
			return
		end

		net.Start("voice.StoreHotkey")
		net.WriteUInt(newValue, 8)
		net.SendToServer()
	end)

	hook.Add("InitPostEntity", "load.VoiceHotkey", function()
		local hotkey = buttonKeyBind:GetInt()
		if not hotkey or hotkey == 0 then hotkey = KEY_T end
		net.Start("voice.StoreHotkey")
		net.WriteUInt(hotkey, 8)
		net.SendToServer()
	end)
end
