local PLAYER, ENTITY = FindMetaTable("Player"), FindMetaTable("Entity")
local GetTable = ENTITY.GetTable

if CLIENT then
  do
    cacher__LocalPlayer = cacher__LocalPlayer or LocalPlayer

    do
      local LP = cacher__LocalPlayer()

      function LocalPlayer()
        return LP
      end

      LPLY = LocalPlayer

      hook.Add("InitPostEntity", "CacheLocalPlayer", function()
        LP = cacher__LocalPlayer()
        hook.Remove("InitPostEntity", "CacheLocalPlayer")
      end, HOOK_MONITOR_HIGH)
    end
  end
end

-- meta
function PLAYER:__index(key)
  return PLAYER[key] or ENTITY[key] or GetTable(self)[key]
end

function PLAYER:Timer(name, time, reps, callback, failure)
  name = self:SteamID64() .. "-" .. name
  timer.Create(name, time, reps, function()
    if IsValid(self) then
      callback(self)
    else
      timer.Remove(name)

      if failure then
        failure()
      end
    end
  end)
end

function PLAYER:TimerExists(name)
  name = self:SteamID64() .. "-" .. name
  return timer.Exists(name)
end

function PLAYER:TimerRemove(name)
  name = self:SteamID64() .. "-" .. name
  timer.Remove(name)
end

function player.inRange(position, range)
  range = range ^ 2

  local output = {}

  for _, ply in player.Iterator() do
    if ply:GetPos():DistToSqr(position) <= range then
      table.insert(output, ply)
    end
  end

  return output
end

function player.GetBySteamID(steamid)
  steamid = steamid:upper()

  for _, ply in player.Iterator() do
    if steamid == ply:SteamID() then return ply end
  end

  return false
end

function player.GetBySteamID64(steamid)
  steamid = tostring(steamid)

  for _, ply in player.Iterator() do
    if steamid == ply:SteamID64() then return ply end
  end

  return false
end

function player.GetByUniqueID(id)
  for _, ply in player.Iterator() do
    if id == ply:UniqueID() then return ply end
  end

  return false
end


local telequeue = {}
local setpos = ENTITY.SetPos
function PLAYER:SetPos(pos)
  telequeue[self] = pos
end

hook.Add("FinishMove", "SetPos.FinishMove", function(pl)
  if telequeue[pl] then
    setpos(pl, telequeue[pl])
    telequeue[pl] = nil
    return true
  end
end)

do
  local GetShootPos = PLAYER.GetShootPos
  local Alive, IsBot = PLAYER.Alive, PLAYER.IsBot
  hook.Add("SetupMove", "Player Shoot Position Fix", function(self)
    if IsBot(self) or not Alive(self) then
      return
    end
    self.m_RealShootPos = GetShootPos(self)
  end, HOOK_MONITOR_HIGH)
  hook.Add("EntityFireBullets", "Player Shoot Position Fix", function(self, data)
    if not self:IsPlayer() or IsBot(self) or not Alive(self) then
      return
    end
    local src = GetShootPos(self)
    if data.Src == src then
      data.Src = self.m_RealShootPos or src
      return true
    end
  end, HOOK_MONITOR_HIGH)
end

do
  local IsOnGround, GetMoveType = ENTITY.IsOnGround, ENTITY.GetMoveType
  local Crouching = PLAYER.Crouching
  do
    local MOVETYPE_LADDER = _G.MOVETYPE_LADDER
    hook.Add("PlayerFootstep", "Player Footstep Fix", function(self)
      if not IsOnGround(self) and GetMoveType(self) ~= MOVETYPE_LADDER then
        return true
      end
    end, HOOK_HIGH)
  end
  local MOVETYPE_NOCLIP, IN_DUCK = _G.MOVETYPE_NOCLIP, _G.IN_DUCK
  hook.Add("StartCommand", "Air Crouching Fix", function(self, cmd)
    if GetMoveType(self) == MOVETYPE_NOCLIP or IsOnGround(self) or cmd:KeyDown(IN_DUCK) or not Crouching(self) then
      return
    end
    cmd:AddKey(IN_DUCK)
    return
  end, HOOK_MONITOR_HIGH)
end
