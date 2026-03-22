AddCSLuaFile()

SWEP.PrintName = "CID"
SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "UnionRP"
SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Показать CID-карту\nПКМ: Посмотреть CID-карту"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.HoldType = "pistol"
SWEP.WeaponHoldType = "pistol"

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 5
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 5
SWEP.Secondary.Ammo = "none"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/perp2/v_fists.mdl"
SWEP.WorldModel = "models/perp2/w_fists.mdl"

SWEP.ShowViewModel = true
SWEP.NonCheck = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["Bip01 L Arm2"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Bip01 L Hand"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Bip01 L Arm1"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Bip01 L Arm"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(-0.556, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Bip01"] = {
		scale = Vector(0.887, 0.887, 0.887),
		pos = Vector(0.555, 0.925, 0),
		angle = Angle(0, 0, 0)
	}
}

SWEP.ViewModelBoneMods = {
	["Bip01 L Arm"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(-0.556, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Bip01"] = {
		scale = Vector(1, 1, 1),
		pos = Vector(0.185, 0, 0),
		angle = Angle(0, 0, 0)
	}
}

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.VElements = {
	["id"] = {
		type = "Model",
		model = "models/dorado/tarjeta4.mdl",
		bone = "Bip01",
		rel = "",
		pos = Vector(18.6, 0, 25.454),
		angle = Angle(-90, 90, 100),
		size = Vector(1.2, 1.2, 1.2),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {
	["ide"] = {
		type = "Model",
		model = "models/dorado/tarjeta4.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(3.5, 4, 0),
		angle = Angle(-90, -90, -90),
		size = Vector(1.2, 1.2, 1.2),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		skin = 0,
		bodygroup = {}
	}
}

function SWEP:Initialize()
	self:SetWeaponHoldType("pistol")
	self:SetHoldType("pistol")
	--local ModelCheck = string.find( self:GetOwner():GetModel():lower(), "female" )
	--if ModelCheck then self.WElements["ide"].modelEnt = ("models/weapons/w_tfa_starshiptroopers_fleetspaceman.mdl") else self.WElements["ide"].modelEnt = ("models/weapons/w_tfa_clonecard_c6.mdl") end
	if CLIENT then
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		if IsValid(self:GetOwner()) then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				if self.ShowViewModel == nil or self.ShowViewModel then
					vm:SetColor(Color(255, 255, 255, 255))
				else
					vm:SetColor(Color(255, 255, 255, 1))
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
			if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip then ang.r = -ang.r end
		end
		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if not tab then return end
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

			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if not bone then continue end
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

	function table.FullCopy(tab)
		if not tab then return nil end
		local res = {}
		for k, v in pairs(tab) do
			if type(v) == "table" then
				res[k] = table.FullCopy(v)
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
