addEvent( "hud > create_notification", true );

HUD = { };

HUD.notifications = { };
HUD.notifications_types = {

	{ 133, 186, 76 },
	{ 75, 158, 200 },
	{ 201, 60, 44 },
	{ 214, 185, 69 }

};

HUD.is_visible = false;

function HUD.setup( )

	HUD.setVisible( true );

	addEventHandler( "hud > create_notification", root, HUD.createNotification );
	addEventHandler( "onClientRender", root, HUD.render );

end

function HUD.setVisible( bool )

	HUD.is_visible = bool;

end

function HUD.render( )

	if ( not HUD.is_visible ) then

		return;

	end

	-- HUD;

	local x = screen[ 1 ] - 250;
	local y = screen[ 2 ] - 55;

	local hunger = localPlayer:getData( "character > hunger" ) or 100;
	local thirst = localPlayer:getData( "character > thirst" ) or 100;
	local health = localPlayer:getHealth( );

		-- HUNGER;

	dxDrawRectangle( x, y, 230, 35, tocolor( 200, 200, 200, 50 ), true );
	dxDrawRectangle( x + 45, y + 5, ( hunger / 100 ) * 180, 25, tocolor( 191, 107, 56 ), true );
	dxDrawText( ceil( hunger ), x + 50, y + 10, 0, 0, tocolor( 255, 255, 255 ), 1, "clear", "left", "top", false, false, true );
	dxDrawImage( x + 10, y + 5, 25, 25, "assets/images/hud/hunger.png", 0, 0, 0, tocolor( 255, 255, 255 ), true );

		-- THIRST;

	y = y - 40;

	dxDrawRectangle( x, y, 230, 35, tocolor( 200, 200, 200, 50 ), true );
	dxDrawRectangle( x + 45, y + 5, ( thirst / 100 ) * 180, 25, tocolor( 75, 158, 200 ), true );
	dxDrawText( ceil( thirst ), x + 50, y + 10, 0, 0, tocolor( 255, 255, 255 ), 1, "clear", "left", "top", false, false, true );
	dxDrawImage( x + 10, y + 5, 25, 25, "assets/images/hud/thirst.png", 0, 0, 0, tocolor( 255, 255, 255 ), true );

		-- LIFE;

	y = y - 40;

	dxDrawRectangle( x, y, 230, 35, tocolor( 200, 200, 200, 50 ), true );
	dxDrawRectangle( x + 45, y + 5, ( health / 100 ) * 180, 25, tocolor( 133, 186, 76 ), true );
	dxDrawText( ceil( health ), x + 50, y + 10, 0, 0, tocolor( 255, 255, 255 ), 1, "clear", "left", "top", false, false, true );
	dxDrawImage( x + 10, y + 5, 25, 25, "assets/images/hud/life.png", 0, 0, 0, tocolor( 255, 255, 255 ), true );

	-- NOTIFICATIONS;

	y = y - 5;

	for k, v in ipairs( HUD.notifications ) do

		y = y - v.h;

		dxDrawRectangle( x, y, 230, v.h, tocolor( v.color[ 1 ], v.color[ 2 ], v.color[ 3 ] ) );
		dxDrawText( v.text, x + 5, y + 5, 0, 0, tocolor( 255, 255, 255 ), 1, "clear" );

		if ( getTickCount( ) - v.tick > 15000 ) then

			remove( HUD.notifications, k );

		end

		y = y - 5;

	end

end

function HUD.createNotification( text, type )

	insert( HUD.notifications, {

		h = ( ( countCharacter( text, "\n" ) + 1 ) * dxGetFontHeight( 1, "clear" ) ) + 10,
		text = text,
		color = HUD.notifications_types[ type ],
		tick = getTickCount( )

	} );

end
