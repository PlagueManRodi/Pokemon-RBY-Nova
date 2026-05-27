MtMoonB5F_Object:
	db $3 ; border block

	def_warp_events
	warp_event 15, 15, MT_MOON_B4F, 2

	def_bg_events

	def_object_events
	object_event  1,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 1 ; person
	object_event 13,  1, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	object_event 12,  6, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person
	object_event  4, 10, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 4 ; person
	object_event  5, 10, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 5 ; person
	object_event 11, 10, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 6 ; person
	object_event  4, 13, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 7 ; person
	object_event  5, 15, SPRITE_BOULDER, STAY, NONE, 8 ; person
	object_event  7, 12, SPRITE_BOULDER, STAY, NONE, 9 ; person
	object_event 13, 10, SPRITE_BOULDER, STAY, NONE, 10 ; person
	object_event 15,  1, SPRITE_BOULDER, STAY, NONE, 11 ; person
	object_event  8,  2, SPRITE_FAIRY, STAY, DOWN, 12, SCREAMTAIL, 100
	object_event  6,  4, SPRITE_POKE_BALL, STAY, NONE, 13
	object_event  0, 15, SPRITE_POKE_BALL, STAY, NONE, 14, BIG_NUGGET
	object_event  4,  2, SPRITE_POKE_BALL, STAY, NONE, 15, PP_UP

	def_warps_to MT_MOON_B5F
