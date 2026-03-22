ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Кровать"
ENT.Author = "Google"
ENT.Category = "UnionRP"
ENT.Spawnable = false

if CLIENT then
	ENT.boneAngles = {
		{"ValveBiped.Bip01_L_Clavicle", Angle(0, -10, 0)},
		{"ValveBiped.Bip01_L_UpperArm", Angle(15, -35, -5)},
		{"ValveBiped.Bip01_L_Forearm", Angle(32, -137, -95)},
		{"ValveBiped.Bip01_L_Hand", Angle(5, -20, -5)},
		{"ValveBiped.Bip01_R_Forearm", Angle(-45, -120, 45)},
		{"ValveBiped.Bip01_R_Hand", Angle(0, -10, 5)},
		{"ValveBiped.Bip01_L_Thigh", Angle(0, -35, -15)},
		{"ValveBiped.Bip01_L_Calf", Angle(0, 100, -15)},
		{"ValveBiped.Bip01_L_Foot", Angle(0, -5, 15)},
	}
end

if SERVER then
	function ENT:SetUser(bedUser)
		self:SetNetVar("bed.User", bedUser)
	end

	function ENT:ResetUser()
		self:SetNetVar("bed.User", nil)
	end

	function ENT:SetRagdollInfo(bedUserModel, bedUserSkin, bedUserBodygroups)
		local info = {
			model = bedUserModel,
			skin = bedUserSkin,
			bodygroups = bedUserBodygroups
		}

		self:SetNetVar("bed.RagdollInfo", info)
	end

	function ENT:ResetRagdollInfo()
		self:SetNetVar("bed.RagdollInfo", nil)
	end
end

function ENT:GetUser()
	return self:GetNetVar("bed.User")
end

function ENT:GetRagdollInfo()
	return self:GetNetVar("bed.RagdollInfo")
end

function ENT:IsBusy()
	return IsValid(self:GetUser())
end
