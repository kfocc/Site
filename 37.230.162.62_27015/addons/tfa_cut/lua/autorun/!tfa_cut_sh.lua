local sin, cos = math.sin, math.cos
local SharedRandom = util.SharedRandom
local TickCount = engine.TickCount
local EntIndex = FindMetaTable("Entity").EntIndex
local fComputeBulletDeviation, fCalculateConeRecoil, fEmitSoundNet, fStopSoundNet
local fNullish = function() end

do
  local flClumpSpread = 0
  local fSpreadBiasPitch, flSpreadBiasYaw = 1, 1
  local flSpreadPitch, flSpreadYaw = 0, 0
  fComputeBulletDeviation = function(self, bulletNum, totalBullets, aimcone) -- Like in ARC-9
    -- trig stuff to ensure the spread is a circle of the right size

    if totalBullets > 1 then
      if bulletNum == 1 then
        local seed = 1337 + EntIndex(self) + TickCount()
        local a = SharedRandom("tfa_physbullet3", 0, 360, seed)
        local spread = aimcone * SharedRandom("tfa_physbullet4", 0, 45, seed) * 1.4142135623730 * 0.1 -- 0.1 костыль, отклонение от прицела до 14 сотых
        -- Yaw
        flSpreadYaw = cos(a) * spread
        -- Pitch
        flSpreadPitch = sin(a) * spread

        flClumpSpread = aimcone --self:GetStatL("Primary.ClumpSpread", aimcone)

        flSpreadBiasYaw = self:GetStatL("Primary.SpreadBiasYaw")
        fSpreadBiasPitch = self:GetStatL("Primary.SpreadBiasPitch")
      end

      local seed2 = bulletNum + EntIndex(self) + TickCount()
      local a = SharedRandom("tfa_physbullet", 0, 360, seed2)
      local spread = flClumpSpread * SharedRandom("tfa_physbullet2", 0, 45, seed2) * 1.4142135623730

      return
        -- Yaw
        (flSpreadYaw + cos(a) * spread) * flSpreadBiasYaw,
        -- Pitch
        (flSpreadPitch + sin(a) * spread) * fSpreadBiasPitch
    end

    local seed = 1337 + EntIndex(self) + TickCount()
    local a = SharedRandom("tfa_physbullet", 0, 360, seed)
    local spread = aimcone * SharedRandom("tfa_physbullet2", 0, 45, seed) * 1.4142135623730

    return
      -- Yaw
      cos(a) * spread * self:GetStatL("Primary.SpreadBiasYaw"),
      -- Pitch
      sin(a) * spread * self:GetStatL("Primary.SpreadBiasPitch")
  end
end

local mult_cvar, dynacc_cvar
do
  local function l_Lerp(t, a, b) return a + (b - a) * t end
  local function l_mathMin(a, b) return (a < b) and a or b end
  local function l_mathMax(a, b) return (a > b) and a or b end
  local function l_ABS(a) return (a < 0) and -a or a end
  local function l_mathClamp(t, a, b)
    if a > b then return b end

    if t > b then
      return b
    end

    if t < a then
      return a
    end

    return t
  end

  local function l_mathApproach(a, b, delta)
    if a < b then
      return l_mathMin(a + l_ABS(delta), b)
    else
      return l_mathMax(a - l_ABS(delta), b)
    end
  end
  local ccon, crec

  fCalculateConeRecoil = function(self)
    local dynacc = false
    local self2 = self:GetTable()
    local jr = self:GetJumpRatio()
    local isr = self:GetIronSightsProgress()

    if dynacc_cvar:GetBool() and (self2.GetStatL(self, "Primary.NumShots") <= 1) then
      dynacc = true
    end

    local isr_1 = l_mathClamp(isr * 2, 0, 1)
    local isr_2 = l_mathClamp((isr - 0.5) * 2, 0, 1)
    local jr_1 = 5 * l_mathClamp(0.2 - jr, 0, 0.2) -- Коэф. сколько пива выпил игрок
    local acv = self2.GetStatL(self, "Primary.Spread") or self2.GetStatL(self, "Primary.Accuracy")
    local recv = self2.GetStatL(self, "Primary.Recoil") * 5

    if dynacc then
      ccon = l_Lerp(isr_2 * jr_1, l_Lerp(isr_1, acv, acv * self2.GetStatL(self, "ChangeStateAccuracyMultiplier")), self2.GetStatL(self, "Primary.IronAccuracy"))
      crec = l_Lerp(isr_2, l_Lerp(isr_1, recv, recv * self2.GetStatL(self, "ChangeStateRecoilMultiplier")), recv * self2.GetStatL(self, "Primary.IronRecoilMultiplier"))
    else
      ccon = l_Lerp(isr * jr_1, acv, self2.GetStatL(self, "Primary.IronAccuracy"))
      crec = l_Lerp(isr, recv, recv * self2.GetStatL(self, "Primary.IronRecoilMultiplier"))
    end

    local crc_1 = l_mathClamp(self:GetCrouchingRatio() * 2, 0, 1)
    local crc_2 = l_mathClamp((self:GetCrouchingRatio() - 0.5) * 2, 0, 1)

    if dynacc then
      ccon = l_Lerp(crc_2, l_Lerp(crc_1, ccon, ccon * self2.GetStatL(self, "ChangeStateAccuracyMultiplier")), ccon * self2.GetStatL(self, "CrouchAccuracyMultiplier"))
      crec = l_Lerp(crc_2, l_Lerp(crc_1, crec, self2.GetStatL(self, "Primary.Recoil") * self2.GetStatL(self, "ChangeStateRecoilMultiplier")), crec * self2.GetStatL(self, "CrouchRecoilMultiplier"))
    end

    local owner = self:GetOwner()
    local isply = owner:IsPlayer()
    local ovel

    if IsValid(owner) then
      if owner:IsPlayer() then
        ovel = self:GetLastVelocity()
      else
        ovel = owner:GetVelocity():Length2D()
      end
    else
      ovel = 0
    end

    local vfc_1 = l_mathClamp(ovel / (isply and owner:GetWalkSpeed() or TFA.GUESS_NPC_WALKSPEED), 0, 2)

    if dynacc then
      ccon = l_Lerp(vfc_1, ccon, ccon * self2.GetStatL(self, "WalkAccuracyMultiplier"))
      crec = l_Lerp(vfc_1, crec, crec * self2.GetStatL(self, "WallRecoilMultiplier"))
    end


    if dynacc then
      ccon = l_Lerp(jr, ccon, ccon * self2.GetStatL(self, "JumpAccuracyMultiplier"))
      crec = l_Lerp(jr, crec, crec * self2.GetStatL(self, "JumpRecoilMultiplier"))
    end

    ccon = ccon * self:GetSpreadRatio()

    if mult_cvar then
      ccon = ccon * mult_cvar:GetFloat()
    end

    if not isply and IsValid(owner) then
      local prof = owner:GetCurrentWeaponProficiency()

      if prof == WEAPON_PROFICIENCY_POOR then
        ccon = ccon * 8
      elseif prof == WEAPON_PROFICIENCY_AVERAGE then
        ccon = ccon * 5
      elseif prof == WEAPON_PROFICIENCY_GOOD then
        ccon = ccon * 3
      elseif prof == WEAPON_PROFICIENCY_VERY_GOOD then
        ccon = ccon * 2
      elseif prof == WEAPON_PROFICIENCY_PERFECT then
        ccon = ccon * 1.5
      end
    end

    return ccon, crec
  end
end

fEmitSoundNet = function(self, sound)
  self:EmitSound(sound)
end

fStopSoundNet = function(self, sound)
  self:StopSound(sound)
end

hook.Add("PreRegisterSWEP", "TFA::CutSH", function(SWEP, sClass)
  if sClass == "tfa_gun_base" then
    SWEP.CanJam = false
    SWEP.UpdateProjectedTextures = fNullish
    SWEP.UpdateJamFactor = fNullish
    SWEP.ComputeBulletDeviation = fComputeBulletDeviation
    SWEP.CalculateConeRecoil = fCalculateConeRecoil
    SWEP.EmitSoundNet = fEmitSoundNet
    SWEP.StopSoundNet = fStopSoundNet
  end
end)
hook.Add("TFA_MakeShell", "TFA::CutSH", function()
  return false
end)

hook.Add("TFABase_PreEarlyInit", "TFA::CutSH", function()
  TFA.Attachments = TFA.Attachments or {}
  TFA.Attachments.Atts = {}
end)

hook.Add("TFABase_LateInit", "TFA::CutSH", function()
  hook.Remove("StartCommand", "TFABashZoom")
  hook.Remove("HUDShouldDraw", "tfa_hidehud")
  hook.Remove("PreDrawOpaqueRenderables", "tfaweaponspredrawopaque")
  hook.Remove("NotifyShouldTransmit", "TFA_AttachmentsRequest")
  hook.Remove("NetworkEntityCreated", "TFA_AttachmentsRequest")
  hook.Remove("OnEntityCreated", "TFA_AttachmentsRequest")
  hook.Remove("PlayerFootstep", "TFAWalkcycle")
  hook.Remove("Tick", "TFAInspectionScreenClicker")

  mult_cvar = GetConVar("sv_tfa_spread_multiplier")
  dynacc_cvar = GetConVar("sv_tfa_dynamicaccuracy")
end)
