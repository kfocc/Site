AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.ExplodeSound = Sound("ANM14Incendiary.Burn")

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Initialize()
	self.KaboomTime = self.KaboomTime or CurTime() + 5
	if SERVER then
		self.Entity:SetModel( "models/weapons/w_anm14.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:DrawShadow( false )
		self:SetAngles( self:GetOwner():GetAngles() )
	end
end

function ENT:Think()
	if SERVER and self.KaboomTime <= CurTime() then
		self:Explode()
		self:Remove()
                self:EmitSound(self.ExplodeSound)
	end
end

function ENT:Explode()
if self.Entity:WaterLevel() > 0 then return end
for i = 1, 15 do
local pos = self.Entity:GetPos() + Vector( math.random( -128, 128 ), math.random( -128, 128 ), 0 )
for _, c in pairs( ents.FindInSphere( pos, 5 ) ) do
if c:GetClass() == "env_fire" then
return end
end
local fire = ents.Create( "env_fire" )
fire:SetPos( pos )
fire:SetKeyValue( "health", "999999" )
fire:SetKeyValue( "firesize", "64" )
fire:SetKeyValue( "damagescale", "25" )
fire:SetKeyValue( "spawnflags", "0" )
fire:SetOwner( self.Owner )
fire:Spawn()
fire:Fire( "StartFire", "", 0 )
timer.Simple( 25, function()
if fire:IsValid() then
fire:Remove()
end
end )
end	
for _, v in pairs( ents.FindInSphere( self.Entity:GetPos(), 100 ) ) do
if v:IsPlayer() or v:IsWorld() or v:IsWeapon() or not v:IsValid() then
return end
if string.find( v:GetClass(), "prop_" ) then
local phys = v:GetPhysicsObject()
if string.find( phys:GetMaterial(), "metal" ) then
return
end
end
end
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "ANM14Incendiary.Bounce" )
	end
end

