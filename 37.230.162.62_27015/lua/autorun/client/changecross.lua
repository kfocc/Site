hook.Add("IGS.Loaded", "changeCross", function()
	local PANEL = vgui.GetControlTable("igs_frame")
	local PANEL_INIT  = PANEL.Init

	function PANEL:Init()
		PANEL_INIT(self)
		self.btnClose:SetTextColor(Color(255,255,255))
	end
end)