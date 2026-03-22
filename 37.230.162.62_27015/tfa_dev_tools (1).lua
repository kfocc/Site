		local rshift = bit.rshift
		local band = bit.band
		return function(state)
			return band(rshift(state, 0), 1) == 0 and 0 or 1, band(rshift(state, 1), 1) == 0 and 0 or 1		end
	