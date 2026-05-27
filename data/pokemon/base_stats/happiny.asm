	db DEX_HAPPINY ; pokedex id

	db 100,   5,   5,  30,  65
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 130 ; catch rate
	db 110 ; base exp

	INCBIN "gfx/pokemon/front/happiny.pic", 0, 1 ; sprite dimensions
	dw HappinyPicFront, HappinyPicBack

	db POUND, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        TAKE_DOWN,    COUNTER,      SOLARBEAM,    PSYCHIC_M,    \
	     DOUBLE_TEAM,  METRONOME,    FIRE_BLAST,   DREAM_EATER,  REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   SHADOW_BALL,  FLASH
ELSE
	tmhm TOXIC,        TAKE_DOWN,    COUNTER,      SOLARBEAM,    PSYCHIC_M,    \
	     DOUBLE_TEAM,  METRONOME,    FIRE_BLAST,   DREAM_EATER,  REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(HappinyPicFront)
	assert BANK(HappinyPicFront) == BANK(HappinyPicBack)
