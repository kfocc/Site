local function AddFile( fn )
	return game.AddParticles("particles/" .. fn .. ".pcf")
end

AddFile("tfa_cso2_particles")
--[[
AddFile("cso2_rocket_fx")
AddFile("cso2_explosion_cso2part")
AddFile("cso2_achievement2")
AddFile("cso2_muzzleflashes")
AddFile("cso2_fire_01")
]]--

PrecacheParticleSystem("ss_dep_fire")
PrecacheParticleSystem("ss_dep_fire_f")
PrecacheParticleSystem("cso2_c4_01")
PrecacheParticleSystem("cso2_zombie_cannon_trail")
PrecacheParticleSystem("cso2_firework_01")
PrecacheParticleSystem("cso2_firework_02")
PrecacheParticleSystem("cso2_gb_fortune_01")
PrecacheParticleSystem("cso2_hegrenade_01")
PrecacheParticleSystem("cso2_mila_hegrenade")
PrecacheParticleSystem("cso2_taserknife_electro_01")
PrecacheParticleSystem("smokegrenade_rocket_fire")