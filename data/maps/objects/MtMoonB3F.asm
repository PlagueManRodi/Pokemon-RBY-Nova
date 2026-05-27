MtMoonB3F_Object:
	db $3 ; border block

	def_warp_events
	warp_event 15, 15, MT_MOON_B2F, 5
	warp_event  1, 15, MT_MOON_B4F, 1

	def_bg_events

	def_object_events
	object_event  1,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 1 ; person
	object_event 12,  2, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	object_event 14,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person
	object_event  8,  5, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 4 ; person
	object_event  7,  8, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 5 ; person
	object_event  9, 11, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 6 ; person
	object_event  3,  6, SPRITE_POKE_BALL, STAY, NONE, 7, PROTEIN
	object_event  7,  3, SPRITE_POKE_BALL, STAY, NONE, 8, IRON
	object_event 13,  6, SPRITE_POKE_BALL, STAY, NONE, 9, CALCIUM

	def_warps_to MT_MOON_B3F
