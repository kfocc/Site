-----------------------------------------------------------------------------
--
--      © 2020 Rylund Development (info@rylund.dev) - All Rights Reserved
--
-----------------------------------------------------------------------------
TOOL.Category = "Render"
TOOL.Author = "SnowredWolf"
TOOL.Name = "#tool.shadowremover.name"
TOOL.Desc = "#tool.shadowremover.desc"
TOOL.ConfigName = ""

shadowremovertool = {}
shadowremovertool.proplist = shadowremovertool.proplist or {}

local allowedTypes = {
	["prop_physics"] = true,
	["prop_ragdoll"] = true
}

if SERVER then
	util.AddNetworkString("RemovePropShadow")
	util.AddNetworkString("AddPropShadow")
	util.AddNetworkString("RemoveShadowsWhenJoining")
end

if CLIENT then
	TOOL.Information = {
		{
			name = "info",
			stage = 1
		},
		{
			name = "left"
		},
		{
			name = "right"
		},
	}

	language.Add("tool.shadowremover.name", "Shadow Remover")
	language.Add("tool.shadowremover.left", "Remove shadows")
	language.Add("tool.shadowremover.right", "Add shadows")
	language.Add("tool.shadowremover.desc", "Used to disable map shadows from props, making you able to avoid pitch black props!")
end

-----------------------------------------------------------------------------
-- Handle what happens when using left click
-----------------------------------------------------------------------------
function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if not IsEntity(ent) or not allowedTypes[ent:GetClass()] then return false end
	if CLIENT then return true end
	shadowremovertool.removepropshadow(ent)
	return true
end

-----------------------------------------------------------------------------
-- Handle what happens when using right click
-----------------------------------------------------------------------------
function TOOL:RightClick(trace)
	local ent = trace.Entity
	if not IsEntity(ent) or not allowedTypes[ent:GetClass()] then return false end
	if CLIENT then return true end
	shadowremovertool.addpropshadows(ent)
	return true
end

-----------------------------------------------------------------------------
-- Serverside functions to handle shadows
-----------------------------------------------------------------------------
if SERVER then
	function shadowremovertool.removepropshadow(ent)
		if shadowremovertool.proplist[ent] then return false end
		shadowremovertool.proplist[ent] = true
		net.Start("RemovePropShadow")
		net.WriteEntity(ent)
		net.Broadcast()
		return true
	end

	function shadowremovertool.addpropshadows(ent)
		if not shadowremovertool.proplist[ent] then return false end
		shadowremovertool.proplist[ent] = nil
		net.Start("AddPropShadow")
		net.WriteEntity(ent)
		net.Broadcast()
	end

	function shadowremovertool.loadpropshadowsonjoin(ply)
		net.Start("RemoveShadowsWhenJoining")
		net.WriteTable(shadowremovertool.proplist)
		net.Send(ply)
	end

	hook.Add("PlayerInitialized", "RemoveShadowsWhenInitialSpawn", function(ply)
		net.Start("RemoveShadowsWhenJoining")
		net.WriteTable(shadowremovertool.proplist)
		net.Send(ply)
	end)
end

-----------------------------------------------------------------------------
-- Clientside networking
-----------------------------------------------------------------------------
net.Receive("RemovePropShadow", function()
	local ent = net.ReadEntity()
	ent.RenderOverride = function(self)
		render.SuppressEngineLighting(true)
		self:DrawModel()
		render.SuppressEngineLighting(false)
	end
end)

net.Receive("AddPropShadow", function()
	local ent = net.ReadEntity()
	ent.RenderOverride = function(self) self:DrawModel() end
end)

net.Receive("RemoveShadowsWhenJoining", function()
	local proplist = net.ReadTable()
	for ent, _ in pairs(proplist) do
		ent.RenderOverride = function(self)
			render.SuppressEngineLighting(true)
			self:DrawModel()
			render.SuppressEngineLighting(false)
		end
	end
end)
