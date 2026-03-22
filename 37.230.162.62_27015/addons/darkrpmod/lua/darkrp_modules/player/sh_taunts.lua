local list = {}
-- ACT_GMOD_GESTURE_TAUNT_ZOMBIE
-- ACT_GMOD_TAUNT_DANCE
-- ACT_GMOD_TAUNT_ROBOT
-- ACT_GMOD_TAUNT_SALUTE
-- ACT_GMOD_TAUNT_PERSISTENCE
-- ACT_GMOD_TAUNT_MUSCLE
-- ACT_GMOD_TAUNT_LAUGH
-- ACT_GMOD_TAUNT_CHEER
local function LoadList()
	list = {
		{
			{
				name = "Руки вверх",
				anim = UAnim.ANIMATION_SURRENDER
			},
			-- Анимация из модуля anims
			{
				name = "Салютовать",
				anim = UAnim.ANIMATION_SALUTE
			},
			-- Анимация из модуля anims
			{
				name = "Дэб",
				anim = UAnim.ANIMATION_DAB
			},
			-- Анимация из модуля anims
			{
				name = "Руки за спину",
				anim = UAnim.ANIMATION_CROSSARMS
			},
			-- Анимация из модуля anims
			{
				name = "Осмотр",
				anim = UAnim.ANIMATION_LOOKUP
			},
			-- Анимация из модуля anims
			{
				name = "Показать пальцем",
				anim = UAnim.ANIMATION_POINT,
				time = 3
			},
			-- Анимация из модуля anims
			{
				name = "Поднять руку",
				anim = UAnim.ANIMATION_HIGHFIVE,
				time = 3
			}
		},
		-- Анимация из модуля anims
		{
			{
				act = "taunt_dance_base",
				name = "Танец",
				console = "dance",
				taunt = ACT_GMOD_TAUNT_DANCE,
				icon = "icon16/tag_red.png"
			},
			{
				act = "taunt_muscle_base",
				name = "Распутный танец",
				console = "muscle",
				taunt = ACT_GMOD_TAUNT_MUSCLE,
				icon = "icon16/tag_red.png"
			},
			{
				act = "taunt_robot_base",
				name = "Танец робота",
				console = "robot",
				taunt = ACT_GMOD_TAUNT_ROBOT,
				icon = "icon16/tag_red.png"
			}
		},
		{
			{
				act = "gesture_wave_original",
				name = "Помахать",
				console = "wave",
				taunt = ACT_GMOD_GESTURE_WAVE,
				icon = "icon16/tag_orange.png"
			},
			{
				act = "gesture_salute_original",
				name = "Отдать честь",
				console = "salute",
				taunt = ACT_GMOD_TAUNT_SALUTE,
				icon = "icon16/tag_orange.png"
			},
			{
				act = "gesture_bow_original",
				name = "Поклон",
				console = "bow",
				taunt = ACT_GMOD_GESTURE_BOW,
				icon = "icon16/tag_orange.png"
			},
			{
				act = "gesture_becon_original",
				name = "Позвать",
				console = "becon",
				taunt = ACT_GMOD_GESTURE_BECON,
				icon = "icon16/tag_orange.png"
			}
		},
		{
			{
				act = "taunt_zombie_original",
				name = "Имитация зомби",
				console = "zombie",
				taunt = ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
				icon = "icon16/tag_yellow.png"
			},
			{
				act = "taunt_laugh_base",
				name = "Смех",
				console = "laugh",
				taunt = ACT_GMOD_TAUNT_LAUGH,
				icon = "icon16/tag_yellow.png"
			},
			{
				act = "taunt_persistence_base",
				name = "Лев",
				console = "pers",
				taunt = ACT_GMOD_TAUNT_PERSISTENCE,
				icon = "icon16/tag_yellow.png"
			},
			{
				act = "taunt_cheer_base",
				name = "Радость",
				console = "cheer",
				taunt = ACT_GMOD_TAUNT_CHEER,
				icon = "icon16/tag_yellow.png"
			}
		},
		{
			{
				act = "gesture_agree_original",
				name = "Согласен",
				console = "agree",
				taunt = ACT_GMOD_GESTURE_AGREE,
				icon = "icon16/tag_green.png"
			},
			{
				act = "gesture_disagree_original",
				name = "Не согласен",
				console = "disagree",
				taunt = ACT_GMOD_GESTURE_DISAGREE,
				icon = "icon16/tag_green.png"
			}
		},
		{
			{
				act = "gesture_signal_halt_original",
				name = "Приказ - остановиться",
				console = "halt",
				taunt = ACT_SIGNAL_HALT,
				icon = "icon16/tag_purple.png"
			},
			{
				act = "gesture_signal_group_original",
				name = "Приказ - сгруппироваться",
				console = "group",
				taunt = ACT_SIGNAL_GROUP,
				icon = "icon16/tag_purple.png"
			},
			{
				act = "gesture_signal_forward_original",
				name = "Приказ - вперёд",
				console = "forward",
				taunt = ACT_SIGNAL_FORWARD,
				icon = "icon16/tag_purple.png"
			}
		}
	}
end

if UAnim then LoadList() end
hook.Add("UAnim.Initialed", "LoadTaunts", LoadList)
if SERVER then
	local function ResetAnim(ply)
		if not IsValid(ply) then return end
		if not ply.Taunted then return end
		if timer.Exists("taunt_" .. tostring(ply)) then timer.Remove("taunt_" .. tostring(ply)) end
		if ply.LuaAnim then
			ply:resetBoneAngles()
			ply:SetNetVar("IgnoreIsTalking", nil)
			ply.LuaAnim = nil
		end

		ply:DoAnimationEvent(0)
		ply.LuaAnim = nil
		ply.Taunted = nil
	end

	local TauntsTryingSwitchWeapon = false -- Может вызвать проблемы, но по сути не должно.
	netstream.Hook("SendTaunt", function(ply, cur, ang, time, num, anim_name, tk)
		if not ply:Alive() then return end
		if ply.Taunted or ply.animationIndex or ply.LuaAnim then return end
		if ply:IsHandcuffed() then return end
		local animData = list[tk]
		animData = animData and animData[num]
		if not animData then return end
		local useEntity = ply:GetUseEntity()
		if IsValid(useEntity) then DropEntityIfHeld(useEntity) end
		local can, reason = hook.Run("PlayerCanTaunt", ply, anim_name)
		if can == false then
			DarkRP.notify(ply, 0, 4, reason or "Вы не можете использовать эту анимацию")
			return
		end

		local keys = ply:HasWeapon("keys")
		if keys then
			TauntsTryingSwitchWeapon = true
			ply:SelectWeapon("keys")
			TauntsTryingSwitchWeapon = false
		end

		if cur == 1 then
			ply.Taunted = true
			ply:SetEyeAngles(ang)
			if animData.taunt then ply:DoAnimationEvent(animData.taunt) end
			timer.Create("taunt_" .. tostring(ply), time, 1, function() ResetAnim(ply) end)
		elseif cur == 2 then
			if not num or not list[1][num] then return end
			ply.Taunted = true
			ply:executeAnimation(list[1][num].anim)
			ply.LuaAnim = true
			ply:SetNetVar("IgnoreIsTalking", true)
			if time then timer.Create("taunt_" .. tostring(ply), time, 1, function() ResetAnim(ply) end) end
		end
	end)

	netstream.Hook("StopTaunt", ResetAnim)
	hook.Add("TFA_PreHolster", "LuaAnim", function(wep) if TauntsTryingSwitchWeapon then return true end end)
	hook.Add("OnHandcuffed", "LuaAnim", function(ply, target)
		ResetAnim(target)
		if ply:HasWeapon("weapon_handcuffed") and ply:GetActiveWeapon():GetClass() ~= "weapon_handcuffed" then
			ply:SelectWeapon("weapon_handcuffed")
		end
	end)
end

hook.Add("PlayerShouldTaunt", "DrawTaunt", function(ply) return false end)
hook.Add("PlayerSwitchWeapon", "NoBagouse", function(ply) if ply.Taunted then return true end end)
function GetTauntList()
	return list
end

if SERVER then return end
hook.Add("CreateMove", "DisableRoaming", function(cmd)
	local lp = LocalPlayer()
	if lp.TauntCamera then return lp.TauntCamera:CreateMove(cmd, lp, lp.Taunted) end
end)

hook.Add("CalcView", "DisableRoaming", function(ply, pos, ang, fov)
	if ply.TauntCamera then
		local view = {
			origin = pos,
			angles = ang,
			drawviewer = true
		}
		return ply.TauntCamera:CalcView(view, ply, ply.Taunted)
	end
end)

local binds = {
	["+moveright"] = true,
	["+moveleft"] = true,
	["+forward"] = true,
	["+back"] = true,
	["+duck"] = true,
	["+jump"] = true,
	["+use"] = true
}

hook.Add("PlayerBindPress", "DisableRoaming", function(pl, bind)
	local lp = LocalPlayer()
	if not lp.Taunted then return end
	if not binds[bind] then return end
	lp.Taunted = nil
	lp.TauntCamera = nil
	lp.LuaAnim = nil
	netstream.Start("StopTaunt")
	-- return true
end)

-- hook.Add("PlayerSwitchWeapon", "DisableRoaming", function(pl)
-- 	local lp = LocalPlayer()
-- 	if not lp.Taunted then return end
-- 	lp.Taunted = nil
-- 	lp.TauntCamera = nil
-- 	lp.LuaAnim = nil
-- 	netstream.Start("StopTaunt")
-- 	-- return true
-- end)
function GonzoTauntCamera()
	local lp = LocalPlayer()
	if IsValid(lp:GetObserverTarget()) then return end
	local CAM = {}
	CAM.WasOn = false
	CAM.CustomAngles = lp:GetAngles()
	CAM.PlayerLockAngles = nil
	CAM.InLerp = 0
	CAM.OutLerp = 1
	--
	-- Draw the local player if we're active in any way
	--
	CAM.ShouldDrawLocalPlayer = function(self, ply, on) return on or self.OutLerp < 1 end
	--
	-- Implements the third person, rotation view (with lerping in/out)
	--
	CAM.CalcView = function(self, view, ply, on)
		if not ply:Alive() or not IsValid(ply:GetViewEntity()) or ply:GetViewEntity() ~= ply then return end
		if self.WasOn ~= on then
			if on then self.InLerp = 0 end
			if not on then self.OutLerp = 0 end
			self.WasOn = on
		end

		if not on and self.OutLerp >= 1 then
			self.CustomAngles = view.angles * 1
			self.PlayerLockAngles = nil
			self.InLerp = 0
			return
		end

		if self.PlayerLockAngles == nil then return end
		--
		-- Simple 3rd person camera
		--
		local TargetOrigin = view.origin - self.CustomAngles:Forward() * 100
		local tr = util.TraceHull({
			start = view.origin,
			endpos = TargetOrigin,
			mask = MASK_SHOT,
			filter = player.GetAll(),
			mins = Vector(-8, -8, -8),
			maxs = Vector(8, 8, 8)
		})

		TargetOrigin = tr.HitPos + tr.HitNormal
		if self.InLerp < 1 then
			self.InLerp = self.InLerp + FrameTime() * 5.0
			view.origin = LerpVector(self.InLerp, view.origin, TargetOrigin)
			view.angles = LerpAngle(self.InLerp, self.PlayerLockAngles, self.CustomAngles)
			return view
		end

		if self.OutLerp < 1 then
			self.OutLerp = self.OutLerp + FrameTime() * 3.0
			view.origin = LerpVector(1 - self.OutLerp, view.origin, TargetOrigin)
			view.angles = LerpAngle(1 - self.OutLerp, self.PlayerLockAngles, self.CustomAngles)
			return view
		end

		view.angles = self.CustomAngles * 1
		view.origin = TargetOrigin
		return view
	end

	--
	-- Freezes the player in position and uses the input from the user command to
	-- rotate the custom third person camera
	--
	CAM.CreateMove = function(self, cmd, ply, on)
		if not ply:Alive() then on = false end
		if not on then return end
		if self.PlayerLockAngles == nil then self.PlayerLockAngles = self.CustomAngles * 1 end
		--
		-- Rotate our view
		--
		self.CustomAngles.pitch = self.CustomAngles.pitch + cmd:GetMouseY() * 0.01
		self.CustomAngles.yaw = self.CustomAngles.yaw - cmd:GetMouseX() * 0.01
		--
		-- Lock the player's controls and angles
		--
		cmd:SetViewAngles(self.PlayerLockAngles)
		cmd:ClearButtons()
		cmd:ClearMovement()
		return true
	end
	return CAM
end

function StartTaunt(an, num, tk)
	local lp = LocalPlayer()
	if lp.Taunted then return end
	local can, reason = hook.Run("PlayerCanTaunt", lp, an.name)
	if can == false then
		notification.AddLegacy(reason or "Вы не можете использовать эту анимацию", NOTIFY_ERROR, 4)
		return
	end

	local cur = an.act and 1 or 2
	local tim, ang = an.time, EyeAngles()
	if cur == 1 then
		local i = lp:LookupSequence(an.act)
		tim = lp:SequenceDuration(i)
	else
		lp.LuaAnim = true
	end

	lp.Taunted = true
	lp.TauntCamera = GonzoTauntCamera()
	netstream.Start("SendTaunt", cur, ang, tim, num, an.name, tk)
	if tim then timer.Create("TauntCamera", tim, 1, function() lp.TauntCamera = nil end) end
end
