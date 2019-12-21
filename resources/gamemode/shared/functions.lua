function countCharacter( string_, findC )

	local text = string_ or "";
	local findC_c = 0;

	while( find( text, findC ) ) do

		findC_c = findC_c + 1;

		local find_ = { find( text, findC ) };

		text = sub( text, find_[ 2 ] + 1, text: len( ) );

	end

	return findC_c;

end

-- https://wiki.multitheftauto.com/wiki/Math.round;

function round( number )

	return number - number % 1;

end

function isCollidingWithBuildArea( area1, area2 )

	local distance = getDistanceBetweenPoints2D( area1.x, area1.y, area2.x, area2.y );
	return distance <= area1.r + area2.r and area2.z + Building.areaHeight >= area1.z and area2.z <= area1.z + Building.areaHeight;

end

-- https://wiki.multitheftauto.com/wiki/IsEventHandlerAdded

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end