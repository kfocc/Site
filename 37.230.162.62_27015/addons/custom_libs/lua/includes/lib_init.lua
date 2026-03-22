local blacklist = {
    ["hook.lua"] = true,
    ["md.lua"] = true,
    ["pon.lua"] = true,
    ["sfs.lua"] = true
}

local includeList = {}
includeList.cl = (SERVER) and AddCSLuaFile or include
includeList.sv = (SERVER) and include or function() end

includeList.sh = function(path)
    includeList.sv(path)
    includeList.cl(path)
end

local function icludeDir(dir, side)
    local func = includeList[side]
    if not func then return end
    local files = file.Find(dir .. "*.lua", "LUA")

    for _, v in ipairs(files) do
        if not blacklist[v] then
            local path = dir .. v
            func(path)
        end
    end
end

icludeDir("includes/lib/", "sh")
icludeDir("includes/lib/client/", "cl")
-- MsgC(Color(255, 0, 0), "Some libs from dash included.\n")