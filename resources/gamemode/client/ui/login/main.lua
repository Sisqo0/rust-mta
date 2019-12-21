addEvent( "login > on_log", true );

Login = { };
Login.UI = {

	images 		= { },
	rectangles 	= { },
	buttons 	= { },
	labels 		= { },
	blur		= { }

};

Login.is_visible = false;

function Login.setup( )

	setCameraMatrix( -1033.6938476563, -1140.7166748047, 130.24279785156, -1034.2347412109, -1141.5483398438, 130.11679077148, 0, 70 );

	setPlayerHudComponentVisible( "all", false );
	showChat( false );
	showCursor( true );
	fadeCamera( true );

	local w = 500;
	local h = 420;
	local x = screen[ 1 ] / 2 - w / 2;
	local y = screen[ 2 ] / 2 - h / 2;
	local b = 10;

	Login.UI.images[ 1 ] = Images:create( 0, 0, screen[ 1 ], screen[ 2 ], "assets/images/background.png" );
	Login.UI.images[ 1 ]:setColor( { 255, 255, 255, 240 } );

	Login.UI.rectangles[ 1 ] = Rectangles:create( x, y, w, h, { 29, 33, 27, 220 } );
	Login.UI.rectangles[ 2 ] = Rectangles:create( x + b, y + b * 2 + 200, w - b * 2, 130, { 65, 62, 47, 100 } );

	Login.UI.images[ 2 ] = Images:create( x + b, y + b, w - b * 2, 200, "assets/images/login/banner.png" );
	Login.UI.labels[ 1 ] = Labels:create( x + b, y + b + 170, w - b * 2, 30, "MTA Rust" );
	Login.UI.labels[ 1 ]:setHorizontalAlign( "center" );
	Login.UI.labels[ 1 ]:setVerticalAlign( "center" );

	Login.UI.labels[ 2 ] = Labels:create( x + b * 2, y + b * 3 + 200, w - b * 4, 30, "Short description." );

	Login.UI.buttons[ 1 ] = Buttons:create( x + b, y + b * 3 + 330, 150, 50, "Site URL" );
	Login.UI.buttons[ 1 ]:setColor( 1, { 22, 72, 112, 255 } );
	Login.UI.buttons[ 1 ]:setColor( 4, { 255, 255, 255, 150 } );

	Login.UI.buttons[ 2 ] = Buttons:create( ( x + ( w - b ) ) - 200, y + b * 3 + 330, 200, 50, "Play" );
	Login.UI.buttons[ 2 ]:setColor( 1, { 109, 144, 63, 255 } );
	Login.UI.buttons[ 2 ]:setColor( 2, { 122, 163, 67, 255 } );
	Login.UI.buttons[ 2 ]:setColor( 3, { 131, 179, 68, 255 } );
	Login.UI.buttons[ 2 ]:setColor( 4, { 255, 255, 255, 150 } );

	addEventHandler( "onClientUIClick", root, Login.click );
	addEventHandler( "login > on_log", root, Login.onLog );

	Login.is_visible = true;

	UI.current_panel = "login";

end

function Login.click( )

	if ( source == Login.UI.buttons[ 1 ].source ) then

		setClipboard( "https://www.site.com" );

	elseif ( source == Login.UI.buttons[ 2 ].source ) then

		if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end

		local text = Login.UI.buttons[ 2 ]:getText( );

		if ( text == "Play" ) then

			triggerServerEvent( "accounts > log_player", localPlayer, localPlayer );

		else

			triggerServerEvent( "utils > kick_player", localPlayer, localPlayer );

		end

	end

end

function Login.setVisible( bool )

	Login.is_visible = bool;

	for _, ui_table in ipairs( { Login.UI.images, Login.UI.rectangles, Login.UI.buttons, Login.UI.labels } ) do

		for _, v in ipairs( ui_table ) do

			v:setVisible( bool );

		end

	end

end

function Login.hide( )

	Login.is_visible = false;
	UI.current_panel = Login.is_visible and "login" or false;

	showCursor( Login.is_visible );
	
	Login.setVisible( Login.is_visible );
	UI.setHudVisible( not Login.is_visible );

end

function Login.onLog( )

	Login.setVisible( false );
	showCursor( false );
	setCameraTarget( localPlayer );

	--Building.start( 1853 );

	UI.current_panel = false;

	Login.UI.buttons[ 2 ]:setText( "Disconnect" );
	Login.UI.buttons[ 2 ]:setColor( 1, { 133, 49, 40, 255 } );
	Login.UI.buttons[ 2 ]:setColor( 2, { 171, 56, 43, 255 } );
	Login.UI.buttons[ 2 ]:setColor( 3, { 201, 60, 44, 255 } );

	removeEventHandler( "login > on_log", root, Login.onLog );

	triggerServerEvent( "utils > remove_data", localPlayer, localPlayer, "waiting_response" );

	UI.setup( );

	bindKey( "F1", "down",
		function( )
			
			if ( ( not UI.current_panel ) or UI.current_panel == "login" ) then

				Login.is_visible = not Login.is_visible;

				UI.current_panel = Login.is_visible and "login" or false;

				setPlayerHudComponentVisible( "radar", not Login.is_visible );

				showCursor( Login.is_visible );
				showChat( not Login.is_visible );

				Login.setVisible( Login.is_visible );
				UI.setHudVisible( not Login.is_visible );

			end

		end
	);

end