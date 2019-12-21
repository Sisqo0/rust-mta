addEvent( "wasted > on_wasted", true );

Wasted = { };

Wasted.UI = {

	buttons = { },
	labels 	= { },
	images 	= { }

};

Wasted.killer = {
	
	name 	= "unnamed",
	weapon 	= "unnamed"

};

function Wasted.setup( )

	Wasted.UI.background = Images:create( 0, 0, screen[ 1 ], screen[ 2 ], "assets/images/background.png" );
	Wasted.UI.background:setColor( { 255, 255, 255, 240 } );

	Wasted.UI.buttons[ 1 ] = Buttons:create( screen[ 1 ] - 220, screen[ 2 ] - 70, 200, 50, "Respawn" );
	Wasted.UI.buttons[ 1 ]:setColor( 1, { 109, 144, 63, 255 } );
	Wasted.UI.buttons[ 1 ]:setColor( 2, { 122, 163, 67, 255 } );
	Wasted.UI.buttons[ 1 ]:setColor( 3, { 131, 179, 68, 255 } );
	Wasted.UI.buttons[ 1 ]:setColor( 4, { 255, 255, 255, 150 } );

	addEventHandler( "onClientUIClick", Wasted.UI.buttons[ 1 ].source,
		function( )
			
			if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
			Wasted.setVisible( false );
			triggerServerEvent( "wasted > respawn", localPlayer, localPlayer );

		end
	);

	Wasted.UI.labels[ 1 ] = Labels:create( 60, 60, 0, 0, "You were killed by" );

	Wasted.UI.images[ 1 ] = Images:create( 190, 70, 135, 20, "assets/images/rec.png" );
	Wasted.UI.images[ 1 ]:setColor( { 131, 179, 68, 255 } );
	Wasted.UI.images[ 1 ]:setRotation( { -5, 0, 0 } );

	Wasted.UI.labels[ 2 ] = Labels:create( 190, 93, 135, 20, sub( Wasted.killer.name, 1, 10 ):lower( ) .. ( #Wasted.killer.name > 10 and "..." or "" ) );
	Wasted.UI.labels[ 2 ]:setRotation( { -5, 0, 0 } );

	Wasted.UI.labels[ 3 ] = Labels:create( 340, 95, 0, 0, "using" );

	Wasted.UI.images[ 2 ] = Images:create( 390, 115, 135, 20, "assets/images/rec.png" );
	Wasted.UI.images[ 2 ]:setColor( { 22, 72, 112, 255 } );
	Wasted.UI.images[ 2 ]:setRotation( { -5, 0, 0 } );

	Wasted.UI.labels[ 4 ] = Labels:create( 390, 158, 135, 20, Wasted.killer.weapon:upper( ) );
	Wasted.UI.labels[ 4 ]:setRotation( { -5, 0, 0 } );

	Wasted.setVisible( false );

	addEventHandler( "wasted > on_wasted", root, Wasted.onWasted );

end

function Wasted.onWasted( killer, weapon )

	Wasted.killer.name = killer;
	Wasted.killer.weapon = weapon;

	Wasted.UI.labels[ 2 ]:setText( sub( Wasted.killer.name, 1, 10 ):lower( ) .. ( #Wasted.killer.name > 10 and "..." or "" ) );
	Wasted.UI.labels[ 4 ]:setText( Wasted.killer.weapon:upper( ) );

	Wasted.setVisible( true );

end

function Wasted.setVisible( bool )

	Inventory.hide( );
	Login.hide( );
	HUD.setVisible( not bool );

	setPlayerHudComponentVisible( "radar", not bool );

	showChat( not bool );
	showCursor( bool );

	UI.current_panel = bool and "wasted" or false;

	Wasted.UI.background:setVisible( bool );

	for _, ui_table in ipairs( { Wasted.UI.buttons, Wasted.UI.images, Wasted.UI.labels } ) do

		for _, element in ipairs( ui_table ) do

			if ( not isElement( element.source ) ) then

				for _, v in ipairs( element ) do

					v:setVisible( bool );

				end

			else

				element:setVisible( bool );

			end

		end

	end

end