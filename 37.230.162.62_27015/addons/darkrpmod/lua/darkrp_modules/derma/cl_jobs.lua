local category = "Police"
local sscale = ScreenScaleH
local ignore_weapons = {
	["hl2_hands"] = true,
	["keys"] = true,
	["pocket"] = true,
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["weapon_fists"] = true,
	["robbery"] = true,
	["door_ram"] = true,
	["weaponchecker"] = true,
}

surface.CreateFont("U.JobText", {
	font = "Roboto",
	size = ScreenScaleH(8),
	weight = 500,
	extended = true
})

local PANEL = {}
function PANEL:Init()
	-- self:ErisScrollbar()
end

local sscale50 = sscale(50)
local function createModelViewer(pnl, iconSize, mdl, teamTable, withoutMask)
	local mask = vgui.Create("ErisF4ModelMask", pnl)
	mask:SetPos(0, 0)
	mask:SetSize(iconSize, iconSize)
	mask:SetHoverColor(Eris.Config.UnifyJobBackdrops and Eris:Theme("itemhover") or teamTable.color)
	mask.Paint = nil

	local modelPanel = mask:GetModelPanel()
	modelPanel:SetCamPos(Vector(62.65, -17.22, 60.48))
	modelPanel:SetLookAng(Angle(-2.99, 165.24, 0.06))
	modelPanel:SetFOV(16.91)
	modelPanel:SetAnimated(false)
	modelPanel:SetModel(mdl)

	local entity = modelPanel:GetEntity()
	entity:SetIK(false)
	entity:ResetSequence(entity:SelectWeightedSequence(ACT_IDLE))
	if teamTable.BodyGroup then teamTable.BodyGroup(entity) end
	if withoutMask then
		local bg = entity:FindBodygroupByName("Mask")
		if bg then entity:SetBodygroup(bg, 0) end
	end
	return mask
end

local colorEmptyDark = Color(70, 70, 70, 100)
local colorBackAlpha = ColorAlpha(col.o, 120)
local colorBackDark = Color(55, 55, 55, 70)
local colorBack = Color(35, 35, 35, 200)
local colorGrayBack = Color(90, 90, 90, 200)
local colorBack2 = colorBack:darken(15)
local colorLockGreen = Color(0, 200, 0, 200)
local colorLockRed = Color(200, 0, 0, 200)
local jobNameCol = ColorAlpha(col.o, 200)
local unlock_icon, lock_icon = Material("icon16/lock_open.png"), Material("icon16/lock.png")
function PANEL:Setup()
	local selected = 1
	local sel_unlocked = true

	--[[
    MAIN FRAME
  --]]
	local frame = vgui.Create("DPanel", self)
	frame:Dock(TOP)
	frame:SetTall(self:GetTall() * 0.9)
	frame:InvalidateParent(true)
	frame.Paint = nil

	local leftPart = vgui.Create("DPanel", frame)
	leftPart:Dock(LEFT)
	leftPart:DockMargin(0, 0, 0, 0)
	leftPart:SetWide(self:GetWide() * 0.33)
	leftPart:InvalidateParent(true)
	leftPart.Paint = nil

	local rightPart = vgui.Create("DPanel", frame)
	rightPart:Dock(RIGHT)
	rightPart:DockMargin(0, 0, 0, 0)
	rightPart:SetWide(self:GetWide() * 0.66)
	rightPart:InvalidateParent(true)
	rightPart.Paint = function(_self, w, h) draw.RoundedBox(0, 0, 0, w, h, colorBack) end

	local sscale2 = sscale(2 * .8)
	local sscale3 = sscale(3 * .8)
	local sscale5 = sscale(5 * .8)
	local sscale10 = sscale(10 * .8)
	local sscale15 = sscale(15 * .8)
	local sscale20 = sscale(20 * .8)
	local sscale30 = sscale(30 * .8)

	-- #region right part of jobs menu
	local jobName = vgui.Create("DLabel", rightPart)
	jobName:Dock(TOP)
	jobName:SetTall(sscale20)
	jobName:DockMargin(sscale3, sscale10, sscale3, 0)
	jobName:SetFont("U.JobText")
	jobName:SetText("Test")
	jobName:SetTextColor(col.w)
	jobName:SetContentAlignment(5)
	jobName.Paint = function(_self, w, h) draw.RoundedBox(4, 0, 0, w, h, jobNameCol) end

	-- #region description
	local descPart = vgui.Create("DPanel", rightPart)
	descPart:Dock(TOP)
	descPart:SetTall(sscale(80))
	descPart:DockMargin(sscale10, sscale5, sscale10, 0)
	descPart.Paint = function(_self, w, h) draw.RoundedBox(4, 0, 0, w, h, colorBack2) end

	local descLabel = vgui.Create("DLabel", descPart)
	descLabel:Dock(TOP)
	descLabel:SetFont("U.JobText")
	descLabel:DockMargin(0, sscale3, 0, 0)
	descLabel:SetTextColor(col.w)
	descLabel:SetContentAlignment(5)
	descLabel:SetText("ОПИСАНИЕ")
	descLabel:SizeToContents()
	descLabel.Paint = nil

	local descText = vgui.Create("DTextEntry", descPart)
	descText:Dock(FILL)
	descText:DockMargin(sscale10, 0, sscale3, sscale3)
	descText:SetVerticalScrollbarEnabled(true)
	descText:SetFont("U.JobText")
	descText:SetTextColor(color_white)
	descText:SetMultiline(true)
	descText:SetPaintBackground(false)
	descText.OnChange = function(_self) if _self:GetValue() ~= _self.mainText then _self:SetValue(_self.mainText) end end

	-- descText.PerformLayout = function(self)
	--   self:SetFontInternal("U.JobText")
	--   self:SetVerticalScrollbarEnabled(false)
	--   self:InsertColorChange(255, 255, 255, 255)
	-- end
	-- descText:InsertColorChange(255, 255, 255, 255)
	-- descText.Paint = nil
	-- #endregion
	-- #region equip description part
	local equipPart = vgui.Create("DPanel", rightPart)
	equipPart:Dock(TOP)
	equipPart:SetTall(sscale(30) * 1.75)
	equipPart:DockMargin(sscale10, sscale5, sscale10, 0)
	equipPart.Paint = function(_self, w, h) draw.RoundedBox(4, 0, 0, w, h, colorBack2) end

	local weaponLabel = vgui.Create("DLabel", equipPart)
	weaponLabel:Dock(TOP)
	weaponLabel:SetFont("U.JobText")
	weaponLabel:DockMargin(0, sscale3, 0, 0)
	weaponLabel:SetTextColor(col.w)
	weaponLabel:SetContentAlignment(5)
	weaponLabel:SetText("ЭКИПИРОВКА")
	weaponLabel:SizeToContents()
	weaponLabel.Paint = nil

	local weaponText = vgui.Create("DTextEntry", equipPart)
	weaponText:Dock(FILL)
	weaponText:DockMargin(sscale10, 0, sscale3, sscale3)
	weaponText:SetVerticalScrollbarEnabled(true)
	weaponText:SetFont("U.JobText")
	weaponText:SetTextColor(color_white)
	weaponText:SetMultiline(true)
	weaponText:SetPaintBackground(false)
	weaponText.OnChange = function(_self) if _self:GetValue() ~= _self.mainText then _self:SetValue(_self.mainText) end end

	-- weaponText.PerformLayout = function(self)
	--   self:SetFontInternal("U.JobText")
	--   self:SetVerticalScrollbarEnabled(false)
	--   self:InsertColorChange(255, 255, 255, 255)
	-- end
	-- weaponText:InsertColorChange(255, 255, 255, 255)
	-- weaponText.Paint = nil
	-- #endregion
	-- #endregion
	-- #region unlock with button and icon part
	local unlockPart = vgui.Create("DPanel", rightPart)
	unlockPart:Dock(BOTTOM)
	unlockPart:SetTall(sscale20)
	unlockPart:DockMargin(sscale15, sscale15, sscale15, sscale15)
	unlockPart.Paint = nil

	local unlockIcon = vgui.Create("DPanel", unlockPart)
	unlockIcon:Dock(LEFT)
	unlockIcon:SetWide(sscale(15))
	local icon_w, icon_h = sscale(7.5), sscale(7.5)
	unlockIcon.Paint = function(_self, w, h)
		local ccol = sel_unlocked and colorLockGreen or colorLockRed
		draw.RoundedBox(4, 0, 0, w, h, ccol)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, col.ba)

		surface.SetDrawColor(ccol)
		surface.SetMaterial(sel_unlocked and unlock_icon or lock_icon)
		surface.DrawTexturedRect(w / 2 - icon_w / 2, h / 2 - icon_h / 2, icon_w, icon_h)

	end

	local selectedMdl = ""
	local unlockButton = vgui.Create("DButton", unlockPart)
	unlockButton:Dock(FILL)
	unlockButton:DockMargin(sscale2, 0, sscale2, 0)
	unlockButton:SetFont("U.JobText")
	unlockButton:SetTextColor(col.w)
	unlockButton.Paint = function(_self, w, h) draw.RoundedBox(4, 0, 0, w, h, colorGrayBack) end

	unlockButton.DoClick = function(_self, w, h)
		if sel_unlocked then
			GetJob(selected)
		else
			local jobTable = RPExtraTeams[selected]
			if not jobTable then return end

			local required = jobTable and jobTable.requireUnlock
			if required and not Job.Unlocks[RPExtraTeams[required].command] then return end

			local list = vgui.Create("MList")
			list:AddItem("Вы уверены?")
			list:AddItem("")
			list:AddItem("Да, я уверен!", function()
				net.Start("Job.UnlockJob")
				net.WriteInt(selected, 13)
				net.SendToServer()
			end)

			list:AddItem("Нет.", function() end)
		end
	end

	-- #endregion

	local modelsListPart = vgui.Create("DPanel", rightPart)
	modelsListPart:Dock(BOTTOM)
	modelsListPart:SetTall(rightPart:GetTall() - jobName:GetTall() - descPart:GetTall() - equipPart:GetTall() - unlockPart:GetTall() - sscale5 * 4 - sscale10 * 3)

	modelsListPart:DockMargin(sscale10, sscale5, sscale10, 0)
	modelsListPart.Paint = function(_self, w, h) draw.RoundedBox(4, 0, 0, w, h, colorBack2) end

	local modelsScroller = vgui.Create("DHorizontalScroller", modelsListPart)
	modelsScroller:Dock(FILL)
	modelsScroller:DockMargin(sscale5, sscale5, sscale5, 0)
	modelsScroller:SetOverlap(-4)
	-- #endregion

	local function UpdateDescription(job, mdl)
		selected = job or selected
		local tbl = RPExtraTeams[selected]
		local j_name = (tbl.vip and "[VIP] " or "") .. tbl.name
		jobName:SetText(" // " .. j_name)
		jobName:SizeToContents()
		jobName:SetWide(jobName:GetWide() * 1.2)

		sel_unlocked = not tbl.unlockCost or Job.Unlocks[tbl.command]
		local max, cur = tbl.max or 0, team.NumPlayers(selected)
		local required = tbl.requireUnlock
		unlockButton:SetText(sel_unlocked and (max == 0 and "Применить" or max > cur and "Применить [" .. cur .. "/" .. max .. "]" or "Достигнут лимит") or (required and not Job.Unlocks[RPExtraTeams[required].command]) and "Необходимо открыть " .. RPExtraTeams[required].name or "Можно приобрести за " .. DarkRP.formatMoney(tbl.unlockCost))

		local sel_description = tostring(tbl.description) or "Unknown"
		local description = ""
		if tbl.salary then description = description .. "- Зарплата: " .. DarkRP.formatMoney(tbl.salary) .. "\n" end

		local maxHealth = tbl.maxhealth or 100
		if maxHealth > 5000 then maxHealth = "∞" end
		description = description .. "- HP: " .. maxHealth .. ", "

		local armor = tbl.armor or 0
		local maxArmor = tbl.maxarmor or 100
		description = description .. "Armor: ( " .. armor .. " / " .. maxArmor .. " )"
		if tbl.lives and tbl.lives > 0 then description = description .. "\n- Жизней: " .. tbl.lives end
		description = description .. "\n\nОписание:\n" .. sel_description

		descText.mainText = description
		descText:SetText(description)

		local sel_weapons = ""
		local weps = table.Merge(tbl.weapons, tbl.weaponsinbox or {})
		for k, v in pairs(weps) do
			if ignore_weapons[v] then continue end
			local name
			local listData = list.Get("Weapon")[v]
			if listData and listData.PrintName then
				name = language.GetPhrase(listData.PrintName)
			else
				name = weapons.Get(v) and weapons.Get(v).PrintName or v
			end

			sel_weapons = sel_weapons .. "- " .. name .. "\n"
		end

		if sel_weapons == "" then sel_weapons = "- Стандартная" end

		weaponText.mainText = sel_weapons
		weaponText:SetText(sel_weapons)

		modelsScroller:Clear()

		selectedMdl = DarkRP.getPreferredJobModel(selected) or mdl or ""
		local matOverlay_Hovered = Material("gui/ContentIcon-hovered.png")
		local function modelPaint(_self, w, h)
			if _self.MousePressed then draw.RoundedBox(0, 0, 0, w, h, col.o) end

			if _self:GetModelPanel():GetModel() == selectedMdl then draw.RoundedBox(0, 0, h - sscale3, w, sscale3, col.o) end

			if _self:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(matOverlay_Hovered)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end

		local function modelClick(_self)
			selectedMdl = _self:GetModelPanel():GetModel()
			if selectedMdl ~= "" and selectedMdl ~= DarkRP.getPreferredJobModel(selected) then DarkRP.setPreferredJobModel(selected, selectedMdl) end

			surface.PlaySound("buttons/button9.wav")
		end

		local modelsList = tbl.model
		if istable(modelsList) then
			if #modelsList == 1 then selectedMdl = modelsList[1] end

			local scrollTo
			for _, model in ipairs(modelsList) do
				local res = createModelViewer(modelsScroller, sscale50, model, tbl, TEAM_GORDON)
				res.PaintOver = modelPaint
				res.DoClick = modelClick
				modelsScroller:AddPanel(res)
				if string.lower(model) == selectedMdl then scrollTo = res end
			end

			if scrollTo then modelsScroller:ScrollToChild(scrollTo) end
		elseif isstring(modelsList) then
			selectedMdl = modelsList
			local res = createModelViewer(modelsScroller, sscale50, modelsList, tbl, TEAM_GORDON)
			res.PaintOver = modelPaint
			res.DoClick = modelClick
			res.OnMousePressed = setSelection
			res.OnMouseReleased = unSetSelection
			modelsScroller:AddPanel(res)
		end
	end
	UpdateDescription()

	-- #region left part of job menu
	local leftPartScroll = vgui.Create("DScrollPanel", leftPart)
	leftPartScroll:Dock(FILL)
	leftPartScroll.Paint = nil

	local sbar = leftPartScroll:GetVBar()
	sbar:SetWide(sscale2)
	sbar:SetHideButtons(true)
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.b)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.o)
	end

	for jobIndex, job in ipairs(RPExtraTeams) do
		if job.type and job.type ~= category then continue end

		local can = hook.Run("playerCanChangeTeam", LocalPlayer(), jobIndex, false)
		if can == false then continue end

		local jobPanel = vgui.Create("DPanel", leftPartScroll)
		jobPanel:Dock(TOP)
		jobPanel:DockMargin(0, 0, sscale3, sscale3)
		jobPanel:SetTall(sscale30 * 1.5)
		local sscale1 = sscale(1)
		jobPanel.Paint = function(_self, w, h)
			if selected == job.team then
				draw.RoundedBoxEx(16, 0, 0, w, h, colorBackAlpha, true, true)
				draw.RoundedBoxEx(16, sscale1, sscale1, w - sscale2, h - sscale2, colorBack, true, true)
			else
				draw.RoundedBoxEx(16, 0, 0, w, h, colorBackDark, true, true)
				draw.RoundedBoxEx(16, sscale1, sscale1, w - sscale2, h - sscale2, colorBack, true, true)
			end
		end

		local sscale64 = sscale(40)
		local modelsList = job.model
		local preferred = DarkRP.getPreferredJobModel(jobIndex)
		local models = istable(modelsList) and modelsList or {modelsList}
		local mdl = models[math.random(#models)]
		if preferred then
			for _, model in ipairs(models) do
				if model:lower() == preferred then
					mdl = model
					break
				end
			end
		end

		local mask = createModelViewer(jobPanel, sscale64, mdl, job)
		mask:Dock(LEFT)
		mask:SetWide(sscale64)
		self.mask = mask

		-- local sscale15 = sscale(15)
		local name = vgui.Create("DLabel", jobPanel)
		name:Dock(TOP)
		name:DockMargin(sscale5, sscale10, 0, 0)
		name:SetText(job.name .. (job.vip and " | VIP" or ""))
		name:SetFont("U.JobText")
		name:SetTextColor(Eris:Theme("itemname"))
		name:SizeToContents()

		local unlockCost = job.unlockCost
		if unlockCost then
			local unlockCostLabel = vgui.Create("DLabel", jobPanel)
			unlockCostLabel:Dock(TOP)
			unlockCostLabel:DockMargin(sscale3, sscale3, 0, 0)
			unlockCostLabel:SetText(DarkRP.formatMoney(unlockCost or 0))
			unlockCostLabel:SetFont("U.JobText")
			unlockCostLabel:SetTextColor(Eris:Theme("itemname"))
			unlockCostLabel:SizeToContents()
		end

		if unlockCost and not Job.Unlocks[job.command] then
			local lockIcon = vgui.Create("DImage", jobPanel)
			lockIcon:SetSize(sscale(7), sscale(7))
			lockIcon:SetZPos(1)
			lockIcon:SetImage("icon16/lock.png")
		end

		local sscale4 = sscale(4)
		local max = job.max and math.max(job.max, 0) or 0
		if max and max > 0 then
			local count = vgui.Create("DPanel", jobPanel)
			count:Dock(BOTTOM)
			count:SetZPos(-2)
			count:SetTall(sscale4)
			count.Paint = function(s, w, h)
				local countPlayers = team.NumPlayers(job.team)
				local colFull = ColorAlpha(job.color, 100)
				local colEmpty = colorEmptyDark
				local seg = w / max
				for i = 1, max do
					local sx, sy, sw, sh = seg * (i - 1) + sscale1, sscale1, seg - sscale2, h
					local clr = i <= countPlayers and colFull or colEmpty
					draw.RoundedBox(2, sx, sy, sw, sh, clr)
				end
			end
		end

		local sscale240 = sscale(240)
		local clickable = vgui.Create("DButton", jobPanel)
		clickable:SetZPos(99)
		clickable:SetPos(0, 0)
		clickable:SetSize(sscale240, jobPanel:GetTall())
		clickable:SetText("")
		clickable.Paint = nil
		clickable.DoClick = function() UpdateDescription(job.team, mdl) end
	end
	-- #endregion
end
vgui.Register("UnionJobs", PANEL, "DScrollPanel")

local f4
function OpenJob(_category)
	if IsValid(DarkRP.f4) then
		-- DarkRP.f4:Remove()
		DarkRP.f4:SetActivePanel("UnionJobs")
		DarkRP.f4:SetTitleText("Профессии")
		return
	end

	category = _category or category

	DarkRP.f4 = vgui.Create("ErisF4")
	DarkRP.f4:SetActivePanel("UnionJobs")
	DarkRP.f4:SetTitleText("Профессии")
end

local GetJobCD = 0
function GetJob(num)
	if (GetJobCD or 0) >= CurTime() then return end
	GetJobCD = CurTime() + 2
	-- if IsValid(DarkRP.f4) then
	--   DarkRP.f4:Remove()
	-- end
	if IsValid(DialogSys.vgui.DialogueMenu) then DialogSys.vgui.DialogueMenu:Remove() end

	netstream.Start("Jobs.GetTeam", num)
end

net.Receive("Job.UnlocksUpdate", function()
	Job.Unlocks = net.ReadTable()
	if IsValid(DarkRP.f4) then OpenJob() end
end)

hook.Add("OnPlayerChangedTeam", "UnionJobsClose", function() if IsValid(f4) then f4:Remove() end end)
