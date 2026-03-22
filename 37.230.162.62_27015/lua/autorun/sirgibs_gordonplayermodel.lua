local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
    player_manager.AddValidHands( "Gordon_Survivor", "models/weapons/c_arms_gor.mdl", 0, "00000000" )
	
end

AddPlayerModel( "Gordon_Survivor", "models/sirgibs/ragdolls/gordon_survivor_player.mdl" )
