	db DEX_MUK ; pokedex id

	db 105, 105,  75,  50, 100
	;   hp  atk  def  spd  spc

	db POISON, DARK ; type
	db 75 ; catch rate
	db 175 ; base exp

	INCBIN "gfx/pokemon/front/muk.pic", 0, 1 ; sprite dimensions
	dw MukPicFront, MukPicBack

	db POISON_GAS, POUND, HARDEN, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    HYPER_BEAM,   MEGA_DRAIN,   \
	     DOUBLE_TEAM,  METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SWIFT,        \
		 REST,         EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   SLUDGE_BOMB,  \
		 SHADOW_BALL,  ACID_STREAM,  STRENGTH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    HYPER_BEAM,   MEGA_DRAIN,   \
	     DOUBLE_TEAM,  METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SWIFT,        \
		 REST,         EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
ENDC		 
	; end

	db BANK(MukPicFront)
	assert BANK(MukPicFront) == BANK(MukPicBack)
