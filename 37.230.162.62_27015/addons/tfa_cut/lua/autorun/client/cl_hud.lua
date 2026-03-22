hook.Add("PreRegisterSWEP", "TFA::CutCL", function(SWEP, sClass)
  if sClass == "tfa_gun_base" then
    SWEP.GetTeamColor = function() return color_white end
  end
end)