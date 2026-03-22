local debug_getregistry = debug.getregistry
local hook_Add = hook.Add
local LocalPlayer = LocalPlayer
local Stack = Stack
local pairs = pairs
local timer_Create = timer.Create
local hook_GetTable = hook.GetTable
local timer_Remove = timer.Remove
local timer_Simple = timer.Simple
local string_format = string.format
local pcall = pcall
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local netstream_Start = netstream.Start
local player_GetAll = player.GetAll

local _R = debug_getregistry()
local _Entity = _R.Entity
local isValid = _Entity.IsValid
local entIndex = _Entity.EntIndex

local hooksList = Stack()
local tabLen = 0

local function parseHooks(tab)
	hooksList:Clear()
	for hookName, hookFunc in pairs(tab) do
		hooksList:Push({hookName, hookFunc})
	end
end

timer_Create("PlayerOneSecondParse", 1, 0, function()
	local oneSecondHooks = hook_GetTable()["PlayerOneSecond"]
	parseHooks(oneSecondHooks)
	tabLen = hooksList:Size()
end)

local str = "PlayerOneSecond failed at hook: \"%s\" with error: \"%s\"!"
local function initalizeOneSecondHook(ply)
	if not isValid(ply) then return end
	local function iterHooks()
		for i = 1, tabLen do
			if not isValid(ply) then return end

			local v = hooksList[i]
			local hookName, hookFunc = v[1], v[2]
			local st, err = pcall(hookFunc, ply)
			if not st then ErrorNoHaltWithStack(string_format(str, hookName, err)) end
			coroutine.wait(0.1)
		end
	end

	local id = "PlayerOneSecond_" .. ply:UniqueID()
	timer_Create(id, 1, 0, function()
		if not isValid(ply) then
			timer_Remove(id)
			return
		end

		CreateLuaThread(iterHooks)
	end)
end

if SERVER then
	hook_Add("PlayerInitialized", "initOneSecondHook", function(ply)
		initalizeOneSecondHook(ply)
		netstream_Start(nil, "sendConnectedPly", ply:EntIndex())
	end)
else
	--[[local queueForSync = {}
	netstream.Hook("sendConnectedPly", function(idx)
		queueForSync[idx] = true
	end)

	hook_Add("NetworkEntityCreated", "initOneSecondHook", function(ent)
		local idx = entIndex(ent)
		if idx and queueForSync[idx] then
			queueForSync[idx] = nil
			initalizeOneSecondHook(ent)
		end
	end)]]
	hook_Add("InitPostEntity", "initializeLocalPlayer", function()
		initalizeOneSecondHook(LocalPlayer())
		--[[local plys = player_GetAll()
		for i = 1, #plys do
			timer_Simple(i * 0.5, function()
				initalizeOneSecondHook(plys[i])
			end)
		end]]
	end)
end
