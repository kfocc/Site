UAnim = UAnim or {}
UAnim.Anims = UAnim.Anims or {
	BONE_HAND_RIGHT = "ValveBiped.Bip01_R_Hand",
	BONE_UPPERARM_RIGHT = "ValveBiped.Bip01_R_UpperArm",
	BONE_FOREARM_RIGHT = "ValveBiped.Bip01_R_Forearm",
	BONE_FOOT_RIGHT = "ValveBiped.Bip01_R_Foot",
	BONE_THIGH_RIGHT = "ValveBiped.Bip01_R_Thigh",
	BONE_CALF_RIGHT = "ValveBiped.Bip01_R_Calf",
	BONE_SHOULDER_RIGHT = "ValveBiped.Bip01_R_Shoulder",
	BONE_ELBOW_RIGHT = "ValveBiped.Bip01_R_Elbow",

	BONE_HAND_LEFT = "ValveBiped.Bip01_L_Hand",
	BONE_UPPERARM_LEFT = "ValveBiped.Bip01_L_UpperArm",
	BONE_FOREARM_LEFT = "ValveBiped.Bip01_L_Forearm",
	BONE_FOOT_LEFT = "ValveBiped.Bip01_L_Foot",
	BONE_THIGH_LEFT = "ValveBiped.Bip01_L_Thigh",
	BONE_CALF_LEFT = "ValveBiped.Bip01_L_Calf",
	BONE_SHOULDER_LEFT = "ValveBiped.Bip01_L_Shoulder",
	BONE_ELBOW_LEFT = "ValveBiped.Bip01_L_Elbow",

	BONE_HEAD = "ValveBiped.Bip01_Head1",
}

local animationsInfo = {}
local function register(animationInfo)
	return table.insert(animationsInfo, animationInfo)
end

function UAnim.GetAnimations()
	return animationsInfo
end

UAnim.ANIMATION_CUFF = register({
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(-20, 16.6, 0),
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(-10, 0, 0),
	[UAnim.Anims.BONE_UPPERARM_LEFT] = Angle(20, 8.8, 0),
	[UAnim.Anims.BONE_FOREARM_LEFT] = Angle(10, 0, 0),
	[UAnim.Anims.BONE_HAND_RIGHT] = Angle(0, 0, -75),
	[UAnim.Anims.BONE_HAND_LEFT] = Angle(0, 0, 75),
})

UAnim.ANIMATION_SURRENDER = register({
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(90, 0, 90),
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(0, -85, 0),
	[UAnim.Anims.BONE_UPPERARM_LEFT] = Angle(-90, 0, -90),
	[UAnim.Anims.BONE_FOREARM_LEFT] = Angle(0, -75, 20),
})

UAnim.ANIMATION_CROSSARMS = register({
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(3.809, 15.382, 2.654),
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(-63.658, 1.8, -84.928),
	[UAnim.Anims.BONE_UPPERARM_LEFT] = Angle(3.809, 15.382, 2.654),
	[UAnim.Anims.BONE_FOREARM_LEFT] = Angle(53.658, -29.718, 31.455),
	[UAnim.Anims.BONE_THIGH_RIGHT] = Angle(4.829, 0, 0),
	[UAnim.Anims.BONE_THIGH_LEFT] = Angle(-8.89, 0, 0),
})

UAnim.ANIMATION_LOOKUP = register({
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(10, -20),
	[UAnim.Anims.BONE_HAND_RIGHT] = Angle(0, 1, 50),
	[UAnim.Anims.BONE_HEAD] = Angle(0, -30, -20),
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(0, -65, 39.8863),
})

UAnim.ANIMATION_POINT = register({
	["ValveBiped.Bip01_R_Finger2"] = Angle(4.151602268219, -52.963024139404, 0.42117667198181),
	["ValveBiped.Bip01_R_Finger21"] = Angle(0.00057629722869024, -58.618747711182, 0.001297949347645),
	["ValveBiped.Bip01_R_Finger3"] = Angle(4.151602268219, -52.963024139404, 0.42117667198181),
	["ValveBiped.Bip01_R_Finger31"] = Angle(0.00057629722869024, -58.618747711182, 0.001297949347645),
	["ValveBiped.Bip01_R_Finger4"] = Angle(4.151602268219, -52.963024139404, 0.42117667198181),
	["ValveBiped.Bip01_R_Finger41"] = Angle(0.00057629722869024, -58.618747711182, 0.001297949347645),
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(25.019514083862, -87.288040161133, -0.0012286090059206),
})

UAnim.ANIMATION_HIGHFIVE = register({
	[UAnim.Anims.BONE_FOREARM_LEFT] = Angle(25, -65, 25),
	[UAnim.Anims.BONE_UPPERARM_LEFT] = Angle(-70, -180, 70),
})

UAnim.ANIMATION_SALUTE = register({
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(40, -130, 30),
	[UAnim.Anims.BONE_HAND_RIGHT] = Angle(10, -10, 0),
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(80, 0, 0),
})

UAnim.ANIMATION_DAB = register({
	[UAnim.Anims.BONE_UPPERARM_RIGHT] = Angle(50, -75, -74),
	[UAnim.Anims.BONE_FOREARM_RIGHT] = Angle(25, -120, 0),
	[UAnim.Anims.BONE_UPPERARM_LEFT] = Angle(-60, 90, -100),
	[UAnim.Anims.BONE_HEAD] = Angle(-45, -10, -40),
})

function UAnim.GetAnimationInfo(animationIndex)
	return animationsInfo[animationIndex]
end

hook.Run("UAnim.Initialed")
