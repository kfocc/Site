include("schat2_config.lua")
include("vgui/cl_basepanel.lua")

if SChat2.Panel and IsValid(SChat2.Panel) then
	SChat2.Panel:Remove()
	SChat2.Panel = nil
end

SChat2.AddChat = SChat2.AddChat or chat.AddText

local meta = FindMetaTable("Player")
function meta:ChatPrint(str)
	chat.AddText(str)
end

local function parseArgs(...)
	local args = {}
	for _, v in pairs({...}) do
		if v then table.insert(args, v) end
	end
	return args
end

function chat.AddText(...)
	if not SChat2.Panel then
		SChat2.Panel = vgui.Create("SChat2Base")
		SChat2.Panel:ChatHide()
	end

	local args = parseArgs(...)
	SChat2.AddChat(unpack(args))
	SChat2.Panel:AddNewLine(args)
end

function chat.GetChatBoxPos()
	if not SChat2.Panel then
		SChat2.Panel = vgui.Create("SChat2Base")
		SChat2.Panel:ChatHide()
	end
	return SChat2.Panel:GetPos()
end

function chat.GetChatBoxSize()
	if not SChat2.Panel then
		SChat2.Panel = vgui.Create("SChat2Base")
		SChat2.Panel:ChatHide()
	end
	return SChat2.Panel:GetSize()
end

hook.Add("HUDShouldDraw", "SChat2HideHUD", function(v) if v == "CHudChat" then return false end end)
local notifyHint = false
hook.Add("PlayerBindPress", "SChat2BindPress", function(ply, bind, pressed)
	if ply ~= LocalPlayer() then return end
	if bind == "messagemode" and pressed then
		if not IsValid(SChat2.Panel) then SChat2.Panel = vgui.Create("SChat2Base") end
		SChat2.Panel:ChatShow()
		if not notifyHint then
			notifyHint = true
			DarkRP.notify(0, 4, "Вы можете изменить режим чата нажав на Tab.")
		end
		return true
	elseif bind == "messagemode2" and pressed then
		if not IsValid(SChat2.Panel) then SChat2.Panel = vgui.Create("SChat2Base") end
		SChat2.Panel:ChatShow()
		SChat2.Panel.isTeam = SChat2.Panel:GetChatTypeInt()
		SChat2.Panel:SetChatType("/g")
		if not notifyHint then
			notifyHint = true
			DarkRP.notify(3, 4, "Вы можете изменить режим чата нажав на Tab.")
		end
		return true
	end
end)

hook.Add("OnPlayerChat", "SChat2Handle", function(ply, msg, team, dead, prefixText, col1, col2)
	if SChat2.Panel then
		if prefixText then
			prefixText = prefixText .. ": "
			-- prefixText = string.Replace(prefixText, ply:Nick() .. ": ", "")
			chat.AddText(col1, prefixText, col2, msg)
		else --Most likely a server 'say' message
			chat.AddText(Color(143, 218, 230), msg)
		end
		return true
	end
end, HOOK_LOW)

hook.Add("OnPauseMenuShow", "SChat2HideChat", function()
	if SChat2.Panel and SChat2.Panel.Displayed then
		SChat2.Panel:ChatHide()
		return false
	end
end)

net.Receive("SChat2Message", function()
	local str = net.ReadString()
	chat.AddText(Color(151, 211, 255), str)
end)

net.Receive("SChat2Message2", function()
	local tbl = net.ReadTable()
	chat.AddText(unpack(tbl))
end)

net.Receive("chat.PrivateMessage", function()
	local tab = net.ReadTable()
	if not tab then return end
	local senderSid = tab.steamID
	local targetSid = tab.targetID
	local senderName = tab.senderName
	local targetName = tab.targetName
	local teamColor = tab.teamColor
	local messageColor = tab.messageColor
	local message = tab.message
	if SChat2.BlockedUsers[senderSid] then return end
	if senderSid ~= LocalPlayer():SteamID() then
		chat.AddText(col.o, "[PM] от ", teamColor, senderName)
		if SChat2:GetConvar("playPMSound", true) then surface.PlaySound("ambient/water/rain_drip1.wav") end
	end

	if IsValid(SChat2.Panel) then SChat2.Panel:AddPrivateMessage(senderSid, targetSid, teamColor, senderName, targetName, messageColor, message) end
end)
