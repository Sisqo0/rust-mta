addEvent( "wasted > respawn", true );

Wasted = { };

function Wasted.setup( )

	addEventHandler( "onPlayerWasted", root, Wasted.onWasted )
	addEventHandler( "wasted > respawn", root, Wasted.respawnPlayer );

end

function Wasted.onWasted( _, killer, weapon )

	triggerClientEvent( source, "wasted > on_wasted", source, isElement( killer ) and ( killer:getType( ) == "player" and killer:getName( ) or "unnamed" ) or "unnamed", weapon and getWeaponNameFromID( weapon ) or "unnamed" );
	Inventory.reset( source );

end

function Wasted.respawnPlayer( player )

	local random_position = random( maxn( SPAWN_POSITIONS ) );

	local x = SPAWN_POSITIONS[ random_position ][ 1 ];
	local y = SPAWN_POSITIONS[ random_position ][ 2 ];
	local z = SPAWN_POSITIONS[ random_position ][ 3 ];

	player:spawn( x, y, z );

	player:setData( "character > hunger", 100 );
	player:setData( "character > thirst", 100 );

	player:removeData( "waiting_response" );

end