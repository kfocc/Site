TOOL.Category = "Half-Life 2"
TOOL.Name = "Spawn campfire"

TOOL.ClientConVar["model"] = "models/props_c17/oildrum001.mdl"
TOOL.ClientConVar["active"] = "0"

TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	}
}

if CLIENT then
	language.Add("tool.spawn_campfire.name", "Spawn campfire")
	language.Add("tool.spawn_campfire.desc", "Спавнит костер на позиции прицела.")
	language.Add("tool.spawn_campfire.left", "ЛКМ: Заспавнить костёр на прицеле с указанной моделью.")
	language.Add("tool.spawn_campfire.right", "ПКМ: Удалить созданный костёр и из БД.")
end

function TOOL:LeftClick(trace)
	if not IsFirstTimePredicted() then return end
	if CLIENT then return true end
	local ent = ents.Create("campfire")
	ent.campfireModel = self:GetClientInfo("model")
	ent.isActive = tobool(self:GetClientInfo("active"))
	ent:SetPos(trace.HitPos)
	ent:Spawn()
	ent:Activate()
	ent:EnableMotion(false)
	ent:CPPISetOwner(self:GetOwner())
	undo.Create("campfire")
	undo.AddEntity(ent)
	undo.SetPlayer(self:GetOwner())
	undo.Finish()
	return true
end

function TOOL:RightClick(trace)
	if not IsFirstTimePredicted() then return end
	if CLIENT then return true end
	local ent = trace.Entity
	if not IsValid(ent) or ent:GetClass() ~= "campfire" then return true end
	ent:Remove()
	return true
end

function TOOL:Reload(trace)
	return true
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", {
		Description = "#tool.spawn_campfire.desc"
	})

	panel:AddControl("TextBox", {
		Label = "Модель для костра",
		Command = "spawn_campfire_model"
	})

	panel:AddControl("CheckBox", {
		Label = "Включен ли костер при спавне?",
		Command = "spawn_campfire_active"
	})
end

hook.Add("CanTool", "!!SpawnCampfire", function(ply, tr, toolname, tool, button) if toolname == "spawn_campfire" and not ply:IsSuperAdmin() then return false end end)
