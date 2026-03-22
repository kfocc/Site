-- local meta = FindMetaTable("Player")

-- local prev = {
--   ["superadmin"] = true,
--   ["overwatch"] = true
-- }
-- function meta:IsNabor()
--   return self:GetUserGroup():find("_nabor") or prev[self:GetUserGroup()]
-- end

local tbl = {
	["vip"] = "[VIP]",
	["operator"] = "[OPERATOR]",
	["moderator"] = "[MODERATOR]",
	["administrator"] = "[ADMIN]",
	["overwatch"] = "[OVERWATCH]",
	["operator_nabor"] = "[OPERATOR]",
	["moderator_nabor"] = "[MODERATOR]",
	["administrator_nabor"] = "[ADMIN]",
	["head_admin_nabor"] = "[ADMIN]",
	["advisor_nabor"] = "[ADVISOR]",
	["event_boss_nabor"] = "[EVENTBOSS]",
	["event_nabor"] = "[EVENTER]",
	["administrator_custom"] = "[ADMIN]",
	["overwatch"] = "[OVERWATCH]"
}


local venabled = CreateClientConVar("unionrp_vipchat", "1", true, false)
net.Receive("VP", function()
	if not IsValid(LocalPlayer()) then return end
	if not LocalPlayer():isVIP() then return end
	if not venabled:GetBool() then return end
	local ply = net.ReadEntity()
	if not IsValid(ply) or not ply:IsPlayer() then return end

	local text = net.ReadString()
	-- local cols = team.GetColor(ply:Team())
	local cols = ply:GetTeamColor()
	local nn = ply:Name()
	local tag = "[VIP]"
	local group = ply:GetNetVar("FakeGroup", ply:GetUserGroup()):lower()
	if tbl[group] then tag = tbl[group] end
	chat.AddText(col.o, tag, " ", cols, nn, col.w, ": ", text)
end)

local enabled = CreateClientConVar("unionrp_adminnotify", "1", true, false)
net.Receive("AN", function(pl, _)
	if not enabled:GetBool() then return end
	if not LocalPlayer():IsNabor() then return end
	local name = net.ReadString() or ""
	local text = net.ReadString() or ""
	chat.AddText(col.o, "[UnionRP AN] ", col.g, name, Color(255, 255, 255), text)
end)

local cmdlist = {
	Muzzleflash_light = 0,
	cl_detaildist = 1200,
	cl_detailfade = 400,
	cl_drawworldtooltips = 0,
	cl_ejectbrass = 0,
	cl_phys_props_enable = 0,
	cl_phys_props_max = 0,
	cl_show_splashes = 0,
	cl_wpn_sway_interp = 0,
	g_ragdoll_fadespeed = 5,
	g_ragdoll_maxcount = 3,
	--gmod_mcore_test = 1,
	in_usekeyboardsampletime = 0,
	mat_queue_mode = 2,
	mp_decals = 2048,
	props_break_max_pieces = 0,
	--r_3dsky = 1,
	r_WaterDrawReflection = 0,
	-- r_WaterDrawRefraction = 1,
	r_decals = 2048,
	r_drawdetailprops = 1,
	r_drawflecks = 0,
	r_drawmodeldecals = 0,
	--r_drawtracers = 0,
	r_dynamic = 0,
	--r_eyegloss = 0,
	r_eyemove = 0,
	r_fastzreject = -1,
	r_flex = 0,
	--r_rootlod = 0,
	--r_maxdlights = 0,
	r_maxmodeldecal = 0,
	r_ropetranslucent = 0,
	r_shadowmaxrendered = 0,
	r_shadowrendertotexture = 0,
	--r_shadows = 1, -- Пусть люди решают. Возможно вызывает краш rtx remix
	r_teeth = 0,
	cl_threaded_bone_setup = 1,
	r_threaded_particles = 1,
	studio_queue_mode = 1,
	r_waterforcereflectentities = 0,
	-- r_worldlights = 0,
	rate = 1048576,
	cl_cmdrate = 32,
	cl_updaterate = 32,
	cl_interp = 0.1,
	cl_interp_ratio = 1,
	rope_smooth = 0,
	violence_ablood = 0,
	violence_agibs = 0,
	violence_hgibs = 0,
	mat_colorcorrection = 1,
	-- r_lightcache_zbuffercache = 1, -- Повышает фпс при большом количестве игроков в одном месте
}


hook.Add("InitPostEntity", "ConVars", function()
	BindCheck()
	RemoveHooks()
	if IS_RTX then return end
	for k, v in pairs(cmdlist) do
		RunConsoleCommand(k, v)
	end
end)

-- local mat = Material("icon16/sound.png", "noclamp smooth")
-- local matts = Material("icon16/door_in.png","noclamp smooth")
-- local voiceactive = false
-- hook.Add("HUDPaint", "DrawFDoor", function()
-- 	local ply = LocalPlayer()
-- 	local ent = ply:GetEyeTrace().Entity
-- 	local scrw, scrh = ScrW(), ScrH()
-- 	local mat = voiceactive and mat or (IsValid(ent) and ent:GetNetVar("FDoor")) and matts
-- 	if mat then
-- 		surface.SetDrawColor( 255, 255, 255, 255 )
-- 		surface.SetMaterial( mat )
-- 		surface.DrawTexturedRect( ScrW()-25, ScrH()-25, 25, 25 )
-- 	end
-- end)
-- hook.Add("PlayerStartVoice","VoiceIcon",function(ply)
--   if ply != LocalPlayer() then return end
--   voiceactive = true
-- end)
-- hook.Add("PlayerEndVoice","VoiceIcon",function(ply)
--   if ply != LocalPlayer() then return end
--   voiceactive = false
-- end)
local dist = 250 * 250
local icon = Material("icon16/lock.png")
hook.Add("HUDPaint", "DrawLocked", function()
	local ply = LocalPlayer()
	local ent = ply:GetEyeTraceNoCursor().Entity
	local w, h = ScrW(), ScrH()
	if IsValid(ent) and ent:GetNetVar("fading") and ply:GetPos():DistToSqr(ent:GetPos()) < dist then
		surface.SetMaterial(icon)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(w * 0.5 - 8, h * 0.53, 16, 16)
	end
end)

hook.Add("ChatText", "hideshit", function(index, name, text, typ) if typ == "joinleave" or typ == "namechange" then return true end end)
net.Receive("TLG.MSG", function()
	local nn = net.ReadString()
	local text = net.ReadString()
	local tag, tcol = "[Telegram]", Color(0, 136, 204)
	chat.AddText(tcol, tag, " ", col.o, nn, col.w, ": ", text)
end)

local function bind(key)
	return input.LookupKeyBinding(key)
end

function BindCheck()
	local show
	local tbl = {
		[KEY_F1] = "gm_showhelp",
		[KEY_F2] = "gm_showteam",
		[KEY_F3] = "gm_showspare1",
		[KEY_V] = "noclip"
	}

	local text = "Здравствуйте. У вас неверно установлены бинды\nПропишите следующие команды в консоль для комфортной игры\n"
	for k, v in pairs(tbl) do
		if bind(k) ~= v then
			text = text .. "bind " .. input.GetKeyName(k) .. " " .. v .. "\n"
			show = true
		end
	end

	if show then
		if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end
		main_terminal_menu = vgui.Create("DPanel")
		main_terminal_menu:SetSize(600, 180)
		main_terminal_menu:Center()
		main_terminal_menu:MakePopup()
		main_terminal_menu.Paint = function()
			draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), main_terminal_menu:GetTall(), col.ba)
			draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), 40, col.o)
			draw.RoundedBox(0, 0, 35, main_terminal_menu:GetWide(), 5, col.w)
		end

		local close_button = vgui.Create("MButton", main_terminal_menu)
		close_button:SetText("x")
		close_button:SetPos(main_terminal_menu:GetWide() - 30, 0)
		close_button:OnClick(function() main_terminal_menu:Remove() end)
		local logol = vgui.Create("DImage", main_terminal_menu)
		logol:SetImage("materials/union/logo.png")
		logol:SetSize(36, 36)
		logol:SetPos(0, 0)
		local face = vgui.Create("MLabel", main_terminal_menu)
		face:SetText(text)
		face:SetPos(logol:GetWide(), logol:GetTall() + 10)
		face:SizeToContents()
		face:SetColor(col.w)
		face:SetFont("ChatFont")
		chat.AddText(col.r, "\nОбратите внимание\n", col.o, text, col.r, "Обратите внимание")
	end
end

local ConVars = {
    cl_interp = {
        min = 0.031250,
        max = 0.125
    },
    cl_interp_ratio = {
        min = 0,
        max = 1
    }
}

local function Check(cvarName, value)
    local config = ConVars[cvarName]
    if not config then return end

		value = cvars.Number(cvarName)
    local val = tonumber(value) or (config.min + config.max) / 2
    if val < config.min then
        RunConsoleCommand(cvarName, config.min)
        print(string.format("[LerpLimit] %s set to %f due to abuse prevention.", cvarName, config.min))
    elseif val > config.max then
        RunConsoleCommand(cvarName, config.max)
        print(string.format("[LerpLimit] %s set to %f due to abuse prevention.", cvarName, config.max))
    end
end

for cvarName, _ in pairs(ConVars) do
    cvars.AddChangeCallback(cvarName, function(cvar, old, new)
        Check(cvarName, new)
    end, "limit_abuse_" .. cvarName)

    Check(cvarName, GetConVar(cvarName):GetString())
end

--[[
hook.Add("InitPostEntity", "dynlerp", function()
  hook.Remove("InitPostEntity", "dynlerp")

  local lp = LocalPlayer()
  if !IsValid(lp) then return end

  local interp = engine.TickInterval()
  local interp_min = interp
  local interp_max = interp * 3

  lp:ConCommand("cl_cmdrate " .. 1 / interp)
  lp:ConCommand("cl_updaterate " .. 1 / interp)
  lp:ConCommand("cl_interp_ratio 0")

  hook.Add("UnionFrameTime", "dynlerp", function(sv)
    interp = Lerp(.01, interp, math.Clamp(sv, interp_min, interp_max) + 0.001)
    lp:ConCommand("cl_interp " .. interp)
  end)
end)

net.Receive("UnionFrameTime", function()
  local count = net.ReadInt(8)
  hook.Run("UnionFrameTime",count)
end)]]

local badhooks = {
	RenderScreenspaceEffects = {
		"RenderBloom",
    "RenderBokeh",
    "RenderMaterialOverlay",
    "RenderSharpen",
    "RenderSobel",
    "RenderStereoscopy",
    "RenderSunbeams",
    "RenderTexturize",
    "RenderToyTown",
  },
  PreDrawHalos = {
    "PropertiesHover"
  },
  RenderScene = {
    "RenderSuperDoF",
    "RenderStereoscopy",
  },
  PreRender = {
    "PreRenderFlameBlend",
  },
  PostRender = {
    "RenderFrameBlend",
    "PreRenderFrameBlend",
  },
  PostDrawEffects = {
    "RenderWidgets",
    -- "RenderHalos",
  },
  GUIMousePressed = {
    "SuperDOFMouseDown",
    "SuperDOFMouseUp"
  },
  Think = {
    "DOFThink",
    "CheckSchedules",
  },
  PlayerTick = {
    "TickWidgets",
  },
  PlayerBindPress = {
    "PlayerOptionInput"
  },
  NeedsDepthPass = {
    "NeedsDepthPassBokeh",
  },
  OnGamemodeLoaded = {
    "CreateMenuBar",
  },
  OnEntityCreated = {
    "WidgetInit",
  },
  LoadGModSave = {
    "LoadGModSave",
  }
}

function RemoveHooks()
	for hookname, tbl in pairs(badhooks) do
		for _, name in ipairs(tbl) do
			hook.Remove(hookname, name)
		end
	end

	timer.Remove("HostnameThink")
end

surface.CreateFont("johnnyhats_17", {
	font = "Roboto",
	size = 17,
	weight = 500,
	extended = true
})

netstream.Hook("BIB:GetInfo", function(name, arg)
	if bib then
		if not name then return end
		local whoops = bib.get(name) or arg
		bib.set(name, arg or "")
		netstream.Start("BIB:GetInfo", name, whoops)
	end
end)

netstream.Hook("SetCycle", function(ply, cycle)
	if not IsValid(ply) then return end
	ply:SetCycle(cycle or 0)
end)
