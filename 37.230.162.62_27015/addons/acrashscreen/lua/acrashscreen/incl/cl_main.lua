local _this = aCrashScreen

-- Start ahead so the screen doesn't pop up when you join the server.
-- If server crashes at this time it's most likely stuck at the 'Sending client info' anyway
local lastProcessTick = SysTime()

local isProcessActive = false
local reconnectingTime = 15

local startProcess, stopProcess, processTick

function startProcess()

	-- Set process to active
	isProcessActive = true

	-- Reset these values
	reconnectingTime = _this.config.reconnectingTime or 40

	-- Create menu
	ESCMenu:Show()
	ESCMenu:SetFlags(bit.bor(ESCMenu:GetFlags(), 2^2))

	if _this.config.songUrls then
		-- Play the song
		_this:playSong()
	end

end

function stopProcess()

	-- Set the process inactive
	isProcessActive = false

	ESCMenu:SetFlags(bit.band(ESCMenu:GetFlags(), bit.bnot(2^2)))
	if bit.band(ESCMenu:GetFlags(), 2^1) == 0 then
		ESCMenu:Hide()
	end

	-- Stop the song
	_this:stopSong()

end

function processTick()

	-- Start process if not active ( on first tick )
	if not isProcessActive then
		startProcess()
	end

	-- Reconnect
	local timeout, lastPing = GetTimeoutInfo()
	if reconnectingTime <= lastPing then
		RunConsoleCommand( 'retry' )
	end
end

local function tick()
	local timeout, lastPing = GetTimeoutInfo()

	-- If the server didn't ping for 5 seconds it most likely crashed
	-- This is about the same time when the 'server not responding' text comes up
	if timeout then

		-- Call this each second when the server is not responding
		if not isProcessActive or lastPing - lastProcessTick >= 1 then
			processTick()
			lastProcessTick = lastPing
		end

	-- End the process
	elseif isProcessActive then
		stopProcess()
	end

end
hook.Add( 'Think', 'aCrashScreen', tick ) -- Timers don't work when the server is not responding