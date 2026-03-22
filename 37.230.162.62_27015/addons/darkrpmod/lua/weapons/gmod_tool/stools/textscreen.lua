TOOL.Category = "Construction"
TOOL.Name = "#tool.textscreen.name"
TOOL.Command = nil
TOOL.ConfigName = ""
local textBox = {}
local lineLabels = {}
local labels = {}
local sliders = {}
local textscreenFonts = textscreenFonts

for i = 1, 5 do
	TOOL.ClientConVar["text" .. i] = ""
	TOOL.ClientConVar["size" .. i] = 20
	TOOL.ClientConVar["r" .. i] = 255
	TOOL.ClientConVar["g" .. i] = 255
	TOOL.ClientConVar["b" .. i] = 255
	TOOL.ClientConVar["a" .. i] = 255
	TOOL.ClientConVar["font" .. i] = 1
end

cleanup.Register("textscreens")
if CLIENT then
	TOOL.Information = {
		{
			name = "left"
		},
		{
			name = "right"
		},
		{
			name = "reload"
		},
	}

	language.Add("tool.textscreen.name", "3D2D Textscreen")
	language.Add("tool.textscreen.desc", "Создайте текстовый экран с несколькими строками, цветами и размерами шрифта.")
	language.Add("tool.textscreen.left", "Spawn a textscreen.") -- Does not work with capital T in tool. Same with right and reload.
	language.Add("tool.textscreen.right", "Update textscreen with settings.")
	language.Add("tool.textscreen.reload", "Copy textscreen.")
	language.Add("Undone.textscreens", "Undone textscreen")
	language.Add("Undone_textscreens", "Undone textscreen")
	language.Add("Cleanup.textscreens", "Textscreens")
	language.Add("Cleanup_textscreens", "Textscreens")
	language.Add("Cleaned.textscreens", "Cleaned up all textscreens")
	language.Add("Cleaned_textscreens", "Cleaned up all textscreens")
	language.Add("SBoxLimit.textscreens", "You've hit the textscreen limit!")
	language.Add("SBoxLimit_textscreens", "You've hit the textscreen limit!")
end

function TOOL:LeftClick(tr)
	if tr.Entity:GetClass() == "player" then return false end
	if CLIENT then return true end
	local ply = self:GetOwner()
	if not self:GetWeapon():CheckLimit("textscreens") then return false end
	local textScreen = ents.Create("sammyservers_textscreen")
	textScreen:SetPos(tr.HitPos)
	local angle = tr.HitNormal:Angle()
	angle:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
	angle:RotateAroundAxis(tr.HitNormal:Angle():Forward(), 90)
	textScreen:SetAngles(angle)
	if IsValid(ply) then textScreen:CPPISetOwner(ply) end
	textScreen:Spawn()
	textScreen:Activate()
	for i = 1, 5 do
		local text = self:GetClientInfo("text" .. i)
		if not text or text == "" then continue end
		--if not text:TextScreenAllowed() then DarkRP.notify(ply, 0, 4, "Недопустимый текст на строке #" .. i) continue end
		textScreen:SetLine(i, -- Line
			text, -- text
			Color(
			-- Color
			tonumber(self:GetClientInfo("r" .. i)), tonumber(self:GetClientInfo("g" .. i)), tonumber(self:GetClientInfo("b" .. i)), tonumber(self:GetClientInfo("a" .. i))), tonumber(self:GetClientInfo("size" .. i)), -- font
			tonumber(self:GetClientInfo("font" .. i)))
	end

	-- Line
	-- text
	-- Color
	undo.Create("textscreens")
	undo.AddEntity(textScreen)
	undo.SetPlayer(ply)
	undo.Finish()
	ply:AddCount("textscreens", textScreen)
	ply:AddCleanup("textscreens", textScreen)
	return true
end

function TOOL:RightClick(tr)
	if tr.Entity:GetClass() == "player" then return false end
	if CLIENT then return true end
	local TraceEnt = tr.Entity
	if not IsValid(TraceEnt) or TraceEnt:GetClass() ~= "sammyservers_textscreen" then return false end
	local owner = TraceEnt:CPPIGetOwner()
	local ply = self:GetOwner()
	if owner ~= ply then return end
	for i = 1, 5 do
		TraceEnt:SetLine(i, -- Line
			tostring(self:GetClientInfo("text" .. i)), -- text
			Color(
			-- Color
			tonumber(self:GetClientInfo("r" .. i)), tonumber(self:GetClientInfo("g" .. i)), tonumber(self:GetClientInfo("b" .. i)), tonumber(self:GetClientInfo("a" .. i))), tonumber(self:GetClientInfo("size" .. i)), -- font
			tonumber(self:GetClientInfo("font" .. i)))
	end

	TraceEnt:Broadcast()
	return true
end

function TOOL:Reload(tr)
	local TraceEnt = tr.Entity
	if not IsValid(TraceEnt) or TraceEnt:GetClass() ~= "sammyservers_textscreen" then return false end
	local lines = TraceEnt.lines
	if not lines then return true end
	for i = 1, 5 do
		local linedata = lines[i]
		if not linedata then continue end
		RunConsoleCommand("textscreen_r" .. i, linedata.color.r)
		RunConsoleCommand("textscreen_g" .. i, linedata.color.g)
		RunConsoleCommand("textscreen_b" .. i, linedata.color.b)
		RunConsoleCommand("textscreen_a" .. i, linedata.color.a)
		RunConsoleCommand("textscreen_size" .. i, linedata.size)
		RunConsoleCommand("textscreen_text" .. i, linedata.text)
		RunConsoleCommand("textscreen_font" .. i, linedata.font)
	end
	return true
end

if not CLIENT then return end
function TOOL.BuildCPanel(CPanel)
	print(CPanel)
	if not CPanel then return end
	CPanel:AddControl("Header", {
		Text = "#tool.textscreen.name",
		Description = "#tool.textscreen.desc"
	})

	local function TrimFontName(fontnum)
		return string.Left(textscreenFonts[fontnum], 8) == "Screens_" and string.TrimLeft(textscreenFonts[fontnum], "Screens_") or textscreenFonts[fontnum]
	end

	local changefont
	local fontnum = textscreenFonts[GetConVar("textscreen_font1"):GetInt()] ~= nil and GetConVar("textscreen_font1"):GetInt() or 1
	local fontsize = {}
	cvars.AddChangeCallback("textscreen_font1", function(convar_name, value_old, value_new)
		fontnum = textscreenFonts[tonumber(value_new)] ~= nil and tonumber(value_new) or 1
		local font = TrimFontName(fontnum)
		changefont:SetText("Шрифты (" .. font .. ")")
	end)

	local function ResetFont(lines, text)
		if #lines >= 5 then
			fontnum = 1
			for i = 1, 5 do
				RunConsoleCommand("textscreen_font" .. i, 1)
			end
		end

		for k, i in pairs(lines) do
			if text then
				RunConsoleCommand("textscreen_text" .. i, "")
				labels[i]:SetText("")
			end

			labels[i]:SetFont(textscreenFonts[fontnum] .. fontsize[i])
		end
	end

	resetall = vgui.Create("DButton", resetbuttons)
	resetall:SetSize(100, 25)
	resetall:SetText("Сбросить")
	resetall.DoClick = function()
		local menu = DermaMenu()
		menu:AddOption("Сбросить цвета", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
			end
		end)

		menu:AddOption("Сбросить размеры", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_size" .. i, 20)
				fontsize[i] = 20
				sliders[i]:SetValue(20)
				labels[i]:SetFont(textscreenFonts[fontnum] .. fontsize[i])
			end
		end)

		menu:AddOption("Сбросить текст", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
			end
		end)

		menu:AddOption("Сбросить шрифты", function() ResetFont({1, 2, 3, 4, 5}, false) end)
		menu:AddOption("Сбросить все", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text" .. i, "")
				RunConsoleCommand("textscreen_font" .. i, 1)
				textBox[i]:SetValue("")
				fontsize[i] = 20
			end

			ResetFont({1, 2, 3, 4, 5}, true)
		end)

		menu:Open()
	end

	CPanel:AddItem(resetall)
	resetline = vgui.Create("DButton")
	resetline:SetSize(100, 25)
	resetline:SetText("Сбросить строку")
	resetline.DoClick = function()
		local menu = DermaMenu()
		for i = 1, 5 do
			menu:AddOption("Сбросить строку " .. i, function()
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text" .. i, "")
				textBox[i]:SetValue("")
				fontsize[i] = 20
				ResetFont({i}, true)
			end)
		end

		menu:AddOption("Сбросить все строки", function()
			for i = 1, 5 do
				RunConsoleCommand("textscreen_r" .. i, 255)
				RunConsoleCommand("textscreen_g" .. i, 255)
				RunConsoleCommand("textscreen_b" .. i, 255)
				RunConsoleCommand("textscreen_a" .. i, 255)
				RunConsoleCommand("textscreen_size" .. i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text" .. i, "")
				RunConsoleCommand("textscreen_font" .. i, 1)
				textBox[i]:SetValue("")
				fontsize[i] = 20
			end

			ResetFont({1, 2, 3, 4, 5}, true)
		end)

		menu:Open()
	end

	CPanel:AddItem(resetline)
	-- Change font
	changefont = vgui.Create("DButton")
	changefont:SetSize(100, 25)
	changefont:SetText("Шрифты (" .. TrimFontName(fontnum) .. ")")
	changefont.DoClick = function()
		local menu = DermaMenu()
		for i = 1, #textscreenFonts do
			local font = TrimFontName(i)
			menu:AddOption(font, function()
				fontnum = i
				for o = 1, 5 do
					RunConsoleCommand("textscreen_font" .. o, i)
					labels[o]:SetFont(textscreenFonts[fontnum] .. fontsize[o])
				end

				changefont:SetText("Change font (" .. font .. ")")
			end)
		end

		menu:Open()
	end

	CPanel:AddItem(changefont)
	local ctrl = vgui.Create("ControlPresets", CPanel)
	ctrl:SetPreset("textscreen")
	local options = {}
	for i = 1, 5 do
		local text = "textscreen_text" .. i
		local size = "textscreen_size" .. i
		local r = "textscreen_r" .. i
		local g = "textscreen_g" .. i
		local b = "textscreen_b" .. i
		local a = "textscreen_a" .. i
		local font = "textscreen_font" .. i
		options[text] = ""
		options[size] = 20
		options[r] = 255
		options[g] = 255
		options[b] = 255
		options[a] = 255
		options[font] = 1
		ctrl:AddConVar(text)
		ctrl:AddConVar(size)
		ctrl:AddConVar(r)
		ctrl:AddConVar(g)
		ctrl:AddConVar(b)
		ctrl:AddConVar(a)
		ctrl:AddConVar(font)
	end

	ctrl:AddOption("#Default", options)
	CPanel:AddPanel(ctrl)
	for i = 1, 5 do
		fontsize[i] = 20
		lineLabels[i] = CPanel:AddControl("Label", {
			Text = "Строка " .. i,
			Description = "Строка " .. i
		})

		lineLabels[i]:SetFont("Default")
		CPanel:AddControl("Color", {
			Label = "Цвет " .. i .. " строки",
			Red = "textscreen_r" .. i,
			Green = "textscreen_g" .. i,
			Blue = "textscreen_b" .. i,
			Alpha = "textscreen_a" .. i,
			ShowHSV = 1,
			ShowRGB = 1,
			Multiplier = 255
		})

		sliders[i] = vgui.Create("DNumSlider")
		sliders[i]:SetText("Размер")
		sliders[i]:SetMinMax(20, 100)
		sliders[i]:SetDecimals(0)
		sliders[i]:SetValue(GetConVar("textscreen_size" .. i))
		sliders[i]:SetConVar("textscreen_size" .. i)
		sliders[i].OnValueChanged = function(panel, value)
			fontsize[i] = math.Round(tonumber(value))
			labels[i]:SetFont(textscreenFonts[fontnum] .. fontsize[i])
			labels[i]:SetHeight(fontsize[i])
		end

		CPanel:AddItem(sliders[i])
		textBox[i] = vgui.Create("DTextEntry")
		textBox[i]:SetUpdateOnType(true)
		textBox[i]:SetEnterAllowed(true)
		textBox[i]:SetConVar("textscreen_text" .. i)
		textBox[i]:SetValue(GetConVar("textscreen_text" .. i):GetString())
		textBox[i].OnTextChanged = function() labels[i]:SetText(textBox[i]:GetValue()) end
		CPanel:AddItem(textBox[i])
		labels[i] = CPanel:AddControl("Label", {
			Text = #GetConVar("textscreen_text" .. i):GetString() >= 1 and GetConVar("textscreen_text" .. i):GetString() or "Line " .. i,
			Description = "Line " .. i
		})

		labels[i]:SetFont(textscreenFonts[fontnum] .. fontsize[i])
		labels[i]:SetAutoStretchVertical(true)
		labels[i]:SetDisabled(true)
		labels[i].Think = function() labels[i]:SetColor(Color(GetConVar("textscreen_r" .. i):GetInt(), GetConVar("textscreen_g" .. i):GetInt(), GetConVar("textscreen_b" .. i):GetInt(), GetConVar("textscreen_a" .. i):GetInt())) end
	end
end
