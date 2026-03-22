local Color = Color
local Material = Material
local LocalPlayer = LocalPlayer
local draw_RoundedBox = draw.RoundedBox
local IsValid = IsValid
local ScrH = ScrH
local ipairs = ipairs
include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/status_busy.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(4)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Черный рынок", 256, col.w, "Есть товар, но только для своих", self.Icon)
end

local mat, mat1 = Material("unionrp/ui/cart.png", "noclamp smooth"), Material("icon16/cart.png", "noclamp smooth")
local white = Color(200, 200, 200, 2)
net.Receive("Open_Weapon_Menu", function(len, ply)
	local ent = net.ReadEntity()
	local main = vgui.Create("DFrame")
	local timerID = "weapon_npc_menu" .. ent:EntIndex()
	timer.Create(timerID, 1, 0, function()
		if not IsValid(main) then
			timer.Remove(timerID)
			return
		end

		if not IsValid(ent) then
			timer.Remove(timerID)
			main:Remove()
			return
		end

		local entPos = ent:GetPos()
		if ent:IsDormant() or LocalPlayer():GetPos():DistToSqr(entPos) >= 150 * 150 then
			timer.Remove(timerID)
			main:Remove()
			return
		end
	end)

	main:SetSize(ScrW() * .7, ScrH() * .7)
	main:Center()
	main:SetTitle("Магазин снаряжения")
	main:SetDraggable(false)
	main:MakePopup()
	main:ShowCloseButton(false)
	main.Paint = function(self)
		kblur(self, 5, 10, 150)
		draw_RoundedBox(0, 0, 0, main:GetWide(), main:GetTall(), Color(12, 12, 12, 180))
		draw_RoundedBox(0, 0, 0, main:GetWide(), main:GetTall() * 0.038, white)
	end
	function main:Think()
		if not LocalPlayer():Alive() then
			main:Remove()
		end
	end

	local close = vgui.Create("DButton", main)
	close:SetSize(main:GetTall() * 0.038, main:GetTall() * 0.038)
	close:SetPos(main:GetWide() - main:GetTall() * 0.038, 0)
	close:SetText("x")
	close.Paint = function(self) draw_RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), col.o) end
	close.DoClick = function(self) main:Remove() end
	local scroll = vgui.Create("DScrollPanel", main)
	scroll:Dock(FILL)
	ApplyScrollPanelStyle(scroll)
	local size = 0
	for k, v in ipairs(weapons_give_npc.weps) do
		if not v.jobs[LocalPlayer():Team()] then continue end
		main.Panel = scroll:Add("DPanel")
		main.Panel:Dock(TOP)
		main.Panel:SetHeight(90)
		main.Panel:DockMargin(0, 0, 0, 5)
		main.Panel.Paint = function()
			draw_RoundedBox(0, 0, 0, main.Panel:GetWide(), main.Panel:GetTall(), Color(0, 0, 0, 0))
			draw_RoundedBox(0, 0, main.Panel:GetTall() - 2, main.Panel:GetWide(), 2, Color(216, 101, 74, 255))
		end

		main.LeftBox = main.Panel:Add("DPanel")
		main.LeftBox:Dock(LEFT)
		main.LeftBox:DockMargin(0, 3, 0, 3)
		main.LeftBox:SetSize(main:GetWide(), main.Panel:GetTall())
		main.LeftBox.Paint = function()
			draw_RoundedBox(0, 0, 0, main.LeftBox:GetWide(), main.LeftBox:GetTall(), Color(0, 0, 0, 180))
			draw_RoundedBox(0, 0, 0, main.LeftBox:GetTall(), main.LeftBox:GetTall(), Color(200, 200, 200, 2))
		end

		main.LeftModel = main.LeftBox:Add("ModelImage")
		main.LeftModel:SetModel("error.mdl")
		main.LeftModel:SetPos(10, 10)
		--main.LeftModel:Center()
		main.LeftModel:SetSize(64, 64)
		main.LeftModel:SetModel(v.model)
		function main.LeftModel:LayoutEntity(Entity)
			return
		end

		main.MidLabel = main.LeftBox:Add("DLabel")
		main.MidLabel:Dock(TOP)
		main.MidLabel:SetFont("heals_give3")
		main.MidLabel:SetText(v.name)
		main.MidLabel:SetContentAlignment(5)
		main.MidLabel:SizeToContents()

		main.MidLabel2 = main.LeftBox:Add("DLabel")
		main.MidLabel2:Dock(TOP)
		main.MidLabel2:SetFont("heals_give5")
		main.MidLabel2:SetText(v.desc)
		main.MidLabel2:SetContentAlignment(5)
		main.MidLabel2:SizeToContents()

		main.Beauty = main.Panel:Add("DPanel")
		local x, y = main.LeftBox:GetSize()
		main.Beauty:SetPos(x - 256, 5)
		main.Beauty:SetSize(main.LeftBox:GetWide() * 2, 83)
		main.Beauty.Paint = function(self) draw_RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(200, 200, 200, 2)) end

		main.RightLabel = main.Panel:Add("DLabel")
		local x, y = main.Beauty:GetPos()
		local xsize, ysize = main.Beauty:GetSize()
		main.RightLabel:SetPos(x + 10, y + ysize / 4)
		main.RightLabel:SetFont("heals_give5")
		main.RightLabel:SetText(v.price)
		main.RightLabel:SetTextColor(LocalPlayer():canAfford(v.price) and Color(100, 200, 100) or Color(220, 20, 20))
		main.RightLabel:SizeToContents()

		main.RightLabel2 = main.Panel:Add("DLabel")
		local x, y = main.RightLabel:GetPos()
		local xsize, ysize = main.RightLabel:GetTextSize()
		main.RightLabel2:SetText("токенов")
		main.RightLabel2:SetPos(x, y + ysize * 1.5)
		main.RightLabel2:SetFont("heals_give5")
		main.RightLabel2:SizeToContents()

		local curmat = mat:IsError() and mat1 or mat
		main.BuyButton = main.Panel:Add("DImageButton")
		main.BuyButton:DockMargin(10, 10, 10, 20)
		main.BuyButton:DockPadding(25, 55, 10, 0)
		main.BuyButton:Dock(RIGHT)
		main.BuyButton:SetMaterial(curmat)

		main.BuyButton.DoClick = function()
			if not v.jobs[LocalPlayer():Team()] then
				main:Remove()
				return
			end

			surface.PlaySound("UI/buttonclickrelease.wav")
			netstream.Start("Open_Weapon_Menu", k)
			-- if IsValid(main) then main:Remove() end
		end
		--[[
  	local buttons = scroll:Add("HealsPanel")
  	buttons:Dock(TOP)
  	buttons:SetHeight(90)
  	buttons:DockMargin(0, 0, 0, 5)

  	buttons.LeftModel:SetModel(v.model)
  	-- buttons.LeftModel.Entity:SetPos(Vector(15, 20, 40))
  	-- buttons.LeftModel:SetFOV(50)
  	-- function buttons.LeftModel:LayoutEntity( Entity ) return end

  	buttons.MidLabel:SetText(v.name)
  	buttons.MidLabel:SetContentAlignment(5)
  	buttons.MidLabel:SizeToContents()

  	buttons.MidLabel1:SetText("")
  	buttons.MidLabel1:SetContentAlignment(5)
  	buttons.MidLabel1:SizeToContents()

  	buttons.MidLabel2:SetText(v.info)
  	buttons.MidLabel2:SetContentAlignment(5)
  	buttons.MidLabel2:SizeToContents()

  	buttons.RightLabel:SetText(v.price)
    buttons.RightLabel:SetTextColor(LocalPlayer():canAfford(v.price) and Color(100,200,100) or Color(220,20,20))
    buttons.RightLabel:SizeToContents()

    buttons.RightLabel2:SetText("токенов")
    buttons.RightLabel2:SetTextColor(Color(220,220,220))
    buttons.RightLabel2:SizeToContents()

  	buttons.BuyButton.DoClick = function()
  		surface.PlaySound("UI/buttonclickrelease.wav")
  		net.Start("Open_Weapon_Menu")
  		net.WriteInt(k, 8)
  		net.SendToServer()
  		-- if IsValid(main) then main:Remove() end
  	end
    ]]
	end
end)
