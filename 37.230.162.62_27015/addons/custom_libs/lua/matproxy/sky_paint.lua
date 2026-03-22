local meta = FindMetaTable("IMaterial")
local setVec = meta.SetVector
local setFlt = meta.SetFloat
local setInt = meta.SetInt
local setTex = meta.SetTexture
local RealTime = RealTime

local update = false
local data = {
  Vector(), -- TOPCOLOR
  Vector(), -- BOTTOMCOLOR
  Vector(), -- SUNNORMAL
  Vector(), -- SUNCOLOR
  Vector(), -- DUSKCOLOR
  1, -- FADEBIAS
  1, -- HDRSCALE
  1, -- DUSKSCALE
  1, -- DUSKINTENSITY
  1, -- SUNSIZE
  1, -- STARLAYERS
  1, -- STARSCALE
  1, -- STARFADE
  1, -- STARPOS
  1, -- STARPOS
  1, -- RTSTARPOS
}
matproxy.Add({
  name = "SkyPaint",
  init = function(self, mat, values) end,
  bind = function(self, mat, ent)
    if not update then
      return
    end

    setVec(mat, "$TOPCOLOR", data[1])
    setVec(mat, "$BOTTOMCOLOR", data[2])
    setVec(mat, "$SUNNORMAL", data[3])
    setVec(mat, "$SUNCOLOR", data[4])
    setVec(mat, "$DUSKCOLOR", data[5])
    setFlt(mat, "$FADEBIAS", data[6])
    setFlt(mat, "$HDRSCALE", data[7])
    setFlt(mat, "$DUSKSCALE", data[8])
    setFlt(mat, "$DUSKINTENSITY", data[9])
    setFlt(mat, "$SUNSIZE", data[10])

    setInt(mat, "$STARLAYERS", data[11])
    if data[11] ~= 0 then
      setFlt(mat, "$STARSCALE", data[12])
      setFlt(mat, "$STARFADE", data[13])
      setTex(mat, "$STARTEXTURE", data[15])
      setFlt(mat, "$STARPOS", data[16])
    end
  end
})

hook.Add("Think", "SkyPaint", function()
  update = false
  data[16] = RealTime() * data[14]
end)

hook.Add("Tick", "SkyPaint", function()
  local g_SkyPaint = g_SkyPaint
  if not (g_SkyPaint and g_SkyPaint:IsValid()) then return end

  update = true
  local values = g_SkyPaint:GetNetworkVars()
  data[1] = values.TopColor
  data[2] = values.BottomColor
  data[3] = values.SunNormal
  data[4] = values.SunColor
  data[5] = values.DuskColor
  data[6] = values.FadeBias
  data[7] = values.HDRScale
  data[8] = values.DuskScale
  data[9] = values.DuskIntensity
  data[10] = values.SunSize

  if values.DrawStars then
    data[11] = values.StarLayers
    data[12] = values.StarScale
    data[13] = values.StarFade
    data[14] = values.StarSpeed
    data[15] = values.StarTexture
    data[16] = RealTime() * data[14] -- To have a valid value
  else
    data[11] = 0
  end
end)

-- Created By JarosLucky