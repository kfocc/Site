function string:IsEnglish()
	return #self:match("[a-zA-Z ]*") == #self
end

function string:IsRussian()
	return #self:match("[Ѐ-џ ]*") == #self
end

function string:IsGood()
	if not self:IsEnglish() and not self:IsRussian() then return end
	if self:IsEnglish() and self:IsRussian() then return end
	return true
end

function string:isTextScreenAllowed()
	return #self:match("[Ѐ-џ%-%(%)%w%p ]*") == #self
end
string.TextScreenAllowed = string.isTextScreenAllowed

function string:IsSteamID()
	return ULib.isValidSteamID(self) -- #(self:match("(STEAM_%d:%d:%d+)$") or "") == #self
end
string.IsSteamID32 = string.IsSteamID

function string:IsSteamID64()
	return #self == 17 and self:StartWith("7656")
end
