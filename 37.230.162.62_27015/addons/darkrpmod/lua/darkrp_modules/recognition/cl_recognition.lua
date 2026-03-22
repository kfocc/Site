DarkRP.Recognition = DarkRP.Recognition or {}
DarkRP.Recognition.Recognised = DarkRP.Recognition.Recognised or {}

hook.Add("Think", "RecognitionThink", function()
	local lp = LocalPlayer()
	if not IsValid() then return end

	DarkRP.Recognition.Recognised[lp:EntIndex()] = true
	hook.Remove("Think", "RecognitionThink")
end)

function DarkRP.Recognition.Know(index)
	return DarkRP.Recognition.Recognised[index] or false
end

surface.CreateFont("RecognitionFont", {
	font = "Roboto",
	size = 20,
	weight = 500,
	additive = true,
	extended = true
})

local function AddButtonToFrame(Frame)
	Frame:SetTall(Frame:GetTall() + 110)

	local button = vgui.Create("DButton", Frame)
	button:SetPos(10, Frame:GetTall() - 110)
	button:SetSize(200, 100)
	button:SetFont("RecognitionFont")
	button:SetTextColor(color_white)

	function button:Paint(bw, bh)
		if self:IsHovered() then
			draw.RoundedBox(4, 0, 0, bw, bh, col.o)
		else
			draw.RoundedBox(4, 0, 0, bw, bh, col.ba)
		end
	end
	return button
end

local buts = {"Радиус шепота", "Радиус разговора", "Радиус крика"}
function DarkRP.Recognition.openMenu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(220, 30)
	frame:SetTitle("Раскрытие личности")
	frame:SetSkin(GAMEMODE.Config.DarkRPSkin)
	frame:MakePopup()

	for k, v in pairs(buts) do
		local b = AddButtonToFrame(frame)
		b:SetText(v)
		function b:DoClick()
			netstream.Start("Recognition.Say", k)
			frame:Remove()
		end
	end

	frame:Center()
end

netstream.Hook("Recognition.Add", function(index) DarkRP.Recognition.Recognised[index] = true end)
netstream.Hook("Recognition.Remove", function(index) DarkRP.Recognition.Recognised[index] = nil end)
netstream.Hook("Recognition.Clear", function() DarkRP.Recognition.Recognised = {} end)
local meta = FindMetaTable("Player")
function meta:isRecognised()
	return DarkRP.Recognition.Know(self:EntIndex())
end

function meta:GetResultNickname() -- в sv файле серверная
	local hidden = self:GetNetVar("HideName") or not self:isRecognised()
	return hidden and self:SteamID():sub(9) or self:Nick()
end

local function openMenu(setDoorOwnerAccess, doorSettingsAccess)
	local trace = LocalPlayer():GetEyeTrace()
	local ent = trace.Entity
	-- Don't open the menu if the entity is not ownable, the entity is too far away or the door settings are not loaded yet
	if not IsValid(ent) or not ent:isKeysOwnable() or trace.HitPos:DistToSqr(LocalPlayer():EyePos()) > 40000 then return end

	local Frame = vgui.Create("DFrame")
	Frame:SetSize(220, 30)
	Frame.btnMaxim:SetVisible(false)
	Frame.btnMinim:SetVisible(false)
	Frame:SetVisible(true)
	Frame:MakePopup()
	Frame:ParentToHUD()

	local entType = DarkRP.getPhrase(ent:IsVehicle() and "vehicle" or "door")
	Frame:SetTitle(DarkRP.getPhrase("x_options", entType:gsub("^%a", string.upper)))
	-- All the buttons
	if ent:isKeysOwnedBy(LocalPlayer()) then
		local Owndoor = AddButtonToFrame(Frame)
		Owndoor:SetText(DarkRP.getPhrase("sell_x", entType))
		Owndoor.DoClick = function()
			RunConsoleCommand("darkrp", "toggleown")
			Frame:Remove()
		end

		local AddOwner = AddButtonToFrame(Frame)
		AddOwner:SetText(DarkRP.getPhrase("add_owner"))
		AddOwner.DoClick = function()
			local menu = DermaMenu()
			menu.found = false
			for _, v in pairs(DarkRP.nickSortedPlayers()) do
				if not ent:isKeysOwnedBy(v) and not ent:isKeysAllowedToOwn(v) then
					local steamID = v:SteamID()
					menu.found = true
					menu:AddOption(v:Nick(), function() RunConsoleCommand("darkrp", "ao", steamID) end)
				end
			end

			if not menu.found then menu:AddOption(DarkRP.getPhrase("noone_available"), function() end) end
			menu:Open()
		end

		local RemoveOwner = AddButtonToFrame(Frame)
		RemoveOwner:SetText(DarkRP.getPhrase("remove_owner"))
		RemoveOwner.DoClick = function()
			local menu = DermaMenu()
			for _, v in pairs(DarkRP.nickSortedPlayers()) do
				if ent:isKeysOwnedBy(v) and not ent:isMasterOwner(v) or ent:isKeysAllowedToOwn(v) then
					local steamID = v:SteamID()
					menu.found = true
					menu:AddOption(v:Nick(), function() RunConsoleCommand("darkrp", "ro", steamID) end)
				end
			end

			if not menu.found then menu:AddOption(DarkRP.getPhrase("noone_available"), function() end) end
			menu:Open()
		end

		if not ent:isMasterOwner(LocalPlayer()) then RemoveOwner:SetDisabled(true) end
	end

	if doorSettingsAccess then
		local DisableOwnage = AddButtonToFrame(Frame)
		DisableOwnage:SetText(DarkRP.getPhrase(ent:getKeysNonOwnable() and "allow_ownership" or "disallow_ownership"))
		DisableOwnage.DoClick = function()
			Frame:Remove()
			RunConsoleCommand("darkrp", "toggleownable")
		end
	end

	if doorSettingsAccess and (ent:isKeysOwned() or ent:getKeysNonOwnable() or ent:getKeysDoorGroup() or hasTeams) or ent:isKeysOwnedBy(LocalPlayer()) then
		local DoorTitle = AddButtonToFrame(Frame)
		DoorTitle:SetText(DarkRP.getPhrase("set_x_title", entType))
		DoorTitle.DoClick = function()
			Derma_StringRequest(DarkRP.getPhrase("set_x_title", entType), DarkRP.getPhrase("set_x_title_long", entType), "", function(text)
				RunConsoleCommand("darkrp", "title", text)
				if IsValid(Frame) then Frame:Remove() end
			end, function() end, DarkRP.getPhrase("ok"), DarkRP.getPhrase("cancel"))
		end
	end

	if not ent:isKeysOwned() and not ent:getKeysNonOwnable() and not ent:getKeysDoorGroup() and not ent:getKeysDoorTeams() or not ent:isKeysOwnedBy(LocalPlayer()) and ent:isKeysAllowedToOwn(LocalPlayer()) then
		local Owndoor = AddButtonToFrame(Frame)
		Owndoor:SetText(DarkRP.getPhrase("buy_x", entType))
		Owndoor.DoClick = function()
			RunConsoleCommand("darkrp", "toggleown")
			Frame:Remove()
		end
	end

	if doorSettingsAccess then
		local EditDoorGroups = AddButtonToFrame(Frame)
		EditDoorGroups:SetText(DarkRP.getPhrase("edit_door_group"))
		EditDoorGroups.DoClick = function()
			local menu = DermaMenu()
			local groups = menu:AddSubMenu(DarkRP.getPhrase("door_groups"))
			local teams = menu:AddSubMenu(DarkRP.getPhrase("jobs"))
			local add = teams:AddSubMenu(DarkRP.getPhrase("add"))
			local remove = teams:AddSubMenu(DarkRP.getPhrase("remove"))
			menu:AddOption(DarkRP.getPhrase("none"), function()
				RunConsoleCommand("darkrp", "togglegroupownable")
				if IsValid(Frame) then Frame:Remove() end
			end)

			for k in pairs(RPExtraTeamDoors) do
				groups:AddOption(k, function()
					RunConsoleCommand("darkrp", "togglegroupownable", k)
					if IsValid(Frame) then Frame:Remove() end
				end)
			end

			local doorTeams = ent:getKeysDoorTeams()
			for k, v in pairs(RPExtraTeams) do
				local which = (not doorTeams or not doorTeams[k]) and add or remove
				which:AddOption(v.name, function()
					RunConsoleCommand("darkrp", "toggleteamownable", k)
					if IsValid(Frame) then Frame:Remove() end
				end)
			end

			menu:Open()
		end
	end

	hook.Call("onKeysMenuOpened", nil, ent, Frame)
	Frame:Center()
	Frame:SetSkin(GAMEMODE.Config.DarkRPSkin)
end

local function Open()
	local lp = LocalPlayer()
	local trace = lp:GetEyeTrace()
	local ent = trace.Entity
	if not IsValid(ent) or not ent:isKeysOwnable() or trace.HitPos:DistToSqr(lp:EyePos()) > 40000 then
		DarkRP.Recognition.openMenu()
		return
	end

	CAMI.PlayerHasAccess(lp, "DarkRP_SetDoorOwner", function(setDoorOwnerAccess) CAMI.PlayerHasAccess(lp, "DarkRP_ChangeDoorSettings", fp{openMenu, setDoorOwnerAccess}) end)
end

timer.Simple(0, function()
	DarkRP.openKeysMenu = Open
	GAMEMODE.ShowTeam = Open
end)
