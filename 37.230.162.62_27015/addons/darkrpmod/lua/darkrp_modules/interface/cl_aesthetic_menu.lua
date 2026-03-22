AS = AS or {}
CreateClientConVar("Union_weapon_selector", 1, true, "Включение нашего выбора оружия")
CreateClientConVar("Union_weapon_selector_side", 1, true, "Выбор оружия справа")
local draw_aesthetic_menu = GetConVar("Union_weapon_selector")
local side_aesthetic_menu = GetConVar("Union_weapon_selector_side")
local cl_drawhud = GetConVar("cl_drawhud")
local ShouldDraw = true
local CurSlot = 0
local CurPos = 1
local TopWIndex = 0
local BotWIndex = 0
local ASpace = 0
local Mul = 1
local Mul2 = 0
local WTabArray = {}
local WTabArrayLength = {}
local function WepInfo(slot, pos)
	local Info = 0
	if WTabArray ~= nil and WTabArray[slot] and WTabArray[slot][pos] ~= nil and slot ~= nil and pos ~= nil then Info = WTabArray[slot][pos]:GetPrintName() end
	return Info
end

local function SDraw()
	if not draw_aesthetic_menu:GetBool() and AS.AllowDisabling == 1 then
		ShouldDraw = false
	else
		ShouldDraw = true
	end
end

local function CurrentWepModel()
	local LPlayer = LocalPlayer()
	local DefaultWM = AS.DefaultWeaponModel
	local WM = DefaultWM
	if CurSlot ~= nil and CurPos ~= nil and CurSlot ~= 0 and CurPos > 0 and LPlayer:IsValid() and LPlayer:Alive() and IsValid(WTabArray[CurSlot][CurPos]) then
		if WTabArray[CurSlot][CurPos] ~= nil and WTabArray[CurSlot][CurPos]:GetWeaponWorldModel() ~= nil then
			WM = WTabArray[CurSlot][CurPos]:GetWeaponWorldModel()
		else
			WM = DefaultWM
		end

		if WM == "" then WM = DefaultWM end
	else
		WM = ""
	end

	if not cl_drawhud:GetBool() or not ShouldDraw then WM = "" end
	return WM
end

local function HUDAlignment()
	if not side_aesthetic_menu:GetBool() then
		ASpace = 0
		Mul = 1
		Mul2 = 0
	else
		ASpace = ScrW()
		Mul = -1
		Mul2 = 1
	end
end

-- DRAW WEAPON MODEL
function DrawWeaponIcon()
	if not IsValid(WepIcon) then
		WepIcon = vgui.Create("DModelPanel")
		WepIcon:SetAnimated(false)
		WepIcon:SetSize(AS.BoxSize * 0.87, AS.BoxSize * 0.87)
		WepIcon:ParentToHUD()
		WepIcon:SetLookAt(Vector(0, 0, 5))
		WepIcon:SetCamPos(Vector(-25, 0, 0))
		function WepIcon:LayoutEntity(Entity)
			return
		end
	end

	if WepIcon:GetModel() ~= CurrentWepModel() then
		WepIcon:SetModel(CurrentWepModel())
		WepIcon:SetVisible(true)
	end

	WepIcon:SetPos(ASpace + (AS.Spacing + AS.BoxSize * 0.11 + 1 * Mul) * Mul - AS.BoxSize * 0.875 * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.HeightOffset + AS.BoxSize * 0.09 - 1)
	if WepIcon.Entity ~= nil and IsValid(WepIcon.Entity) then
		WepIcon.Entity:SetMaterial(AS.WeaponMaterialOverride)
		WepIcon.Entity:SetAngles(Angle(0, RealTime() * AS.WeaponRotationSpeed, 0))
		WepIcon:SetColor(AS.WeaponModelColor)
	end
end

local function CorrectBounds()
	if CurSlot ~= nil and CurSlot ~= 0 and CurPos ~= nil then
		if WTabArray[CurSlot][CurPos - 1] == nil then
			TopWIndex = 0
		else
			TopWIndex = CurPos - 1
		end

		if WTabArray[CurSlot][CurPos + 1] == nil then
			BotWIndex = 0
		else
			BotWIndex = CurPos + 1
		end
	end
end

local function DrawHUD()
	-- CHECK FOR HUD ALIGNMENT
	HUDAlignment()
	-- WEAPON POSITION INDEX CORRECTION
	CorrectBounds()
	-- BASE DRAWING
	for i = 0, 5 do
		if i ~= CurSlot - 1 then
			draw.RoundedBox(3, ASpace + AS.SideSpacing * Mul - AS.BoxSize * Mul2, (AS.Spacing + AS.BoxSize) * i + AS.HeightOffset, AS.BoxSize, AS.BoxSize, AS.OutlineColor)
			if WepInfo(i + 1, 1) == 0 then
				draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 * Mul) * Mul - AS.BoxSize * Mul2, 1 + (AS.Spacing + AS.BoxSize) * i + AS.HeightOffset, AS.BoxSize - 2, AS.BoxSize - 2, AS.EmptyColor)
			else
				draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 * Mul) * Mul - AS.BoxSize * Mul2, 1 + (AS.Spacing + AS.BoxSize) * i + AS.HeightOffset, AS.BoxSize - 2, AS.BoxSize - 2, AS.UnselectedColor)
			end
		end
	end

	-- MID WEP SCROLL BOX DRAWING
	if WepInfo(CurSlot, CurPos) ~= 0 then
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2), (AS.BoxSize - 2) / 3, AS.OutlineColor)
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize + 1 * Mul) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 + 1 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2) - 2, (AS.BoxSize - 2) / 3 - 2, AS.SelectedColor)
		draw.DrawText(CurPos .. ". ", "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.1 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.9) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 + AS.HeightOffset, AS.SelectedFontColor)
		draw.DrawText(WepInfo(CurSlot, CurPos), "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.4 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.7) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 + AS.HeightOffset, AS.SelectedFontColor)
	end

	-- BOT WEP SCROLL BOX DRAWING
	if BotWIndex ~= 0 then
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 + 1 * AS.BoxSize / 3 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2), (AS.BoxSize - 2) / 3, AS.OutlineColor)
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize + 1 * Mul) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 + 1 + 1 * AS.BoxSize / 3 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2) - 2, (AS.BoxSize - 2) / 3 - 2, AS.UnselectedAltColor)
		draw.DrawText(BotWIndex .. ". ", "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.1 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.9) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 + AS.BoxSize / 3 + AS.HeightOffset, AS.UnselectedFontColor)
		draw.DrawText(WepInfo(CurSlot, CurPos + 1), "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.4 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.7) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 + AS.BoxSize / 3 + AS.HeightOffset, AS.UnselectedFontColor)
	end

	-- TOP WEP SCROLL BOX DRAWING
	if TopWIndex ~= 0 then
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 - 1 * AS.BoxSize / 3 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2), (AS.BoxSize - 2) / 3, AS.OutlineColor)
		draw.RoundedBox(3, ASpace + (AS.SideSpacing + 1 + AS.BoxSize + 1 * Mul) * Mul - AS.RectMul * (AS.BoxSize - 2) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 + 1 - 1 * AS.BoxSize / 3 + AS.HeightOffset, AS.RectMul * (AS.BoxSize - 2) - 2, (AS.BoxSize - 2) / 3 - 2, AS.UnselectedAltColor)
		draw.DrawText(TopWIndex .. ". ", "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.1 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.9) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 - AS.BoxSize / 3 + AS.HeightOffset, AS.UnselectedFontColor)
		draw.DrawText(WepInfo(CurSlot, CurPos - 1), "AS.NormalSizeFont", ASpace + (AS.Spacing + AS.BoxSize * 1.4 + AS.SideSpacing / 2) * Mul - AS.RectMul * (AS.BoxSize * 0.7) * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.BoxSize / 3 * 1.2 - AS.BoxSize / 3 + AS.HeightOffset, AS.UnselectedFontColor)
	end

	-- MAIN SCROLL BOX DRAWING
	draw.RoundedBox(3, ASpace + AS.SideSpacing * Mul - AS.BoxSize * Mul2, (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.HeightOffset, AS.BoxSize, AS.BoxSize, AS.OutlineColor)
	draw.RoundedBox(3, ASpace + AS.SideSpacing * Mul + 1 - AS.BoxSize * Mul2, 1 + (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.HeightOffset, AS.BoxSize - 2, AS.BoxSize - 2, AS.SelectedColor)
	-- WEAPON MODEL BOX
	surface.SetDrawColor(AS.WepBoxOutlineColor)
	surface.DrawOutlinedRect(ASpace + (AS.SideSpacing + 4 * Mul) * Mul - AS.BoxSize * Mul2, 4 + (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.HeightOffset, AS.BoxSize - 8, AS.BoxSize - 8)
	draw.RoundedBox(0, ASpace + (AS.SideSpacing + 5 * Mul) * Mul - AS.BoxSize * Mul2, 5 + (AS.Spacing + AS.BoxSize) * (CurSlot - 1) + AS.HeightOffset, (AS.BoxSize - 2) - 8, (AS.BoxSize - 2) - 8, AS.WepBoxBackgroundColor)
	-- TEXT DRAWING
	if not WTabArray[CurSlot] then return end
	local ActiveWeapon = WTabArray[CurSlot][CurPos]
	local LPlayer = LocalPlayer()
	if LPlayer:IsValid() and LPlayer:Alive() and ActiveWeapon ~= nil then
		local Clip = ActiveWeapon:Clip1()
		local Ammo = LPlayer:GetAmmoCount(ActiveWeapon:GetPrimaryAmmoType())
		for i = 0, 5 do
			if CurSlot - 1 == i then
				draw.DrawText("[" .. i + 1 .. "]", "AS.NormalSizeFont", ASpace + (AS.SideSpacing + AS.BoxSize * 0.09) * Mul - AS.BoxSize * 0.84 * Mul2, AS.HeightOffset + (AS.Spacing + AS.BoxSize) * i + AS.BoxSize * 0.05, AS.SelectedFontColor, TEXT_ALIGN_LEFT)
				if Ammo ~= 0 and Clip ~= -1 and Ammo ~= nil and Clip ~= nil then
					draw.DrawText(Clip .. "/" .. Ammo, "AS.NormalSizeFont", ASpace + (AS.SideSpacing + AS.BoxSize * 0.91) * Mul + 0.83 * AS.BoxSize * Mul2, AS.HeightOffset + (AS.Spacing + AS.BoxSize) * i + AS.BoxSize * 0.75, AS.SelectedFontColor, TEXT_ALIGN_RIGHT)
				else
					--draw.DrawText( "---/---", "AS.NormalSizeFont", ASpace+(AS.SideSpacing+AS.BoxSize*0.91)*Mul+0.83*AS.BoxSize*Mul2, AS.HeightOffset+(AS.Spacing+AS.BoxSize)*i+AS.BoxSize*0.75, AS.SelectedFontColor, TEXT_ALIGN_RIGHT)
				end
			else
				draw.DrawText("[" .. i + 1 .. "]", "AS.HeaderFont", ASpace + (AS.BoxSize / 2) * Mul + AS.SideSpacing * Mul, 5 + AS.HeightOffset + (AS.Spacing + AS.BoxSize) * i, AS.UnselectedFontColor, TEXT_ALIGN_CENTER)
				if WepInfo(i + 1, 1) == 0 then
					draw.DrawText("[ - ]", "AS.NormalSizeFont", ASpace + (AS.BoxSize / 2) * Mul + AS.SideSpacing * Mul, 5 + AS.HeightOffset + AS.BoxSize / 2 + (AS.Spacing + AS.BoxSize) * i, AS.UnselectedFontColor, TEXT_ALIGN_CENTER)
				else
					draw.DrawText("[ " .. WTabArrayLength[i + 1] .. " ]", "AS.NormalSizeFont", ASpace + (AS.BoxSize / 2) * Mul + AS.SideSpacing * Mul, 5 + AS.HeightOffset + AS.BoxSize / 2 + (AS.Spacing + AS.BoxSize) * i, AS.UnselectedFontColor, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end

-- BASIC VARIABLES
local Selection = 1
local WepCount = 0
local MSlots = 6
local LocalPlayer = LocalPlayer
-- FILL WEAPON ARRAY
local function FillTab()
	for i = 1, MSlots do
		WTabArray[i] = {}
		WTabArrayLength[i] = 0
	end

	WepCount = 0
	for i = 1, MSlots do
		for j = 1, WTabArrayLength[i] do
			WTabArray[i][j] = nil
		end

		WTabArrayLength[i] = 0
	end

	for _, pWeapon in pairs(LocalPlayer():GetWeapons()) do
		WepCount = WepCount + 1
		local NextSlot = pWeapon:GetSlot() + 1
		if NextSlot <= MSlots then
			local TabLength = WTabArrayLength[NextSlot] + 1
			WTabArrayLength[NextSlot] = TabLength
			WTabArray[NextSlot][TabLength] = pWeapon
		end
	end

	if CurSlot ~= 0 then
		local TabLength = WTabArrayLength[CurSlot]
		if TabLength < CurPos then
			if TabLength == 0 then
				CurSlot = 0
			else
				CurPos = TabLength
			end
		end
	end
end

local Delay = AS.AutoHideTime
local IsReady = true
local function AutoHide()
	if IsReady then
		CurSlot = 0
		IsReady = false
		-- timer.Simple( Delay, function() IsReady = true end )
		timer.Create("TimerAutoHide", Delay or 4, 0, function() IsReady = true end)
	end

	SDraw()
end

-- DRAW THE HUD
hook.Add("HUDPaint", "HudControl", function()
	AutoHide()
	if CurSlot == 0 then
		if WepIcon then WepIcon:SetVisible(false) end
		return
	end

	FillTab()
	DrawWeaponIcon()
	local LPlayer = LocalPlayer()
	if not cl_drawhud:GetBool() then return end
	if LPlayer:IsValid() and LPlayer:Alive() and not ShouldDraw == false and not LPlayer:KeyDown(IN_ATTACK) and (not LPlayer:InVehicle() or LPlayer:GetAllowWeaponsInVehicle()) then
		DrawHUD()
	else
		CurSlot = 0
	end
end)

hook.Add("PlayerSay", "PlayerSayExample", function(ply, text, team) CurSlot = 0 end)
-- HUD CONTROLS
hook.Add("PlayerBindPress", "HudKeybinds", function(LPlayer, CurPress, IsPressed)
	if ShouldDraw then
		CurPress = string.lower(CurPress)
		-- NEXT
		if CurPress == "invnext" then
			local Looping = CurSlot == 0
			FillTab()
			if not IsPressed or WepCount == 0 then return true end
			if Looping then
				local CurWep = LPlayer:GetActiveWeapon()
				if CurWep:IsValid() then
					local NextSlot = CurWep:GetSlot() + 1
					local TabLength = WTabArrayLength[NextSlot]
					local NWTabArray = WTabArray[NextSlot]
					if NWTabArray[TabLength] ~= CurWep then
						CurSlot = NextSlot
						CurPos = 1
						for i = 1, TabLength - 1 do
							if NWTabArray[i] == CurWep then
								CurPos = i + 1
								break
							end
						end

						if not LPlayer:KeyDown(IN_ATTACK) then LPlayer:EmitSound(AS.MovingSound) end
						return true
					end

					CurSlot = NextSlot
				end
			end

			if Looping or CurPos == WTabArrayLength[CurSlot] then
				repeat
					if CurSlot == MSlots then
						CurSlot = 1
					else
						CurSlot = CurSlot + 1
					end
				until WTabArrayLength[CurSlot] ~= 0

				CurPos = 1
			else
				CurPos = CurPos + 1
			end

			if not LPlayer:KeyDown(IN_ATTACK) then
				LPlayer:EmitSound(AS.MovingSound)
				timer.Start("TimerAutoHide")
			end
			return true
		end

		--PREVIOUS
		if CurPress == "invprev" then
			local Looping = CurSlot == 0
			FillTab()
			if WepCount == 0 or not IsPressed then return true end
			if Looping then
				local CurWep = LPlayer:GetActiveWeapon()
				if CurWep:IsValid() then
					local NextSlot = CurWep:GetSlot() + 1
					local NWTabArray = WTabArray[NextSlot]
					if NWTabArray[1] ~= CurWep then
						CurSlot = NextSlot
						CurPos = 1
						for i = 2, WTabArrayLength[NextSlot] do
							if NWTabArray[i] == CurWep then
								CurPos = i - 1
								break
							end
						end

						if not LPlayer:KeyDown(IN_ATTACK) then LPlayer:EmitSound(AS.MovingSound) end
						return true
					end

					CurSlot = NextSlot
				end
			end

			if Looping or CurPos == 1 then
				repeat
					if CurSlot <= 1 then
						CurSlot = MSlots
					else
						CurSlot = CurSlot - 1
					end
				until WTabArrayLength[CurSlot] ~= 0

				CurPos = WTabArrayLength[CurSlot]
			else
				CurPos = CurPos - 1
			end

			if not LPlayer:KeyDown(IN_ATTACK) then
				LPlayer:EmitSound(AS.MovingSound)
				timer.Start("TimerAutoHide")
			end
			return true
		end

		-- 1-6 SELECTION
		if CurPress:sub(1, 4) == "slot" and not LPlayer:KeyDown(IN_ATTACK) then
			FillTab()
			local NextSlot = tonumber(CurPress:sub(5))
			if NextSlot == nil then return end
			if not IsPressed then return true end
			if NextSlot <= MSlots then
				if NextSlot == CurSlot then
					if CurPos == WTabArrayLength[CurSlot] then
						CurPos = 1
					else
						CurPos = CurPos + 1
					end
				elseif WTabArrayLength[NextSlot] ~= 0 then
					CurSlot = NextSlot
					CurPos = 1
				end

				if not LPlayer:KeyDown(IN_ATTACK) or WepCount == 0 then
					LPlayer:EmitSound(AS.MovingSound)
					timer.Start("TimerAutoHide")
				end
			end
			return true
		end

		-- CANCEL
		if CurPress == "cancelselect" or CurPress == "+menu" or CurPress == "+attack2" then --or LPlayer:IsTyping()
			CurSlot = 0
		end

		if CurSlot ~= 0 then
			if CurPress == "+attack" then
				local pWeapon = WTabArray[CurSlot][CurPos]
				CurSlot = 0
				if pWeapon:IsValid() and pWeapon ~= LPlayer:GetActiveWeapon() then
					hook.Add("CreateMove", "WeaponSelect", function(cmd)
						if pWeapon:IsValid() and LPlayer:IsValid() and pWeapon ~= LPlayer:GetActiveWeapon() then
							cmd:SelectWeapon(pWeapon)
						else
							hook.Remove("CreateMove", "WeaponSelect")
						end
					end)
				end

				if not LPlayer:KeyDown(IN_ATTACK) then
					LPlayer:EmitSound(AS.SelectionSound)
					timer.Start("TimerAutoHide")
				end
				return true
			end
		end
	end
end)
