Route1_Object:
	db $b ; border block

	def_warp_events

	def_bg_events
	bg_event  9, 27, 4 ; Route1Text4

	def_object_events
	object_event 17, 31, SPRITE_POKE_BALL, STAY, NONE, 1, STARDUST
	object_event  5, 24, SPRITE_YOUNGSTER, WALK, UP_DOWN, 2 ; person
	object_event 15, 13, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, 3 ; person
	
	def_warps_to ROUTE_1

	; unused
	warp_to 2, 7, 4
