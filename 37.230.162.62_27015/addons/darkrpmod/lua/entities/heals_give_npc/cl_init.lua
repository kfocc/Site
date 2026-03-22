include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont("heals_give1", {
	font = "Inter",
	size = 17,
	weight = 500,
	extended = true
})

surface.CreateFont("heals_give2", {
	font = "Inter",
	size = 28,
	weight = 500,
	extended = true
})

surface.CreateFont("heals_give3", {
	font = "Inter",
	size = 28,
	weight = 500,
	extended = true
})

surface.CreateFont("heals_give4", {
	font = "Inter",
	size = 28,
	weight = 500,
	extended = true
})

surface.CreateFont("heals_give5", {
	font = "Inter",
	size = 15,
	weight = 500,
	extended = true
})

local white = Color(200, 200, 200, 2)
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/pill_add.png")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(4)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Фармацевт", 256, col.w, "Лекарства для больницы", self.Icon)
end

local function BuyHeals()
	local main = vgui.Create("DFrame")
	main:SetSize(ScrW() * .7, ScrH() * .7)
	main:Center()
	main:SetTitle("Покупка лекарств")
	main:SetDraggable(false)
	main:MakePopup()
	main:ShowCloseButton(false)
	main.Paint = function(self)
		kblur(self, 5, 10, 150)
		draw.RoundedBox(0, 0, 0, main:GetWide(), main:GetTall(), Color(12, 12, 12, 180))
		draw.RoundedBox(0, 0, 0, main:GetWide(), main:GetTall() * 0.038, white)
	end

	local close = vgui.Create("DButton", main)
	close:SetSize(main:GetTall() * 0.038, main:GetTall() * 0.038)
	close:SetPos(main:GetWide() - main:GetTall() * 0.038, 0)
	close:SetText("x")
	close.Paint = function(self) draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), col.o) end
	close.DoClick = function(self) main:Remove() end
	local heals = heals_give_npc.heals
	for k, v in ipairs(heals) do
		local buttons = main:Add("HealsPanel")
		buttons:Dock(TOP)
		buttons:SetHeight(90)
		--buttons:SetWide(main:GetWide())
		buttons:DockMargin(0, 0, 0, 5)
		buttons.LeftModel:SetModel(v.model)
		-- buttons.LeftModel.Entity:SetPos(Vector(15, 20, 40))
		-- buttons.LeftModel:SetFOV(50)
		-- function buttons.LeftModel:LayoutEntity(Entity) return end
		buttons.MidLabel:SetText(v.name)
		buttons.MidLabel:SetContentAlignment(5)
		buttons.MidLabel:SizeToContents()
		buttons.MidLabel1:SetText("Лекарств за использование: " .. v.points)
		buttons.MidLabel1:SetContentAlignment(5)
		buttons.MidLabel1:SizeToContents()
		buttons.MidLabel2:SetText(v.desc)
		buttons.MidLabel2:SetContentAlignment(5)
		buttons.MidLabel2:SizeToContents()
		buttons.RightLabel:SetText(v.price)
		buttons.RightLabel:SetTextColor(LocalPlayer():canAfford(v.price) and Color(100, 200, 100) or Color(220, 20, 20))
		buttons.RightLabel:SizeToContents()
		buttons.RightLabel2:SetText("токенов")
		buttons.RightLabel2:SetTextColor(Color(220, 220, 220))
		buttons.RightLabel2:SizeToContents()
		buttons.BuyButton.DoClick = function()
			surface.PlaySound("UI/buttonclickrelease.wav")
			net.Start("Open_Heal_NPC_menu")
			net.WriteInt(k, 8)
			net.SendToServer()
			-- if IsValid(main) then
			-- 	main:Remove()
			-- end
		end
	end
end

local buttons = {
	{
		text = "Кто ты?",
		func = function(npc, menu) menu.SetText("Моя обязанность - управление этим складом медикаментов, и моя задача заключается в предоставлении необработанных лекарств медикаментам Гражданского Союза Рабочих.") end
	},
	{
		text = "Как обработать лекарства?",
		func = function(npc, menu) menu.SetText("Сначала приобретите лекарства у меня, а затем направляйтесь в подвал ГСР, который находится напротив этого здания. Там я разместите приобретенные лекарства в обрабатывающем устройстве и подождите, пока они обработаются. Затем заберите обработанные лекарства и доставьте их в больницу, чтобы пополнить запасы кроватей.") end,
		check = function(ply, npc) return ply:Team() == TEAM_GSR4 end
	},
	{
		text = "Хочу приобрести лекарства",
		func = function(npc, menu)
			if LocalPlayer():Team() == TEAM_GSR4 then
				BuyHeals()
				menu:Remove()
			else
				menu.SetText("Давай без этих шуток. Думаешь, я персонал ГСР не знаю? Я то всех медиков знаю.")
			end
		end
	},
	{
		text = "Давай сюда свои токены!",
		func = function(npc, menu)
			if npc:GetNW2Bool("Robbery") then
				menu.SetText("Не трогайте меня, у меня ничего нет! Меня недавно грабили!")
				return
			end

			netstream.Start("NPC.Robbery", npc)
			menu:Remove()
		end,
		check = function(ply, npc) return ply:HasGun() and (ply:isGang() or ply:isRebel() or ply:isRefugee() or ply:Team() == TEAM_AFERIST) end
	}
}

local nice_text = "Чем могу помочь?"
function ENT:OnOpen()
	DialogSys.BeginDialogue(self, nice_text, buttons)
end

local mat, mat1 = Material("unionrp/ui/cart.png", "noclamp smooth"), Material("icon16/cart.png", "noclamp smooth")
local PANEL = {
	Init = function(self)
		local dir = self:GetParent()
		self.Panel = self:Add("DPanel")
		self.Panel:Dock(TOP)
		self.Panel:SetHeight(90)
		self.Panel:DockMargin(10, 0, 10, 0)
		self.Panel.Paint = function()
			draw.RoundedBox(0, 0, 0, self.Panel:GetWide(), self.Panel:GetTall(), Color(0, 0, 0, 0))
			draw.RoundedBox(0, 0, self.Panel:GetTall() - 2, self.Panel:GetWide(), 2, Color(216, 101, 74, 255))
		end


		self.LeftBox = self.Panel:Add("DPanel")
		self.LeftBox:Dock(LEFT)
		self.LeftBox:DockMargin(0, 3, 0, 3)
		self.LeftBox:SetSize(self.Panel:GetWide() * 2, self.Panel:GetTall())
		self.LeftBox.Paint = function() draw.RoundedBox(0, 0, 0, self.LeftBox:GetWide(), self.LeftBox:GetTall(), white) end

		self.LeftModel = self.LeftBox:Add("ModelImage")
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
		self.MidBox:SetSize(dir:GetWide() - self.LeftBox:GetTall() * 2)
		self.MidBox.Paint = function() draw.RoundedBox(0, 0, 0, self.MidBox:GetWide() - self.LeftBox:GetWide(), self.MidBox:GetTall(), Color(0, 0, 0, 180)) end

		self.MidLabel = self.MidBox:Add("DLabel")
		self.MidLabel:Dock(TOP)
		self.MidLabel:SetFont("heals_give3")
		--self.MidLabel:SetText(heals[1].name)
		self.MidLabel:SetContentAlignment(5)
		self.MidLabel:SizeToContents()

		self.MidLabel1 = self.MidBox:Add("DLabel")
		self.MidLabel1:Dock(TOP)
		self.MidLabel1:SetFont("heals_give5")
		--self.MidLabel1:SetText(heals[1].points)
		self.MidLabel1:SetContentAlignment(5)
		self.MidLabel1:SizeToContents()

		self.MidLabel2 = self.MidBox:Add("DLabel")
		self.MidLabel2:Dock(FILL)
		self.MidLabel2:SetFont("heals_give5")
		--self.MidLabel2:SetText(heals[1].info)
		--self.MidLabel2:SetContentAlignment(5)
		--self.MidLabel2:SizeToContents()

		self.Beauty = self.Panel:Add("DPanel")
		local x, y = self.MidBox:GetPos()
		self.Beauty:SetPos(x + self.MidBox:GetWide() + 3, y + self.MidBox:GetTall() + 3)
		self.Beauty:SetSize(self.LeftBox:GetWide() * 2, self.LeftBox:GetTall() - 5)
		self.Beauty.Paint = function(self) draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), white) end

		local curmat = mat:IsError() and mat1 or mat
		self.BuyButton = self.Panel:Add("DImageButton")
		self.BuyButton:DockMargin(10, 10, 10, 20)
		self.BuyButton:DockPadding(25, 55, 10, 0)
		self.BuyButton:Dock(RIGHT)
		self.BuyButton:SetMaterial(curmat)

		--self.Beauty2 = self.Panel:Add("DPanel")
		--self.Beauty2:DockMargin(10, 10, 0, 20)
		--self.Beauty2:DockPadding(25, 55, 10, 0)
		--self.Beauty2:Dock(RIGHT)
		--self.Beauty2.Paint = function(self)
		--	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), col.o)
		--end
		self.RightLabel = self.Panel:Add("DLabel")
		local x, y = self.Beauty:GetPos()
		local xsize, ysize = self.Beauty:GetSize()
		self.RightLabel:SetPos(x + 10, y + ysize / 4)
		self.RightLabel:SetFont("heals_give5")
		--self.RightLabel:SetText("Стоимость: 228 $")
		self.RightLabel:SizeToContents()
		self.RightLabel2 = self.Panel:Add("DLabel")
		local x, y = self.RightLabel:GetPos()
		local xsize, ysize = self.RightLabel:GetTextSize()
		self.RightLabel2:SetText("")
		self.RightLabel2:SetPos(x, y + ysize * 1.5)
		self.RightLabel2:SetFont("heals_give5")
		self.RightLabel2:SizeToContents()
	end
}

vgui.Register("HealsPanel", PANEL)
