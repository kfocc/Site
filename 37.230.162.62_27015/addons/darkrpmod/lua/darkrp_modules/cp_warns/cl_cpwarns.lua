local cpWarn = cpWarn or {}
_G.cpWarn = cpWarn
cpWarn.list = cpWarn.list or {}

netstream.Hook("cpWarn.Sync.Warn", function(sid, row)
	cpWarn.list[sid] = row
end)

netstream.Hook("cpWarn.Sync.UnWarn", function(sid, row)
	cpWarn.list[sid] = row
end)

netstream.Hook("cpWarn.Sync.ResetWarns", function(sid)
	cpWarn.list[sid] = nil
end)

netstream.Hook("cpWarn.Sync.AllWarns", function(list)
	table.Merge(cpWarn.list, list)
end)