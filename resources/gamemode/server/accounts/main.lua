addEvent( "accounts > log_player", true );

Accounts = { };

function Accounts.setup( )

	exec( "CREATE TABLE IF NOT EXISTS accounts ( serial TEXT, clothes TEXT, position TEXT, rotation INT, life INT, hunger INT, thirst INT )" );

	addEventHandler( "accounts > log_player", root, Accounts.logPlayer );

end

function Accounts.logPlayer( player )

	if ( not isElement( player ) ) then

		return;

	end

	if ( player:getData( "character > logged" ) ) then

		return;

	end

	local query = query( "SELECT * FROM accounts WHERE serial = ?", player.serial );
	if ( maxn( query ) ~= 0 ) then
		
		query = query[ 1 ];
		Accounts.load( player, query );

	else

		Accounts.create( player );

	end

end

function Accounts.create( player )

	local random_position = random( maxn( SPAWN_POSITIONS ) );

	exec( "INSERT INTO accounts ( serial, clothes, position, rotation, life, hunger, thirst ) VALUES ( ?, ?, ?, ?, ?, ?, ? )",

		player.serial,
		toJSON( { { "player_torso", "torso", 0 }, { "player_face", "head", 0 }, { "player_legs", "legs", 0 }, { "foot", "feet", 0 } } ),
		toJSON( SPAWN_POSITIONS[ random_position ] ),
		0,
		100,
		100,
		100

	);

	Accounts.load( player, {["serial"]=player.serial,["clothes"]=toJSON({{"player_torso","torso",0},{"player_face","head",1},{"player_legs","legs",2},{"foot","feet",3}}),["position"]=toJSON(SPAWN_POSITIONS[random_position]),["rotation"]=0,["life"]=100,["hunger"]=100,["thirst"]=100} );

end

function Accounts.load( player, query )

	local pos = fromJSON( query[ "position" ] );

	local x = pos[ 1 ];
	local y = pos[ 2 ];
	local z = pos[ 3 ];

	local r = query[ "rotation" ];

	player:spawn( x, y, z, r );

	player:setData( "character > hunger", query[ "hunger" ] );
	player:setData( "character > thirst", query[ "thirst" ] );
	player:setData( "character > logged", true );
	player:setData( "character > serial", player:getSerial( ) );

	player:setHealth( query[ "life" ] );

	triggerClientEvent( player, "login > on_log", player );

	for _, v in ipairs( fromJSON( query[ "clothes" ] ) ) do

		player:addClothes( unpack( v ) );

	end

end

function Accounts.respawn( player )

	local random_position = random( maxn( SPAWN_POSITIONS ) );

	local x = SPAWN_POSITIONS[ random_position ][ 1 ];
	local y = SPAWN_POSITIONS[ random_position ][ 2 ];
	local z = SPAWN_POSITIONS[ random_position ][ 3 ];

	player:spawn( x, y, z );

	player:setData( "character > hunger", 100 );
	player:setData( "character > thirst", 100 );

end

function Accounts.save( player )

	local clothes = { };

	for i=0, 3 do

		local clothe = { player:getClothes( i ) };
		insert( clothes, { clothe[ 1 ], clothe[ 2 ], i } );

	end

	exec( "UPDATE accounts SET clothes = ?, position = ?, rotation = ?, life = ?, hunger = ?, thirst = ? WHERE serial = ?",

		toJSON( clothes ),
		toJSON( { player.position.x, player.position.y, player.position.z } ),
		player.rotation.z,
		player.health,
		player:getData( "character > hunger" ) or 0,
		player:getData( "character > thirst" ) or 0,
		player.serial

	);

	Inventory.save( player );

end

function Accounts.logout( player )

	if ( not player:getData( "character > logged" ) ) then

		return;

	end

	Accounts.save( player );

	player:removeData( "character > logged" );
	player:removeData( "character > hunger" );
	player:removeData( "character > thirst" );
	player:removeData( "character > weapon" );
	player:removeData( "character > building" );
	player:removeData( "character > tool" );

	for k, v in pairs( Inventory.players[ player ].preview_objects ) do

		if ( isElement( v ) ) then

			exports[ "bone_attach" ]:detachElementFromBone( v );
			destroyElement( v );

		end

	end

end
