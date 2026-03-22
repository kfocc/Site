local meta = FindMetaTable("Player")

DarkRP.LPPocket = DarkRP.LPPocket or {}

function meta:getPocketItems()
	if self ~= LocalPlayer() then return nil end
	return DarkRP.LPPocket
end
