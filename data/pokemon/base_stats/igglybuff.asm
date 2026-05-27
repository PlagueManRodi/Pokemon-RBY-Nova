	db DEX_IGGLYBUFF ; pokedex id

	db  90,  30,  15,  15,  20
	;   hp  atk  def  spd  spc

	db NORMAL, FAIRY ; type
	db 170 ; catch rate
	db 42 ; base exp

	INCBIN "gfx/pokemon/front/igglybuff.pic", 0, 1 ; sprite dimensions
	dw IgglybuffPicFront, IgglybuffPicBack

	db SING, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SOLARBEAM,    PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      \
	     FIRE_BLAST,   DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   \
		 SHADOW_BALL,  FLASH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SOLARBEAM,    PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      \
	     FIRE_BLAST,   DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   \
		 FLASH
ENDC
	; end

	db BANK(IgglybuffPicFront)
	assert BANK(IgglybuffPicFront) == BANK(IgglybuffPicBack)
