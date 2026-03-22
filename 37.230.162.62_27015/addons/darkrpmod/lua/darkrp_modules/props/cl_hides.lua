local AccsesGroup = {
	overwatch = true,
	assistant_nabor = true,
	advisor_nabor = true,
	event_boss_nabor = true,
	event_nabor = true,
}

local tabstoremove = {
	[language.GetPhrase("spawnmenu.content_tab")] = function()
		local lp = LocalPlayer()
		return not lp:IsEventer() and not lp:IsSuperAdmin()
	end,
	[language.GetPhrase("spawnmenu.category.npcs")] = function()
		local lp = LocalPlayer()
		return not lp:IsSuperAdmin() and (lp:Team() ~= TEAM_ADMIN or not (lp:GetNetVar("cats.AllowNPCSpawn") or AccsesGroup[lp:GetUserGroup()]))
	end,
	[language.GetPhrase("spawnmenu.category.entities")] = function()
		local lp = LocalPlayer()
		return not lp:IsEventer() and not lp:IsSuperAdmin()
	end,
	[language.GetPhrase("spawnmenu.category.weapons")] = function()
		local lp = LocalPlayer()
		return not lp:IsEventer() and not lp:IsSuperAdmin()
	end,
	[language.GetPhrase("spawnmenu.category.vehicles")] = function()
		local lp = LocalPlayer()
		return not lp:IsEventer() and not lp:IsSuperAdmin()
	end,
	[language.GetPhrase("spawnmenu.category.postprocess")] = true,
	[language.GetPhrase("spawnmenu.category.dupes")] = true,
	[language.GetPhrase("spawnmenu.category.saves")] = true
}

local function RemoveSandboxTabs()
	--local ply = LocalPlayer()
	--if ply:IsSuperAdmin() then return end
	for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
		local func = tabstoremove[v.Tab:GetText()]
		local isClosed = false
		if func == true or isfunction(func) and func() and v.Tab:IsVisible() then
			v.Tab:SetVisible(false)
			isClosed = true
		elseif isfunction(func) and not func() then
			if not v.Tab:IsVisible() then v.Tab:SetVisible(true) end
		end

		if isClosed then
			-- g_SpawnMenu.CreateMenu:SwitchToName("Строительство")
			g_SpawnMenu.CreateMenu:InvalidateLayout()
		end
	end
end

hook.Add("SpawnMenuOpen", "blockmenutabs", RemoveSandboxTabs)
hook.Remove("SpawnMenuOpened", "blockmenutabs", RemoveSandboxTabs)
local acceptedCategory = {
	["Zombies + Enemy Aliens"] = true,
	["Combine"] = true
}

hook.Add("SpawnMenuOpen", "RemoveOtherNPCS", function()
	local lp = LocalPlayer()
	if lp:IsSuperAdmin() or AccsesGroup[lp:GetUserGroup()] then return end
	for _, Category in pairs(g_SpawnMenu.CreateMenu.Items) do
		if Category.Name == "#spawnmenu.category.npcs" then
			local parents = Category.Panel:GetChildren()[1]
			if not IsValid(parents) then continue end
			local treeNodes = parents.ContentNavBar.Tree:Root():GetChildNodes()
			for k, v in ipairs(treeNodes) do
				if not acceptedCategory[v:GetText()] then v:Remove() end
			end
		end
	end
end)
