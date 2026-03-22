AddCSLuaFile()

if SERVER then
util.AddNetworkString("anim_keys")
util.AddNetworkString("knocking")
util.AddNetworkString("lock_door_keys")
util.AddNetworkString("KeysMenu")
    AddCSLuaFile("cl_menu.lua")
end
SWEP.PrintName = "Ключи"
if CLIENT then

    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false

    include("cl_menu.lua")
end

SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Закрыть дверь\nПКМ: Открыть дверь\nПерезарядка: Меню взаимодействия с дверью"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPKeys = true

SWEP.WorldModel = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "DarkRP (Utility)"
SWEP.Sound = "doors/door_latch1.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:ShouldDrawViewModel()
    return false
end

local function lookingAtLockable(ply, ent)
    local eyepos = ply:EyePos()
    return IsValid(ent)             and
        ent:isKeysOwnable()         and
        not ent:getKeysNonOwnable() and
        (
            ent:isDoor()    and eyepos:Distance(ent:GetPos()) < 65
            or
            ent:IsVehicle() and eyepos:Distance(ent:NearestPoint(eyepos)) < 100
            or
            ent.Container   and eyepos:Distance(ent:GetPos()) < 65
        )

end

local function lockUnlockAnimation(ply, snd)
    ply:EmitSound("npc/metropolice/gear" .. math.floor(math.Rand(1,7)) .. ".wav")
    timer.Simple(0.9, function() if IsValid(ply) then ply:EmitSound(snd) end end)

    ply:PlayAnim("LockUnlock")
end

local function doKnock(ply, sound)
    ply:EmitSound(sound, 100, math.random(90, 110))

    ply:PlayAnim("Knock")
end

function SWEP:PrimaryAttack()
    local trace = self:GetOwner():GetEyeTrace()

    if not lookingAtLockable(self:GetOwner(), trace.Entity) then return end

    self:SetNextPrimaryFire(CurTime() + 1.5)

    if CLIENT then return end

    if self:GetOwner():canKeysLock(trace.Entity) then
        trace.Entity:keysLock() -- Lock the door immediately so it won't annoy people
        lockUnlockAnimation(self:GetOwner(), self.Sound)
    elseif trace.Entity:IsVehicle() then
        DarkRP.notify(self:GetOwner(), 1, 3, DarkRP.getPhrase("do_not_own_ent"))
    else
        doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard4.wav")
    end
end

function SWEP:SecondaryAttack()
    local trace = self:GetOwner():GetEyeTrace()

    if not lookingAtLockable(self:GetOwner(), trace.Entity) then return end

    self:SetNextSecondaryFire(CurTime() + 1.5)

    if CLIENT then return end

    if self:GetOwner():canKeysUnlock(trace.Entity) then
        trace.Entity:keysUnLock() -- Unlock the door immediately so it won't annoy people
        lockUnlockAnimation(self:GetOwner(), self.Sound)
    elseif trace.Entity:IsVehicle() then
        DarkRP.notify(self:GetOwner(), 1, 3, DarkRP.getPhrase("do_not_own_ent"))
    else
        doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard3.wav")
    end
end

function SWEP:Reload()
    local trace = self:GetOwner():GetEyeTrace()
    if not IsValid(trace.Entity) or (IsValid(trace.Entity) and ((not trace.Entity:isDoor() and not trace.Entity:IsVehicle()) or self:GetOwner():EyePos():Distance(trace.HitPos) > 200)) then
        if CLIENT and not DarkRP.disabledDefaults["modules"]["animations"] then RunConsoleCommand("_DarkRP_AnimationMenu") end
        return
    end
    if SERVER then
            net.Start("KeysMenu")
        net.Send(self:GetOwner())
    end
end

local acts = {
    ["LockUnlock"] = ACT_GMOD_GESTURE_ITEM_PLACE,
    ["Knock"] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST
}

if CLIENT then
    netstream.Hook("KeysAnim", function(ply, id)
        if not IsValid(ply) then return end
        ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, acts[id] or id, true)
    end)
else
    local PLAYER = FindMetaTable("Player")
    function PLAYER:PlayAnim(anim)
        local rcp = RecipientFilter()
        rcp:AddPVS(self:GetPos())
        self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, acts[anim] or anim, true)
        netstream.Start(rcp, "KeysAnim", self, anim or anim)
    end
end