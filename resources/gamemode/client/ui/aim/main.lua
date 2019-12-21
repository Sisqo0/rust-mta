Aim = { };

Aim.visible = true;
Aim.target = false;

function Aim.setup( )

	addEventHandler( "onClientRender", root, Aim.render );
	bindKey( "e", "down", Aim.interact );

end

function Aim.setVisible( bool )

	Aim.visible = bool;

end

function Aim.render( )

	Aim.target = false;

	local cam = { getCameraMatrix( ) };

	if ( localPlayer:getControlState( "aim_weapon" ) and localPlayer:getWeapon( ) ~= 0 ) then

		-- AIM;

		if ( Aim.visible ) then

			local aim_p = Vector3( localPlayer:getTargetEnd( ) );

			local x, y = getScreenFromWorldPosition( aim_p.x, aim_p.y, aim_p.z );

			if ( x and y ) then

				dxDrawImage( floor( x - 2.5 ), floor( y - 2.5 ), 5, 5, "assets/images/circle.png" );

			end

		end

	end

	-- RAYCAST;

	local world_screen = { getWorldFromScreenPosition( screen[ 1 ] / 2, screen[ 2 ] / 2, 10 ) };
	local process = { processLineOfSight( cam[ 1 ], cam[ 2 ], cam[ 3 ], world_screen[ 1 ], world_screen[ 2 ], world_screen[ 3 ], _, _, false ) };

	if ( isElement( process[ 5 ] ) ) then

		if ( process[ 5 ]:getData( "loot > type" ) == "item" ) then

			local item = process[ 5 ]:getData( "loot > item" );
			local ammount = process[ 5 ]:getData( "loot > ammount" );

			dxDrawText( ITEMS[ item ].name .. " x" .. ammount, 0, screen[ 2 ] / 2 - 15, screen[ 1 ], screen[ 2 ] / 2 - 15, tocolor( 255, 255, 255 ), 1, "clear", "center", "center" );

			dxDrawImage( floor( screen[ 1 ] / 2 ), floor( screen[ 2 ] / 2 ) + 1, 5, 5, "assets/images/circle.png" );

			Aim.target = { process[ 5 ], "item" };

		elseif ( process[ 5 ]:getData( "loot > type" ) == "dispenser" ) then

			local life = process[ 5 ]:getData( "loot > life" ) or 100;
			local name = process[ 5 ]:getData( "loot > name" ) or "unnamed";

			dxDrawText( name, screen[ 1 ] / 2 - 100, 80, 0, 0, tocolor( 255, 255, 255 ), 1, "clear" );
			dxDrawRectangle( screen[ 1 ] / 2 - 100, 100, 200, 5, tocolor( 255, 255, 255, 100 ) );
			dxDrawRectangle( screen[ 1 ] / 2 - 100, 100, (life / 100) * 200, 5, tocolor( 255, 255, 255 ) );

			Aim.target = { process[ 5 ], "dispenser" };

		elseif ( process[ 5 ]:getData( "building > life" ) ) then

			local owner = process[ 5 ]:getData( "building > owner" );

			if ( ( ( owner ~= localPlayer:getData( "character > serial" ) ) and ( localPlayer:getControlState( "aim_weapon" ) and localPlayer:getWeapon( ) ~= 0 ) ) or ( ( owner == localPlayer:getData( "character > serial" ) ) and ( ( localPlayer:getControlState( "aim_weapon" ) and localPlayer:getWeapon( ) ~= 0 ) or localPlayer:getData( "building > hammer" ) ) ) ) then

				local life = process[ 5 ]:getData( "building > life" ) or 100;
				local name = process[ 5 ]:getData( "building > name" ) or "unnamed";

				dxDrawText( name, screen[ 1 ] / 2 - 100, 80, 0, 0, tocolor( 255, 255, 255 ), 1, "clear" );
				dxDrawRectangle( screen[ 1 ] / 2 - 100, 100, 200, 5, tocolor( 255, 255, 255, 100 ) );
				dxDrawRectangle( screen[ 1 ] / 2 - 100, 100, (life / 100) * 200, 5, tocolor( 255, 255, 255 ) );

				Aim.target = { process[ 5 ], "building" };

			end

		end

	end

end

function Aim.interact( )

	if ( Aim.target ) then

		if ( isElement( Aim.target[ 1 ] ) and Aim.target[ 2 ] == "item" ) then

			if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
			triggerServerEvent( "loot > get_loot", localPlayer, localPlayer, Aim.target[ 1 ] );

		end

	end

end