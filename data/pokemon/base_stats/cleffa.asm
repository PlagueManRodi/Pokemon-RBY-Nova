	db DEX_CLEFFA ; pokedex id

	db  50,  25,  28,  15,  45
	;   hp  atk  def  spd  spc

	db FAIRY, FAIRY ; type
	db 150 ; catch rate
	db 44 ; base exp

	INCBIN "gfx/pokemon/front/cleffa.pic", 0, 1 ; sprite dimensions
	dw CleffaPicFront, CleffaPicBack

	db POUND, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    SOLARBEAM,    \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     FIRE_BLAST,   DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   \
		 SHADOW_BALL,   FLASH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    SOLARBEAM,    \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     FIRE_BLAST,   DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   \
		 FLASH
ENDC
	; end

	db BANK(CleffaPicFront)
	assert BANK(CleffaPicFront) == BANK(CleffaPicBack)
