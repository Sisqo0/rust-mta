addEventHandler( "onResourceStart", resourceRoot,
	function( )

		setMapName( "Los Santos" );
		setGameType( "RUST" );

		setServerConfigSetting( "minclientversion", "1.5.6", true );
		setServerConfigSetting( "server_logic_fps_limit", 0, true );
		setServerConfigSetting( "busy_sleep_time", 0, true );
		setServerConfigSetting( "idle_sleep_time", 0, true );
		setServerConfigSetting( "player_sync_interval", 200, true );
		setServerConfigSetting( "lightweight_sync_interval", 1500, true );
		setServerConfigSetting( "ped_sync_interval", 400, true );
		setServerConfigSetting( "unoccupied_vehicle_sync_interval", 1000, true );
		setServerConfigSetting( "camera_sync_interval", 500, true );
		setServerConfigSetting( "keysync_mouse_sync_interval", 100, true );
		setServerConfigSetting( "keysync_analog_sync_interval", 100, true );
		setServerConfigSetting( "bullet_sync", 0, true );
		setServerConfigSetting( "donkey_work_interval", 1000, true );
		setServerConfigSetting( "vehext_percent", 50, true );
		setServerConfigSetting( "fpslimit", 61, true );
		setServerConfigSetting( "bandwidth_reduction", "maximum", true );

		Loot.setup( );

		Database.setup( );
		Accounts.setup( );
		Inventory.setup( );
		Building.setup( );
		Wasted.setup( );

	end
);

addEvent( "onUIGenerated", true );
addEventHandler( "onUIGenerated", root,
	function( player )
		
		Inventory.load( player );

	end
);