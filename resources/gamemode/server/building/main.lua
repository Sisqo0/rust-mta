addEvent( "building > create", true );
addEvent( "building > add_part", true );
addEvent( "building > remove_part", true );

Building = { };

Building.builds = { };
Building.elements = { };

function Building.setup( )

	--exec( "CREATE TABLE IF NOT EXISTS builds ( build TEXT, serial TEXT )" );

	addEventHandler( "building > create", root, Building.create );

end

addEvent("destroyele",true)
addEventHandler("destroyele",root,function(ele)Building.takeLife(ele)end);

function Building.create( player, name, model, x, y, z, r )

	local group = concat( { x, y, z }, ";" );

	if ( Building.builds[ group ] ) then

		return;

	end

	Building.builds[ group ] = {

		x 		= x,
		y 		= y,
		z 		= z,
		r 		= r,
		owner 	= player.serial,
		life 	= 100,
		type 	= "wood",
		name 	= name

	};

	local element = createObject( model, x, y, z );
	element:setRotation( 0, 0, r );
	element:setData( "building > owner", player.serial );
	element:setData( "building > life", 100 );
	element:setData( "building > type", "wood" );
	element:setData( "building > name", name );

	Building.elements[ element ] = group;

end

function Building.destroy( element )

	if ( not Building.elements[ element ] ) then

		return;

	end

	local group = Building.elements[ element ];

	if ( not Building.builds[ group ] ) then

		return;

	end

	Building.builds[ group ] = nil;
	Building.elements[ element ] = nil;

	element:removeData( "building > owner" );
	element:removeData( "building > life" );
	element:removeData( "building > type" );
	element:removeData( "building > name" );

	destroyElement( element );

end

function Building.takeLife( element )

	if ( not Building.elements[ element ] ) then

		return;

	end

	local group = Building.elements[ element ];

	if ( not Building.builds[ group ] ) then

		return;

	end

	if ( Building.builds[ group ].life - 5 > 0 ) then

		Building.builds[ group ].life = Building.builds[ group ].life - 5;
		element:setData( "building > life", Building.builds[ group ].life );

	else

		Building.destroy( element );

	end

end