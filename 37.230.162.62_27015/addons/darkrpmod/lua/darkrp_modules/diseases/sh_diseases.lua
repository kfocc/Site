diseases = diseases or {}
diseases.stored = diseases.stored or {}
local stored = diseases.stored
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
diseases.config = diseases.config or {}
diseases.config.Enable = true
diseases.config.TeamsToImmune = {}
diseases.config.DisTickRandomCheck = 300 -- 5 минут

hook.Add("PostGamemodeLoaded", "DisConfigInitialize", function()
	diseases.config.TeamsToImmune = {
		[TEAM_CITIZEN] = true,
		[TEAM_VORT] = true,
		[TEAM_BANG1] = true,
		[TEAM_GORDON] = true,
		[TEAM_ELITE5] = true,
		[TEAM_GMAN] = true,
		[TEAM_ZOMB1] = true,
		[TEAM_ZOMBIE1] = true,
		[TEAM_ZOMBIE2] = true,
		[TEAM_ZOMBIE3] = true,
		[TEAM_ZOMBIE4] = true,
		[TEAM_CREMATOR] = true,
		[TEAM_ADMIN] = true,
		[TEAM_STALKER] = true,
	}
end)

diseases.config.coughSounds = {"ambient/voices/cough1.wav", "ambient/voices/cough2.wav", "ambient/voices/cough3.wav", "ambient/voices/cough4.wav"}
function diseases.config:Immune(ply)
	if IsValid(ply) then
		if not ply:Alive() or ply:GetMoveType() == MOVETYPE_NOCLIP or self.TeamsToImmune[ply:Team()] or ply:isEnabledMask() or ply:isOTA() or ply:isZombie() or ply._inHealBed or ply:InVehicle() then
			return true
		else
			return false
		end
	else
		return true
	end
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local pMeta = FindMetaTable("Player")
function pMeta:GetDisease()
	if not IsValid(self) then return end
	local dis = stored[self:GetNW2Int("disease", 0)]
	return dis
end

function pMeta:GetDiseaseName()
	if not IsValid(self) then return end
	local dis = self:GetDisease()
	return dis and dis.name
end

function pMeta:getGender()
	if IsValid(self) then
		local gender = self:isFemale() and "female" or "male"
		return gender
	end
end

function diseases.Find(id)
	if isstring(id) then
		for _, v in ipairs(stored) do
			if v.name:utf8lower() == id:utf8lower() then return v end
		end
	elseif isnumber(id) then
		return stored[id]
	elseif istable(id) then
		local raw = id.id or 0
		return stored[raw]
	end
end

function diseases.GetAll()
	return stored
end

function diseases.Random()
	return stored[math.random(#stored)]
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
local i = 0
function diseases:CreateDisease(name, data)
	if not istable(data) then return end
	i = i + 1
	local dis = {}
	dis.id = i
	dis.name = name
	dis.heal_time = data.heal_time or 30

	if SERVER then -- копируем, значения, чтобы избавиться от возможного лишнего мусора.
		dis.chance_to_infect = data.chance_to_infect
		dis.protect = data.protect
		dis.customcheck = data.customcheck
		dis.pre_infection = data.pre_infection
		dis.tick_in_infection = data.tick_in_infection
		dis.max_infection_ticks = data.max_infection_ticks
		dis.infection = data.infection
		dis.post_infection = data.post_infection
		dis.random_events_timeout = data.random_events_timeout
		dis.random_events = data.random_events
	else
		dis.vis_effect = data.vis_effect
	end

	self.stored[i] = dis
	return dis
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
diseases:CreateDisease("Кашель", {
	heal_time = 30,
	chance_to_infect = 10,
	customcheck = function(ply) return ply:WaterLevel() > 0 or ply:Health() < 25 end,
	random_events_timeout = {15, 45},
	random_events = function(ply)
		local nick = ply:GetResultNickname()
		diseases:AddText(nick .. " кашляет.", Color(137, 210, 53), ply, 150)
		ply:EmitSound(diseases.config.coughSounds[math.random(#diseases.config.coughSounds)], 100, 100)
	end
})

diseases:CreateDisease("Простуда", {
	heal_time = 30,
	chance_to_infect = 10,
	customcheck = function(ply) return ply:WaterLevel() > 0 or ply:GetDiseaseName() == "Кашель" end,
	random_events_timeout = {15, 45},
	random_events = function(ply)
		local nick = ply:GetResultNickname()
		diseases:AddText(nick .. " кашляет.", Color(137, 210, 53), ply, 150)
		ply:EmitSound(diseases.config.coughSounds[math.random(#diseases.config.coughSounds)], 100, 100)
	end
})

local plain_mat = Material("pp/texturize/plain.png")
diseases:CreateDisease("Глаукома", {
	heal_time = 45,
	chance_to_infect = 10,
	customcheck = function(ply) return ply:Health() < 25 end,
	vis_effect = function() DrawTexturize(1, plain_mat) end
})

diseases:CreateDisease("Язва", {
	heal_time = 60,
	chance_to_infect = 5,
	customcheck = function(ply) return ply:getDarkRPVar("Energy", 0) <= 25 end,
	random_events_timeout = {120, 180},
	random_events = function(ply)
		local nick = ply:GetResultNickname()
		diseases:AddText(nick .. " невольно сгибается из-за боли в животе и блюет на пол.", Color(137, 210, 53), ply, 150)
		ply:EmitSound(diseases.config.coughSounds[math.random(#diseases.config.coughSounds)], 100, 100)
		hook.Run("VomitPlayer", ply)
	end
})

local local_cfg = {
	sounds = {
		female = "vo/npc/female01/question%s.wav",
		male = "vo/npc/male01/question%s.wav"
	}
}

diseases:CreateDisease("Лихорадка", {
	heal_time = 80,
	chance_to_infect = 10,
	customcheck = function(ply)
		local dis = ply:GetDiseaseName()
		return dis and (dis == "Глаукома" or dis == "Кашель" or dis == "Простуда")
	end,
	random_events_timeout = {120, 300},
	random_events = function(ply)
		local nick = ply:GetResultNickname()
		diseases:AddText(nick .. " выглядит неважно.", Color(137, 210, 53), ply, 150)
		local rand = math.random(1, 9)
		local text = local_cfg.sounds[ply:getGender()]
		if text then
			text = text:format(rand)
			ply:EmitSound(text, 100, 100)
		end
	end,
	vis_effect = function()
		DrawMotionBlur(math.Clamp(0.25, 0.1, 1), 1, 0)
		if math.random(1, 50) == 1 then DrawTexturize(1, plain_mat) end
	end
})

local local_cfg = {
	sounds = {
		female = "vo/npc/female01/pain0%s.wav",
		male = "vo/npc/male01/pain0%s.wav"
	},
	text = {"%s очень сильно кашляет, отхаркивая мокроту из легких.", "%s начинает задыхаться и жадно глотать воздух."}
}

diseases:CreateDisease("Туберкулез", {
	heal_time = 120,
	chance_to_infect = 5,
	customcheck = function(ply)
		local dis = ply:GetDiseaseName()
		return dis and (dis == "Кашель" or dis == "Лихорадка")
	end,
	random_events_timeout = {5, 15},
	random_events = function(ply)
		local snd = local_cfg.sounds[ply:getGender()]
		if snd then
			local rand = math.random(1, 9)
			snd = snd:format(rand)
			ply:EmitSound(snd, 100, 100)
		end

		local textRow = local_cfg.text
		local text = textRow[math.random(#textRow)]
		local nick = ply:GetResultNickname()
		diseases:AddText(text:format(nick), Color(137, 210, 53), ply, 150)
	end,
	tick_in_infection = {4, 6},
	infection = function(ply)
		if ply:Health() >= 5 then
			ply:SetHealth(ply:Health() - 1)
		else
			ply:Kill()
		end
	end,
	vis_effect = function() DrawMotionBlur(math.Clamp(0.1, 0.1, 1), 1, 0) end
})

diseases:CreateDisease("ОВИ", {
	heal_time = 120,
	chance_to_infect = 5,
	customcheck = function(ply)
		local dis = ply:GetDiseaseName()
		return dis and dis == "Туберкулез"
	end,
	random_events_timeout = {5, 15},
	random_events = function(ply)
		local rand = math.random(1, 9)
		local text = local_cfg.sounds[ply:getGender()]
		if text then
			text = text:format(rand)
			ply:EmitSound(text, 100, 100)
		end

		local row = local_cfg.text
		text = row[math.random(#row)]
		local nick = ply:GetResultNickname()
		diseases:AddText(text:format(nick), Color(137, 210, 53), ply, 150)
	end,
	tick_in_infection = 1,
	infection = function(ply)
		if ply:Health() >= 5 then
			ply:SetHealth(ply:Health() - 3)
		else
			ply:Kill()
		end
	end
})

local dis = {}
if CLIENT then
	dis.intensity = 0
	dis.hpwait, dis.hpalpha = 0, 0
	dis.vig = surface.GetTextureID("vgui/vignette_w")
	dis.clr = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 1,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}
end

diseases:CreateDisease("Перелом", {
	heal_time = 60,
	random_events_timeout = {120, 300},
	random_events = function(ply)
		local nick = ply:GetResultNickname()
		diseases:AddText(nick .. " выглядит неважно.", Color(137, 210, 53), ply, 150)
		local rand = math.random(1, 9)
		local text = local_cfg.sounds[ply:getGender()]
		if text then
			text = text:format(rand)
			ply:EmitSound(text, 100, 100)
		end
	end,
	post_infection = function(ply)
		ply:SetJumpPower(100)
		ply:SetRunSpeed(130)
		ply:SetWalkSpeed(50)
		ply:SetDuckSpeed(0.15)
	end,
	vis_effect = function(ply)
		local x, y = ScrW(), ScrH()
		local FT = FrameTime()
		dis.intensity = math.Approach(dis.intensity, 1 - math.Clamp(20 / 80, 0, 1), FT * 3)
		if dis.intensity > 0 then
			surface.SetDrawColor(0, 0, 0, 200 * dis.intensity)
			surface.SetTexture(dis.vig)
			surface.DrawTexturedRect(0, 0, x, y)
			dis.clr["$pp_colour_colour"] = 1 - dis.intensity
			DrawColorModify(dis.clr)
			surface.SetDrawColor(255, 0, 0, (50 * dis.intensity) * dis.hpalpha)
			surface.DrawTexturedRect(0, 0, x, y)
			local CT = CurTime()
			if CT > dis.hpwait then
				ply:EmitSound("lowhp/hbeat.wav", 45 * dis.intensity, 100 + 20 * dis.intensity)
				dis.hpwait = CT + 0.5
			end

			if CT < dis.hpwait - 0.4 then
				dis.hpalpha = math.Approach(dis.hpalpha, 1, FrameTime() * 10)
			else
				dis.hpalpha = math.Approach(dis.hpalpha, 0.33, FrameTime() * 10)
			end
		end
	end
})

diseases:CreateDisease("Отравление", {
	heal_time = 60,
	random_events_timeout = {10, 15},
	random_events = function(ply)
		local rand = math.random(1, 9)
		local text = local_cfg.sounds[ply:getGender()]
		if text then
			text = text:format(rand)
			ply:EmitSound(text, 100, 100)
		end
	end,
	tick_in_infection = 10,
	infection = function(ply)
		if ply:Health() > 5 then
			ply:SetHealth(ply:Health() - 5)
		else
			ply:Kill()
		end
	end,
	vis_effect = function(ply) DrawMotionBlur(0.1, 1.5, 0.03) end
})

diseases:CreateDisease("Отравление едой", {
	heal_time = 70,
	random_events_timeout = {10, 15},
	random_events = function(ply)
		local rand = math.random(1, 9)
		local text = local_cfg.sounds[ply:getGender()]
		if text then
			text = text:format(rand)
			ply:EmitSound(text, 100, 100)
		end
	end,
	tick_in_infection = 1,
	max_infection_ticks = 66,
	infection = function(ply)
		if ply._inHealBed then return end
		if ply:Health() > 3 then
			ply:SetHealth(ply:Health() - 3)
		else
			ply:Kill()
		end
	end,
	post_infection = function(ply)
		ply:ChatPrint("Кажется в еду, которую Вы съели - было что-то подмешано... Вы чувствуете как вам становится плохо...")
		ply:setSelfDarkRPVar("Energy", 5)
		timer.Simple(math.random(3, 10), function() if IsValid(ply) and ply:Alive() then hook.Run("VomitPlayer", ply) end end)
	end,
	vis_effect = function(ply) DrawMotionBlur(0.1, 1.5, 0.03) end
})
