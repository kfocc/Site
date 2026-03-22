local broadcasts = broadcasts or {}
_G.broadcasts = broadcasts

if CLIENT then
	broadcasts.speakerModel = "models/props_wasteland/speakercluster01a.mdl"
	broadcasts.maxDist = 1024 * 1024
	broadcasts.volume = 0.2
else
	broadcasts.delayTime = {2700, 3600}

	broadcasts.soundsList = {
		"unionrp/broadcast/1.mp3",
		"unionrp/broadcast/2.mp3",
		"unionrp/broadcast/3.mp3",
		"unionrp/broadcast/4.mp3",
		"unionrp/broadcast/5.mp3",
		"unionrp/broadcast/6.mp3",
		"unionrp/broadcast/7.mp3",
		"unionrp/broadcast/8.mp3",
		"unionrp/broadcast/9.mp3",
		"unionrp/broadcast/10.mp3",
		"unionrp/broadcast/11.mp3",
		"unionrp/broadcast/12.mp3",
		"unionrp/broadcast/13.mp3",
		"unionrp/broadcast/14.mp3",
		"unionrp/broadcast/15.mp3",
		"unionrp/broadcast/16.mp3",
		"unionrp/broadcast/17.mp3",
		"unionrp/broadcast/18.mp3",
		"unionrp/broadcast/19.mp3",
	}
end
