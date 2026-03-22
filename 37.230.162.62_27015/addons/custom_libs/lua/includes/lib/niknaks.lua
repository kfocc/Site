local version = 0.53
if NikNaks and NikNaks.VERSION > version then return end

local file_Find, MsgC, unpack = file.Find, MsgC, unpack

NikNaks = {}
NikNaks.net = {}
NikNaks.VERSION = version
NikNaks.Version = version -- For backwards compatibility
NikNaks.AUTHORS = { "Nak", "Phatso" }
NikNaks.__metatables = {}

do
	---A simply Msg function for NikNaks
	---@param ... any
	function NikNaks.Msg( ... )
		local a = {...}
		if #a < 1 then return end
		MsgC(NikNaks.REALM_COLOR,"[NN] ", unpack(a), "\n")
	end
end

---Auto includes, runs and AddCSLuaFile files using their prefix.
---@param str string File path
---@return any ... Anything the file returns
function NikNaks.AutoInclude( str )
	local path = str
	if string.find(str,"/") then
		path = string.GetFileFromFilename(str)
	end
	local _type
	if path ~= "shared.lua" then
		_type = string.sub(path,0,3)
	else
		_type = "sh_"
	end
	if SERVER then
		if _type == "cl_" or _type == "sh_" then
			AddCSLuaFile(str)
		end
		if _type ~= "cl_" then
			return include(str)
		end
	elseif _type ~= "sv_" then
		return include(str)
	end
end


--- @class BSPObject
local meta = {}
meta.__index = meta
meta.__tostring = function( self ) return string.format( "BSP Map [ %s ]", self._mapfile ) end
meta.MetaName = "BSP"
NikNaks.__metatables["BSP"] = meta
NikNaks._Source = "niknak"

-- NikNaks.AutoInclude("niknaks/modules/sh_hooks.lua")
do
	NikNaks.Hooks = {
		DataPackageStart = "NikNaks.DataPackage.Start",
		DataPackageDone = "NikNaks.DataPackage.Done",
	}
end
--NikNaks.AutoInclude("niknaks/modules/sh_enums.lua")
do
	-- Globals
	NikNaks.vector_zero = Vector( 0, 0, 0 )
	NikNaks.vector_down = Vector( 0, 0, -1 )

	NikNaks.angle_up = NikNaks.vector_zero:Angle()
	NikNaks.angle_down = NikNaks.vector_down:Angle()

	-- Cap move only exists server-side, so we need to define it here.
	NikNaks.CAP_MOVE_GROUND								= 0x01 -- walk/run
	NikNaks.CAP_MOVE_JUMP								= 0x02 -- jump/leap
	NikNaks.CAP_MOVE_FLY								= 0x04 -- can fly, move all around
	NikNaks.CAP_MOVE_CLIMB								= 0x08 -- climb ladders
	--CAP_MOVE_SWIM / bits_BUILD_GIVEWAY?	= 0x10 -- navigate in water			// Removed by Valve: UNDONE - not yet implemented
	--CAP_MOVE_CRAWL						= 0x20 -- crawl						// Removed by Valve: UNDONE - not yet implemented

	-- AI Nodes
	---@alias NODE_TYPE
	---| `NikNaks.NODE_TYPE_INVALID`
	---| `NikNaks.NODE_TYPE_ANY`
	---| `NikNaks.NODE_TYPE_DELETED`
	---| `NikNaks.NODE_TYPE_GROUND`
	---| `NikNaks.NODE_TYPE_AIR`
	---| `NikNaks.NODE_TYPE_CLIMB`

	NikNaks.NODE_TYPE_INVALID 	=-1 -- Any nodes not matching these
	NikNaks.NODE_TYPE_ANY 		= 0
	NikNaks.NODE_TYPE_DELETED 	= 1 -- Internal in hammer?
	NikNaks.NODE_TYPE_GROUND 	= 2
	NikNaks.NODE_TYPE_AIR 		= 3
	NikNaks.NODE_TYPE_CLIMB 	= 4
	--NODE_TYPE_WATER 	= 5	-- Unused? I have no idea, since CAP_MOVE_SWIM seems unused and the fish use air nodes.

	--- HULL enums excists server-side, so we need to define it here.
	NikNaks.HULL_HUMAN 			= 0	--	30w, 73t		// Combine, Stalker, Zombie...
	NikNaks.HULL_SMALL_CENTERED = 1	--	40w, 40t		// Scanner
	NikNaks.HULL_WIDE_HUMAN		= 2	--	?				// Vortigaunt
	NikNaks.HULL_TINY			= 3	--	24w, 24t		// Headcrab
	NikNaks.HULL_WIDE_SHORT		= 4	--	?				// Bullsquid
	NikNaks.HULL_MEDIUM			= 5	--	36w, 65t		// Cremator
	NikNaks.HULL_TINY_CENTERED	= 6	--	16w, 8t			// Manhack
	NikNaks.HULL_LARGE			= 7	--	80w, 100t		// Antlion Guard
	NikNaks.HULL_LARGE_CENTERED = 8	--	?				// Mortar Synth / Strider
	NikNaks.HULL_MEDIUM_TALL	= 9	--	36w, 100t		// Hunter
	NikNaks.NUM_HULLS			= 10
	-- HULL_NONE				= 11 -- Max enum value

	---@alias STATIC_PROP_FLAG
	---| `NikNaks.STATIC_PROP_FLAG_FADES`
	---| `NikNaks.STATIC_PROP_USE_LIGHTING_ORIGIN`
	---| `NikNaks.STATIC_PROP_NO_DRAW`
	---| `NikNaks.STATIC_PROP_IGNORE_NORMALS`
	---| `NikNaks.STATIC_PROP_NO_SHADOW`
	---| `NikNaks.STATIC_PROP_MARKED_FOR_FAST_REFLECTION`
	---| `NikNaks.STATIC_PROP_NO_PER_VERTEX_LIGHTING`
	---| `NikNaks.STATIC_PROP_NO_SELF_SHADOWING`
	---| `NikNaks.STATIC_PROP_WC_MASK`

	NikNaks.STATIC_PROP_FLAG_FADES = 1 -- Fades.
	NikNaks.STATIC_PROP_USE_LIGHTING_ORIGIN = 2-- Use the lighting origin.
	NikNaks.STATIC_PROP_NO_DRAW = 4 -- No draw.
	NikNaks.STATIC_PROP_IGNORE_NORMALS = 8 -- Ignore normals.
	NikNaks.STATIC_PROP_NO_SHADOW = 16 -- No shadow.
	NikNaks.STATIC_PROP_MARKED_FOR_FAST_REFLECTION = 32 -- Marked for fast reflection.
	NikNaks.STATIC_PROP_NO_PER_VERTEX_LIGHTING = 64 -- Disables per vertex lighting.
	NikNaks.STATIC_PROP_NO_SELF_SHADOWING = 128 -- Disables self shadowing.
	NikNaks.STATIC_PROP_WC_MASK = 220	-- All flags settable in hammer.

	---@alias STATIC_PROP_FLAG_EX
	---| `NikNaks.STATIC_PROP_FLAGS_EX_DISABLE_SHADOW_DEPTH` -- Do not render this prop into the CSM or flashlight shadow depth map.
	---| `NikNaks.STATIC_PROP_FLAGS_EX_DISABLE_CSM` -- Disables cascaded shadow maps.
	---| `NikNaks.STATIC_PROP_FLAGS_EX_ENABLE_LIGHT_BOUNCE` -- Enables light bounce in vrad.

	NikNaks.STATIC_PROP_FLAGS_EX_DISABLE_SHADOW_DEPTH = 1 -- Do not render this prop into the CSM or flashlight shadow depth map.
	NikNaks.STATIC_PROP_FLAGS_EX_DISABLE_CSM = 2 -- Disables cascaded shadow maps.
	NikNaks.STATIC_PROP_FLAGS_EX_ENABLE_LIGHT_BOUNCE = 4 -- Enables light bounce in vrad.

	-- Errors
	---@alias BSP_ERROR
	---| `NikNaks.BSP_ERROR_FILECANTOPEN`
	---| `NikNaks.BSP_ERROR_NOT_BSP`
	---| `NikNaks.BSP_ERROR_TOO_NEW`
	---| `NikNaks.BSP_ERROR_FILENOTFOUND`

	NikNaks.BSP_ERROR_FILECANTOPEN  = 0 -- This error is thrown when the file can't be opened.
	NikNaks.BSP_ERROR_NOT_BSP 		= 1 -- This error is thrown when the file isn't a BSP-file.
	NikNaks.BSP_ERROR_TOO_NEW 		= 2 -- This error is thrown when the file is too new.
	NikNaks.BSP_ERROR_FILENOTFOUND 	= 3 -- This error is thrown when the file isn't found.

	--[[ TODO: AI movement
	NikNaks.PATHTYPE_NONE=-1	-- In case there are no path-options on the map
	NikNaks.PATHTYPE_AIN = 0
	NikNaks.PATHTYPE_NAV = 1
	NikNaks.PATHTYPE_NIKNAV = 2

	-- How the NPC should move
	NikNaks.PATHMOVETYPE_GROUND = 0
	NikNaks.PATHMOVETYPE_FLY 	= 1
	]]
end
--NikNaks.AutoInclude("niknaks/modules/sh_util_extended.lua")
do
	local NikNaks = NikNaks
	local tostring, tonumber, tobool, Angle, Vector, string_ToColor, max = tostring, tonumber, tobool, Angle, Vector, string.ToColor, math.max

	--- Same as AccessorFunc, but will make 'Set' functions return self. Allowing you to chain-call.
	--- @param tab table
	--- @param varname string
	--- @param name string
	--- @param iForce? number
	function NikNaks.AccessorFuncEx( tab, varname, name, iForce )
		if not tab then debug.Trace() end
		tab[ "Get" .. name ] = function( self ) return self[ varname ] end
		if ( iForce == FORCE_STRING ) then
			tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tostring( v ) return self end
		return end
		if ( iForce == FORCE_NUMBER ) then
			tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tonumber( v ) return self end
		return end
		if ( iForce == FORCE_BOOL ) then
			tab[ "Set" .. name ] = function( self, v ) self[ varname ] = tobool( v ) return self end
		return end
		if ( iForce == FORCE_ANGLE ) then
			tab[ "Set" .. name ] = function( self, v ) self[ varname ] = Angle( v ) return self end
		return end
		if ( iForce == FORCE_COLOR ) then
			tab[ "Set" .. name ] = function( self, v )
				if ( NikNaks.type( v ) == "Vector" ) then self[ varname ] = v:ToColor()
				else self[ varname ] = string_ToColor( tostring( v ) ) end
				return self
			end
		return end
		if ( iForce == FORCE_VECTOR ) then
			tab[ "Set" .. name ] = function( self, v )
				if ( IsColor( v ) ) then self[ varname ] = v:ToVector()
				else self[ varname ] = Vector( v ) end
				return self
			end
		return end
		tab[ "Set" .. name ] = function( self, v ) self[ varname ] = v return self end
	end

	NikNaks.util = {}

	-- Hull
	do
		--- Returns a HULL_ENUM fitting the hull given.
		--- @param vecMin Vector
		--- @param vecMax Vector
		--- @return HULL HULL_ENUM
		function NikNaks.util.FindHull( vecMin, vecMax )
			local wide = max(-vecMin.x, -vecMin.y, vecMax.x, vecMax.y)
			local high = vecMax.z - vecMin.z
			if wide <= 16 and high <= 8 then
				return NikNaks.HULL_TINY_CENTERED
			elseif wide <= 24 and high <= 24 then
				return NikNaks.HULL_TINY
			elseif wide <= 40 and high <= 40 then
				return NikNaks.HULL_SMALL_CENTERED
			elseif wide <= 36 and high <= 65 then
				return NikNaks.HULL_MEDIUM
			elseif wide <= 32 and high <= 73 then
				return NikNaks.HULL_HUMAN
			elseif wide <= 36 and high <= 100 then
				return NikNaks.HULL_MEDIUM_TALL
			else
				return NikNaks.HULL_LARGE
			end
		end

		--- Returns a HULL_ENUM matching the entitys hull.
		--- @param entity Entity|Player|NPC
		--- @return HULL HULL_ENUM
		function NikNaks.util.FindEntityHull( entity )
			-- Players and NPCs have a hull function
			local mi,ma
			if entity.GetHull then
				mi, ma = entity:GetHull()
			else
				mi, ma = entity:OBBMins(), entity:OBBMaxs()
			end
			return NikNaks.util.FindHull( mi, ma )
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_randomizer.lua")
--NikNaks.AutoInclude("niknaks/modules/sh_linq_module.lua")
do
	---@class LINQ
	local t = {}
	t.__index = t
	t.MetaName = "LINQ"
	NikNaks.__metatables["LINQ"] = t

	---Creates a new LINQ object.
	---
	---**Note**: Table needs to be an array.
	---@generic T: any
	---@param tbl T[]
	---@return LINQ
	function NikNaks.LINQ(tbl)
		local self = setmetatable({}, t)
		---@diagnostic disable-next-line: invisible
		self.tbl = tbl
		return self
	end

	---Returns as a string
	---@return string
	function t:ToString()
		return "LINQ[" .. self:Count() .. "]"
	end

	--#region Filters

	---Filters the table based on the given predicate
	---@param predicate function
	---@return self
	function t:Where(predicate)
		local tbl = {}
		for k, v in pairs(self.tbl) do
			if predicate(v, k) then
				table.insert(tbl, v)
			end
		end
		self.tbl = tbl
		return self
	end

	---Projects the table based on the given selector
	---@param selector function
	---@return self
	function t:Select(selector)
		local tbl = {}
		for k, v in pairs(self.tbl) do
			local a, b, c, d, e, f = selector(v, k)
			if b == nil then
				table.insert(tbl, a)
			else
				table.insert(tbl, {a, b, c, d, e, f})
			end
		end
		self.tbl = tbl
		return self
	end

	---Projects the table based on the given selector. Flattens the result (Each element in the result is a separate element in the table)
	---@param selector function
	---@return self
	function t:SelectMany(selector)
		local tbl = {}
		for k, v in pairs(self.tbl) do
			for _, value in ipairs({selector(v, k)}) do
				table.insert(tbl, value)
			end
		end
		self.tbl = tbl
		return self
	end

	---Filters the table based on the given type.
	---
	---**Warning:** This function is slow and should be used sparingly.
	---@param strType string
	---@return self
	function t:OfType(strType)
		local tbl = {}
		for _, v in pairs(self.tbl) do
			if strType == type(v) then
				table.insert(tbl, v)
			end
		end
		self.tbl = tbl
		return self
	end

	---Filters the table based on the given types.
	---
	---**Warning:** This function is slow and should be used sparingly.
	---@param types table<string>
	---@return self
	function t:OfTypes(types)
		local tbl = {}
		for _, v in pairs(self.tbl) do
			if table.HasValue(types, type(v)) then
				table.insert(tbl, v)
			end
		end
		self.tbl = tbl
		return self
	end

	--#endregion

	--#region Variables

	---Returns the first element that satisfies the predicate
	---@param predicate function
	---@return any
	function t:Single(predicate)
		for k, v in pairs(self.tbl) do
			if predicate(v, k) then
				return v
			end
		end
		return nil
	end

	---Returns the first element that satisfies the predicate or the default value
	---@param predicate function
	---@param default any
	---@return any
	function t:SingleOrDefault(predicate, default)
		for k, v in pairs(self.tbl) do
			if predicate(v, k) then
				return v
			end
		end
		return default
	end

	---Returns true if any element in the table satisfies the predicate
	---@param predicate any
	---@return boolean
	function t:Any(predicate)
		for k, v in pairs(self.tbl) do
			if predicate(v, k) then
				return true
			end
		end
		return false
	end

	---Returns true if all elements in the table satisfy the predicate
	---@param predicate any
	---@return boolean
	function t:All(predicate)
		for k, v in pairs(self.tbl) do
			if not predicate(v, k) then
				return false
			end
		end
		return true
	end

	---Returns the number of elements in the table
	---@return number
	function t:Count()
		return #self.tbl
	end

	---Returns true if the table is empty
	---@return boolean
	function t:Empty()
		return #self.tbl == 0
	end

	---Returns the sum of the elements in the table
	---@return number
	---
	---**Warning:** This function only works with numbers.
	function t:Sum()
		local sum = 0
		for k, v in pairs(self.tbl) do
			sum = sum + v
		end
		return sum
	end

	---Returns the average of the elements in the table
	---@return number
	---
	---**Warning:** This function only works with numbers.
	function t:Average()
		return self:Sum() / self:Count()
	end

	---Returns the minimum element in the table
	---@return any
	function t:Min()
		local min = self.tbl[1]
		for k, v in pairs(self.tbl) do
			if v < min then
				min = v
			end
		end
		return min
	end

	---Returns the maximum element in the table
	---@return any
	function t:Max()
		local max = self.tbl[1]
		for k, v in pairs(self.tbl) do
			if v > max then
				max = v
			end
		end
		return max
	end

	---Returns true if the table contains the element
	---@param element any
	---@return boolean
	function t:Contains(element)
		for k, v in pairs(self.tbl) do
			if v == element then
				return true
			end
		end
		return false
	end

	---First element of the table
	---@return any
	function t:First()
		return self.tbl[1]
	end

	---First element of the table or the default value
	---@param default any
	---@return any
	function t:FirstOrDefault(default)
		local val = self.tbl[1]
		return val == nil and default or val
	end

	---Last element of the table
	---@return any
	function t:Last()
		return self.tbl[#self.tbl]
	end

	---Last element of the table or the default value
	---@param default any
	---@return any
	function t:LastOrDefault(default)
		local val = self.tbl[#self.tbl]
		return val == nil and default or val
	end

	---Element at the given index
	---@param index number
	---@return any
	function t:ElementAt(index)
		return self.tbl[index]
	end

	---Element at the given index or the default value
	---@param index number
	---@param default any
	---@return any
	function t:ElementAtOrDefault(index, default)
		local val = self.tbl[index]
		return val == nil and default or val
	end

	---Returns as a table
	---@return any[]
	function t:ToTable()
		return self.tbl
	end

	--#endregion

	--#region Modifiers

	---Splits it into chunks of the given size
	---@param size number
	---@return any[]
	function t:Chunk(size)
		---@type LINQ[]
		local result = {}
		local chunk = {}
		local num = #self.tbl
		for i = 1, num do
			table.insert(chunk, self.tbl[i])
			if i % size == 0 or i == num then
				table.insert(result, chunk)
				chunk = {}
			end
		end
		return result
	end

	---Orders the table based on the given comparer
	---@param comparer function?
	---@return self
	function t:OrderBy(comparer)
		table.sort(self.tbl, comparer)
		return self
	end

	---Reverses the table
	---@return self
	function t:Reverse()
		local tbl = {}
		for i = #self.tbl, 1, -1 do
			table.insert(tbl, self.tbl[i])
		end
		self.tbl = tbl
		return self
	end

	---Distincts the table
	---@return self
	function t:Distinct()
		local tbl = {}
		for k, v in pairs(self.tbl) do
			if not table.HasValue(tbl, v) then
				table.insert(tbl, v)
			end
		end
		self.tbl = tbl
		return self
	end

	---Unions the table with the given table
	---@param tbl LINQ
	---@return self
	function t:Union(tbl)
		for _, v in pairs(tbl.tbl) do
			if not table.HasValue(self.tbl, v) then
				table.insert(self.tbl, v)
			end
		end
		return self
	end

	---Intersects the table with the given table
	---@param tbl LINQ
	---@return self
	function t:Intersect(tbl)
		local newTbl = {}
		for _, v in pairs(self.tbl) do
			if table.HasValue(tbl.tbl, v) then
				table.insert(newTbl, v)
			end
		end
		self.tbl = newTbl
		return self
	end

	---Zips the table with the given table
	---@param tbl LINQ
	---@param func function<any, any> # Returns the new value based on the two values.
	---@return self
	function t:Zip(tbl, func)
		local newTbl = {}
		for i = 1, math.min(#self.tbl, #tbl.tbl) do
			table.insert(newTbl, func(self.tbl[i], tbl.tbl[i]))
		end
		self.tbl = newTbl
		return self
	end

	---Groups the table based on the given keySelector
	---@param keySelector function<string> # The key selector.
	---@return self
	function t:GroupBy(keySelector)
		local tbl = {}
		for k, v in pairs(self.tbl) do
			local key = keySelector(v, k)
			if not tbl[key] then
				tbl[key] = {}
			end
			table.insert(tbl[key], v)
		end
		self.tbl = tbl
		return self
	end

	---Skips the first n elements
	---@param n number
	---@return self
	function t:Skip(n)
		local tbl = {}
		for i = n + 1, #self.tbl do
			table.insert(tbl, self.tbl[i])
		end
		self.tbl = tbl
		return self
	end

	---Skips the last n elements
	---@param n number
	---@return self
	function t:SkipLast(n)
		local tbl = {}
		for i = 1, #self.tbl - n do
			table.insert(tbl, self.tbl[i])
		end
		self.tbl = tbl
		return self
	end

	---Skips elements from the beginning until the predicate is false
	---@param predicate function
	---@return self
	function t:SkipWhile(predicate)
		local tbl = {}
		local skip = true
		for k, v in pairs(self.tbl) do
			if skip and not predicate(v, k) then
				skip = false
			end
			if not skip then
				table.insert(tbl, v)
			end
		end
		self.tbl = tbl
		return self
	end

	---Takes the first n elements
	---@param n number
	---@return self
	function t:Take(n)
		local tbl = {}
		for i = 1, n do
			table.insert(tbl, self.tbl[i])
		end
		self.tbl = tbl
		return self
	end

	---Takes the last n elements
	---@param n number
	---@return self
	function t:TakeLast(n)
		local tbl = {}
		for i = #self.tbl - n + 1, #self.tbl do
			table.insert(tbl, self.tbl[i])
		end
		self.tbl = tbl
		return self
	end

	---Takes elements from the beginning until the predicate is false
	---@param predicate function
	---@return self
	function t:TakeWhile(predicate)
		local tbl = {}
		for k, v in pairs(self.tbl) do
			if not predicate(v, k) then
				break
			end
			table.insert(tbl, v)
		end
		self.tbl = tbl
		return self
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_file_extended.lua")
do
	---@class File
	local FILE = FindMetaTable( "File" )

	-- Exstra file functions

	--- Returns true if the file is valid and can be written to.
	--- @return boolean
	function FILE:IsValid()
		return tostring( self ) ~= "[NULL File]"
	end

	--- Writes a vector to the file.
	--- @param vector Vector
	function FILE:WriteVector( vector )
		self:WriteFloat( vector.x )
		self:WriteFloat( vector.y )
		self:WriteFloat( vector.z )
	end

	--- Reads a vector from the file.
	--- @return Vector
	function FILE:ReadVector()
		return Vector( self:ReadFloat(), self:ReadFloat(), self:ReadFloat() )
	end

	NikNaks.file = {}
	--- Same as file.Write, but will automatically create folders and return true if successful.
	--- @param fileName string
	--- @param contents string
	--- @return boolean
	function NikNaks.file.WriteEx( fileName, contents )
		local a = string.Explode( "/", fileName )
		assert( #a <= 10, "Unable to create an unreasonable array of folders!" )

		if #a > 1 then
			file.CreateDir( string.GetPathFromFilename( fileName ) )
		end

		local f = file.Open( fileName, "wb", "DATA" )
		if not f then return false end

		f:Write( contents )
		f:Close()

		return true
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_color_extended.lua")
--NikNaks.AutoInclude("niknaks/modules/sh_model_extended.lua")
do
	local file_Open, file_Exists = file.Open, file.Exists
	local cache = {}

	--- Returns the model's hull size. If the model is not found, it will return two zero vectors.
	--- @param name string
	--- @return Vector MinVec
	--- @return Vector MaxVec
	function NikNaks.ModelSize( name )
		if cache[name] then
			return Vector( cache[name][1] ), Vector( cache[name][2] )
		end

		if not file_Exists( name, "GAME" ) then
			cache[name] = { Vector(), Vector() }
			return Vector( cache[name][1] ), Vector( cache[name][2] )
		end

		local f = file_Open( name, "r", "GAME" )
		if f == nil then
			cache[name] = { Vector(), Vector() }
			return Vector( cache[name][1] ), Vector( cache[name][2] )
		end

		f:Seek( 104 )

		local hullMin = Vector( f:ReadFloat(), f:ReadFloat(), f:ReadFloat() )
		local hullMax = Vector( f:ReadFloat(), f:ReadFloat(), f:ReadFloat() )

		f:Close()

		cache[name] = { hullMin, hullMax }
		return Vector( hullMin ), Vector( hullMax )
	end
end

do
	local util_GetModelMeshes, Material = util.GetModelMeshes, Material

	--- Returns the materials used for this model. This can be expensive, so cache the result.
	--- @param name any
	--- @param lod? number
	--- @param bodygroupMask? number
	--- @return IMaterial[]
	function NikNaks.ModelMaterials( name, lod, bodygroupMask )
		local data = util_GetModelMeshes( name, lod or 0, bodygroupMask or 0 )
		if not data then return {} end

		local t = {}
		for i = 1, #data do
			local mat = data[i]["material"]

			if mat then
				table.insert( t, (Material( mat )) )
			end
		end
		return t
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bitbuffer.lua")
do
	local s_char, s_byte, tostring = string.char, string.byte, tostring
	local band, brshift, blshift, bor, bswap = bit.band, bit.rshift, bit.lshift, bit.bor, bit.bswap
	local log, ldexp, frexp, floor, ceil, max, setmetatable, source = math.log, math.ldexp, math.frexp, math.floor, math
		.ceil, math.max, setmetatable, jit.util.funcinfo(NikNaks.AutoInclude)["source"]

	--- @class BitBufferModule
	NikNaks.BitBuffer = {}

	--- @class BitBuffer
	--- @field _data number[]
	--- @field _tell number
	--- @field _len number
	--- @field _little_endian boolean
	local meta = {}
	meta.__index = meta
	function meta:__tostring()
		return "BitBuffer [" .. self:Size() .. "]"
	end

	--- Fixes bit-shift errors
	--- @param int number
	--- @param shift number
	--- @return number
	local function rshift(int, shift)
		if shift > 31 then return 0x0 end
		return brshift(int, shift)
	end

	--- @param int number
	--- @param shift number
	--- @return number
	local function lshift(int, shift)
		if shift > 31 then return 0x0 end
		return blshift(int, shift)
	end

	-- "Crams" the data into the bitbuffer. Ignoring offsets
	local function unsaferawdata(self, str)
		if #str <= 0 then return end

		local len = #str
		local p = #self._data
		local whole = lshift(rshift(len - 4, 2), 2) -- Bytes

		for i = 1, whole, 4 do
			local a, b, c, d = s_byte(str, i, i + 3)
			p = p + 1
			self._data[p] = bor(lshift(a, 24), lshift(b, 16), lshift(c, 8), d)
		end

		self._tell = lshift(p, 5)
		for i = whole + 1, len do
			meta.WriteByte(self, s_byte(str, i))
		end

		self._len = max(self._len, lshift(len, 3))
	end

	--- @param little_endian? boolean
	--- @return BitBuffer
	local function create(data, little_endian)
		--- @type BitBuffer
		local t = {
			_data = {},
			_tell = 0,
			_len = 0,
			_little_endian = little_endian == nil and true or little_endian or false
		}
		setmetatable(t, meta)

		if not data then return t end
		local mt = getmetatable(data)

		if type(data) == "string" then
			unsaferawdata(t, data)
			t._tell = 0 -- Reset tell
		elseif not mt then
			local q = #data
			for i = 1, q do
				t._data[i] = data[i]
			end
			t._len = q * 32
		end

		return t
	end

	NikNaks.BitBuffer.Create = create
	setmetatable(NikNaks.BitBuffer, {
		--- Creates a new BitBuffer
		--- @param data string|table
		--- @param little_endian boolean?
		--- @return BitBuffer
		__call = function(_, data, little_endian) return create(data, little_endian) end
	})

	-- Simple int->string and reverse. ( Little-Endian )
	do
		--- Takes a string of 1-4 charectors and converts it into a Little-Endian int
		--- @param str string
		--- @return number
		function NikNaks.BitBuffer.StringToInt(str)
			local a, b, c, d = s_byte(str, 1, 4)
			if d then
				return bor(blshift(d, 24), blshift(c, 16), blshift(b, 8), a)
			elseif c then
				return bor(blshift(c, 16), blshift(b, 8), a)
			elseif b then
				return bor(blshift(b, 8), a)
			else
				return a
			end
		end

		local q = 0xFF
		--- Takes an Little-Endian number and converts it into a 4 char-string
		--- @param int number
		--- @return string
		function NikNaks.BitBuffer.IntToString(int)
			local a, b, c, d = brshift(int, 24), band(brshift(int, 16), q), band(brshift(int, 8), q), band(int, q)
			return s_char(d, c, b, a)
		end
	end

	-- To signed and unsigned
	local to_signed
	do
		local maxint = {}
		for i = 1, 32 do
			local n = i
			maxint[i] = math.pow(2, n - 1)
		end

		function to_signed(int, bits)
			if int < 0 then return int end -- Already signed
			local maximum = maxint[bits]
			return int - band(int, maximum) * 2
		end
	end

	-- Access
	do
		--- Returns lengh of the BitBuffer.
		--- @return number
		function meta:__len()
			return self._len
		end

		meta.Size = meta.__len

		--- Returns where we're reading/writing from.
		--- @return number
		function meta:Tell()
			return self._tell
		end

		--- Sets the tell to a position.
		--- @param num number
		--- @return self
		function meta:Seek(num)
			self._tell = brshift(blshift(num, 1), 1)
			return self
		end

		--- Skips x bits ahead.
		--- @param num number
		--- @return BitBuffer self
		function meta:Skip(num)
			self._tell = self._tell + num
			return self
		end

		--- Returns true if we've reached the end of the bitbuffer.
		--- @return boolean
		function meta:EndOfData()
			return self._tell >= self._len
		end

		--- Clears all data from the BitBuffer.
		--- @return BitBuffer self
		function meta:Clear()
			self._data = {}
			self._len = 0
			self._tell = 0
			return self
		end

		--- Converts a number to bits. ( Big-Endian )
		--- @param num number
		--- @param bits number
		--- @return string
		local function toBits(num, bits, byte_space)
			local str = ""
			for i = bits, 1, -1 do
				if byte_space and i % 8 == 0 and i < 32 then
					str = str .. " "
				end
				local b = band(num, lshift(0x1, i - 1)) == 0
				str = str .. (b and "0" or "1")
			end
			return str
		end
		NikNaks.BitBuffer.ToBits = toBits

		--- Debug print function for the bitbuffer.
		function meta:Debug()
			local size = string.NiceSize(self._len / 8)
			local rep = string.rep("=", (32 - (#size + 6)) / 2)
			print("BitBuff	" ..
				rep .. " [" .. size .. "] " .. (self:IsLittleEndian() and "Le " or "Be ") .. rep .. "\t= 0xHX =")
			for i = 1, math.min(#self._data, 10) do
				print(i, toBits(self._data[i], 32), bit.tohex(self._data[i]):upper())
			end
		end

		--- Returns true if the bitbuffer is little-endian.
		--- @return boolean
		function meta:IsLittleEndian()
			return self._little_endian or false
		end

		--- Returns true if the bitbuffer is big-endian.
		--- @return boolean
		function meta:IsBigEndian()
			return not self._little_endian
		end

		--- Sets the bitbuffer to be little-endian.
		--- @return self BitBuffer The BitBuffer that was modified
		function meta:SetLittleEndian()
			self._little_endian = true
			return self
		end

		--- Sets the bitbuffer to be big-endian.
		--- @return self BitBuffer The BitBuffer that was modified
		function meta:SetBigEndian()
			self._little_endian = false
			return self
		end
	end

	-- Write / Read Raw
	local writeraw, readraw
	do
		-- Need to check endian type here.
		-- B |--|--|FF|11|
		-- L |--|--|11|FF|

		-- B |--|-F|FF|11| -- Input
		-- S |11|FF|-F|--| -- Swap
		-- > |--|11|FF|-F| -- rshift
		-- L |--|-1|1F|FF| -- Output

		-- B |00000000|00000000|00000000|00000000|
		local b_mask = 0xFFFFFFFF

		--- @param int number
		--- @param bits number
		--- @return number
		local function swap(int, bits)
			return brshift(bswap(int), 32 - bits)
		end

		--- @param self BitBuffer
		--- @param int number
		--- @param bits number
		--- @return self BitBuffer The BitBuffer that was modified
		function writeraw(self, int, bits)
			if self._little_endian and bits % 8 == 0 then
				int = swap(int, bits)
			end

			local tell = self._tell
			self._tell = tell + bits
			self._len = max(self._len, self._tell)

			-- Retrive data pos
			local i_word = rshift(tell, 5) + 1 -- [ 1 - length ]
			local bitPos = tell % 32     -- [[ 0 - 31 ]]
			local ebitPos = bitPos + bits -- The end bit pos

			-- DataMask & Data
			local mask = bor(lshift(b_mask, 32 - bitPos), rshift(b_mask, ebitPos))
			local data = band(self._data[i_word] or 0x0, mask)

			-- Write the data
			if ebitPos <= 32 then
				self._data[i_word] = bor(data, lshift(int, 32 - ebitPos))
				return self
			end

			local overflow = ebitPos - 32 -- [[ 1, 31 ]]
			self._data[i_word] = bor(data, rshift(int, overflow))

			data = band(rshift(b_mask, overflow), self._data[i_word + 1] or 0x0)
			self._data[i_word + 1] = bor(data, lshift(int, 32 - overflow))

			return self
		end

		--- @param self BitBuffer
		--- @param bits number
		--- @return number # The read data
		function readraw(self, bits)
			local tell = self._tell
			self._tell = tell + bits

			-- Retrive data pos
			local i_word = rshift(tell, 5) + 1 -- [ 1 - length ]
			local bitPos = tell % 32     -- [[ 0 - 31 ]]
			local ebitPos = bitPos + bits -- The end bit pos

			-- DataMask & Data
			if ebitPos <= 32 then
				local data = brshift(self._data[i_word] or 0x0, 32 - ebitPos)
				if self._little_endian and bits % 8 == 0 then
					return swap(band(data, brshift(b_mask, 32 - bits)), bits)
				end
				return band(data, brshift(b_mask, 32 - bits))
			end

			local over = ebitPos - 32 -- How many bits we're over
			local data1 = lshift(band(self._data[i_word] or 0x0, rshift(b_mask, bitPos)), over)
			local data2 = rshift(self._data[i_word + 1] or 0x0, 32 - over)

			if self._little_endian and bits % 8 == 0 then
				return swap(bor(data1, data2), bits)
			end

			return bor(data1, data2)
		end

		if not source:find("niknak") then return end
	end

	--- Add raw (debug) functions
	meta._writeraw = writeraw
	meta._readraw = readraw

	-- Boolean
	do
		local b_mask = 0xFFFFFFFF
		--We don't need to call write/read raw. Since this is 1 bit.

		--- Writes a boolean.
		--- @param b boolean
		--- @return self BitBuffer
		function meta:WriteBoolean(b)
			local tell = self._tell
			self._tell = tell + 1
			self._len = max(self._len, self._tell)

			-- Retrive data pos
			local i_word = rshift(tell, 5) + 1 -- [ 1 - length ]
			local bitPos = tell % 32     -- [[ 0 - 31 ]]
			local ebitPos = bitPos + 1

			-- DataMask & Data
			local mask = bor(lshift(b_mask, 32 - bitPos), rshift(b_mask, ebitPos))
			local data = band(self._data[i_word] or 0x0, mask)

			-- Write the data
			self._data[i_word] = bor(data, lshift(b and 1 or 0, 32 - ebitPos))

			return self
		end

		--- Reads a boolean.
		--- @return boolean
		function meta:ReadBoolean()
			local tell = self._tell
			self._tell = tell + 1

			-- Retrive data pos
			local i_word = rshift(tell, 5) + 1 -- [ 1 - length ]
			local bitPos = tell % 32     -- [[ 0 - 31 ]]
			local ebitPos = bitPos + 1   -- The end bit pos

			-- DataMask & Data
			local data = rshift(self._data[i_word] or 0x0, 32 - ebitPos)

			return band(data, rshift(b_mask, 32 - 1)) == 1
		end
	end

	-- 32 bit Int
	do
		meta.WriteInt = writeraw

		--- Reads an int.
		--- @param bits number
		--- @return number
		function meta:ReadInt(bits)
			return to_signed(readraw(self, bits), bits)
		end
	end

	-- UInt
	do
		meta.WriteUInt = writeraw

		local c = math.pow(2, 32)

		--- Reads an unsigned int.
		--- @param bits number
		--- @return number
		function meta:ReadUInt(bits)
			local n = readraw(self, bits)
			if n > -1 then return n end -- 32bit numbers could be negative when reading.
			return n + c
		end
	end

	-- Byte
	do
		--- Writes a byte. ( 0 - 255 )
		--- @param byte number
		--- @return BitBuffer self
		function meta:WriteByte(byte)
			writeraw(self, byte, 8)
			return self
		end

		--- Reads a byte. ( 0 - 255 )
		--- @return number
		function meta:ReadByte()
			return readraw(self, 8)
		end
	end

	-- Signed Byte
	do
		--- Writes a signed byte. ( -128 - 127 )
		--- @param byte number
		--- @return BitBuffer self
		function meta:WriteSignedByte(byte)
			self:WriteInt(byte, 8)
			return self
		end

		--- Writes a signed byte. ( -128 - 127 )
		--- @return number
		function meta:ReadSignedByte()
			return self:ReadInt(8)
		end
	end

	-- Ushort
	do
		--- Writes an unsigned 2 byte number. ( 0 - 65535 )
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteUShort(num)
			self:WriteUInt(num, 16)
			return self
		end

		--- Reads an unsigned 2 byte number. ( 0 - 65535 )
		--- @return number
		function meta:ReadUShort()
			return self:ReadUInt(16)
		end
	end

	-- Short
	do
		--- Writes a 2 byte number. ( -32768 - 32767 )
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteShort(num)
			self:WriteInt(num, 16)
			return self
		end

		--- Reads an 2 byte number. ( -32768 - 32767 )
		--- @return number
		function meta:ReadShort()
			return self:ReadInt(16)
		end
	end

	-- ULong
	do
		--- Writes an unsigned 4 byte number. ( 0 - 4294967295 )
		--- @param num number
		--- @return self BitBuffer
		function meta:WriteULong(num)
			self:WriteUInt(num, 32)
			return self
		end

		--- Reads an unsigned 4 byte number ( 0 - 4294967295 )
		--- @return number
		function meta:ReadULong()
			return self:ReadUInt(32)
		end
	end

	-- Long
	do
		--- Writes a 4 byte number. ( -2147483648 - 2147483647 )
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteLong(num)
			self:WriteInt(num, 32)
			return self
		end

		--- Reads a 4 byte number. ( -2147483648 - 2147483647 )
		--- @return number
		function meta:ReadLong()
			return self:ReadInt(32)
		end
	end

	-- Nibble
	do
		--- Writes a 4 bit unsigned number. ( 0 - 15 )
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteNibble(num)
			self:WriteUInt(num, 4)
			return self
		end

		--- Reads a 4 bit unsigned number. ( 0 - 15 )
		--- @return number
		function meta:ReadNibble()
			return self:ReadUInt(4)
		end
	end

	-- Snort ( 2bit number )
	do
		--- Writes a 2 bit unsigned number. ( 0 - 3 )
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteSnort(num)
			self:WriteUInt(num, 2)
			return self
		end

		--- Reads a 2 bit unsigned number. ( 0 - 3 )
		--- @return number
		function meta:ReadSnort()
			return self:ReadUInt(2)
		end
	end

	--- @param n number
	--- @return boolean
	local function isNegative(n) return 1 / n == -math.huge end

	-- Float
	do
		--- Writes an IEEE 754 little-endian float.
		--- @param num number
		--- @return self BitBuffer
		function meta:WriteFloat(num)
			local sign = 0
			local man = 0
			local ex = 0

			-- Mark negative numbers.
			if num < 0 then
				sign = 0x80000000
				num = -num
			end

			if num ~= num then -- Nan
				ex = 0xFF
				man = 1
			elseif num == math.huge then -- Infintiy
				ex = 0xFF
				man = 0
			elseif num ~= 0 then -- Anything but 0's
				man, ex = frexp(num)
				ex = ex + 0x7F

				if ex <= 0 then
					man = ldexp(man, ex - 1)
					ex = 0
				elseif ex >= 0xFF then -- Reached infinity
					ex = 0xFF
					man = 0
				elseif ex == 1 then
					ex = 0
				else
					man = man * 2 - 1
					ex = ex - 1
				end

				man = floor(ldexp(man, 23) + 0.5)
			elseif isNegative(num) then -- Minus 0 support
				sign = 0x80000000
				man = 0
			end

			-- Not tested, but I guess it is faster to write 1 32bit number, than 3x others.
			self:WriteULong(bor(sign, lshift(band(ex, 0xFF), 23), man))

			return self
		end

		local _23pow = 2 ^ 23

		--- Reads an IEEE 754 little-endian float.
		--- @return number
		function meta:ReadFloat()
			local n = self:ReadULong()
			local sign = band(0x80000000, n) == 0 and 1 or -1
			local ex = band(rshift(n, 23), 0xFF)
			local man = band(n, 0x007FFFFF) / _23pow

			if ex == 0 and man == 0 then
				return 0 * sign -- Number 0
			elseif ex == 255 and man == 0 then
				return math.huge * sign -- -+inf
			elseif ex == 255 and man ~= 0 then
				return 0 / 0   -- nan
			else
				return ldexp(1 + man, ex - 127) * sign
			end
		end
	end

	-- Double
	do
		--[[
			|FFFFFFFF|FFFFFFFF|
			|Fa|Fb|Fc|Fd| |Fe|Ff|Fg|Fh|
			|Fh|Fg|Ff|Fe| |Fd|Fc|Fb|Fa| -> Data input

			|Fh|Fg|Ff|Fe| |Fd|Fc|Fb|Fa|
			|Fe|Ff|Fg|Fh| |Fa|Fb|Fc|Fd|
			|Fa|Fb|Fc|Fd| |Fe|Ff|Fg|Fh|
		]]
		local _52pow = 2 ^ 52
		local _32pow = 2 ^ 32
		local _log = math.log(2)

		--- Writes an IEEE 754 little-endian double. This seems to fail at numbers beyond 1.7976931348623157e+307
		--- @param num number
		--- @return BitBuffer self
		function meta:WriteDouble(num)
			-- Handle special cases first
			local sign = 0
			if num < 0 or (num == 0 and isNegative(num)) then
				num = -num
				sign = 0x80000000
			end

			local ex, man
			if num == 0 then -- Zero
				ex = 0
				man = 0
			elseif num == math.huge then -- Infinity
				ex = 2047
				man = 0
			elseif num ~= num then -- NaN
				ex = 2047
				man = 1
			else
				-- Normal numbers
				local m, e = math.frexp(num)
				ex = e + 1022 -- frexp returns exponent as if mantissa is in [0.5, 1); bias it by 1023 - 1
				man = (m * 2 - 1) * _52pow -- Adjust mantissa to IEEE 754 format

				-- Handle cases where exponent overflows to ensure no inadvertent infinity
				if ex > 2046 then
					ex = 2046
					man = _52pow - 1 -- Max mantissa value before tipping into infinity
				end
			end

			if self._little_endian then
				self:WriteULong(band(man, 0xFFFFFFFF))
				self:WriteULong(bor(sign, lshift(ex, 20), band(man / _32pow, 0x000FFFFF)))
			else
				self:WriteULong(bor(sign, lshift(ex, 20), band(man / _32pow, 0x000FFFFF)))
				self:WriteULong(band(man, 0xFFFFFFFF))
			end

			return self
		end

		--- Reads an IEEE 754 little- or big-endian double.
		--- @return number
		function meta:ReadDouble()
			local a, b
			if self._little_endian then
				b, a = self:ReadULong(), self:ReadULong()
			else
				a, b = self:ReadULong(), self:ReadULong()
			end

			local sign = band(0x80000000, a) == 0 and 1 or -1
			local ex = rshift(band(0x7FF00000, a), 20)
			local man = band(a, 0x000FFFFF) * _32pow + b

			if ex == 0 and man == 0 then
				return 0 * sign -- Number 0
			elseif ex == 0x7FF and man == 0 then
				return math.huge * sign -- Infinity
			elseif ex == 0x7FF and man ~= 0 then
				return 0 / 0   -- NaN
			elseif ex == 0 then
				-- Subnormal numbers (denormals)
				return sign * man / _52pow * math.pow(2, -1022)
			else
				-- Normal numbers
				return sign * (man / _52pow + 1) * math.pow(2, ex - 1023)
			end
		end
	end

	-- Data
	do
		--- Writes raw string-data.
		--- @param str string
		--- @return BitBuffer self
		function meta:Write(str)
			local len = #str
			local q = lshift(rshift(len, 2), 2)

			for i = 1, q, 4 do
				local a, b, c, d = s_byte(str, i, i + 3)
				self:WriteUInt(bor(lshift(a, 24), lshift(b, 16), lshift(c, 8), d), 32)
			end

			for i = q + 1, len do
				self:WriteUInt(s_byte(str, i), 8)
			end

			return self
		end

		--- Reads raw string-data. Default bytes are the length of the bitbuffer.
		--- @param bytes number? If not given, will read until the end of the bitbuffer.
		--- @return string
		function meta:Read(bytes)
			bytes = bytes or math.ceil((self:Size() - self:Tell()) / 8)

			local ReadByte = meta.ReadByte
			local c, s = lshift(rshift(bytes, 2), 2), ""

			for _ = 1, c, 4 do
				s = s .. s_char(ReadByte(self), ReadByte(self), ReadByte(self), ReadByte(self))
			end

			for _ = c + 1, bytes do
				s = s .. s_char(ReadByte(self))
			end

			return s
		end
	end

	-- Special Types
	do
		local Write, Read = meta.Write, meta.Read

		--- Writes a string. Max string length: 65535
		--- @param str string
		--- @return BitBuffer self
		function meta:WriteString(str)
			local l = #str
			if l > 65535 then
				str = str:sub(0, 65535)
				l = 65535
			end

			self:WriteUShort(l)
			Write(self, str)

			return self
		end

		--- Reads a string. Max string length: 65535
		--- @return string
		function meta:ReadString()
			return Read(self, self:ReadUShort() or 0)
		end

		local z = '\0'

		--- Writes a string using a nullbyte at the end. Note: Will remove all nullbytes given.
		--- @param str string
		--- @return BitBuffer self
		function meta:WriteStringNull(str)
			Write(self, string.gsub(str, z, '') .. z)
			return self
		end

		--- Reads a string using a nullbyte at the end. Note: ReadStringNull is a bit slower than ReadString.
		--- @param maxLength? number
		--- @return string
		function meta:ReadStringNull(maxLength)
			maxLength = maxLength or ceil(self:Size() - self:Tell()) / 8

			local str = ""
			if maxLength < 1 then return str end

			local c = self:ReadByte()
			while c ~= 0 and maxLength > 0 do
				str = str .. s_char(c)
				c = self:ReadByte()
				maxLength = maxLength - 1
			end

			return str
		end

		--- Writes a Vector.
		--- @param vector Vector
		--- @return BitBuffer self
		function meta:WriteVector(vector)
			self:WriteFloat(vector.x)
			self:WriteFloat(vector.y)
			self:WriteFloat(vector.z)
			return self
		end

		--- Reads a Vector.
		--- @return Vector
		function meta:ReadVector()
			return Vector(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
		end

		--- Writes an Angle.
		--- @param angle Angle
		--- @return BitBuffer self
		function meta:WriteAngle(angle)
			self:WriteFloat(angle.p)
			self:WriteFloat(angle.y)
			self:WriteFloat(angle.r)
			return self
		end

		--- Reads an Angle.
		--- @return Angle
		function meta:ReadAngle()
			return Angle(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
		end

		--- Writes a 32bit Color.
		--- @param color Color
		--- @return self BitBuffer
		function meta:WriteColor(color)
			self:WriteByte(color.r)
			self:WriteByte(color.g)
			self:WriteByte(color.b)
			self:WriteByte(color.a or 255)
			return self
		end

		--- Reads a 32bit color.
		--- @return Color
		function meta:ReadColor()
			return Color(self:ReadByte(), self:ReadByte(), self:ReadByte(), self:ReadByte())
		end
	end

	-- Tables / Types
	do
		local typeIDs = {
			["nil"]     = 0,
			["boolean"] = 1,
			["number"]  = 2,
			-- light userdata
			["string"]  = 4,
			["table"]   = 5,
			-- function
			-- userdata
			-- thread
			["Entity"]  = 9,
			["Vector"]  = 10,
			["Angle"]   = 11,
			-- physobj
			["Color"]   = 255
		}

		--- Writes a type using a byte as TYPE_ID.
		--- @param obj any
		--- @return BitBuffer self
		function meta:WriteType(obj)
			local id = TypeID(obj)

			if id == TYPE_TABLE and obj.r and obj.g and obj.b then
				id = TYPE_COLOR
			end

			self:WriteByte(id)
			if id == TYPE_NIL then return self end

			if id == TYPE_BOOL then
				self:WriteByte(obj and 1 or 0)
			elseif id == TYPE_NUMBER then
				self:WriteDouble(obj)
			elseif id == TYPE_STRING then
				self:WriteString(obj)
			elseif id == TYPE_TABLE then
				self:WriteTable(obj)
			elseif id == TYPE_ENTITY then
				self:WriteULong(obj:EntIndex())
			elseif id == TYPE_VECTOR then
				self:WriteVector(obj)
			elseif id == TYPE_ANGLE then
				self:WriteAngle(obj)
			elseif id == TYPE_COLOR then
				self:WriteColor(obj)
			end

			return self
		end

		--- Reads a type using a byte as TYPE_ID.
		--- @return any
		function meta:ReadType()
			local id = self:ReadByte()

			if id == TYPE_NIL then
				return
			elseif id == TYPE_BOOL then
				return self:ReadByte() == 1
			elseif id == TYPE_NUMBER then
				return self:ReadDouble()
			elseif id == TYPE_STRING then
				return self:ReadString()
			elseif id == TYPE_TABLE then
				return self:ReadTable()
			elseif id == TYPE_ENTITY then
				return Entity(self:ReadULong())
			elseif id == TYPE_VECTOR then
				return self:ReadVector()
			elseif id == TYPE_ANGLE then
				return self:ReadAngle()
			elseif id == TYPE_COLOR then
				return self:ReadColor()
			end
		end

		--- Writes a table
		--- @param tab table
		--- @return self BitBuffer
		function meta:WriteTable(tab)
			for k, v in pairs(tab) do
				self:WriteType(k)
				self:WriteType(v)
			end

			self:WriteByte(0)

			return self
		end

		--- Reads a table. Default maxValues is 150
		--- @param maxValues? number
		--- @return table
		function meta:ReadTable(maxValues)
			maxValues = maxValues or 150

			-- Table
			local tab = {}
			local k = self:ReadType()

			while k ~= nil and maxValues > 0 do
				tab[k] = self:ReadType()
				k = self:ReadType()
				maxValues = maxValues - 1
			end

			return tab
		end
	end

	-- File functions
	do
		--- Same as file.Open, but returns it as a bitbuffer. little_endian is true by default.
		--- @param fileName string
		--- @param gamePath? string
		--- @param lzma? boolean
		--- @param little_endian? boolean
		--- @return BitBuffer?
		function NikNaks.BitBuffer.OpenFile(fileName, gamePath, lzma, little_endian)
			if gamePath == true then gamePath = "GAME" end
			if gamePath == nil then gamePath = "DATA" end
			if gamePath == false then gamePath = "DATA" end

			local f = file.Open(fileName, "rb", gamePath)
			if not f then return nil end

			-- Data
			local str = f:Read(f:Size()) -- Is faster
			if lzma then
				str = util.Decompress(str) or str
			end

			f:Close()

			--- @type BitBuffer
			local b = NikNaks.BitBuffer(str, little_endian)
			b:Seek(0)

			return b
		end

		--- Saves the bitbuffer to a file within the data folder. Returns true if it got saved.
		--- @param fileName string
		--- @param lzma? boolean
		--- @return boolean
		function meta:SaveToFile(fileName, lzma)
			local f = file.Open(fileName, "wb", "DATA")
			if not f then return false end

			local s = self:Size()
			local t = self:Tell()

			if lzma then
				self:Seek(0)
				local data = self:Read()
				data = util.Compress(data) or data
				f:Write(data)
			else
				self:Seek(0)

				local b_pos = math.floor(s / 32)
				for i = 1, b_pos do
					f:WriteULong(bswap(self._data[i]))
				end

				local bytesLeft = (s % 32) / 8
				if bytesLeft > 0 then
					self:Seek(b_pos * 32)

					for i = 1, bytesLeft do
						local b = self:ReadByte()
						f:WriteByte(b)
					end
				end
			end

			self:Seek(t)
			f:Close()

			return true
		end
	end

	-- Net functions

	--- Reads a bitbuffer from the net and returns self.
	--- @param bits number
	--- @return self
	function meta:ReadFromNet(bits)
		for i = 1, bits / 32 do
			self:WriteUInt(net.ReadUInt(32), 32)
		end

		local leftover = bits % 32
		if leftover > 0 then
			self:WriteUInt(net.ReadUInt(leftover), leftover)
		end

		self:Seek(0)
		return self
	end

	--- Creates and reads a bitbuffer from the net and returns it.
	--- @param bits number
	--- @return BitBuffer
	function NikNaks.BitBuffer.FromNet(bits)
		return NikNaks.BitBuffer():ReadFromNet(bits)
	end

	--- Writes the bitbuffer to the net and returns the size.
	--- @return number # The size of the bitbuffer
	function meta:WriteToNet()
		local tell = self:Tell()
		self:Seek(0)

		local l = self:Size()
		for _ = 1, l / 32 do
			net.WriteUInt(self:ReadULong(), 32)
		end

		local leftover = l % 32
		if leftover > 0 then
			net.WriteUInt(self:ReadUInt(leftover), leftover)
		end

		self:Seek(tell)
		return l
	end

	--- Writes the bitbuffer to the net and returns the size.
	--- @param buf BitBuffer
	--- @return number # The size of the bitbuffer
	function NikNaks.BitBuffer.ToNet(buf)
		return buf:WriteToNet()
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_module.lua")
do
	local obj_tostring = "BSP %s [ %s ]"
	local format = string.format

	--- @class BSPObject
	--- @field _isL4D2 boolean # If the map is from L4D2, this will be true.
	local meta = NikNaks.__metatables["BSP"]

	--- @return File?
	local function openFile( self )
		if self._mapfile == nil then return end
		return file.Open( self._mapfile, "rb", "GAME" )
	end

	--- Reads the lump header.
	--- @param self BSPObject
	--- @param f BitBuffer|File
	local function read_lump_h( self, f )
		-- "How do we stop people loading L4D2 maps in other games?"
		-- "I got it, we scrample the header."

		--- @class BSPLumpHeader
		--- @field fileofs number # Offset of the lump in the file
		--- @field filelen number # Length of the lump
		--- @field version number # Version of the lump
		--- @field fourCC number # FourCC of the lump
		local t = {}
		if self._version ~= 21 or self._isL4D2 == false then
			t.fileofs = f:ReadLong()
			t.filelen = f:ReadLong()
			t.version = f:ReadLong()
			t.fourCC  = f:ReadLong()
		elseif self._isL4D2 == true then
			t.version = f:ReadLong()
			t.fileofs = f:ReadLong()
			t.filelen = f:ReadLong()
			t.fourCC = f:ReadLong()
		elseif NikNaks._Source:find( "niknak" ) then -- Try and figure it out
			local fileofs = f:ReadLong() -- Version
			local filelen = f:ReadLong() -- fileofs
			local version = f:ReadLong() -- filelen
			t.fourCC  = f:ReadLong()
			if fileofs <= 8 then
				self._isL4D2 = true
				t.version = fileofs
				t.fileofs = filelen
				t.filelen = version
			else
				self._isL4D2 = false
				t.fileofs = fileofs
				t.filelen = filelen
				t.version = version
			end
		end

		return t
	end

	--- Parse LZMA. These are for gamelumps, entities, PAK files and staticprops .. ect from TF2
	--- @param str string
	--- @return string
	local function LZMADecompress( str )
		if str:sub( 0, 4 ) ~= "LZMA" then return str end

		local actualSize = str:sub( 5, 8 )
		local lzmaSize 	= NikNaks.BitBuffer.StringToInt( str:sub( 9, 12 ) )
		if lzmaSize <= 0 then return "" end -- Invalid length

		local t = str:sub( 13, 17 )
		local data = str:sub( 18, 18 + lzmaSize ) -- Why not just read all of it? What data is after this? Tell me your secrets Valve.
		return util.Decompress( t .. actualSize .. "\0\0\0\0" .. data ) or str
	end

	local thisMap = "maps/" .. game.GetMap() .. ".bsp"
	local thisMapObject

	--- Reads the BSP file and returns it as an object.
	--- @param fileName string? # The file name of the map. If not provided, it will load the current map.
	--- @return BSPObject? # Will be nill, if unable to load the map.
	--- @return BSP_ERROR? # Error code if unable to load the map.
	--- **Note:** The current map will be cached and returned if the same map is loaded twice.
	---
	--- **Error Codes:**
	--- - `NikNaks.BSP_ERROR_FILENOTFOUND` - File not found
	--- - `NikNaks.BSP_ERROR_FILECANTOPEN` - Unable to open file
	--- - `NikNaks.BSP_ERROR_NOT_BSP` - Not a BSP file
	--- - `NikNaks.BSP_ERROR_TOO_NEW` - Map is too new
	function NikNaks.Map( fileName )
		-- Handle filename
		if not fileName then
			if thisMapObject then return thisMapObject end -- This is for optimization, so we don't have to load the same map twice.
			fileName = thisMap
		else
			if not string.match( fileName, ".bsp$" ) then fileName = fileName .. ".bsp" end -- Add file header
			if not string.match( fileName, "^maps/" ) and not file.Exists( fileName, "GAME" ) then -- Map doesn't exists and no folder indecated.
				fileName = "maps/" .. fileName	-- Add "maps" folder
			end
		end

		if not file.Exists( fileName, "GAME" ) then
			-- File not found
			return nil, NikNaks.BSP_ERROR_FILENOTFOUND
		end

		local f = file.Open( fileName, "rb", "GAME" )
		if not f then
			-- Unable to open file
			return nil, NikNaks.BSP_ERROR_FILECANTOPEN
		end

		-- Read the header
		if f:Read( 4 ) ~= "VBSP" then
			f:Close()
			return nil, NikNaks.BSP_ERROR_NOT_BSP
		end

		-- Create BSP object
		--- @class BSPObject
		--- @field __map BSPObject
		local BSP = setmetatable( {}, meta )
		BSP._mapfile = fileName
		BSP._size	 = f:Size()
		BSP._mapname = string.GetFileFromFilename( fileName )
		BSP._mapname = string.match( BSP._mapname, "(.+).bsp$" ) or BSP._mapname
		BSP._version = f:ReadLong()
		BSP._fileobj = f

		if BSP._version > 21 then
			f:Close()
			return nil, NikNaks.BSP_ERROR_TOO_NEW
		end

		-- Read Lump Header
		--- @type BSPLumpHeader[]
		BSP._lumpheader = {}
		for i = 0, 63 do
			BSP._lumpheader[i] = read_lump_h( BSP, f )
		end

		--- @type BitBuffer[]
		BSP._lumpstream = {}

		BSP._gamelumps = {}
		f:Close()

		if thisMap == fileName then
			thisMapObject = BSP
		end

		return BSP
	end

	-- Smaller functions
	do
		--- Returns the mapname of the map.
		--- @return string
		function meta:GetMapName()
			return self._mapname or "Unknown"
		end

		--- Returns the filepath of the map.
		--- @return string
		function meta:GetMapFile()
			return self._mapfile or "No file"
		end

		--- Returns the map-version.
		--- @return number
		function meta:GetVersion()
			return self._version
		end

		--- Returns the size of the map in bytes.
		--- @return number # Size in bytes
		function meta:GetSize()
			return self._size
		end
	end

	-- Lump functions
	do
		if SERVER then
			---Returns true if the server has a lumpfile for the given lump. Lumpfiles are used to override the default lump data. They do not exist on the client.
			---@param lump_id number # The lump ID
			---@return boolean
			---@server
			function meta:HasLumpFile( lump_id )
				if self._lumpfile and self._lumpfile[lump_id] ~= nil then
					return self._lumpfile[lump_id]
				end
				self._lumpfile = self._lumpfile or {}
				self._lumpfile[lump_id] = file.Exists("maps/" .. self._mapname .. "_l_" .. lump_id .. ".lmp", "GAME")
				return self._lumpfile[lump_id]
			end
		end

		--- Returns the data lump as a ByteBuffer. This will also be cached onto the BSP object.
		--- @param lump_id number # The lump ID to read. This is a number between 0 and 63.
		--- @return BitBuffer
		function meta:GetLump( lump_id )
			local lumpStream = self._lumpstream[lump_id]
			if lumpStream then
				lumpStream:Seek( 0 ) -- Reset the read position
				return lumpStream
			end

			local lump_h = self._lumpheader[lump_id]
			assert( lump_h, "Tried to read invalid lumpheader!" )

			-- The raw lump data
			local data = ""

			-- Check for LUMPs
			local lumpPath = "maps/" .. self._mapname .. "_l_" .. lump_id .. ".lmp"
			if file.Exists( lumpPath, "GAME" ) then -- L4D has _s_ and _h_ files too. Depending on the gamemode.
				data = file.Read( lumpPath, "GAME" ) or ""
			elseif lump_h.filelen > 0 then
				local f = openFile( self )
				if (f ~= nil) then
					f:Seek( lump_h.fileofs )
					data = f:Read( lump_h.filelen )
					f:Close()
				end
			end

			-- TF2 have some maps that are LZMA compressed.
			data = LZMADecompress( data )

			-- Create bytebuffer object with the data and return it
			self._lumpstream[lump_id] = NikNaks.BitBuffer( data or "" )

			return self._lumpstream[lump_id]
		end

		--- Deletes the lump from the cache. This frees up memory.
		--- @param lump_id number
		function meta:ClearLump( lump_id )
			self._lumpstream[lump_id] = nil
		end

		--- Returns the lump version.
		--- @return number
		function meta:GetLumpVersion( lump_id )
			return self._lumpheader[ lump_id ].version
		end

		--- Reads the lump as a string. This will not be cached or saved, but it is faster than to parse the data into a bytebuffer and useful to read the raw data.
		--- @param lump_id number # The lump ID to read. This is a number between 0 and 63.
		--- @return string # The raw data of the lump.
		function meta:GetLumpString( lump_id )
			local lump_h = self._lumpheader[lump_id]
			assert( lump_h, "Tried to read invalid lumpheader!" )

			-- The raw lump data
			local data = ""
			local lumpPath = "maps/" .. self._mapname .. "_l_" .. lump_id .. ".lmp"
			if file.Exists( lumpPath, "GAME" ) then
				data = file.Read( lumpPath, "GAME" ) or ""
			elseif lump_h.filelen > 0 then
				local f = openFile( self )
				if(f ~= nil) then
					f:Seek( lump_h.fileofs )
					data = f:Read( lump_h.filelen )
					f:Close()
				end
			end

			-- TF2 have some maps that are LZMA compressed.
			data = LZMADecompress( data )
			return data
		end

		--- Returns a list of gamelumps.
		--- @return BSPGameLumpHeader[]
		function meta:GetGameLumpHeaders()
			if self._gamelump then return self._gamelump end
			self._gamelump = {}

			local lump = self:GetLump( 35 )
			for i = 0, math.min( 63, lump:ReadLong() ) do
				--- @class BSPGameLumpHeader
				--- @field id number # ID of the lump
				--- @field flags number # Flags of the lump
				--- @field version number # Version of the lump
				--- @field fileofs number # Offset of the lump in the file
				--- @field filelen number # Length of the lump
				local t = {
					id = lump:ReadLong(),
					flags = lump:ReadUShort(),
					version = lump:ReadUShort(),
					fileofs = lump:ReadLong(),
					filelen = lump:ReadLong()
				}
				self._gamelump[i] = t
			end

			self:ClearLump( 35 )
			return self._gamelump
		end

		--- Returns the gamelump header matching the ID.
		--- @param GameLumpID number
		--- @return BSPGameLumpHeader?
		function meta:FindGameLump( GameLumpID )
			for _, v in pairs( self:GetGameLumpHeaders() ) do
				if v.id == GameLumpID then
					return v
				end
			end
		end

		--- @class BSPGameLump
		--- @field buffer BitBuffer
		--- @field version number
		--- @field flags number

		--- Returns the game lump as a bytebuffer. This will also be cached on the BSP object.
		--- @param gameLumpID any
		---	@return BSPGameLump?
		function meta:GetGameLump( gameLumpID )
			--- @type BSPGameLump?
			local gameLump = self._gamelumps[gameLumpID]
			if gameLump then
				gameLump.buffer:Seek( 0 )
				return gameLump
			end

			-- Locate the gamelump.
			local t = self:FindGameLump( gameLumpID )

			-- No data found, or lump has no data.
			if not t or t.filelen <= 0 then
				-- Create an empty bitbuffer with -1 version and 0 flag

				gameLump = {
					flags = t and t.flags or 0,
					version = t and t.version or -1,
					buffer = NikNaks.BitBuffer.Create(),
				}

				self._gamelumps[gameLumpID] = gameLump
				return gameLump
			else
				local f = openFile( self )
				if f ~= nil then
					f:Seek( t.fileofs )
					gameLump = {
						flags = t.flags,
						version = t.version,
						buffer = NikNaks.BitBuffer.Create( LZMADecompress( f:Read( t.filelen ) ) ),
					}
					self._gamelumps[gameLumpID] = gameLump
					return gameLump
				end
			end
		end
	end

	-- Word Data
	do
		local default = [[detail\detailsprites.vmt]]

		--- Returns the detail-metail the map uses. This is used for the detail sprites like grass and flowers.
		--- @return string
		function meta:GetDetailMaterial()
			local wEnt = self:GetEntities()[0]
			return wEnt and wEnt.detailmaterial or default
		end

		--- Returns true if the map is a cold world. ( Flag set in the BSP ) This was added in Day of Defeat: Source.
		--- @return boolean
		function meta:IsColdWorld()
			local wEnt = self:GetEntity( 0 )
			return wEnt and wEnt.coldworld == 1 or false
		end

		--- Returns the min-positions where brushes are within the map.
		--- @return Vector
		function meta:WorldMin()
			if self._wmin then return self._wmin end

			local wEnt = self:GetEntity( 0 )
			if not wEnt then
				self._wmin = NikNaks.vector_zero
				return self._wmin
			end

			self._wmin = util.StringToType( wEnt.world_mins or "0 0 0", "Vector" ) or NikNaks.vector_zero
			return self._wmin
		end

		--- Returns the max-position where brushes are within the map.
		--- @return Vector
		function meta:WorldMax()
			if self._wmax then return self._wmax end

			local wEnt = self:GetEntity( 0 )
			if not wEnt then
				self._wmax = NikNaks.vector_zero
				return self._wmax
			end

			self._wmax = util.StringToType( wEnt.world_maxs or "0 0 0", "Vector" ) or NikNaks.vector_zero
			return self._wmax
		end

		--- Returns the map-bounds. These are not the size of the map, but the bounds where brushes are within.
		--- @return Vector
		--- @return Vector
		function meta:GetBrushBounds()
			return self:WorldMin(), self:WorldMax()
		end

		--- Returns the skybox position. Returns [0,0,0] if none are found.
		--- @return Vector
		function meta:GetSkyBoxPos()
			if self._skyCamPos then return self._skyCamPos end

			local t = self:FindByClass( "sky_camera" )
			if #t < 1 then
				self._skyCamPos = NikNaks.vector_zero
			else
				self._skyCamPos = t[1].origin
			end

			return self._skyCamPos
		end

		--- Returns the skybox scale. Returns 1 if none are found.
		--- @return number
		function meta:GetSkyBoxScale()
			if self._skyCamScale then return self._skyCamScale end

			local t = self:FindByClass( "sky_camera" )
			if #t < 1 then
				self._skyCamScale = 1
			else
				self._skyCamScale = t[1].scale
			end

			return self._skyCamScale
		end

		--- Returns true if the map has a 3D skybox.
		--- @return boolean
		function meta:HasSkyBox()
			if self._skyCam ~= nil then return self._skyCam end
			self._skyCam = #self:FindByClass( "sky_camera" ) > 0
			return self._skyCam
		end

		--- Returns a position in the skybox that matches the one in the world.
		--- @param vec Vector
		--- @return Vector
		function meta:WorldToSkyBox( vec )
			return vec / self:GetSkyBoxScale() + self:GetSkyBoxPos()
		end

		--- Returns a position in the world that matches the one in the skybox.
		--- @param vec Vector
		--- @return Vector
		function meta:SkyBoxToWorld( vec )
			return ( vec - self:GetSkyBoxPos() ) * self:GetSkyBoxScale()
		end
	end

	-- Cubemaps
	do
		--- @class BSPCubeMap
		--- @field origin Vector
		--- @field size number
		--- @field texture string
		--- @field id number
		local cubemeta = {}
		cubemeta.__index = cubemeta
		cubemeta.__tostring = function( self ) return
			format( obj_tostring, "Cubemap", "Index: " .. self:GetIndex() )
		end

		--- Returns the position of the cubemap.
		--- @return Vector
		function cubemeta:GetPos() return self.origin end

		--- Returns the size of the cubemap.
		--- @return number # Size of the cubemap
		function cubemeta:GetSize() return self.size end

		--- Returns the index of the cubemap.
		--- @return number # Index of the cubemap
		function cubemeta:GetIndex() return self.id or -1 end

		--- Returns the texture of the cubemap.
		--- @return string
		function cubemeta:GetTexture() return self.texture end

		--- Returns the CubeMaps in the map.
		--- @return BSPCubeMap[]
		function meta:GetCubemaps()
			if self._cubemaps then return self._cubemaps end

			local b = self:GetLump( 42 )
			local len = b:Size()

			--- @type BSPCubeMap[]
			self._cubemaps = {}
			for _ = 1, math.min( 1024, len / 128 ) do
				--- @class BSPCubeMap
				local t = setmetatable( {}, cubemeta )
				t.origin = Vector( b:ReadLong(), b:ReadLong(), b:ReadLong() )
				t.size = b:ReadLong()
				t.texture = ""

				local texturePath = "maps/" .. self:GetMapName() .. "/c" .. t.origin.x .. "_" .. t.origin.y .. "_" .. t.origin.z
				t.texturePath = texturePath
				if self:GetVersion() > 19 then
					t.texturePath = texturePath .. ".hdr"
				end

				if t.size == 0 then
					t.size = 32
				end

				t.id = table.insert( self._cubemaps, t ) - 1
			end

			self:ClearLump( 42 )
			return self._cubemaps
		end

		--- Returns the nearest cubemap to the given position.
		--- @param pos Vector # The position to check from
		--- @return BSPCubeMap?
		function meta:FindNearestCubemap( pos )
			local lr, lc
			for _, v in ipairs( self:GetCubemaps() ) do
				local cd = v:GetPos():DistToSqr( pos )

				if not lc then
					lc = v
					lr = cd
				elseif lr > cd then
					lc = v
					lr = cd
				end
			end

			return lc
		end
	end

	-- Textures and materials
	do
		-- local max_data = 256000

		--- Returns the texture data string table. This is an id list of all textures used by the map.
		--- @return number[]
		function meta:GetTexdataStringTable()
			if self._texstab then return self._texstab end

			self._texstab = {}

			local data = self:GetLump( 44 )
			for i = 0, data:Size() / 32 - 1 do
				self._texstab[i] = data:ReadLong()
			end

			self:ClearLump( 44 )
			return self._texstab
		end

		--- Returns the texture data string data. This is a list of all textures used by the map.
		--- @return table
		function meta:GetTexdataStringData()
			if self._texstr then return self._texstr end

			--- @type table
			self._texstr = {}

			--- @type string[]
			self._texstr.id = {}

			local data = self:GetLump( 43 )
			for i = 0, data:Size() / 8 - 1 do
				local _id = data:Tell() / 8
				local str = data:ReadStringNull()
				self._texstr.id[_id] = str

				if #str == 0 then break end

				self._texstr[i] = string.lower( str )
			end

			self:ClearLump( 43 )
			return self._texstr
		end

		--- Returns a list of textures used by the map.
		--- @return string[]
		function meta:GetTextures()
			local c = {}
			local q = self:GetTexdataStringData()
			for i = 1, #q do
				c[i] = q[i]
			end
			return c
		end

		local function getTexByID( self, id )
			id = self:GetTexdataStringTable()[id]
			return self:GetTexdataStringData().id[id]
		end

		--- Returns a list of material-data used by the map.
		--- @return BSPTextureData[]
		function meta:GetTexData()
			if self._tdata then return self._tdata end

			--- @type BSPTextureData[]
			self._tdata = {}

			-- Load TexdataStringTable
			self:GetTextures()
			local b = self:GetLump( 2 )
			local count = b:Size() / 256 + 1

			for i = 0, count - 1 do
				--- @class BSPTextureData
				--- @field reflectivity Vector
				--- @field nameStringTableID string
				--- @field width number
				--- @field height number
				--- @field view_width number
				--- @field view_height number
				local t = {}
				t.reflectivity = b:ReadVector()
				local n = b:ReadLong()
				t.nameStringTableID = getTexByID( self, n ) or tostring( n )
				t.width = b:ReadLong()
				t.height = b:ReadLong()
				t.view_width = b:ReadLong()
				t.view_height = b:ReadLong()
				self._tdata[i] = t
			end

			self:ClearLump( 2 )
			return self._tdata
		end

		--- Returns a list of material-data used by the map.
		--- @return TextureInfo[]
		function meta:GetTexInfo()
			if self._tinfo then return self._tinfo end

			self._tinfo = {}
			local data = self:GetLump( 6 )

			for i = 0, data:Size() / 576 - 1 do
				--- @class TextureInfo
				--- @field textureVects table<number, number[]>
				--- @field lightmapVecs table<number, number[]>
				--- @field flags number # Surface flags of the texture (SURF_*)
				--- @field texdata number # Index of the texture data
				local t = {}
				t.textureVects	= {}
				t.textureVects[0] = { [0] = data:ReadFloat(), data:ReadFloat(), data:ReadFloat(), data:ReadFloat() }
				t.textureVects[1] = { [0] = data:ReadFloat(), data:ReadFloat(), data:ReadFloat(), data:ReadFloat() }
				t.lightmapVecs	= {}
				t.lightmapVecs[0] = { [0] = data:ReadFloat(), data:ReadFloat(), data:ReadFloat(), data:ReadFloat() }
				t.lightmapVecs[1] = { [0] = data:ReadFloat(), data:ReadFloat(), data:ReadFloat(), data:ReadFloat() }
				t.flags			= data:ReadLong()
				t.texdata 		= data:ReadLong()
				self._tinfo[i] = t
			end

			self:ClearLump( 6 )
			return self._tinfo
		end
	end

	-- Planes, Vertex and Edges
	do
		local dot = Vector().Dot

		--- @class BSPPlane
		--- @field normal Vector # Normal vector
		--- @field dist number # distance form origin
		--- @field type number # plane axis indentifier
		local planeMeta = {}
		planeMeta.__index = planeMeta
		NikNaks.__metatables["BSP Plane"] = planeMeta

		--- Calculates the plane dist
		--- @param vec Vector
		--- @return number
		function planeMeta:DistTo( vec )
			return dot(self.normal, vec ) - self.dist
		end

		--- Returns a list of all planes
		--- @return BSPPlane[]
		function meta:GetPlanes()
			if self._plane then return self._plane end

			self._plane = {}
			local data = self:GetLump( 1 )
			for i = 0, data:Size() / 160 - 1 do
				--- @class BSPPlane
				local t = {}
				t.normal = data:ReadVector() -- Normal vector
				t.dist = data:ReadFloat() -- distance form origin
				t.type = data:ReadLong() -- plane axis indentifier
				setmetatable(t, planeMeta)
				self._plane[i] = t
			end

			self:ClearLump( 1 )
			return self._plane
		end

		local MAX_MAP_VERTEXS = 65536

		--- Returns an array of coordinates of all the vertices (corners) of brushes in the map geometry.
		--- @return Vector[]
		function meta:GetVertex()
			if self._vertex then return self._vertex end

			--- @type Vector[]
			self._vertex = {}
			local data = self:GetLump( 3 )

			for i = 0, math.min( data:Size() / 96, MAX_MAP_VERTEXS ) - 1 do
				self._vertex[i] = data:ReadVector()
			end

			self:ClearLump( 3 )
			return self._vertex
		end

		local MAX_MAP_EDGES = 256000

		--- Returns all edges. An edge is two points forming a line.
		--- Note: First edge seems to be [0 0 0] - [0 0 0]
		--- @return table<number, Vector[]>
		function meta:GetEdges()
			if self._edge then return self._edge end

			-- @type table<number, Vector[]>
			self._edge = {}
			local data = self:GetLump( 12 )

			local v = self:GetVertex()
			for i = 0, math.min( data:Size() / 32, MAX_MAP_EDGES ) -1 do
				self._edge[i] = { v[data:ReadUShort()], v[data:ReadUShort()] }
			end

			self:ClearLump( 12 )
			return self._edge
		end

		local MAX_MAP_SURFEDGES = 512000

		---Returns all surfedges. A surfedge is an index to edges with a direction. If positive First -> Second, if negative Second -> First.
		---@return number[]
		function meta:GetSurfEdges()
			if self._surfedge then return self._surfedge end

			--- @type number[]
			self._surfedge = {}
			local data = self:GetLump( 13 )

			for i = 0, math.min( data:Size() / 32, MAX_MAP_SURFEDGES ) -1 do
				self._surfedge[i] = data:ReadLong()
			end

			self:ClearLump( 13 )
			return self._surfedge
		end

		local abs = math.abs

		--- Returns the two edge-positions using surf index
		--- @param num number
		--- @return Vector, Vector
		function meta:GetSurfEdgesIndex( num )
			local surf = self:GetSurfEdges()[num]
			local edge = self:GetEdges()[abs( surf )]

			if surf >= 0 then
				return edge[1], edge[2]
			else
				return edge[2], edge[1]
			end
		end
	end

	-- Visibility, leafbrush and leaf functions
	do
		--- Returns the visibility data.
		--- @return VisibilityInfo
		function meta:GetVisibility()
			if self._vis then return self._vis end

			local data = self:GetLump( 4 )
			local num_clusters = data:ReadLong()

			-- Check to see if the num_clusters match
			if num_clusters ~= self:GetLeafsNumClusters() then
				error( "Invalid NumClusters!" )
			end

			--- @class VisibilityInfo
			--- @field VisData VisbilityData[] # Visibility data
			--- @field num_clusters number # Number of clusters
			local t = { VisData = {} }
			local visData = t.VisData

			for i = 0, num_clusters - 1 do
				--- @class VisbilityData
				--- @field PVS number
				--- @field PAS number
				local v = {}
				v.PVS = data:ReadULong()
				v.PAS = data:ReadULong()

				visData[i] = v
			end

			data:Seek( 0 )

			local bytebuff = {}
			for i = 0, bit.rshift( data:Size() - data:Tell(), 3 ) - 1 do
				bytebuff[i] = data:ReadByte()
			end

			t._bytebuff = bytebuff
			t.num_clusters = num_clusters
			self._vis = t

			self:ClearLump( 4 )
			return t
		end

		local TEST_EPSILON			= 0.1
		local dot = Vector().Dot

		--- Returns the leaf the point is within. Use 0 If unsure about iNode.
		--- @param iNode number
		--- @param point Vector
		--- @return BSPLeafObject
		function meta:PointInLeaf( iNode, point )
			if iNode < 0 then
				return self:GetLeafs()[-1 -iNode]
			end

			local node = self:GetNodes()[iNode]
			local plane = self:GetPlanes()[node.planenum]
			local dist = dot(point, plane.normal ) - plane.dist

			if dist > TEST_EPSILON then
				return self:PointInLeaf( node.children[1], point )
			elseif dist < -TEST_EPSILON then
				return self:PointInLeaf( node.children[2], point )
			else
				local pTest = self:PointInLeaf( node.children[1], point )
				if pTest.cluster ~= -1 then
					return pTest
				end

				return self:PointInLeaf( node.children[2], point )
			end
		end

		--- Returns the contents of the point.
		--- @param point Vector
		--- @return CONTENTS # Contents of the point
		function meta:PointContents( point )
			local leaf = self:PointInLeaf( 0, point )
			return leaf.contents
		end

		--- Returns the leaf the point is within, but allows caching by feeding the old VisLeaf.
		--- Will also return a boolean indicating if the leaf is new.
		--- @param iNode number
		--- @param point Vector
		--- @param lastVis BSPLeafObject?
		--- @return BSPLeafObject
		--- @return boolean newLeaf
		function meta:PointInLeafCache( iNode, point, lastVis )
			if not lastVis then return self:PointInLeaf( iNode, point ), true end
			if point:WithinAABox( lastVis.mins, lastVis.maxs ) then return lastVis, false end
			return self:PointInLeaf( iNode, point ), true
		end

		--- Returns the vis-cluster from said point.
		--- @param position Vector
		--- @return number
		function meta:ClusterFromPoint( position )
			return self:PointInLeaf( 0, position ).cluster or -1
		end

		--- Computes the leaf-id the detail is within. -1 for none.
		--- @param position Vector
		--- @return number
		function meta:ComputeDetailLeaf( position )
			local node = 0
			local nodes = self:GetNodes()
			local planes = self:GetPlanes()

			while node > 0 do
				--- @type MapNode
				local n = nodes[node]
				--- @type BSPPlane
				local p = planes[n.planenum]

				if dot(position, p.normal ) < p.dist then
					node = n.children[2]
				else
					node = n.children[1]
				end
			end

			return - node - 1
		end

		local MAX_MAP_LEAFFACES = 65536

		--- Returns the leaf_face array. This is used to return a list of faces from a leaf.
		--- FaceID = LeafFace[ Leaf.firstleafface + [0 -> Leaf.numleaffaces - 1] ]
		--- @return number[]
		function meta:GetLeafFaces()
			if self._leaffaces then return self._leaffaces end

			--- @type number[]
			self._leaffaces = {}
			local data = self:GetLump( 16 )

			for i = 1, math.min( data:Size() / 16, MAX_MAP_LEAFFACES ) do
				self._leaffaces[i] = data:ReadUShort()
			end

			self:ClearLump( 16 )
			return self._leaffaces
		end

		local MAX_MAP_LEAFBRUSHES = 65536

		--- Returns an array of leafbrush-data.
		--- @return BSPBrushObject[]
		function meta:GetLeafBrushes()
			if self._leafbrush then return self._leafbrush end

			--- @type BSPBrushObject[]
			self._leafbrush = {}
			local data = self:GetLump( 17 )
			local brushes = self:GetBrushes()

			for i = 1, math.min( data:Size() / 16, MAX_MAP_LEAFBRUSHES ) do
				self._leafbrush[i] = brushes[data:ReadUShort()]
			end

			self:ClearLump( 17 )
			return self._leafbrush
		end

		--- Returns map-leafs in a table with cluster-IDs as key. Note: -1 is no cluster ID.
		--- @return table<number, BSPLeafObject[]>
		function meta:GetLeafClusters()
			if self._clusters then return self._clusters end

			--- @type table<number, BSPLeafObject[]>
			self._clusters = {}
			local leafs = self:GetLeafs()

			for i = 0, #leafs - 1 do
				local leaf = leafs[i]
				local cluster = leaf.cluster
				if self._clusters[cluster] then
					table.insert( self._clusters[cluster], leaf )
				else
					self._clusters[cluster] = { leaf }
				end
			end

			return self._clusters
		end

	end

	-- Faces and Displacments
	do
		--- Returns the DispVerts data.
		--- @return DispVert[]
		function meta:GetDispVerts()
			if self._dispVert then return self._dispVert end

			--- @type DispVert[]
			self._dispVert = {}
			local data = self:GetLump( 33 )

			for i = 0, data:Size() / 160 - 1 do
				--- @class DispVert
				--- @field vec Vector
				--- @field dist number
				--- @field alpha number
				local t = {
					vec = data:ReadVector(),
					dist = data:ReadFloat(),
					alpha = data:ReadFloat()
				}

				self._dispVert[i] = t
			end

			self:ClearLump( 33 )
			return self._dispVert
		end

		--- Holds flags for the triangle in the displacment mesh.
		--- Returns the DispTris data
		--- @return number[]
		function meta:GetDispTris()
			if self._dispTris then return self._dispTris end

			--- @type number[]
			self._dispTris = {}
			local data = self:GetLump( 48 )

			for i = 0, data:Size() / 16 - 1 do
				self._dispTris[i] = data:ReadUShort()
			end

			self:ClearLump( 48 )
			return self._dispTris
		end

		local m_AllowedVerts = 10
		local m_Ddispinfo_t = 176 * 8

		--- Returns the DispInfo data.
		--- @return DispInfo[] # DispInfo
		--- @return table<number, DispInfo> # DispInfo By face
		function meta:GetDispInfo()
			if self._dispinfo then return self._dispinfo, self._dispinfo_byface end

			--- @type DispInfo[]
			self._dispinfo = {}

			--- @type DispInfo[]
			self._dispinfo_byface = {}

			local data = self:GetLump( 26 )
			local dispInfoCount = data:Size() / m_Ddispinfo_t

			local target = 0
			for i = 0, dispInfoCount - 1 do
				target = i * m_Ddispinfo_t

				if data:Tell() ~= target then
					print( "ERROR: Mismatched tell. Expected:", target, "got:", data:Tell(), "diff:", target - data:Tell() )
				end

				local function verify( expectedBytes )
					local here = data:Tell()
					assert( here == target + ( expectedBytes * 8 ), ( here - target ) / 8 )
				end

				--- @class DispInfo
				--- @field startPosition Vector
				--- @field DispVertStart number
				--- @field DispTriStart number
				--- @field power number
				--- @field minTess number
				--- @field smoothingAngle number
				--- @field contents CONTENTS|MASK # Contents of the displacement. ( MASK is a combination of CONTENTS )
				--- @field MapFace number
				--- @field LightmapAlphaStart number
				--- @field LightmapSamplePositionStart number
				local q = {}

				-- 4 bytes * 3 = 12 bytes
				q.startPosition = data:ReadVector()
				verify( 12 )

				-- 4 bytes
				q.DispVertStart = data:ReadLong()
				verify( 16 )

				-- 4 bytes
				q.DispTriStart = data:ReadLong()
				verify( 20 )

				-- 4 bytes
				q.power = data:ReadLong()
				assert( q.power >= 2, q.power )
				assert( q.power <= 4, q.power )
				verify( 24 )

				-- 2 bytes
				q.flags = data:ReadUShort()
				verify( 26 )

				-- 2 bytes
				q.minTess = data:ReadShort()
				verify( 28 )

				-- 4 bytes
				q.smoothingAngle = data:ReadFloat()
				verify( 32 )

				-- 4 bytes
				q.contents = data:ReadLong()
				verify( 36 )

				-- 2 bytes
				q.MapFace = data:ReadUShort()
				verify( 38 )

				-- 4 bytes
				q.LightmapAlphaStart = data:ReadLong()
				verify( 42 )

				-- 4 bytes
				q.LightmapSamplePositionStart = data:ReadLong()
				verify( 46 )

				data:Skip( 88 * 8 )
				-- -- 48 bytes
				-- q.EdgeNeighbors = CDispNeighbor( data )
				-- verify( 94 )

				-- -- 40 bytes
				-- q.CornerNeighbors = CDispCornerNeighbors( data )
				verify( 134 )

				-- 4 bytes * 10 = 40 bytes
				q.allowedVerts = {}
				for v = 0, m_AllowedVerts - 1 do
					q.allowedVerts[v] = data:ReadLong()
				end
				assert( table.Count( q.allowedVerts ) == 10, table.Count( q.allowedVerts ) )
				verify( 174 )

				data:Skip( 8 * 2 )

				local offset = i * m_Ddispinfo_t
				q.offset = offset

				self._dispinfo[i] = q
				self._dispinfo_byface[q.MapFace] = q
			end

			self:ClearLump( 26 )
			return self._dispinfo, self._dispinfo_byface
		end

		local MAX_MAP_FACES = 65536

		--- Returns all original faces. ( Warning, uses a lot of memory )
		--- @return OriginalFace[]
		function meta:GetOriginalFaces()
			if self._originalfaces then return self._originalfaces end

			--- @class OriginalFace[]
			self._originalfaces = {}
			local data = self:GetLump( 27 )

			for i = 1, math.min( data:Size() / 448, MAX_MAP_FACES ) do
				--- @class OriginalFace
				--- @field styles number[]
				--- @field LightmapTextureMinsInLuxels number[]
				--- @field LightmapTextureSizeInLuxels number[]
				local t = {}
				t.plane 	= self:GetPlanes()[data:ReadUShort()]
				t.side 		= data:ReadByte()
				t.onNode 	= data:ReadByte()
				t.firstedge = data:ReadLong()
				t.numedges 	= data:ReadShort()
				t.texinfo 	= data:ReadShort()
				t.dispinfo				= data:ReadShort()
				t.surfaceFogVolumeID	= data:ReadShort()
				t.styles				= { data:ReadByte(), data:ReadByte(), data:ReadByte(), data:ReadByte() }
				t.lightofs				= data:ReadLong()
				t.area					= data:ReadFloat()
				t.LightmapTextureMinsInLuxels	= { data:ReadLong(), data:ReadLong() }
				t.LightmapTextureSizeInLuxels	= { data:ReadLong(), data:ReadLong() }
				t.origFace			= data:ReadLong()
				t.numPrims			= data:ReadUShort()
				t.firstPrimID		= data:ReadUShort()
				t.smoothingGroups	= data:ReadULong()
				t.__map = self
				t.__id = i
				self._originalfaces[i] = t
			end

			self:ClearLump( 27 )
			return self._originalfaces
		end
	end

	-- Model The brush-models embedded within the map. 0 is always the entire map.
	do
		--- @class BModel
		local meta_bmodel = {}
		meta_bmodel.__index = meta_bmodel

		--- Returns a list of BModels ( Brush Models )
		--- @return BModel
		function meta:GetBModels()
			if self._bmodel then return self._bmodel end
			self._bmodel = {}
			local data = self:GetLump( 14 )
			for i = 0, data:Size() / 384 - 1 do
				--- @class BModel
				local t = {}
				t.mins = data:ReadVector()
				t.maxs = data:ReadVector()
				t.origin = data:ReadVector()
				t.headnode = data:ReadLong()
				t.firstface = data:ReadLong()
				t.numfaces = data:ReadLong()
				t.__map = self
				setmetatable( t, meta_bmodel )
				self._bmodel[i] = t
			end

			self:ClearLump( 14 )
			return self._bmodel
		end

		--- Returns a list of Faces making up this bmodel
		--- @return BSPFaceObject[]
		function meta_bmodel:GetFaces()
			local t = {}
			local c = 1
			local faces = self.__map:GetFaces()

			for i = self.firstface, self.firstface + self.numfaces - 1 do
				t[c] = faces[i]
				c = c + 1
			end

			return t
		end

		--- Locates the BModelIndex for the said faceIndex
		--- @param faceId number
		--- @return number
		function meta:FindBModelIDByFaceIndex( faceId )
			local bModels = self:GetBModels()

			for i = 0, #bModels do
				local q = bModels[i]
				if q.numfaces >= 0 and faceId >= q.firstface and faceId < q.firstface + q.numfaces then
					return i
				end
			end

			return 0
		end
	end

	-- Special custom functions
	do
		local lower = string.lower

		--- Returns true if the position is outside the map
		--- @param position Vector
		--- @return boolean
		function meta:IsOutsideMap( position )
			local leaf = self:PointInLeaf( 0, position )
			if not leaf then return true end -- No leaf? Shouldn't be possible.
			return leaf:IsOutsideMap()
		end

		--- Returns a list of all materials used by the map.
		--- @return IMaterial[]
		function meta:GetMaterials()
			if self._materials then	return self._materials end

			--- @type IMaterial[]
			self._materials = {}

			for _, v in pairs( self:GetTextures() ) do
				if v then
					local m = Material( v )
					if m then table.insert( self._materials, m ) end
				end
			end

			return self._materials
		end

		--- Returns true if the texture is used by the map.
		--- @param texture string
		--- @return boolean
		function meta:HasTexture( texture )
			texture = lower( texture )

			for _, v in pairs( self:GetTextures() ) do
				if v and lower( v ) == texture then
					return true
				end
			end

			return false
		end

		--- Returns true if the material is used by the map.
		--- @param material IMaterial
		--- @return boolean
		function meta:HasMaterial( material )
			return self:HasTexture( material:GetName() )
		end

		--- Returns true if the skybox is rendering at this position.
		--- Note: Seems to be broken in EP2 and beyond, where the skybox is rendered at all times regardless of position.
		--- @return boolean
		function meta:IsRenderingSkyboxAtPosition( position )
			local leaf = self:PointInLeaf( 0, position )
			if not leaf then return false end -- No leaf? Shouldn't be possible
			return leaf:HasSkyboxInPVS()
		end

		--- Returns a list of skybox leafs (If the map has a skybox)
		--- @return BSPLeafObject[]
		function meta:GetSkyboxLeafs()
			if self._skyboxleafs then return self._skyboxleafs end

			--- @type BSPLeafObject[]
			self._skyboxleafs = {}

			local t = self:FindByClass( "sky_camera" )
			if #t < 1 then return self._skyboxleafs end -- Unable to locate skybox leafs

			local p = t[1].origin
			if not p then return self._skyboxleafs end
			local leaf = self:PointInLeaf( 0, p )
			if not leaf then return self._skyboxleafs end

			local area = leaf.area

			local i = 1
			for _, l in ipairs( self:GetLeafs() ) do
				if l.area == area then
					self._skyboxleafs[i] = l
					i = i + 1
				end
			end

			return self._skyboxleafs
		end

		--- Returns the size of the skybox
		--- @return Vector? # The minimum size of the skybox
		--- @return Vector? # The maximum size of the skybox
		function meta:GetSkyboxSize()
			if self._skyboxmin and self._skyboxmaxs then return self._skyboxmin, self._skyboxmaxs end

			for _, leaf in ipairs( self:GetSkyboxLeafs() ) do
				if not self._skyboxmin then
					self._skyboxmin = Vector( leaf.mins )
				else
					self._skyboxmin.x = math.min( self._skyboxmin.x, leaf.mins.x )
					self._skyboxmin.y = math.min( self._skyboxmin.y, leaf.mins.y )
					self._skyboxmin.z = math.min( self._skyboxmin.z, leaf.mins.z )
				end
				if not self._skyboxmaxs then
					self._skyboxmaxs = Vector( leaf.maxs )
				else
					self._skyboxmaxs.x = math.max( self._skyboxmaxs.x, leaf.maxs.x )
					self._skyboxmaxs.y = math.max( self._skyboxmaxs.y, leaf.maxs.y )
					self._skyboxmaxs.z = math.max( self._skyboxmaxs.z, leaf.maxs.z )
				end
			end

			return self._skyboxmin, self._skyboxmaxs
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_entities.lua")
do
	--- @class BSPEntity # An object that represents an entity within the BSP.
	--- @field origin Vector
	--- @field angles Angle
	--- @field rendercolor? Color
	--- @field ontrigger? table
	--- @field classname? string
	--- @field model? string
	--- @field targetname? string
	--- @field world_mins? string
	--- @field world_maxs? string
	--- @field scale? number
	--- @field coldworld? number

	--- Locates the next enter-token
	--- @param data string
	--- @param pos number
	--- @return number
	local function findNextToken( data, pos )
		for i = pos, #data do
			if data[i] == "{" then return i end
		end

		return -1
	end

	--- Locates the next exit-token
	local function findNextExitToken( data, pos )
		local keypos = 0
		local ignore = false

		for i = pos, #data do
			if data[i] == "\"" then ignore = not ignore
			elseif ignore then continue end

			if data[i] == "{" then keypos = keypos + 1
			elseif data[i] == "}" then
				keypos = keypos - 1
				if keypos == 0 then return i end
			end
		end
	end

	--- Convert a few things to make it easier to read entities.
	--- @param t BSPEntity
	local function postEntParse( t )

		t.origin = util.StringToType( t.origin or "0 0 0" --[[@as string]], "Vector" )
		t.angles = util.StringToType( t.angles or "0 0 0" --[[@as string]], "Angle" )

		if t.rendercolor then
			local c = util.StringToType( t.rendercolor or "255 255 255" --[[@as string]], "Vector" )
			t.rendercolor = Color( c.x, c.y, c.z, 255 )
		end

		-- Make sure ontrigger is a table.
		if t.ontrigger and type( t.ontrigger ) ~= "table" then
			t.ontrigger = { t.ontrigger }
		end
	end

	-- A list of data-keys that can have multiple entries.
	local _tableTypes = {
		["OnMapSpawn"] = 	true,
		["OnTrigger"] = 	true,
		["OnStartTouch"] = 	true,
		["OnArrivedAtDestinationNode"] = true,
		["OnPowered"] = 	true,
		["OnUnpowered"] = 	true,
		["OnExplode"] = 	true,
		["OnAllTrue"] = 	true,
	}

	--- @return BSPEntity
	local function ParseEntity( str )
		--- @class BSPEntity
		local t = {}

		for key, value in string.gmatch( str, [["(.-)".-"(.-)"]] ) do
			value = tonumber( value ) or value
			if t[key] then
				if type( t[key] ) ~= "table" then
					t[key] = { t[key] }
				else
					table.insert( t[key], value )
				end
			elseif _tableTypes[key] then
				t[key] = { value }
			else
				t[key] = value
			end
		end

		postEntParse( t )

		return t
	end

	--- Parses the entity data from the BSP data.
	--- @param data string
	--- @return BSPEntity[]
	local function parseEntityData( data )
		-- Cut the data into bits
		local charPos = 1
		local tabData = {}
		for _ = 1, #data do -- while true do
			local nextToken = findNextToken( data, charPos )
			if nextToken < 0 then
				break -- No token found. EOF.
			else
				local exitToken = findNextExitToken( data, nextToken )
				if exitToken then
					tabData[#tabData + 1] = data:sub( nextToken, exitToken )
					charPos = exitToken
				else -- ERROR No exit token? Try and parse the rest.
					tabData[#tabData + 1] = data:sub( nextToken ) .. "}"
					NikNaks.Msg( [[[BSP] ParseEntity: No closing brace found!]] )
					break
				end
			end
		end

		local tab = {}
		for id, str in pairs( tabData ) do
			local t = ParseEntity( str )
			tab[id - 1] = t
		end

		return tab
	end

	--- @class BSPObject
	local meta = NikNaks.__metatables["BSP"]

	--- Returns a list of all raw-entity data within the BSP.
	--- @return BSPEntity[]
	function meta:GetEntities()
		if self._entities then return self._entities end

		-- Since it is stringbased, it is best to keep it as a string.
		local data = self:GetLumpString( 0 )

		-- Parse all entities
		self._entities = parseEntityData( data )

		return self._entities
	end

	--- Returns the raw entity data for the specified index.
	--- @param index number
	--- @return BSPEntity?
	function meta:GetEntity( index )
		return self:GetEntities()[index]
	end

	--- Returns a list of BSPEntities, matching the class.
	--- @param class string
	--- @return BSPEntity[]
	function meta:FindByClass( class )
		local t = {}

		for _, v in pairs( self:GetEntities() ) do
			local vClass = v.classname
			if vClass == nil then continue end
			if class and string.match( vClass, class ) then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of BSPEntities, matching the model.
	--- @param model string
	--- @return BSPEntity[]
	function meta:FindByModel( model )
		local t = {}

		for _, v in pairs( self:GetEntities() ) do
			if v.model == model then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of entity data, matching the targetname.
	--- @param name string
	--- @return BSPEntity[]
	function meta:FindByName( name )
		local t = {}

		for _, v in pairs( self:GetEntities() ) do
			if v.targetname == name then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of entity data, within the specified box. Note: This (I think) is slower than ents.FindInBox
	--- @param boxMins Vector
	--- @param boxMaxs Vector
	--- @return BSPEntity[]
	function meta:FindInBox( boxMins, boxMaxs )
		local t = {}
		for _, v in pairs( self:GetEntities() ) do
			local origin = v.origin
			if origin and v.origin:WithinAABox( boxMins, boxMaxs ) then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of entity data, within the specified sphere. Note: This (I think) is slower than ents.FindInSphere
	--- @param origin Vector
	--- @param radius number
	--- @return BSPEntity[]
	function meta:FindInSphere( origin, radius )
		radius = radius ^ 2

		local t = {}

		for _, v in pairs( self:GetEntities() ) do
			local vOrigin = v.origin
			if vOrigin and vOrigin:DistToSqr( origin ) <= radius then
				t[#t + 1] = v
			end
		end

		return t
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_faces.lua")
do
	local obj_tostring = "BSP %s [ %s ]"
	local format = string.format

	local vMeta = FindMetaTable("Vector")
	local cross, dot = vMeta.Cross, vMeta.Dot

	--- @class BSPObject
	local meta = NikNaks.__metatables["BSP"]

	--- @class BSPFaceObject
	--- @field planenum number
	--- @field plane BSPPlane
	--- @field side number
	--- @field onNode number
	--- @field firstedge number
	--- @field numedges number
	--- @field texinfo number
	--- @field dispinfo number
	--- @field surfaceFogVolumeID number
	--- @field styles table
	--- @field lightofs number
	--- @field area number
	--- @field LightmapTextureMinsInLuxels table
	--- @field LightmapTextureSizeInLuxels table
	--- @field origFace number
	--- @field numPrims number
	--- @field firstPrimID number
	--- @field smoothingGroups number
	--- @field __bmodel number
	--- @field __map BSPObject
	--- @field __id number
	--- @field _vertex table
	local meta_face = {}
	meta_face.__index = meta_face
	meta_face.__tostring = function( self ) return format( obj_tostring, "Faces", self.__id ) end
	meta_face.MetaName = "BSP Faces"
	NikNaks.__metatables["BSP Faces"] = meta_face

	local MAX_MAP_FACES = 65536

	--- Returns all faces within the BSP. This is very memory intensive.
	--- @return BSPFaceObject[]
	function meta:GetFaces()
		if self._faces then return self._faces end
		self._faces = {}

		local data = self:GetLump( 7 )
		for i = 0, math.min( data:Size() / 448, MAX_MAP_FACES ) - 1 do
			--- @class BSPFaceObject
			local t = {}
			t.planenum = data:ReadUShort()
			t.plane 	= self:GetPlanes()[ t.planenum ]
			t.side 		= data:ReadByte() -- 1 = same direciton as face
			t.onNode 	= data:ReadByte() -- 1 if on node, 0 if in leaf
			t.firstedge = data:ReadLong()
			t.numedges 	= data:ReadShort()
			t.texinfo 	= data:ReadShort() -- Texture info
			t.dispinfo	= data:ReadShort() -- Displacement info
			t.surfaceFogVolumeID	= data:ReadShort()
			t.styles				= { data:ReadByte(), data:ReadByte(), data:ReadByte(), data:ReadByte() }
			t.lightofs				= data:ReadLong()
			t.area					= data:ReadFloat()
			t.LightmapTextureMinsInLuxels	= { data:ReadLong(), data:ReadLong() }
			t.LightmapTextureSizeInLuxels	= { data:ReadLong(), data:ReadLong() }
			t.origFace			= data:ReadLong()
			t.numPrims			= data:ReadUShort()
			t.firstPrimID		= data:ReadUShort()
			t.smoothingGroups	= data:ReadULong()
			t.__bmodel = self:FindBModelIDByFaceIndex( i )
			t.__map = self
			t.__id = i
			setmetatable( t, meta_face )
			self._faces[i] = t
		end

		self:ClearLump( 7 )
		return self._faces
	end

	-- Returns the original face if found.
	---@return OriginalFace?
	function meta_face:GetOriginalFace()
		return self.__map:GetOriginalFaces()[self.origFace]
	end

	---Returns a list of faces that contain a displacment.
	---@return BSPFaceObject[]
	function meta:GetDisplacmentFaces()
		if self._distab then return self._distab end
		self._distab = {}
		for key, face in pairs(self:GetFaces()) do
			if(face.dispinfo == -1) then continue end
			table.insert(self._distab, face)
		end
		return self._distab
	end

	-- We make a small hack to cache and get the entities using brush-models.
	local function __findEntityUsingBrush( self )
		if self.__funcBrush then return self.__funcBrush end

		local entities = self:GetEntities()
		self.__funcBrush = { [0] = entities[0] }

		for _, v in pairs( entities ) do
			local numMdl = string.match( v.model or "", "*([%d]+)" )

			if numMdl then
				self.__funcBrush[tonumber( numMdl )] = v
			end
		end

		return self.__funcBrush
	end

	--- Parses a Color object from the given BitBuffer
	--- @param data BitBuffer
	--- @return Color
	local function __readColorRGBExp32 ( data )
		return NikNaks.ColorRGBExp32ToColor( {
			r = data:ReadByte(),
			g = data:ReadByte(),
			b = data:ReadByte(),
			exponent = data:ReadSignedByte()
		} )
	end

	--- Returns the lightmap samples for the face.
	--- @return table<string, LightmapSample[]>?
	function meta_face:GetLightmapSamples()
		local lightofs = self.lightofs

		if lightofs == -1 then return end
		if self._lightmap_samples then return self._lightmap_samples end

		--- @class LightmapSample
		--- @field color Color
		--- @field exponent number

		--- @type LightmapSample[]
		local full = {}

		--- @type LightmapSample[]
		local average = {}

		local samples = { average = average, full = full }
		self._lightmap_samples = samples

		local has_bumpmap = self:GetMaterial():GetString( "$bumpmap" ) ~= nil
		local luxel_count = ( self.LightmapTextureSizeInLuxels[1] + 1 ) * ( self.LightmapTextureSizeInLuxels[2] + 1 )

		local lightstyle_count = 0
		for _, v in ipairs( self.styles ) do
			if v ~= 255 then lightstyle_count = lightstyle_count + 1 end
		end

		-- "For faces with bumpmapped textures, there are four times the usual number of lightmap samples"
		local sample_count = lightstyle_count * luxel_count
		if has_bumpmap then sample_count = sample_count * 4 end

		local data = self.__map:GetLump( 8 )

		-- Get the average samples
		-- "Immediately preceeding the lightofs-referenced sample group,
		--  there are single samples containing the average lighting on the face, one for each lightstyle,
		--  in reverse order from that given in the styles[] array."
		local color, exponent
		data:Seek( ( lightofs * 8 ) - ( 32 * lightstyle_count ) )
		for _ = 1, lightstyle_count do
			color, exponent = __readColorRGBExp32( data )
			table.insert( average, 1, { color = color, exponent = exponent } )
		end

		-- Get the full samples
		for _ = 1, sample_count do
			color, exponent = __readColorRGBExp32( data )
			table.insert( full, { color = color, exponent = exponent } )
		end

		return samples
	end

	--- Returns the face-index. Will return -1 if none.
	--- @return number
	function meta_face:GetIndex()
		return self.__id or -1
	end

	--- Returns the normal vector for the face.
	--- @return Vector
	function meta_face:GetNormal()
		return self.plane.normal
	end

	--- Returns the texture info for the face.
	--- @return TextureInfo?
	function meta_face:GetTexInfo()
		return self.__map:GetTexInfo()[self.texinfo]
	end

	--- Returns the texture data for the face.
	--- @return BSPTextureData?
	function meta_face:GetTexData()
		return self.__map:GetTexData()[ self:GetTexInfo().texdata ]
	end

	--- Returns the texture for the face.
	--- @return string
	function meta_face:GetTexture()
		return self:GetTexData().nameStringTableID
	end

	--- Returns the material the face use. Note: Materials within the BSP won't be loaded.
	--- @return IMaterial
	function meta_face:GetMaterial()
		if self._mat then return self._mat end
		self._mat = Material( self:GetTexture() or "__error" )
		return self._mat
	end

	--- Returns true if the face should render.
	--- @return boolean
	function meta_face:ShouldRender()
		local texinfo = self:GetTexInfo()
		local flags = texinfo and texinfo.flags or 0
		return bit.band( flags, 0x80 ) == 0 and bit.band( flags, 0x200 ) == 0
	end

	--- Returns true if the face-texture is translucent
	--- @return boolean
	function meta_face:IsTranslucent()
		local texinfo = self:GetTexInfo() or 0
		return bit.band( texinfo.flags, 0x10 ) ~= 0
	end

	--- Returns true if the face is part of 2D skybox.
	--- @return boolean
	function meta_face:IsSkyBox()
		local texinfo = self:GetTexInfo() or 0
		return bit.band( texinfo.flags, 0x2 ) ~= 0
	end

	--- Returns true if the face is part of 3D skybox.
	--- @return boolean
	function meta_face:IsSkyBox3D()
		local texinfo = self:GetTexInfo() or 0
		return bit.band( texinfo.flags, 0x4 ) ~= 0
	end

	--- Returns true if the face's texinfo has said flag.
	--- @return boolean
	function meta_face:HasTexInfoFlag( flag )
		local texinfo = self:GetTexInfo() or 0
		return bit.band( texinfo.flags, flag  ) ~= 0
	end

	--- Returns true if the face is part of the world and not another entity.
	--- @return boolean
	function meta_face:IsWorld()
		return self.__bmodel == 0
	end

	--- Returns the BModel the face has. 0 if it is part of the world.
	--- @return number
	function meta_face:GetBModel()
		return self.__bmodel
	end

	--- Returns the entity-object-data that is part of this face.
	--- @return string EntityData
	function meta_face:GetEntity()
		return __findEntityUsingBrush( self.__map )[self.__bmodel]
	end

	-- Displacments TODO: Fix Displacment Position and Data

	--- Returns true if the face is part of Displacment
	--- @return boolean
	function meta_face:IsDisplacement()
		return self.dispinfo > -1
	end

	--- Returns the DisplacmentInfo for the face.
	---@return DispInfo
	function meta_face:GetDisplacementInfo()
		local _, t = self.__map:GetDispInfo()
		return t[self.__id]
	end

	--- Returns the vertex positions for the face. [Not Cached]
	--- Note this will ignore BModel-positions and displacment mesh.
	--- @return Vector[]?
	function meta_face:GetVertexs()
		if self._vertex then return self._vertex end
		local t = {}
		for i = 0, self.numedges - 1 do
			t[i + 1] = self.__map:GetSurfEdgesIndex( self.firstedge + i )
		end

		self._vertex = t
		return t
	end

	--- Checks to see if the triangle is intersecting and returns the intersection.
	--- @param orig Vector
	--- @param dir Vector
	--- @param v0 Vector
	--- @param v1 Vector
	--- @param v2 Vector
	--- @return Vector? intersectionPoint
	--- @return number? distance
	local function IsRayIntersectingTriangle(orig, dir, v0, v1, v2)
		local v0v1 = v1 - v0
		local v0v2 = v2 - v0
		local pvec = cross(dir,v0v2)
		local det = dot(v0v1, pvec)
		-- Ray and triangle are parallel if det is close to 0
		if det > -0.0001 and det < 0.0001 then
			return -- No intersection.
		end

		local invDet = 1 / det

		local tvec = orig - v0
		local u = dot(tvec, pvec) * invDet
		if (u < 0 or u > 1) then return end

		local qvec = cross(tvec,v0v1)
		local v = dot(dir, qvec) * invDet
		if (v < 0 or u + v > 1) then return end

		local t = dot(v0v2, qvec) * invDet
		if t > 0 then
			return orig + dir * t, t
		end

		return nil
	end

	--- Calculate the intersection point between a ray and the face.
	--- @param origin Vector
	--- @param dir Vector The normalized direction.
	--- @return Vector? -- The intersection point if found, otherwise nil
	--- @return number? distance
	function meta_face:CalculateRayIntersection( origin, dir )
		if self.plane.normal:Dot( dir ) > 0 then return end
		local poly = self:GetVertexs()
		if not poly then return end
		for i = 1, #poly - 2 do
			local v0 = poly[1]
			local v1 = poly[i + 1]
			local v2 = poly[i + 2]
			local hitPos, dis = IsRayIntersectingTriangle(origin, dir, v0, v1, v2)

			if hitPos then
				return hitPos, dis
			end
		end
		return nil
	end

	--- Calculate the intersection point between a line segment and the face.
	--- @param startPos Vector
	--- @param endPos Vector
	--- @return Vector? -- The in tersection point if found, otherwise nil
	--- @return number? distance
	function meta_face:CalculateSegmentIntersection( startPos, endPos )
		local plane = self.plane
		local dot1 = plane:DistTo(startPos)
		local dot2 = plane:DistTo(endPos)

		if (dot1 > 0) ~= (dot2 > 0) or true then
			local t = dot1 / ( dot1 - dot2 )

			if t <= 0 or t >= 1 then return end
			local poly = self:GetVertexs()
			if not poly then return end
			for i = 1, #poly - 2 do
				local v0 = poly[1]
				local v1 = poly[i + 1]
				local v2 = poly[i + 2]

				-- Check if ray is intersecting triangle point v0, v1 and v2
				local dir = (endPos - startPos):GetNormalized()
				local hitPos, dis = IsRayIntersectingTriangle(startPos, dir, v0, v1, v2)
				if hitPos then
					return hitPos, dis
				end
			end
		end
	end

	--- @class PolygonMeshVertex
	--- @field normal Vector
	--- @field pos Vector
	--- @field u number
	--- @field v number
	--- @field lu number
	--- @field lv number
	--- @field tangent Vector
	--- @field binormal Vector
	--- @field userdata table<number, number>

	--- @return PolygonMeshVertex[]
	local function GetDisplacementVertexs(self, faceVertexData )
		local dispInfo = self:GetDisplacementInfo()
		local start = dispInfo.startPosition

		local baseVerts = faceVertexData
		assert( #baseVerts == 4 )

		---Extracts the u and v params from each point in vData and returns them as Vectors (u->x, v->y, z->0)
		local function extractUVVecs( vData, u, v )
			u = u or "u"
			v = v or "v"
			local uvs = {}

			local point
			for i = 1, #vData do
				point = vData[i]
				table.insert( uvs, Vector( point[u], point[v], 0 ) )
			end

			return unpack( uvs )
		end

		local baseQuad = {}
		local startIdx = 1
		do
			local minDist = math.huge

			local pos, idx, dist
			for i = 1, 4 do
				pos = baseVerts[i].pos
				idx = table.insert( baseQuad, pos ) --[[@as number]]

				dist = pos:Distance( start )
				if dist < minDist then
					minDist = dist
					startIdx = idx
				end
			end
		end

		local function rotated( q )
			local part = {}
			for i = startIdx, #q do
				table.insert( part, q[i] )
			end
			for i = 1, startIdx - 1 do
				table.insert( part, q[i] )
			end

			return part
		end

		local A, B, C, D = unpack( rotated( baseQuad ) )
		local AD = D - A
		local BC = C - B

		local quad = rotated( baseVerts )

		local uvA, uvB, uvC, uvD = extractUVVecs( quad )
		local uvAD = uvD - uvA
		local uvBC = uvC - uvB

		local uv2A, uv2B, uv2C, uv2D = extractUVVecs( quad, "u1", "v1" )
		local uv2AD = uv2D - uv2A
		local uv2BC = uv2C - uv2B

		local power = dispInfo.power
		local power2 = 2 ^ power
		local vertCount = ( ( 2 ^ power ) + 1 ) ^ 2
		local vertStart = dispInfo.DispVertStart
		local vertEnd = vertStart + vertCount

		local vertices = {}
		do
			local LerpVector = LerpVector
			local math_floor = math.floor
			local table_insert = table.insert

			local dispVertices = self.__map:GetDispVerts()
			local vertex, t1, t2, baryVert, dispVert, trueVert, textureUV, lightmapUV
			local normal = baseVerts[1].normal

			local index = 0
			for v = vertStart, vertEnd - 1 do
				vertex = dispVertices[v]
				if not vertex then
					print( "Unexpected end of vertex", "Start: " .. vertStart, "End: " .. vertEnd, "Current: " .. v )
					break
				end

				t1 = index % ( power2 + 1 ) / power2
				t2 = math_floor( index / ( power2 + 1 ) ) / power2

				baryVert = LerpVector( t2, A + ( AD * t1 ), B + ( BC * t1 ) )
				dispVert = vertex.vec * vertex.dist
				trueVert = baryVert + dispVert
				textureUV = LerpVector( t2, uvA + ( uvAD * t1 ), uvB + ( uvBC * t1 ) )
				lightmapUV = LerpVector( t2, uv2A + ( uv2AD * t1 ), uv2B + ( uv2BC * t1 ) )

				table_insert( vertices, {
					pos = trueVert,
					normal = normal,
					u = textureUV.x,
					v = textureUV.y,
					u1 = lightmapUV.x,
					v1 = lightmapUV.y,
					userdata = { 0, 0, 0, 0 }
				} )

				index = index + 1
			end
		end

		--- Vertecies are in a grid, we need to convert them to triangles

		return vertices
	end

	--- Returns a table in form of a polygon-mesh. [Not Cached]
	--- This will also generate displacement mesh if the face is part of a displacement.
	---
	--- **Note:** Displacments are "smoothed" on the GPU, and therefore the mesh between the vertices can curve.
	--- @return PolygonMeshVertex[]
	function meta_face:GenerateVertexData()
		--- @type PolygonMeshVertex[]
		local t = {}
		local tv = self:GetTexInfo().textureVects
		local lv = self:GetTexInfo().lightmapVecs
		local texdata = self:GetTexData()
		local mat_w, mat_h = 0, 0
		if texdata ~= nil then
			mat_w, mat_h = texdata.view_width, texdata.view_height
		end
		local n = self:GetNormal()

		-- Move the faces to match func_brushes (If any)
		local bNum = self.__bmodel
		local exPos, exAng
		if bNum > 0 then
			-- Get funch_brushes and their location
			local func_brush = __findEntityUsingBrush( self.__map )[bNum]
			if func_brush then
				exPos = func_brush.origin
				exAng = func_brush.angles
			end
		end

		local luxelW = self.LightmapTextureSizeInLuxels[1] + 1
		local luxelH = self.LightmapTextureSizeInLuxels[2] + 1

		for i = 0, self.numedges - 1 do
			--- @class PolygonMeshVertex
			local vert = {}
			local a = self.__map:GetSurfEdgesIndex( self.firstedge + i )
			vert.pos = a
			if bNum > 0 then -- WorldPos -> Entity Brush
				a = WorldToLocal( a, Angle(0,0,0), Vector(0,0,0), exAng )
				vert.pos = a + exPos
			end
			vert.normal = n
			-- UV & LV
			vert.u = ( tv[0][0] * a.x + tv[0][1] * a.y + tv[0][2] * a.z + tv[0][3] ) / mat_w
			vert.v = ( tv[1][0] * a.x + tv[1][1] * a.y + tv[1][2] * a.z + tv[1][3] ) / mat_h

			vert.u1 = ( ( lv[0][0] * a.x + lv[0][1] * a.y + lv[0][2] * a.z + lv[0][3] ) - self.LightmapTextureMinsInLuxels[1] ) / luxelW
			vert.v1 = ( ( lv[1][0] * a.x + lv[1][1] * a.y + lv[1][2] * a.z + lv[1][3] ) - self.LightmapTextureMinsInLuxels[2] ) / luxelH

			local biangent = vert.normal:Cross(vector_up)
			vert.tangent = biangent:Cross(vert.normal):GetNormalized()
			vert.binormal = vert.normal:Cross(vert.tangent)

			vert.userdata = { vert.tangent.x, vert.tangent.y, vert.tangent.z, 0 } -- Todo: Calculate this?
			t[i + 1] = vert
		end

		if self:IsDisplacement() then
			return GetDisplacementVertexs( self, t )
		end
		return t
	end

	--- @return PolygonMeshVertex[]?
	local function PolyChop( o_vert )
		local vert = {}
		if #o_vert < 3 then return end

		local n = 1
		local triCount = #o_vert - 2

		for i = 1, triCount do
			vert[n] 	= o_vert[1]
			vert[n + 1] = o_vert[i + 1]
			vert[n + 2] = o_vert[i + 2]
			n = n + 3
		end

		return vert
	end

	---Converts a grid-based mesh to triangle-mesh
	---@param grid PolygonMeshVertex
	---@return PolygonMeshVertex[]
	local function GridPolyChop(grid)
		local width = math.sqrt(#grid)
		local height = #grid / width
		local triangles = {}

		for i = 1, height - 1 do
			for j = 1, width - 1 do
				local index1 = (i - 1) * width + j
				local index2 = i * width + j
				local index3 = i * width + j + 1

				table.insert(triangles, grid[index1])
				table.insert(triangles, grid[index2])
				table.insert(triangles, grid[index3])

				local index4 = (i - 1) * width + j + 1
				table.insert(triangles, grid[index1])
				table.insert(triangles,grid[index3])
				table.insert(triangles,grid[index4])
			end
		end

		return triangles
	end


	---Returns a table in form of a polygon-mesh for triangles. [Not Cached]
	---@return PolygonMeshVertex[]?
	function meta_face:GenerateVertexTriangleData()
		if self._vertTriangleData then return self._vertTriangleData end
		if not self:IsDisplacement() then
			self._vertTriangleData = PolyChop( self:GenerateVertexData() )
		else
			-- Displacments are build in a rows within a grid, we need to convert them to triangles
			self._vertTriangleData = GridPolyChop(self:GenerateVertexData())
		end
		return self._vertTriangleData
	end

	--- All mesh-data regarding said face. Should use face:GenerateVertexTriangleData intead.
	--- @return PolygonMeshData
	function meta_face:GenerateMeshData()
		--- @class PolygonMeshData
		local t = {}
		t.verticies = self:GenerateVertexData()
		t.triangles = PolyChop( t.verticies )
		t.material = self:GetTexture()
		return {t}
	end

	do
		local function calculateTriangleArea(v1, v2, v3)
			local crossProduct = (v2 - v1):Cross(v3 - v1)
			return crossProduct:Length() / 2.0
		end

		--- Returns the surface area of the face.
		--- @return number
		function meta_face:GetArea()
			if self.surfacearea then return self.surfacearea end
			self.surfacearea = 0
			local triangles = self:GenerateVertexTriangleData()
			if not triangles then return 0 end
			-- Concatenate all the vertices from the triangles into the vertices table
			for i = 1, #triangles, 3 do
				local v1, v2, v3 = triangles[i].pos, triangles[i + 1].pos, triangles[i + 2].pos
				self.surfacearea = self.surfacearea + calculateTriangleArea(v1,v2,v3)
			end
			return self.surfacearea
		end
	end

	if CLIENT then
		--- @type IMesh[]
		NIKNAKS_TABOMESH = NIKNAKS_TABOMESH or {}

		--- Builds the mesh if face has none.
		--- @return IMesh|boolean?
		function meta_face:BuildMesh(col)
			if SERVER then return end
			if self._mesh then return self._mesh end
			col = col or color_white
			-- Tex
			local texinfo = self:GetTexInfo()
			if texinfo ~= nil and (bit.band( texinfo.flags, 0x80 ) ~= 0 or bit.band( texinfo.flags, 0x200 ) ~= 0) then
				self._mesh = false
				return self._mesh
			end

			local meshData = self:GenerateVertexTriangleData()
			if not meshData then return self._mesh end

			self._mesh = Mesh( self:GetMaterial() )

			-- Vert
			mesh.Begin( self._mesh, MATERIAL_TRIANGLES, #meshData )
			for i = 1, #meshData do
				local vert = meshData[i]
				-- > Mesh
				mesh.Normal( vert.normal )
				mesh.Position( vert.pos ) -- Set the position
				mesh.Color(col.r, col.g, col.b, col.a)
				mesh.TexCoord( 0, vert.u, vert.v ) -- Set the texture UV coordinates
				mesh.TexCoord( 1, vert.lu, vert.lv ) -- Set the lightmap UV coordinates
				mesh.TexCoord( 2, vert.lu, vert.lv  ) -- Set the lightmap UV coordinates
				--mesh.TexCoord( 2, self.LightmapTextureSizeInLuxels[1], self.LightmapTextureSizeInLuxels[2] ) -- Set the texture UV coordinates
				--mesh.TexCoord( 2, self.LightmapTextureMinsInLuxels[1], self.LightmapTextureMinsInLuxels[2] ) -- Set the texture UV coordinates
				mesh.AdvanceVertex()
			end

			mesh.End()

			table.insert( NIKNAKS_TABOMESH, self._mesh )
			return self._mesh
		end

		--- Returns the mesh generated for the face.
		--- Note. Need to call face:BuildMesh first.
		--- @return IMesh|boolean?
		function meta_face:GetMesh()
			return self._mesh
		end

		--- Deletes the mesh generated for the face.
		--- @return self
		function meta_face:DeleteMesh()
			if not self._mesh then return self end
			self._mesh:Destroy()
			self._mesh = nil
			return self
		end

		--- Generates a mesh for the face and renders it.
		function meta_face:DebugRender( iMaterial)
			render.SetMaterial( iMaterial or  self:GetMaterial() )
			local verts = self:GenerateVertexTriangleData()
			if not verts then return end
			mesh.Begin(nil, MATERIAL_TRIANGLES, #verts / 3 ) -- Begin writing to the dynamic mesh
			for i = 1, #verts do
				mesh.Position( verts[i].pos ) -- Set the position
				mesh.TexCoord( 0, verts[i].u, verts[i].v ) -- Set the texture UV coordinates
				mesh.TexCoord( 1, verts[i].u1, verts[i].v1 ) -- Set the light UV coordinates
				mesh.AdvanceVertex() -- Write the vertex
			end
			mesh.End() -- Finish writing the mesh and draw it

			return true
		end

		for _, _mesh in pairs( NIKNAKS_TABOMESH ) do
			if IsValid( _mesh ) then _mesh:Destroy() end
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_leafs.lua")
do
	local obj_tostring = "BSP %s [ %s ]"
	local format, clamp, min, max = string.format, math.Clamp, math.min, math.max

	--- @class BSPObject
	--- @field _dispFaceLeaf table<number, BSPFaceObject>
	local meta = NikNaks.__metatables["BSP"]

	--- @class BSPLeafObject
	local meta_leaf = {}
	meta_leaf.__index = meta_leaf
	meta_leaf.__tostring = function( self ) return format( obj_tostring, "Leaf", self.__id ) end
	meta_leaf.MetaName = "BSP Leaf"
	NikNaks.__metatables["BSP Leaf"] = meta_leaf

	local MAX_MAP_NODES = 65536
	local TEST_EPSILON = 0.01
	local FLT_EPSILON = 1.192092896e-07
	local canGenerateParents = false

	--- Generates parentNodes for nodes and leafs.
	--- @param self BSPObject
	--- @param nodeNum integer
	--- @param parent integer
	--- @param nodes MapNode[]
	--- @param leafs BSPLeafObject[]
	local function makeParents(self, nodeNum, parent, nodes, leafs, firstRun)
		if firstRun and not canGenerateParents then return end
		canGenerateParents = false

		nodes[nodeNum].parentNode = parent

		for i = 1, 2 do
			local j = nodes[nodeNum].children[i]
			if j < 0 then
				leafs[-j - 1].parentNode = nodeNum;
			else
				makeParents(self, j, nodeNum, nodes, leafs)
			end
		end
	end

	--- Returns a table of map nodes
	--- @return MapNode[]
	function meta:GetNodes()
		if self._node then return self._node end
		self._node = {}
		local data = self:GetLump( 5 )

		for i = 0, math.min( data:Size() / 256, MAX_MAP_NODES ) - 1 do
			--- @class MapNode
			--- @field children number[]
			--- @field planenum number
			--- @field plane BSPPlane
			--- @field mins Vector
			--- @field maxs Vector
			--- @field firstFace number
			--- @field numFaces number
			--- @field area number
			--- @field padding number
			--- @field parentNode number
			local t = {}
				t.planenum = data:ReadLong()
				t.plane = self:GetPlanes()[ t.planenum ]
				t.children = { data:ReadLong(), data:ReadLong() }
				t.mins = Vector( data:ReadShort(), data:ReadShort(), data:ReadShort() )
				t.maxs = Vector( data:ReadShort(), data:ReadShort(), data:ReadShort() )
				t.firstFace = data:ReadUShort()
				t.numFaces = data:ReadUShort()
				t.area = data:ReadShort()
				t.padding = data:ReadShort()
				t.parentNode = -1
			self._node[i] = t
		end

		self:ClearLump( 5 )

		canGenerateParents = true
		makeParents(self, 0, -1, self._node, self:GetLeafs(), true)
		canGenerateParents = false
		return self._node
	end

	--- Returns a table of map leafs.
	--- @return BSPLeafObject[], number num_clusters
	function meta:GetLeafs()
		if self._leafs then return self._leafs, self._leafs_num_clusters end

		--- @type BSPLeafObject[]
		self._leafs = {}

		local lumpversion = self:GetLumpVersion( 10 )
		local data = self:GetLump( 10 )
		local size = 240  -- version

		if lumpversion == 0 then
			size = size + 192 -- byte r, byte g,  byte b +  char expo
		end

		if self._version <= 19 or true then
			size = size + 16
		end

		local n = 0
		for i = 0, data:Size() / size - 1 do
			data:Seek( i * size )

			--- @class BSPLeafObject
			--- @field mins Vector
			--- @field maxs Vector
			local t = {}
				t.contents = data:ReadLong() 	-- 32	32	4
				t.cluster = data:ReadShort() 	-- 16	48	6

				n = math.max( t.cluster + 1, n )

				local d = data:ReadUShort()
				t.area = bit.band( d, 0x1FF )		-- 16	64	8
				t.flags = bit.rshift( d, 9 )		-- 16	80	10

				t.mins = Vector( data:ReadShort(), data:ReadShort(), data:ReadShort() ) -- 16 x 3 ( 48 )	128		16
				t.maxs = Vector( data:ReadShort(), data:ReadShort(), data:ReadShort() ) -- 16 x 3 ( 48 )	176		22
				t.firstleafface 	= data:ReadUShort()	-- 16	192		24
				t.numleaffaces 		= data:ReadUShort()	-- 16	208		26
				t.firstleafbrush 	= data:ReadUShort()	-- 16	224		28
				t.numleafbrushes 	= data:ReadUShort()	-- 16	240		30
				t.leafWaterDataID 	= data:ReadShort()	-- 16	256		32
				t.__id = i
				t.__map = self
				t.parentNode = -1

				if t.leafWaterDataID > -1 then
					t.leafWaterData = self:GetLeafWaterData()[t.leafWaterDataID]
				end

				setmetatable( t, meta_leaf )

			self._leafs[i] = t
		end

		self._leafs_num_clusters = n
		self:ClearLump( 10 )

		canGenerateParents = true
		makeParents(self, 0, -1, self:GetNodes(), self._leafs, true)
		canGenerateParents = false

		return self._leafs, n
	end

	--- Returns a list of LeafWaterData. Holds the data of leaf nodes that are inside water.
	--- @return BSPLeafWaterData[]
	function meta:GetLeafWaterData()
		if self._pLeafWaterData then return self._pLeafWaterData end

		local data = self:GetLump( 36 )
		self._pLeafWaterData = {}

		for i = 0, data:Size() / 80 - 1 do
			--- @class BSPLeafWaterData
			--- @field surfaceZ number The height of the water surface
			--- @field minZ number The minimum height of the water
			--- @field surfaceTexInfoID number The texture info ID
			--- @field material IMaterial? The material of the water
			local t = {}
			t.surfaceZ = data:ReadFloat()
			t.minZ = data:ReadFloat()
			t.surfaceTexInfoID = data:ReadShort()
			local texInfo = self:GetTexInfo()[ t.surfaceTexInfoID ]
			if(texInfo ~= nil)then
				local texString = self:GetTexdataStringData()[ texInfo.texdata ]
				t.material = Material( texString )
			end
			data:Skip( 2 ) -- A short that is always 0x00
			self._pLeafWaterData[i] = t
		end

		self:ClearLump( 36 )
		return self._pLeafWaterData
	end

	--- Returns the number of leaf-clusters
	--- @return number
	function meta:GetLeafsNumClusters()
		local _, num_clusters = self:GetLeafs()
		return num_clusters
	end

	--- Returns the brushes in the given leaf.
	--- @return BSPBrushObject[]
	function meta_leaf:GetBrushes()
		if self._brushes then return self._brushes end

		--- @type BSPBrushObject[]
		self._brushes = {}
		local brush = self.__map:GetBrushes()
		local leafBrushes = self.__map:GetLeafBrushes()
		local c = self.firstleafbrush
		for i = 0, self.numleafbrushes do
			local f_id = leafBrushes[ i + c ]
			self._brushes[i + 1] = f_id
		end

		return self._brushes
	end

	if CLIENT then
		local mat = Material( "vgui/menu_mode_border" )
		local defaultColor = Color( 255, 0, 0, 255 )

		--- A simple debug-render function that renders the leaf
		--- @CLIENT
		--- @param col Color
		function meta_leaf:DebugRender( col )
			render.SetMaterial( mat )
			render.SetBlend( 0.8 )
			render.DrawBox( Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), self.maxs, self.mins, col or defaultColor )
			render.SetBlend( 1 )
		end
	end

	--- Returns the leaf index.
	--- @return number
	function meta_leaf:GetIndex()
		return self.__id or -1
	end

	--- Returns the leaf area.
	--- @return number
	function meta_leaf:GetArea()
		return self.area or -1
	end

	---In most cases, leafs within the skybox share the same value and are have the cluster id of 0.
	-- However older Source versions doesn't have 3D skyboxes and untested on maps without 3D skybox.
	--function meta_leaf:In3DSkyBox()
	--	return self.cluster == 0
	--end

	--- Returns true if the leaf has the 3D sky within its PVS.
	--- Note: Seems to be broken from EP2 and up.
	--- @return boolean
	function meta_leaf:HasSkyboxInPVS()
		return bit.band( self.flags, 0x1 ) ~= 0
	end

	--- Returns true if the leaf has the 3D sky within its PVS.
	--- Note: Seems to be deprecated. Use Leaf:HasSkyboxInPVS() and BSP:HasSkyBox() instead.
	--- @return boolean
	--- @deprecated
	function meta_leaf:Has2DSkyboxInPVS()
		return bit.band( self.flags, 0x4 ) ~= 0
	end

	--- Returns true if the leaf contains said content
	--- @param CONTENTS CONTENTS
	--- @return boolean
	function meta_leaf:HasContents( CONTENTS )
		if CONTENTS == 0 then return self.contents == CONTENTS end
		return bit.band( self.contents, CONTENTS ) ~= 0
	end

	--- Returns the content flag the leaf has.
	--- @return CONTENTS
	function meta_leaf:GetContents()
		return self.contents
	end

	--- Returns a list of faces within this leaf. Starting at 1.
	--- Note: A face can be in multiple leafs.
	--- @param includeDisplacment boolean? # If true, it will include displacment faces. Note: this can be slow.
	--- @return BSPFaceObject[]
	function meta_leaf:GetFaces(includeDisplacment)
		if self._faces then return self._faces end

		--- @type BSPFaceObject[]
		self._faces = {}
		local faces = self.__map:GetFaces()
		local leafFace = self.__map:GetLeafFaces()
		local c = self.firstleafface

		for i = 0, self.numleaffaces do
			local f_id = leafFace[ i + c ]
			self._faces[i + 1] = faces[f_id]
		end

		if(includeDisplacment)then
			--- Displacments aren't included in leafs, we need to manually add them.
			if(not self.__map._dispFaceLeaf) then
				--- @type table<number, BSPFaceObject>
				self.__map._dispFaceLeaf = {}
				for key, value in pairs(self.__map:GetDisplacmentFaces()) do
					local vertexs = value:GetVertexs()
					if vertexs == nil or #vertexs ~= 4 then continue end -- Invalid displacment
					local leafs = self.__map:AABBInLeafs(0, vertexs[1], vertexs[3])
					for key, leaf in pairs(leafs) do
						if(not self.__map._dispFaceLeaf[leaf:GetIndex()]) then
							self.__map._dispFaceLeaf[leaf:GetIndex()] = {}
						end
						table.insert(self.__map._dispFaceLeaf[leaf:GetIndex()], value)
					end
				end
			end

			local dispFaces = self.__map._dispFaceLeaf[self:GetIndex()]
			if(dispFaces)then
				for key, value in pairs(dispFaces) do
					table.insert(self._faces, value)
				end
			end
		end

		return self._faces
	end

	--- Returns true if the leaf has water within.
	--- @return boolean
	function meta_leaf:HasWater()
		return self.leafWaterDataID > 0
	end

	--- Returns the water data, if any.
	--- @return table?
	function meta_leaf:GetWaterData()
		return self.leafWaterData
	end

	--- Returns the water MaxZ within the leaf.
	--- @return number?
	function meta_leaf:GetWaterMaxZ()
		return self.leafWaterData and self.leafWaterData.surfaceZ
	end

	--- Returns the water MinZ within the leaf.
	--- @return number?
	function meta_leaf:GetWaterMinZ()
		return self.leafWaterData and self.leafWaterData.minZ
	end

	--- Returns true if the leaf is outside the map.
	--- @return boolean
	function meta_leaf:IsOutsideMap()
		-- Locations outside the map are always cluster -1. However we check to see if the contnets is solid to be sure.
		return self.cluster == -1 and self.contents == 1
	end

	--- Returns the cluster-number for the leaf. Cluster numbers can be shared between multiple leafs. Note, SkyBox leafs the same cluster number.
	--- @return number cluster # The cluster number of the leaf.
	function meta_leaf:GetCluster()
		return self.cluster
	end

	--- Returns true if the position is within the given leaf. Do note leafs in older maps, sometimes overlap.
	--- @param position Vector
	--- @return boolean
	function meta_leaf:IsPositionWithin( position )
		local l = self.__map:PointInLeaf(0, position)
		if not l then return false end
		return l:GetIndex() == self:GetIndex()
	end

	--- Returns a list of all leafs around the given leaf. Do note this is a rough estimate and may not be 100% accurate. Leafs are not always perfect cubes.
	--- @param borderSize number? @The size of the border around the leaf.
	--- @return BSPLeafObject[]
	function meta_leaf:GetAdjacentLeafs(borderSize)
		local t, i, s = {}, 1, borderSize or 2
		for _, leaf in ipairs( self.__map:AABBInLeafs(0, self.mins, self.maxs, s) ) do
			if leaf == self then continue end
			t[i] = leaf
			i = i + 1
		end
		return t
	end

	--- Returns true if the leafs are adjacent to each other. Do note this is a rough estimate and may not be 100% accurate. Leafs are not always perfect cubes.
	--- @return boolean
	function meta_leaf:IsLeafAdjacent( leaf )
		for _, c_leaf in ipairs( self:GetAdjacentLeafs() ) do
			if c_leaf == leaf then return true end
		end
		return false
	end

	--- Roughly returns the distance from leaf to the given position.
	--- @param position Vector
	--- @return number
	function meta_leaf:Distance( position )
		local cPos = Vector(clamp(position.x, self.mins.x, self.maxs.x),
							clamp(position.y, self.mins.y, self.maxs.y),
							clamp(position.z, self.mins.z, self.maxs.z))
		return cPos:Distance( position )
	end

	--- Roughly returns the distance from leaf to the given position.
	--- @param position Vector
	--- @return number
	function meta_leaf:DistToSqr( position )
		local cPos = Vector(clamp(position.x, self.mins.x, self.maxs.x),
							clamp(position.y, self.mins.y, self.maxs.y),
							clamp(position.z, self.mins.z, self.maxs.z))
		return cPos:DistToSqr( position )
	end

	local planeMeta = NikNaks.__metatables["BSP Plane"]

	--- Returns a list of planes, pointing into the leaf.
	--- @return BSPPlane[]
	function meta_leaf:GetBoundaryPlanes()
		local nodeIndex = self.parentNode
		local list = {}
		if not nodeIndex then return list end

		local child = -( self:GetIndex() + 1 )
		local nodes = self.__map:GetNodes()
		while ( nodeIndex >= 0 ) do
			local node = nodes[nodeIndex]
			local plane = node.plane
			if( node.children[1] == child ) then
				table.insert(list, plane)
			else
				table.insert(list, setmetatable({
					dist = -plane.dist,
					normal = -plane.normal,
					type = plane.type
				}, planeMeta))
			end

			child = nodeIndex
			nodeIndex = nodes[child].parentNode
		end
		return list
	end

	local function locateBoxLeaf( iNode, tab, mins, maxs, nodes, planes, leafs )
		local cornerMin, cornerMax = Vector(0,0,0), Vector(0,0,0)
		while iNode >= 0 do
			local node = nodes[ iNode ]
			local plane = planes[ node.planenum ]
			for i = 1, 3 do
				if( plane.normal[i] >= 0) then
					cornerMin[i] = mins[i]
					cornerMax[i] = maxs[i]
				else
					cornerMin[i] = maxs[i]
					cornerMax[i] = mins[i]
				end
			end
			if plane.normal:Dot(cornerMax) - plane.dist <= -TEST_EPSILON  then
				iNode = node.children[2]
			elseif plane.normal:Dot(cornerMin) - plane.dist >= TEST_EPSILON then
				iNode = node.children[1]
			else
				if not locateBoxLeaf(node.children[1], tab, mins, maxs, nodes, planes, leafs) then
					return false
				end
				return locateBoxLeaf(node.children[2], tab, mins, maxs, nodes, planes, leafs)
			end
		end
		tab[#tab + 1] = leafs[ -1 -iNode ]
		return true
	end

	--- Returns a list of leafs within the given two positions.
	--- @param iNode? number # The node index to start from. Default is 0.
	--- @param point Vector # The first point
	--- @param point2 Vector # The second point
	--- @param add? number # The size of the border around the AABB.
	--- @return BSPLeafObject[]
	function meta:AABBInLeafs( iNode, point, point2, add )
		add = add or 0
		local mins = Vector(min(point.x, point2.x) - add, min(point.y, point2.y) - add, min(point.z, point2.z) - add)
		local maxs = Vector(max(point.x, point2.x) + add, max(point.y, point2.y) + add, max(point.z, point2.z) + add)
		local tab = {}
		locateBoxLeaf(iNode or 0, tab, mins, maxs, self:GetNodes(), self:GetPlanes(), self:GetLeafs())
		return tab
	end

	---Returns true if the AABB has parts of the outside map within.
	--- @param position Vector
	--- @param position2 Vector
	--- @return boolean
	function meta:IsAABBOutsideMap( position, position2 )
		for _, leaf in pairs( self:AABBInLeafs( 0, position, position2 ) ) do
			if leaf:IsOutsideMap() then return true end
		end
		return false
	end

	local function locateSphereLeaf( iNode, tab, origin, radius, nodes, planes, leafs)
		while iNode >= 0 do
			local node = nodes[ iNode ]
			local plane = planes[ node.planenum ]
			if plane.normal:Dot(origin) + radius - plane.dist <= -TEST_EPSILON then
				iNode = node.children[2]
			elseif plane.normal:Dot(origin) - radius - plane.dist >= TEST_EPSILON then
				iNode = node.children[1]
			else
				if not locateSphereLeaf( node.children[1], tab, origin, radius, nodes, planes, leafs ) then
					return false
				end
				return locateSphereLeaf( node.children[2], tab, origin, radius, nodes, planes, leafs )
			end
		end
		tab[#tab + 1] = leafs[ -1 -iNode ]
		return true
	end

	--- Returns a list of leafs within the given sphere.
	--- @param iNode number # The node index to start from. Default is 0.
	--- @param origin Vector # The origin of the sphere
	--- @param radius number # The radius of the sphere
	--- @return BSPLeafObject[]
	function meta:SphereInLeafs(iNode, origin, radius)
		local tab = {}
		locateSphereLeaf(iNode, tab, origin, radius, self:GetNodes(), self:GetPlanes(), self:GetLeafs())
		return tab
	end

	--- Returns true if the sphere has parts of the outside map within.
	--- @param position Vector # The origin of the sphere
	--- @param range number # The radius of the sphere
	--- @return boolean
	function meta:IsSphereOutsideMap( position, range )
		for _, leaf in pairs( self:SphereInLeafs( 0, position, range ) ) do
			if leaf:IsOutsideMap() then return true end
		end
		return false
	end

	--- Adds leafs intersecting between the two points.
	--- @param self BSPObject
	--- @param nodeIndex number
	--- @param startFraction number
	--- @param endFraction number
	--- @param startPos Vector
	--- @param endPos Vector
	--- @param tab table
	local function locateLineLeaf(self, nodeIndex, startFraction, endFraction, startPos, endPos, tab)
		if nodeIndex < 0 then
			local leaf = self:GetLeafs()[ -nodeIndex - 1]
			table.insert(tab, leaf)
		end

		local node = self:GetNodes()[nodeIndex]
		if not node then return end
		local plane = node.plane
		if not plane then return end

		local start_dist, end_dist = 0,0

		if plane.type == 0 then
			start_dist = startPos.x - plane.dist
			end_dist = endPos.x - plane.dist
		elseif plane.type == 1 then
			start_dist = startPos.y - plane.dist
			end_dist = endPos.y - plane.dist
		elseif plane.type == 2 then
			start_dist = startPos.z - plane.dist
			end_dist = endPos.z - plane.dist
		else
			start_dist = startPos:Dot( plane.normal ) - plane.dist
			end_dist = endPos:Dot( plane.normal ) - plane.dist
		end

		if start_dist >= 0 and end_dist >= 0 then
			locateLineLeaf(self, node.children[1], startFraction, endFraction, startPos, endPos, tab)
		elseif start_dist < 0 and end_dist < 0 then
			locateLineLeaf(self, node.children[2], startFraction, endFraction, startPos, endPos, tab)
		else
			local side_id, fraction_first, fraction_second, fraction_middle;
			if start_dist < end_dist then
				side_id = 2

				local inversed_distance  = 1 / ( start_dist - end_dist )
				fraction_first = ( start_dist + FLT_EPSILON ) * inversed_distance
				fraction_second = ( start_dist + FLT_EPSILON ) * inversed_distance
			elseif( end_dist < start_dist ) then
				side_id = 1

				local inversed_distance  = 1 / ( start_dist - end_dist )
				fraction_first = ( start_dist + FLT_EPSILON ) * inversed_distance
				fraction_second = ( start_dist - FLT_EPSILON ) * inversed_distance
			else
				side_id = 1
				fraction_first = 1
				fraction_second = 0
			end

			if fraction_first < 0 then
				fraction_first = 0
			elseif fraction_first > 1 then
				fraction_first = 1
			end

			if fraction_second < 0 then
				fraction_second = 0
			elseif fraction_second > 1 then
				fraction_second = 1
			end

			fraction_middle = startFraction + ( endFraction - startFraction ) * fraction_first
			local middle = startPos + fraction_first * ( endPos - startPos )

			locateLineLeaf( self, node.children[side_id], startFraction, fraction_middle, startPos, middle, tab)

			fraction_middle = startFraction + ( endFraction - startFraction ) * fraction_second
			middle = startPos + fraction_second * ( endPos - startPos )
			side_id = (side_id == 1) and 2 or 1
			locateLineLeaf( self, node.children[side_id], fraction_middle, endFraction, middle, endPos, tab)
		end
	end

	--- Returns a list of leafs between startPos and endPos.
	--- @param iNode number # The node index to start from. Default is 0.
	--- @param startPos Vector # The start position
	--- @param endPos Vector # The end position
	--- @return BSPLeafObject[]
	function meta:LineInLeafs(iNode, startPos, endPos)
		local tab = {}
		locateLineLeaf(self, iNode or 0, 0, 1, startPos, endPos, tab)
		return tab
	end

	--- Returns true if the line has parts of the outside map within.
	--- @param startPos Vector # The start position
	--- @param endPos Vector # The end position
	--- @return boolean
	function meta:IsLineOutsideMap( startPos, endPos)
		for _, leaf in pairs( self:LineInLeafs( 0, startPos, endPos ) ) do
			if leaf:IsOutsideMap() then return true end
		end
		return false
	end

	--- Returns roughtly the leafs maximum boundary
	--- @return Vector
	function meta_leaf:OBBMaxs()
		return self.maxs
	end

	--- Returns roughtly the leafs minimums boundary
	--- @return Vector
	function meta_leaf:OBBMins()
		return self.mins
	end

	--- Returns roughtly the leafs center.
	--- @return Vector
	function meta_leaf:GetPos()
		return (self.mins + self.maxs) / 2
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_brushes.lua")
do
	local obj_tostring = "BSP %s [ %s ]"
	local format = string.format

	--- @class BSPObject
	local meta = NikNaks.__metatables["BSP"]

	--- @class BSPBrushObject
	local meta_brush = {}
	meta_brush.__index = meta_brush
	meta_brush.__tostring = function( self ) return format( obj_tostring, "BSP Brush", self.__id ) end
	meta_brush.MetaName = "BSP Brush"
	NikNaks.__metatables["BSP Brush"] = meta_brush

	local DIST_EPSILON = 0.03125
	local MAX_MAP_BRUSHES = 16384
	local MAX_MAP_BRUSHSIDES = 163840

	--- Returns an array of the brush-data with brush-sides.
	--- @return BSPBrushObject[]
	function meta:GetBrushes()
		if self._brushes then return self._brushes end

		self._brushes = {}

		local data = self:GetLump( 18 )
		for id = 1, math.min( data:Size() / 96, MAX_MAP_BRUSHES ) do
			--- @class BSPBrushObject
			local t = {}
			local first = data:ReadLong()
			local num = data:ReadLong()
			t.contents = data:ReadLong()
			t.numsides = num
			--- @type BrushSideObject[]
			t.sides = {}
			t.__id = id
			t.__map = self

			local n = 1
			for i = first, first + num - 1 do
				t.sides[n] = self:GetBrushSides()[i]
				n = n + 1
			end

			self._brushes[id] = setmetatable( t, meta_brush )
		end

		self:ClearLump( 18 )
		return self._brushes
	end

	--- Returns an array of brushside-data.
	--- @return BrushSideObject[]
	function meta:GetBrushSides()
		if self._brushside then return self._brushside end

		self._brushside = {}

		local data = self:GetLump( 19 )
		local planes = self:GetPlanes()
		for i = 1, math.min( data:Size() / 64, MAX_MAP_BRUSHSIDES ) do
			--- @class BrushSideObject
			local t = {}
				t.plane = planes[ data:ReadUShort() ]
				t.texinfo = data:ReadShort()
				t.dispinfo = data:ReadShort()
				local q = data:ReadShort()
				t.bevel = bit.band( q, 0x1 ) == 1 -- Seems to be 1 if used for collision detection
				t.thin = bit.rshift( q, 8 ) == 1 -- For Portal 2 / Alien Swarm
			self._brushside[i - 1] = t
		end

		self:ClearLump( 19 )
		return self._brushside
	end

	---Returns the index of the brush.
	---@return integer
	function meta_brush:GetIndex()
		return self.__id or -1
	end

	--- Returns the content flag the brush has.
	--- @return CONTENTS
	function meta_brush:GetContents()
		return self.contents
	end

	--- Returns true if the brush has said content
	--- @param CONTENTS CONTENTS
	--- @return boolean
	function meta_brush:HasContents( CONTENTS )
		if CONTENTS == 0 then return self.contents == CONTENTS end
		return bit.band( self.contents, CONTENTS ) ~= 0
	end

	-- Texture Stuff

	--- Returns the TexInfo for the brush-side.
	--- @param side number
	--- @return table
	function meta_brush:GetTexInfo( side )
		return self.__map:GetTexInfo()[self.sides[side].texinfo]
	end

	--- Returns the TexData for the brush-side.
	--- @param side number
	--- @return table
	function meta_brush:GetTexData( side )
		return self.__map:GetTexData()[ self:GetTexInfo( side ).texdata]
	end

	--- Returns the texture for the brush-side.
	--- @param side number
	--- @return string
	function meta_brush:GetTexture( side )
		local t = self:GetTexData( side ) or {}
		return t.nameStringTableID
	end

	--- Returns the Material for the brush-side.
	--- @param side number
	--- @return IMaterial
	function meta_brush:GetMaterial( side )
		if self._material and self._material[side] then return self._material[side] end
		if not self._material then self._material = {} end

		self._material[side] = Material( self:GetTexture( side ) or "__error" )
		return self._material[side]
	end

	--- Returns true if the point is inside the brush
	--- @param position Vector
	--- @return boolean
	function meta_brush:IsPointInside( position )
		for i = 1, self.numsides do
			local side = self.sides[i]
			local plane = side.plane
			if plane.normal:Dot( position ) - plane.dist > DIST_EPSILON then
				return false
			end
		end

		return true
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_pvspas.lua")
do
	local obj_tostring = "BSP %s"
	local format = string.format

	--- @class BSPObject
	local meta = NikNaks.__metatables["BSP"]

	--- @class BSPLeafObject
	local meta_leaf = NikNaks.__metatables["BSP Leaf"]

	--[[The data is stored as an array of bit-vectors; for each cluster, a list of which other clusters are visible
		from it are stored as individual bits (1 if visible, 0 if occluded) in an array, with the nth bit position
		corresponding to the nth cluster. ]]
	--- @param vis VisibilityInfo
	--- @param offset number
	local function getClusters( vis, offset, PVS )
		local c = 0
		local v = offset
		local pvs_buffer = vis._bytebuff
		local num_clusters = vis.num_clusters

		while c <= num_clusters do
			if pvs_buffer[v] == 0 then
				v = v + 1
				c = c + 8 * pvs_buffer[v]
			else
				local b = 1

				while b ~= 0 do
					if bit.band( pvs_buffer[v], b ) ~= 0 then
						PVS[c] = true
					end

					b = bit.band( b * 2, 0xFF )
					c = c + 1
				end
			end

			v = v + 1
		end
	end

	--- PVS ( Potentially Visible Set )
	do
		--- @class PVSObject
		---@field __map BSPObject
		local meta_pvs = {}
		meta_pvs.__index = meta_pvs
		meta_pvs.__tostring = "BSP PVS"
		meta_pvs.MetaName = "BSP PVS"
		NikNaks.__metatables["BSP PVS"] = meta_pvs

		local DVIS_PVS = 1

		--- Creates a new empty PVS-object. Potentially Visible Set
		--- @return PVSObject
		function meta:CreatePVS()
			local t = {}
			t.__map = self
			setmetatable( t, meta_pvs )
			return t
		end

		--- Uses the given ( or creates a new PVS-object ) and adds the position to it.
		--- @param position Vector The position to add to the PVS
		--- @param PVS PVSObject? The PVS to add the position to. If nil, a new PVS will be created.
		--- @return PVSObject
		function meta:PVSForOrigin( position, PVS )
			PVS = PVS or self:CreatePVS()

			PVS.__map = self
			local cluster = self:ClusterFromPoint( position )
			if cluster < 0 then return PVS end -- Empty cluster position.

			local vis = self:GetVisibility()
			local visofs = vis.VisData[cluster].PVS

			getClusters( vis, visofs, PVS )

			return PVS
		end

		--- Returns true if the two positions are in same PVS.
		--- @param position Vector The first position
		--- @param position2 Vector The second position
		--- @return boolean
		function meta:PVSCheck( position, position2 )
			local PVS = self:PVSForOrigin( position )
			local cluster = self:ClusterFromPoint( position2 )
			return PVS[cluster] or false
		end


		--- Adds the position to PVS
		--- @param position Vector The position to add to the PVS
		--- @return self
		function meta_pvs:AddPVS( position )
			self.__map:PVSForOrigin( position, self )
			return self
		end

		--- Removes the position from PVS. Note: This is a bit slow.
		--- @param position Vector The position to remove from the PVS
		--- @return self
		function meta_pvs:RemovePVS( position )
			for id in pairs( self.__map:PVSForOrigin( position ) ) do
				if id ~= "__map" then self[id] = nil end
			end
			return self
		end

		--- Removes the leaf from PVS
		--- @param leaf BSPLeafObject The leaf to remove from the PVS
		--- @return self PVSObject
		function meta_pvs:RemoveLeaf( leaf )
			self[leaf.cluster] = nil
			return self
		end

		--- Returns true if the PVS can see the position
		--- @param position Vector The position to check
		--- @return boolean
		function meta_pvs:TestPosition( position )
			local cluster = self.__map:ClusterFromPoint( position )
			return self[cluster] or false
		end

		--- Creates a PVS from the leaf.
		--- @return PVSObject
		function meta_leaf:CreatePVS()
			local PVS = {}
			PVS.__map = self.__map
			setmetatable( PVS, meta_pvs )
			if self.cluster < 0 then return PVS end -- Leaf invalid. Return empty PVS.

			local vis = self.__map:GetVisibility()
			local visofs = vis.VisData[self.cluster].PVS

			getClusters( vis, visofs, PVS )

			return PVS
		end

		--- Returns a list of leafs within this PVS. Note: This is a bit slow.
		--- @return BSPLeafObject[]
		function meta_pvs:GetLeafs()
			local t = {}
			local n = 1
			local leafs = self.__map:GetLeafs()

			for i = 1, #leafs do
				local leaf = leafs[i]
				local cluster = leaf.cluster

				if cluster >= 0 and self[cluster] then
					t[n] = leaf
					n = n + 1
				end
			end

			return t
		end

		--- Returns true if the PVS has the given leaf
		--- @param leaf BSPLeafObject The leaf to check
		--- @return boolean
		function meta_pvs:HasLeaf( leaf )
			if leaf.cluster < 0 then return false end
			return self[leaf.cluster]
		end
	end

	-- PAS
	do
		---@class PASObject
		---@field __map BSPObject
		local meta_pas = {}
		meta_pas.__index = meta_pas
		meta_pas.__tostring = "BSP PAS"
		meta_pas.MetaName = "BSP PAS"
		NikNaks.__metatables["BSP PAS"] = meta_pas
		local DVIS_PAS = 2

		--- Creates a new empty PAS-object. Positional Audio System
		--- @return PASObject
		function meta:CreatePAS()
			return setmetatable( {}, meta_pas )
		end

		--- Creates a new PAS-object and adds the position to it.
		--- @param position Vector # The position to add to the PAS
		--- @param PAS PASObject? # The PAS to add the position to. If nil, a new PAS will be created.
		--- @return PASObject? # The PAS-object with the position added to it. If the position is invalid, nil is returned.
		function meta:PASForOrigin( position, PAS )
			PAS = PAS or self:CreatePAS()
			PAS.__map = self

			local cluster = self:ClusterFromPoint( position )
			local vis = self:GetVisibility()
			if cluster < 0 then return end -- err

			local visofs = vis.VisData[cluster].PAS

			getClusters( vis, visofs, PAS )

			return PAS
		end

		--- Returns true if the two positions are in same PAS.
		--- @param position Vector # The first position
		--- @param position2 Vector # The second position
		--- @return boolean
		function meta:PASCheck( position, position2 )
			local PAS = self:PASForOrigin( position ) or {}
			return PAS[self:ClusterFromPoint( position2 )] or false
		end

		--- Adds the position to PAS
		--- @param position Vector # The position to add to the PAS
		--- @return self
		function meta_pas:AddPAS( position )
			self.__map:PASForOrigin( position, self )
			return self
		end

		--- Removes the position from PAS ( This is a bit slow )
		--- @param position Vector # The position to remove from the PAS
		--- @return self
		function meta_pas:RemovePAS( position )
			for id in pairs( self.__map:PASForOrigin( position ) or {} ) do
				if id ~= "__map" then self[id] = nil end
			end

			return self
		end

		--- Removes the leaf from PVS
		--- @param leaf BSPLeafObject # The leaf to remove from the PAS
		--- @return self
		function meta_pas:RemoveLeaf( leaf )
			self[leaf.cluster] = nil
			return self
		end

		--- Returns true if the PAS can see the position
		--- @param position Vector # The position to check
		--- @return boolean
		function meta_pas:TestPosition( position )
			local cluster = self.__map:ClusterFromPoint( position )
			return self[cluster] or false
		end

		--- Creates a PAS from the leaf.
		--- @return PASObject
		function meta_leaf:CreatePAS()
			local PAS = setmetatable( {}, meta_pas )
			if self.cluster < 0 then return PAS end -- Leaf invalid. Return empty PVS.

			local vis = self.__map:GetVisibility()
			local visofs = vis[ self.cluster ][ DVIS_PAS ]

			getClusters( vis, visofs, PAS )

			return PAS
		end

		--- Returns true if the PAS has the given leaf
		--- @param leaf BSPLeafObject # The leaf to check
		--- @return boolean
		function meta_pas:HasLeaf( leaf )
			if leaf.cluster < 0 then return false end
			return self[leaf.cluster]
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_staticprops.lua")
do
	local band = bit.band

	--- @class BSPObject
	local meta = NikNaks.__metatables["BSP"]

	--- @class StaticProp
	--- @field Index number
	--- @field version number
	--- @field Origin Vector
	--- @field Angles Angle
	--- @field PropType string
	--- @field First_leaf number
	--- @field LeafCount number
	--- @field Solid number
	--- @field Flags? number
	--- @field Skin number
	--- @field FadeMinDist number
	--- @field FadeMaxDist number
	--- @field LightingOrigin Vector
	--- @field ForcedFadeScale? number
	--- @field MinDXLevel? number
	--- @field MaxDXLevel? number
	--- @field lightmapResolutionX? number
	--- @field lightmapResolutionY? number
	--- @field MinCPULevel? number
	--- @field MaxCPULevel? number
	--- @field MinGPULevel? number
	--- @field MaxGPULevel? number
	--- @field DiffuseModulation? Color
	--- @field DisableX360? boolean
	--- @field FlagsEx? number
	--- @field UniformScale? number
	local meta_staticprop = {}
	meta_staticprop.__index = meta_staticprop
	meta_staticprop.__tostring = function(self) return "Static Prop" .. (self.PropType  and " [" .. self.PropType .. "]" or "") end
	meta_staticprop.MetaName = "StaticProp"
	NikNaks.__metatables["StaticProp"] = meta_staticprop

	local version = {}
		-- Base version from Wiki. Most HL2 maps are version 5.
		version[4] = function( f, obj, m )
			obj.Origin = f:ReadVector()								-- Vector (3 float) 12 bytes
			obj.Angles = f:ReadAngle()								-- Angle (3 float) 	12 bytes
			obj.PropType = m[f:ReadUShort() + 1]					-- unsigned short 			2 bytes
			obj.First_leaf = f:ReadUShort()							-- unsigned short 			2 bytes
			obj.LeafCount = f:ReadUShort()							-- unsigned short 			2 bytes
			obj.Solid = f:ReadByte()								-- unsigned char 			1 byte
			obj.Flags = f:ReadByte()								-- unsigned char 			1 byte
			obj.Skin = f:ReadLong()									-- int 						4 bytes
			obj.FadeMinDist = f:ReadFloat()							-- float 					4 bytes
			obj.FadeMaxDist = f:ReadFloat()							-- float 					4 bytes
			obj.LightingOrigin = f:ReadVector()						-- Vector (3 float) 		12 bytes
			return 448
		end

		-- Fade scale added.
		version[5] = function( f, obj, m)
			version[4]( f, obj, m )
			obj.ForcedFadeScale = f:ReadFloat()					-- float 					4 bytes
			return 480
		end

		-- Minimum and maximum DX-level
		version[6] = function( f, obj, m)
			version[5]( f, obj, m )
			obj.MinDXLevel = f:ReadUShort()					-- unsigned short 			2 bytes
			obj.MaxDXLevel = f:ReadUShort()					-- unsigned short 			2 bytes
			return 512
		end

		-- Color modulation added
		version[7] = function( f, obj, m )
			version[6]( f, obj, m )
			obj.DiffuseModulation = f:ReadColor()
			return 544
		end

		-- Removal of DX-Level. Possible for Linux and console support.
		version[8] = function( f, obj, m )
			version[5]( f,obj, m )
			obj.MinCPULevel = f:ReadByte()					-- unsigned char 			1 byte
			obj.MaxCPULevel = f:ReadByte()					-- unsigned char 			1 byte
			obj.MinGPULevel = f:ReadByte()					-- unsigned char 			1 byte
			obj.MaxGPULevel = f:ReadByte()					-- unsigned char 			1 byte
			obj.DiffuseModulation = f:ReadColor()
			return 544
		end

		-- Added Dissable-flag for X360
		version[9] = function( f, obj, m )
			version[8]( f, obj, m )
			-- The first byte seems to be the indecator.
			-- All maps have the first byte as 0x00, where the L4D2 map; 'c2m4_barns.bsp', tells us it is 0x01 is true.
			obj.DisableX360 = f:ReadByte() == 1 	-- The first byte is the indecator
			-- The last 3 bytes seems to be random data, to fill out the 32bit network-limit
			f:Skip( 24 )
			return 576
		end

		-- This version is for TF2 and some CS:S maps.
		-- Was build on version 6. Guess they where never meant to be released on consoles and only PC ( Since they use DXLevel )
		version[10] = function( f, obj, m )
			version[6]( f, obj, m )
			obj.lightmapResolutionX = f:ReadLong()
			obj.lightmapResolutionY = f:ReadLong()
			return 576
		end

		-- ( Version 7* ) This version is for some CSGO maps. I guess it was for the console support.
		version["10A"] = function( f, obj, m )
			version[9]( f, obj, m )
			obj.FlagsEx = f:ReadULong()
			return 608
		end

		-- The newest CSGO maps. Might have left the console's behind with the newest map versions.
		version[11] = function( f, obj, m )
			local q = version[9]( f, obj, m )
			obj.FlagsEx = f:ReadULong()
			obj.UniformScale = f:ReadFloat()
			return q + 64
		end

	--- @class StaticProp

	--- @param f BitBuffer
	--- @param ver number|string
	--- @return StaticProp, number
	local function CreateStaticProp( f, ver, m )
		local obj = {}
		local startTell = f:Tell()

		version[ver]( f, obj, m )
		obj.version = ver

		local sizeUsed = f:Tell() - startTell
		return setmetatable( obj, meta_staticprop ), sizeUsed
	end

	--- Returns a list of all static-props within the map.
	--- @return StaticProp[]
	function meta:GetStaticProps()
		if self._staticprops then return self._staticprops end

		local gameLump = self:GetGameLump( 1936749168 ) -- 1936749168 == "sprp"
		if not gameLump then
			self._staticprops = {}
			self._staticprops_mdl = {}
			return self._staticprops
		end

		--- @type number|string
		local propVersion = gameLump.version
		local b = gameLump.buffer

		if b:Size() < 1 or not NikNaks._Source:find( "niknak" ) then -- This map doesn't have staticprops, or doesn't support them.
			self._staticprops = {}
			self._staticprops_mdl = {}
			return self._staticprops
		end

		if propVersion > 11 then
			ErrorNoHalt( self._mapfile .. " has an unknown static-prop version!" )
			self._staticprops = {}
			self._staticprops_mdl = {}
			return self._staticprops
		end

		-- Load the model list. This list is used by the static_props.
		--- @type string[]
		self._staticprops_mdl = {}

		local n = b:ReadLong()
		if n > 16384 then -- Check if we overread the max static props.
			ErrorNoHalt( self._mapfile .. " has more than 16384 models!" )
			self._staticprops = {}
			return self._staticprops
		end

		for i = 1, n do
			-- All model-paths are saved as char[128]. Any overflow are nullbytes.
			local model = ""

			for i2 = 1, 128 do
				local c = string.char( b:ReadByte() )
				if string.match( c,"[%w_%-%.%/]" ) then -- Just in case, we check for "valid" chars instead.
					model = model .. c
				end
			end

			self._staticprops_mdl[i] = model
		end

		-- Read the leaf-array. (Unused atm). Prob an index for the static props. However each static-prop already hold said data.
		b:Skip( 16 * b:ReadLong() )

		-- Read static props
		local count = b:ReadLong()
		if count > 16384 then -- Check if we are above the max staticprop.
			ErrorNoHalt( self._mapfile .. " has more than 16384 staticprops!" )
			self._staticprops = {}
			return self._staticprops
		end

		-- We calculate the amount of static props within this space. It is more stable.
		local staticStart = b:Tell()
		local endPos = b:Size()
		local staticSize = ( endPos - staticStart ) / count
		local staticUsed

		--- @type StaticProp[]
		self._staticprops = {}

		-- Check for the 7* version.
		if staticSize == 608 and propVersion == 10 then
			propVersion = "10A"
		end

		for i = 0, count - 1 do
			-- This is to try and get as much valid data we can.
			b:Seek( staticStart + staticSize * i )
			local sObj, sizeused = CreateStaticProp( b, propVersion, self._staticprops_mdl )
			staticUsed = staticUsed or sizeused
			sObj.Index = i
			self._staticprops[i] = sObj
		end

		if staticUsed and staticUsed ~= staticSize then
			ErrorNoHalt( "Was unable to parse " .. self._mapfile .. "'s StaticProps correctly!" )
		end

		return self._staticprops
	end

	--- Returns the static-prop object from said index.
	--- @param index number
	--- @return StaticProp?
	function meta:GetStaticProp( index )
		return self:GetStaticProps()[index]
	end

	--- Returns a list of all static-prop models within the map.
	--- @return string[] # List of string paths to the models.
	function meta:GetStaticPropModels()
		if self._staticprops_mdl then return self._staticprops_mdl end

		self:GetStaticProps() -- If no model list, then load the gamelump.
		return self._staticprops_mdl
	end

	--- Returns a list of all static-props, matching the model.
	--- @param model string # The model path to search for.
	--- @return StaticProp[] # List of static-props matching the model.
	function meta:FindStaticByModel( model )
		local t = {}

		for _, v in pairs( self:GetStaticProps() ) do
			if v.PropType == model then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of all static-props, within the specified box.
	--- @param boxMins Vector # The minimum position of the box.
	--- @param boxMaxs Vector # The maximum position of the box.
	--- @return StaticProp[]
	function meta:FindStaticInBox( boxMins, boxMaxs )
		local t = {}

		for _, v in pairs( self:GetStaticProps() ) do
			local origin = v.Origin
			if origin and v.Origin:WithinAABox( boxMins, boxMaxs ) then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns a list of all static-props, within the specified sphere.
	--- @param origin Vector # The origin of the sphere.
	--- @param radius number # The radius of the sphere.
	--- @return StaticProp[]
	function meta:FindStaticInSphere( origin, radius )
		radius = radius ^ 2
		local t = {}

		for _, v in pairs( self:GetStaticProps() ) do
			local spOrigin = v.Origin
			if spOrigin and spOrigin:DistToSqr( origin ) <= radius then
				t[#t + 1] = v
			end
		end

		return t
	end

	--- Returns the index of the static prop.
	---@return number
	function meta_staticprop:GetIndex()
		return self.Index
	end

	--- Returns the position
	--- @return Vector
	function meta_staticprop:GetPos()
		return self.Origin
	end

	--- Returns the angles
	--- @return Angle
	function meta_staticprop:GetAngles()
		return self.Angles
	end

	--- Returns the model path
	--- @return string
	function meta_staticprop:GetModel()
		return self.PropType
	end

	--- Returns the skin index
	--- @return number
	function meta_staticprop:GetSkin()
		return self.Skin or 0
	end

	--- Returns the color of the static prop. If none is found, it will return white.
	--- @return Color
	function meta_staticprop:GetColor()
		return self.DiffuseModulation or color_white
	end

	--- Returns the scale of the static prop. If none is found, it will return 1.
	--- @return number
	function meta_staticprop:GetScale()
		return self.UniformScale or 1
	end
	meta_staticprop.GetModelScale = meta_staticprop.GetScale

	--- Returns the solid enum.
	--- @return SOLID
	function meta_staticprop:GetSolid()
		return self.Solid
	end

	--- Returns true if the static prop has said solid flag.
	--- @param SOLID SOLID
	--- @return boolean
	function meta_staticprop:HasSolid( SOLID )
		return band( self:GetSolid(), SOLID ) ~= 0
	end

	--- Returns the lighting origin.
	--- @return Vector
	function meta_staticprop:GetLightingOrigin()
		return self.LightingOrigin
	end

	--- Returns the static prop flags.
	--- @return STATIC_PROP_FLAG # The flags of the static prop.
	function meta_staticprop:GetFlags()
		return self.Flags
	end

	--- Returns true if the static prop has said flag.
	--- @param flag STATIC_PROP_FLAG # The flag to check for.
	--- @return boolean
	function meta_staticprop:HasFlag( flag )
		return band( self:GetFlags(), flag ) ~= 0
	end

	--- Returns true if the static prop is disabled on X360.
	--- @return boolean
	function meta_staticprop:GetDisableX360()
		return self.DisableX360 or false
	end

	--- Returns the model bounds of the static prop.
	--- @return Vector # The minimum bounds.
	--- @return Vector # The maximum bounds.
	function meta_staticprop:GetModelBounds()
		local a, b = NikNaks.ModelSize( self:GetModel() )
		local s = self:GetScale()
		return a * s, b * s
	end
	meta_staticprop.GetModelRenderBounds = meta_staticprop.GetModelBounds
	meta_staticprop.GetRenderBounds = meta_staticprop.GetModelBounds

	-- Fade Functions

	--- Returns the fade minimum distance.
	--- @return number
	function meta_staticprop:GetFadeMinDist()
		return self.FadeMinDist
	end

	--- Returns the fade maximum distance.
	--- @return number
	function meta_staticprop:GetFadeMaxDist()
		return self.FadeMaxDist
	end

	--- Returns the forced fade scale. If none is found, it will return 1.
	--- @return number
	function meta_staticprop:GetForceFadeScale()
		return self.ForcedFadeScale or 1
	end

	-- "Other"

	--[[ DXLevel
		0 = Ignore
		70 = DirectX 7
		80 = DirectX 8
		81 = DirectX 8.1
		90 = DirectX 9
		95 = DirectX 9+ ( 9.3 )
		98 = DirectX 9Ex
	]]
	--- Returns the minimum and maximum DXLevel to render the static prop.
	---@return number MinDXLevel # The minimum DXLevel
	---@return number MaxDXLevel # The maximum DXLevel
	function meta_staticprop:GetDXLevel()
		return self.MinDXLevel or 0, self.MaxDXLevel or 0
	end

	if CLIENT then

		--- Returns true if the static prop has a DXLevel required to render.
		--- @return boolean
		function meta_staticprop:HasDXLevel()
			local num = render.GetDXLevel()
			if self.MinDXLevel ~= 0 and num < self.MinDXLevel then return false end
			if self.MaxDXLevel ~= 0 and num > self.MaxDXLevel then return false end
			return true
		end
	end

	--[[
		CPU Level
		0 = Ignore
		1 = "Low"
		2 = "Medium"
		3 = "High"
	]]
	--- Returns the minimum and maximum CPULevel to render the static prop.
	---@return number MinCPULevel # The minimum CPULevel
	---@return number MaxCPULevel # The maximum CPULevel
	function meta_staticprop:GetCPULevel()
		return self.MinCPULevel or 0, self.MaxCPULevel or 0
	end

	--[[
		GPU Level
		0 = Ignore
		1 = "Low"
		2 = "Medium"
		3 = "High"
	]]
	--- Returns the minimum and maximum GPULevel to render the static prop.
	---@return number MinGPULevel # The minimum GPULevel
	---@return number MaxGPULevel # The maximum GPULevel
	function meta_staticprop:GetGPULevel()
		return self.MinGPULevel or 0, self.MaxGPULevel or 0
	end

	-- Allows to set the lightmap resolution for said static-prop.
	-- Checkout https://tf2maps.net/threads/guide-lightmap-optimization.33113/ for more info
	---@return number? ResolutionX # The X resolution of the lightmap
	---@return number? ResolutionY # The Y resolution of the lightmap
	function meta_staticprop:GetLightMapResolution()
		return self.lightmapResolutionX, self.lightmapResolutionY
	end

	--- Returns the "Further" flags of the static prop.
	--- @return STATIC_PROP_FLAG_EX
	function meta_staticprop:GetFlagExs()
		return self.FlagsEx or 0
	end

	--- Returns true if the static prop has said flag.
	--- @param flag STATIC_PROP_FLAG_EX
	--- @return boolean
	function meta_staticprop:HasFlagEx( flag )
		return band( self:GetFlagExs(), flag ) ~= 0
	end

	--- Returns the version of the static prop.
	--- Note: version 7* will be returned as a string: "10A"
	---@return number|string
	function meta_staticprop:GetVersion()
		return self.version
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_bsp_trace.lua")
do
	--- @class BSPObject
	local meta_bsp = NikNaks.__metatables["BSP"]

	--- @class BSPFaceObject
	local meta_face = NikNaks.__metatables["BSP Faces"]

	--- @class BSPLeafObject
	local meta_leaf = NikNaks.__metatables["BSP Leaf"]

	--- @class BSPBrushObject
	local meta_brush = NikNaks.__metatables["BSP Brush"]

	local DIST_EPSILON = 0.03125
	local FLT_EPSILON = 1.192092896e-07

	--- Returns a new trace-reult
	--- @param startPos Vector
	--- @param endPos Vector
	--- @return table
	local function newTrace( startPos, endPos)
		local t = {
			StartPos = startPos,
			EndPos = endPos,
			HitPos = endPos,
			Normal = ( endPos - startPos ):GetNormalized(),
			Fraction = 1,
			FractionLeftSolid = 0
		}
		return t
	end

	local mt = getmetatable(Vector(0,0,0))
	local dot = mt.Dot
	local cross = mt.Cross

	--- Checks to see if the triangle is intersecting and returns the intersection.
	--- @param orig Vector The origin of the ray.
	--- @param dir Vector The normalized direction.
	--- @param v0 Vector The first vertex of the triangle.
	--- @param v1 Vector The second vertex of the triangle.
	--- @param v2 Vector The third vertex of the triangle.
	--- @return Vector? Intersection
	local function IsRayIntersectingTriangle(orig, dir, v0, v1, v2)
		local v0v1 = v1 - v0
		local v0v2 = v2 - v0
		local pvec = cross(dir,v0v2)
		local det = dot(v0v1, pvec)

		-- Ray and triangle are parallel if det is close to 0
		if det > -0.0001 and det < 0.0001 then
			return -- No intersection.
		end

		local invDet = 1 / det

		local tvec = orig - v0
		local u = dot(tvec, pvec) * invDet
		if (u < 0 or u > 1) then return end

		local qvec = cross(tvec,v0v1)
		local v = dot(dir, qvec) * invDet
		if (v < 0 or u + v > 1) then return end

		local distance = dot(v0v2, qvec) * invDet
		if distance > 0 then
			return orig + dir * distance
		end

		return nil
	end

	--- Checks to see if ray is intersecting the given face.
	--- @param origin Vector
	--- @param dir Vector The normalized direction.
	--- @return Vector? -- The intersection point if found, otherwise nil
	function meta_face:LineDirectionIntersection( origin, dir )
		local poly = self:GetVertexs()
		if not poly then return end
		local j = 1
		for i = 1, #poly - 2 do
			local v0 = poly[1]
			local v1 = poly[i + 1]
			local v2 = poly[i + 2]
			local hitPos = IsRayIntersectingTriangle(origin, dir, v0, v1, v2)
			if hitPos then return hitPos end
			j = j + 3
		end
		return nil
	end

	--- Checks to see if the line segment is intersecting the given face.
	--- @param startPos Vector
	--- @param endPos Vector
	--- @return Vector? -- The intersection point if found, otherwise nil
	function meta_face:LineSegmentIntersection( startPos, endPos )
		local plane = self.plane
		local dot1 = plane:DistTo(startPos)
		local dot2 = plane:DistTo(endPos)

		if (dot1 > 0) ~= (dot2 > 0) or true then
			local t = dot1 / ( dot1 - dot2 )

			if t <= 0 or t >= 1 then return end
			local poly = self:GetVertexs()
			if not poly then return end
			for i = 1, #poly - 2 do
				local v0 = poly[1]
				local v1 = poly[i + 1]
				local v2 = poly[i + 2]

				-- Check if ray is intersecting triangle point v0, v1 and v2
				local hit = IsRayIntersectingTriangle(startPos, (endPos - startPos):GetNormalized(), v0, v1, v2)
				if hit then return hit end
			end
		end
	end


	--- Returns the BrushObject that the ray is intersecting, if any.
	--- @param origin Vector
	--- @param dir Vector
	---@return BSPBrushObject?
	function meta_leaf:IsRayIntersecting( origin, dir )
		for _, brush in pairs( self:GetBrushes() ) do
			local hit = brush:IsRayIntersecting( origin, dir )
			if hit then return brush end
		end
	end

	--- Casts a ray on the brush
	--- @param self BSPObject
	--- @param brush BSPBrushObject
	--- @param startPos Vector
	--- @param endPos Vector
	--- @param trace table
	--- @return boolean
	local function rayCastBrush( self, brush, startPos, endPos, trace)
		local sides = self:GetBrushSides()
		if #sides < 1 then return false end

		local f_enter = -99
		local f_leave = 1
		local starts_out = false
		local ends_out = false
		for _, side in pairs( sides ) do
			if side.bevel == 1 then continue end

			local plane = side.plane
			local start_dist = startPos:Dot( plane.normal ) - plane.dist
			local end_dist = endPos:Dot( plane.normal ) - plane.dist
			if start_dist > 0 then
				starts_out = true
				if end_dist > 0 then return end
			else
				if end_dist <= 0 then continue end
				ends_out = true
			end

			if start_dist > end_dist then
				local fraction = math.max( start_dist - DIST_EPSILON, 0 )
				fraction = fraction / ( start_dist - end_dist )
				f_enter = math.max( f_enter, fraction )
			else
				local fraction = ( start_dist + DIST_EPSILON ) / ( start_dist - end_dist )
				f_leave = math.min( f_leave, fraction)
			end
		end

		if starts_out then
			if trace.FractionLeftSolid - f_enter > 0 then
				starts_out = false
			end
		end

		if not starts_out then
			trace.StartSolid = true
			trace.Content = brush.Content

			if not ends_out then
				trace.AllSolid = true
				trace.Fraction = 0
				trace.FractionLeftSolid = 1
			else
				if f_leave ~= 1 and f_leave > trace.FractionLeftSolid then
					trace.FractionLeftSolid = f_leave
					if trace.Fraction <= f_leave then
						trace.Fraction = 1
					end
				end
			end
			return false
		end

		if f_enter < f_leave then
			if f_enter > -99 and f_enter < trace.Fraction then
				if f_enter < 0 then
					f_enter = 0
				end
				trace.Fraction = f_enter
				trace.Brush = brush
				trace.Content = brush.Content
			end
		end
		return false
	end

	-- Raycasts a BSPFaceObject and returns the result in the trace table.
	---@param face BSPFaceObject
	---@param trace table
	---@return boolean
	local function rayCastFace( face, trace )
		local startPos = trace.StartPos
		local endPos = trace.EndPos

		local plane = face.plane
		local dot1 = plane:DistTo(startPos)
		local dot2 = plane:DistTo(endPos)

		if (dot1 > 0) ~= (dot2 > 0) or true then

			if math.abs(dot1 - dot2) < DIST_EPSILON then return false end

			local t = dot1 / ( dot1 - dot2 )

			if t <= 0 or t >= trace.Fraction then return false end
			local intersection = startPos + (endPos - startPos) * t
			local hit = face:LineDirectionIntersection(startPos, trace.Normal)
			if hit then
				trace.Fraction = t
				trace.HitPos = intersection
				trace.HitNormal = plane.normal
				trace.Face = face
				trace.Hit = true
				trace.HitSky = face:IsSkyBox3D() or face:IsSkyBox()
				trace.SurfaceFlags = face:GetTexInfo().flags
				return true
			end
		end
		return false
	end

	do
		local dot = Vector().Dot
		local min, max = math.min, math.max
		local nodes = {}
		local leafs = {}

		local middle = Vector()
		---@param self BSPObject
		---@param nodeIndex number
		---@param startFraction number
		---@param endFraction number
		---@param startPos Vector
		---@param endPos Vector
		---@param trace table
		---@param mask number? The surface flags to check for. (SURF_*)
		local function rayCastNode( self, nodeIndex, startFraction, endFraction, startPos, endPos, trace, mask )
			local traceFraction = trace.Fraction
			if traceFraction <= startFraction then return end

			if nodeIndex < 0 then
				---@type BSPLeafObject
				local leaf = leafs[ -nodeIndex - 1]
				if trace.StartSolid or traceFraction < 1 then return end
				for _, face in ipairs(leaf:GetFaces()) do
					if dot(face.plane.normal,trace.Normal) < 0 then
						-- Check mask
						if mask and bit.band(face:GetTexInfo().flags, mask) == 0 then continue end
						rayCastFace(face, trace)
					end
				end
				return
			end

			--- @type MapNode
			local node = nodes[nodeIndex]
			if not node or not node.plane then return end

			local plane = node.plane
			local start_dist, end_dist = 0,0

			if plane.type == 0 then
				start_dist = startPos.x - plane.dist
				end_dist = endPos.x - plane.dist
			elseif plane.type == 1 then
				start_dist = startPos.y - plane.dist
				end_dist = endPos.y - plane.dist
			elseif plane.type == 2 then
				start_dist = startPos.z - plane.dist
				end_dist = endPos.z - plane.dist
			else
				start_dist = dot(startPos, plane.normal) - plane.dist
				end_dist = dot(endPos, plane.normal) - plane.dist
			end

			if start_dist >= 0 and end_dist >= 0 then
				rayCastNode(self, node.children[1], startFraction, endFraction, startPos, endPos, trace, mask)
			elseif start_dist < 0 and end_dist < 0 then
				rayCastNode(self, node.children[2], startFraction, endFraction, startPos, endPos, trace, mask)
			else
				local side_id, fraction_first, fraction_second = 0, 0, 0
				local inversed_distance = 1 / (start_dist - end_dist)

				if start_dist < end_dist then
					side_id = 2
					fraction_first = (start_dist + FLT_EPSILON) * inversed_distance
					fraction_second = (start_dist + FLT_EPSILON) * inversed_distance
				elseif end_dist < start_dist then
					side_id = 1
					fraction_first = (start_dist + FLT_EPSILON) * inversed_distance
					fraction_second = (start_dist - FLT_EPSILON) * inversed_distance
				else
					side_id = 1
					fraction_first, fraction_second = 1, 0
				end

				fraction_first = min(1, max(0, fraction_first))
				fraction_second = min(1, max(0, fraction_second))
				local difX = endPos.x - startPos.x
				local difY = endPos.y - startPos.y
				local difZ = endPos.z - startPos.z

				local fraction_middle = startFraction + (endFraction - startFraction) * fraction_first
				middle.x = startPos.x + fraction_first * difX
				middle.y = startPos.y + fraction_first * difY
				middle.z = startPos.z + fraction_first * difZ

				rayCastNode(self, node.children[side_id], startFraction, fraction_middle, startPos, middle, trace, mask)

				fraction_middle = startFraction + (endFraction - startFraction) * fraction_second
				middle.x = startPos.x + fraction_second * difX
				middle.y = startPos.y + fraction_second * difY
				middle.z = startPos.z + fraction_second * difZ
				side_id = (side_id == 1) and 2 or 1

				rayCastNode(self, node.children[side_id], fraction_middle, endFraction, middle, endPos, trace, mask)
			end
		end

		--- Returns a lua-based surface trace result.
		--- Supports mask for surface flags (SURF_*). See https://developer.valvesoftware.com/wiki/BSP_flags_(Source)
		---
		--- **Note**: If the trace starts inside a brush, faces facing away will be ignored. Using a mask enhances performance, focusing solely on faces matching the mask.
		--- @param startPos Vector
		--- @param endPos Vector
		--- @param mask SURF? The surface flags to check for. (SURF_*)
		--- @return table
		function meta_bsp:SurfaceTraceLine( startPos, endPos, mask)
			local trace = newTrace( startPos, endPos )
			nodes = self:GetNodes()
			leafs = self:GetLeafs()
			rayCastNode(self, 0, 0, 1, startPos, endPos, trace, mask)
			if trace.Fraction < 1 then
				trace.Hit = true
			end
			return trace
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_soundModule.lua")
do
	NikNaks.Sounds = {}

	do
		---Returns the duration of a wave file
		---@param fil File
		---@return number seconds # If unable to read the file, it will return 0
		local function getWaveFileDuration(fil)
			fil:Skip(4)
			if fil:Read(4) ~= "WAVE" then fil:Close() return 0 end -- Make sure it's a WAVE file
			local bitRate = 0
			-- Handle headers
			while true do
				local headerId = string.lower(fil:Read(4))
				local dataSize = fil:ReadLong()
				local endPos = fil:Tell() + dataSize
				if headerId == "fmt " then
					fil:Skip(8) -- Format, Channels, sampleRate
					bitRate = fil:ReadLong()
					fil:Seek(endPos)
					continue
				elseif headerId == "data" then
					fil:Close()
					return dataSize / bitRate
				else
					-- Check if headerId contains a-z characters. Could be a custom chunk
					if string.match(headerId, "[a-z]") then fil:Seek(endPos) continue end
				end
				break
			end
			-- Fallback to file size
			if bitRate > 0 then
				return (fil:Size() - 28) / bitRate
			end
			fil:Close()
			return 0
		end

		--- Returns the duration of an OGG file
		---
		--- *Note: This only works for OGG files with a Vorbis header*.
		---@param fil File
		---@return integer
		local function getOGGDuration(fil)
			-- Locate the last page header
			local size = fil:Size() - 6
			for i = size, 0, -1 do
				fil:Seek(i)
				if fil:Read(4) == "OggS" then
					if fil:ReadByte() == 0 then break end -- Version have to be 0
				end
			end
			if fil:ReadByte() ~= 0x04 then fil:Close() return 0 end -- Ensure EOS flag is set
			local granulePos = fil:ReadLong()
			-- Locate first Voribs header. This should be somewhere after 28 bytes from the start.
			-- Limit this to 1000 bytes to prevent lag for non-vorbis ogg files
			local found = false
			for i = 28, 1000, 1 do
				fil:Seek(i)
				if fil:Read(6) == "vorbis" then
					found = true
					break
				end
			end
			if not found then fil:Close() return 0 end

			fil:Skip(5)
			local rate = fil:ReadLong()
			return granulePos / rate
		end

		/*
		--- Returns the duration of an MP3 file
		---@param soundPath string
		---@return integer
		local function getMP3Duration(soundPath)
			local buff = NikNaks.BitBuffer.OpenFile( soundPath, "GAME" )
			if not buff then return 0 end
			-- check for ID3v2 tag
			local tag = buff:Read(3)
			if tag == "ID3" then
				local majorVersion = buff:ReadByte()
				local minorVersion = buff:ReadByte()
				local flags = buff:ReadByte()
				local size = buff:ReadLong()
				if bit.band(flags, 0x10) ~= 0 then
					-- Extended header
					local extSize = buff:ReadLong()
					buff:Skip(extSize - 6)
				end
				buff:Skip(size - 10)

				-- Check for another ID3v2 tag
				tag = buff:Read(3)
				if tag == "ID3" then
					majorVersion = buff:ReadByte()
					minorVersion = buff:ReadByte()
					flags = buff:ReadByte()
					size = buff:ReadLong()
					if bit.band(flags, 0x10) ~= 0 then
						-- Extended header
						local extSize = buff:ReadLong()
						buff:Skip(extSize - 6)
					end
					buff:Skip(size - 10)
				end

				-- Check for a MPEG header
				local header = buff:Read(3)
				if header == "TAG" then

					return -4
				end


			else

			end

			return duration
		end*/

		--- Returns the duration of a sound file. Supports WAV and OGG files, regardless of OS.
		---
		--- **Note**: This only works for OGG files with a Vorbis header
		---
		--- **⚠Warning**: This isn't cached, so it's best to cache the duration if you're going to use it multiple times.
		---@param soundPath string # The path to the sound file.
		---@return number seconds # If unable to read the file, it will return 0
		function NikNaks.Sounds.GetDuration(soundPath)
			local fil = file.Open("sound/" .. soundPath, "rb", "GAME")
			if not fil then return 0 end
			-- Read the start of the header
			local header = fil:Read(4)
			if header == "RIFF" then
				return getWaveFileDuration(fil)
			elseif header == "OggS" then
				return getOGGDuration(fil)
			elseif string.match(header, "ID3") then
				fil:Close()
			end
			return 0
		end
	end
end
--NikNaks.AutoInclude("niknaks/modules/sh_datapackage.lua")
do
	NikNaks.DataPackage = {}

	local NET = "NikNak_Data"

	local NET_HEADER = 0
	local NET_DATA = 1

	local conMaxSize = CreateConVar( "niknaks_datapackage_maxsize", "63", FCVAR_ARCHIVE + FCVAR_REPLICATED, "The max size of a data packages in kb." , 1, 63 )
	local conMaxTime = CreateConVar( "niknaks_datapackage_maxtime", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "The max time inbetween packages." , 0.5, 5 )

	-- Net messages can max be 64kb in size. And a roughly 128kb/s limit. Max 1 package pr second.

	---@class DataPackage
	---@field _id string # The package id.
	---@field _data number[] # 32bit data
	---@field _size number # The bigbuffer size.
	---@field _nsize number # The size of the data.
	---@field _nid number # The current index of the data.
	---@field _players Player[] # The players that should receive this package.


	--- Returns the max size of a data package in longs.
	---@return number
	local function getMaxConSize()
		return math.floor( conMaxSize:GetInt() * 256 )
	end


	if SERVER then
		util.AddNetworkString( NET )
		---@type DataPackage[]
		local dataToSend = {}
		DEBUGDATASEND = dataToSend

		local nextSend = 0
		local function onThink()
			-- Once pr second
			if nextSend >= CurTime() then return end
			nextSend = CurTime() + conMaxTime:GetFloat()

			if #dataToSend == 0 then
				hook.Remove( "Think", "NikNaks.DataPackage" )
				return
			end
			local package = dataToSend[1]

			if #package._data == package._nid then
				-- We're done with this package.
				table.remove( dataToSend, 1 )
				hook.Run( NikNaks.Hooks.DataPackageDone, package._id )
				return
			end

			net.Start(NET)
				net.WriteUInt( NET_DATA, 1 )
				for i = 1, getMaxConSize() do
					if not package._data[package._nid + 1] then break end
					package._nid = package._nid + 1
					net.WriteUInt( package._data[package._nid], 32 )
				end
			net.Send( package._players )
		end

		--- Sends a data package to the specified players.
		--- @param id string # The package id.
		--- @param bitBuffer BitBuffer # The data to send.
		--- @param players Player[] # The players to send the data to.
		---
		--- *Server*:
		function NikNaks.DataPackage.Send( id, bitBuffer, players )
			---@type DataPackage
			local package = {
				_id = id,
				_data = bitBuffer._data,
				_size = bitBuffer:Size(),
				_nsize = #bitBuffer._data,
				_players = players,
				_nid = 0
			}

			hook.Run( NikNaks.Hooks.DataPackageStart, package._id )

			net.Start(NET)
				net.WriteUInt( NET_HEADER, 1 )
				net.WriteString( id )
				net.WriteUInt( package._size, 32 )
				net.WriteUInt( package._nsize, 32 )
			net.Send( players )

			table.insert( dataToSend, package )
			hook.Add( "Think", "NikNaks.DataPackage", onThink )
		end

		--- Returns true if the package is in the queue to be sent.
		--- @param id string
		--- @return boolean
		---
		--- @server
		function NikNaks.DataPackage.IsInQueue( id )
			for i = 1, #dataToSend do
				if dataToSend[i]._id == id then return true end
			end
			return false
		end

		--- Returns true if the package id is being sent.
		--- @param id string
		--- @return boolean
		---
		--- @server
		function NikNaks.DataPackage.IsSending( id )
			return dataToSend[1] and dataToSend[1]._id == id or false
		end

		--- Returns the current percent of the package being sent.
		---@return number # The current percent. 0-1
		function NikNaks.DataPackage.CurrentPercent()
			local currentPackage = dataToSend[1]
			if not currentPackage then return 0 end
			return currentPackage._nid / currentPackage._nsize
		end
	else
		---@type DataPackage?
		local packageBuilder

		---Returns true if the package id is being received.
		---@param id string
		---@return boolean
		---
		---@client
		function NikNaks.DataPackage.IsReciving( id )
			return packageBuilder and packageBuilder._id == id or false
		end

		net.Receive( NET, function()
			local header = net.ReadUInt( 1 )
			if header == NET_HEADER then
				local id = net.ReadString()
				local size = net.ReadUInt( 32 )
				local nsize = net.ReadUInt( 32 )

				packageBuilder = {
					_id = id,
					_data = {},
					_size = size,
					_nsize = nsize,
					_players = {},
					_nid = 0
				}

			elseif header == NET_DATA then
				if not packageBuilder then return end
				for i = 1, getMaxConSize() do
					if #packageBuilder._data == packageBuilder._nsize then
						-- Done
						local bitBuffer = NikNaks.BitBuffer.Create( packageBuilder._data )
						bitBuffer._len = packageBuilder._size
						bitBuffer:Seek( 0 )
						hook.Run( NikNaks.Hooks.DataPackageDone, packageBuilder._id, bitBuffer )
						packageBuilder = nil
						return
					end
					table.insert( packageBuilder._data, net.ReadUInt( 32 ) )
					packageBuilder._nid = packageBuilder._nid + 1
				end
			end
		end)

		--- Returns the current percent of the package being sent.
		---@return number # The current percent. 0-1
		function NikNaks.DataPackage.CurrentPercent()
			if not packageBuilder then return 0 end
			return packageBuilder._nid / packageBuilder._nsize
		end
	end
end
--NikNaks.AutoInclude("niknaks/framework/sh_localbsp.lua")
do
	-- Load the current map
	--- @type BSPObject?
	local BSP, BSP_ERR = NikNaks.Map()
	local NikNaks = NikNaks

	--- @type BSPObject?
	NikNaks.CurrentMap = BSP

	if not BSP and BSP_ERR then
		if BSP_ERR == NikNaks.BSP_ERROR_FILECANTOPEN then
			ErrorNoHalt("NikNaks are unable to open the mapfile!")
		elseif BSP_ERR == NikNaks.BSP_ERROR_NOT_BSP then
			ErrorNoHalt("NikNaks can't read the mapfile (It isn't VBSP)!")
		elseif BSP_ERR == NikNaks.BSP_ERROR_TOO_NEW then
			ErrorNoHalt("NikNaks can't read the mapfile (Newer than v20)!")
		elseif BSP_ERR == NikNaks.BSP_ERROR_FILENOTFOUND then
			ErrorNoHalt("NikNaks can't read the mapfile (File not found)!")
		else
			ErrorNoHalt("NikNaks can't read the mapfile (Unknown)!")
		end
	end
end