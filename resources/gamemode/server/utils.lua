addEvent( "utils > remove_data", true );
addEventHandler( "utils > remove_data", root,
	function( element, ... )

		element:removeData( ... );

	end
);

addEvent( "utils > set_health", true );
addEventHandler( "utils > set_health", root,
	function( element, ... )

		element:setHealth( ... );

	end
);

addEvent( "utils > kick_player", true );
addEventHandler( "utils > kick_player", root,
	function( player, ... )

		player:kick( ... );

	end
);

function createNotification( player, text, type )

	triggerClientEvent( player, "hud > create_notification", player, text, type );

end