local tEntityVars = _G.tEntityVars or {}
_G.tEntityVars = tEntityVars

local tMeta = FindMetaTable"Entity"
local fEntIndex = tMeta.EntIndex

do
	local function eGetVar(ent, sName, xDefault)
		local tEntTable = tEntityVars[fEntIndex(ent)]
		if not tEntTable then return xDefault end
		local xValue = tEntTable[sName]
		if xValue == nil then return xDefault end

		return xValue
	end

	local function eGetVars(ent)
		return tEntityVars[fEntIndex(ent)]
	end

	local function eSetVar(ent, sName, xValue)
		local iID = fEntIndex(ent)
		local tEntTable = tEntityVars[iID]

		if not tEntTable then
			tEntTable = {}
			tEntityVars[iID] = tEntTable
		end

		tEntTable[sName] = xValue
	end

	tMeta.GetVar = eGetVar
	tMeta.GetVars = eGetVars
	tMeta.SetVar = eSetVar

	_G.eGetVar = eGetVar
	_G.eGetVars = eGetVars
	_G.eSetVar = eSetVar

	local fIsPlayer = tMeta.IsPlayer
	hook.Add("EntityRemoved", "extensions.EntityRemoved", function(eEnt)
		if fIsPlayer(eEnt) then return end
		tEntityVars[fEntIndex(eEnt)] = nil
	end, HOOK_MONITOR_HIGH)

	hook.Add("PlayerInitialSpawn", "extensions.PlayerInitialSpawn", function(pPly)
		tEntityVars[fEntIndex(pPly)] = {}
	end, HOOK_MONITOR_HIGH)

	hook.Add("PlayerDisconnected", "extensions.PlayerDisconnected", function(pPly)
		tEntityVars[fEntIndex(pPly)] = false
	end, HOOK_MONITOR_LOW)
end

function tMeta:EnableMotion(bBool)
	local ePhys = self:GetPhysicsObject()
	if IsValid(ePhys) then return ePhys:EnableMotion(bBool) end
end

function tMeta:IsEnableMotion()
	local ePhys = self:GetPhysicsObject()
	if IsValid(ePhys) then return ePhys:IsEnableMotion() end
end

do
	local GetCTable = tMeta.GetCTable
	if not GetCTable then
		GetCTable = tMeta.GetTable
		tMeta.GetCTable = GetCTable
	end
	local cache = setmetatable({}, {__mode = "kv"})
	hook.Add("EntityRemove", "Entity.GetTable", function(entity, fullUpdate)
		if fullUpdate then return end
		return Simple(0, function()
			cache[entity] = nil
		end)
	end, HOOK_MONITOR_HIGH)
	local getTable
	getTable = function(entity)
		if cache[entity] == nil then
			cache[entity] = GetCTable(entity) or {}
		end
		return cache[entity]
	end
	tMeta.GetTable = getTable
	tMeta.__index = function(self, key)
		return tMeta[key] or getTable(self)[key]
	end
end