local Owner
local IsWorld
local IsShared
local IsBuddy
local LastID
local Note = {
	msg = "",
	typ = "",
	time = 0,
	alpha = 0
}

local scr_w, scr_h = ScrW(), ScrH()
------------------
--  PROP OWNER  --
------------------
------------------------
--  PHYSGUN BEAM FIX  --
------------------------
local function PhysBeam(ply, ent)
	return false
end

hook.Add("PhysgunPickup", "pprotect_physbeam", PhysBeam)
----------------------------
--  ADD BLOCKED PROP/ENT  --
----------------------------
properties.Add("addblockedprop", {
	MenuLabel = "Add to Blocked-List",
	Order = 2002,
	MenuIcon = "icon16/page_white_edit.png",
	Filter = function(self, ent, ply)
		local typ = "prop"
		if ent:GetClass() ~= "prop_physics" then typ = "ent" end
		if not cl_PProtect.Settings.Antispam["enabled"] or not cl_PProtect.Settings.Antispam[typ .. "block"] or not LocalPlayer():IsSuperAdmin() or not ent:IsValid() or ent:IsPlayer() then return false end
		return true
	end,
	Action = function(self, ent)
		net.Start("pprotect_save_cent")
		if ent:GetClass() == "prop_physics" then
			net.WriteTable({
				typ = "props",
				name = ent:GetModel(),
				model = ent:GetModel()
			})
		else
			net.WriteTable({
				typ = "ents",
				name = ent:GetClass(),
				model = ent:GetModel()
			})
		end

		net.SendToServer()
	end
})

---------------------
--  SHARED ENTITY  --
---------------------
properties.Add("shareentity", {
	MenuLabel = "Share entity",
	Order = 2003,
	MenuIcon = "icon16/group.png",
	Filter = function(self, ent, ply)
		if not ent:IsValid() or not cl_PProtect.Settings.Propprotection["enabled"] or ent:IsPlayer() then return false end
		if LocalPlayer():IsSuperAdmin() or Owner == LocalPlayer() then
			return true
		else
			return false
		end
	end,
	Action = function(self, ent)
		local shared_info = {}
		local sh = {"phys", "tool", "use", "dmg"}
		for _, v in pairs(sh) do
			shared_info[v] = ent:GetNW2Bool("pprotect_shared_" .. v)
		end

		-- Frame
		local frm = cl_PProtect.addfrm(180, 165, "share prop:", false)
		-- Checkboxes
		frm:addchk("Physgun", nil, shared_info["phys"], function(c) ent:SetNW2Bool("pprotect_shared_phys", c) end)
		frm:addchk("Toolgun", nil, shared_info["tool"], function(c) ent:SetNW2Bool("pprotect_shared_tool", c) end)
		frm:addchk("Use", nil, shared_info["use"], function(c) ent:SetNW2Bool("pprotect_shared_use", c) end)
		frm:addchk("Damage", nil, shared_info["dmg"], function(c) ent:SetNW2Bool("pprotect_shared_dmg", c) end)
	end
})

----------------
--  MESSAGES  --
----------------
-- DRAW NOTE
local function DrawNote()
	-- Check Note
	if Note.msg == "" or Note.time + 5 < SysTime() then return end
	-- Animation
	if Note.time + 0.5 > SysTime() then
		Note.alpha = math.Clamp(Note.alpha + 10, 0, 255)
	elseif SysTime() > Note.time + 4.5 then
		Note.alpha = math.Clamp(Note.alpha - 10, 0, 255)
	end

	surface.SetFont(cl_PProtect.setFont("Inter", 18, 500, true))
	local tw, th = surface.GetTextSize(Note.msg)
	local w = tw + 20
	local h = th + 20
	local x = ScrW() - w - 20
	local y = ScrH() - h - 20
	local alpha = Note.alpha
	local bcol = Color(88, 144, 222, alpha)
	-- Textbox
	if Note.typ == "info" then
		bcol = Color(128, 255, 0, alpha)
	elseif Note.typ == "admin" then
		bcol = Color(176, 0, 0, alpha)
	end

	draw.RoundedBox(0, x - h, y, h, h, bcol)
	draw.RoundedBox(0, x, y, w, h, Color(240, 240, 240, alpha))
	draw.SimpleText("i", cl_PProtect.setFont("Inter", 36, 1000, true), x - 23, y + 2, Color(255, 255, 255, alpha))
	local tri = {
		{
			x = x,
			y = y + h * 0.5 - 6
		},
		{
			x = x + 5,
			y = y + h * 0.5
		},
		{
			x = x,
			y = y + h * 0.5 + 6
		}
	}

	surface.SetDrawColor(bcol)
	draw.NoTexture()
	surface.DrawPoly(tri)
	-- Text
	draw.SimpleText(Note.msg, cl_PProtect.setFont("Inter", 18, 500, true), x + 10, y + 10, Color(75, 75, 75, alpha))
end

hook.Add("HUDPaint", "pprotect_drawnote", DrawNote)
function cl_PProtect.ClientNote(msg, typ)
	if not cl_PProtect.Settings.CSettings["notes"] then return end
	local al = 0
	if Note.alpha > 0 then al = 255 end
	Note = {
		msg = msg,
		typ = typ,
		time = SysTime(),
		alpha = al
	}

	if Note.typ == "info" then
		LocalPlayer():EmitSound("buttons/button9.wav", 100, 100)
	elseif Note.typ == "admin" and cl_PProtect.Settings.Antispam["alert"] then
		LocalPlayer():EmitSound("ambient/alarms/klaxon1.wav", 100, 100)
	end
end

---------------
--  NETWORK  --
---------------
-- NOTIFY
net.Receive("pprotect_notify", function(len)
	local note = net.ReadTable()
	if note[2] == "admin" and not LocalPlayer():IsAdmin() then return end
	cl_PProtect.ClientNote(note[1], note[2])
end)

-- BUDDIES
net.Receive("pprotect_send_buddies", function(len) IsBuddy = net.ReadBool() end)
