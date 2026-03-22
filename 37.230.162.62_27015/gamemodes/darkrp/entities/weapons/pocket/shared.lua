AddCSLuaFile()

if SERVER then
  AddCSLuaFile("cl_menu.lua")
  include("sv_init.lua")
end

if CLIENT then include("cl_menu.lua") end


SWEP.PrintName = "Сумка"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Положить предмет в сумку\nПКМ: Выложить последний предмет\nПерезарядка: Посмотреть содержимое сумки"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPPocket = true

SWEP.IconLetter = ""

SWEP.AnimPrefix = "rpg"
SWEP.HoldType			= "none"
SWEP.ViewModel = "models/weapons/c_nsuitcase.mdl"
SWEP.WorldModel = "models/weapons/w_nsuitcase.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands			= true

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "DarkRP (Utility)"
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

function SWEP:PrimaryAttack()
  self:SetNextPrimaryFire(CurTime() + 0.2)

  if not SERVER then return end

  local owner = self:GetOwner()
  local ent = owner:GetEyeTrace().Entity
  if not IsValid(ent) then return end
  if ent:GetPos():Distance(self:GetPos()) > 256 then
    DarkRP.notify(owner, 1, 4, "Предмет слишком далеко")
    return
  end

  -- if not ent.pickup then return end
  local canPickup, message = hook.Run("canPocketLimit", owner, ent)
  if not canPickup then
    if message then DarkRP.notify(owner, 1, 4, message) end
    return
  end

  owner:addPocketItem(ent)
end

function SWEP:SecondaryAttack()
  if not SERVER then return end
  local owner = self:GetOwner()

  local maxK = 0
  for k, v in pairs(owner:getPocketItems()) do
    if k < maxK then continue end
    maxK = k
  end

  if maxK == 0 then
    DarkRP.notify(owner, 1, 4, DarkRP.getPhrase("pocket_no_items"))
    return
  end

  if SERVER then
    local pocket = Storage.GetPocketTable(self:GetOwner())
    local canPickup, message = hook.Call("canDropPocketItem", nil, owner, maxK, pocket[maxK])
    if canPickup == false then
      if message then DarkRP.notify(owner, 1, 4, message) end
      return
    end
  end

  owner:dropPocketItem(maxK)
end

function SWEP:Reload()
  if not CLIENT then return end
  DarkRP.openPocketMenu()
end

function SWEP:TranslateActivity(act)
  return -1
end

local meta = FindMetaTable("Player")
DarkRP.stub{
  name = "getPocketItems",
  description = "Get a player's pocket items.",
  parameters = {},
  returns = {
    {
      name = "items",
      description = "A table containing crucial information about the items in the pocket.",
      type = "table"
    }
  },
  metatable = meta,
  realm = "Shared"
}