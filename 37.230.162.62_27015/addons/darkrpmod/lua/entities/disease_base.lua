AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "health_item_base"

ENT.Category  = "Diseases"
ENT.Spawnable = false

-- Базовые значения
ENT.ItemDelay = 10
ENT.ItemSound = "items/medshot4.wav"
ENT.ItemText  = "Применение..."
ENT.ErrorText = "Этот препарат вам не подходит."

function ENT:Use(_, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local name = ply:GetDiseaseName()
    if not name or not (self.Cures and self.Cures[name]) then
        DarkRP.notify(ply, 1, 4, self.ErrorText)
        return
    end

    local data = {
        delaytime = self.ItemDelay,

        check = function(p)
            return IsValid(self)
                and IsValid(p)
                and p:Alive()
                and p:GetEyeTrace().Entity == self
                and p:GetPos():DistToSqr(self:GetPos()) <= 100 * 100
        end,

        onfinish = function(p)
            if not IsValid(self) or not IsValid(p) or not p:Alive() then return end

            p:SetDisease(0)

            self:EmitSound(self.ItemSound, 60, 100, 0.8)
            self:Remove()
        end
    }

    ply:AddAction(self.ItemText, data)
end