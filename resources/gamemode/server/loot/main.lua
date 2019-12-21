addEvent( "loot > take_life", true );
addEvent( "loot > get_loot", true );

Loot = { };

Loot.loots_to_respawn = { };

Loot.cols = {

	trees = { },
	rocks = { }

};

Loot.barrels_type = {

	"Scrap Barrel"

};

function Loot.setup( )

	Loot.generate( );

	setTimer( function( )

		if ( maxn( Loot.loots_to_respawn ) > 0 ) then

			local x = Loot.loots_to_respawn[ 1 ].x;
			local y = Loot.loots_to_respawn[ 1 ].y;
			local z = Loot.loots_to_respawn[ 1 ].z;

			local type = Loot.loots_to_respawn[ 1 ].type;

			local col = Loot.loots_to_respawn[ 1 ].col;

			local element = Object( find( type, "Barrel" ) and CUSTOM_MODELS[ type ].model or type == "Tree" and LOOT_MODELS.TREES[ random( maxn( LOOT_MODELS.TREES ) ) ] or LOOT_MODELS.ROCKS[ random( maxn( LOOT_MODELS.ROCKS ) ) ], x, y, z );
			element:setData( "loot > life", 100 );
			element:setData( "loot > name", type );
			element:setData( "loot > type", "dispenser" );

			Loot.cols[ col ] = element;

			remove( Loot.loots_to_respawn, 1 );

		end

	end, 15 * 60000, 0 );

end

function Loot.generate( )

	-- BARRELS;

	for k, v in pairs( LOOT_POSITIONS.BARRELS ) do

		local type = random( maxn( Loot.barrels_type ) );
		local element = Object( CUSTOM_MODELS[ Loot.barrels_type[ type ] ].model, v.x, v.y, v.z );
		element:setData( "loot > life", 100 );
		element:setData( "loot > name", Loot.barrels_type[ type ] );
		element:setData( "loot > type", "dispenser" );

		local blip = Blip( v.x, v.y, v.z, 8 );
		blip:setVisibleDistance( 180 );

		local col = ColShape.Cuboid( v.x - 0.9, v.y - 0.9, v.z - 0.6, 1.8, 1.8, 1.5 );

		Loot.cols[ col ] = element;

		element:setData( "loot > col", col );

	end

	-- TREES;

	for k, v in pairs( LOOT_POSITIONS.TREES ) do

		local model = LOOT_MODELS.TREES[ random( maxn( LOOT_MODELS.TREES ) ) ];
		local element = Object( model, v.x, v.y, v.z );
		element:setData( "loot > life", 100 );
		element:setData( "loot > name", "Tree" );
		element:setData( "loot > type", "dispenser" );

		local blip = Blip( v.x, v.y, v.z, 46 );
		blip:setVisibleDistance( 180 );

		local col = ColShape.Cuboid( v.x - 0.9, v.y - 0.9, v.z, 1.8, 1.8, 8 );

		Loot.cols[ col ] = element;

		element:setData( "loot > col", col );

	end

	-- ROCKS;

	for k, v in pairs( LOOT_POSITIONS.ROCKS ) do

		local model = LOOT_MODELS.ROCKS[ random( maxn( LOOT_MODELS.ROCKS ) ) ];
		local element = Object( model, v.x, v.y, v.z );
		element:setData( "loot > life", 100 );
		element:setData( "loot > name", "Rock" );
		element:setData( "loot > type", "dispenser" );

		local blip = Blip( v.x, v.y, v.z, 47 );
		blip:setVisibleDistance( 180 );

		local col = ColShape.Sphere( v.x, v.y, v.z, 1.5 );

		Loot.cols[ col ] = element;

		element:setData( "loot > col", col );

	end

	addEventHandler( "loot > take_life", root, Loot.takeLife );
	addEventHandler( "loot > get_loot", root, Loot.getLoot );
	addEventHandler( "onElementColShapeHit", root, Loot.onColHit );
	addEventHandler( "onElementColShapeLeave", root, Loot.onColLeave );

end

function Loot.takeLife( player, element, type, w_fire )

	if ( element:getData( "loot > life" ) - 10 > 0 ) then

		element:setData( "loot > life", element:getData( "loot > life" ) - 10 );

		if ( type == "Rock" ) then

			element:setScale( element:getData( "loot > life" ) / 100 );

		end

		if ( w_fire ) then

			local x = element.position.x;
			local y = element.position.y;
			local z = element.position.z;

			Loot.createLootItem( x, y, z + 1, find( type, "Barrel" ) and 19 or type == "Tree" and 17 or 18, 1 );

		else

			if ( not Inventory.giveItem( player, find( type, "Barrel" ) and 19 or type == "Tree" and 17 or 18, 1 ) ) then

				local x = element.position.x;
				local y = element.position.y;
				local z = element.position.z;

				Loot.createLootItem( x, y, z, find( type, "Barrel" ) and 19 or type == "Tree" and 17 or 18, 1 );

			end

		end

	else

		local x = element.position.x;
		local y = element.position.y;
		local z = element.position.z;
		local col = element:getData( "loot > col" );

		if ( find( element:getData( "loot > name" ), "Barrel" ) ) then

			Loot.createLootItem( x, y, z + 1, 11, 1 );
			Loot.createLootItem( x, y, z + 1, 7, 1 );

		end

		element:removeData( "loot > life" );
		element:removeData( "loot > name" );
		element:removeData( "loot > type" );
		element:removeData( "loot > col" );

		destroyElement( element );

		insert( Loot.loots_to_respawn, { x = x, y = y, z = z, type = type, col = col } );

	end

end

function Loot.getLoot( player, loot )

	local item = loot:getData( "loot > item" );
	local ammount = loot:getData( "loot > ammount" );
	local life = loot:getData( "loot > life" );

	if ( ( not item ) or ( not ammount ) or ( not life ) ) then

		return player:removeData( "waiting_response" );

	end

	if ( Inventory.giveItem( player, item, ammount, life ) ) then

		loot:removeData( "loot > item" );
		loot:removeData( "loot > ammount" );
		loot:removeData( "loot > life" );
		loot:removeData( "loot > type" );

		local model = loot:getData( "loot > model" );

		if ( isElement( model ) ) then

			loot:removeData( "loot > model" );

			destroyElement( model );

		end

		destroyElement( loot );

	end

	player:removeData( "waiting_response" );

end

function Loot.createLootItem( x, y, z, item, ammount )

	local physic = Object( 1598, x, y, z );
	physic:setData( "loot > item", item );
	physic:setData( "loot > ammount", ammount );
	physic:setData( "loot > life", 100 );
	physic:setData( "loot > type", "item" );

	local drop_model = Object( ITEMS[ item ].drop_model or 1279, 0, 0, 0 );

	physic:setData( "loot > model", drop_model );

	drop_model:setCollisionsEnabled( false );
	physic:setAlpha( 0 );

	drop_model:attach( physic, 0, 0, 0, 0, 0, 0 );

	setTimer( function( physic, r )

		physic:setVelocity( 0, 0, 0.1 );
	
	end, 100, 1, physic, r );

end

function Loot.onColHit( col )

	if ( isElement( source ) and source:getType( ) == "player" ) then

		if ( Loot.cols[ col ] and isElement( Loot.cols[ col ] ) ) then

			triggerClientEvent( source, "loot > update_col", source, Loot.cols[ col ] );

		end

	end

end

function Loot.onColLeave( col )

	if ( isElement( source ) and source:getType( ) == "player" ) then

		if ( Loot.cols[ col ] ) then

			triggerClientEvent( source, "loot > update_col", source );

		end

	end

end
