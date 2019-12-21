Images = { };
Images.__index = Images;

setmetatable( Images, Usefull );

function Images:create( x, y, w, h, image )

	local self = setmetatable( {

		x 			= x,
		y 			= y,
		w 			= w,
		h 			= h,
		image 		= image,
		r 			= { 0, 0, 0 },
		color 		= { 255, 255, 255, 255 },
		visible 	= true,
		clickable 	= true,
		source 		= createElement( "ui" )

	}, Images );

	self.source:setData( "mouse_on", false, false );

	insert( Framework.elements, self );

	return self;

end

function Images:setColor( color )

	self.color = color;

end

function Images:setRotation( rot )

	self.r = rot;

end

function Images:setImage( image )

	self.image = image;

end

function Images:tick( )

end

function Images:render( )

	if ( self.visible ) then

		dxDrawImage( self.x, self.y, self.w, self.h, self.image, self.r[ 1 ], self.r[ 2 ], self.r[ 3 ], tocolor( self.color[ 1 ] or 255, self.color[ 2 ] or 255, self.color[ 3 ] or 255, self.color[ 4 ] or 255 ) );

	end

end