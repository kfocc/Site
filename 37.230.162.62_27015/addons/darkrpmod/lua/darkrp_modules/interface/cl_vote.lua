local bind_key_y = CreateClientConVar("union_vote_y_key", KEY_EQUAL, true, false, "Биндит кнопку голосования(За).")
local bind_key_n = CreateClientConVar("union_vote_n_key", KEY_MINUS, true, false, "Биндит кнопку голосования(Против).")
if bind_key_y:GetInt() == KEY_F7 then bind_key_y:SetInt(KEY_EQUAL) end
if bind_key_n:GetInt() == KEY_F8 then bind_key_n:SetInt(KEY_MINUS) end

local keyY, keyN = bind_key_y:GetInt(), bind_key_n:GetInt()
local currentVotes = Stack()
--1 символ - 8 пикселей(в среднем)
local function parseText(pixels)
	if pixels <= 8 then return 8 end
	return math.ceil(pixels / 8)
end

local function MsgDoVote(ans)
	if not IsValid(LocalPlayer()) then return end

	local question = net.ReadString()
	local voteid = net.ReadString()
	local timeleft = net.ReadFloat()
	if timeleft == 0 then timeleft = 100 end

	currentVotes:Push({
		quest = question,
		id = voteid,
		timeneed = timeleft,
		oldtime = CurTime(),
		ans = ans
	})

	if not string.find(voteid, "searchSmugglerOrThief", 1, true) then -- temporary solution
		LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	end

	keyY, keyN = input.GetKeyName(bind_key_y:GetInt() or KEY_EQUAL), input.GetKeyName(bind_key_n:GetInt() or KEY_MINUS)
end

net.Receive("DoVote", MsgDoVote)
net.Receive("DoQuestion", function() MsgDoVote(true) end)

function DarkRP.DoQuestion(params)
	currentVotes:Push({
		quest = params.question,
		timeneed = params.timeleft or 100,
		oldtime = CurTime(),
		callback = params.callback
	})

	local snd = "Town.d1_town_02_elevbell1"
	if params.sound then
		snd = params.sound
	elseif params.nosound then
		snd = nil
	end

	if snd then LocalPlayer():EmitSound(snd, 100, 100) end
	keyY, keyN = input.GetKeyName(bind_key_y:GetInt() or KEY_EQUAL), input.GetKeyName(bind_key_n:GetInt() or KEY_MINUS)
end

local function KillVoteVGUI()
	local id = net.ReadString()
	for k, v in ipairs(currentVotes) do
		if id == v.id then
			currentVotes:Pop(k)
			break
		end
	end
end
net.Receive("KillVoteVGUI", KillVoteVGUI)
net.Receive("KillQuestionVGUI", KillVoteVGUI)

local voteSizeX = 460
local voteSizeY = 30
local voteBackAlpha = 240
local voteLineColor = {216, 101, 74, 255}
local voteLineColorBack = {120, 120, 120, 255}
local voteButtonYColor = {134, 252, 75}
local voteLineHeight = 4
local voteTextColor = {
	r = 255,
	g = 255,
	b = 255,
	a = 255
}

local blockSize = 55
local betweenBlockAndBack = 12
local betweenBlocks = 10
local w = ScrW() * 0.5
local h = 80
local function DrawVotesStuff()
	local len = currentVotes:Size()
	if len > 0 then
		local removeID = nil
		for i = 1, len do
			local v = currentVotes[i]
			if v.timeneed - (CurTime() - v.oldtime) > 0 then
				surface.SetDrawColor(0, 0, 0, voteBackAlpha)
				surface.SetFont("default")
				local size = surface.GetTextSize(v.quest) + blockSize * 2 + betweenBlocks * 3
				if size < voteSizeX then size = voteSizeX end

				surface.DrawRect(w, h + (i - 1) * (voteSizeY + 10), size, voteSizeY)

				surface.SetDrawColor(voteLineColorBack[1], voteLineColorBack[2], voteLineColorBack[3], 255)
				surface.DrawRect(w + 1, h + 1 + (i - 1) * (voteSizeY + 10), size - 2, voteLineHeight)

				surface.SetDrawColor(voteLineColor[1], voteLineColor[2], voteLineColor[3], 255)

				surface.DrawRect(w + 1, h + 1 + (i - 1) * (voteSizeY + 10), size / v.timeneed * (v.timeneed - (CurTime() - v.oldtime)), voteLineHeight)

				draw.SimpleText(v.quest, "default", w + 5, h + (i - 1) * (voteSizeY + 10) + voteSizeY / 1.7 - 8, voteTextColor)

				--[[
					Кнопка За
				]]
				-- Коробка бэкграунда.
				surface.SetDrawColor(voteButtonYColor[1], voteButtonYColor[2], voteButtonYColor[3], 255)
				surface.DrawRect(w + size - blockSize - betweenBlocks - blockSize - betweenBlocks, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7, blockSize, voteSizeY - betweenBlockAndBack)

				-- Текст в коробке.
				draw.SimpleText("Да (" .. keyY .. ")", "Default", w + size - blockSize - betweenBlocks + 5 - blockSize - betweenBlocks, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7 + 2, {
					r = 0,
					g = 0,
					b = 0,
					a = 255
				})

				-- Обводка коробки.
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawOutlinedRect(w + size - blockSize - betweenBlocks - blockSize - betweenBlocks, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7, blockSize, voteSizeY - betweenBlockAndBack)
				--[[
					Кнопка против
				]]
				-- Коробка бэкграунда.
				surface.SetDrawColor(255, 100, 100, 255)
				surface.DrawRect(w + size - blockSize - betweenBlocks, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7, blockSize, voteSizeY - betweenBlockAndBack)

				-- Текст в коробке.
				draw.SimpleText("Нет (" .. keyN .. ")", "Default", w + size - blockSize - betweenBlocks + 5, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7 + 2, {
					r = 0,
					g = 0,
					b = 0,
					a = 255
				})

				-- Обводка коробки.
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawOutlinedRect(w + size - blockSize - betweenBlocks, h + (i - 1) * (voteSizeY + 10) + betweenBlockAndBack / 1.7, blockSize, voteSizeY - betweenBlockAndBack)

				--Обводка всего окна.
				surface.SetDrawColor(100, 100, 100, 70)
				surface.DrawOutlinedRect(w, h + (i - 1) * (voteSizeY + 10), size, voteSizeY)
			else
				removeID = i
			end
		end

		if removeID then
			local vote = currentVotes[removeID]
			if vote.callback then vote.callback(false) end
			currentVotes:Pop(removeID)
		end
	end
end
hook.Add("HUDPaint", "DrawVotesStuff", DrawVotesStuff)

local string_Interpolate = string.Interpolate
local lastPressed = 0
local answerStrings = {
	[1] = {"ans {voteID} 1\n", "vote {voteID} yea\n"},
	[0] = {"ans {voteID} 2\n", "vote {voteID} nay\n"},
}

hook.Add("PlayerButtonDown", "VotesButtonStuff", function(_, button)
	local len = currentVotes:Size()
	if len <= 0 then return end

	local bkeyY = bind_key_y:GetInt() or KEY_EQUAL
	local bkeyN = bind_key_n:GetInt() or KEY_MINUS
	if button ~= bkeyY and button ~= bkeyN then return end

	local curTime = CurTime()
	if lastPressed >= curTime then return end
	lastPressed = curTime + 1

	local vote = currentVotes[1]
	if not vote then return end

	local result = button == bkeyY and 1 or 0
	local ans = vote.ans and 1 or 2
	local voteID = vote and vote.id
	if voteID then
		LocalPlayer():ConCommand(string_Interpolate(answerStrings[result][ans], {
			voteID = voteID
		}))
	end

	local callback = vote.callback
	if callback then callback(result == 1) end
	currentVotes:Pop(1)
end)

concommand.Add("rp_vote", function() end)
