SCR = SCR or {}
local function StopThinking()
	hook.Remove("PostRender", "TakeScreenshot")
end

local function SendToServer(iID, link, hash)
	netstream.Start("SCR.Request", iID, link, hash)
end

netstream.Hook("SCR.Request", function(iID, link, auth, quality, filename)
	if filename and file.Exists(filename, "MOD") then
		local screen = file.Read(filename, "MOD")
		SCR.Upload(util.Base64Encode(screen), link, auth, function(link) SendToServer(iID, link, auth) end)
		return
	end

	SCR.TakeScreenshot(link, auth, quality, function(link) SendToServer(iID, link, auth) end, filename)
end)

local function TakeScreenshot(fCallback, quality)
	hook.Add("PostRender", "TakeScreenshot", function()
		local scrdat = render.Capture({
			format = "jpeg",
			quality = quality or 50,
			h = ScrH(),
			w = ScrW()
		})

		if not scrdat then return end
		StopThinking()
		local base64 = util.Base64Encode(scrdat)
		fCallback(base64)
	end)
end

local requests = {}
function SCR.RequestAndUpload(pl, name, callback)
	local id = #requests + 1
	requests[id] = callback
	netstream.Start(pl, "SCR.RequestAndUpload", name)
end

function SCR.Upload(base64, link, auth, fCallback)
	fCallback = fCallback or print
	local params = {
		["image"] = base64,
		["auth"] = auth,
	}

	http.Post(link, params, function(result)
		local tDat = util.JSONToTable(result)
		if not tDat.success then
			local err = tDat.data and tDat.data.error or tDat.errors and tDat.errors[1]
			fCallback({
				error = "sg error: " .. (err.message or err.detail or err.status or "UNKNOWN") .. " (" .. (err.code or "UNKNOWN") .. ")"
			})
			return
		end

		fCallback(tDat.data)
	end, function(failed)
		fCallback({
			error = "sg: fallback " .. (failed or "!")
		})
	end)
end

function SCR.TakeScreenshot(link, auth, quality, fCallback, filename)
	TakeScreenshot(function(screen) SCR.Upload(screen, link, auth, fCallback) end, quality)
end
