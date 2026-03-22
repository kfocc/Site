ENT.Type = "anim"
ENT.PrintName = "Новое силовое поле"
ENT.Category = "Альянс"

ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Entity", 0, "Dummy")
	self:NetworkVar("Bool", 0, "Hacked")
	self:NetworkVar("Bool", 1, "Unsafe")
	self:NetworkVar("Bool", 2, "OpenOnSpawn")
	self:NetworkVar("Bool", 3, "OpenOnCode")
	self:NetworkVar("Bool", 4, "OnlyCmd")
end

function ENT:TestCollision(a, b, c, d, mask)
	-- MASK_DEADSOLID	65547	Anything that blocks corpse movement
	-- MASK_NPCWORLDSTATIC	131083	The world entity
	-- MASK_PLAYERSOLID_BRUSHONLY	81931	World + Brushes + Player Clips
	-- test(100745227, "use")
	-- test(1107312651, "use toggle")
	-- test(1174421507, "shot")
	-- test(33636363, "collision")
	-- test(33701899, "npc")
	if bit.band(mask, CONTENTS_MOVEABLE + CONTENTS_PLAYERCLIP + CONTENTS_MONSTERCLIP) >= CONTENTS_MOVEABLE + CONTENTS_PLAYERCLIP or bit.band(mask, CONTENTS_GRATE) > 0 then return true end
end
