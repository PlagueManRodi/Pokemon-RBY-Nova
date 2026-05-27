TrainerAIPointers:
	table_width 3, TrainerAIPointers
	; one entry per trainer class
	; first byte, number of times (per Pokémon) it can occur
	; next two bytes, pointer to AI subroutine for trainer class
	; subroutines are defined in engine/battle/trainer_ai.asm
	dbw 3, SwitchAI 		; YOUNGSTER
	dbw 3, SwitchAI 		; BUG_CATCHER
	dbw 3, SwitchAI 		; LASS
	dbw 3, SwitchAI 		; SAILOR
	dbw 3, SwitchAI 		; CAMPER
	dbw 3, SwitchAI 		; PICNICKER
	dbw 3, SwitchAI 		; POKEMANIAC
	dbw 3, SwitchAI 		; SUPER_NERD
	dbw 3, SwitchAI 		; HIKER
	dbw 3, SwitchAI 		; BIKER
	dbw 3, SwitchAI 		; BURGLAR
	dbw 3, SwitchAI 		; ENGINEER
	dbw 3, SwitchAI 		; KAREN
	dbw 3, SwitchAI 		; FISHER
	dbw 3, SwitchAI 		; SWIMMER
	dbw 3, SwitchAI 		; CUE_BALL
	dbw 3, SwitchAI 		; GAMBLER
	dbw 3, SwitchAI 		; BEAUTY
	dbw 3, SwitchAI 		; PSYCHIC_TR
	dbw 3, SwitchAI 		; ROCKER
	dbw 3, SwitchAI 		; JUGGLER
	dbw 3, SwitchAI 		; TAMER
	dbw 3, SwitchAI 		; BIRD_KEEPER
	dbw 3, SwitchAI 		; BLACKBELT
	dbw 3, SwitchAI 		; RIVAL1
	dbw 3, SwitchAI 		; PROF_OAK
	dbw 3, SwitchAI 		; CHIEF
	dbw 3, SwitchAI 		; SCIENTIST
	dbw 3, SwitchAI 		; GIOVANNI
	dbw 3, SwitchAI 		; ROCKET
	dbw 3, SwitchAI 		; COOLTRAINER_M
	dbw 3, SwitchAI 		; COOLTRAINER_F
	dbw 3, SwitchAI 		; BRUNO
	dbw 3, SwitchAI 		; BROCK
	dbw 3, SwitchAI 		; MISTY
	dbw 3, SwitchAI 		; LT_SURGE
	dbw 3, SwitchAI 		; ERIKA
	dbw 3, SwitchAI 		; KOGA
	dbw 3, SwitchAI 		; BLAINE
	dbw 3, SwitchAI 		; SABRINA
	dbw 3, SwitchAI 		; GENTLEMAN
	dbw 3, SwitchAI 		; RIVAL2
	dbw 3, SwitchAI 		; RIVAL3
	dbw 3, SwitchAI 		; LORELEI
	dbw 3, SwitchAI 		; CHANNELER
	dbw 3, SwitchAI 		; AGATHA
	dbw 3, SwitchAI 		; LANCE
	assert_table_length NUM_TRAINERS
