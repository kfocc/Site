local _this = aCrashScreen.config
---------------------------------

-- Your community name
_this.communityName = "UnionRP"

_this.reconnectText = {"Сервер не отвечает или перезагружается!", "В случае перезагрузки сервера, вам будут возвращены:", "Токены за принтеры, ваша профессия, свепы и пропы."}

-- The web-based server status checker
-- This will check if the server is online, if it is it will automatically reconnect
-- Set this to false if you want to use auto reconnection after x amount of seconds
_this.serverStatusURL = false

-- How long to wait for the client to reconnect to the server when it is back up
-- If you're reconnecting before the server is fully loaded, increase this value
_this.serverOnlineReconnectingTime = 20

-- Only if serverStatusURL is false, this will auto reconnect after x amount of seconds
_this.reconnectingTime = 40

-- THIS server's IP address and Port
-- Only needed if you use serverStatusURL
_this.serverIP = "37.230.162.62"
_this.serverPort = "27015"

-- Color of the background, will only be shown if the background image is disabled
_this.backgroundColor = Color( 0, 75, 130 )

-- Song(s), has to be a direct url to the file
-- Will be chosen randomly, but will only play once until all songs have been played
-- Set this to false if you want this disabled
_this.songUrls = { -- NOTE: These songs are place holders, they most likely will not work
	"https://unionrp.info/hl2rp/track1.mp3",
	"https://unionrp.info/hl2rp/track2.mp3"
}

-- If you want to adjust the looks of the crash menu find file 'cl_menu.lua'
-- To enable readable error messages go to 'sh_start.lua'
-- Obviously this will require you to have some GLua knowledge
-- If you do manage to break something while editing this file do not ask for support, revert the changes instead

--[[////////////////////////// Contact & Support /////////////////////////////////
//                                                                              //
//        If you find any bugs or have a problem feel free to contact me:       //
//                    http://steamcommunity.com/id/ikefi                        //
//                     As my profile description states:                        //
//               i might not add you right away or not at all.                  //
//              it'll be better to just create a ticket instead.                //
//                                                                              //
////////////////////////////////////////////////////////////////////////////////]]