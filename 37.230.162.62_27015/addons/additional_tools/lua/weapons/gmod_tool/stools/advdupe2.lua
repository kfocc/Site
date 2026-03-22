--[[
	Title: Adv. Dupe 2 Tool

	Desc: Defines the AD2 tool and assorted functionalities.

	Author: TB

	Version: 1.0
]]
TOOL.Category = "Construction"
TOOL.Name = "#Tool.advdupe2.name"
cleanup.Register("AdvDupe2")
require"controlpanel"

if SERVER then
	local phys_constraint_system_types = {
		Weld = true,
		Rope = true,
		Elastic = true,
		Slider = true,
		Axis = true,
		AdvBallsocket = true,
		Motor = true,
		Pulley = true,
		Ballsocket = true,
		Winch = true,
		Hydraulic = true
	}

	--Orders constraints so that the dupe uses as little constraint systems as possible
	local function GroupConstraintOrder(ply, constraints)
		--First seperate the nocollides, sorted, and unsorted constraints
		local sorted, unsorted = {}, {}

		for k, v in pairs(constraints) do
			if phys_constraint_system_types[v.Type] then
				sorted[#sorted + 1] = v
			else
				unsorted[#unsorted + 1] = v
			end
		end

		local sortingSystems = {}
		local fullSystems = {}

		local function buildSystems(input)
			while next(input) ~= nil do
				for k, v in pairs(input) do
					for systemi, system in pairs(sortingSystems) do
						for _, target in pairs(system) do
							for x = 1, 4 do
								if v.Entity[x] then
									for y = 1, 4 do
										if target.Entity[y] and v.Entity[x].Index == target.Entity[y].Index then
											system[#system + 1] = v

											if #system == 100 then
												fullSystems[#fullSystems + 1] = system
												table.remove(sortingSystems, systemi)
											end

											input[k] = nil
											goto super_loopbreak
										end
									end
								end
							end
						end
					end
				end

				--Normally skipped by the goto unless no cluster is found. If so, make a new one.
				local k = next(input)

				sortingSystems[#sortingSystems + 1] = {input[k]}

				input[k] = nil
				::super_loopbreak::
			end
		end

		buildSystems(sorted)
		local ret = {}

		for _, system in pairs(fullSystems) do
			for _, v in pairs(system) do
				ret[#ret + 1] = v
			end
		end

		for _, system in pairs(sortingSystems) do
			for _, v in pairs(system) do
				ret[#ret + 1] = v
			end
		end

		for k, v in pairs(unsorted) do
			ret[#ret + 1] = v
		end

		if #fullSystems ~= 0 then
			ply:ChatPrint("DUPLICATOR: WARNING, Number of constraints exceeds 100: (" .. #ret .. "). Constraint sorting might not work as expected.")
		end

		return ret
	end

	local function CreationConstraintOrder(constraints)
		local ret = {}

		for k, v in pairs(constraints) do
			ret[#ret + 1] = k
		end

		table.sort(ret)

		for i = 1, #ret do
			ret[i] = constraints[ret[i]]
		end

		return ret
	end

	local function GetSortedConstraints(ply, constraints)
		if ply:GetInfo("advdupe2_sort_constraints") ~= "0" then
			return GroupConstraintOrder(ply, constraints)
		else
			return CreationConstraintOrder(constraints)
		end
	end

	local areacopy_classblacklist = {
		gmod_anchor = true
	}

	local function PlayerCanDupeCPPI(ply, ent)
		if not AdvDupe2.duplicator.IsCopyable(ent) or areacopy_classblacklist[ent:GetClass()] then return false end

		local entOwner = ent:CPPIGetOwner()
		return entOwner == ply or sv_PProtect.IsBuddy(entOwner, ply, "tool")
	end

	local function PlayerCanDupeTool(ply, ent)
		if not AdvDupe2.duplicator.IsCopyable(ent) or areacopy_classblacklist[ent:GetClass()] then return false end

		local trace = {
			Entity = ent
		}

		return hook.Run("CanTool", ply, trace, "advdupe2") ~= false
	end

	--[[
		Name: LeftClick
		Desc: Defines the tool's behavior when the player left-clicks.
		Params: <trace> trace
		Returns: <boolean> success
	]]
	function TOOL:LeftClick(trace)
		if not trace then return false end
		local ply = self:GetOwner()
		if not ply.AdvDupe2 or not ply.AdvDupe2.Entities then return false end

		if ply.AdvDupe2.Pasting or ply.AdvDupe2.Downloading then
			AdvDupe2.Notify(ply, "Advanced Duplicator 2 is busy.", NOTIFY_ERROR)
			return false
		end

		if (ply._advdupe2LC or 0) >= CurTime() then
			local time = util.TimeToStr(math.ceil(ply._advdupe2LC - CurTime()))
			AdvDupe2.Notify(ply, "Подождите " .. time .. " перед следующим использованием.", NOTIFY_ERROR)
			return false
		end
		ply._advdupe2LC = CurTime() + (GetConVar("AdvDupe2_PasteEntitiesDelay"):GetInt() + 2)

		local isOrigin = tobool(ply:GetInfo("advdupe2_original_origin"))
		local z = math.Clamp(tonumber(ply:GetInfo("advdupe2_offset_z")) + ply.AdvDupe2.HeadEnt.Z, -32000, 32000)
		local traceHitPos = trace.HitPos + Vector(0, 0, z)

		if isOrigin then
			if ply.AdvDupe2.HeadEnt.Pos:DistToSqr(ply:EyePos()) >= AdvDupe2.distToPaste then
				AdvDupe2.Notify(ply, "Вы слишком далеко от места установки Вашего дубликата.", NOTIFY_ERROR)
				return
			end
		else
			if traceHitPos:DistToSqr(ply:EyePos()) >= AdvDupe2.distToPaste then
				AdvDupe2.Notify(ply, "Вы слишком далеко от места установки Вашего дубликата.", NOTIFY_ERROR)
				return
			end
		end

		ply.AdvDupe2.Position = traceHitPos
		ply.AdvDupe2.Angle = Angle(ply:GetInfoNum("advdupe2_offset_pitch", 0), ply:GetInfoNum("advdupe2_offset_yaw", 0), ply:GetInfoNum("advdupe2_offset_roll", 0))

		if tobool(ply:GetInfo("advdupe2_offset_world")) then
			ply.AdvDupe2.Angle = ply.AdvDupe2.Angle - ply.AdvDupe2.Entities[ply.AdvDupe2.HeadEnt.Index].PhysicsObjects[0].Angle
		end

		local origin
		if isOrigin then
			origin = ply.AdvDupe2.HeadEnt.Pos
		end

		ply.AdvDupe2.Pasting = true
		AdvDupe2.Notify(ply, "Pasting...")

		AdvDupe2.InitPastingQueue(ply, ply.AdvDupe2.Position, ply.AdvDupe2.Angle, origin, tobool(ply:GetInfo("advdupe2_paste_constraints")), tobool(ply:GetInfo("advdupe2_paste_parents")), tobool(ply:GetInfo("advdupe2_paste_disparents")), tobool(ply:GetInfo("advdupe2_paste_protectoveride")))

		return true
	end

	--[[
		Name: RightClick
		Desc: Defines the tool's behavior when the player right-clicks.
		Params: <trace> trace
		Returns: <boolean> success
	]]
	function TOOL:RightClick(trace)
		local ply = self:GetOwner()

		if ply.AdvDupe2.Pasting or ply.AdvDupe2.Downloading then
			AdvDupe2.Notify(ply, "Advanced Duplicator 2 is busy.", NOTIFY_ERROR)
			return false
		end

		if (ply._advdupe2RC or 0) >= CurTime() then
			local time = util.TimeToStr(math.ceil(ply._advdupe2RC - CurTime()))
			AdvDupe2.Notify(ply, "Подождите " .. time .. " перед следующим использованием.", NOTIFY_ERROR)
			return false
		end
		ply._advdupe2RC = CurTime() + (GetConVar("AdvDupe2_FileModificationDelay"):GetInt() + 2)

		if not trace or not trace.Hit then return false end
		local Entities, Constraints, AddOne
		local HeadEnt = {}

		local PPCheck = (CPPI ~= nil and PlayerCanDupeCPPI) or PlayerCanDupeTool
		if trace.HitNonWorld then
			-- Filter duplicator blocked entities out.
			local traceEnt = trace.Entity
			if not AdvDupe2.duplicator.IsCopyable(traceEnt) then return false end
			if not PPCheck(ply, traceEnt) then return false end

			--If Alt is being held, add a prop to the dupe
			if ply:KeyDown(IN_WALK) and ply.AdvDupe2.Entities ~= nil and next(ply.AdvDupe2.Entities) ~= nil then
				Entities = ply.AdvDupe2.Entities
				Constraints = ply.AdvDupe2.Constraints
				HeadEnt = ply.AdvDupe2.HeadEnt
				AdvDupe2.duplicator.Copy(ply, traceEnt, Entities, Constraints, HeadEnt.Pos)
				--Only add the one ghost
				AddOne = Entities[traceEnt:EntIndex()]
			else
				Entities = {}
				Constraints = {}
				HeadEnt.Index = traceEnt:EntIndex()
				HeadEnt.Pos = trace.HitPos
				AdvDupe2.duplicator.Copy(ply, traceEnt, Entities, Constraints, trace.HitPos)
			end
		else --Non valid entity or clicked the world
			--select all owned props
			Entities = {}

			local entAll = ents.GetAll()
			for i = 1, #entAll do
				local ent = entAll[i]
				if PPCheck(ply, ent) then
					Entities[ent:EntIndex()] = ent
				end
			end

			local _, Ent = next(Entities)
			if not Ent then
				net.Start("AdvDupe2_RemoveGhosts")
				net.Send(ply)
				return true
			end

			HeadEnt.Index = Ent:EntIndex()
			HeadEnt.Pos = Ent:GetPos()
			Entities, Constraints = AdvDupe2.duplicator.AreaCopy(ply, Entities, HeadEnt.Pos, true)
		end

		if not HeadEnt.Z then
			local WorldTrace = util.TraceLine({
				mask = MASK_NPCWORLDSTATIC,
				start = HeadEnt.Pos + Vector(0, 0, 1),
				endpos = HeadEnt.Pos - Vector(0, 0, 50000)
			})

			HeadEnt.Z = WorldTrace.Hit and math.abs(HeadEnt.Pos.Z - WorldTrace.HitPos.Z) or 0
		end

		ply.AdvDupe2.HeadEnt = HeadEnt
		ply.AdvDupe2.Entities = Entities
		ply.AdvDupe2.Constraints = GetSortedConstraints(ply, Constraints)

		local info = {
			name = "",
			creator = ply:Nick(),
			date = os.date("%d %B %Y"),
			time = os.date("%I:%M %p"),
			size = "",
			desc = "",
			entities = table.Count(ply.AdvDupe2.Entities),
			constraints = #ply.AdvDupe2.Constraints
		}
		net.Start("AdvDupe2_SetDupeInfo")
		net.WriteTable(info)
		net.Send(ply)

		if AddOne then
			AdvDupe2.SendGhost(ply, AddOne)
		else
			AdvDupe2.SendGhosts(ply)
		end

		AdvDupe2.ResetOffsets(ply)

		return true
	end

	function TOOL:Reload(trace)
		local ply = self:GetOwner()
		if not ply.AdvDupe2.Entities then return false end

		--clear the dupe
		net.Start("AdvDupe2_RemoveGhosts")
		net.Send(ply)

		ply.AdvDupe2.Entities = nil
		ply.AdvDupe2.Constraints = nil

		net.Start("AdvDupe2_ResetDupeInfo")
		net.Send(ply)

		AdvDupe2.ResetOffsets(ply)
		return true
	end

	--Checks table, re-draws loading bar, and recreates ghosts when tool is pulled out
	function TOOL:Deploy()
		local ply = self:GetOwner()

		if not ply.AdvDupe2 then
			ply.AdvDupe2 = {}
		end

		if not ply.AdvDupe2.Entities then return end
		net.Start("AdvDupe2_StartGhosting")
		net.Send(ply)

		if ply.AdvDupe2.Queued then
			AdvDupe2.InitProgressBar(ply, "Queued: ")

			return
		end

		if ply.AdvDupe2.Pasting then
			AdvDupe2.InitProgressBar(ply, "Pasting: ")

			return
		else
			if ply.AdvDupe2.Uploading then
				AdvDupe2.InitProgressBar(ply, "Opening: ")

				return
			elseif ply.AdvDupe2.Downloading then
				AdvDupe2.InitProgressBar(ply, "Saving: ")

				return
			end
		end
	end

	--Removes progress bar
	function TOOL:Holster()
		AdvDupe2.RemoveProgressBar(self:GetOwner())
	end

	--Called to clean up the tool when pasting is finished or undo during pasting
	function AdvDupe2.FinishPasting(Player, Paste)
		Player.AdvDupe2.Pasting = false
		AdvDupe2.RemoveProgressBar(Player)

		if Paste then
			AdvDupe2.Notify(Player, "Finished Pasting!")
		end
	end

	function AdvDupe2.InitProgressBar(ply, label)
		net.Start("AdvDupe2_InitProgressBar")
		net.WriteString(label)
		net.Send(ply)
	end

	function AdvDupe2.UpdateProgressBar(ply, percent)
		net.Start("AdvDupe2_UpdateProgressBar")
		net.WriteFloat(percent)
		net.Send(ply)
	end

	function AdvDupe2.RemoveProgressBar(ply)
		net.Start("AdvDupe2_RemoveProgressBar")
		net.Send(ply)
	end

	--Reset the offsets of height, pitch, yaw, and roll back to default
	function AdvDupe2.ResetOffsets(ply, keep)
		if not keep then
			ply.AdvDupe2.Name = nil
		end

		net.Start("AdvDupe2_ResetOffsets")
		net.Send(ply)
	end
end

if CLIENT then
	function TOOL:LeftClick(trace)
		if trace and AdvDupe2.HeadGhost then return true end
		return false
	end

	function TOOL:RightClick(trace)
		return true
	end

	--Removes progress bar and removes ghosts when tool is put away
	function TOOL:ReleaseGhostEntity()
		if self:GetOwner() ~= LocalPlayer() then return end

		AdvDupe2.RemoveGhosts()
		if AdvDupe2.Rotation then
			hook.Remove("PlayerBindPress", "AdvDupe2_BindPress")
			hook.Remove("CreateMove", "AdvDupe2_MouseControl")
		end
		return
	end

	function TOOL:Reload(trace)
		if trace and AdvDupe2.HeadGhost then return true end
		return false
	end

	--Take control of the mouse wheel bind so the player can modify the height of the dupe
	local function MouseWheelScrolled(ply, bind, pressed)
		if bind == "invprev" then
			local Z = tonumber(ply:GetInfo("advdupe2_offset_z")) + 5
			RunConsoleCommand("advdupe2_offset_z", Z)

			return true
		elseif bind == "invnext" then
			local Z = tonumber(ply:GetInfo("advdupe2_offset_z")) - 5
			RunConsoleCommand("advdupe2_offset_z", Z)

			return true
		end

		GAMEMODE:PlayerBindPress(ply, bind, pressed)
	end

	local XTotal = 0
	local YTotal = 0
	local LastXDegree = 0

	local function MouseControl(cmd)
		local X = -cmd:GetMouseX() / -20
		local Y = cmd:GetMouseY() / -20
		local X2 = 0
		local Y2 = 0

		if X ~= 0 then
			X2 = tonumber(LocalPlayer():GetInfo("advdupe2_offset_yaw"))

			if LocalPlayer():KeyDown(IN_SPEED) then
				XTotal = XTotal + X
				local temp = XTotal + X2
				local degree = math.Round(temp / 45) * 45

				if degree >= 225 then
					degree = -135
				elseif degree <= -225 then
					degree = 135
				end

				if degree ~= LastXDegree then
					XTotal = 0
					LastXDegree = degree
				end

				X2 = degree
			else
				X2 = X2 + X

				if X2 < -180 then
					X2 = X2 + 360
				elseif X2 > 180 then
					X2 = X2 - 360
				end
			end

			RunConsoleCommand("advdupe2_offset_yaw", X2)
		end
		--[[if(Y~=0)then
			local modyaw = LocalPlayer():GetAngles().y
			local modyaw2 = tonumber(LocalPlayer():GetInfo("advdupe2_offset_yaw"))

			if(modyaw<0)then modyaw = modyaw + 360 else modyaw = modyaw + 180 end
			if(modyaw2<0)then modyaw2 = modyaw2 + 360 else modyaw2 = modyaw2 + 180 end

			modyaw = modyaw - modyaw2
			local modyaw3 = modyaw
			if(modyaw3<0)then
				modyaw3 = modyaw3 * -1
			end

			local pitch = tonumber(LocalPlayer():GetInfo("advdupe2_offset_pitch"))
			local roll = tonumber(LocalPlayer():GetInfo("advdupe2_offset_roll"))

				--print(modyaw3)
			if(modyaw3 <= 90)then
				pitch = pitch + (Y - Y * (modyaw3/90))
				roll = roll - (Y*(modyaw3/90))
			end

			--if(pitch>180)then pitch = -180

			RunConsoleCommand("advdupe2_offset_pitch",pitch)
			RunConsoleCommand("advdupe2_offset_roll",roll)
		end]]
	end

	--Checks binds to modify dupes position and angles
	function TOOL:Think()
		if AdvDupe2.HeadGhost then
			AdvDupe2.UpdateGhosts()
		end

		if LocalPlayer():KeyDown(IN_USE) then
			if not AdvDupe2.Rotation then
				hook.Add("PlayerBindPress", "AdvDupe2_BindPress", MouseWheelScrolled)
				hook.Add("CreateMove", "AdvDupe2_MouseControl", MouseControl)
				AdvDupe2.Rotation = true
			end
		else
			if AdvDupe2.Rotation then
				AdvDupe2.Rotation = false
				hook.Remove("PlayerBindPress", "AdvDupe2_BindPress")
				hook.Remove("CreateMove", "AdvDupe2_MouseControl")
			end

			XTotal = 0
			YTotal = 0
			LastXDegree = 0

			return
		end
	end

	--Hinder the player from looking to modify offsets with the mouse
	function TOOL:FreezeMovement()
		return AdvDupe2.Rotation
	end

	language.Add("Tool.advdupe2.name", "Advanced Duplicator 2")
	language.Add("Tool.advdupe2.desc", "Duplicate things.")
	language.Add("Tool.advdupe2.0", "Primary: Paste, Secondary: Copy.")
	language.Add("Undone.AdvDupe2", "Undone AdvDupe2 paste")
	language.Add("Cleanup.AdvDupe2", "Adv. Duplications")
	language.Add("Cleaned.AdvDupe2", "Cleaned up all Adv. Duplications")
	language.Add("SBoxLimit.AdvDupe2", "You've reached the Adv. Duplicator limit!")

	CreateClientConVar("advdupe2_offset_world", 0, false, true)
	CreateClientConVar("advdupe2_offset_z", 0, false, true)
	CreateClientConVar("advdupe2_offset_pitch", 0, false, true)
	CreateClientConVar("advdupe2_offset_yaw", 0, false, true)
	CreateClientConVar("advdupe2_offset_roll", 0, false, true)
	CreateClientConVar("advdupe2_original_origin", 0, false, true)
	CreateClientConVar("advdupe2_paste_constraints", 1, false, true)
	CreateClientConVar("advdupe2_sort_constraints", 1, true, true)
	CreateClientConVar("advdupe2_paste_parents", 1, false, true)
	CreateClientConVar("advdupe2_copy_outside", 0, false, true)
	CreateClientConVar("advdupe2_limit_ghost", 100, false, true)
	--Experimental

	CreateClientConVar("advdupe2_paste_disparents", 0, false, true)
	CreateClientConVar("advdupe2_paste_protectoveride", 1, false, true)
	CreateClientConVar("advdupe2_debug_openfile", 1, false, true)

	local function BuildCPanel(CPanel)
		CPanel:ClearControls()
		local FileBrowser = vgui.Create("advdupe2_browser")
		CPanel:AddItem(FileBrowser)
		FileBrowser:SetSize(CPanel:GetWide(), 405)
		AdvDupe2.FileBrowser = FileBrowser
		local Check = vgui.Create("DCheckBoxLabel")
		Check:SetText("Paste at original position")
		Check:SetDark(true)
		Check:SetConVar("advdupe2_original_origin")
		Check:SetValue(0)
		Check:SetTooltip("Paste at the position originally copied")
		CPanel:AddItem(Check)
		Check = vgui.Create("DCheckBoxLabel")
		Check:SetText("Paste with constraints")
		Check:SetDark(true)
		Check:SetConVar("advdupe2_paste_constraints")
		Check:SetValue(1)
		Check:SetTooltip("Paste with or without constraints")
		CPanel:AddItem(Check)
		Check = vgui.Create("DCheckBoxLabel")
		Check:SetText("Paste with parenting")
		Check:SetDark(true)
		Check:SetConVar("advdupe2_paste_parents")
		Check:SetValue(1)
		Check:SetTooltip("Paste with or without parenting")
		CPanel:AddItem(Check)
		CPanel:AddItem(Check_2)
		Check = vgui.Create("DCheckBoxLabel")
		Check:SetText("Sort constraints by their connections")
		Check:SetDark(true)
		Check:SetConVar("advdupe2_sort_constraints")
		Check:SetValue(GetConVarNumber("advdupe2_sort_constraints"))
		Check:SetTooltip("Orders constraints so that they build a rigid constraint system.")
		CPanel:AddItem(Check)
		local NumSlider = vgui.Create("DNumSlider")
		NumSlider:SetText("Ghost Percentage:")
		NumSlider.Label:SetDark(true)
		NumSlider:SetMin(0)
		NumSlider:SetMax(100)
		NumSlider:SetDecimals(0)
		NumSlider:SetConVar("advdupe2_limit_ghost")
		NumSlider:SetTooltip("Change the percent of ghosts to spawn")
		--If these funcs are not here, problems occur for each
		local func = NumSlider.Slider.OnMouseReleased

		NumSlider.Slider.OnMouseReleased = function(self, mcode)
			func(self, mcode)
			AdvDupe2.StartGhosting()
		end

		local func2 = NumSlider.Slider.Knob.OnMouseReleased

		NumSlider.Slider.Knob.OnMouseReleased = function(self, mcode)
			func2(self, mcode)
			AdvDupe2.StartGhosting()
		end

		local func3 = NumSlider.Wang.Panel.OnLoseFocus

		NumSlider.Wang.Panel.OnLoseFocus = function(txtBox)
			func3(txtBox)
			AdvDupe2.StartGhosting()
		end

		CPanel:AddItem(NumSlider)
		local Category1 = vgui.Create("DCollapsibleCategory")
		CPanel:AddItem(Category1)
		Category1:SetLabel("Offsets")
		Category1:SetExpanded(0)
		local parent = FileBrowser:GetParent():GetParent():GetParent():GetParent()
		--[[Offsets]]
		--
		local CategoryContent1 = vgui.Create("DPanelList")
		CategoryContent1:SetAutoSize(true)
		CategoryContent1:SetDrawBackground(false)
		CategoryContent1:SetSpacing(1)
		CategoryContent1:SetPadding(2)

		--Fix the damned mouse not scrolling when it's over the catagories
		CategoryContent1.OnMouseWheeled = function(self, dlta)
			parent:OnMouseWheeled(dlta)
		end

		Category1:SetContents(CategoryContent1)
		NumSlider = vgui.Create("DNumSlider")
		NumSlider:SetText("Height Offset")
		NumSlider.Label:SetDark(true)
		NumSlider:SetMin(-2500)
		NumSlider:SetMax(2500)
		NumSlider:SetDefaultValue(0)
		NumSlider:SetDecimals(3)
		NumSlider:SetConVar("advdupe2_offset_z")
		NumSlider:SetTooltip("Changes the dupe Z offset")
		CategoryContent1:AddItem(NumSlider)
		Check = vgui.Create("DCheckBoxLabel")
		Check:SetText("Use World Angles")
		Check:SetDark(true)
		Check:SetConVar("advdupe2_offset_world")
		Check:SetValue(0)
		Check:SetTooltip("Use world angles for the offset instead of the main entity")
		CategoryContent1:AddItem(Check)
		NumSlider = vgui.Create("DNumSlider")
		NumSlider:SetText("Pitch Offset")
		NumSlider.Label:SetDark(true)
		NumSlider:SetMin(-180)
		NumSlider:SetMax(180)
		NumSlider:SetDefaultValue(0)
		NumSlider:SetDecimals(3)
		NumSlider:SetTooltip("Changes the dupe pitch offset")
		NumSlider:SetConVar("advdupe2_offset_pitch")
		CategoryContent1:AddItem(NumSlider)
		NumSlider = vgui.Create("DNumSlider")
		NumSlider:SetText("Yaw Offset")
		NumSlider.Label:SetDark(true)
		NumSlider:SetMin(-180)
		NumSlider:SetMax(180)
		NumSlider:SetDefaultValue(0)
		NumSlider:SetDecimals(3)
		NumSlider:SetTooltip("Changes the dupe yaw offset")
		NumSlider:SetConVar("advdupe2_offset_yaw")
		CategoryContent1:AddItem(NumSlider)
		NumSlider = vgui.Create("DNumSlider")
		NumSlider:SetText("Roll Offset")
		NumSlider.Label:SetDark(true)
		NumSlider:SetMin(-180)
		NumSlider:SetMax(180)
		NumSlider:SetDefaultValue(0)
		NumSlider:SetDecimals(3)
		NumSlider:SetTooltip("Changes the dupe roll offset")
		NumSlider:SetConVar("advdupe2_offset_roll")
		CategoryContent1:AddItem(NumSlider)
		local Btn = vgui.Create("DButton")
		Btn:SetText("Reset")

		Btn.DoClick = function()
			RunConsoleCommand("advdupe2_offset_z", 0)
			RunConsoleCommand("advdupe2_offset_pitch", 0)
			RunConsoleCommand("advdupe2_offset_yaw", 0)
			RunConsoleCommand("advdupe2_offset_roll", 0)
		end

		CategoryContent1:AddItem(Btn)
		--[[Dupe Information]]
		--
		local Category2 = vgui.Create("DCollapsibleCategory")
		CPanel:AddItem(Category2)
		Category2:SetLabel("Dupe Information")
		Category2:SetExpanded(0)
		local CategoryContent2 = vgui.Create("DPanelList")
		CategoryContent2:SetAutoSize(true)
		CategoryContent2:SetDrawBackground(false)
		CategoryContent2:SetSpacing(3)
		CategoryContent2:SetPadding(2)
		Category2:SetContents(CategoryContent2)

		CategoryContent2.OnMouseWheeled = function(self, dlta)
			parent:OnMouseWheeled(dlta)
		end

		AdvDupe2.Info = {}
		local lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.File or "File: ")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.File = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Creator or "Creator:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Creator = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Date or "Date:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Date = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Time or "Time:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Time = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Size or "Size:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Size = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Desc or "Desc:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Desc = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Entities or "Entities:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Entities = lbl
		lbl = vgui.Create("DLabel")
		lbl:SetText(AdvDupe2.InfoText.Constraints or "Constraints:")
		lbl:SetDark(true)
		CategoryContent2:AddItem(lbl)
		AdvDupe2.Info.Constraints = lbl
	end

	function TOOL.BuildCPanel(panel)
		panel:ClearControls()

		panel:AddControl("Header", {
			Text = "Advanced Duplicator 2",
			Description = "Duplicate stuff."
		})

		local function tryToBuild()
			local CPanel = controlpanel.Get("advdupe2")

			if CPanel and CPanel:GetWide() > 16 then
				BuildCPanel(CPanel)
			else
				timer.Simple(0.1, tryToBuild)
			end
		end

		tryToBuild()
	end

	local state = 0

	local ToColor = {
		r = 25,
		g = 100,
		b = 40,
		a = 255
	}

	local CurColor = {
		r = 25,
		g = 100,
		b = 40,
		a = 255
	}

	local rate

	---Remember to use gm_clearfonts
	surface.CreateFont("AD2Font", {
		font = "Arial",
		size = 40,
		weight = 900,
		extended = true,
	})

	surface.CreateFont("AD2TitleFont", {
		font = "Arial",
		size = 24,
		weight = 900,
		extended = true,
	})

	function TOOL:DrawToolScreen()
		if not AdvDupe2 then return true end
		local text = "Ready"

		if AdvDupe2.Preview then
			text = "Preview"
		end

		local state = 0

		if AdvDupe2.ProgressBar.Text then
			state = 1
			text = AdvDupe2.ProgressBar.Text
		end

		cam.Start2D()
		surface.SetDrawColor(32, 32, 32, 255)
		surface.DrawRect(0, 0, 256, 256)

		if state == 0 then
			ToColor = {
				r = 25,
				g = 100,
				b = 40,
				a = 255
			}
		else
			ToColor = {
				r = 130,
				g = 25,
				b = 40,
				a = 255
			}
		end

		rate = FrameTime() * 160
		CurColor.r = math.Approach(CurColor.r, ToColor.r, rate)
		CurColor.g = math.Approach(CurColor.g, ToColor.g, rate)
		surface.SetDrawColor(CurColor)
		surface.DrawRect(13, 13, 230, 230)
		surface.SetTextColor(255, 255, 255, 255)
		draw.SimpleText("Advanced Duplicator 2", "AD2TitleFont", 128, 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "AD2Font", 128, 128, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if state ~= 0 then
			draw.RoundedBox(6, 32, 178, 192, 28, Color(255, 255, 255, 150))
			draw.RoundedBox(6, 36, 182, 188 * (AdvDupe2.ProgressBar.Percent / 100), 24, Color(0, 255, 0, 255))
		elseif LocalPlayer():KeyDown(IN_USE) then
			draw.SimpleText("Height: " .. LocalPlayer():GetInfo("advdupe2_offset_z"), "AD2TitleFont", 25, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("Pitch: " .. LocalPlayer():GetInfo("advdupe2_offset_pitch"), "AD2TitleFont", 25, 190, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText("Yaw: " .. LocalPlayer():GetInfo("advdupe2_offset_yaw"), "AD2TitleFont", 25, 220, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end

		cam.End2D()
	end

	function AdvDupe2.InitProgressBar(label)
		AdvDupe2.ProgressBar = {}
		AdvDupe2.ProgressBar.Text = label
		AdvDupe2.ProgressBar.Percent = 0
		AdvDupe2.BusyBar = true
	end

	net.Receive("AdvDupe2_InitProgressBar", function()
		AdvDupe2.InitProgressBar(net.ReadString())
	end)

	net.Receive("AdvDupe2_UpdateProgressBar", function()
		AdvDupe2.ProgressBar.Percent = net.ReadFloat()
	end)

	function AdvDupe2.RemoveProgressBar()
		AdvDupe2.ProgressBar = {}
		AdvDupe2.BusyBar = false

		if AdvDupe2.Ghosting then
			AdvDupe2.InitProgressBar("Ghosting: ")
			AdvDupe2.BusyBar = false
			AdvDupe2.ProgressBar.Percent = AdvDupe2.CurrentGhost / AdvDupe2.TotalGhosts * 100
		end
	end

	net.Receive("AdvDupe2_RemoveProgressBar", function()
		AdvDupe2.RemoveProgressBar()
	end)

	net.Receive("AdvDupe2_ResetOffsets", function()
		RunConsoleCommand("advdupe2_original_origin", "0")
		RunConsoleCommand("advdupe2_paste_constraints", "1")
		RunConsoleCommand("advdupe2_offset_z", "0")
		RunConsoleCommand("advdupe2_offset_pitch", "0")
		RunConsoleCommand("advdupe2_offset_yaw", "0")
		RunConsoleCommand("advdupe2_offset_roll", "0")
		RunConsoleCommand("advdupe2_paste_parents", "1")
		RunConsoleCommand("advdupe2_paste_disparents", "0")
	end)

	net.Receive("AdvDupe2_ReportModel", function()
		print("Advanced Duplicator 2: Invalid Model: " .. net.ReadString())
	end)

	net.Receive("AdvDupe2_ReportClass", function()
		print("Advanced Duplicator 2: Invalid Class: " .. net.ReadString())
	end)

	net.Receive("AdvDupe2_ResetDupeInfo", function()
		if not AdvDupe2.Info then return end
		AdvDupe2.Info.File:SetText("File:")
		AdvDupe2.Info.Creator:SetText("Creator:")
		AdvDupe2.Info.Date:SetText("Date:")
		AdvDupe2.Info.Time:SetText("Time:")
		AdvDupe2.Info.Size:SetText("Size:")
		AdvDupe2.Info.Desc:SetText("Desc:")
		AdvDupe2.Info.Entities:SetText("Entities:")
		AdvDupe2.Info.Constraints:SetText("Constraints:")
	end)

	net.Receive("AdvDupe2_SetDupeInfo", function(len, ply)
		local tab = net.ReadTable()
		if AdvDupe2.Info then
			AdvDupe2.Info.File:SetText("File: " .. tab.name)
			AdvDupe2.Info.Creator:SetText("Creator: " .. tab.creator)
			AdvDupe2.Info.Date:SetText("Date: " .. tab.date)
			AdvDupe2.Info.Time:SetText("Time: " .. tab.time)
			AdvDupe2.Info.Size:SetText("Size: " .. tab.size)
			AdvDupe2.Info.Desc:SetText("Desc: " .. tab.desc)
			AdvDupe2.Info.Entities:SetText("Entities: " .. tab.entities)
			AdvDupe2.Info.Constraints:SetText("Constraints: " .. tab.constraints)
		else
			AdvDupe2.InfoText.File = "File: " .. tab.name
			AdvDupe2.InfoText.Creator = "Creator: " .. tab.creator
			AdvDupe2.InfoText.Date = "Date: " .. tab.date
			AdvDupe2.InfoText.Time = "Time: " .. tab.time
			AdvDupe2.InfoText.Size = "Size: " .. tab.size
			AdvDupe2.InfoText.Desc = "Desc: " .. tab.desc
			AdvDupe2.InfoText.Entities = "Entities: " .. tab.entities
			AdvDupe2.InfoText.Constraints = "Constraints: " .. tab.constraints
		end
	end)
end