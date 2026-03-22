if CLIENT then
    surface.CreateFont("zck_font01", {
        font = "Arial",
        extended = false,
        size = ScreenScale(50),
        weight = ScreenScale(300),
    })
end

--[[
	PRECACHE PARTICLE
--]]
game.AddParticles("particles/zck_snowball.pcf")
PrecacheParticleSystem("zck_snowball_explode")
PrecacheParticleSystem("zck_snowball_pickup")
PrecacheParticleSystem("zck_snowball_trail")

sound.Add({
    name = "zck_snowball_impact",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_65dB,
    pitch = {98, 100},
    sound = {"weapons/snowball/snowball_impact01.wav", "weapons/snowball/snowball_impact02.wav"}
})

--[[
	PRECACHE SOUNDS
--]]
sound.Add({
    name = "zck_snowball_pickup",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_65dB,
    pitch = {98, 100},
    sound = {"weapons/snowball/zck_snowball_pickup01.wav", "weapons/snowball/zck_snowball_pickup02.wav", "weapons/snowball/zck_snowball_pickup03.wav", "weapons/snowball/zck_snowball_pickup04.wav", "weapons/snowball/zck_snowball_pickup05.wav"}
})

if SERVER then
    hook.Add("InitPostEntity", "precacheSound", function()
        local worldspawn = game.GetWorld()
        worldspawn:EmitSound("weapons/snowball/snowball_impact01.wav", 1, 100, 0)
        worldspawn:EmitSound("weapons/snowball/snowball_impact02.wav", 1, 100, 0)
    end)
end