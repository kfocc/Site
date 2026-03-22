local _this = aCrashScreen
local downloadQueue = {}

function _this:getSongByURL( url, callback, ignoreQueue )

	if not ignoreQueue then
		table.insert( downloadQueue, { url, callback } )
		if #downloadQueue > 1 then return end
	end

	sound.PlayURL( url, 'noplay noblock',
		function( channel, errorID, errorName )

			if IsValid( channel ) then
				callback( channel )
			else
				callback( channel, errorName, errorID )
			end

			table.remove( downloadQueue, 1 )
			if #downloadQueue > 0 then
				_this:getSongByURL( downloadQueue[ 1 ][ 1 ], downloadQueue[ 1 ][ 2 ], true )
			end

		end)

end
