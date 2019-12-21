addEventHandler( "onPlayerQuit", root,
	function( )

		Accounts.logout( source );
		source:removeData( "waiting_response" );
		unbindKey( source, "r", "down", Inventory.reloadWeapon );

	end
);