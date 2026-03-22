ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "April"
ENT.Author = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "UnionRP"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.nonfreeze = true
ENT.nofreeze = true

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel("models/items/cs_gift.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:EnableMotion(false)
		self:SetKeyValue("fademindist", 2800)
		self:SetKeyValue("fademaxdist", 2800)
	end

	function ENT:Use(ply)
		local data = {
			delaytime = 2.5,
			check = function(_ply) return IsValid(self) and _ply:GetEyeTraceNoCursor().Entity == self end,
			onaction = function(_ply) _ply:EmitSound("buttons/blip1.wav", 35, 100, 0.6) end,
			onfail = function(_ply) end,
			onfinish = function(_ply) netstream.Start(_ply, "AprilFoolEnt") end
		}

		ply:AddAction("Открываем", data)
	end
else
	local function Draw3DText(pos, ang, flipView)
		if flipView then
			-- Flip the angle 180 degrees around the UP axis
			ang:RotateAroundAxis(vector_up, 180)
		end

		cam.Start3D2D(pos, ang, 0.35)
		-- Actually draw the text. Customize this to your liking.
		draw.DrawText("Подарок!", "Point_Font", 0, 0, color_white, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	function ENT:Draw(flags)
		-- Draw the model
		self:DrawModel(flags)
		local t = SysTime()
		local pos = self:GetPos() + self:GetUp() * 33 + vector_up * math.sin(t) * 4
		local ang = Angle(0, t * 100 % 360, 90)
		Draw3DText(pos, ang, false)
		Draw3DText(pos, ang, true)
	end

	netstream.Hook("AprilFoolEnt", function()
		UI_Derma_Query("В честь дня рождения сервера, вы можете получить " .. DarkRP.formatMoney(300000), "День рождение сервера", "Получить", function()
			netstream.Start("AprilFoolEnt")
		end, "Не нужно")()
	end)
end
