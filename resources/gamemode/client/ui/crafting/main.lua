Crafting = { };

Crafting.UI = {

	buttons		= { },
	rectangles 	= { },
	images 		= { },
	progressbar = { },
	labels 		= { },
	gridlist 	= { }

};

function Crafting.setup( )

	Crafting.UI.background = Images:create( 0, 0, screen[ 1 ], screen[ 2 ], "assets/images/background.png" );
	Crafting.UI.background:setColor( { 255, 255, 255, 240 } );

	Crafting.UI.buttons[ 1 ] = Buttons:create( screen[ 1 ] / 2 - 200 / 2, 0, 200, 50, "INVENTORY" );

	addEventHandler( "onClientUIClick", Crafting.UI.buttons[ 1 ].source,
		function( )
			
			Crafting.setVisible( false );
			Inventory.setVisible( true );

		end
	);

	Crafting.setVisible( false );

end

function Crafting.setVisible( bool )

	HUD.setVisible( not bool );
	Crafting.UI.background:setVisible( bool );

	for _, ui_table in ipairs( { Crafting.UI.buttons, Crafting.UI.rectangles, Crafting.UI.images, Crafting.UI.progressbar, Crafting.UI.labels, Crafting.UI.gridlist } ) do

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