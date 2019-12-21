Usefull = { };
Usefull.__index = Usefull;

function Usefull:setVisible( bool )

	self.visible = bool;
	if ( not bool ) then

		self.source:setData( "mouse_on", false, false );

	end

end

function Usefull:isVisible( )

	return self.visible;

end

function Usefull:setClickable( bool )

	self.clickable = bool;

end

function Usefull:setText( text )

	if ( self.text ) then

		self.text = text;

	end

end

function Usefull:getText( )

	return self.text;

end

function Usefull:setPosition( x, y )

	self.x = x;
	self.y = y;

end

function Usefull:setSize( w, h )

	self.w = w;
	self.h = h;

end

function Usefull:getPosition( )

	return self.x, self.y;

end

function Usefull:getSize( )

	return self.w, self.h;

end

function Usefull:destroy( )

	for k, v in ipairs( Framework.elements ) do

		if ( v == self ) then

			remove( Framework.elements, k );

		end

	end

	self:destroyElements( );
	setmetatable( self, nil );
	self = nil;

end

function Usefull:destroyElements( )

	for _, v in ipairs( self ) do

		if ( isElement( v ) ) then

			v:destroy( );

		end

	end

end