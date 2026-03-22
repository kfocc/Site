if not DarkRP or (not DarkRP.createJob and not RPExtraTeams) then
	DarkRP = {}
	RPExtraTeams = {}
	local jobCount = 0
	function DarkRP.createJob(Name, colorOrTable, model, Description, Weapons, command, maximum_amount_of_this_class, Salary, admin, Vote, Haslicense, NeedToChangeFrom, CustomCheck)
		local tableSyntaxUsed = not IsColor(colorOrTable)

		local CustomTeam =
			tableSyntaxUsed and colorOrTable or
			{
				color = colorOrTable,
				model = model,
				description = Description,
				weapons = Weapons,
				command = command,
				max = maximum_amount_of_this_class,
				salary = Salary,
				admin = admin or 0,
				vote = tobool(Vote),
				hasLicense = Haslicense,
				NeedToChangeFrom = NeedToChangeFrom,
				customCheck = CustomCheck
			}
		CustomTeam.name = Name

		jobCount = jobCount + 1
		CustomTeam.team = jobCount

		CustomTeam.salary = math.floor(CustomTeam.salary)
		table.insert(RPExtraTeams, CustomTeam)
		return jobCount
	end

	local pMeta = FindMetaTable("Player")
	function pMeta:getJobTable(ply)
		local tbl = RPExtraTeams[ply:Team()]
		return tbl or {}
	end

	if SERVER then
		AddCSLuaFile("darkrp_customthings/jobs.lua")
	end

	include("darkrp_customthings/jobs.lua")
	MsgC(Color(255, 0, 0), "Included darkrp_customthings/jobs.lua.\n")
end
