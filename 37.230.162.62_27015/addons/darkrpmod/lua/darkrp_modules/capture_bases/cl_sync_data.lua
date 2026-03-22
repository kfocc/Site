captureBases = captureBases or {}
local basesCfg = captureBases.basesCfg
local syncMapping = {
	["started"] = function(zoneData)
		local status = net.ReadBool()
		zoneData.started = status
		if status then
			zoneData.lastCapture = net.ReadUInt(32)
		else
			zoneData.nextCapture = net.ReadUInt(32)
		end
	end,
	["nextCapture"] = function(zoneData) zoneData.nextCapture = net.ReadUInt(32) end,
	["leaderCount"] = function(zoneData) zoneData.leaderCount = net.ReadUInt(4) end,
	["insideZoneCount"] = function(zoneData) zoneData.insideZoneCount = net.ReadUInt(7) end,
}

net.Receive("captureBases.ZoneSync", function()
	local zoneID = net.ReadUInt(8)
	local zoneData = basesCfg[zoneID]
	if not zoneData then return end

	local syncID = net.ReadString()
	local syncFunc = syncMapping[syncID]
	if not syncFunc then return end
	syncFunc(zoneData)
end)

net.Receive("captureBases.InitialZoneSync", function()
	local zones = net.ReadTable()
	table.Merge(basesCfg, zones)
end)
