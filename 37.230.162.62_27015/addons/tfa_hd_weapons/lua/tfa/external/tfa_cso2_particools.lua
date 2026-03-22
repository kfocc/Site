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

PrecacheParticleSystem("ss_ak47_fire_f")
PrecacheParticleSystem("ss_m4a1_fire_f")
PrecacheParticleSystem("cso2_galilsniper_tesla")