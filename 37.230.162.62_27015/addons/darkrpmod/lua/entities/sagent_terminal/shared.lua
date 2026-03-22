ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Терминал альянса для взлома"
ENT.Author = "Someone"
ENT.Spawnable = false
ENT.bNoPersist = true
function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "TerminalID")
end
