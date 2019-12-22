addEventHandler( "onResourceStop", resourceRoot,
	function( )

		for _, v in ipairs( getElementsByType( "player" ) ) do

			Accounts.logout( v );
			v:removeData( "waiting_response" );
			unbindKey( v, "r", "down", Inventory.reloadWeapon );

		end

	end
);
