local tiles = { }
local timer
local enabled = true

local ROW_COUNT = 12

function toggleCustomTiles ( )
	disabled = not enabled
	    if ( enabled ) then
		    handleTileLoading ( )
		        timer = setTimer ( handleTileLoading, 500, 0 )
	    else
		    if isTimer ( timer ) then killTimer ( timer ) end
		        for name, data in pairs ( tiles ) do
			        unloadTile ( name )
		        end
	       end
	end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), toggleCustomTiles)


function handleTileLoading ( )
	local visibleTileNames = table.merge ( engineGetVisibleTextureNames ( "radar??" ), engineGetVisibleTextureNames ( "radar???" ) )
	    for name, data in pairs ( tiles ) do
		    if not table.find ( visibleTileNames, name ) then
			    unloadTile ( name )
		    end
	    end
	for index, name in ipairs ( visibleTileNames ) do
		loadTile ( name )
	end
end

function table.merge ( ... )
	local ret = { }
	    for index, tbl in ipairs ( {...} ) do
		    for index, val in ipairs ( tbl ) do
			    table.insert ( ret, val )
		    end
	    end
	return ret
end

function table.find ( tbl, val )
	for index, value in ipairs ( tbl ) do
		if ( value == val ) then
			return index
		end
	end
	
	return false
end

function loadTile ( name )
	if type ( name ) ~= "string" then
		return false
	end
	
	if ( tiles[name] ) then
		return true
	end
	
	local id = tonumber ( name:match ( "%d+" ) )
	
	if not ( id ) then
		return false
	end
	
	local row = math.floor ( id / ROW_COUNT )
	local col = id - ( row * ROW_COUNT )
	
	local posX = -3000 + 500 * col
	local posY =  3000 - 500 * row
	
	local file = string.format ( "sattelite/sattelite_%d_%d.png", row, col )

	local texture = dxCreateTexture ( file )
	if not ( texture ) then
		outputChatBox ( string.format ( "Failed to load texture for %q (%q)", tostring ( name ), tostring ( file ) ) )
		return false
	end
	
	local shader = dxCreateShader ( "texreplace.fx" )
	
	if not ( shader ) then
		outputChatBox ( "Failed to load shader" )
		destroyElement ( texture )
		return false
	end
	
	dxSetShaderValue ( shader, "gTexture", texture )
	engineApplyShaderToWorldTexture ( shader, name )
	tiles[name] = { shader = shader, texture = texture }
	return true
end

function unloadTile ( name )
	local tile = tiles[name]
	    if not ( tile ) then
		    return false
	    end
	if isElement ( tile.shader )  then destroyElement ( tile.shader )  end
	if isElement ( tile.texture ) then destroyElement ( tile.texture ) end
	
	tiles[name] = nil
	return true
end