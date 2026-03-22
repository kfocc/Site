TOOL.Category = "Half-Life 2"
TOOL.Name = "Spawn container"

TOOL.ClientConVar["model"] = "models/props_junk/cardboard_box001a.mdl"
TOOL.ClientConVar["slots"] = "10"
TOOL.ClientConVar["cooldown"] = "600"
TOOL.ClientConVar["lootid"] = "none"
TOOL.ClientConVar["clear_on_respawn"] = "0"
TOOL.ClientConVar["craft"] = "0"

TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	}
}

if CLIENT then
	language.Add("tool.spawn_container.name", "Spawn container")
	language.Add("tool.spawn_container.model", "Модель контейнера.")
	language.Add("tool.spawn_container.slots", "Количество слотов в контейнере.")
	language.Add("tool.spawn_container.cooldown", "КД респавна лута.")
	language.Add("tool.spawn_container.lootid", "ID категории лута.")
	language.Add("tool.spawn_container.clear_on_respawn", "Очищать контейнер при респавне лута.")
	language.Add("tool.spawn_container.craft", "Верстак")
	language.Add("tool.spawn_container.desc", "Спавнит контейнер на позиции прицела.")
	language.Add("tool.spawn_container.left", "ЛКМ: Заспавнить контейнер на прицеле с указанной моделью.")
	language.Add("tool.spawn_container.right", "ПКМ: Удалить созданный контейнер и из БД.")
end

function TOOL:LeftClick(trace)
	if not IsFirstTimePredicted() then return end
	if CLIENT then return true end
	local ent = ents.Create("container")
	ent.containerModel = self:GetClientInfo("model")
	ent.storageSlots = tonumber(self:GetClientNumber("slots"))
	ent.respawnCooldown = tonumber(self:GetClientNumber("cooldown"))
	ent.lootCategory = self:GetClientInfo("lootid")
	ent.clearOnRespawn = tobool(self:GetClientNumber("clear_on_respawn"))
	ent:Setcraft(tobool(self:GetClientInfo("craft")))
	ent:SetPos(trace.HitPos)
	ent:Spawn()
	ent:Activate()
	ent:EnableMotion(false)
	ent:CPPISetOwner(self:GetOwner())
	undo.Create("container")
	undo.AddEntity(ent)
	undo.SetPlayer(self:GetOwner())
	undo.Finish()
	return true
end

function TOOL:RightClick(trace)
	if not IsFirstTimePredicted() then return end
	if CLIENT then return true end
	local ent = trace.Entity
	if not IsValid(ent) or ent:GetClass() ~= "container" then return true end
	ent:Remove()
	return true
end

function TOOL:Reload(trace)
	return true
end

function TOOL.BuildCPanel(panel)
	panel:TextEntry("#tool.spawn_container.model", "spawn_container_model")
	panel:TextEntry("#tool.spawn_container.slots", "spawn_container_slots")
	panel:TextEntry("#tool.spawn_container.cooldown", "spawn_container_cooldown")
	panel:TextEntry("#tool.spawn_container.lootid", "spawn_container_lootid")
	panel:CheckBox("#tool.spawn_container.clear_on_respawn", "spawn_container_clear_on_respawn")
	panel:CheckBox("#tool.spawn_container.craft", "spawn_container_craft")
end

hook.Add("CanTool", "!!Spawncontainer", function(ply, tr, toolname, tool, button) if toolname == "spawn_container" and not ply:IsSuperAdmin() then return false end end)
