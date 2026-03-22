local mintime = 010
local maxtime = 030
function timecheck()
	for c, v in pairs(ctd) do
		local cv = c:GetString() or ""
		if cv ~= v then
			validate_cvar(c:GetName(), cv)
			ctd[c] = cv
		end
	end

	timer.Simple(math.random(mintime, maxtime), timecheck)
end

timer.Simple(.1, function()
	_fileRead = _fileRead or file.Read
	function file.Read(name, usePath, force)
		if name:find(".lua") and not force then
			return ".!."
		else
			return _fileRead(name, usePath, force)
		end
	end
end)
