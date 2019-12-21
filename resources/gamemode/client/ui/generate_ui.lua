UI = { };
UI.current_panel = false;

function UI.setup( )

	HUD.setup( );
	Aim.setup( );
	Inventory.setup( );
	Crafting.setup( );
	Wasted.setup( );

	showChat( true );

	setPlayerHudComponentVisible( "radar", true );

	-- setar prioridade;

	removeEventHandler( "onClientRender", root, Framework.render );
	removeEventHandler( "onClientClick", root, Framework.click );
	addEventHandler( "onClientRender", root, Framework.render );
	addEventHandler( "onClientClick", root, Framework.click );

	triggerServerEvent( "onUIGenerated", localPlayer, localPlayer );

	HUD.createNotification( "VERSÃO BETA", 4 );

	setTimer( function( )

		HUD.createNotification( "VERSÃO BETA", 4 );

	end, 120000, 0 );

end

function UI.setHudVisible( bool )

	HUD.setVisible( bool );

	for _, ui_table in ipairs( { Inventory.UI.hotbar } ) do

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