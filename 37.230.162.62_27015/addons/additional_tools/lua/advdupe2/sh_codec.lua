--[[
	Title: Adv. Dupe 2 Codec

	Desc: Dupe encoder/decoder.

	Author: emspike

	Version: 2.0
]]
local REVISION = 5

local pairs = pairs
local compress = util.Compress
local decompress = util.Decompress
local serialize = pon.encode
local deserialize = pon.decode
AdvDupe2.CodecRevision = REVISION

function AdvDupe2.CheckValidDupe(dupe, info)
	if not dupe.HeadEnt then return false, "Missing HeadEnt table" end
	if not dupe.Entities then return false, "Missing Entities table" end
	if not dupe.HeadEnt.Z then return false, "Missing HeadEnt.Z" end
	if not dupe.HeadEnt.Pos then return false, "Missing HeadEnt.Pos" end
	if not dupe.HeadEnt.Index then return false, "Missing HeadEnt.Index" end
	if not dupe.Entities[dupe.HeadEnt.Index] then return false, "Missing HeadEnt index [" .. dupe.HeadEnt.Index .. "] from Entities table" end

	for key, data in pairs(dupe.Entities) do
		if not data.PhysicsObjects then return false, "Missing PhysicsObject table from Entity [" .. key .. "][" .. data.Class .. "][" .. data.Model .. "]" end
		if not data.PhysicsObjects[0] then return false, "Missing PhysicsObject[0] table from Entity [" .. key .. "][" .. data.Class .. "][" .. data.Model .. "]" end
		if not data.PhysicsObjects[0].Pos then return false, "Missing PhysicsObject[0].Pos from Entity [" .. key .. "][" .. data.Class .. "][" .. data.Model .. "]" end
		if not data.PhysicsObjects[0].Angle then return false, "Missing PhysicsObject[0].Angle from Entity [" .. key .. "][" .. data.Class .. "][" .. data.Model .. "]" end
	end

	return true
end

--[[
	Name:	GenerateDupeStamp
	Desc:	Generates an info table.
	Params:	<player> ply
	Return:	<table> stamp
]]
function AdvDupe2.GenerateDupeStamp(ply)
	local stamp = {}
	stamp.name = ply:GetName()
	stamp.time = os.date("%I:%M %p")
	stamp.date = os.date("%d %B %Y")
	stamp.timezone = os.date("%z")
	hook.Call("AdvDupe2_StampGenerated", GAMEMODE, stamp)

	return stamp
end

--[[
	Name:	Encode
	Desc:	Generates the string for a dupe file with the given data.
	Params:	<table> dupe, <table> info, <function> callback, <...> args
	Return:	runs callback(<string> encoded_dupe, <...> args)
]]
function AdvDupe2.Encode(dupe, info, callback, ...)
	dupe._info = info

	local st, res = pcall(serialize, dupe)
	if not st then
		ErrorNoHaltWithStack("[ADVDUPE 2] " .. res)
		return
	end

	local encodedTable = compress(res)
	callback(encodedTable, ...)
end

--[[
	Name:	Decode
	Desc:	Generates the table for a dupe from the given string. Inverse of Encode
	Params:	<string> encodedDupe, <function> callback, <...> args
	Return:	runs callback(<boolean> success, <table/string> tbl, <table> info)
]]
function AdvDupe2.Decode(encodedDupe)
	local size = #encodedDupe
	local st, decomp = pcall(decompress, encodedDupe)
	if not st then
		ErrorNoHaltWithStack("[ADVDUPE 2] " .. decomp)
		return false, "Malformed dupe"
	end

	local st, res = pcall(deserialize, decomp)
	if not st then
		ErrorNoHaltWithStack("[ADVDUPE 2] " .. res)
		return false, "Malformed dupe"
	end

	local info = res._info
	res._info = nil
	info.size = size
	if not AdvDupe2.CheckValidDupe(res, info) then
		return false, "Malformed dupe"
	end

	return true, res, info
end