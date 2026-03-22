include("shared.lua")
function ENT:Initialize()
	return
end

surface.CreateFont("BoxText", {
	font = "Inter",
	extended = true,
	size = 30,
	weight = 800,
})

hook.Add("PostPlayerDraw", "Box.ShowBox", function(ply)
	if IsValid(ply.JobModel) and not ply:GetNetVar("HasBox") then
		ply.JobModel:Remove()
		ply.JobModel = nil
		return
	end

	if not ply:GetNetVar("HasBox") then return end
	if not IsValid(ply.JobModel) then
		ply.JobModel = ClientsideModel("models/props_junk/cardboard_box003b.mdl")
		local box = ply.JobModel
		local nn = tostring(box)
		timer.Create(nn, 5, 0, function()
			if not IsValid(box) then
				timer.Remove(nn)
				return
			end

			if IsValid(ply) then return end
			box:Remove()
		end)
	end

	local box_model = ply.JobModel
	local offsetvec = Vector(0, 20, 0)
	local offsetang = Angle(0, -90, -90)
	local boneid = ply:LookupBone("ValveBiped.Bip01_Spine2")
	if not boneid then return end
	local matrix = ply:GetBoneMatrix(boneid)
	if not matrix then return end
	local newpos, newang = LocalToWorld(offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles())
	box_model:SetPos(newpos)
	box_model:SetAngles(newang)
	box_model:SetupBones()
	box_model:DrawModel()
end)

local color_white = color_white
local color_black = color_black
function ENT:Draw(flags)
	self:DrawModel(flags)
	if LocalPlayer():GetEyeTrace().Entity == self and self:GetPos():Distance(LocalPlayer():GetPos()) < 150 then
		local ang = self:GetAngles()
		ang[2] = ang[2] + 90
		cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 4.3 - self:GetAngles():Right() * 1.4 - self:GetAngles():Forward() * 1.5, ang, 0.1)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(-151, -37, 301, 45)
		draw.SimpleTextOutlined("Рационники", "BoxText", 0, -10, col.o, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(-151, 25, 301, 152)
		draw.SimpleTextOutlined("На складе: " .. GetGlobalInt("Rac.Count", 0), "BoxText", 0, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Нажмите E для", "BoxText", 0, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("взаимодействия", "BoxText", 0, 120, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		cam.End3D2D()
	end
end

function ENT:Think()
	return
end
