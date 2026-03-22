local DarkRP = DarkRP or {}
DarkRP.adverts = DarkRP.adverts or {}

net.Receive("Receive_Advert_Menu", function(len)
	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 150)
	frame:SetTitle("Ссылка на картинку")
	frame:Center()
	frame:MakePopup()
	frame.Paint = function()
		draw.RoundedBox(0, 0, 0, frame:GetWide(), frame:GetTall(), Color(12, 12, 12, 180))
		draw.RoundedBox(0, 0, 0, frame:GetWide(), frame:GetTall() * 0.15, Color(216, 101, 74))
	end

	local panel = frame:Add("DPanel")
	panel:SetSize(frame:GetWide() - 10, frame:GetTall() / 3)
	panel:Center()

	local text1 = panel:Add("DTextEntry")
	text1:SetHeight(15)
	text1:Dock(FILL)
	text1:Center()
	text1:SetMultiline(true)
	text1:SetText("Ссылка на картинку")

	local panel1 = panel:Add("DPanel")
	panel1:Dock(RIGHT)
	panel1:DockMargin(3, 5, 0, 5)
	panel1:SetTall(34)

	local text2 = panel1:Add("DTextEntry")
	text2:Dock(TOP)
	text2:DockMargin(20, 0, 2, 0)
	text2:SetText("256")

	local label1 = panel1:Add("DLabel")
	label1:SetPos(3, 1)
	label1:SetTextColor(Color(0, 0, 0))
	label1:SetText("W")

	local text3 = panel1:Add("DTextEntry")
	text3:Dock(BOTTOM)
	text3:DockMargin(20, 0, 2, 1)
	text3:SetText("256")

	local label2 = panel1:Add("DLabel")
	label2:SetPos(5, panel1:GetTall() * 0.55)
	label2:SetTextColor(Color(0, 0, 0))
	label2:SetText("H")

	local panel2 = frame:Add("DPanel")
	panel2:Dock(BOTTOM)
	panel2:DockMargin(5, 5, 5, 5)
	panel2:SetTall(35)
	panel2.Paint = function(self) end

	local button = panel2:Add("DButton")
	button:SetText("Добавить адверт")
	button:Dock(LEFT)
	button:DockMargin(5, 5, 5, 5)
	button:SizeToContents()
	button.CheckArgs = function(self)
		local path = {}
		if (string.sub(text1:GetValue(), 1, 7) == "http://" or string.sub(text1:GetValue(), 1, 8) == "https://") and (string.EndsWith(text1:GetValue(), ".jpg") or string.EndsWith(text1:GetValue(), ".png")) then
			path.url = text1:GetValue()
			if isnumber(tonumber(text2:GetValue())) and isnumber(tonumber(text3:GetValue())) then
				path.w = text2:GetValue()
				path.h = text3:GetValue()
			else
				text2:SetText(isnumber(tonumber(text2:GetValue())) and text2:GetValue() or "ERROR")
				text3:SetText(isnumber(tonumber(text3:GetValue())) and text3:GetValue() or "ERROR")
				return
			end

			net.Start("Receive_Advert_Menu")
			net.WriteTable(path)
			net.SendToServer()
			PrintTable(path)
		else
			return text1:SetText("Ошибка, ссылка должна заканчиваться на .jpg или .png\n и начинаться с http(s)!")
		end
	end

	button.DoClick = function(self) self:CheckArgs() end

	local button1 = panel2:Add("DButton")
	button1:SetText("Удалить адверт")
	button1:Dock(LEFT)
	button1:DockMargin(5, 5, 5, 5)
	button1:SizeToContents()
	button1.DoClick = function(self) RunConsoleCommand("say", "\"!adremove\"") end
end)

net.Receive("Get_Advert_Data", function(len, ply)
	local tbl = net.ReadTable()
	local int = net.ReadInt(8)
	if tbl then
		if int == 1 then
			hook.Run("CacheMaterial", tbl)
			DarkRP.adverts[#DarkRP.adverts + 1] = tbl
		elseif int == 2 then
			for k, v in pairs(tbl) do
				hook.Run("CacheMaterial", v)
			end

			DarkRP.adverts = tbl
		end
	end
end)

hook.Remove("CacheMaterial", "UnionCacheMaterial")
hook.Add("CacheMaterial", "UnionCacheMaterial", function(data)
	if data.material then return end
	local exploded = string.Explode("/", data.url)
	local extension = "." .. string.GetExtensionFromFilename(exploded[#exploded])
	local path = "unionrp/saves/adverts/" .. game.GetMap() .. "/" .. util.CRC(data.url) .. extension
	if file.Exists(path, "DATA") then
		data.material = Material("../data/" .. path, "noclamp smooth")
		return
	end

	local directories = string.Explode("/", path)
	local currentPath = ""
	for k, v in pairs(directories) do
		if k < #directories then
			currentPath = currentPath .. v .. "/"
			file.CreateDir(currentPath)
		end
	end

	http.Fetch(data.url, function(body, length, headers, code)
		path = path:gsub(".jpeg", ".jpg")
		file.Write(path, body)
		data.material = Material("../data/" .. path, "noclamp smooth")
	end, function() data.material = Material("gui/gmod_logo", "noclamp smooth") end)
end)

hook.Add("PostDrawTranslucentRenderables", "UnionDrawAdverts", function(bDrawingDepth, bDrawingSkybox)
	if bDrawingSkybox or bDrawingDepth then return end
	local ply = LocalPlayer()
	local eyePos = EyePos()
	local eyeAngles = EyeAngles()
	if DarkRP.adverts and #DarkRP.adverts ~= 0 then
		for k, v in ipairs(DarkRP.adverts) do
			if v.material then
				if ply:GetPos():Distance(v.position) > 1000 then continue end
				cam.Start3D2D(v.position, v.angles, 0.25)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				render.PushFilterMag(TEXFILTER.ANISOTROPIC)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(v.material)
				surface.DrawTexturedRect(0, 0, v.width, v.height)
				render.PopFilterMag()
				render.PopFilterMin()
				cam.End3D2D()
			end
		end
	end
end)
