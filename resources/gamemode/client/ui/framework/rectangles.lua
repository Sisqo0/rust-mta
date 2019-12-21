Rectangles = { };
Rectangles.__index = Rectangles;

setmetatable( Rectangles, Usefull );

function Rectangles:create( x, y, w, h, color )

	local self = setmetatable( {

		x 			= x,
		y 			= y,
		w 			= w,
		h 			= h,
		color 		= color,
		next_color 	= color,
		ms 			= getTickCount( ),
		visible 	= true,
		clickable 	= true,
		source 		= createElement( "ui" )

	}, Rectangles );

	self.source:setData( "mouse_on", false, false );

	insert( Framework.elements, self );

	return self;

end

function Rectangles:setColor( color )

	self.next_color = color;
	self.ms = getTickCount( );

end

function Rectangles:tick( )

	if ( self.visible ) then

		local r, g, b = interpolateBetween( self.color[ 1 ], self.color[ 2 ], self.color[ 3 ], self.next_color[ 1 ], self.next_color[ 2 ], self.next_color[ 3 ], ( getTickCount( ) - self.ms ) / 100, "OutQuad" );
		local a = interpolateBetween( self.color[ 4 ], 0, 0, self.next_color[ 4 ], 0, 0, ( getTickCount( ) - self.ms ) / 100, "OutQuad" );

		self.color = { r, g, b, a };

	end

end

function Rectangles:render( )

	if ( self.visible ) then

		dxDrawRectangle( self.x, self.y, self.w, self.h, tocolor( self.color[ 1 ] or 255, self.color[ 2 ] or 255, self.color[ 3 ] or 255, self.color[ 4 ] or 255 ) );

	end

end