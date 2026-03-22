local meta = FindMetaTable("Entity")
netstream.Hook("npc_open", function(npc)
	if npc.OnOpen then
		npc:OnOpen()
	elseif npc.npcJobType then
		OpenJob(npc.npcJobType)
	end
end)

function meta:aUse(arg)
	netstream.Start("NPC.aUse", self, arg)
end

function meta:Robbery(arg)
	netstream.Start("NPC.Robbery", self)
end
