local eMeta = debug.getregistry().Entity

--[[-------------------------------------------------------------------------
Get
---------------------------------------------------------------------------]]

eMeta.oldGetNWAngle = eMeta.GetNWAngle
eMeta.oldGetNWBool = eMeta.GetNWBool
eMeta.oldGetNWEntity = eMeta.GetNWEntity
eMeta.oldGetNWFloat = eMeta.GetNWFloat
eMeta.oldGetNWInt = eMeta.GetNWInt
eMeta.oldGetNWString = eMeta.GetNWString

eMeta.GetNWAngle = eMeta.GetNW2Angle
eMeta.GetNWBool = eMeta.GetNW2Bool
eMeta.GetNWEntity = eMeta.GetNW2Entity
eMeta.GetNWFloat = eMeta.GetNW2Float
eMeta.GetNWInt = eMeta.GetNW2Int
eMeta.GetNWString = eMeta.GetNW2String

--[[-------------------------------------------------------------------------
Set
---------------------------------------------------------------------------]]

eMeta.oldSetNWAngle = eMeta.SetNWAngle
eMeta.oldSetNWBool = eMeta.SetNWBool
eMeta.oldSetNWEntity = eMeta.SetNWEntity
eMeta.oldSetNWFloat = eMeta.SetNWFloat
eMeta.oldSetNWInt = eMeta.SetNWInt
eMeta.oldSetNWString = eMeta.SetNWString

eMeta.SetNWAngle = eMeta.SetNW2Angle
eMeta.SetNWBool = eMeta.SetNW2Bool
eMeta.SetNWEntity = eMeta.SetNW2Entity
eMeta.SetNWFloat = eMeta.SetNW2Float
eMeta.SetNWInt = eMeta.SetNW2Int
eMeta.SetNWString = eMeta.SetNW2String
