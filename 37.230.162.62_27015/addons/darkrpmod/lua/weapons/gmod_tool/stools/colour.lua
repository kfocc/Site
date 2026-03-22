TOOL.Category = "Render"
TOOL.Name = "#tool.colour.name"
TOOL.ClientConVar["r"] = 255
TOOL.ClientConVar["g"] = 255
TOOL.ClientConVar["b"] = 255
TOOL.ClientConVar["a"] = 255
TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	},
	{
		name = "reload"
	}
}

local function SetColour(ply, ent, data)
	local colorData = data.Color
	colorData.a = 255
	if colorData then ent:SetColor(Color(colorData.r, colorData.g, colorData.b, colorData.a)) end
	if SERVER then duplicator.StoreEntityModifier(ent, "colour", data) end
end

duplicator.RegisterEntityModifier("colour", SetColour)
function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if IsValid(ent.AttachedEntity) then ent = ent.AttachedEntity end
	if not IsValid(ent) then -- The entity is valid and isn't worldspawn
		return false
	end

	if CLIENT then return true end
	local r = self:GetClientNumber("r", 0)
	local g = self:GetClientNumber("g", 0)
	local b = self:GetClientNumber("b", 0)
	SetColour(self:GetOwner(), ent, {
		Color = Color(r, g, b, 255),
	})
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
	if IsValid(ent.AttachedEntity) then ent = ent.AttachedEntity end
	if not IsValid(ent) then -- The entity is valid and isn't worldspawn
		return false
	end

	if CLIENT then return true end
	local clr = ent:GetColor()
	self:GetOwner():ConCommand("colour_r " .. clr.r)
	self:GetOwner():ConCommand("colour_g " .. clr.g)
	self:GetOwner():ConCommand("colour_b " .. clr.b)
	self:GetOwner():ConCommand("colour_a " .. 255)
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
	if IsValid(ent.AttachedEntity) then ent = ent.AttachedEntity end
	if not IsValid(ent) then -- The entity is valid and isn't worldspawn
		return false
	end

	if CLIENT then return true end
	SetColour(self:GetOwner(), ent, {
		Color = color_white
	})
	return true
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {
		Description = "#tool.colour.desc"
	})

	CPanel:ToolPresets("colour", ConVarsDefault)
	CPanel:ColorPicker("#tool.colour.color", "colour_r", "colour_g", "colour_b", "colour_a")
end
