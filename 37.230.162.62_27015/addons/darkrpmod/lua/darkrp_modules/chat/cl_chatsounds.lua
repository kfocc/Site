local s = CreateClientConVar("unionrp_chatsounds", "0", true, false)
local t = CreateClientConVar("unionrp_ukr", "0", true, false)
local function httpUrlEncode(text) -- спасибо разрабам wiremod
	local ndata = string.gsub(tostring(text), "[^%w _~%.%-]", function(str)
		local nstr = string.format("%X", string.byte(str))
		return "%" .. (string.len(nstr) == 1 and "0" or "") .. nstr
	end)
	return string.gsub(ndata, " ", "+")
end

function tts(txt, ply, tbl)
	txt = httpUrlEncode(txt)
	tbl = t:GetBool() and "uk" or "ru"
	sound.PlayURL("https://translate.google.com/translate_tts?ie=UTF-8&tl=" .. tbl .. "&client=tw-ob&q=" .. txt, ply and "3d" or "mono", function(station)
		if IsValid(station) then
			station:SetVolume(1)
			if ply then station:SetPos(ply:GetPos()) end
			station:Play()
		end
	end)
end

hook.Add("OnPlayerChat", "UnionRPSounds", function(ply, text, teamchat, dead)
	if s:GetInt() == 1 and IsValid(ply) and (ply:GetPos():Distance(LocalPlayer():GetPos()) < 250 or teamchat) then
		tts(text,ply)
	end
end)


local MAX_DURATION = 5
local MAX_SAME_SOUND = 2

local function ProccessSound(ply, phrases, volume, index)
	if not IsValid(ply) or not ply:Alive() then
		return
	end
	local name = "chatsounds." .. ply:SteamID64() .. ".sound"
	if timer.Exists(name) then
		timer.Remove(name)
	end

	local data = phrases[index]
	local snd = istable(data.sounds) and table.Random(data.sounds) or data.sounds
	if not snd then
		return
	end

	ply:EmitSound(snd, volume)

	if #phrases == index then return end
	local delay = SoundDuration(snd) + 0.1
	timer.Create(name, delay, 1, function()
		ProccessSound(ply, phrases, volume, index + 1)
	end)
end

local duration, used = 0, {}
local function preparePhrase(data)
	local count = (used[data] or 0) + 1
	used[data] = count
	if count > MAX_SAME_SOUND or duration > MAX_DURATION then return false end

	duration = duration + SoundDuration(istable(data.sounds) and data.sounds[1] or data.sounds) + 0.1
end

local MODULE = unionrp.sounds
local function MessageToPhrases(tab, text, disableVip)
	local words = trie.Prepare(text)
	local phrases, i, old_i = {}

	repeat
		old_i = i
		for j, data in ipairs(tab) do
			phrases, i = trie.GetPrefixes(data.trie, words, phrases, i, data.max, preparePhrase)
		end
	until old_i == i

	duration, used = 0, {}

	return phrases
end

local function GetMessage(ply, text, prefix)
	local name = ply:GetNetVar("HideCPName") and ply:getDarkRPVar("job") or ply:GetResultNickname()
	if string.sub(prefix, 1, #name) ~= name then return end

	local classes = MODULE.GetClass(ply)
	local tab = {}
	for _, class in ipairs(classes) do
		local data = MODULE.classes[class]
		if not data.trie then
			local phrases = {}
			for k, v in pairs(MODULE.stored[class]) do
				phrases[v.phrase] = v
			end
			data.trie = trie.Bulid(phrases)
		end
		table.insert(tab, data)
	end

	local phrases = MessageToPhrases(tab, text)
	if #phrases == 0 then return end
	ProccessSound(ply, phrases, 80, 1)
end

hook.Add("OnPlayerChat", "chatsounds", function(ply, text, teamchat, dead, prefix)
	if not IsValid(ply) then return end
	if not ply:Alive() or teamchat or dead then return end
	GetMessage(ply, text, prefix)
end)