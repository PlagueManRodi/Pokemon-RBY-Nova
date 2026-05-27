	db DEX_SMOOCHUM ; pokedex id

	db  45,  30,  15,  65,  65
	;   hp  atk  def  spd  spc

	db ICE, PSYCHIC_TYPE ; type
	db 45 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/front/smoochum.pic", 0, 1 ; sprite dimensions
	dw SmoochumPicFront, SmoochumPicBack

	db POUND, LOVELY_KISS, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    ICE_BEAM,     \
	     BLIZZARD,     PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     DREAM_EATER,  REST,         SUBSTITUTE,   SHADOW_BALL,  FLASH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    ICE_BEAM,     \
	     BLIZZARD,     PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     DREAM_EATER,  REST,         SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(SmoochumPicFront)
	assert BANK(SmoochumPicFront) == BANK(SmoochumPicBack)
