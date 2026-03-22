local material = Material("unionrp/ui/cart.png", "noclamp smooth")

surface.CreateFont("HudFontBig01", {
	font = "Roboto",
	size = 28,
	weight = 500,
	extended = true
})

surface.CreateFont("HudFontBig03", {
	font = "Roboto",
	size = 15,
	weight = 500,
	extended = true
})

local PANEL = {
	Init = function(self)
		self.Panel = self:Add("DPanel")
		self.Panel:Dock(TOP)
		self.Panel:SetHeight(90)
		self.Panel.Paint = function()
			draw.RoundedBox(0, 0, 0, self.Panel:GetWide(), self.Panel:GetTall(), Color(0, 0, 0, 0))
			draw.RoundedBox(0, 0, self.Panel:GetTall() - 2, self.Panel:GetWide(), 2, Color(216, 101, 74, 255))
		end

		self.LeftBox = self.Panel:Add("DPanel")
		self.LeftBox:Dock(LEFT)
		self.LeftBox:DockMargin(0, 3, 0, 3)
		self.LeftBox:SetSize(self.Panel:GetWide() * 2, self.Panel:GetTall())
		self.LeftBox.Paint = function() draw.RoundedBox(0, 0, 0, self.LeftBox:GetWide(), self.LeftBox:GetTall(), Color(0, 0, 0, 180)) end

		self.LeftModel = self.LeftBox:Add("SpawnIcon")
		self.LeftModel:SetModel("error.mdl")
		-- self.LeftModel:Dock(FILL)
		self.LeftModel:Center()
		self.LeftModel:SetSize(64, 64)
		-- self.LeftModel.Entity:SetPos(Vector(15, 20, 40))
		-- self.LeftModel:SetFOV(50)
		-- function self.LeftModel:LayoutEntity(Entity) return end

		self.MidBox = self.Panel:Add("DPanel")
		self.MidBox:Dock(LEFT)
		self.MidBox:DockMargin(3, 3, 0, 3)
		self.MidBox:SetSize(self.Panel:GetWide() * 4.5, self.Panel:GetTall())
		self.MidBox.Paint = function() draw.RoundedBox(0, 0, 0, self.MidBox:GetWide(), self.MidBox:GetTall(), Color(0, 0, 0, 180)) end

		self.MidLabel = self.MidBox:Add("DLabel")
		self.MidLabel:Dock(TOP)
		self.MidLabel:SetFont("HudFontBig01")
		--self.MidLabel:SetText(heals[1].name)
		self.MidLabel:SetContentAlignment(5)
		self.MidLabel:SizeToContents()

		self.MidLabel1 = self.MidBox:Add("DLabel")
		self.MidLabel1:Dock(TOP)
		self.MidLabel1:SetFont("HudFontBig03")
		--self.MidLabel1:SetText(heals[1].points)
		self.MidLabel1:SetContentAlignment(5)
		self.MidLabel1:SizeToContents()

		self.MidLabel2 = self.MidBox:Add("DLabel")
		self.MidLabel2:Dock(FILL)
		self.MidLabel2:SetFont("HudFontBig03")
		--self.MidLabel2:SetText(heals[1].info)
		self.MidLabel2:SetContentAlignment(5)
		self.MidLabel2:SizeToContents()

		self.BuyButton = self.Panel:Add("DImageButton")
		self.BuyButton:DockMargin(10, 10, 55, 20)
		self.BuyButton:DockPadding(25, 55, 10, 0)
		self.BuyButton:Dock(RIGHT)
		self.BuyButton:SetMaterial(material)

		self.RightLabel = self.Panel:Add("DLabel")
		self.RightLabel:SetPos(self.Panel:GetWide() * 7, self.Panel:GetTall() * 0.78)
		self.RightLabel:SetFont("HudFontBig03")
		--self.RightLabel:SetText("Стоимость: 228 $")
		self.RightLabel:SizeToContents()
	end
}
vgui.Register("HealsPanel1", PANEL)

net.Receive("OpenHalloweenMenu", function(len)
	local main = vgui.Create("DFrame")
	main:SetSize(600, ScrH() * 0.465)
	main:Center()
	main:SetTitle("Магазин (у Вас: " .. LocalPlayer():GetHPoints() .. " поинтов)")
	main:SetDraggable(false)
	main:MakePopup()
	main.Paint = function()
		draw.RoundedBox(0, 0, 0, main:GetWide(), main:GetTall(), Color(12, 12, 12, 180))
		draw.RoundedBox(0, 0, 0, main:GetWide(), main:GetTall() * 0.06, Color(216, 101, 74))
	end

	local scroll = main:Add("DScrollPanel")
	scroll:Dock(FILL)

	for k, v in ipairs(halloweenItems) do
		local buttons = scroll:Add("HealsPanel1")
		buttons:Dock(TOP)
		buttons:SetHeight(90)
		buttons:DockMargin(0, 0, 0, 5)

		buttons.LeftModel:SetModel(v.model)
		-- buttons.LeftModel.Entity:SetPos(Vector(15, 20, 40))
		-- buttons.LeftModel:SetFOV(50)
		-- function buttons.LeftModel:LayoutEntity(Entity) return end

		buttons.MidLabel:SetText(v.name)
		buttons.MidLabel:SetContentAlignment(5)
		buttons.MidLabel:SizeToContents()

		buttons.MidLabel1:SetText("")
		buttons.MidLabel1:SetContentAlignment(5)
		buttons.MidLabel1:SizeToContents()

		buttons.MidLabel2:SetText(v.desc)
		buttons.MidLabel2:SetContentAlignment(5)
		buttons.MidLabel2:SizeToContents()

		buttons.RightLabel:SetText("Стоимость: " .. v.price)
		buttons.RightLabel:SizeToContents()

		buttons.BuyButton.DoClick = function()
			surface.PlaySound("UI/buttonclickrelease.wav")
			net.Start("OpenHalloweenMenu")
			net.WriteInt(k, 8)
			net.SendToServer()
			if IsValid(main) then main:Remove() end
		end
	end
end)
