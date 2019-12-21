addEvent( "building > toggle", true );

Building = { };

Building.block_create = false;

Building.atual_model = 0;

Building.UI = {

	actions 	= { }

};

Building.areaHeight = 40;
Building.areas = {

	{ x = -157.19267, y = 135.95172, z = 3.76650, r = 20, owner = nil },

};

Building.action_parts = { "Foundation", "Floor", "Wall", "WallDoor", "WallWindow", "Stair", "Door" };

function Building.setup( )

	Building.atual_model = CUSTOM_MODELS[ "Foundation" ].model;

	Building.preview_shader = dxCreateShader( "assets/shaders/color.fx" );
	dxSetShaderValue( Building.preview_shader, "gColor", { 129 / 255, 222 / 255, 29 / 255, 1 } );

	Building.UI.actions[ 1 ] = ActionMenu:create( screen[ 1 ] / 2, screen[ 2 ] / 2, 500, 500 );
	Building.UI.actions[ 1 ]:setVisible( false );

	-- PARTS;

	Building.UI.actions[ 1 ]:addAction( {

		name = "Foundation"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Floor"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Wall"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Wall\nDoor"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Wall\nWindow"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Stair"

	} );

	Building.UI.actions[ 1 ]:addAction( {

		name = "Door"

	} );

	addEventHandler( "building > toggle", root, Building.toggle );
	addEventHandler( "onClientUIClick", Building.UI.actions[ 1 ].source, Building.actionClick );

	addEventHandler( "onClientPlayerWeaponFire", root,
		function( _, _, _, _, _, _, hit )

			if ( isElement( hit ) ) then

				triggerServerEvent( "destroyele", localPlayer, hit );

			end

		end
	);

	--addEventHandler( "onClientRender", root, areaCollision );

end

function Building.toggle( bool )

	if ( bool ) then

		Building.preview_element = createObject( Building.atual_model, 0, 0, -10 );

		setElementCollisionsEnabled( Building.preview_element, false );
		engineApplyShaderToWorldTexture( Building.preview_shader, "*", Building.preview_element );

		addEventHandler( "onClientPreRender", root, Building.updatePreview );

		bindKey( "mouse1", "down", Building.create );
		bindKey( "mouse2", "both", Building.action );

	else

		destroyElement( Building.preview_element );

		removeEventHandler( "onClientPreRender", root, Building.updatePreview );

		unbindKey( "mouse1", "down", Building.create );
		unbindKey( "mouse2", "both", Building.action );

	end

end

function Building.action( k, s )

	if ( ( not UI.current_panel ) or UI.current_panel == "building_action" ) then

		if ( s == "down" ) then

			Building.UI.actions[ 1 ]:setVisible( true );
			showCursor( true );
			UI.current_panel = "building_action";

		elseif ( s == "up" ) then

			Building.UI.actions[ 1 ]:setVisible( false );
			showCursor( false );
			UI.current_panel = false;

		end

	end

end

function Building.actionClick( part )

	Building.atual_model = CUSTOM_MODELS[ Building.action_parts[ part ] ].model;

	if ( isElement( Building.preview_element ) ) then

		Building.preview_element:setModel( Building.atual_model );

	end

	Building.UI.actions[ 1 ]:setVisible( false );
	showCursor( false );
	UI.current_panel = false;

end

function areaCollision( )

	for k, v in pairs( Building.areas ) do

		for i=0, 360 do

			local x = v.x;
			local y = v.y;
			local z = v.z;

			x = x + math.cos( math.rad( i ) ) * v.r;
			y = y + math.sin( math.rad( i ) ) * v.r;

			dxDrawLine3D( x, y, z, x, y, z + Building.areaHeight, tocolor( 0, 255, 0 ), 2 );

		end

	end

	for i=0, 360 do

		local x = localPlayer.position.x;
		local y = localPlayer.position.y;
		local z = localPlayer.position.z;

		x = x + math.cos( math.rad( i ) ) * 20;
		y = y + math.sin( math.rad( i ) ) * 20;

		dxDrawLine3D( x, y, z, x, y, z + Building.areaHeight, Building.isColliding( { x = localPlayer.position.x, y = localPlayer.position.y, z = localPlayer.position.z, r = 20 } ) and tocolor( 255, 255, 0 ) or tocolor( 0, 255, 255 ), 2 );

	end

end

function Building.isColliding( area )

	for _, v in pairs( Building.areas ) do

		if ( isCollidingWithBuildArea( v, area ) ) then

			return true;

		end

	end

	return false;

end

function Building.updatePreview( )

	Building.block_create = false;
	Building.raycast = nil;

	if ( not isElement( Building.preview_element ) ) then

		return;
	
	end

	Building.preview_element.position = Vector3( 0, 0, -10 );

	local cam = { getCameraMatrix( ) };
	local world_screen = { getWorldFromScreenPosition( screen[ 1 ] / 2, screen[ 2 ] / 2, 10 ) };
	local process = { processLineOfSight( cam[ 1 ], cam[ 2 ], cam[ 3 ], world_screen[ 1 ], world_screen[ 2 ], world_screen[ 3 ], true, false, false, true, false ) };
	
	if ( process[ 1 ] ) then

		local x = process[ 2 ];
		local y = process[ 3 ];
		local z = process[ 4 ] + .15;
		local r = -math.deg( math.atan2( x - localPlayer.position.x, y - localPlayer.position.y ) ) + ( Building.isWall( Building.preview_element.model ) and 90 or 0 );

		if ( isElement( process[ 5 ] ) ) then

			if ( BUILDING_RULES[ Building.preview_element.model ] ) then

				if ( BUILDING_RULES[ Building.preview_element.model ][ process[ 5 ].model ] ) then

					x, y, z, r = Building.getPosition( process[ 5 ], BUILDING_RULES[ Building.preview_element.model ][ process[ 5 ].model ], { x, y, z } );
					z = z + ( ( process[ 5 ].model == CUSTOM_MODELS[ "Floor" ].model and Building.preview_element.model ~= CUSTOM_MODELS[ "Floor" ].model ) and ( BUILDING_SIZES[ process[ 5 ].model ].z / 2 ) or 0 );
					r = process[ 5 ].rotation.z + r;

					Building.raycast = process[ 5 ];
				
				end
			
			end

		else

			if ( Building.preview_element.model ~= CUSTOM_MODELS[ "Foundation" ].model ) then

				Building.block_create = true;

			end

		end

		Building.preview_element.position = Vector3( x, y, z );
		Building.preview_element.rotation = Vector3( 0, 0, r );
	
	end

	if ( Building.block_create ) then

		Building.preview_shader:setValue( "gColor", { 1, 0, 0, 1 } );

	else

		Building.preview_shader:setValue( "gColor", { 0, 1, 0, 1 } );

	end

end

function Building.getPosition( hit_element, type, target_pos )

	local x = hit_element.position.x;
	local y = hit_element.position.y;
	local z = hit_element.position.z;

	if ( type == "bottom_side" ) then

		local sides = { };
		local minSide = 1;
		local minDistance = 999;

		sides[ 1 ] = { x + ( math.cos( math.rad( hit_element.rotation.z ) ) * Building.getRadius( hit_element.model, "top" ) ), y + ( math.sin( math.rad( hit_element.rotation.z ) ) * Building.getRadius( hit_element.model, "top" ) ), z, 0 };
		sides[ 2 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 90 ) ) * Building.getRadius( hit_element.model, "top" ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 90 ) ) * Building.getRadius( hit_element.model, "top" ) ), z, 0 };
		sides[ 3 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 180 ) ) * Building.getRadius( hit_element.model, "top" ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 180 ) ) * Building.getRadius( hit_element.model, "top" ) ), z, 0 };
		sides[ 4 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 270 ) ) * Building.getRadius( hit_element.model, "top" ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 270 ) ) * Building.getRadius( hit_element.model, "top" ) ), z, 0 };

		for k, v in ipairs( sides ) do

			local d = getDistanceBetweenPoints2D( v[ 1 ], v[ 2 ], target_pos[ 1 ], target_pos[ 2 ] );
			if ( d < minDistance ) then

				minSide = k;
				minDistance = d;

			end

		end

		return unpack( sides[ minSide ] );

	elseif ( type == "side" ) then

		local sides = { };
		local minSide = 1;
		local minDistance = 999;

		sides[ 1 ] = { x + ( math.cos( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 180 };
		sides[ 2 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 90 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 90 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 270 };
		sides[ 3 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 0 };
		sides[ 4 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 270 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 270 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 90 };
	
		for k, v in ipairs( sides ) do

			local d = getDistanceBetweenPoints2D( v[ 1 ], v[ 2 ], target_pos[ 1 ], target_pos[ 2 ] );
			if ( d < minDistance ) then

				minSide = k;
				minDistance = d;

			end

		end

		return unpack( sides[ minSide ] );

	elseif ( type == "two_side" ) then

		local sides = { };
		local minSide = 1;
		local minDistance = 999;

		sides[ 1 ] = { x + ( math.cos( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( Building.preview_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( Building.preview_element.model, "top" ) / 2 ) ), z + BUILDING_SIZES[ hit_element.model ].z - BUILDING_SIZES[ Building.preview_element.model ].z / 2, 0 };
		sides[ 2 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( Building.preview_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( Building.preview_element.model, "top" ) / 2 ) ), z + BUILDING_SIZES[ hit_element.model ].z - BUILDING_SIZES[ Building.preview_element.model ].z / 2, 0 };

		for k, v in ipairs( sides ) do

			local d = getDistanceBetweenPoints2D( v[ 1 ], v[ 2 ], target_pos[ 1 ], target_pos[ 2 ] );
			if ( d < minDistance ) then

				minSide = k;
				minDistance = d;

			end

		end

		return unpack( sides[ minSide ] );

	elseif ( type == "top_center" ) then

		local angles = { };
		local minAngle = 1;
		local minDistance = 999;

		angles[ 1 ] = { x + ( math.cos( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 90 };
		angles[ 2 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 90 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 90 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 180 };
		angles[ 3 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 180 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 270 };
		angles[ 4 ] = { x + ( math.cos( math.rad( hit_element.rotation.z + 270 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), y + ( math.sin( math.rad( hit_element.rotation.z + 270 ) ) * ( Building.getRadius( hit_element.model, "top" ) / 2 ) ), z, 0 };
	
		for k, v in ipairs( angles ) do

			local d = getDistanceBetweenPoints2D( v[ 1 ], v[ 2 ], target_pos[ 1 ], target_pos[ 2 ] );
			if ( d < minDistance ) then

				minAngle = k;
				minDistance = d;

			end

		end

		return x, y, z + BUILDING_SIZES[ Building.preview_element.model ].z, angles[ minAngle ][ 4 ];

	elseif ( type == "top" ) then

		return x, y, z + BUILDING_SIZES[ hit_element.model ].z, 0;

	end

end

function Building.isWall( model )

	for name, v in pairs( CUSTOM_MODELS ) do

		if ( string.find( name, "Wall" ) and v.model == model ) then

			return true;
		
		end
	
	end

	return false;

end

function Building.getRadius( model, rType )

	if ( rType == "top" ) then

		return math.sqrt( BUILDING_SIZES[ model ].x * BUILDING_SIZES[ model ].y );

	elseif ( rType == "height" ) then

		return math.sqrt( BUILDING_SIZES[ model ].x * BUILDING_SIZES[ model ].z );

	end

end

function Building.create( )

	if ( not UI.current_panel ) then

		if ( Building.block_create ) then return; end

		local x, y, z = Building.preview_element.position.x, Building.preview_element.position.y, Building.preview_element.position.z;
		local r = Building.preview_element.rotation.z;

		local name = "unnamed";

		for k, v in pairs( CUSTOM_MODELS ) do

			if ( v.model == Building.preview_element:getModel( ) ) then

				name = k;

			end

		end

		triggerServerEvent( "building > create", localPlayer, localPlayer, name, Building.preview_element:getModel( ), x, y, z, r );


	end

end
