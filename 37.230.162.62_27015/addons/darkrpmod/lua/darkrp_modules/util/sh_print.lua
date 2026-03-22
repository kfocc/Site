function prt(a)
	PrintTable(a)
end

function PRINT(...)
	local count = select("#", ...)
	local args = {...}
	if count > 1 then
		PrintTable(args)
	else
		_G[istable(args[1]) and "prt" or "print"](...)
	end
end
