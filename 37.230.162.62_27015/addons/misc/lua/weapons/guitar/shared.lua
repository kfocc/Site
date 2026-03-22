if CLIENT then
    SWEP.ViewModelBoneMods = {}
    SWEP.WElements = {
        ["element_name"] = { type = "Model", model = "models/custom/guitar/m_d_45.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-16.42, 34.831, -4.919), angle = Angle(-82.644, 60.391, -0.542), size = Vector(0.995, 0.995, 0.995), color = Color(255, 255, 254, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
    }
end

SWEP.PrintName = "Гитара"
SWEP.Slot = 5
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author = "UnionRP"
SWEP.Purpose = ""
SWEP.Instructions = "R: Сменить песню"
SWEP.Category = "UnionRP"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/tayley/v_guitar.mdl"
SWEP.WorldModel = "models/custom/guitar/m_d_45.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.Songs = {
    {sound = "weapons/Guitar/1.mp3", name = "Triage at Dawn"}, -- ОСТАВИТЬ
    {sound = "weapons/Guitar/2.mp3", name = "The Last of Us"},
    {sound = "weapons/Guitar/3.mp3", name = "He's a Pirate"},
    {sound = "weapons/Guitar/4.mp3", name = "Tobias Rauscher"},
    {sound = "weapons/Guitar/5.mp3", name = "Faded"},
    {sound = "weapons/Guitar/6.mp3", name = "Stalker"},
    {sound = "weapons/Guitar/7.mp3", name = "Metro"},
    {sound = "weapons/Guitar/8.mp3", name = "Sail"},
    {sound = "weapons/Guitar/9.mp3", name = "Sora Ni Utaeba"},
    {sound = "weapons/Guitar/10.mp3", name = "Californication"}, -- ОСТАВИТЬ
    {sound = "weapons/Guitar/11.mp3", name = "Axel F"},
    --{sound = "weapons/Guitar/12.mp3", name = ""},
    --{sound = "weapons/Guitar/13.mp3", name = ""},
    {sound = "weapons/Guitar/14.mp3", name = "Radioactive"}, -- ОСТАВИТЬ
    {sound = "weapons/Guitar/15.mp3", name = "Blue Christmas"},
    {sound = "weapons/Guitar/16.mp3", name = "Numb"},
    {sound = "weapons/Guitar/17.mp3", name = "Demons"},
    --{sound = "weapons/Guitar/18.mp3", name = ""},
    {sound = "weapons/Guitar/19.mp3", name = "Boulevard of Broken Dreams"}, -- ОСТАВИТЬ
    {sound = "weapons/Guitar/20.mp3", name = "When I see you again"},
}

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Song")
end

function SWEP:Deploy()
	self:SetHoldType("slam")
end

function SWEP:Stop()
	local last = self.last_song
	if last then
		self:StopSound(last)
		self.last_song = nil
	end
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return true end
	self:Stop()
	self:SetNextPrimaryFire(CurTime() + 1)

	local song = self:GetSong()

	local song_info = self.Songs[song]
	local audio = song_info.sound

    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self:EmitSound(audio, 70, 100)
	self.last_song = audio

	return true
end

function SWEP:SecondaryAttack()
	self:Stop()
	return true
end

function SWEP:Holster()
	self:Stop()
	return true
end

function SWEP:OnRemove()
	self:Holster()
end