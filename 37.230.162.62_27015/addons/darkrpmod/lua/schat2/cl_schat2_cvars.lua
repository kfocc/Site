SChat2.cvars = SChat2.cvars or {}
local function LoadCvars()
	sql.Query("CREATE TABLE IF NOT EXISTS unionrp_chat_convars(id INT NOT NULL, data TEXT NOT NULL);")
	local query = sql.Query("SELECT data FROM unionrp_chat_convars WHERE id = 1;")
	if istable(query) and query[1] then
		local suc, res = pcall(pon.decode, query[1].data)
		if suc then
			for k, v in pairs(res) do
				SChat2.cvars[k] = v
			end
		else
			sql.Query("DELETE FROM unionrp_chat_convars WHERE id = 1;")
		end
	else
		sql.Query("INSERT INTO unionrp_chat_convars(id, data) VALUES('1', '[}');")
	end
end

LoadCvars()
local function SaveCvars()
	local str = pon.encode(SChat2.cvars)
	sql.Query("UPDATE unionrp_chat_convars SET data = " .. SQLStr(str) .. " WHERE id = 1;")
end

function SChat2:GetConvar(str, def)
	local cvar, config = self.cvars[str], self.Config[str]
	if cvar ~= nil then
		return cvar
	elseif config ~= nil then
		return config
	end
	return def
end

function SChat2:SetConvar(str, val)
	self.cvars[str] = val
	SaveCvars()
end

function SChat2:SetConvars(...)
	local tbl = {...}
	local tblLen = #tbl
	for i = 1, tblLen do
		local v = tbl[i]
		if v then self.cvars[v[1]] = v[2] end
	end

	SaveCvars()
end

function SChat2:ResetConvars()
	table.Empty(self.cvars)
	if SChat2.Panel and IsValid(SChat2.Panel) then
		local posX, posY = SChat2:GetConvar("posX", 10), SChat2:GetConvar("posY", ScrH() * 0.5)
		local sizeW, sizeH = SChat2:GetConvar("sizeW", ScrW() / 3), SChat2:GetConvar("sizeH", ScrW() / 3)
		SChat2.Panel:SetPos(posX, posY)
		SChat2.Panel:SetSize(sizeW, sizeH)
	end

	SaveCvars()
end
