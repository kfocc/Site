DialogSys = DialogSys or {}
DialogSys.vgui = DialogSys.vgui or {} -- derma
DialogSys.NPCS = DialogSys.NPCS or {} -- clientside npc

local sscale = util.SScale
surface.CreateFont("UFont.Dialog", -- кнопки диалога
	{
	font = "Inter",
	size = sscale(20),
	weight = 400,
	extended = true,
})

surface.CreateFont("UFont.Dialog.NPCText", -- текст НПС
	{
	font = "Inter",
	size = sscale(20),
	weight = 200,
	extended = true,
})

surface.CreateFont("UFont.Dialog.NPCName", -- имя НПС
	{
	font = "Inter",
	size = sscale(25),
	weight = 0,
	extended = true,
})

local goodbyesRandom = {
	"Пока",
	"Мне пора",
	"Я пойду",
	"Удачи",
	"Уйти",
	"Я пойду, пожалуй",
	"Благодарю, я пойду"
}

local goodbyes = {
	["Закрыть"] = true,
}

for i = 1, #goodbyesRandom do
	goodbyes[goodbyesRandom[i]] = true
end

local function checkGoodBye(tbl, away_text)
	local has = false
	for k, v in pairs(tbl) do
		if goodbyes[v.text] then has = true end
	end

	if not has then
		table.insert(tbl, {
			text = away_text or goodbyesRandom[math.random(#goodbyesRandom)],
			func = function(n, m) m:Remove() end
		})
	end
end

local colorGray = Color(200, 200, 200)
local colorSemiBlack = Color(20, 20, 20, 150)
function DialogSys.BeginDialogue(npc, nice_text, tbl, away_text)
	if IsValid(DialogSys.vgui.DialogueMenu) then DialogSys.vgui.DialogueMenu:Remove() end

	tbl = tbl or {}
	checkGoodBye(tbl, away_text)

	DialogSys.vgui.npc = npc

	local npc_name = npc:GetNetVar("Name", npc.Name or npc.NPCName or npc.PrintName or "<Неизвестно>")
	local pang = LocalPlayer():GetAngles()
	local nang = npc:GetAngles()
	nang.y = pang.y + 180
	--npc:SetAngles(nang)
	--
	local dmenu = vgui.Create("DPanel")
	DialogSys.vgui.DialogueMenu = dmenu

	local scrw, scrh = ScrW(), ScrH()
	dmenu:SetSize(scrw, scrh)
	dmenu:CloseOnEscape()
	dmenu:MakePopup()

	local headBone = npc:LookupBone("ValveBiped.Bip01_Head1")
	local bonePos = headBone and npc:GetBonePosition(headBone) or npc:GetPos() + Vector(0, 0, 64)
	bonePos = bonePos + Vector(0, 0, -2)

	dmenu.Paint = function(self, w, h)
		-- Камера на голову NPC
		draw.RoundedBox(0, 0, 0, w, h, colorSemiBlack)

		if npc.NoZoom then return end
		self.Fov = self.Fov or 90
		local pos = LocalPlayer():EyePos()
		local fov = self.Fov
		local ang = (bonePos - pos):Angle()
		--
		local targetFov = 60
		if fov > targetFov then
			local fspeed = FrameTime() * 40
			fov = fov - fspeed
		end

		self.Fov = fov

		--
		render.RenderView({
			origin = pos,
			angles = ang,
			drawviewmodel = false,
			dopostprocess = true,
			fov = fov,
			x = 0,
			y = 0,
			w = w,
			h = h
		})
	end

	dmenu.Think = function(self) if input.IsKeyDown(KEY_W) or input.IsKeyDown(KEY_A) or input.IsKeyDown(KEY_S) or input.IsKeyDown(KEY_D) or input.IsKeyDown(KEY_SPACE) then self:Remove() end end
	temporaryDisableThirdPerson(true)
	dmenu.OnRemove = function(me) temporaryDisableThirdPerson(false) end
	local mainFrame = vgui.Create("DPanel", dmenu)
	local minW, minH = sscale(900), sscale(460)
	local sscale1 = sscale(1)
	mainFrame:SetSize(minW, minH)
	mainFrame:SetPos(0, ScrH() - minH)
	mainFrame:CenterHorizontal()
	mainFrame.Paint = nil

	local answerFrameSize = sscale(200)
	local textFrameSize = sscale(200)
	local nameFrameSize = sscale(50)
	local frame = vgui.Create("UnionFrame", mainFrame) -- Фрейм для ответов
	frame:Dock(BOTTOM)
	frame:SetTall(answerFrameSize)
	frame.Paint = function(self, w, h) NiceBlur(nil, 10, 0, 0, w, h) end

	dmenu.Frame = frame

	local dummyNPCText = vgui.Create("DPanel", mainFrame)
	dummyNPCText:Dock(BOTTOM)
	dummyNPCText:SetTall(textFrameSize)
	dummyNPCText.Paint = function(self, w, h) NiceBlur(nil, 10, 0, 0, w, h) end

	local sscale30 = sscale(30)
	local npcText = vgui.Create("RichText", dummyNPCText) -- Сам текст слов
	npcText:Dock(FILL)
	npcText:DockMargin(sscale30, sscale30, sscale30, sscale30)
	npcText.PerformLayout = function(self)
		self:SetFontInternal("UFont.Dialog.NPCText")
		self:SetFGColor(colorGray)
	end

	local npcName = vgui.Create("DLabel", mainFrame) -- Имя npc
	npcName:Dock(BOTTOM)
	npcName:SetTall(nameFrameSize)
	npcName:SetText("")
	npcName.SetText = function(self, text)
		self.currentText = text
		surface.SetFont("UFont.Dialog.NPCName")
		self.currentTextSize = {surface.GetTextSize(text)}
	end

	npcName.Paint = function(self, w, h)
		local half = w * 0.5
		local textSize = self.currentTextSize[1]
		local blurSize = half - textSize
		NiceBlur(nil, 4, blurSize, 0, textSize * 2, h)
		draw.SimpleText(self.currentText, "UFont.Dialog.NPCName", half, h * 0.5, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local sscale15 = sscale(15)
	local sscale25 = sscale(25)
	local sscale2 = sscale(2)
	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)
	scroll:DockMargin(sscale15, sscale1, sscale15, sscale25)
	local sbar = scroll:GetVBar()
	sbar:SetWide(sscale2)
	sbar:SetHideButtons(true)
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.b)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.o)
	end

	DialogSys.vgui.DialogueMenu.scroll = scroll
	DialogSys.vgui.DialogueMenu.text = npcText
	DialogSys.vgui.DialogueMenu.name = npcName
	DialogSys.vgui.DialogueMenu.SetButtons = DialogSys.SetButtons
	DialogSys.vgui.DialogueMenu.SetText = DialogSys.SetText
	DialogSys.vgui.DialogueMenu.SetName = DialogSys.SetName
	DialogSys.SetName(npc_name)
	DialogSys.SetText(nice_text)
	DialogSys.SetButtons(tbl)
end

function DialogSys.SetButtons(tbl)
	if not IsValid(DialogSys.vgui.DialogueMenu) then return end

	tbl = tbl or {}

	local frame = DialogSys.vgui.DialogueMenu
	local scroll = frame.scroll
	local sscale1 = sscale(1)
	local sscale10 = sscale(10)
	-- table.sort(tbl, function(a, b) return utf8.len(a.text) < utf8.len(b.text) end)

	scroll:Clear()
	checkGoodBye(tbl)

	for k, v in ipairs(tbl) do
		if v.check and not v.check(LocalPlayer(), DialogSys.vgui.npc) then continue end

		local text = " - " .. (v.text or "Неизвестно")
		local pnl = scroll:Add("DButton")
		pnl:Dock(TOP)
		pnl:DockMargin(0, 0, 0, sscale(3))
		pnl:SetTall(sscale(35))
		pnl:SetText("")
		pnl.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.RoundedBox(4, sscale1, h - sscale1, w - sscale10, sscale1, col.o)
			else
				draw.RoundedBox(4, sscale1, h - sscale1, w - sscale10, sscale1, col.w)
			end

			draw.SimpleText(text, "UFont.Dialog", 0, h * 0.45, col.w, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		pnl.DoClick = function(self) v.func(DialogSys.vgui.npc, frame) end
	end
end

function DialogSys.SetText(txt)
	if not IsValid(DialogSys.vgui.DialogueMenu) then return end

	local frame = DialogSys.vgui.DialogueMenu
	local text = frame.text
	text:SetText("")
	text:AppendText(txt)
	timer.Simple(0, function()
		if not IsValid(text) then return end
		text:GotoTextStart()
	end)
end

function DialogSys.SetName(text)
	if not IsValid(DialogSys.vgui.DialogueMenu) then return end

	local frame = DialogSys.vgui.DialogueMenu
	local name = frame.name
	name:SetText(text)
end

function DialogSys.Remove()
	if not IsValid(DialogSys.vgui.DialogueMenu) then return end

	DialogSys.vgui.DialogueMenu:Remove()
end

netstream.Hook("DialogSys.BeginDialogue", function(npc, text, tbl) DialogSys.BeginDialogue(npc, text, tbl) end)
