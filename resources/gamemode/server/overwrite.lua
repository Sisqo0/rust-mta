_removeElementData = removeElementData;
function removeElementData( element, data )

	setElementData( element, data, false );
	_removeElementData( element, data );

end