ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Записка"
ENT.ShowName = "ЗАПИСКА"
ENT.Author = ""
ENT.IsPaper = true

ENT.Spawnable = true
ENT.Category = "UnionRP"

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true
ENT.DoNotDuplicate = true

ENT.maxTitleLength = 40
ENT.maxTextLength = 2048
ENT.mdl = Model("models/props_office/notepad_office.mdl")
ENT.docType = "note"
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Extended")
	self:NetworkVar("String", 0, "Title")
	self:NetworkVar("Entity", 1, "owning_ent")
	self:NetworkVar("Int", 0, "LastUpdate")
	if SERVER then self:NetworkVarNotify("owning_ent", self.OnVarChanged) end
end

function ENT:GetPOwner()
	return self:Getowning_ent()
end

function ENT:SetPOwner(ply)
	return self:Setowning_ent(ply)
end

function ENT:GetText()
	return self:GetNetVar("paper.Text", "")
end

function ENT:GetSignedData()
	return self:GetNetVar("paper.SignedData")
end

if SERVER then
	function ENT:SetText(text)
		return self:SetNetVar("paper.Text", text)
	end

	function ENT:SetSignedData(plyName, plyJob, jobColor)
		return self:SetNetVar("paper.SignedData", {
			name = plyName,
			job = plyJob,
			jobColor = jobColor
		})
	end
end
