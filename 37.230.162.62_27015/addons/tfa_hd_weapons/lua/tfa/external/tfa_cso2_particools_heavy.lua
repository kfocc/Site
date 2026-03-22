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

PrecacheParticleSystem("ss_m3dragon_fire_f")
PrecacheParticleSystem("cso2_pkmfire_01")
PrecacheParticleSystem("cso2_pkmfire_02")