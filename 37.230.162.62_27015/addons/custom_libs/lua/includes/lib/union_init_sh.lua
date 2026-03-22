union = union or {}
local union = union
union.cvars = union.cvars or {}

union.cvars.winter = CreateConVar("winter_event_enabled", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable winter event")
union.cvars.halloween = CreateConVar("halloween_event_enabled", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable halloween event")
union.cvars.spawn_pumpkin = CreateConVar("spawn_pumpkin_enabled", 0, FCVAR_REPLICATED + FCVAR_ARCHIVE, "Enable spawn pumpkin")