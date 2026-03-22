local pMeta = FindMetaTable("Player")
CID = CID or {}

function pMeta:GetCID()
	return self:GetNetVar("CID", "#####")
end
pMeta.GetID = pMeta.GetCID

CID.restrictedCID = {"001", "0001", "0002", "0003", "0004", "0005", "0006", "0007", "0008", "0009", "00001", "00002", "00003", "00004", "00005", "00006", "00007", "00008", "00009", "002", "003", "004", "005", "006", "007", "008", "009", "314", "228", "282", "911", "1488", "1337", "10007", "000", "111", "222", "333", "444", "555", "666", "777", "888", "999", "0000", "1111", "2222", "3333", "4444", "5555", "6666", "7777", "8888", "9999", "00000", "11111", "22222", "33333", "44444", "55555", "66666", "77777", "88888", "99999", "000000", "111111", "222222", "333333", "444444", "555555", "666666", "777777", "888888", "999999"}

for k, v in ipairs(CID.restrictedCID) do
	CID.restrictedCID[v] = true
	CID.restrictedCID[k] = nil
end

CID.acceptedCID = {
	[3] = "^(%d%d%d)$",
	[4] = "^(%d%d%d%d)$",
	[5] = "^(%d%d%d%d%d)$",
	[6] = "^(%d%d%d%d%d%d)$",
}

CID.changePrice = 30000
CID.CoolDown = 300

CID.changeTempPrice = 2500
CID.tempCoolDown = 30

-- CID.s64Len = 17
CID.defaultLen = 5
