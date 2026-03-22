local E = FindMetaTable("Entity")
local GT = E.GetTable
local EI = E.EntIndex
local iT = 0
local tP = {}

for i = 1, 128 do
  tP[i] = 0
end

hook.Add("CalcMainActivity", "AnimationsTick", function(pL, v)
  if iT ~= tP[EI(pL)] then
    tP[EI(pL)] = iT
  else
    local tD = GT(pL)
    return tD.CalcIdeal, tD.CalcSeqOverride
  end
end, HOOK_HIGH)
hook.Add("Tick", "AnimationsTick", function() iT = iT + 1 end)