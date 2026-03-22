local iconStr = "icon16/%s.png"
local dMenu
local function buildDMenu(result)
	if IsValid(dMenu) then dMenu:Remove() end
	dMenu = DermaMenu()
	function dMenu:AddSpacer(strText, funcFunction)
		local pnl = vgui.Create("DPanel", self)
		pnl.Paint = function(p, w, h)
			surface.SetDrawColor(col.o)
			surface.DrawRect(0, 0, w, h)
		end

		pnl:SetTall(1)
		self:AddPanel(pnl)
		return pnl
	end

	-- dMenu:SetTextColor(col.w)
	local length = #result
	local col1 = col.o:darken(20)
	if length > 0 then
		for i = 1, length do
			local data = result[i]
			local id, name, icon = data[1], data[2], data[3]
			local opt = dMenu:AddOption(name, function() netstream.Start("contextEntity.request", id) end)
			opt:SetTextColor(col.w)
			opt.Paint = function(self, w, h) if self:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, col1) end end
			if icon then opt:SetIcon(iconStr:format(icon)) end
		end
	end

	dMenu:AddSpacer()
	local text = length > 0 and "Закрыть" or "Вы не можете ничего с этим сделать..."
	local cls = dMenu:AddOption(text)
	if length > 0 then cls:SetIcon(iconStr:format("cross")) end
	cls:SetTextColor(col.w)
	cls.Paint = function(self, w, h) if self:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, col1) end end
	dMenu.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, col.ba) end
	local w, h = ScrW() * 0.5, ScrH() * 0.5
	dMenu:Open(w, h)
end

-- local function contextEntityPressed()
-- 	local lp = LocalPlayer()
-- 	local ent = lp:GetEyeTrace().Entity
-- 	if IsValid(ent) then
-- 		local entCfg = contextEntity.entsList[ent:GetClass()]
-- 		if entCfg then
-- 			if lp:GetPos():Distance(ent:GetPos()) >= 100 then
-- 				return
-- 			end
-- 			buildDMenu(ent, entCfg)
-- 		end
-- 	end
-- end
-- hook.Add(
-- 	"KeyPress",
-- 	"contextEntity.KeyPress",
-- 	function(_, key)
-- 		if not IsFirstTimePredicted() then
-- 			return
-- 		end
-- 		if key ~= IN_USE then
-- 			return
-- 		end
-- 		timer.Create(
-- 			"contextEntity.KeyPress",
-- 			0.5,
-- 			1,
-- 			function()
-- 				contextEntityPressed()
-- 			end
-- 		)
-- 	end
-- )
-- hook.Add(
-- 	"KeyRelease",
-- 	"contextEntity.KeyRelease",
-- 	function(_, key)
-- 		if not IsFirstTimePredicted() then
-- 			return
-- 		end
-- 		if key ~= IN_USE then
-- 			return
-- 		end
-- 		if timer.Exists("contextEntity.KeyPress") then
-- 			timer.Remove("contextEntity.KeyPress")
-- 		end
-- 		if IsValid(dMenu) then
-- 			dMenu:Remove()
-- 		end
-- 	end
-- )
cEntsWhitelist = cEntsWhitelist or {}
local pressed, time
hook.Add("KeyPress", "contextEntity.KeyPress", function(_, key)
	if not IsFirstTimePredicted() then return end
	if key ~= IN_USE then return end
	if pressed then return end
	local lp = LocalPlayer()
	if lp:IsRagdolled() then return end
	local trEnt = LocalPlayer():GetEyeTraceNoCursor().Entity
	if not IsValid(trEnt) or not cEntsWhitelist[trEnt:GetClass()] then return end
	pressed = true
	timer.Create("contextEntity.startTimer", 0.3, 1, function() if pressed then time = CurTime() + 0.5 end end)
end)

hook.Add("KeyRelease", "contextEntity.KeyRelease", function(_, key)
	if not IsFirstTimePredicted() then return end
	if key ~= IN_USE then return end
	if not pressed then return end
	timer.Remove("contextEntity.startTimer")
	pressed = nil
	time = nil
end)

hook.Add("HUDPaint", "contextEntity.drawCircle", function()
	if pressed and time then
		local rad = (CurTime() - time) * 50
		if rad >= 25 then time = CurTime() + 0.5 end
		-- print(rad)
		local w, h = ScrW() * 0.5, ScrH() * 0.5
		surface.DrawCircle(w, h, rad, Color(255, 100, 80))
	end
end)

--[[
	RENDER E KEY
]]
local trEnt
timer.Create("checkTrEnt", 0.1, 0, function()
	local pl = LocalPlayer()
	if not IsValid(pl) or not pl.GetEyeTrace then return end
	local tr = pl:GetEyeTrace().Entity
	if IsValid(tr) then
		if tr ~= trEnt then
			if cEntsWhitelist[tr:GetClass()] then
				trEnt = tr
			else
				trEnt = nil
			end
		end
	else
		trEnt = nil
	end
end)

local material = Material("unionrp/ui/key_e.png", "noclamp smooth")
-- timer.Simple(
-- 	.1,
-- 	function()
-- 		if not file.Exists("unionrp", "DATA") then
-- 			file.CreateDir("unionrp")
-- 		end
-- 		if not file.Exists("unionrp/key_e.png", "DATA") then
-- 			http.Fetch(
-- 				"https://unionrp.info/hl2rp/e_key.png",
-- 				function(callback)
-- 					if callback then
-- 						file.Write("unionrp/key_e.png", callback)
-- 						material = Material("../data/unionrp/key_e.png", "noclamp smooth")
-- 					end
-- 				end
-- 			)
-- 		end
-- 	end
-- )
local dist = 100 * 100
hook.Add("HUDPaint", "contextEntity.drawKey", function()
	local ply = LocalPlayer()
	if IsValid(trEnt) and not time and not IsValid(dMenu) and not isAction and ply:Alive() and not ply:IsRagdolled() then
		if trEnt:GetPos():DistToSqr(ply:GetPos()) >= dist then return end
		local w, h = ScrW() * 0.5, ScrH() * 0.5
		local cur = math.floor(CurTime() % 2)
		surface.SetMaterial(material)
		surface.SetDrawColor(255, 255, 255, 255)
		local s = cur == 0 and 32 or 64
		surface.DrawTexturedRect(w - 32, h + 70 - s, 64, s)
	end
end)

--[[
	END OF RENDER E KEY
]]
netstream.Hook("contextEntity.request", function(result)
	time = nil
	-- if not result or result._length == 0 then
	if not result then
		if IsValid(dMenu) then dMenu:Remove() end
		return
	end

	buildDMenu(result)
end)

netstream.Hook("contextEntity.sendWL", function(result) cEntsWhitelist = result end)
