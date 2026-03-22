if not RTX then return end

-- Remix UI states
local UI_STATE_NONE = 0
local UI_STATE_BASIC = 1
local UI_STATE_ADVANCED = 2
local previousRtxUiState = UI_STATE_NONE

local blockEntityMenu = CreateClientConVar(
	"rtx_blockentitymenu",
	"0",
	true,
	false,
	"Disable context options pop-up when right-clicking on an entity",
	0,
	1
)

local enabled = false
local worldPanel = vgui.GetWorldPanel()
local hudPanel = GetHUDPanel()

-- detours EnableScreenClicker so even if another addon disables screen clicking, this addon's state still keeps it enabled
gui.tmc_EnableScreenClickerInternal = gui.EnableScreenClicker
function gui.EnableScreenClicker(bool, ...)
	return gui.tmc_EnableScreenClickerInternal(bool or enabled, ...)
end

-- detours OpenEntityMenu to control opening the entity menu by ConVar if the cursor is free
properties.tmc_OpenEntityMenuInternal = properties.OpenEntityMenu
function properties.OpenEntityMenu(ent, tr, ...)
	if blockEntityMenu:GetBool() and enabled then
		return
	end

	return properties.tmc_OpenEntityMenuInternal(ent, tr, ...)
end

-- Add this Think hook to monitor the Remix UI state
hook.Add("Think", "RTX.TMC_MonitorRemixUI", function()
    -- Check if the RemixConfig API exists (from our module)
    if not RemixConfig or not RemixConfig.GetUIState then return end

    -- Get the current UI state
    local rtxUiState = RemixConfig.GetUIState()

    -- Only process if the state has changed
    if rtxUiState ~= previousRtxUiState then
        local isRtxUiActive = rtxUiState ~= UI_STATE_NONE
        previousRtxUiState = rtxUiState

        -- Update cursor visibility based on Remix UI state
        enabled = isRtxUiActive
        gui.EnableScreenClicker(enabled)
        worldPanel:SetWorldClicker(enabled)
        hudPanel:SetWorldClicker(enabled)
				netstream.Start("RTX.SetState", rtxUiState)

        -- Update input blocking
        if enabled then
            -- Block input when Remix UI is active
            hook.Add("CreateMove", "RTX.TMC_BlockAttacks", function(cmd)
                cmd:RemoveKey(IN_ATTACK)
                cmd:RemoveKey(IN_ATTACK2)
                return true
            end)

            hook.Add("StartCommand", "RTX.TMC_BlockInput", function(ply, cmd)
                if ply == LocalPlayer() then
                    cmd:ClearMovement()
                    cmd:ClearButtons()
                end
            end)

            hook.Add("InputMouseApply", "RTX.TMC_BlockMouseInput", function()
                return true
            end)

        else
            -- Unblock input when Remix UI is closed
            hook.Remove("CreateMove", "RTX.TMC_BlockAttacks")
            hook.Remove("StartCommand", "RTX.TMC_BlockInput")
            hook.Remove("InputMouseApply", "RTX.TMC_BlockMouseInput")
        end
    end
end)

-- Add a debug command to display current UI state
concommand.Add("rtx_ui_state", function()
    if RemixConfig and RemixConfig.GetUIState then
        local rtxUiState = RemixConfig.GetUIState()
        local stateNames = {
            [UI_STATE_NONE] = "None (UI not visible)",
            [UI_STATE_BASIC] = "Basic UI",
            [UI_STATE_ADVANCED] = "Advanced UI"
        }

        print("Current RTX UI state:", rtxUiState, stateNames[rtxUiState] or "Unknown")
        print("TMC cursor enabled:", enabled)
    else
        print("RemixConfig API not available")
    end
end)