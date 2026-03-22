surface.CreateFont("VoiceIndicator", {
	font = "Inter",
	size = 18,
	weight = 700,
	extended = true
})

surface.CreateFont("VoiceIndicatorJob", {
	font = "Inter",
	size = 15,
	weight = 700,
	extended = true
})

local PlayerVoicePanels = PlayerVoicePanels or {}
_G.PlayerVoicePanels = PlayerVoicePanels
local PANEL = {}
PANEL.Margin = 2
PANEL.Padding = 6
PANEL.WaveyColor = Color(255, 255, 255, 255)
PANEL.Font = "VoiceIndicator"
PANEL.FontJob = "VoiceIndicatorJob"

local mutedIcon = Material("icon16/sound_mute.png", "noclamp smooth")
function PANEL:Init()
	self.Color = color_transparent
	self:SetSize(300, 32 + self.Padding)
	self:DockPadding(0, 0, 0, 0)
	self:Dock(BOTTOM)

	self.VoiceIconPanel = vgui.Create("DPanel", self)
	self.VoiceIconPanel:Dock(LEFT)
	self.VoiceIconPanel:SetWide(32)
	self.VoiceIconPanel.Paint = nil

	self.VoiceIcon = vgui.Create("DImage", self.VoiceIconPanel)
	self.VoiceIcon:Dock(FILL)
	self.VoiceIcon:DockMargin(8, 8, 8, 8)

	self.Avatar = vgui.Create("DModelPanel", self)
	self.Avatar:Dock(LEFT)
	self.Avatar:SetWide(32)
	-- self.Avatar:SetPos(self.Padding / 2, self.Padding / 2)
	self.Avatar:SetParent(self)
	function self.Avatar:LayoutEntity(ent)
		return
	end
end

function PANEL:Setup(ply)
	self.ply = ply
	if not IsValid(ply) then
		self:Remove()
		return
	end

	self.Avatar:SetModel(ply:GetModel())
	local eyepos = Vector(0, 0, 64)
	if not IsValid(self.Avatar.Entity) then return end
	local bone = self.Avatar.Entity:LookupBone("ValveBiped.Bip01_Head1")
	if bone then eyepos = self.Avatar.Entity:GetBonePosition(bone) end

	local voiceIcon = ply:_IsMuted() and mutedIcon or ply:GetVoiceDistanceIcon()
	self.VoiceIcon.currentIcon = voiceIcon
	self.VoiceIcon:SetMaterial(voiceIcon)

	eyepos:Add(Vector(0, 0, 2))
	self.Avatar:SetFOV(45)
	self.Avatar:SetLookAt(eyepos)
	self.Avatar:SetCamPos(eyepos - Vector(-18, 0, 0))
	self.Avatar.Entity:SetEyeTarget(eyepos - Vector(-12, 0, 0))
	self.Avatar.Entity:SetSkin(ply:GetSkin())
	for i = 1, #ply:GetBodyGroups() do
		self.Avatar.Entity:SetBodygroup(i, ply:GetBodygroup(i))
	end

	self.Color = Color(255, 0, 0)
	self.TextColor = team.GetColor(ply:GetNetVar("TeamNum", ply:Team()))
	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	local ply = self.ply
	if not IsValid(ply) then
		self:Remove()
		return
	end

	local nick, job = ply:GetResultNickname(), ply:GetResultTeamName()
	surface.SetFont(self.Font)
	local tw, th = surface.GetTextSize(nick)
	surface.SetFont(self.FontJob)
	local jtb = surface.GetTextSize(job)
	local curlen = tw > jtb and tw or jtb
	local halfheight = th / 5
	w = 32 + 8 * 2 + curlen
	--local color = ply:GetPlayerColor() * 255
	--color = Color(math.Clamp(color.r, 30, 180), math.Clamp(color.g, 30, 180), math.Clamp(color.b, 30, 180), 50)
	--local teamcol = self.TextColor
	--teamcol.a = 5
	draw.RoundedBox(4, 32, 0, w, h, col.ba)
	--draw.RoundedBox(4, 0, 0, w, h, teamcol)

	local x = 64 + 10
	draw.DrawText(nick, self.Font, x, halfheight, col.w, nil, TEXT_ALIGN_CENTER)
	draw.DrawText(job, self.FontJob, x, halfheight + th, col.w, nil, TEXT_ALIGN_CENTER)

	local vol = ply:VoiceVolume()
	local volh = h - vol * h
	local basevol = h - volh
	draw.RoundedBox(1, 32, basevol, 1, volh, col.o)
end

function PANEL:Think()
	if self.fadeAnim then self.fadeAnim:Run() end
	if (self.nextThink or 0) >= CurTime() then return end
	self.nextThink = CurTime() + 0.1

	local ply = self.ply
	if not IsValid(ply) then return end

	local voiceIcon = ply:_IsMuted() and mutedIcon or ply:GetVoiceDistanceIcon()
	local voiceIconPanel = self.VoiceIcon
	if voiceIcon ~= voiceIconPanel.currentIcon then
		voiceIconPanel.currentIcon = voiceIcon
		voiceIconPanel:SetMaterial(voiceIcon)
	end
end

function PANEL:Fuck()
	self.Avatar:Remove()
	self:Remove()
end

function PANEL:FadeOut(anim, delta, data)
	if anim.Finished then
		if IsValid(PlayerVoicePanels[self.ply]) then
			self.Avatar:Remove()
			PlayerVoicePanels[self.ply]:Remove()
			PlayerVoicePanels[self.ply] = nil
			--
			return
		end
		--
		return
	end

	--
	self:SetAlpha(255 - 255 * delta)
end
derma.DefineControl("VoiceNotify", "", PANEL, "DPanel")

hook.Add("PlayerStartVoice", "Union.StartVoice", function(ply)
	if not IsValid(VoicePanelList) then return end
	-- There'd be an exta one if voice_loopback is on, so remove it.
	--if ply ~= LocalPlayer() then gamemode.Call("PlayerEndVoice", ply) end
	if IsValid(PlayerVoicePanels[ply]) then
		--PlayerVoicePanels[ply]:Fuck()
		if PlayerVoicePanels[ply].fadeAnim then
			PlayerVoicePanels[ply].fadeAnim:Stop()
			PlayerVoicePanels[ply].fadeAnim = nil
		end

		PlayerVoicePanels[ply]:SetAlpha(255)
		return
	end

	if not IsValid(ply) then return end
	local pnl = VoicePanelList:Add("VoiceNotify")
	pnl:Setup(ply)
	PlayerVoicePanels[ply] = pnl
	--PlayerVoicePanels[ply]:Remove()
end)

local function VoiceClean()
	for k, v in pairs(PlayerVoicePanels) do
		if not IsValid(k) then hook.Run("PlayerEndVoice", k) end
	end
end
timer.Create("VoiceClean", 10, 0, VoiceClean)

hook.Add("PlayerEndVoice", "Union.EndVoice", function(ply)
	if IsValid(PlayerVoicePanels[ply]) then
		--PlayerVoicePanels[ply]:Fuck()
		if PlayerVoicePanels[ply].fadeAnim then return end
		PlayerVoicePanels[ply].fadeAnim = Derma_Anim("FadeOut", PlayerVoicePanels[ply], PlayerVoicePanels[ply].FadeOut)
		PlayerVoicePanels[ply].fadeAnim:Start(2)
	end
end)

local function CreateVoiceVGUI()
	timer.Simple(.1, function()
		if IsValid(g_VoicePanelList) then g_VoicePanelList:Remove() end
		if IsValid(VoicePanelList) then
			VoicePanelList:Remove() -- autorefresh
		end

		VoicePanelList = vgui.Create("DPanel")
		VoicePanelList:ParentToHUD()
		VoicePanelList:SetPos(ScrW() - 320, 100)
		VoicePanelList:SetSize(300, ScrH() - 200)
		VoicePanelList:SetPaintBackground(false)
	end)
end
hook.Add("InitPostEntity", "Union.CreateVoiceVGUI", CreateVoiceVGUI)

netstream.Hook("Voice.Stop", function() RunConsoleCommand("-voicerecord") end)
