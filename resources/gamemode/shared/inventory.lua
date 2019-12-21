INVENTORY_SLOTS = { INVENTORY = { r = 5, c = 6 }, CLOTHES = 6, SIZE = 45 };

--[[

	-- ITEM TABLE --

	name 			= string,
	description 	= string,
	stackable 		= boolean,
	weapon 			= boolean,
	ammo_id 		= boolean,
	food 			= boolean,
	hunger 			= int,
	thrist 			= int,
	wear	 		= boolean,
	clothes 		= boolean,
	preview_object 	= { model = int, pos = { float, float, float }, r = { float, float, float }, bone = int },
	show_ammo 		= boolean,
	max_ammo 		= int,
	mta_id 			= int

]]--

ITEMS = {

	[ 1 ] = {

		name 		= "Apple",
		description = "Food",
		stackable 	= true,
		food 		= true,
		hunger 		= 3,
		thirst 		= 2

	},

	[ 2 ] = {

		name 		= "Construction Plan",
		description = "Construction",
		stackable 	= true

	},

	[ 3 ] = {

		name 			= "AK-47",
		description 	= "Weapon",
		weapon 			= true,
		ammo_id 		= 4,
		wear	 		= true,
		preview_object 	= { model = 355, pos = { -0.2, -0.15, 0 }, r = { 0, 0, 0 }, bone = 3 },
		show_ammo 		= true,
		max_ammo 		= 30,
		mta_id 			= 30

	},

	[ 4 ] = {

		name 		= "5.56 Ammo",
		description = "Ammo",
		stackable 	= true

	},

	[ 5 ] = {

		name 		= "Blue Shirt",
		description = "Roupa",
		clothes 	= { 4 }

	},

	[ 6 ] = {

		name 		= "Green Shirt",
		description = "Clothe",
		clothes 	= { 4 }

	},

	[ 7 ] = {

		name 		= "Boot",
		description = "Clothe",
		clothes 	= { 6 }

	},

	[ 8 ] = {

		name 		= "Balaclava",
		description = "Clothe",
		clothes 	= { 2 }

	},

	[ 9 ] = {

		name 		= "Armor",
		description = "Protection",
		wear 		= true,
		clothes 	= { 3 }

	},

	[ 10 ] = {

		name 		= "Jeans Legs",
		description = "Clothe",
		clothes 	= { 5 }

	},

	[ 11 ] = {

		name 		= "Helmet",
		description = "Protection",
		wear 		= true,
		clothes 	= { 1 }

	},

	[ 12 ] = {

		name 			= "Pistol",
		description 	= "Weapon",
		weapon 			= true,
		ammo_id 		= 13,
		wear	 		= true,
		preview_object 	= { model = 348, pos = { 0, 0.2, 0.1 }, r = { 235, 90, 0 }, bone = 4 },
		show_ammo 		= true,
		max_ammo 		= 7,
		mta_id 			= 24

	},

	[ 13 ] = {

		name 		= "Pistol Ammo",
		description = "Ammo",
		stackable 	= true

	},

	[ 14 ] = {

		name 		= "Hammer",
		description = "Up/remove constructions",
		mta_id 		= 11,
		stackable 	= true

	},

	[ 15 ] = {

		name 		= "Pickaxe",
		description = "Pickaxe",
		wear 		= true,
		mta_id 		= 10

	},

	[ 16 ] = {

		name 		= "Axe",
		description = "Axe",
		wear 		= true,
		mta_id 		= 12

	},

	[ 17 ] = {

		name 		= "Wood",
		description = "Wood",
		stackable 	= true

	},

	[ 18 ] = {

		name 		= "Rock",
		description = "Rock",
		stackable 	= true

	},

	[ 19 ] = {

		name 		= "Scrap",
		description = "Scrap",
		stackable 	= true

	},

};