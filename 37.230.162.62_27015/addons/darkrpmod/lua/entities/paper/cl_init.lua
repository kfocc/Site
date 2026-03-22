include("shared.lua")
local HTMLCode = [[
<!doctypehtml><html lang=ru><meta charset=utf-8><meta content="text/html; charset=UTF-8"http-equiv=content-type><meta content="width=device-width,initial-scale=1"name=viewport><title>Paper</title><style>header h1,section{padding-top:2%;text-shadow:0 1px 1px #000}body,header h1,section p{margin:0;height:100%}body,header h1,html,section p{height:100%}body,footer p{padding-right:2%}.my-scrollbar,footer p{position:absolute;right:0}@font-face{font-family:Skellyman;font-style:normal;font-weight:1000;src:url(asset://garrysmod/resource/fonts/skellyman.ttf) format("truetype")}@font-face{font-family:Machinetype;font-style:normal;font-weight:1000;src:url(asset://garrysmod/resource/fonts/nevduplenysh.ttf) format("truetype")}*{box-sizing:border-box}html{font-size:14px;line-height:1.15}footer p,section{font-size:1.4rem}body{padding-left:2%;cursor:default;color:#333;word-wrap:break-word;background-size:100% 100%;background-attachment:fixed}body::-webkit-scrollbar{display:none}header{height:10%}header h1{text-align:center;overflow:hidden}section{height:80%}section p{padding:0;overflow-y:auto;overflow-x:hidden}section p::-webkit-scrollbar{display:none}footer p{bottom:0;text-align:right;text-shadow:0 1px 0 #000}.colored-sign{text-shadow:.1em .1em .2em}.outline-for-edit{border:dashed #333}.prevent-select{-webkit-user-select:none;-ms-user-select:none;user-select:none}.my-scrollbar{cursor:default;width:5px;margin:5px;height:50px;top:0;background-color:#142745;border-radius:5px}</style><header class=prevent-select hidden id=title-header><h1 id=paper-title>Sample header text.</h1></header><section class=prevent-select hidden id=text-main><p id=paper-body>Sample body text.</section><footer class=prevent-select hidden id=sign-footer><p><b>Подпись: <span id=player-name>Sample Name</span>(<span id=player-job>Sample Job</span>)</b></footer><script>var paperTitle=document.getElementById("paper-title"),paperText=document.getElementById("paper-body"),paperPlayerName=document.getElementById("player-name"),paperPlayerJob=document.getElementById("player-job");paperTitle.innerText="",paperText.innerText="",paperPlayerName.innerText="",paperPlayerJob.innerText="";var titleHeader=document.getElementById("title-header"),textMain=document.getElementById("text-main"),signFooter=document.getElementById("sign-footer"),html=document.documentElement,isExtended=!1,scrollBar=document.createElement("div"),scrollBarStyle=scrollBar.style;function checkScrollBarVisible(){paperText.scrollHeight<=paperText.clientHeight?scrollBar.hidden=!0:scrollBar.hidden=!1}function checkMainTextHeight(){titleHeader.hidden&&signFooter.hidden?textMain.style.height="97%":titleHeader.hidden?textMain.style.height="90%":signFooter.hidden?textMain.style.height="87%":textMain.style.height="80%"}scrollBar.className="my-scrollbar prevent-selection",html.appendChild(scrollBar),paperText.addEventListener("scroll",function(){var e=paperText.scrollTop/(paperText.scrollHeight-paperText.clientHeight)*100,t=html.clientHeight*(e/100);t=Math.min(t,window.innerHeight-50-10),scrollBarStyle.top=t+"px"}),checkScrollBarVisible();var paperTypes={note:{font:'"Skellyman", sans-serif',back_image:"url(asset://garrysmod/materials/unionrp/ui/static-paper.jpg)",back_color:"#caa363",margin_left:"0",html_text_size:"14px"},doc:{font:'"Machinetype", sans-serif',back_image:"url(asset://garrysmod/materials/unionrp/ui/static-doc.png)",back_color:"transparent",margin_left:"7%",html_text_size:"22px"}},body=document.body;function setDocType(e){var t=paperTypes[e];t&&(html.style.setProperty("font-size",t.html_text_size),body.style.setProperty("font-family",t.font),body.style.setProperty("background-color",t.back_color),body.style.setProperty("background-image",t.back_image),body.style.setProperty("margin-left",t.margin_left))}var maxTitleLength=46,maxTextLength=2048;function setMaxLength(e,t){maxTitleLength=e,maxTextLength=t}function setPaperTitle(e){0!=e.length&&(titleHeader.hidden=!1,paperTitle.innerText=e,checkScrollBarVisible(),checkMainTextHeight())}function setPaperText(e){0!=e.length&&(textMain.hidden=!1,isExtended?paperText.innerHTML=e:paperText.innerText=e,checkScrollBarVisible(),checkMainTextHeight())}function setExtended(){isExtended=!0}function setPaperSign(e,t,n){signFooter.hidden=!1,paperPlayerName.innerText=e,paperPlayerJob.innerText=t,paperPlayerJob.style.color=n,checkMainTextHeight()}function preventPasteNewLine(e){if(e){e.preventDefault();var t=(e.clipboardData||window.clipboardData).getData("text/plain");(t=t.replace(/(\r\n|\n|\r)/gm," ")).length+paperTitle.innerText.length>maxTitleLength&&(t=t.substring(0,maxTitleLength-paperTitle.innerText.length)),document.execCommand("insertText",!1,t)}}function preventPasteHTML(e){if(e){e.preventDefault();var t=(e.clipboardData||window.clipboardData).getData("text/plain");t.length+paperText.innerText.length>maxTextLength&&(t=t.substring(0,maxTextLength-paperText.innerText.length)),document.execCommand("insertText",!1,t)}}var whitelistKeyKodes={8:!0,37:!0,38:!0,39:!0,40:!0};function preventLimitAndNewLine(e){if(e&&!e.ctrlKey){var t=e.keyCode;(13===t||!whitelistKeyKodes[t]&&e.target.innerText.length>=maxTitleLength)&&(e.preventDefault(),checkScrollBarVisible())}}function preventLimitAndNewLineText(e){e&&!e.ctrlKey&&!whitelistKeyKodes[e.keyCode]&&e.target.innerText.length>=maxTextLength&&(e.preventDefault(),checkScrollBarVisible())}var isEditing=!1;function setEditState(e){if(isEditing=e)titleHeader.hidden=!1,textMain.hidden=!1,titleHeader.classList.remove("prevent-select"),textMain.classList.remove("prevent-select"),paperTitle.classList.add("outline-for-edit"),paperText.classList.add("outline-for-edit"),paperTitle.contentEditable=!0,paperText.contentEditable=!0,paperTitle.addEventListener("keydown",preventLimitAndNewLine,!1),paperTitle.addEventListener("paste",preventPasteNewLine,!1),paperText.addEventListener("keydown",preventLimitAndNewLineText,!1),paperText.addEventListener("paste",preventPasteHTML,!1),checkScrollBarVisible();else{titleHeader.classList.add("prevent-select"),textMain.classList.add("prevent-select"),paperTitle.classList.remove("outline-for-edit"),paperText.classList.remove("outline-for-edit"),paperTitle.contentEditable=!1,paperText.contentEditable=!1,paperTitle.removeEventListener("keydown",preventLimitAndNewLine,!1),paperTitle.removeEventListener("paste",preventPasteNewLine,!1),paperText.removeEventListener("keydown",preventLimitAndNewLineText,!1),paperText.removeEventListener("paste",preventPasteHTML,!1);var t=paperTitle.innerText.length;t<=0?titleHeader.hidden=!0:maxTitleLength<t&&(paperTitle.innerText=paperTitle.innerText.substring(0,maxTitleLength));var n=paperText.innerText.length;n<=0?textMain.hidden=!0:maxTextLength<n&&(paperText.innerText=paperText.innerText.substring(0,maxTextLength)),paperTitle.blur(),paperText.blur(),checkScrollBarVisible(),checkMainTextHeight()}}function toggleEdit(){setEditState(isEditing=!isEditing)}function triggerSave(){paper.saveText(paperTitle.innerText,paperText.innerText)}</script>
]]
surface.CreateFont("NoteFontTitle", {
	font = "Inter",
	size = 30,
	weight = 900,
	extended = true,
})

surface.CreateFont("NoteFontText", {
	font = "Inter",
	size = 20,
	weight = 900,
	extended = true,
})

surface.CreateFont("NoteFontText1", {
	font = "Inter",
	size = 15,
	weight = 900,
	extended = true,
})

surface.CreateFont("NoteFontText2", {
	font = "Inter",
	size = 15,
	weight = 900,
	extended = true,
})

local maxLength = ENT.maxTextLength
local maxTitleLength = ENT.maxTitleLength
local bColor = Color(15, 15, 15)
local function DrawOutlinedText(text, font, color, x, y)
	draw.SimpleText(text, font, x, y, color or bColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(text, font, x, y - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local viewDist = 200 * 200
local rotVector, rotAngle = Vector(-5, 0, 0.48), Angle(0, 90, 0)
function ENT:Draw(flags)
	self:DrawModel(flags)
	if not IsValid(self) then return end
	local distance = self:GetPos():DistToSqr(EyePos())
	if distance > viewDist then return end
	local pos, ang = LocalToWorld(rotVector, rotAngle, self:GetPos(), self:GetAngles())
	local title = self:GetTitle()
	cam.Start3D2D(pos, ang, 0.05)
	surface.SetDrawColor(37, 24, 12, 255)
	surface.DrawRect(-85, -22, 169.9, 35)
	if title ~= "" then
		local tbl = self.WrappedText
		if istable(tbl) then
			local i = 13
			for k, v in ipairs(tbl) do
				DrawOutlinedText(v, "NoteFontText2", nil, 0, -i)
				i = i - 16
			end
		else
			self.WrappedText = string.ExplodeBySize(title, 18)
		end
	else
		DrawOutlinedText(self.ShowName, "NoteFontTitle", nil, 0, 0)
	end

	local signedData = self:GetSignedData()
	if signedData then
		local name, job = signedData.name, signedData.job
		DrawOutlinedText("Подписано: " .. name, "NoteFontText", nil, 0, 190)
		DrawOutlinedText("(" .. job .. ")", "NoteFontText1", signedData.color, -1, 210)
	end

	cam.End3D2D()
end

netstream.Hook("paper.OpenPaper", function(ent)
	if IsValid(paperVGUI) then
		paperVGUI:Remove()
		paperVGUI = nil
	end

	local paper = vgui.Create("paperGUI")
	paper.paperPanel:QueueJavascript("setDocType('" .. ent.docType .. "')")
	paper.updated = ent:GetLastUpdate()
	paper:Update(ent)
	paperVGUI = paper
end)

local function S(v)
	return ScrH() * (v / 900)
end

surface.CreateFont("NoteFontUIText", {
	font = "Inter",
	size = S(18),
	weight = 500,
	extended = true,
})

local panel = {}
local function createButton(isFirst, parent, icon, tooltip, isEnabled, func)
	local cpb = parent:Add("DImageButton")
	cpb:Dock(TOP)
	cpb:DockMargin(0, isFirst and 0 or 10, 0, 0)
	cpb:SetTall(isFirst and S(26) or 16)
	cpb:SetImage(icon)
	-- cpb:SizeToContents()
	cpb:SetStretchToFit(false)
	cpb:SetTooltip(tooltip)
	cpb:SetEnabled(isEnabled)
	cpb.DoClick = func
	return cpb
end

function panel:Init()
	self:SetTitle("")

	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)
	self:ShowCloseButton(false)
	self.OnClose = function()
		if self.editing then
			self.editing = false
			netstream.Start("paper.EditState", self.ent, false)
		end
	end

	-- self:SetVisible(false)
	local pW, pH = S(700), S(800)
	self:SetSize(pW, pH)
	self.Paint = function(self, w, h) end

	local bSize = S(26)
	local paperPanel = self:Add("DHTML")
	paperPanel:Dock(FILL)
	-- paperPanel:OpenURL("asset://garrysmod/addons/unionrp_test1/html/paper.html")
	paperPanel:SetHTML(HTMLCode)
	paperPanel:AddFunction("paper", "saveText", function(title, text)
		local ent = self.ent
		if not IsValid(ent) then return end
		if title == ent:GetTitle() then title = false end
		if text == ent:GetText() then text = false end
		if title and title:utf8len() > maxTitleLength then title = title:utf8sub(1, maxTitleLength) end
		if text and text:utf8len() > maxLength then text = text:utf8sub(1, maxLength) end
		self.editing = false
		netstream.Start("paper.SaveText", self.ent, title, text)
	end)

	paperPanel:QueueJavascript("setMaxLength(" .. maxTitleLength .. ", " .. maxLength .. ")")
	self.paperPanel = paperPanel

	local instrumentPanel = self:Add("DPanel")
	instrumentPanel:Dock(RIGHT)
	instrumentPanel:SetWide(bSize)
	instrumentPanel.Paint = function(self, w, h) end
	self.instrumentPanel = instrumentPanel

	self.closeButton = createButton(true, instrumentPanel, "icons/fa32/close.png", "Закрыть", true, function() self:Close() end)

	self.controlButton1 = createButton(false, instrumentPanel, "icon16/page_delete.png", "Уничтожить документ", false, function()
		local dMenu = DermaMenu()
		local accept = dMenu:AddOption("Порвать", function() netstream.Start("paper.DeleteNote", self.ent) end)
		accept:SetIcon("icon16/accept.png")
		local cancel = dMenu:AddOption("Отменить")
		cancel:SetIcon("icon16/cancel.png")
		dMenu:Open()
	end)

	self.controlButton2 = createButton(false, instrumentPanel, "icon16/page_key.png", "Подписывает документ от Вашего имени", false, function()
		local dMenu = DermaMenu()
		local accept = dMenu:AddOption("Подписать", function()
			if self.editing then return end
			netstream.Start("paper.SignNote", self.ent)
			self.controlButton2:SetEnabled(false)
			self.controlButton3:SetEnabled(false)
			self.controlButton4:SetEnabled(false)
		end)

		accept:SetIcon("icon16/accept.png")
		local cancel = dMenu:AddOption("Отменить")
		cancel:SetIcon("icon16/cancel.png")
		dMenu:Open()
	end)

	self.controlButton3 = createButton(false, instrumentPanel, "icon16/page_edit.png", "Дает возможность изменить написанное", false, function()
		self.editing = not self.editing
		self.paperPanel:QueueJavascript("toggleEdit()")
		netstream.Start("paper.EditState", self.ent, self.editing)
	end)

	self.controlButton4 = createButton(false, instrumentPanel, "icon16/page_save.png", "Сохраняет текст", false, function()
		self.paperPanel:QueueJavascript("setEditState(false);triggerSave()")
		self.preventUpdate = true
		self.controlButton4:SetDisabled(true)
		self.controlButton4.coolDown = CurTime() + 3
		timer.Simple(3, function() if IsValid(self.controlButton4) and IsValid(self.ent) and not self.ent:GetSignedData() then self.controlButton4:SetDisabled(false) end end)
	end)

	self:MakePopup()
	self:Center()
end

local maxDist = 128 * 128
function panel:Update(ent)
	self.ent = ent
	if not IsValid(ent) then self:Remove() end
	if self.preventUpdate then
		self.preventUpdate = false
		return
	end

	local title = ent:GetTitle()
	local text = ent:GetText()
	local signedData = ent:GetSignedData()
	local signed = signedData ~= nil
	local owner = ent:GetPOwner()
	if title ~= "" then ent.WrappedText = string.ExplodeBySize(title, 18) end
	timer.Create("paper.checkEntLife", 0.3, 0, function()
		if not IsValid(paperVGUI) then
			timer.Remove("paper.checkEntLife")
			return
		end

		local lp = LocalPlayer()
		if not IsValid(ent) or ent:GetPos():DistToSqr(lp:GetPos()) >= maxDist or not lp:Alive() then
			paperVGUI:Remove()
			timer.Remove("paper.checkEntLife")
			return
		end

		local updated = self.updated
		local gLU = ent:GetLastUpdate()
		if gLU ~= updated then
			self.updated = gLU
			paperVGUI:Update(ent)
		end
	end)

	if ent:GetExtended() then self.paperPanel:QueueJavascript("setExtended()") end
	if title ~= "" then self.paperPanel:QueueJavascript("setPaperTitle('" .. string.JavascriptSafe(title) .. "')") end
	if text ~= "" then self.paperPanel:QueueJavascript("setPaperText('" .. string.JavascriptSafe(text) .. "')") end
	if not signed then
		self.controlButton2:SetEnabled(true)
	else
		local col = signedData.jobColor
		local jobColor = Color(col.r, col.g, col.b):ToHex()
		self.paperPanel:QueueJavascript("setPaperSign('" .. string.JavascriptSafe(signedData.name) .. "', '" .. string.JavascriptSafe(signedData.job) .. "', '" .. string.JavascriptSafe(jobColor) .. "')")
	end

	local phys = ent:GetPhysicsObject()
	if owner == LocalPlayer() or IsValid(phys) and phys:IsMoveable() then self.controlButton1:SetEnabled(true) end
	local cd = self.controlButton4.coolDown
	if owner == LocalPlayer() and not signed and (not cd or cd <= CurTime()) then
		self.controlButton3:SetEnabled(true)
		self.controlButton4:SetEnabled(true)
	end
end

function panel:OnRemove()
	paperVGUI = nil
end

vgui.Register("paperGUI", panel, "DFrame")
