CeladonNovaHouse_Object:
	db $f ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP,  9
	warp_event  3,  7, LAST_MAP,  9

	def_bg_events

	def_object_events
	object_event  2,  2, SPRITE_HIKER, STAY, DOWN, 1 ; person
	object_event  4,  2, SPRITE_GIRL, STAY, DOWN, 2 ; person
	object_event  7,  3, SPRITE_COOLTRAINER_F, STAY, LEFT, 3 ; person
	object_event  7,  5, SPRITE_GIRL, STAY, LEFT, 4 ; person
	object_event  0,  3, SPRITE_GENTLEMAN, STAY, RIGHT, 5, OPP_GENTLEMAN, 6 ; person
	object_event  0,  5, SPRITE_BEAUTY, STAY, RIGHT, 6 ; person
	object_event  5,  2, SPRITE_COOLTRAINER_M, STAY, DOWN, 7 ; person
	
	def_warps_to CELADON_NOVA_HOUSE
