addEvent( "onClientUIClick", true );
addEvent( "onClientUIMouseEnter", true );
addEvent( "onClientUIMouseLeave", true );

Framework = { };
Framework.elements = { };

function Framework.setup( )

	addEventHandler( "onClientRender", root, Framework.render );
	addEventHandler( "onClientClick", root, Framework.click );

end

function Framework.render( )

	for _, v in ipairs( Framework.elements ) do

		if ( v.visible and v.clickable ) then

			local c = { getCursorPosition( ) };
			local data = v.source:getData( "mouse_on" );

			if ( Framework.rectangleWithPointCollision( v.x, v.y, v.w, v.h, c[ 1 ], c[ 2 ] ) ) then

				if ( not data ) then

					triggerEvent( "onClientUIMouseEnter", v.source );
					v.source:setData( "mouse_on", true, false );

				end

			else

				if ( data ) then

					triggerEvent( "onClientUIMouseLeave", v.source );
					v.source:setData( "mouse_on", false, false );

				end

			end

		else

			if ( v.source:getData( "mouse_on" ) ) then

				v.source:setData( "mouse_on", false, false );

			end

		end

		v:tick( );
		v:render( );

	end

end

function Framework.click( b, s )

	if ( b == "left" and s == "up" ) then

		for _, ui_element in ipairs( getElementsByType( "ui" ) ) do

			local is_action = ui_element:getData( "is_action" );
			local data = ui_element:getData( "mouse_on" );
			if ( data ) then

				triggerEvent( "onClientUIClick", ui_element, is_action and data or nil );

			end

		end

	end

end

function Framework.rectangleWithPointCollision( rx, ry, rw, rh, px, py )

	return px >= rx and py >= ry
	   and px <= rx + rw and py <= ry + rh;

end