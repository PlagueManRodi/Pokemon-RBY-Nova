	db DEX_GRAVELER ; pokedex id

	db  55,  95, 115,  35,  45
	;   hp  atk  def  spd  spc

	db ROCK, ELECTRIC ; type
	db 120 ; catch rate
	db 137 ; base exp

	INCBIN "gfx/pokemon/front/graveler.pic", 0, 1 ; sprite dimensions
	dw GravelerPicFront, GravelerPicBack

IF DEF(_MODERN)
	db TACKLE, DEFENSE_CURL, SPARK, NO_MOVE ; level 1 learnset modern
ELSE
	db TACKLE, DEFENSE_CURL, THUNDERPUNCH, NO_MOVE ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  COUNTER,      \
	     SEISMIC_TOSS, THUNDERBOLT,  THUNDER,      EARTHQUAKE,   DOUBLE_TEAM,  \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         EXPLOSION,    \
		 ROCK_SLIDE,   SUBSTITUTE,   STRENGTH,     FLASH	
	; end

	db BANK(GravelerPicFront)
	assert BANK(GravelerPicFront) == BANK(GravelerPicBack)
