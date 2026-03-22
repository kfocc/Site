if SERVER then
	local _R = debug.getregistry()
	local meta = _R.Player

	function meta:ChatAddText(...)
		netstream.Start(self, "chatAddText", ...)
	end

	function ChatAddText(...)
		netstream.Start(nil, "chatAddText", ...)
	end
end

if CLIENT then
	netstream.Hook("chatAddText", function(...)
		chat.AddText(...)
	end)
end