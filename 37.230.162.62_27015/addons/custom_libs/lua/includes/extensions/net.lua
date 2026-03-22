TYPE_COLOR = 255

setmetatable(
	net,
	{
		__call = function(self, name, func)
			return self.Receive(name, func)
		end
	}
)

net.Receivers = {}

function net.Receive(name, func)
	net.Receivers[name:lower()] = func
end

local bspam = {}
function net.Incoming(len, client)
	local i = net.ReadHeader()
	local strName = util.NetworkIDToString(i)

	if (not strName) then
		return
	end

	strName = strName:lower()
	local func = net.Receivers[strName]
	if not func then
		if not bspam[strName] and SERVER then
			bspam[strName] = true
			ErrorNoHalt("[NET] " .. strName .. " pooled and doesn't have func.")
		end
		return
	end

	len = len - 16

	func(len, client)

	hook.Run("IncomingNetMessage", len, client)
end

net.WriteBool = net.WriteBit

function net.ReadBool()
	return net.ReadBit() == 1
end

local WriteUInt = net.WriteUInt
function net.WriteEntity(ent)
	if IsValid(ent) then
		WriteUInt(ent:EntIndex(), 13)
	else
		WriteUInt(0, 13)
	end
end

function net.ReadEntity()
	local i = net.ReadUInt(13)
	if not i then
		return
	end
	return Entity(i)
end

local ReadUInt = net.ReadUInt
function net.ReadUInt(bitCount)
	if (bitCount > 32) or (bitCount < 1) then
		ErrorNoHalt("Out of range bitCount! Got " .. bitCount)
		return
	end
	return ReadUInt(bitCount)
end

local ReadInt = net.ReadInt
function net.ReadInt(bitCount)
	if (bitCount > 32) or (bitCount < 1) then
		ErrorNoHalt("Out of range bitCount! Got " .. bitCount)
		return
	end
	return ReadInt(bitCount)
end

function net.WriteRGB(r, g, b)
	WriteUInt(r, 8)
	WriteUInt(g, 8)
	WriteUInt(b, 8)
end

function net.WriteRGBA(r, g, b, a)
	WriteUInt(r, 8)
	WriteUInt(g, 8)
	WriteUInt(b, 8)
	WriteUInt(a, 8)
end
local WriteRGBA = net.WriteRGBA

function net.WriteColor(c)
	WriteRGBA(c.r, c.g, c.b, c.a)
end

function net.ReadRGB()
	local RUInt = net.ReadUInt
	return RUInt(8), RUInt(8), RUInt(8)
end

function net.ReadRGBA()
	local RUInt = net.ReadUInt
	return RUInt(8), RUInt(8), RUInt(8), RUInt(8)
end
local ReadRGBA = net.ReadRGBA

function net.ReadColor()
	return Color(ReadRGBA())
end

function net.WriteByte(i)
	WriteUInt(i, 8)
end

function net.ReadByte()
	return net.ReadUInt(8)
end

function net.WriteShort(i)
	WriteUInt(i, 16)
end

function net.ReadShort()
	return net.ReadUInt(16)
end

function net.WriteLong(i)
	WriteUInt(i, 32)
end

function net.ReadLong()
	return net.ReadUInt(32)
end

function net.WriteTable(tab)
	local data = sfs.encode(tab)

	data = util.Compress(data)
	data = data or "" --Compress может вернуть nil.

	local data_len = #data
	net.WriteUInt(data_len, 16)
	net.WriteData(data, data_len)
end

function net.ReadTable()
	local data_len = net.ReadUInt(16)
	local data = net.ReadData(data_len)
	data = util.Decompress(data, 5242880)

	local p, res = pcall(sfs.decode, data)
	data = p and res or {}
	if not p then
		ErrorNoHalt("[net] Data is not table. \n" .. debug.traceback())
	end

	return data
end

function net.WriteChar(value)
	net.WriteByte((isstring(value) and string.char(value) or value))
end

function net.ReadChar()
	return net.ReadByte()
end

net.WriteVars = {
	[TYPE_NIL] = function(t, v)
		net.WriteUInt(t, 8)
	end,
	[TYPE_STRING] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteString(v)
	end,
	[TYPE_NUMBER] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteDouble(v)
	end,
	[TYPE_TABLE] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteTable(v)
	end,
	[TYPE_BOOL] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteBool(v)
	end,
	[TYPE_ENTITY] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteEntity(v)
	end,
	[TYPE_VECTOR] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteVector(v)
	end,
	[TYPE_ANGLE] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteAngle(v)
	end,
	[TYPE_MATRIX] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteMatrix(v)
	end,
	[TYPE_COLOR] = function(t, v)
		net.WriteUInt(t, 8)
		net.WriteColor(v)
	end
}

function net.WriteType(v)
	local typeid = nil

	if IsColor(v) then
		typeid = TYPE_COLOR
	else
		typeid = TypeID(v)
	end

	local wv = net.WriteVars[typeid]
	if (wv) then
		return wv(typeid, v)
	end

	ErrorNoHalt("net.WriteType: Couldn't write " .. type(v) .. " (type " .. typeid .. ")")
end

net.ReadVars = {
	[TYPE_NIL] = function()
		return nil
	end,
	[TYPE_STRING] = function()
		return net.ReadString()
	end,
	[TYPE_NUMBER] = function()
		return net.ReadDouble()
	end,
	[TYPE_TABLE] = function()
		return net.ReadTable()
	end,
	[TYPE_BOOL] = function()
		return net.ReadBool()
	end,
	[TYPE_ENTITY] = function()
		return net.ReadEntity()
	end,
	[TYPE_VECTOR] = function()
		return net.ReadVector()
	end,
	[TYPE_ANGLE] = function()
		return net.ReadAngle()
	end,
	[TYPE_MATRIX] = function()
		return net.ReadMatrix()
	end,
	[TYPE_COLOR] = function()
		return net.ReadColor()
	end
}

function net.ReadType(typeid)
	typeid = typeid or net.ReadUInt(8)

	local rv = net.ReadVars[typeid]
	if (rv) then
		return rv()
	end

	ErrorNoHalt("net.ReadType: Couldn't read type " .. typeid)
end

if SERVER then
	function util.AddNetworkStrings(...)
		local tab = {...}
		for i = 1, #tab do
			local id = tab[i]
			if id then
				util.AddNetworkString(id)
			end
		end
	end

	util.AddNetworkString("umsg.SendLua")
	function BroadcastLua(luaCode)
		luaCode = util.Compress(luaCode)
		local binLen = #luaCode

		net.Start("umsg.SendLua")
		net.WriteUInt(binLen, 16)
		net.WriteData(luaCode, binLen)
		net.Broadcast()
	end

	debug.getregistry().Player.SendLua = function(self, luaCode)
		luaCode = util.Compress(luaCode)
		local binLen = #luaCode

		net.Start("umsg.SendLua")
		net.WriteUInt(binLen, 16)
		net.WriteData(luaCode, binLen)
		net.Send(self)
	end
else
	net.Receive("umsg.SendLua", function()
		local binLen = net.ReadUInt(16)
		local code = net.ReadData(binLen)
		code = util.Decompress(code)

		RunString(code, "BroadcastLua/SendLua")
	end)
end

--[[-------------------------------------------------------------------------
Override state
---------------------------------------------------------------------------]]
local eMeta = debug.getregistry().Entity

--[[-------------------------------------------------------------------------
Get
---------------------------------------------------------------------------]]
eMeta.oldGetNWAngle = eMeta.GetNWAngle
eMeta.oldGetNWBool = eMeta.GetNWBool
eMeta.oldGetNWEntity = eMeta.GetNWEntity
eMeta.oldGetNWFloat = eMeta.GetNWFloat
eMeta.oldGetNWInt = eMeta.GetNWInt
eMeta.oldGetNWString = eMeta.GetNWString

eMeta.GetNWAngle = eMeta.GetNW2Angle
eMeta.GetNWBool = eMeta.GetNW2Bool
eMeta.GetNWEntity = eMeta.GetNW2Entity
eMeta.GetNWFloat = eMeta.GetNW2Float
eMeta.GetNWInt = eMeta.GetNW2Int
eMeta.GetNWString = eMeta.GetNW2String

--[[-------------------------------------------------------------------------
Set
---------------------------------------------------------------------------]]
eMeta.oldSetNWAngle = eMeta.SetNWAngle
eMeta.oldSetNWBool = eMeta.SetNWBool
eMeta.oldSetNWEntity = eMeta.SetNWEntity
eMeta.oldSetNWFloat = eMeta.SetNWFloat
eMeta.oldSetNWInt = eMeta.SetNWInt
eMeta.oldSetNWString = eMeta.SetNWString

eMeta.SetNWAngle = eMeta.SetNW2Angle
eMeta.SetNWBool = eMeta.SetNW2Bool
eMeta.SetNWEntity = eMeta.SetNW2Entity
eMeta.SetNWFloat = eMeta.SetNW2Float
eMeta.SetNWInt = eMeta.SetNW2Int
eMeta.SetNWString = eMeta.SetNW2String
--

--[[
	-- set names to prevent collisions.
	local str = {
		[1] = "DTAngle",
		[2] = "DTBool",
		[3] = "DTEntity",
		[4] = "DTFloat",
		[5] = "DTInt",
		[6] = "DTString",
		[7] = "DTVector"
	}

	-- restore GetDT* option to return default value.
	local defaultValue = {
		DTAngle = Angle(),
		DTBool = false,
		DTEntity = NULL,
		DTFloat = 0.0,
		DTInt = 0,
		DTString = "",
		DTVector = Vector()
	}

	-- cached DTVar tags to prevent concatenations, return only stored names.
	local cachedNames = {
		DTAngle = {},
		DTBool = {},
		DTEntity = {},
		DTFloat = {},
		DTInt = {},
		DTString = {},
		DTVector = {}
	}
	_G.cachedNames = cachedNames

	-- concatenate DT typename with index to prevent collision.
	local function checkTag(tag, var)
		local row = cachedNames[tag]

		-- i dunno, think not needed.
		-- if not row then
		-- 	cachedNames[tag] = {}
		-- end

		--cache typename first time.
		local data = row[var]
		if not data then
			row[var] = tag .. "_" .. var
			data = row[var]
		end
		return data
	end


	local function SetNetVar(self, tag, var, value)
		local name = checkTag(tag, var)
		return self:SetNetVar(name, value)
	end

	local function GetNetVar(self, tag, var, defaultValue)
		local name = checkTag(tag, var)
		return self:GetNetVar(name, defaultValue)
	end

	for _, v in ipairs(str) do
		eMeta["oldSet" .. v] = eMeta["Set" .. v]
		eMeta["Set" .. v] = function(self, var, value)
			return SetNetVar(self, v, var, value)
		end
	end

	for _, v in ipairs(str) do
		eMeta["oldGet" .. v] = eMeta["Get" .. v]
		eMeta["Get" .. v] = function(self, var)
			return GetNetVar(self, v, var, defaultValue[v])
		end
	end
--]]
-- local strSet = {
-- 	["SetDT2Angle"] = "SetNW2Angle",
-- 	["SetDT2Bool"] = "SetNW2Bool",
-- 	["SetDT2Entity"] = "SetNW2Entity",
-- 	["SetDT2Float"] = "SetNW2Float",
-- 	["SetDT2Int"] = "SetNW2Int",
-- 	["SetDT2String"] = "SetNW2String",
-- 	["SetDT2Vector"] = "SetNW2Vector"
-- }

-- local strGet = {
-- 	["GetDT2Angle"] = "GetNW2Angle",
-- 	["GetDT2Bool"] = "GetNW2Bool",
-- 	["GetDT2Entity"] = "GetNW2Entity",
-- 	["GetDT2Float"] = "GetNW2Float",
-- 	["GetDT2Int"] = "GetNW2Int",
-- 	["GetDT2String"] = "GetNW2String",
-- 	["GetDT2Vector"] = "GetNW2Vector"
-- }

-- local cachedNames = {}
-- local function cacheTag(tag, var)
-- 	local row = cachedNames[tag]
-- 	if not row then
-- 		local str = "DT2_" .. var
-- 		cachedNames[tag] = str
-- 		row = str
-- 	end
-- 	return row
-- end

-- for k, v in pairs(strSet) do
-- 	eMeta[k] = function(self, var, value)
-- 		local tag = cacheTag(v, var)
-- 		return eMeta[v](self, tag, value)
-- 	end
-- end

-- for k, v in pairs(strGet) do
-- 	eMeta[k] = function(self, var)
-- 		local tag = cacheTag(v, var)
-- 		return eMeta[v](self, tag)
-- 	end
-- end