IS_RTX = not render.SupportsVertexShaders_2_0() and util.IsBinaryModuleInstalled("RTXFixesBinary")
if not IS_RTX then return end
RTX = RTX or {}
require("RTXFixesBinary")