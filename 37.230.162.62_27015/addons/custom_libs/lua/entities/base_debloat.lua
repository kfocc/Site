AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

function ENT:SetPlayer( ply )
	self.Founder = ply

	if ( IsValid( ply ) ) then
		self.FounderSID = ply:SteamID64()
		self.FounderIndex = ply:UniqueID()
	else
		self.FounderSID = nil
		self.FounderIndex = nil
	end
end

function ENT:GetPlayer()

	if ( self.Founder == nil ) then

		-- SetPlayer has not been called
		return NULL

	elseif ( IsValid( self.Founder ) ) then

		-- Normal operations
		return self.Founder

	end

	-- See if the player has left the server then rejoined
	local ply = player.GetBySteamID64( self.FounderSID )
	if ( !IsValid( ply ) ) then

		-- Oh well
		return NULL

	end

	-- Save us the check next time
	self:SetPlayer( ply )
	return ply

end