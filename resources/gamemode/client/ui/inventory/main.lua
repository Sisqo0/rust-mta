addEvent( "inventory > load_items", true );
addEvent( "inventory > update_item", true );
addEvent( "inventory > reset_items", true );

Inventory = { };

Inventory.preview = { };

Inventory.key = "tab";
Inventory.is_visible = false;

Inventory.selected_item = false;
Inventory.item_on = false;
Inventory.moving_item = false;
Inventory.click_ms = 0;
Inventory.block_event = false;
Inventory.in_drop_area = false;

Inventory.items = false;

Inventory.UI = {

	hotbar 		= { },
	inventory 	= { },
	clothes 	= { },
	rectangles 	= { },
	labels 		= { },
	buttons 	= { },
	radios 		= { },
	images 		= { },
	description = { },
	use_button 	= { }

};

function Inventory.setup( )

	bindKey( "tab", "down", Inventory.toggle );
	toggleControl( "action", false );

	Inventory.preview.ped = createPed( localPlayer.model, 0, 0, 0 );
	exports[ "object_preview" ]:setAlpha( Inventory.preview.preview, 0 );

	-- CREATING UI;

	Inventory.UI.background = Images:create( 0, 0, screen[ 1 ], screen[ 2 ], "assets/images/background.png" );
	Inventory.UI.background:setColor( { 255, 255, 255, 240 } );

	Inventory.UI.buttons[ 1 ] = Buttons:create( screen[ 1 ] / 2 - 200 / 2, 0, 200, 50, "CRAFTING" );

	addEventHandler( "onClientUIClick", Inventory.UI.buttons[ 1 ].source,
		function( )
			
			Inventory.setVisible( false );
			Crafting.setVisible( true );

		end
	);

	Inventory.UI.buttons[ 2 ] = Buttons:create( 20, screen[ 2 ] - ( ( INVENTORY_SLOTS.SIZE * 2 + 10 ) / 2 + 30 / 2 ), 100, 30, "CREATE TEAM" );

	local FONT_H = dxGetFontHeight( 1, "clear" ) + 2;

	-- CLOTHES;

	local CLOTHES_X = 20;
	local CLOTHES_Y = screen[ 2 ] - ( ( INVENTORY_SLOTS.SIZE * 3 ) + 30 );

	for i=1, INVENTORY_SLOTS.CLOTHES do

		Inventory.UI.clothes[ i ] = { };
		Inventory.UI.clothes[ i ][ 1 ] = Rectangles:create( CLOTHES_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), CLOTHES_Y, INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, { 200, 200, 200, 50 } );
		Inventory.UI.clothes[ i ][ 2 ] = Images:create( CLOTHES_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), CLOTHES_Y, INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, "assets/images/null.png" );
		Inventory.UI.clothes[ i ][ 3 ] = Labels:create( CLOTHES_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ) + 4, CLOTHES_Y + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), 0, 0, "" );
		Inventory.UI.clothes[ i ][ 4 ] = Rectangles:create( CLOTHES_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), CLOTHES_Y + INVENTORY_SLOTS.SIZE, 2, 0, { 131, 179, 68, 255 } );
		Inventory.UI.clothes[ i ][ 5 ] = Labels:create( CLOTHES_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), CLOTHES_Y + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), INVENTORY_SLOTS.SIZE, 0, "" );
		Inventory.UI.clothes[ i ][ 5 ]:setHorizontalAlign( "right" );

	end

	-- HOTBAR;

	local HOTBAR_W = ( INVENTORY_SLOTS.SIZE + 5 ) * INVENTORY_SLOTS.INVENTORY.c;
	local HOTBAR_X = screen[ 1 ] / 2 - HOTBAR_W / 2;
	local HOTBAR_Y = screen[ 2 ] - ( INVENTORY_SLOTS.SIZE + 20 );

	for i=1, INVENTORY_SLOTS.INVENTORY.c do

		Inventory.UI.hotbar[ i ] = { };
		Inventory.UI.hotbar[ i ][ 1 ] = Rectangles:create( HOTBAR_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), HOTBAR_Y, INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, { 200, 200, 200, 50 } );
		Inventory.UI.hotbar[ i ][ 2 ] = Images:create( HOTBAR_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), HOTBAR_Y, INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, "assets/images/null.png" );
		Inventory.UI.hotbar[ i ][ 3 ] = Labels:create( HOTBAR_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ) + 4, HOTBAR_Y + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), 0, 0, "" );
		Inventory.UI.hotbar[ i ][ 4 ] = Rectangles:create( HOTBAR_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), HOTBAR_Y + INVENTORY_SLOTS.SIZE, 2, 0, { 131, 179, 68, 255 } );
		Inventory.UI.hotbar[ i ][ 5 ] = Labels:create( HOTBAR_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * i ) ), HOTBAR_Y + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), INVENTORY_SLOTS.SIZE, 0, "" );
		Inventory.UI.hotbar[ i ][ 5 ]:setHorizontalAlign( "right" );

		bindKey( i, "both",
			function( k, s )
				
				if ( not Inventory.is_visible and ( not UI.current_panel ) ) then

					if ( s == "down" ) then

						Inventory.UI.hotbar[ i ][ 1 ]:setColor( { 20, 138, 255, 200 } );

						if ( Inventory.getItemUsedIn( "hotbar", i ) ) then

							Inventory.useItem( Inventory.getItemUsedIn( "hotbar", i ) );

						end

					elseif ( s == "up" ) then

						Inventory.UI.hotbar[ i ][ 1 ]:setColor( { 200, 200, 200, 50 } );

					end

				end

			end
		);

	end

	-- INVENTORY;

	local INV_H = ( INVENTORY_SLOTS.SIZE + 5 ) * INVENTORY_SLOTS.INVENTORY.r;
	local INV_X = screen[ 1 ] / 2 - HOTBAR_W / 2;
	local INV_Y = screen[ 2 ] - ( INV_H + INVENTORY_SLOTS.SIZE + 35 );

	local c = 1;
	local r = 1;

	for i=1, ( INVENTORY_SLOTS.INVENTORY.r * INVENTORY_SLOTS.INVENTORY.c ) do

		Inventory.UI.inventory[ i ] = { };
		Inventory.UI.inventory[ i ][ 1 ] = Rectangles:create( INV_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * c ) ), INV_Y + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * r ) ), INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, { 200, 200, 200, 50 } );
		Inventory.UI.inventory[ i ][ 2 ] = Images:create( INV_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * c ) ), INV_Y + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * r ) ), INVENTORY_SLOTS.SIZE, INVENTORY_SLOTS.SIZE, "assets/images/null.png" );
		Inventory.UI.inventory[ i ][ 3 ] = Labels:create( INV_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * c ) ) + 4, ( INV_Y + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * r ) ) ) + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), 0, 0, "" );
		Inventory.UI.inventory[ i ][ 4 ] = Rectangles:create( INV_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * c ) ), ( INV_Y + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * r ) ) ) + INVENTORY_SLOTS.SIZE, 2, 0, { 131, 179, 68, 255 } );
		Inventory.UI.inventory[ i ][ 5 ] = Labels:create( INV_X + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * c ) ), INV_Y + ( -INVENTORY_SLOTS.SIZE + ( ( INVENTORY_SLOTS.SIZE + 5 ) * r ) ) + INVENTORY_SLOTS.SIZE - ( FONT_H - 2 ), INVENTORY_SLOTS.SIZE, 0, "" );
		Inventory.UI.inventory[ i ][ 5 ]:setHorizontalAlign( "right" );

		if ( c + 1 > INVENTORY_SLOTS.INVENTORY.c ) then

			c = 1;
			r = r + 1;

		else

			c = c + 1;

		end

	end

	Inventory.UI.rectangles[ 1 ] = Rectangles:create( INV_X + 5, INV_Y - 9, HOTBAR_W - 5, 2, { 200, 200, 200, 50 } );

	Inventory.UI.radios[ 1 ] = Radios:create( INV_X + 5, INV_Y - 105, HOTBAR_W - 60, 50, 50, 100 );
	Inventory.UI.rectangles[ 2 ] = Rectangles:create( INV_X + ( HOTBAR_W - 50 ), INV_Y - 105, 50, 50, { 200, 200, 200, 50 } );
	Inventory.UI.images[ 1 ] = Images:create( INV_X + ( HOTBAR_W - 50 ), INV_Y - 105, 50, 50, "assets/images/null.png" );
	Inventory.UI.rectangles[ 3 ] = Rectangles:create( INV_X + 5, INV_Y - 210, HOTBAR_W - 5, 100, { 200, 200, 200, 50 } );
	Inventory.UI.description[ 1 ] = Labels:create( INV_X + 10, INV_Y - 205, HOTBAR_W - 15, 90, ITEMS[ 1 ].name .. ":\n" .. ITEMS[ 1 ].description );
	Inventory.UI.images[ 2 ] = Images:create( INV_X + ( HOTBAR_W - 55 ), INV_Y - 205, 50, 50, "assets/images/null.png" );
	Inventory.UI.use_button[ 1 ] = Buttons:create( INV_X + 5, INV_Y - 50, HOTBAR_W - 5, 30, "USE" );

	addEventHandler( "onClientUIClick", Inventory.UI.use_button[ 1 ].source,
		function( )
			
			Inventory.useItem( Inventory.selected_item );

		end
	);

	addEventHandler( "onClientUIMouseEnter", Inventory.UI.rectangles[ 2 ].source,
		function( )

			Inventory.UI.rectangles[ 2 ]:setColor( { 20, 138, 255, 200 } );
			Inventory.item_on = "selected_item";

		end
	);

	addEventHandler( "onClientUIMouseLeave", Inventory.UI.rectangles[ 2 ].source,
		function( )

			Inventory.UI.rectangles[ 2 ]:setColor( { 200, 200, 200, 50 } );
			Inventory.item_on = false;

		end
	);

	Inventory.setVisible( false );

	for _, ui_table in ipairs( { Inventory.UI.inventory, Inventory.UI.clothes, Inventory.UI.hotbar } ) do

		for k, v in ipairs( ui_table ) do

			addEventHandler( "onClientUIMouseEnter", v[ 1 ].source,
				function( )

					v[ 1 ]:setColor( { 20, 138, 255, 200 } );
					Inventory.item_on = { ui_table, k };

				end
			);

			addEventHandler( "onClientUIMouseLeave", v[ 1 ].source,
				function( )

					v[ 1 ]:setColor( { 200, 200, 200, 50 } );
					Inventory.item_on = false;

				end
			);

		end

	end

	addEventHandler( "inventory > load_items", root, Inventory.loadItems );
	addEventHandler( "inventory > update_item", root, Inventory.updateItem );
	addEventHandler( "inventory > reset_items", root, Inventory.reset );
	addEventHandler( "onClientClick", root, Inventory.click );

end

function Inventory.click( b, s )

	if ( b == "left" ) then

		if ( s == "down" ) then

			Inventory.click_ms = getTickCount( );

			if ( Inventory.item_on and ( not Inventory.moving_item ) ) then

				if ( Inventory.item_on[ 1 ] == Inventory.UI.inventory ) then

					if ( Inventory.items[ Inventory.item_on[ 2 ] ] ) then

						Inventory.moving_item = Inventory.item_on;

					end

				elseif ( Inventory.item_on[ 1 ] == Inventory.UI.hotbar ) then

					local slot, value = Inventory.getItemUsedIn( "hotbar", Inventory.item_on[ 2 ] );
					if ( slot ) then

						Inventory.moving_item = { Inventory.item_on[ 1 ], slot, Inventory.item_on[ 2 ] };

					end

				elseif ( Inventory.item_on[ 1 ] == Inventory.UI.clothes ) then

					local slot, value = Inventory.getItemUsedIn( "clothes", Inventory.item_on[ 2 ] );
					if ( slot ) then

						Inventory.moving_item = { Inventory.item_on[ 1 ], slot, Inventory.item_on[ 2 ] };

					end

				elseif ( Inventory.item_on == "selected_item" ) then

					Inventory.moving_item = { "selected_item", Inventory.selected_item };

				end

				addEventHandler( "onClientRender", root, Inventory.renderMovingItem );

			end

		elseif ( s == "up" ) then

			if ( Inventory.moving_item ) then

				if ( Inventory.item_on ) then

					if ( Inventory.moving_item[ 1 ] == "selected_item" ) then

						local ammount = Inventory.UI.radios[ 1 ]:getProgress( );

						if ( ammount > 0 and ( not ( ammount == 1 and Inventory.items[ Inventory.moving_item[ 2 ] ].ammount == 1 ) ) ) then

							if ( Inventory.item_on and Inventory.item_on[ 1 ] == Inventory.UI.inventory ) then

								if ( Inventory.moving_item[ 2 ] ~= Inventory.item_on[ 2 ] ) then

									if ( not Inventory.items[ Inventory.item_on[ 2 ] ] ) then

										if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
										triggerServerEvent( "inventory > give_item", localPlayer, localPlayer, Inventory.items[ Inventory.moving_item[ 2 ] ].item, ammount, Inventory.items[ Inventory.moving_item[ 2 ] ].life, Inventory.item_on[ 2 ], true );
										triggerServerEvent( "inventory > update_ammount", localPlayer, localPlayer, Inventory.moving_item[ 2 ], Inventory.items[ Inventory.moving_item[ 2 ] ].ammount - ammount );

									elseif ( Inventory.items[ Inventory.item_on[ 2 ] ].item == Inventory.items[ Inventory.moving_item[ 2 ] ].item and ITEMS[ Inventory.items[ Inventory.moving_item[ 2 ] ].item ].stackable ) then
									
										if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
										triggerServerEvent( "inventory > update_ammount", localPlayer, localPlayer, Inventory.item_on[ 2 ], Inventory.items[ Inventory.item_on[ 2 ] ].ammount + ammount );
										triggerServerEvent( "inventory > update_ammount", localPlayer, localPlayer, Inventory.moving_item[ 2 ], Inventory.items[ Inventory.moving_item[ 2 ] ].ammount - ammount );

									end

								end

							end

						end

					else

						if ( not ( Inventory.moving_item[ 1 ] == Inventory.item_on[ 1 ] and ( Inventory.moving_item[ 3 ] and Inventory.moving_item[ 3 ] == Inventory.item_on[ 2 ] or Inventory.moving_item[ 2 ] == Inventory.item_on[ 2 ] ) ) ) then

							if ( Inventory.item_on[ 1 ] == Inventory.UI.inventory ) then

								if ( Inventory.items[ Inventory.item_on[ 2 ] ] and Inventory.items[ Inventory.moving_item[ 2 ] ].item == Inventory.items[ Inventory.item_on[ 2 ] ].item and ITEMS[ Inventory.items[ Inventory.moving_item[ 2 ] ].item ].stackable ) then

									if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
									triggerServerEvent( "inventory > update_ammount", localPlayer, localPlayer, Inventory.item_on[ 2 ], Inventory.items[ Inventory.item_on[ 2 ] ].ammount + Inventory.items[ Inventory.moving_item[ 2 ] ].ammount );
									triggerServerEvent( "inventory > take_item", localPlayer, localPlayer, Inventory.moving_item[ 2 ] );

								else

									if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
									triggerServerEvent( "inventory > trade_slot", localPlayer, localPlayer, Inventory.moving_item[ 2 ], Inventory.item_on[ 2 ] );

								end

							elseif ( Inventory.item_on[ 1 ] == Inventory.UI.hotbar ) then

								if ( Inventory.moving_item[ 1 ] == Inventory.UI.inventory and ( not Inventory.getItemUsedIn( "hotbar", Inventory.item_on[ 2 ] ) ) ) then

									if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
									triggerServerEvent( "inventory > set_usedin", localPlayer, localPlayer, "hotbar", Inventory.moving_item[ 2 ], Inventory.item_on[ 2 ] );

								elseif ( Inventory.moving_item[ 1 ] == Inventory.UI.hotbar ) then

									if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
									triggerServerEvent( "inventory > trade_usedin", localPlayer, localPlayer, Inventory.moving_item[ 2 ], Inventory.getItemUsedIn( "hotbar", Inventory.item_on[ 2 ] ), "hotbar", Inventory.item_on[ 2 ] );

								end

							elseif ( Inventory.item_on[ 1 ] == Inventory.UI.clothes ) then

								if ( Inventory.moving_item[ 1 ] == Inventory.UI.inventory and ( not Inventory.getItemUsedIn( "clothes", Inventory.item_on[ 2 ] ) ) ) then

									if ( ITEMS[ Inventory.items[ Inventory.moving_item[ 2 ] ].item ].clothes and ITEMS[ Inventory.items[ Inventory.moving_item[ 2 ] ].item ].clothes[ 1 ] == Inventory.item_on[ 2 ] ) then

										if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
										triggerServerEvent( "inventory > set_usedin", localPlayer, localPlayer, "clothes", Inventory.moving_item[ 2 ], Inventory.item_on[ 2 ] );

									end

								end

							end

						else

							if ( getTickCount( ) - Inventory.click_ms < 200 ) then

								if ( Inventory.moving_item[ 1 ] == Inventory.UI.inventory ) then

									if ( Inventory.selected_item ~= Inventory.moving_item[ 2 ] ) then

										Inventory.selected_item = Inventory.moving_item[ 2 ];
										Inventory.showSelectedItemPanel( true );

									else

										Inventory.selected_item = false;
										Inventory.showSelectedItemPanel( false );

									end

								else

									local tab = false;

									if ( Inventory.moving_item[ 1 ] == Inventory.UI.hotbar ) then

										tab = "hotbar";

									elseif ( Inventory.moving_item[ 1 ] == Inventory.UI.clothes ) then

										tab = "clothes";

									end

									if ( tab ) then

										if ( localPlayer:getData( "waiting_response" ) ) then return; else localPlayer:setData( "waiting_response", true ); end
										triggerServerEvent( "inventory > remove_usedin", localPlayer, localPlayer, Inventory.moving_item[ 2 ] );

									end

								end

							end

						end

					end

					Inventory.moving_item = false;
					Inventory.in_drop_area = false;

				else

					Inventory.moving_item = false;
					Inventory.in_drop_area = false;
					
				end

			end

		end

	elseif ( b == "right" ) then

	end

end

function Inventory.renderMovingItem( )

	local cursor = { getCursorPosition( ) };
	local item = "assets/images/null.png";

	if ( Inventory.moving_item ) then

		item = "assets/images/items/" .. Inventory.items[ Inventory.moving_item[ 2 ] ].item .. ".png";		

	else

		removeEventHandler( "onClientRender", root, Inventory.renderMovingItem );

	end

	dxDrawImage( cursor[ 1 ] - 25, cursor[ 2 ] - 25, 50, 50, item, 0, 0, 0, tocolor( 255, 255, 255 ), true );

	if ( item ~= "assets/images/null.png" ) then

		local drop_w = ( INVENTORY_SLOTS.SIZE + 5 ) * INVENTORY_SLOTS.INVENTORY.c;
		
		local INV_H = ( INVENTORY_SLOTS.SIZE + 5 ) * INVENTORY_SLOTS.INVENTORY.r;
		local INV_Y = screen[ 2 ] - ( INV_H + INVENTORY_SLOTS.SIZE + 35 );

		local drop_h = Inventory.selected_item and ( screen[ 2 ] - ( INV_H + INVENTORY_SLOTS.SIZE + 320 ) ) or ( screen[ 2 ] - ( INV_H + INVENTORY_SLOTS.SIZE + 100 ) );

		local drop_y = 60;
		local drop_x = screen[ 1 ] / 2 - drop_w / 2;

		dxDrawDropArea( drop_x + 5, drop_y, drop_w - 5, drop_h );

	end

end

function Inventory.toggle( )

	if ( ( not UI.current_panel ) or UI.current_panel == "inventory" ) then

		Inventory.is_visible = not Inventory.is_visible;
		UI.current_panel = Inventory.is_visible and "inventory" or false;

		showChat( not Inventory.is_visible );
		showCursor( Inventory.is_visible );

		Inventory.setVisible( Inventory.is_visible );
		Crafting.setVisible( false );

		setPlayerHudComponentVisible( "radar", not Inventory.is_visible );

	end

end

function Inventory.hide( )

	Inventory.is_visible = false;
	UI.current_panel = Inventory.is_visible and "inventory" or false;

	showChat( not Inventory.is_visible );
	showCursor( Inventory.is_visible );

	Inventory.setVisible( Inventory.is_visible );
	Crafting.setVisible( false );

	setPlayerHudComponentVisible( "radar", not Inventory.is_visible );

end

function Inventory.loadItems( items )

	Inventory.moving_item = false;
	Inventory.in_drop_area = false;
	Inventory.selected_item = false;
	Inventory.showSelectedItemPanel( false );

	Inventory.items = items;

	for k, v in pairs( Inventory.items ) do

		Inventory.loadItem( "inventory", k, v.item, v.ammount, v.life, v.ammo );
		if ( v.used_in ) then

			Inventory.loadItem( v.used_in[ 1 ], v.used_in[ 2 ], v.item, v.ammount, v.life, v.ammo );

		end

	end

end

function Inventory.reset( )

	for i=1, INVENTORY_SLOTS.CLOTHES do

		Inventory.loadItem( "clothes", i, false, false, false, false );

	end

	for i=1, INVENTORY_SLOTS.INVENTORY.c do

		Inventory.loadItem( "hotbar", i, false, false, false, false );

	end

	for i=1, ( INVENTORY_SLOTS.INVENTORY.c * INVENTORY_SLOTS.INVENTORY.r ) do

		Inventory.loadItem( "inventory", i, false, false, false, false );

	end

end

function Inventory.updateItem( i, item, old_usedin )

	if ( Inventory.selected_item == i ) then

		Inventory.selected_item = false;
		Inventory.showSelectedItemPanel( false );

	end

	if ( item ) then

		Inventory.items[ i ] = item;
		Inventory.loadItem( "inventory", i, Inventory.items[ i ].item, Inventory.items[ i ].ammount, Inventory.items[ i ].life, Inventory.items[ i ].ammo );

		if ( old_usedin ) then

			Inventory.loadItem( old_usedin[ 1 ], old_usedin[ 2 ], false, false, false, false );

		end

		if ( Inventory.items[ i ].used_in ) then

			Inventory.loadItem( Inventory.items[ i ].used_in[ 1 ], Inventory.items[ i ].used_in[ 2 ], Inventory.items[ i ].item, Inventory.items[ i ].ammount, Inventory.items[ i ].life, Inventory.items[ i ].ammo );

		end

	else

		Inventory.loadItem( "inventory", i, false, false, false, false );

		if ( Inventory.items[ i ].used_in ) then

			Inventory.loadItem( Inventory.items[ i ].used_in[ 1 ], Inventory.items[ i ].used_in[ 2 ], false, false, false, false );

		end

		Inventory.items[ i ] = nil;

	end

end

function Inventory.loadItem( type, i, item, ammount, life, ammo )

	Inventory.UI[ type ][ i ][ 2 ]:setImage( item and ( "assets/images/items/" .. item .. ".png" ) or "assets/images/null.png" );
	Inventory.UI[ type ][ i ][ 3 ]:setText( ( ammount and ammount > 1 ) and ( "x" .. ammount ) or "" );
	Inventory.UI[ type ][ i ][ 4 ]:setSize( 2, item and ( ITEMS[ item ].wear and ( -( ( life / 100 ) * INVENTORY_SLOTS.SIZE ) ) or 0 ) or 0 );
	Inventory.UI[ type ][ i ][ 5 ]:setText( item and ( ITEMS[ item ].show_ammo and ammo or 0 ) or "" );
	Inventory.UI[ type ][ i ][ 5 ]:setColor( ammo and ( ITEMS[ item ].show_ammo and ( ammo > 0 and { 255, 255, 255, 255 } or { 200, 200, 200, 255 } ) or { 0, 0, 0, 0 } ) or { 0, 0, 0, 0 } );

end

function Inventory.setVisible( bool )

	if ( bool ) then

		for i=0, 3 do

			local clothe = { localPlayer:getClothes( i ) };
			Inventory.preview.ped:addClothes( clothe[ 1 ], clothe[ 2 ], i );

		end

		Inventory.preview.preview = exports[ "object_preview" ]:createObjectPreview( Inventory.preview.ped, 0, 0, 200, -100, screen[ 2 ] - ( ( INVENTORY_SLOTS.SIZE * 3 ) + 600 ), 500, 500, false, true );
		Inventory.preview.ped.alpha = 255;

	else

		Inventory.preview.ped.alpha = 0;
		exports[ "object_preview" ]:destroyObjectPreview( Inventory.preview.preview );
		Inventory.moving_item = false;
		Inventory.item_on = false;

	end

	Inventory.UI.background:setVisible( bool );
	Inventory.showSelectedItemPanel( bool and Inventory.selected_item or false );

	for _, ui_table in ipairs( { Inventory.UI.inventory, Inventory.UI.clothes, Inventory.UI.labels, Inventory.UI.buttons } ) do

		for _, element in ipairs( ui_table ) do

			if ( not isElement( element.source ) ) then

				for _, v in ipairs( element ) do

					v:setVisible( bool );

				end

			else

				element:setVisible( bool );

			end

		end

	end

end

function Inventory.showSelectedItemPanel( bool )

	Inventory.UI.rectangles[ 1 ]:setVisible( bool );
	Inventory.UI.radios[ 1 ]:setVisible( bool );
	Inventory.UI.rectangles[ 2 ]:setVisible( bool );
	Inventory.UI.images[ 1 ]:setVisible( bool );
	Inventory.UI.images[ 2 ]:setVisible( bool );
	Inventory.UI.rectangles[ 3 ]:setVisible( bool );
	Inventory.UI.description[ 1 ]:setVisible( bool );
	Inventory.UI.use_button[ 1 ]:setVisible( bool );

	if ( Inventory.selected_item ) then

		Inventory.UI.description[ 1 ]:setText( ITEMS[ Inventory.items[ Inventory.selected_item ].item ].name .. ":\n" .. ITEMS[ Inventory.items[ Inventory.selected_item ].item ].description );
		Inventory.UI.radios[ 1 ]:setMax( Inventory.items[ Inventory.selected_item ].ammount );
		Inventory.UI.images[ 1 ]:setImage( "assets/images/items/" .. Inventory.items[ Inventory.selected_item ].item .. ".png" );
		Inventory.UI.images[ 2 ]:setImage( "assets/images/items/" .. Inventory.items[ Inventory.selected_item ].item .. ".png" );

	end

end

function Inventory.getItemUsedIn( used_in, slot )

	for k, v in pairs( Inventory.items ) do

		if ( v.used_in ) then

			if ( v.used_in[ 1 ] == used_in and v.used_in[ 2 ] == slot ) then

				return k, v;

			end

		end

	end

	return;

end

function Inventory.useItem( slot )

	triggerServerEvent( "inventory > use_item", localPlayer, localPlayer, slot );

end

-- sla

function dxDrawDropArea( x, y, w, h )

	Inventory.in_drop_area = false;

	local cursor = { getCursorPosition( ) };
	local colliding = false;

	if ( Framework.rectangleWithPointCollision( x, y, w, h, cursor[ 1 ], cursor[ 2 ] ) ) then

		Inventory.in_drop_area = true;
		colliding = true;

	end

	dxDrawRectangle( x, y, w, h, colliding and tocolor( 20, 138, 255, 200 ) or tocolor( 200, 200, 200, 50 ) );
	dxDrawText( "Drop Area", x, y, w + x, h + y, tocolor( 255, 255, 255 ), 1, "clear", "center", "center" );

end