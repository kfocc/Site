if SERVER then
    AddCSLuaFile("data/utf8_data.lua")
end

local a, b = include("data/utf8_data.lua")
local d = string.byte
local e = string.format
local f = string.len
local g = string.sub
local h = "Invalid UTF-8 character: %s, %s."
local i = "UTF-8 string terminated early: %s."

local function j(k, l)
    l = l or 1

    if not isstring(k) then
        ErrorNoHaltWithStack("bad argument #1 to 'utf8charbytes' (string expected, got " .. type(k) .. ")")

        return 1
    end

    if not isnumber(l) then
        ErrorNoHaltWithStack("bad argument #2 to 'utf8charbytes' (number expected, got " .. type(l) .. ")")

        return 1
    end

    local c = d(k, l)

    if c > 0 and c <= 127 then
        return 1
    elseif c >= 194 and c <= 223 then
        local m = d(k, l + 1)

        if not m then
            ErrorNoHaltWithStack(e(i, k))

            return 2
        end

        if m < 128 or m > 191 then
            ErrorNoHaltWithStack(e(h, k, m))
        end

        return 2
    elseif c >= 224 and c <= 239 then
        local m = d(k, l + 1)
        local n = d(k, l + 2)

        if not m or not n then
            ErrorNoHaltWithStack(e(i, k))

            return 3
        end

        if c == 224 and (m < 160 or m > 191) then
            ErrorNoHaltWithStack(e(h, k, m))
        elseif c == 237 and (m < 128 or m > 159) then
            ErrorNoHaltWithStack(e(h, k, m))
        elseif m < 128 or m > 191 then
            ErrorNoHaltWithStack(e(h, k, m))
        end

        if n < 128 or n > 191 then
            ErrorNoHaltWithStack(e(h, k, n))
        end

        return 3
    elseif c >= 240 and c <= 244 then
        local m = d(k, l + 1)
        local n = d(k, l + 2)
        local o = d(k, l + 3)

        if not m or not n or not o then
            ErrorNoHaltWithStack(e(i, k))

            return 4
        end

        if c == 240 and (m < 144 or m > 191) then
            ErrorNoHaltWithStack(e(h, k, m))
        elseif c == 244 and (m < 128 or m > 143) then
            ErrorNoHaltWithStack(e(h, k, m))
        elseif m < 128 or m > 191 then
            ErrorNoHaltWithStack(e(h, k, m))
        end

        if n < 128 or n > 191 then
            ErrorNoHaltWithStack(e(h, k, n))
        end

        if o < 128 or o > 191 then
            ErrorNoHaltWithStack(e(h, k, o))
        end

        return 4
    else
        ErrorNoHaltWithStack(e(h, k, c))

        return 1
    end
end

local function p(k)
    if not isstring(k) then
        ErrorNoHaltWithStack("bad argument #1 to 'utf8len' (string expected, got " .. type(k) .. ")")

        return 1
    end

    local q = 1
    local r = f(k)
    local s = 0

    while q <= r do
        s = s + 1
        q = q + j(k, q)
    end

    return s
end

if not string.utf8bytes then
    string.utf8bytes = j
end

if not string.utf8len then
    string.utf8len = p
end

local function t(k, l, u)
    u = u or -1

    if not isstring(k) then
        ErrorNoHaltWithStack("bad argument #1 to 'utf8sub' (string expected, got " .. type(k) .. ")")

        return ""
    end

    if not isnumber(l) then
        ErrorNoHaltWithStack("bad argument #2 to 'utf8sub' (number expected, got " .. type(l) .. ")")

        return ""
    end

    if not isnumber(u) then
        ErrorNoHaltWithStack("bad argument #3 to 'utf8sub' (number expected, got " .. type(u) .. ")")

        return ""
    end

    local q = 1
    local r = f(k)
    local s = 0
    local v = l >= 0 and u >= 0 or p(k)
    local w = l >= 0 and l or v + l + 1
    local x = u >= 0 and u or v + u + 1
    if w > x then return "" end
    local y, z = 1, r

    while q <= r do
        s = s + 1

        if s == w then
            y = q
        end

        q = q + j(k, q)

        if s == x then
            z = q - 1
            break
        end
    end

    return g(k, y, z)
end

if not string.utf8sub then
    string.utf8sub = t
end

local function A(k, B)
    if not isstring(k) then
        ErrorNoHaltWithStack("bad argument #1 to 'utf8replace' (string expected, got " .. type(k) .. ")")

        return ""
    end

    if not istable(B) then
        ErrorNoHaltWithStack("bad argument #2 to 'utf8replace' (table expected, got " .. type(B) .. ")")

        return ""
    end

    local q = 1
    local r = f(k)
    local C
    local D = ""

    while q <= r do
        C = j(k, q)
        local c = g(k, q, q + C - 1)
        D = D .. (B[c] or c)
        q = q + C
    end

    return D
end

local function E(k)
    return A(k, a)
end

if not string.utf8upper and a then
    string.utf8upper = E
end

local function F(k)
    return A(k, b)
end

if not string.utf8lower and b then
    string.utf8lower = F
end

local function G(k)
    if not isstring(k) then
        ErrorNoHaltWithStack("bad argument #1 to 'utf8reverse' (string expected, got " .. type(k) .. ")")

        return ""
    end

    local r = f(k)
    local q = r
    local C
    local D = ""

    while q > 0 do
        c = d(k, q)

        while c >= 128 and c <= 191 do
            q = q - 1
            c = d(k, q)
        end

        C = j(k, q)
        D = D .. g(k, q, q + C - 1)
        q = q - 1
    end

    return D
end

if not string.utf8reverse then
    string.utf8reverse = G
end

utf8.len = string.utf8len
utf8.sub = string.utf8sub
utf8.upper = string.utf8upper
utf8.lower = string.utf8lower
utf8.reverse = string.utf8reverse