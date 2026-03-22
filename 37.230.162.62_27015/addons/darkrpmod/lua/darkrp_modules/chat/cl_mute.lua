local PLAYER = FindMetaTable("Player")

function PLAYER:_SetMuted(bool)
	if bool then
		if not self:_IsMuted() then
			self.oldVoiceVolumeScale = self:GetVoiceVolumeScale()
			self:SetVoiceVolumeScale(0)
		end
	else
		if self:_IsMuted() then
			local oldScale = self.oldVoiceVolumeScale or 1
			self:SetVoiceVolumeScale(oldScale)
			self.oldVoiceVolumeScale = nil
		end
	end
end

function PLAYER:_IsMuted()
	return self:GetVoiceVolumeScale() < 0.2
end
