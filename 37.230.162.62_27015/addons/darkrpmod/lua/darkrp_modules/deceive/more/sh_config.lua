deceive.Config = {}
deceive.Config.NoDisguiseAsJobs = {
	"Civil Protection", -- In here, put names of jobs that shouldn't be able to disguise into other players. -- Leave empty to let everyone disguise.
	"Civil Protection Chief",
	"Mayor",
}

deceive.Config.NoDisguiseIntoJobs = {
	"Super Admin", -- In here, put names of jobs that shouldn't be able to be disguised as. -- Leave empty to let everyone disguise as anything. -- this is an example
}

deceive.Config.AllowedUserGroups = {} -- In here, put names of usergroups that players need to have in order to disguise. -- Leave empty to let everyone disguise. -- "donator", -- this is an example
-- Message that shows up if you try to disguise with an incorrect usergroup.
deceive.Config.DonatorOnlyMessage = "You need to donate in order to use our server's Disguise feature!"
-- The command people will have to input in the chat / console to remove their own disguise.
-- Default is "undisguise".
deceive.Config.UndisguiseCommand = "undisguise"
-- Time in seconds until a player is able to disguise again after disguising.
-- 0 will disable the cooldown.
deceive.Config.UseCooldown = 30
-- Number of times a disguise drawer can be used until it breaks.
-- 0 will make the number of uses infinite.
deceive.Config.DrawerMaxUses = 10
-- Amount of damage a disguise drawer can take before breaking.
-- 0 will make the disguise drawer unbreakable.
deceive.Config.DrawerHealth = 200
-- If true, the disguised player's job will show as the job of its target.
-- Set to false if you don't want this.
deceive.Config.FakeJob = true
-- If true, the disguised player will show as the name of its target.
-- Set to false if you don't want this.
deceive.Config.FakeName = true
-- If true, the disguised player will appear as the model of its target.
-- Set to false if you don't want this.
deceive.Config.FakeModel = true
-- If true, the disguised player's model color will appear as the model color of its target.
-- Set to false if you don't want this.
deceive.Config.FakeModelColor = true
-- If true, we will use the default shipments included with the addon.
-- Set to false if you want to have your own way of handling the shipments.
-- Feel free to change them to your liking if they suffice in this state.
deceive.Config.NoDefaultShipments = false
-- If true, a disguised player will hate its disguise removed when firing a weapon.
deceive.Config.RemoveOnAttack = true


deceive.Config.allCanMask = {
	[TEAM_BICH1] = true,
	[TEAM_CITIZEN1] = true,
	[TEAM_MPF1] = true,
	[TEAM_MPF2] = true,
	[TEAM_MPF3] = true,
	[TEAM_MPF4] = true,
	[TEAM_GSR1] = true,
	[TEAM_GSR2] = true,
	[TEAM_GSR3] = true,
	[TEAM_GSR4] = true,
}

--[[
deceive.Config.onlyCanMask = {
  [TEAM_AGENT] = {
    [TEAM_MPF6] = true, -- true, чтобы разрешить маскировку если её нет в списке allCanMask
    [TEAM_MPF7] = false, -- false, чтобы запретить маскировку под эту тиму если она есть в allCanMask
    [TEAM_MPF8] = true,
  }
}
-]]
deceive.Config.onlyCanMask = {
	[TEAM_AGENT] = {
		[TEAM_MPF6] = true,
		[TEAM_MPF7] = true,
		[TEAM_MPF8] = true,
	},
	[TEAM_ELITE4] = {
		[TEAM_GSR1] = false,
		[TEAM_GSR2] = false,
		[TEAM_GSR3] = false,
		[TEAM_GSR4] = false,
		[TEAM_CITIZEN2] = true,
	},
	[TEAM_GSPY] = {	
		[TEAM_MPF4] = false,
		[TEAM_GSR5] = true,
	},
	[TEAM_AFERIST] = {
		[TEAM_CITIZEN1] = false,
		[TEAM_GSR4] = false,
		[TEAM_GSR5] = false,
		[TEAM_MPF1] = false,
		[TEAM_MPF2] = false,
		[TEAM_MPF3] = false,
		[TEAM_MPF4] = false,
		[TEAM_GANG1] = true,
		[TEAM_GANG2] = true,
	},
}
