Database = { };

Database.user = "root";
Database.pass = "";
Database.database = "mta_rust";
Database.host = "localhost";

function Database.setup( )

	Database.connection = Connection( "mysql", "dbname=" .. Database.database .. ";host=" .. Database.host, Database.user, Database.pass );

	if ( not Database.connection ) then

		print( "Falha ao conectar com o banco de dados!" );
		cancelEvent( true );

	end

end

function query( ... )

	local query_ = Database.connection:query( ... );
	local poll, num_rows = query_:poll( -1 );

	if ( poll ) then

		return poll, num_rows;

	end

	return print( "QUERY: " .. type( poll ) );

end

function exec( ... )

	local exec_ = Database.connection:exec( ... );

	if ( exec_ ) then

		return exec_;

	end

	return print( "EXECUTION: " .. type( exec_ ) );

end