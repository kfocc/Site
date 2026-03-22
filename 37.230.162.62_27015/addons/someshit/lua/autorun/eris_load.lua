Eris = {}
 
if(SERVER) then 
	AddCSLuaFile("eris/cl_init.lua")
	AddCSLuaFile("eris/sh_init.lua")
	AddCSLuaFile("eris/config.lua") 

	include("eris/config.lua") 
	include("eris/sh_init.lua")
else 
	timer.Simple(5, function()
		include("eris/cl_init.lua") 
		include("eris/sh_init.lua") 
		include("eris/config.lua")
	end)
end  
 
local path = "eris/ui/"
local files = file.Find(path.."*.lua", "LUA")
function Eris.Load()
	for _, f in pairs(files) do 
		local path = path..f

		if(SERVER) then   
			if(f:StartWith("sh_")) then 
				AddCSLuaFile(path) 
				include(path)    
			end 
	 
			if(f:StartWith("cl_")) then
				AddCSLuaFile(path)
			end

			if(f:StartWith("sv_")) then
				include(path)
			end
		else
			timer.Simple(5, function()
				include(path)
			end)
		end
	end
end
Eris.Load()