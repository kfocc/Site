if not RTX then return end

local ENTITY = FindMetaTable("Entity")

local SuppressEngineLighting = render.SuppressEngineLighting
local MaterialOverride = render.MaterialOverride
local MaterialOverrideByIndex = render.MaterialOverrideByIndex
local GetMaterial = ENTITY.GetMaterial
local GetMaterials = ENTITY.GetMaterials
local GetSubMaterial = ENTITY.GetSubMaterial
local DrawModel = ENTITY.DrawModel
local EXCLUDED_PASSES = bit.bnot(STUDIO_RENDER + STUDIO_DRAWTRANSLUCENTSUBMODELS)

local function OverrideRTXEntities()
	local function DrawEnt(self, flags)
		if bit.band(flags, EXCLUDED_PASSES) > 0 then DrawModel(self, flags) return end

		SuppressEngineLighting(true)
		if GetMaterial(self) ~= "" then
			local mat = Material(GetMaterial(self))
			MaterialOverride(mat)
		end

		-- Fixes submaterial tool and lua SetSubMaterial
		for k, v in pairs(GetMaterials(self)) do
			if GetSubMaterial(self, k - 1) ~= "" then
				MaterialOverrideByIndex(k - 1, Material(GetSubMaterial(self, k - 1)))
			end
		end

		local new_flags = STUDIO_RENDER + STUDIO_STATIC_LIGHTING--flags + STUDIO_STATIC_LIGHTING -- Fix hash instability
		DrawModel(self, new_flags)
		MaterialOverride(nil)
		SuppressEngineLighting(false)
	end

	local function Set(ent)
		--ent:SetRenderMode(RENDERMODE_NORMAL)
		ent.RenderOverride = DrawEnt
	end

	for k, v in ents.Iterator() do
		if v:GetClass() == "class C_BaseFlex" then
			continue
		end
		Set(v)
	end

	hook.Add("NetworkEntityCreated","RTX.OverrideEntities", function(ent)
		Set(ent)
	end)

	hook.Add("DrawPhysgunBeam", "RTX.OverrideEntities", function() return false end)
end

local function OverrideRTXFunctions()
	halo.Add = function() end -- Моргающий белый экран от обводок
	halo.Render = function() end -- Моргающий белый экран от обводок
	halo.RenderedEntity = function() end -- Моргающий белый экран от обводок
	DrawColorModify = function() end -- Использует шейдер. Моргающий белый экран
end

OverrideRTXFunctions()
OverrideRTXEntities()

timer.Simple(1, function() -- Ломает рендер камеры
	hook.Remove("PostDraw2DSkyBox", "StormFox2.SkyBoxRender")
end)