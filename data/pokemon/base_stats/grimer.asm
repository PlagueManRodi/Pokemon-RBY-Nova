	db DEX_GRIMER ; pokedex id

	db  80,  80,  50,  25,  40
	;   hp  atk  def  spd  spc

	db POISON, DARK ; type
	db 190 ; catch rate
	db 65 ; base exp

	INCBIN "gfx/pokemon/front/grimer.pic", 0, 1 ; sprite dimensions
	dw GrimerPicFront, GrimerPicBack

	db POISON_GAS, POUND, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    MEGA_DRAIN,   DOUBLE_TEAM,  \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SWIFT,        REST,         \
		 EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   SLUDGE_BOMB,  SHADOW_BALL,  \
		 ACID_STREAM,  STRENGTH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    MEGA_DRAIN,   DOUBLE_TEAM,  \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SWIFT,        REST,         \
		 EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
ENDC		 
	; end

	db BANK(GrimerPicFront)
	assert BANK(GrimerPicFront) == BANK(GrimerPicBack)
