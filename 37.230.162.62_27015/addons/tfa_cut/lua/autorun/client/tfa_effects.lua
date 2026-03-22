local tracers = CreateClientConVar("tfa_opt_tracers", "0", true, false, "Enable laggy TFA tracers")

hook.Add("TFABase_LateInit", "TFA::RemoveEffects", function()
  TFA._ParticleTracer = TFA._ParticleTracer or TFA.ParticleTracer
  TFA.ParticleTracer = function(...)
    if not tracers:GetBool() then
      return
    end

    return TFA._ParticleTracer(...)
  end
end)

local hooks = {
  {h = "TFA_MuzzleFlash", c = "tfa_opt_muzzleflash", name = "Вспышки при стрельбе", def = "1"},
  {h = "TFA_MuzzleSmoke", c = "tfa_opt_muzzlesmoke", name = "Дым при стрельбе", def = "0"},
  {h = "TFA_EjectionSmoke", c = "tfa_opt_ejectionsmoke", name = "Дым при создании гильз", def = "0"},
  {h = "TFA_MakeShell", c = "tfa_opt_makeshell", name = "Создание гильз", def = "0"},
}

for _, tbl in ipairs(hooks) do
  local hookName = tbl.h
  local convarName = tbl.c
  local name = tbl.name
  local value = tbl.def or "0"
  local convar = CreateClientConVar(convarName, value, true, false, name)
  tbl.convar = convar
  hook.Add(hookName, "TFA::RemoveEffects", function()
    if not convar:GetBool() then
      return false
    end
  end)
end

hook.Add("PopulateToolMenu", "tfa_edithooks", function()
  spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "tfa_opt_settings", "TFA", "", "", function(option)
    option:addlbl("Эффекты", true)
    option:addchk("Трассеры", "Включает лагганые трассеры", tracers:GetBool(), function(c) tracers:SetBool(c) end)
    for _, hookName in ipairs(hooks) do
      local convar = hookName.convar
      option:addchk(hookName.name, "Эффект, который хорошо ест ФПС", convar:GetBool(), function(b) convar:SetBool(b) end)
    end
    local impact = GetConVar("cl_tfa_fx_impact_enabled")
    if impact then
      option:addchk("Попадания", "Включает эффекты попаданий", impact:GetBool(), function(b) impact:SetBool(b) end)
    end
    local muzzlesmoke_limit = GetConVar("cl_tfa_fx_muzzlesmoke_limited")
    if muzzlesmoke_limit then
      option:addchk("Ограничение кол-ва дыма", "Ставит лимит на кол-во эффектов дыма", muzzlesmoke_limit:GetBool(), function(b) muzzlesmoke_limit:SetBool(b) end)
    end
  end)
end)