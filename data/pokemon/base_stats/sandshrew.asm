	db DEX_SANDSHREW ; pokedex id

	db  50,  75,  90,  40,  35
	;   hp  atk  def  spd  spc

	db ICE, STEEL ; type
	db 255 ; catch rate
	db 60 ; base exp

	INCBIN "gfx/pokemon/front/sandshrew.pic", 0, 1 ; sprite dimensions
	dw SandshrewPicFront, SandshrewPicBack

	db SCRATCH, DEFENSE_CURL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BLIZZARD,     COUNTER,      SEISMIC_TOSS, EARTHQUAKE,   DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         ROCK_SLIDE,   SUBSTITUTE,   \
		 X_SCISSOR,    CUT,          STRENGTH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BLIZZARD,     COUNTER,      SEISMIC_TOSS, EARTHQUAKE,   DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         ROCK_SLIDE,   SUBSTITUTE,   \
		 CUT,          STRENGTH
ENDC
	; end

	db BANK(SandshrewPicFront)
	assert BANK(SandshrewPicFront) == BANK(SandshrewPicBack)
