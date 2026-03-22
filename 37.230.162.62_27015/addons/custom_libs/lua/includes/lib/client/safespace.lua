local rawget = rawget
local rawset = rawset
local unpack = unpack
local TEXT_FILTER_UNKNOWN = TEXT_FILTER_UNKNOWN
local FilterText = util.FilterText

-- TODO: This needs to be smartly cleaned regularly so it doesn't get really, really big
SafeSpace = { Cache = {} }
local cache = SafeSpace.Cache

timer.Create("SafeSpace_CacheCleaner", 180, 0, function()
  cache = {}
end)

local _filter = function( text )
    return FilterText( text, TEXT_FILTER_UNKNOWN )
end

local function filter( text )
    if not text then return end

    local cached = rawget( cache, text )
    if cached then
        return cached == true and text or cached
    end

    -- We just save "true" if the
    -- text remained unchanged to save tons of memory
    local result = _filter( text )
    local toSave = result == text and true or result
    rawset( cache, text, toSave )

    return result
end

local isEnabled = CreateClientConVar( "gm_safespace_enabled", 1, true, false, "Enable/Disable SafeSpace", 0, 1 ):GetBool()
cvars.AddChangeCallback( "gm_safespace_enabled", function( _, _, new )
    isEnabled = tobool( new )
    SafeSpace.Cache = {}
end, "UpdateLocalValue" )

SafeSpace.wrap = function( lib, key, textIndex, argHandler )
    textIndex = textIndex or 1

    local ogName = "_SafeSpaceStub_" .. key
    lib[ogName] = lib[ogName] or lib[key]
    local og = lib[ogName]

    lib[key] = wrapper or function( ... )
        if not isEnabled then return og( ... ) end

        local args = { ... }

        -- TODO: Make the third param either an
        -- index (for default functionality) or a function (for custom filtering)
        if argHandler then
            args = argHandler( args, filter )
        else
            -- args[textIndex] = filter( args[textIndex] )
            rawset( args, textIndex, filter( rawget( args, textIndex ) ) )
        end

        return og( unpack( args ) )
    end
end

hook.Add( "Think", "SafeSpace_CacheFilterText", function()
    hook.Remove( "Think", "SafeSpace_CacheFilterText" )
    FilterText = util.FilterText
end )

local isstring = isstring
local wrap = SafeSpace.wrap

local function filterVarArgs( args, filter )
    local argsCount = #args

    for i = 1, argsCount do
        local arg = rawget( args, i )

        if isstring( arg ) then
            rawset( args, i, filter( arg ) )
        end
    end

    return args
end

hook.Add("Initialize", "SafeSpace_Init", function()
  -- Chat
  wrap( chat, "AddText", nil, filterVarArgs )

  -- Surface
  wrap( surface, "GetTextSize" )
  wrap( surface, "DrawText" )

  -- Notification
  wrap( notification, "AddLegacy" )

  -- Debugoverlay
  wrap( debugoverlay, "Text", 2 )
  wrap( debugoverlay, "ScreenText", 3 )
  wrap( debugoverlay, "EntityTextAtPosition", 3 )

  -- Builtin
  wrap( _G, "print", nil, filterVarArgs )
  wrap( _G, "Msg", nil, filterVarArgs )
  wrap( _G, "MsgAll", nil, filterVarArgs )
  wrap( _G, "MsgC", nil, filterVarArgs )
  wrap( _G, "MsgN", nil, filterVarArgs )
end)