screen = { guiGetScreenSize( ) };

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )

		toggleControl( "next_weapon", false );
		toggleControl( "previous_weapon", false );

		setAmbientSoundEnabled( "general", false );
		setAmbientSoundEnabled( "gunfire", false );
		
		Loot.setup( );

		Models.replace( );
		Building.setup( );
		Weapons.setup( );

		Framework.setup( );

		Login.setup( );

		--UI.setup( );

		setTimer( function( )

			if ( localPlayer:getData( "character > logged" ) ) then

				local hunger = localPlayer:getData( "character > hunger" );
				local thirst = localPlayer:getData( "character > thirst" );

				if ( hunger ) then

					local loss = random( 10 ) / 10;

					if ( hunger - loss >= 0 ) then

						localPlayer:setData( "character > hunger", hunger - loss );

					else

						if ( hunger > 0 ) then

							localPlayer:setData( "character > hunger", 0 );

						end

						triggerServerEvent( "utils > set_health", localPlayer, localPlayer, localPlayer:getHealth( ) - 0.3 );

					end

				end

				if ( thirst ) then

					local loss = random( 10 ) / 10;

					if ( thirst - loss >= 0 ) then

						localPlayer:setData( "character > thirst", thirst - loss );

					else

						if ( thirst > 0 ) then

							localPlayer:setData( "character > thirst", 0 );

						end

						triggerServerEvent( "utils > set_health", localPlayer, localPlayer, localPlayer:getHealth( ) - 0.3 );

					end

				end

			end

		end, 15 * 1000, 0 );

	end
);

_getCursorPosition = getCursorPosition;
function getCursorPosition( )

	local cursor = { -screen[ 1 ], -screen[ 2 ] };

	if ( isCursorShowing( ) ) then

		cursor = { _getCursorPosition( ) };
		cursor[ 1 ] = cursor[ 1 ] * screen[ 1 ];
		cursor[ 2 ] = cursor[ 2 ] * screen[ 2 ];

	end

	return cursor[ 1 ], cursor[ 2 ];

end