Job = {}

--[[ JOB TYPES CONFIGURATION ]]
Job.NPC = {
	--hobo = {
	--	name = "Hobos",
	--	model = {"models/Humans/corpse1.mdl"},
	--	pos = {
	--		[1] = {
	--			pos = Vector(-1817.4630126953,-344.19561767578,-196.96875),
	--			angle = Angle(21.898780822754,-178.65776062012,0),
	--		}
	--
	--	},
	--	limit = 1
	--},
	commerce = {
		name = "Commerce", -- type name
		model = {
			"models/mossman.mdl", -- NPC models
			"models/Humans/Group02/male_08.mdl"
		},
		pos = {
			-- NPC positions
			[1] = {
				pos = Vector(-852.093750, -968.375000, -195.968750),
				angle = Angle(0.000, -90.000, 0.000),
			},
			[2] = {
				pos = Vector(-809.58392333984, -971.39575195313, -195.96875),
				angle = Angle(0, -86.806198120117, 0),
			}
		},
		limit = 0.4 -- percentage limit (40% of players allowed to pick a job which has commerce type)
	},
	police = {
		name = "Police Force",
		model = {"models/breen.mdl"},
		pos = {
			[1] = {
				pos = Vector(-1577.093750, 221.031250, -159.968750),
				angle = Angle(0, -90, 0),
			}
		},
		limit = 0.3
	},
	crime = {
		name = "Crime",
		model = {"models/Humans/Group03/male_07.mdl", "models/Humans/Group03/Male_01.mdl", "models/Humans/Group03/Male_05.mdl"},
		pos = {
			[1] = {
				pos = Vector(-446.437500, 165.000000, -203.968750),
				angle = Angle(0.000, 90.000, 0.000),
			}
		},
		limit = 0.5
	}
}

function Job:Get(name)
	return Job.NPC[name]
end
