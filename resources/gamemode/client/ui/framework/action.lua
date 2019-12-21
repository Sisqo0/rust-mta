ActionMenu = { };
ActionMenu.__index = ActionMenu;

setmetatable( ActionMenu, Usefull );

function ActionMenu:create( x, y, w, h )

	local self = setmetatable( {

		x 			= x,
		y 			= y,
		w 			= w,
		h 			= h,
		actions 	= { },
		visible 	= true,
		clickable 	= true,
		font 		= "clear",
		size 		= 0,
		mouse_on 	= false,
		background 	= dxCreateShader( "assets/shaders/circle.fx" ),
		source 		= createElement( "ui" )

	}, ActionMenu );

	self.source:setData( "mouse_on", false, false );
	self.source:setData( "is_action", true, false );

	insert( Framework.elements, self );

	return self;

end

function ActionMenu:setFont( font )

	self.font = font;

end

function ActionMenu:tick( )

	self.mouse_on = false;

	if ( self.visible ) then

		if ( isCursorShowing( ) ) then

			local angle = 0;
			local min_angle = 0;
			local min_distance = 999;

			for i=1, maxn( self.actions ) do

				angle = angle + self.size;

				local x = self.x + cos( rad( -( 90 + self.size / 2 ) + angle ) ) * ( sqrt( self.w * self.h ) / 2 - 35 );
				local y = self.y + sin( rad( -( 90 + self.size / 2 ) + angle ) ) * ( sqrt( self.w * self.h ) / 2 - 35 );
				local cursor = { getCursorPosition( ) };

				local distance = math.sqrt( ( x - cursor[ 1 ] )^2 + ( y - cursor[ 2 ] )^2 );
				if ( distance < min_distance ) then

					min_angle = i;
					min_distance = distance;

				end

			end

			self.mouse_on = min_angle;
			self.source:setData( "mouse_on", min_angle, false );

		end

	end

end

function ActionMenu:render( )

	if ( self.visible ) then

		local angle = 0;

		dxDrawCircle( self.background, self.x, self.y, self.w, self.h, tocolor( 255, 255, 255 ), 0, 360, 80 );
		if ( maxn( self.actions ) > 0 ) then
		
			for i=1, maxn( self.actions ) do

				angle = angle + self.size;

				if ( self.mouse_on == i ) then

					dxDrawCircle( self.actions[ i ].shader, self.x, self.y, self.w + 40, self.h + 40, tocolor( 255, 39, 15 ), ( self.size * ( i - 1 ) ), ( self.size * i ) - ( self.size * ( i - 1 ) ), 90 );

				end

				local x = self.x + cos( rad( -( 90 + self.size / 2 ) + angle ) ) * ( sqrt( self.w * self.h ) / 2 - ( self.mouse_on == i and 25 or 40 ) );
				local y = self.y + sin( rad( -( 90 + self.size / 2 ) + angle ) ) * ( sqrt( self.w * self.h ) / 2 - ( self.mouse_on == i and 25 or 40 ) );
				dxDrawText( self.actions[ i ].name, x, y, 1 + x, 1 + y, self.mouse_on == i and tocolor( 255, 255, 255 ) or tocolor( 25, 25, 25 ), 1, self.font, "center", "center" );

			end

		end

	end

end

function ActionMenu:addAction( action )

	action.shader = dxCreateShader( "assets/shaders/circle.fx" );
	insert( self.actions, action );
	self.size = 360 / #self.actions;

end

function ActionMenu:removeAction( action )

	destroyElement( self.actions[ action ].shader );
	remove( self.actions, action );
	self.size = 360 / #self.actions;

end

-- https://wiki.multitheftauto.com/wiki/Shader_examples;

function dxDrawCircle( circleShader, x, y, width, height, color, angleStart, angleSweep, borderWidth )
	if ( not isElement ( circleShader ) ) then
		return;
	end
	height = height or width
	color = color or tocolor(255,255,255)
	borderWidth = borderWidth or 1e9
	angleStart = angleStart or 0
	angleSweep = angleSweep or 360 - angleStart
	if ( angleSweep < 360 ) then
		angleEnd = math.fmod( angleStart + angleSweep, 360 ) + 0
	else
		angleStart = 0
		angleEnd = 360
	end
	x = x - width / 2
	y = y - height / 2
	dxSetShaderValue ( circleShader, "sCircleWidthInPixel", width );
	dxSetShaderValue ( circleShader, "sCircleHeightInPixel", height );
	dxSetShaderValue ( circleShader, "sBorderWidthInPixel", borderWidth );
	dxSetShaderValue ( circleShader, "sAngleStart", math.rad( angleStart ) - math.pi );
	dxSetShaderValue ( circleShader, "sAngleEnd", math.rad( angleEnd ) - math.pi );
	dxDrawImage( x, y, width, height, circleShader, 0, 0, 0, color )
end