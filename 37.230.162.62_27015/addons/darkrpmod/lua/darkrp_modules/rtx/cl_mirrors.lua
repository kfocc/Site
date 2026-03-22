if not RTX then return end

RTX.Mirrors = RTX.Mirrors or {}
local function CreateMirrors()
	netstream.Start("RTX.ClearMirrors")
	for k, v in ipairs(RTX.Mirrors) do
		RTX.Mirrors[k] = nil
		if IsValid(v) then
			v:Remove()
		end
	end

	for k, v in ipairs(NikNaks.CurrentMap:FindByClass("func_reflective_glass")) do
		local origin = v.origin
		if not origin then
			print("Invalid origin for func_reflective_glass entity - " .. tostring(origin))
			continue
		end
		local model = v.model
		if not model then
			print("Invalid model for func_reflective_glass entity - " .. tostring(model))
			continue
		end
		local angles = v.angles
		local ent = ClientsideModel(model, RENDERGROUP_STATIC)
		ent:SetPos(origin)
		if angles then
			ent:SetAngles(angles)
		end
		ent:DrawShadow(false)
		table.insert(RTX.Mirrors, ent)
	end
end

hook.Add("InitPostEntity", "RTX.CreateMirrors", CreateMirrors)

concommand.Add("rtx_createmirrors", CreateMirrors)