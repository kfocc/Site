if not RTX then return end

local convars = {
	["r_drawsprites"] = 0,
	["r_drawdecals"] = 0,
	["mat_disable_d3d9ex"] = 1,
	["mat_softwarelighting"] = 0,
	["gmod_mcore_test"] = 1,
	["mat_queue_mode"] = 2,
	["r_novis"] = 1,
	["r_frustumcullworld"] = 0,
	["r_occlusion"] = 0,
	["r_lod"] = 0,
	["r_staticprop_lod"] = 0,
	["r_worldlights"] = 16,
	["r_unloadlightmaps"] = 1,
	["r_shadows"] = 0,
	["r_glint_alwaysdraw"] = -1,
	["r_3dsky"] = 0,
	["r_WaterDrawReflection"] = 0,
	["r_WaterDrawRefraction"] = 0,
	["r_radiosity"] = 0,
	["r_PhysPropStaticLighting"] = 0,
	["r_colorstaticprops"] = 0,
	["r_lightinterp"] = 0,
	["r_performant_enable"] = 0,
}

local convars_runconsolecommand = {
	["mat_disable_d3d9ex"] = 1,
	["mat_softwarelighting"] = 0,
	["gmod_mcore_test"] = 1,
	["mat_queue_mode"] = 2,
	["r_frustumcullworld"] = 0,
	["r_occlusion"] = 0,
	["r_lod"] = 0,
	["r_staticprop_lod"] = 0,
	["r_worldlights"] = 16,
	["r_shadows"] = 0,
	["r_glint_alwaysdraw"] = -1,
	--["r_3dsky"] = 0,
	["r_WaterDrawReflection"] = 0,
	["r_WaterDrawRefraction"] = 0,
	["r_radiosity"] = 0,
	["r_PhysPropStaticLighting"] = 0,
	--["r_performant_enable"] = 0,
}

local function ApplyConvars()
	for k, v in pairs(convars_runconsolecommand) do
		RunConsoleCommand(k, v)
	end
end
timer.Simple(10, ApplyConvars)