addEvent( "loot > update_col", true );

Loot = { };
Loot.cooldown = getTickCount( );

function Loot.setup( )

	addEventHandler( "onClientPlayerWeaponFire", root,
		function( _, _, _, _, _, _, hit )

			if ( isElement( hit ) ) then

				if ( hit:getData( "loot > type" ) == "dispenser" ) then

					triggerServerEvent( "loot > take_life", localPlayer, localPlayer, hit, hit:getData( "loot > name" ), true );

				end

			end

		end
	);

	addEventHandler( "loot > update_col", root, Loot.updateCol );

end

function Loot.click( k, s )

	if ( getTickCount( ) - Loot.cooldown >= 3000 and isElement( Loot.colliding ) ) then

		Loot.cooldown = getTickCount( );

		if ( s == "up" ) then

			if ( k == "mouse1" ) then

				local type = Loot.colliding:getData( "loot > type" );

				if ( type == "dispenser" ) then

					local d_type = Loot.colliding:getData( "loot > name" );
					local d_life = Loot.colliding:getData( "loot > life" );
					
					if ( d_life > 0 ) then

						triggerServerEvent( "loot > take_life", localPlayer, localPlayer, Loot.colliding, d_type );

					end

				end

			elseif ( k == "mouse2" ) then

			end

		end

	end

end

function Loot.updateCol( col )

	Loot.colliding = col;

	if ( isElement( col ) ) then

		if ( not isEventHandlerAdded( "onClientKey", root, Loot.click ) ) then

			bindKey( "mouse1", "up", Loot.click );
			bindKey( "mouse2", "up", Loot.click );

		end

	else

		if ( isEventHandlerAdded( "onClientKey", root, Loot.click ) ) then

			unbindKey( "mouse1", "up", Loot.click );
			unbindKey( "mouse2", "up", Loot.click );

		end

	end

end