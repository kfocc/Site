local entIndex = FindMetaTable("Entity").EntIndex

local adminCachePlayers = adminCachePlayers or {}
_G.adminCachePlayers = adminCachePlayers

local disableCheck = {}
netstream.Hook("adminCache.UpdateAdmin", function(ei, value)
	adminCachePlayers[ei] = value
	local ent = Entity(ei)
	if IsValid(ent) then ent:CollisionRulesChanged() end
	local lp = LocalPlayer()
	if value == nil and ent == lp then disableCheck[lp] = nil end
end)

local excludeEnts = {}
local excludeClass = {
	func_tracktrain = true,
	-- worldspawn = true
}

hook.Add("ShouldCollide", "admin.CalculateCollide", function(ent1, ent2)
	if disableCheck[ent1] or disableCheck[ent2] then return end
	if adminCachePlayers[entIndex(ent1)] and not excludeEnts[ent2] then
		return false
	elseif adminCachePlayers[entIndex(ent2)] and not excludeEnts[ent1] then
		return false
	end
end)

hook.Add("OnEntityCreated", "admin.CacheEnt", function(ent)
	if excludeClass[ent:GetClass()] then
		excludeEnts[ent] = true
	end
end)

hook.Add("EntityRemoved", "admin.CacheEnt", function(ent)
	if excludeEnts[ent] then
		excludeEnts[ent] = nil
	end
end)

hook.Add("InitPostEntity", "admin.CacheEnt", function()
	excludeEnts[Entity(0)] = true
end)

netstream.Hook("admin.CollideDisable", function(should)
	local lp = LocalPlayer()
	disableCheck[lp] = should
	lp:CollisionRulesChanged()
end)
