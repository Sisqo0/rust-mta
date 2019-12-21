Buttons = { };
Buttons.__index = Buttons;

setmetatable( Buttons, Usefull );

function Buttons:create( x, y, w, h, text )

	local self = setmetatable( {

		x 			= x,
		y 			= y,
		w 			= w,
		h 			= h,
		text 		= text,
		colors 		= { { 200, 200, 200, 50 }, { 28, 142, 255, 150 }, { 20, 138, 255, 200 }, { 255, 255, 255, 255 } },
		old_color 	= { 200, 200, 200, 50 },
		atual_color = { 200, 200, 200, 50 },
		next_color 	= { 200, 200, 200, 50 },
		state 		= "out",
		ms 			= getTickCount( ),
		visible 	= true,
		clickable 	= true,
		font 		= "clear",
		source 		= createElement( "ui" )

	}, Buttons );

	self.source:setData( "mouse_on", false, false );

	insert( Framework.elements, self );

	return self;

end

function Buttons:setFont( font )

	self.font = font;

end

function Buttons:setColor( i, color )

	self.colors[ i ] = color;

	if ( i == 1 ) then

		if ( self.state == "out" ) then

			self.next_color = color;

		end

	elseif ( i == 2 ) then

		if ( self.state == "in" ) then

			self.next_color = color;

		end

	elseif ( i == 3 ) then

		if ( self.state == "clicked" ) then

			self.next_color = color;

		end

	end

end

function Buttons:getColor( i )

	return self.colors[ i ];

end

function Buttons:tick( )

	if ( self.visible ) then

		if ( self.clickable ) then

			local colliding = Framework.rectangleWithPointCollision( self.x, self.y, self.w, self.h, getCursorPosition( ) );

			if ( ( not colliding ) and ( not getKeyState( "mouse1" ) ) and self.state ~= "out" ) then

				self.state = "out";
				self.ms = getTickCount( );
				self.old_color = self.atual_color;
				self.next_color = self.colors[ 1 ];

			end

			if ( colliding and self.state ~= "in" and ( not getKeyState( "mouse1" ) ) ) then

				self.state = "in";
				self.ms = getTickCount( );
				self.old_color = self.atual_color;
				self.next_color = self.colors[ 2 ];

			end

			if ( colliding and getKeyState( "mouse1" ) and self.state == "in" ) then

				self.state = "clicked";
				self.ms = getTickCount( );
				self.old_color = self.atual_color;
				self.next_color = self.colors[ 3 ];

			end

			local r, g, b = interpolateBetween( self.old_color[ 1 ], self.old_color[ 2 ], self.old_color[ 3 ], self.next_color[ 1 ], self.next_color[ 2 ], self.next_color[ 3 ], ( getTickCount( ) - self.ms ) / 100, "OutQuad" );
			local a = interpolateBetween( self.old_color[ 4 ], 0, 0, self.next_color[ 4 ], 0, 0, ( getTickCount( ) - self.ms ) / 100, "OutQuad" );

			self.atual_color = { r, g, b, a };

		end

	end

end

function Buttons:render( )

	if ( self.visible ) then

		dxDrawRectangle( self.x, self.y, self.w, self.h, tocolor( self.atual_color[ 1 ] or 255, self.atual_color[ 2 ] or 255, self.atual_color[ 3 ] or 255, self.atual_color[ 4 ] or 255 ) );
		dxDrawText( self.text, self.x, self.y, self.x + self.w, self.y + self.h, tocolor( self.colors[ 4 ][ 1 ] or 255, self.colors[ 4 ][ 2 ] or 255, self.colors[ 4 ][ 3 ] or 255, self.colors[ 4 ][ 4 ] or 255 ), 1, self.font, "center", "center" );

	end

end