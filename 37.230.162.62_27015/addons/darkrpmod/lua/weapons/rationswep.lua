SWEP.PrintName = "Рацион"
SWEP.HoldType = "slam"
SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Использовать рацион"
SWEP.Category = "UnionRP"
SWEP.Slot = 0
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.ViewModelFOV = 76.381909547739
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_package.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = {
		scale = Vector(1.108, 1.108, 1.108),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["ValveBiped.Bip01_L_Clavicle"] = {
		scale = Vector(1.016, 1.016, 1.016),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["ValveBiped.Grenade_body"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(-0.926, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["ValveBiped.Bip01_R_Hand"] = {
		scale = Vector(1.016, 1.016, 1.016),
		pos = Vector(0.185, -0.186, 0),
		angle = Angle(0, 0, 0)
	}
}

SWEP.VElements = {
	["package"] = {
		type = "Model",
		model = "models/weapons/w_package.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(-0.519, 1.557, 0),
		angle = Angle(101.688, -1.17, 5.843),
		size = Vector(0.95, 0.95, 0.95),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

function SWEP:Initialize()
	self:SetHoldType("slam")
	-- other initialize code goes here
	if CLIENT then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		--self:SetHoldType("slam")
		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		-- init view model bone build function
		if IsValid(self:GetOwner()) then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				-- Init viewmodel visibility
				if self.ShowViewModel == nil or self.ShowViewModel then
					vm:SetColor(Color(255, 255, 255, 255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255, 255, 255, 1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")
				end
			end
		end
	end
end

function SWEP:Holster()
	if CLIENT and IsValid(self:GetOwner()) then
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then self:ResetBonePositions(vm) end
	end
	return true
end

function SWEP:PrimaryAttack()
	if self.wait then return end
	self.wait = true
	self:SetHoldType("smg")
	self:EmitSound("physics/cardboard/cardboard_box_break3.wav")
	if CLIENT then
		RunConsoleCommand("say", "/me открывает рацион")
	else
		timer.Simple(1, function()
			if not IsValid(self) then return end
			local owner = self:GetOwner()
			local loyallvl = owner:getJobTable().loyallvl or 50
			local money = (loyallvl / 50) * 1000
			owner:addMoney(money, "Рацион")
			owner:setSelfDarkRPVar("Energy", 100)
			DarkRP.notify(owner, 2, 4, "+" .. money .. " токенов")
			DarkRP.notify(owner, 2, 4, "Вы снова сыты")
			self:Remove()
			owner:SelectWeapon("keys")
			owner:EmitSound("physics/concrete/concrete_impact_hard3.wav")
		end)
	end
end

function SWEP:SecondaryAttack()
	return
end

local function RemoveClientModels(tab)
	if not istable(tab) then return end
	for k, v in pairs(tab) do
		local ent = v.modelEnt
		if IsValid(ent) then ent:Remove() end
	end
end

function SWEP:OnRemove()
	self:Holster()
	if CLIENT then
		RemoveClientModels(self.VElements)
		RemoveClientModels(self.WElements)
	end
end

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self:GetOwner():GetViewModel()
		if not IsValid(vm) then return end
		if not self.VElements then return end
		self:UpdateBonePositions(vm)
		if not self.vRenderOrder then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			for k, v in pairs(self.VElements) do
				if v.type == "Model" then
					table.insert(self.vRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]
			if not v then
				self.vRenderOrder = nil
				break
			end

			if v.hide then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if not v.bone then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos then continue end
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then model:SetBodygroup(k, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if self.ShowWorldModel == nil or self.ShowWorldModel then self:DrawModel() end
		if not self.WElements then return end
		if not self.wRenderOrder then
			self.wRenderOrder = {}
			for k, v in pairs(self.WElements) do
				if v.type == "Model" then
					table.insert(self.wRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		if IsValid(self:GetOwner()) then
			bone_ent = self:GetOwner()
		else
			-- when the weapon is dropped
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]
			if not v then
				self.wRenderOrder = nil
				break
			end

			if v.hide then continue end
			local pos, ang
			if v.bone then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if not pos then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then model:SetBodygroup(k, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang
		if tab.rel and tab.rel ~= "" then
			local v = basetab[tab.rel]
			if not v then return end
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation(basetab, v, ent)
			if not pos then return end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if not bone then return end
			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ent:GetBoneMatrix(bone)
			if m then pos, ang = m:GetTranslation(), m:GetAngles() end
			if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip then
				ang.r = -ang.r -- Fixes mirrored models
			end
		end
		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if not tab then return end
		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs(tab) do
			if v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME") then
				if IsValid(v.modelEnt) then v.modelEnt:Remove() end
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if IsValid(v.modelEnt) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			elseif v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME") then
				local name = v.sprite .. "-"
				local params = {
					["$basetexture"] = v.sprite
				}

				-- make sure we create a unique name based on the selected options
				local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}
				for i, j in pairs(tocheck) do
					if v[j] then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false
	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if not vm:GetBoneCount() then return end
			-- !! WORKAROUND !! //
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if not hasGarryFixedBoneScalingYet then
				allbones = {}
				for i = 0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if self.ViewModelBoneMods[bonename] then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1, 1, 1),
							pos = Vector(0, 0, 0),
							angle = Angle(0, 0, 0)
						}
					end
				end

				loopthrough = allbones
			end

			-- !! ----------- !! //
			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if not bone then continue end
				-- !! WORKAROUND !! //
				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)
				if not hasGarryFixedBoneScalingYet then
					local cur = vm:GetBoneParent(bone)
					while cur >= 0 do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms
				-- !! ----------- !! //
				if vm:GetManipulateBoneScale(bone) ~= s then vm:ManipulateBoneScale(bone, s) end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then vm:ManipulateBoneAngles(bone, v.angle) end
				if vm:GetManipulateBonePosition(bone) ~= p then vm:ManipulateBonePosition(bone, p) end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		if not vm:GetBoneCount() then return end
		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, Vector(1, 1, 1))
			vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
			vm:ManipulateBonePosition(i, Vector(0, 0, 0))
		end
	end

	--[[*************************
		Global utility code
	*************************]]
	-- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	-- Does not copy entities of course, only copies their reference.
	-- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy(tab)
		if not tab then return nil end
		local res = {}
		for k, v in pairs(tab) do
			if type(v) == "table" then
				res[k] = table.FullCopy(v) -- recursion ho!
			elseif type(v) == "Vector" then
				res[k] = Vector(v.x, v.y, v.z)
			elseif type(v) == "Angle" then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		return res
	end
end
