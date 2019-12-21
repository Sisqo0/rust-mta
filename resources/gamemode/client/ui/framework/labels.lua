Labels = { };
Labels.__index = Labels;

setmetatable( Labels, Usefull );

function Labels:create( x, y, w, h, text )

	local self = setmetatable( {

		x 					= x,
		y 					= y,
		w 					= w,
		h 					= h,
		text 				= text,
		color 				= { 255, 255, 255, 255 },
		size 				= 1,
		font 				= "clear",
		hex 				= false,
		r 					= { 0, 0, 0 },
		horizontal_align 	= "left",
		vertical_align		= "top",
		visible 			= true,
		clickable 			= true,
		source 				= createElement( "ui" )

	}, Labels );

	self.source:setData( "mouse_on", false, false );

	insert( Framework.elements, self );

	return self;

end

function Labels:setHorizontalAlign( align )

	self.horizontal_align = align;

end

function Labels:setVerticalAlign( align )

	self.vertical_align = align;

end

function Labels:setFont( font )

	self.font = font;

end

function Labels:setHexCodeEnabled( bool )

	self.hex = bool;

end

function Labels:setRotation( rot )

	self.r = rot;

end

function Labels:setColor( color )

	self.color = color;

end

function Labels:tick( )

end

function Labels:render( )

	if ( self.visible ) then

		local x = self.x;
		local y = self.y;
		local w = dxGetTextWidth( self.text, self.size, self.font );
		local h = dxGetFontHeight( self.size, self.font );

		if ( self.horizontal_align == "center" ) then

			x = x + ( self.w / 2 - w / 2 );

		elseif ( self.horizontal_align == "right" ) then

			x = x + ( self.w - w );

		end

		if ( self.vertical_align == "center" ) then

			y = y + ( self.h / 2 - h / 2 );

		elseif ( self.vertical_align == "bottom" ) then

			y = y + ( self.h - h );

		end

		dxDrawText( self.text, x, y, self.w, self.h, tocolor( self.color[ 1 ] or 255, self.color[ 2 ] or 255, self.color[ 3 ] or 255, self.color[ 4 ] or 255 ), self.size, self.font, _, _, _, _, _, self.hex, _, self.r[ 1 ], self.r[ 2 ], self.r[ 3 ] );

	end

end