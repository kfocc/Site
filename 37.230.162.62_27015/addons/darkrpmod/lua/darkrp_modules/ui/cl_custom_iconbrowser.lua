do
	local PANEL = {}
	local local_IconList = nil
	local function recursiveSearch(tab, path)
		coroutine.wait(0.1)
		local files, folders = file.Find("materials/" .. path .. "/*", "GAME")
		local curPath = path .. "/"
		for k, v in ipairs(files) do
			if v:EndsWith(".png") then tab[#tab + 1] = curPath .. v end
		end

		if not table.IsEmpty(folders) then
			for _, v in ipairs(folders) do
				recursiveSearch(tab, path .. "/" .. v)
			end
		end
		return tab
	end

	function PANEL:FillByPath(path)
		if not path or not isstring(path) then return end
		CreateLuaThread(function()
			self.Filled = true
			self:SetBackgroundColor(Color(155, 155, 155))
			if not local_IconList then local_IconList = recursiveSearch({}, path) end
			local i = 0
			for k, v in SortedPairs(local_IconList) do
				if not IsValid(self) then return end
				if not IsValid(self.IconLayout) then return end
				i = i + 1

				local btn = self.IconLayout:Add("DImageButton")
				btn.FilterText = string.lower(v)

				btn:SetOnViewMaterial(v)

				btn:SetTooltip(btn:GetImage())
				btn:SetSize(40, 40)
				btn:SetPos(-22, -22)
				btn:SetStretchToFit(false)
				btn:SetColor(color_white)

				btn.DoClick = function()
					self.m_pSelectedIcon = btn
					self.m_strSelectedIcon = btn:GetImage()
					self:OnChangeInternal()
				end

				btn.Paint = function(btn, w, h)
					if self.m_pSelectedIcon ~= btn then return end
					derma.SkinHook("Paint", "Selection", btn, w, h)
				end

				if not self.m_pSelectedIcon or self.m_strSelectedIcon == btn:GetImage() then self.m_pSelectedIcon = btn end
				self.IconLayout:Layout()
				if i >= 50 then
					i = 0
					coroutine.wait(0.01)
				end
			end
		end)
	end

	vgui.Register("DIconBrowserCustom", PANEL, "DIconBrowser")
end

function Derma_OpenIconBrowserCustom(cb, cbOnChange)
	if IsValid(Derma_IconBrowserCustom) then
		Derma_IconBrowserCustom:Remove()
		-- Derma_IconBrowserCustom:SetVisible(true)
		-- Derma_IconBrowserCustom:MakePopup()
		-- return Derma_IconBrowserCustom
	end

	local Derma_IconBrowser = vgui.Create("DFrame")
	Derma_IconBrowser:SetTitle("Derma Icon Browser")
	Derma_IconBrowser:SetIcon("icons/fa32/file-picture-o.png")
	Derma_IconBrowser:SetScreenLock(true)
	Derma_IconBrowser:SetSizable(true)
	_G.Derma_IconBrowserCustom = Derma_IconBrowserCustom
	local minFrameW, minFrameH = 250, 200
	local frameW, frameH = cookie.GetNumber("Derma_IconBrowser_W", 400), cookie.GetNumber("Derma_IconBrowser_H", 400)

	if frameW > ScrW() or frameH > ScrH() then
		frameW, frameH = 400, 400
		cookie.Delete("Derma_IconBrowser_W")
		cookie.Delete("Derma_IconBrowser_H")
	end

	Derma_IconBrowser.OnScreenSizeChanged = function(self)
		self:SetSize(math.min(self:GetWide(), ScrW()), math.min(self:GetTall(), ScrH()))
		cookie.Set("Derma_IconBrowser_W", self:GetWide())
		cookie.Set("Derma_IconBrowser_H", self:GetTall())
		self.m_bStoreResize = false
	end

	Derma_IconBrowser.OnSizeChanged = function(self)
		if self.m_bStoreResize ~= false then
			self.m_bStoreResize = true
		else
			self.m_bStoreResize = nil
		end
	end

	Derma_IconBrowser.OnMouseReleased = function(self)
		if self.m_bStoreResize then
			self.m_bStoreResize = nil
			cookie.Set("Derma_IconBrowser_W", self:GetWide())
			cookie.Set("Derma_IconBrowser_H", self:GetTall())
		end

		DFrame.OnMouseReleased(self)
	end

	Derma_IconBrowser.OnClose = function(self)
		if not cb then return end
		local selectedIcon = self.IconBrowser:GetSelectedIcon()
		if selectedIcon then pcall(cb, selectedIcon) end
	end

	Derma_IconBrowser:SetSize(frameW, frameH)
	Derma_IconBrowser:SetMinimumSize(minFrameW, minFrameH)
	Derma_IconBrowser:Center()
	Derma_IconBrowser:MakePopup()
	local copyIconSize = 16
	local copyIconSpacing = 5
	local matCopyIcon = Material("icon16/page_copy.png")
	Derma_IconBrowser.PaintOver = function(self)
		if self.m_nCopiedTime and SysTime() <= self.m_nCopiedTime then
			local wasEnabled = DisableClipping(true)
			local slideAnimFrac = 1 - math.TimeFraction(self.m_nCopiedTime - 1, self.m_nCopiedTime, SysTime())
			local fadeAnimFrac = 1 - math.max(math.TimeFraction(self.m_nCopiedTime - .75, self.m_nCopiedTime, SysTime()), 0)
			surface.SetFont("BudgetLabel")
			surface.SetTextColor(255, 255, 255, fadeAnimFrac * 255)
			local mouseX, mouseY = self:ScreenToLocal(input.GetCursorPos())
			local textW, textH = surface.GetTextSize(self.m_strCopiedIcon)
			local textX = mouseX - (textW - copyIconSize - copyIconSpacing) / 2
			local textY = mouseY + textH + (1 - slideAnimFrac) * textH + 5
			surface.SetTextPos(textX, textY)
			surface.DrawText(self.m_strCopiedIcon)
			local copyIconX = textX - copyIconSize - copyIconSpacing
			local copyIconY = textY - (math.max(textH, copyIconSize) - math.min(textH, copyIconSize)) / 2
			surface.SetDrawColor(255, 255, 255, fadeAnimFrac * 255)
			surface.SetMaterial(matCopyIcon)
			surface.DrawTexturedRect(copyIconX, copyIconY, copyIconSize, copyIconSize)
			DisableClipping(wasEnabled)
		end
	end

	local IconBrowser = Derma_IconBrowser:Add("DIconBrowserCustom")
	IconBrowser:Dock(FILL)
	IconBrowser:SetManual(true)
	IconBrowser:FillByPath("icons/fa32")
	IconBrowser.OnChange = function(self)
		local selectedIcon = self:GetSelectedIcon()
		Derma_IconBrowser.m_nCopiedTime = SysTime() + 1
		Derma_IconBrowser.m_strCopiedIcon = selectedIcon
		SetClipboardText(Derma_IconBrowser.m_strCopiedIcon)
		surface.PlaySound("garrysmod/content_downloaded.wav")
		if cb and selectedIcon then pcall(cbOnChange, selectedIcon) end
	end

	Derma_IconBrowser.IconBrowser = IconBrowser
	local BottomPanel = Derma_IconBrowser:Add("DPanel")
	BottomPanel:MoveToBefore(IconBrowser)
	BottomPanel:Dock(BOTTOM)
	BottomPanel:DockMargin(0, 3, 0, 0)
	BottomPanel:SetTall(24)
	BottomPanel.Paint = function() end

	local AcceptButton = BottomPanel:Add("DButton")
	AcceptButton:Dock(RIGHT)
	AcceptButton:SetWide(Derma_IconBrowser:GetWide() * 0.2)
	AcceptButton:SetImage("icon16/accept.png")
	AcceptButton:SetText("Принять")
	AcceptButton.DoClick = function(self) Derma_IconBrowser:Close() end

	local Search = BottomPanel:Add("DTextEntry")
	Search:MoveToBefore(BottomPanel)
	Search:Dock(FILL)
	Search:SetPlaceholderText("#spawnmenu.search")
	Search:SetUpdateOnType(true)
	Search.OnValueChange = function(self) IconBrowser:FilterByText(Search:GetValue():Trim()) end
	Derma_IconBrowser.Search = Search

	local SearchIcon = Search:Add("DImage")
	SearchIcon:SetImage("icon16/zoom.png")
	SearchIcon:Dock(RIGHT)
	SearchIcon:DockMargin(4, 4, 4, 4)
	SearchIcon:SetSize(16, 16)
	Derma_IconBrowser:SetDeleteOnClose(false)
	return Derma_IconBrowser
end

concommand.Add("derma_icon_browser_custom", Derma_OpenIconBrowserCustom, nil, "Opens the Derma Icon Browser", FCVAR_DONTRECORD)
