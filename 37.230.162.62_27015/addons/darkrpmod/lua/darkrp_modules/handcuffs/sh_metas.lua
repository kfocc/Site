local meta = FindMetaTable("Player")

function meta:IsHandcuffed()
	return self:GetNW2Bool("JSRestrained")
end

function meta:IsEscorted()
	return self:GetNW2Bool("JSEscorted")
end

function meta:CanUseScreeds()
	return self:GetNetVar("useScreeds", false) or self:GetNetVar("isUsedScreeds", false) or self:getJobTable().screeds
end
