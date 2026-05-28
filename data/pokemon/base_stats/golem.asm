	db DEX_GOLEM ; pokedex id

	db  80, 120, 130,  45,  65
	;   hp  atk  def  spd  spc

	db ROCK, ELECTRIC ; type
	db 45 ; catch rate
	db 223 ; base exp

	INCBIN "gfx/pokemon/front/golem.pic", 0, 1 ; sprite dimensions
	dw GolemPicFront, GolemPicBack

IF DEF(_MODERN)
	db TACKLE, DEFENSE_CURL, SPARK, ROCK_THROW ; level 1 learnset modern
ELSE
	db TACKLE, DEFENSE_CURL, THUNDERPUNCH, ROCK_THROW ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     COUNTER,      SEISMIC_TOSS, THUNDERBOLT,  THUNDER,      EARTHQUAKE,   \
	     DOUBLE_TEAM,  METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         \
		 EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   STRENGTH,     FLASH	     
	; end

	db BANK(GolemPicFront)
	assert BANK(GolemPicFront) == BANK(GolemPicBack)
