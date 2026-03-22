UAnim = UAnim or {}
UAnim.Players = UAnim.Players or {}
UAnim.ANIMATION_START_ANGLES = Angle(0, 0, 0)
UAnim.ANIMATION_LERP_RATIO_ADDED = 0.1
UAnim.ANIMATION_LERP_ITERATIONS = math.floor(1 / UAnim.ANIMATION_LERP_RATIO_ADDED)

local player_animations = UAnim.Players

local function ResetBones(player)
	local player_table = player_animations[player] or {}
	local animationInfo = player_table.animationInfo or {}
	local boneIndexes = player_table.boneIndexes or {}

	for boneName, _ in pairs(animationInfo) do
		local boneIndex = boneIndexes[boneName]
		if not boneIndex then continue end
		player:ManipulateBoneAngles(boneIndex, UAnim.ANIMATION_START_ANGLES)
	end

	player_animations[player] = nil
	player.animationIndex = nil
end

net.Receive("boneAnglesExecute", function()
	local player = net.ReadEntity()
	if not IsValid(player) then return end

	if player_animations[player] then ResetBones(player) end

	local animationIndex = net.ReadUInt(8)
	local animationInfo = UAnim.GetAnimationInfo(animationIndex)
	if not animationInfo then return end

	local boneIndexes = {}
	for boneName, _ in pairs(animationInfo) do
		boneIndexes[boneName] = player:LookupBone(boneName)
	end
	local tbl = {
		animationInfo = animationInfo,
		animationRatio = UAnim.ANIMATION_LERP_RATIO_ADDED,
		boneIndexes = boneIndexes
	}
	player_animations[player] = tbl
	player.animationIndex = animationIndex
end)

hook.Add("Think", "UAnim.Animation", function()
	for player, animationTbl in pairs(player_animations) do
		if not IsValid(player) then
			player_animations[player] = nil
			continue
		end

		local ratio = animationTbl.animationRatio
		if ratio >= 0.95 then continue end
		local animationInfo = animationTbl.animationInfo
		ratio = Lerp(FrameTime() * 4, ratio, 1)
		animationTbl.animationRatio = ratio

		for boneName, _ in pairs(animationInfo) do
			local boneIndex = animationTbl.boneIndexes[boneName]
			if boneIndex then
				player:ManipulateBoneAngles(boneIndex, LerpAngle(ratio, UAnim.ANIMATION_START_ANGLES, animationInfo[boneName]))
			end
		end
	end
end)

net.Receive("boneAnglesReset", function()
	local player = net.ReadEntity()
	if not IsValid(player) then return end
	ResetBones(player)
end)
