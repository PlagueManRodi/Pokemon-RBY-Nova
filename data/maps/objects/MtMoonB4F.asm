MtMoonB4F_Object:
	db $3 ; border block

	def_warp_events
	warp_event  1, 15, MT_MOON_B3F, 2
	warp_event 15, 15, MT_MOON_B5F, 1

	def_bg_events

	def_object_events
	object_event  2,  2, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 1 ; person
	object_event  5,  4, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	object_event  6,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person
	object_event  9,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 4 ; person
	object_event  9,  3, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 5 ; person
	object_event 12,  4, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 6 ; person
	object_event  3,  7, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 7 ; person
	object_event  1, 11, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 8 ; person
	object_event  6, 10, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 9 ; person
	object_event  7,  5, SPRITE_BOULDER, STAY, NONE, 10 ; person
	object_event  9,  5, SPRITE_POKE_BALL, STAY, NONE, 11, MASTER_BALL
	object_event  0,  8, SPRITE_POKE_BALL, STAY, NONE, 12, CARBOS
	object_event 15, 10, SPRITE_POKE_BALL, STAY, NONE, 13, HP_UP

	def_warps_to MT_MOON_B4F
