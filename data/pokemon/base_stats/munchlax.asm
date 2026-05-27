	db DEX_MUNCHLAX ; pokedex id

	db 135,  85,  40,   5,  40
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 50 ; catch rate
	db 78 ; base exp

	INCBIN "gfx/pokemon/front/munchlax.pic", 0, 1 ; sprite dimensions
	dw MunchlaxPicFront, MunchlaxPicBack

	db TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   WHIRLWIND,    MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     COUNTER,      \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      EARTHQUAKE,   PSYCHIC_M,    \
	     DOUBLE_TEAM,  METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         \
		 ROCK_SLIDE,   SUBSTITUTE,   SHADOW_BALL,  SURF,         STRENGTH
ELSE
	tmhm MEGA_PUNCH,   WHIRLWIND,    MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     COUNTER,      \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      EARTHQUAKE,   PSYCHIC_M,    \
	     DOUBLE_TEAM,  METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         \
		 ROCK_SLIDE,   SUBSTITUTE,   SURF,         STRENGTH
ENDC
	; end

	db BANK(MunchlaxPicFront)
	assert BANK(MunchlaxPicFront) == BANK(MunchlaxPicBack)
