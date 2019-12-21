Models = { };

function Models.replace( )

	for _, v in pairs( CUSTOM_MODELS ) do

		if ( fileExists( v.txd ) ) then

			local txd = EngineTXD( v.txd );
			txd:import( v.model );

		end

		if ( fileExists( v.dff ) ) then

			local dff = EngineDFF( v.dff );
			dff:replace( v.model );

		end

		if ( fileExists( v.col ) ) then

			local col = EngineCOL( v.col );
			col:replace( v.model );

		end

	end

end