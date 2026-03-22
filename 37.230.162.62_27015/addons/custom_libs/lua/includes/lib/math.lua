local math_random = math.random
local math_abs = math.abs

function math.Clamp(inval, minval, maxval)
  if inval < minval then return minval end
  if inval > maxval then return maxval end

  return inval
end

function table.Shuffle(tbl)
  local len = #tbl
  for i = len, 1, -1 do
    local rand = math_random(len)
    tbl[i], tbl[rand] = tbl[rand], tbl[i]
  end

  return tbl
end

function math.Approach(cur, target, inc)
  inc = math_abs(inc)

  if cur < target then
    local val = cur + inc
    return val < target and val or target
  elseif cur > target then
    local val = cur - inc
    return val > target and val or target
  end

  return target
end