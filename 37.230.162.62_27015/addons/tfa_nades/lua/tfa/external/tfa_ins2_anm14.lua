local path = "weapons/anm14/"
local pref = "Weapon_ANM14"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".PinPull", path .. "rgo_pinpull.wav")
TFA.AddWeaponSound(pref .. ".ArmThrow", path .. "rgo_throw.wav")
TFA.AddWeaponSound(pref .. ".ArmDraw", path .. "rgo_armdraw.wav")

sound.Add(
{
    name = "ANM14Incendiary.Burn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = SNDLVL_GUNFIRE,
    sound = "weapons/anm14/AN_M14_burn.wav"
})

sound.Add(
{
    name = "ANM14Incendiary.Bounce",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/anm14/AN_M14_bounce_0"..math.random( 1, 3 )..".wav"
})

if killicon and killicon.Add then
	killicon.Add("tfa_ins2_anm14", "vgui/hud/tfa_ins2_anm14", hudcolor)
    killicon.Add("ent_insurgencyanm14_tfa", "vgui/hud/tfa_ins2_anm14", hudcolor)
end