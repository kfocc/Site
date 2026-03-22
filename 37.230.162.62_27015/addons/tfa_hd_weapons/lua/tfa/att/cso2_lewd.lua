if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Lewd Handling"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["+"], "Using the gun will now give you an erection", TFA.AttachmentColors["-"], "It's hard to play one handed" }
ATTACHMENT.Icon = "entities/tfa_cso2_lewd.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "LEWD"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = Sound("tfa_cso2_awptan.1"),
		["Sound_Silenced"] = Sound("tfa_cso2_awptan.1")
	}
}

function ATTACHMENT:Attach(wep)
	wep.Silenced = true
	wep:SetSilenced(true)
end

function ATTACHMENT:Detach(wep)
	wep.Silenced = false
	wep:SetSilenced(false)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
