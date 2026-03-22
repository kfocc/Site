--[[
	STool: Fading Doors
	Version: 2.1.1
	Author: http://www.steamcommunity.com/id/zapk
--]]
--[[
	New in 2.1.0:
	-	Fixed "No Effect" not working.
	-	Cleaned up code.
--]]
TOOL.Category = "Construction"
TOOL.Name = "#tool.fading_door.name"

TOOL.ClientConVar["key"] = "5"
TOOL.ClientConVar["toggle"] = "1"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["noeffect"] = "0"
TOOL.ClientConVar["notify"] = "0"

-- create convar fading_door_nokeyboard (defualt 0)
local noKeyboard = CreateConVar("fading_door_nokeyboard", "0", FCVAR_ARCHIVE, "Set to 1 to disable using fading doors with the keyboard")
local function checkTrace(tr)
	-- edgy, yes, but easy to read
	return tr.Entity and tr.Entity:IsValid() and not (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsVehicle() or tr.HitWorld)
end

if CLIENT then
	-- handle languages
	language.Add("tool.fading_door.name", "Fading Door")
	language.Add("tool.fading_door.desc", "Заставляет объект исчезать при активации.")
	language.Add("tool.fading_door.0", "Click on an object to make it a fading door.")
	language.Add("Undone_fading_door", "Undone Fading Door")
	-- handle tool panel
	function TOOL:BuildCPanel()
		self:AddControl("Header", {
			Text = "#tool.fading_door.name",
			Description = "#tool.fading_door.desc"
		})

		self:AddControl("CheckBox", {
			Label = "Изначально открыт",
			Command = "fading_door_reversed"
		})

		--self:AddControl( "CheckBox", { Label = "Toggle", Command = "fading_door_toggle" } )
		self:AddControl("CheckBox", {
			Label = "Без эффекта",
			Command = "fading_door_noeffect"
		})

		self:AddControl("CheckBox", {
			Label = "Уведомления",
			Command = "fading_door_notify"
		})

		self:AddControl("Numpad", {
			Label = "Кнопка",
			ButtonSize = "22",
			Command = "fading_door_key"
		})
	end

	-- leftclick trace function
	TOOL.LeftClick = checkTrace
	return
end

local function fadeActivate(self, notFromButton)
	local can, reason = hook.Run("FadingDoor.Activate", self, self:CPPIGetOwner(), true, notFromButton)
	if can == false then
		if reason then DarkRP.notify(self:CPPIGetOwner(), 2, 4, reason) end
		return
	end

	self.fadeActive = true
	--AN("Открывает FDOOR", self:CPPIGetOwner())
	self.fadeMaterial = self:GetMaterial()
	self.fadeColor = self:GetColor()
	if self.noEffect then
		self:SetColor(Color(255, 255, 255, 0))
		self:SetMaterial("Models/effects/vol_light001")
	else
		self:SetMaterial("sprites/heatwave")
	end

	self:DrawShadow(false)
	self:SetNotSolid(true)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:EnableMotion(false) end
	self:SetNetVar("fading", false)
end

local function fadeDeactivate(self, notFromButton)
	local can, reason = hook.Run("FadingDoor.DeActivate", self, self:CPPIGetOwner(), false, notFromButton)
	if can == false then
		if reason then DarkRP.notify(self:CPPIGetOwner(), 2, 4, reason) end
		return
	end

	--AN("Закрывает FDOOR", self:CPPIGetOwner())
	self.fadeActive = false
	self:SetMaterial(self.fadeMaterial or "")
	self:SetColor(self.fadeColor or color_white)
	self:DrawShadow(true)
	self:SetNotSolid(false)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:EnableMotion(false) end
	self:SetNetVar("fading", true)
end

local function fadeToggleActive(self, ply)
	if noKeyboard:GetBool() and not numpad.FromButton() then
		DarkRP.notify(ply, 0, 4, "Нужно поставить keypad/кнопку")
		return
	end

	if self.fadeActive then
		self:fadeDeactivate(not numpad.FromButton())
	else
		self:fadeActivate(not numpad.FromButton())
	end
end

local function onUp(ply, ent)
	return
end

numpad.Register("Fading Door onUp", onUp)
local function onDown(ply, ent)
	if ply.nextfdoor and ply.nextfdoor > CurTime() then return end
	if not (ent:IsValid() and ent.fadeToggleActive) then return end
	ent:fadeToggleActive(ply)
	ply.nextfdoor = CurTime() + 5
end

numpad.Register("Fading Door onDown", onDown)
local function onRemove(self)
	numpad.Remove(self.fadeUpNum)
	numpad.Remove(self.fadeDownNum)
end

local function dooEet(ply, ent, stuff)
	if ent.isFadingDoor then
		ent:fadeDeactivate()
		onRemove(ent)
	else
		ent.isFadingDoor = true
		ent.fadeActivate = fadeActivate
		ent.fadeDeactivate = fadeDeactivate
		ent.fadeToggleActive = fadeToggleActive
		ent:CallOnRemove("Fading Door", onRemove)
	end

	local key = stuff.key
	ent.fadeUpNum = numpad.OnUp(ply, key, "Fading Door onUp", ent)
	ent.fadeDownNum = numpad.OnDown(ply, key, "Fading Door onDown", ent)
	ent.fadeToggle = stuff.toggle
	ent.noEffect = stuff.noEffect
	ent.notify = stuff.notify
	ent.key = key
	if stuff.reversed then
		ent:fadeActivate()
	else
		ent:SetNetVar("fading", true)
	end

	duplicator.StoreEntityModifier(ent, "Fading Door", stuff)
	return true
end

duplicator.RegisterEntityModifier("Fading Door", dooEet)
if not FadingDoor then
	local function legacy(ply, ent, data)
		return dooEet(ply, ent, {
			key = data.Key,
			toggle = data.Toggle,
			reversed = data.Inverse,
			noEffect = data.NoEffect,
			notify = data.Notify
		})
	end

	duplicator.RegisterEntityModifier("FadingDoor", legacy)
end

local function doUndo(undoData, ent)
	if IsValid(ent) then
		onRemove(ent)
		ent:fadeDeactivate()
		ent.isFadingDoor = false
		if WireLib then
			ent.TriggerInput = ent.fadeTriggerInput
			if ent.Inputs then
				Wire_Link_Clear(ent, "Fade")
				ent.Inputs["Fade"] = nil
				WireLib._SetInputs(ent)
			end

			if ent.Outputs then
				local port = ent.Outputs["FadeActive"]
				if port then
					for i, inp in ipairs(port.Connected) do
						if inp.Entity:IsValid() then Wire_Link_Clear(inp.Entity, inp.Name) end
					end
				end

				ent.Outputs["FadeActive"] = nil
				WireLib._SetOutputs(ent)
			end
		end

		ent:SetNetVar("fading", nil)
	end
end

function TOOL:LeftClick(tr)
	if not checkTrace(tr) then return false end
	local ent = tr.Entity
	local ply = self:GetOwner()
	if not ent.isFadingDoor then
		undo.Create("Fading_Door")
		undo.AddFunction(doUndo, ent)
		undo.SetPlayer(ply)
		undo.Finish()
	end

	dooEet(ply, ent, {
		key = self:GetClientNumber("key"),
		toggle = self:GetClientNumber("toggle") == 1, -- тут чекни
		reversed = self:GetClientNumber("reversed") == 1,
		noEffect = self:GetClientNumber("noeffect") == 1,
		notify = self:GetClientNumber("notify") == 1
	})
	return true
end

fd_dooEet = dooEet
