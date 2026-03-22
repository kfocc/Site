local CATEGORY_NAME = "Event"

function ulx.setmodelscale( calling_ply, target_ply, amount )
  if amount > 2 or amount < .5 then
    ULib.tsayError( calling_ply, "Размер модели должен быть от 0.5 до 2", true )
    return
  end
  target_ply:SetModelScale( amount, 1 )
  ulx.fancyLogAdmin( calling_ply, "#A устанавливает #T размер модели #f", target_ply, amount )
end
local setmodelscale = ulx.command( CATEGORY_NAME, "ulx setmodelscale", ulx.setmodelscale, "!setmodelscale" )
setmodelscale:addParam{ type=ULib.cmds.PlayerArg }
setmodelscale:addParam{ type=ULib.cmds.NumArg, hint = "size", default = 0}
setmodelscale:defaultAccess( ULib.ACCESS_ADMIN )
setmodelscale:help( "Устанавливает размер модели игрока" )

function ulx.removeeventweapons(calling_ply, target_ply)
  for _, weap in ipairs(target_ply:GetWeapons()) do
    if weap.IsEvent then
      weap:Remove()
    end
  end
  ulx.fancyLogAdmin(calling_ply, "#A удаляет все ивентовые оружия у #T", target_ply)
end
local removeeventweapons = ulx.command(CATEGORY_NAME, "ulx removeeventweapons", ulx.removeeventweapons, "!removeeventweapons")
removeeventweapons:addParam{ type=ULib.cmds.PlayerArg }
removeeventweapons:defaultAccess(ULib.ACCESS_ADMIN)
removeeventweapons:help("Удаляет все ивентовые оружия у игрока")

function ulx.removeeventweaponsall(calling_ply)
  for _, ply in player.Iterator() do
    for _, weap in ipairs(ply:GetWeapons()) do
      if weap.IsEvent then
        weap:Remove()
      end
    end
  end
  ulx.fancyLogAdmin(calling_ply, "#A удаляет все ивентовые оружия у всех игроков")
end
local removeeventweaponsall = ulx.command(CATEGORY_NAME, "ulx removeeventweaponsall", ulx.removeeventweaponsall, "!removeeventweaponsall")
removeeventweaponsall:defaultAccess(ULib.ACCESS_ADMIN)
removeeventweaponsall:help("Удаляет все ивентовые оружия у всех игроков")

function ulx.setmodel(calling_ply, target_ply, model)
  if not IsValid(target_ply) then return end
  --local is_model_valid = util.IsValidModel(model) or file.Exists(model, "GAME")
  --if not is_model_valid then
  --  ULib.tsayError(calling_ply, "Модель не найдена", true)
  --  return
  --end
  --if not util.IsValidRagdoll(model) then
  --  ULib.tsayError(calling_ply, "Модель не является регдоллом", true)
  --  return
  --end
  local is_valid
  for k, v in pairs(player_manager.AllValidModels()) do
    if v == model then
      is_valid = true
      break
    end
    if k == model then
      is_valid = true
      model = v
      break
    end
  end
  if not is_valid then
    ULib.tsayError(calling_ply, "Модель не найдена", true)
    return
  end
  if not target_ply.pre_event_bodygroups then
    target_ply.pre_event_bodygroups = {}
    for i = 1,#target_ply:GetBodyGroups() do
      target_ply.pre_event_bodygroups[i] = target_ply:GetBodygroup(i)
    end
    target_ply.pre_event_model = target_ply:GetModel()
  end
  target_ply:SetModel(model)
  ulx.fancyLogAdmin(calling_ply, "#A устанавливает #T модель #s", target_ply, model)
end
local setmodel = ulx.command(CATEGORY_NAME, "ulx setmodel", ulx.setmodel, "!setmodel")
setmodel:addParam{ type=ULib.cmds.PlayerArg }
setmodel:addParam{ type=ULib.cmds.StringArg, hint = "model" }
setmodel:defaultAccess(ULib.ACCESS_ADMIN)
setmodel:help("Устанавливает модель игрока")

function ulx.getmodellist(calling_ply)
  local models = {}
  for k, v in pairs(player_manager.AllValidModels()) do
    table.insert(models, v)
  end
  table.sort(models)
  ULib.console(calling_ply, "Список моделей:")
  for k, v in ipairs(models) do
    ULib.console(calling_ply, v)
  end
  ULib.tsay(calling_ply, "Список моделей отправлен в консоль")
end
local getmodellist = ulx.command(CATEGORY_NAME, "ulx getmodellist", ulx.getmodellist, "!getmodellist")
getmodellist:defaultAccess(ULib.ACCESS_ADMIN)
getmodellist:help("Получить список всех моделей")

local function RemoveEventModel(ply)
  if ply.pre_event_bodygroups then
    ply.pre_event_bodygroups = nil
    ply.pre_event_model = nil
  end
end

hook.Add("PlayerSpawn", "Events.RemoveModel", RemoveEventModel)
hook.Add("PlayerDeath", "Events.RemoveModel", RemoveEventModel)

local function RestoreModel(ply)
  if ply.pre_event_bodygroups then
    ply:SetModel(ply.pre_event_model)
    for i = 1,#ply:GetBodyGroups() do
      ply:SetBodygroup(i, ply.pre_event_bodygroups[i])
    end
    ply.pre_event_bodygroups = nil
    ply.pre_event_model = nil
  end
end

function ulx.restoremodel(calling_ply, target_ply)
  if not target_ply.pre_event_bodygroups or not target_ply.pre_event_model then
    ULib.tsayError(calling_ply, "Игрок не менял модель", true)
    return
  end
  RestoreModel(target_ply)
  ulx.fancyLogAdmin(calling_ply, "#A восстанавливает #T модель", target_ply)
end
local restoremodel = ulx.command(CATEGORY_NAME, "ulx restoremodel", ulx.restoremodel, "!restoremodel")
restoremodel:addParam{ type=ULib.cmds.PlayerArg }
restoremodel:defaultAccess(ULib.ACCESS_ADMIN)
restoremodel:help("Восстанавливает модель игрока")

function ulx.restoremodelall(calling_ply)
  for _, ply in player.Iterator() do
    if ply.pre_event_bodygroups then
      RestoreModel(ply)
    end
  end
  ulx.fancyLogAdmin(calling_ply, "#A восстанавливает модели всех игроков")
end
local restoremodelall = ulx.command(CATEGORY_NAME, "ulx restoremodelall", ulx.restoremodelall, "!restoremodelall")
restoremodelall:defaultAccess(ULib.ACCESS_ADMIN)
restoremodelall:help("Восстанавливает модели всех игроков")

function ulx.hp( calling_ply, target_plys, amount )
  target_plys:SetHealth( amount )
  ulx.fancyLogAdmin( calling_ply, "#A выдаёт #T #i хп", target_plys, amount )
end
local hp = ulx.command( CATEGORY_NAME, "ulx hp", ulx.hp, "!hp" )
hp:addParam{ type=ULib.cmds.PlayerArg }
hp:addParam{ type=ULib.cmds.NumArg, min=1, max=1000, hint="hp", ULib.cmds.round }
hp:defaultAccess( ULib.ACCESS_ADMIN )
hp:help("Выдаёт игроку хп")

function ulx.armor( calling_ply, target_plys, amount )
  target_plys:SetArmor( amount )
  ulx.fancyLogAdmin( calling_ply, "#A выдаёт #T #i брони", target_plys, amount )
end
local armor = ulx.command( CATEGORY_NAME, "ulx armor", ulx.armor, "!armor" )
armor:addParam{ type=ULib.cmds.PlayerArg }
armor:addParam{ type=ULib.cmds.NumArg, min=0, max=1000, hint="armor", ULib.cmds.round }
armor:defaultAccess( ULib.ACCESS_ADMIN )
armor:help("Выдаёт игроку броню")

function ulx.setJob( calling_ply, target_ply, job )
  local newjob = nil
  if tonumber(job) then
    newjob = RPExtraTeams[tonumber(job)] --way faster! you just need to know the jobs teamnumber (better for other lua scripts to use it)
  else
    for i,v in pairs( RPExtraTeams ) do
      if string.lower( v.name ) == string.lower( job ) or
        string.lower( v.command ) == string.lower( job ) or
        string.lower( "vote" .. v.command ) == string.lower( job )
      then --exact match
        newjob = v
        break
      elseif string.find( string.lower( v.name ), string.lower( job ) ) != nil or
          string.find( string.lower( "vote" .. v.command ), string.lower( job ) ) != nil
      then
        if not newjob or (newjob and string.len(v.name) < string.len(newjob.name)) then --always take the matching job with the shortest name else "Civil Protection" could end up with "Civil Protection Chief"
          newjob = v
        end
      end
    end
  end
  if newjob == nil then
    ULib.tsayError( calling_ply, "Не найдено!", true )
    return
  end
  local SetTeam = target_ply.changeTeam or target_ply.SetTeam --uses darkrps own functions now
  SetTeam(target_ply, newjob.team, true)
  ulx.fancyLogAdmin( calling_ply, "#A изменяет профессию #T на #s", target_ply, newjob.name )
end
local setJob = ulx.command( CATEGORY_NAME, "ulx setjob", ulx.setJob, "!setjob" )
setJob:addParam{ type=ULib.cmds.PlayerArg }
setJob:addParam{ type=ULib.cmds.StringArg, hint="new job", ULib.cmds.takeRestOfLine }
setJob:defaultAccess( ULib.ACCESS_ADMIN )
setJob:help( "Установка профы" )

function ulx.editbodygroups(calling_ply, target_ply)
  netstream.Start(calling_ply, "EditBodygroups", target_ply)
end
local editbodygroups = ulx.command(CATEGORY_NAME, "ulx editbodygroups", ulx.editbodygroups, "!editbodygroups")
editbodygroups:addParam{ type=ULib.cmds.PlayerArg }
editbodygroups:defaultAccess(ULib.ACCESS_ADMIN)
editbodygroups:help("Редактирование бодигрупп игрока")


function ulx.setcollision(calling_ply, target_ply, should)
  if target_ply:Team() ~= TEAM_ADMIN then
    ULib.tsayError(calling_ply, "Игрок не администратор", true)
    return
  end
  if should then
    target_ply:SetAdminCollide(true)
    ulx.fancyLogAdmin(calling_ply, "#A включает коллизию для #T", target_ply)
  else
    target_ply:SetAdminCollide()
    ulx.fancyLogAdmin(calling_ply, "#A отключает коллизию для #T", target_ply)
  end
end
local setcollision = ulx.command(CATEGORY_NAME, "ulx setcollision", ulx.setcollision, "!setcollision")
setcollision:addParam{ type=ULib.cmds.PlayerArg }
setcollision:addParam{ type=ULib.cmds.BoolArg, hint = "enable/disable" }
setcollision:defaultAccess(ULib.ACCESS_ADMIN)
setcollision:help("Включает/отключает коллизию для администратора")

function ulx.disablecollisionall(calling_ply)
  for _, ply in player.Iterator() do
    if ply:IsAdminCollide() then
      ply:SetAdminCollide()
    end
  end
  ulx.fancyLogAdmin(calling_ply, "#A отключает коллизию для всех администраторов")
end
local disablecollisionall = ulx.command(CATEGORY_NAME, "ulx disablecollisionall", ulx.disablecollisionall, "!disablecollisionall")
disablecollisionall:defaultAccess(ULib.ACCESS_ADMIN)
disablecollisionall:help("Отключает коллизию для всех администраторов")

function ulx.music(calling_ply, link, should_stop, zone, on_my_pos)
  if not link then
    ULib.tsayError(calling_ply, "Ссылка не найдена", true)
    return
  end
  local is_zone = zone and zone ~= ""
  local receivers = {}
  if is_zone then
    for _, ply in player.Iterator() do
      if ply:GetZone() == zone or ply == calling_ply then
        table.insert(receivers, ply)
      end
    end
  else
    receivers = player.GetAll()
  end
  if #receivers == 0 then
    ULib.tsayError(calling_ply, "Игроки не найдены", true)
    return
  end
  local on_pos = on_my_pos and calling_ply:GetPos()
  netstream.Start(receivers, "PlayMusic", link, should_stop, on_pos)
  local add = should_stop and " отключая все звуки" or ""
  local add2 = on_my_pos and " на своей позиции" or ""
  if is_zone then
    ulx.fancyLogAdmin(calling_ply, "#A включает музыку в зоне #s" .. add .. add2, zone)
  else
    ulx.fancyLogAdmin(calling_ply, "#A включает музыку всем игрокам" .. add .. add2)
  end
end
local music = ulx.command(CATEGORY_NAME, "ulx music", ulx.music, "!music")
music:addParam{ type=ULib.cmds.StringArg, hint = "Ссылка на mp3" }
music:addParam{ type=ULib.cmds.BoolArg, hint = "Ввод stopsound", ULib.cmds.optional }
music:addParam{ type=ULib.cmds.StringArg, hint = "Название зоны", ULib.cmds.optional }
music:addParam{ type=ULib.cmds.BoolArg, hint = "3д звук на вашей позиции", ULib.cmds.optional }

if CLIENT then
  local cur_station
  local enabled = CreateClientConVar( "unionrp_music", "1", true, false, "Включена ли музыка" )
  local volume = CreateClientConVar( "unionrp_music_volume", "1", true, false, "Громкость музыки", 0, 1)

  cvars.AddChangeCallback("unionrp_music", function(convar, old, new)
    local should = tobool(new)
    if not should and cur_station and IsValid(cur_station) then
      cur_station:Stop()
    end
  end)

  cvars.AddChangeCallback("unionrp_music_volume", function(convar, old, new)
    local cur_volume = math.Clamp(tonumber(new), 0, 1)
    if cur_station and IsValid(cur_station) then
      cur_station:SetVolume(cur_volume)
    end
  end)

  netstream.Hook("PlayMusic", function(link, should_stop, position)
    if not enabled:GetBool() then
      chat.AddText( col.o, "[UnionRP Music]", col.w, " У вас отключена музыка. Для включения пропишите в консоль <unionrp_music 1>" )
      return
    end

    local cur_volume = math.Clamp(volume:GetFloat(), 0, 1)
    if not link then return end

    if should_stop then
      RunConsoleCommand("stopsound")
    end
    chat.AddText( col.o, "[UnionRP Music]", col.w, " Для отключения музыки пропишите в консоль <unionrp_music 0>" )
    chat.AddText( col.o, "[UnionRP Music]", col.w, " Для остановки музыки пропишите в консоль <stopsound>" )
    chat.AddText( col.o, "[UnionRP Music]", col.w, " Для изменения громкости пропишите в консоль <unionrp_music_volume 0 - 1>" )
    sound.PlayURL ( link, position and "3d" or "mono", function(station)
      if cur_station and IsValid(cur_station) then
        cur_station:Stop()
      end

      if not IsValid(station) then
        chat.AddText( col.o, "[UnionRP Music]", col.w, " Не удалось воспроизвести песню" )
        return
      end

      cur_station = station
      if position then
        station:Set3DFadeDistance(500, 1000)
        station:SetPos(position)
      end
      station:SetVolume(cur_volume)
      station:Play()
    end)
  end)
end