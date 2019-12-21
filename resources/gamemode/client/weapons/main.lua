Weapons = { };

function Weapons.setup( )

	addEventHandler( "onClientPlayerWeaponFire", localPlayer, Weapons.onFire );

end

function Weapons.onFire( )

	local weapon_data = localPlayer:getData( "character > weapon" );
	if ( weapon_data ) then

		if ( Inventory.items[ weapon_data ] ) then

			if ( Inventory.items[ weapon_data ].ammo - 1 >= 0 ) then

				triggerServerEvent( "inventory > update_ammo", localPlayer, localPlayer, weapon_data, Inventory.items[ weapon_data ].ammo - 1 );

				if ( Inventory.items[ weapon_data ].ammo - 1 == 0 ) then

					toggleControl( "fire", false );
					toggleControl( "aim_weapon", false );
					triggerServerEvent( "inventory > reload_weapon", localPlayer, localPlayer );

				end

				triggerServerEvent( "inventory > update_life", localPlayer, localPlayer, weapon_data, Inventory.items[ weapon_data ].life - 0.05 );

			end

		end

	end

end