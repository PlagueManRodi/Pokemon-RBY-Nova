	db DEX_SANDSLASH ; pokedex id

	db  75, 100, 120,  65,  65
	;   hp  atk  def  spd  spc

	db ICE, STEEL ; type
	db 90 ; catch rate
	db 158 ; base exp

	INCBIN "gfx/pokemon/front/sandslash.pic", 0, 1 ; sprite dimensions
	dw SandslashPicFront, SandslashPicBack

IF DEF(_MODERN)
	db METAL_CLAW, ICICLE_CRASH, NIGHT_SLASH, SWORDS_DANCE ; level 1 learnset modern
ELSE
	db LEECH_LIFE, SLASH, AMNESIA, SWORDS_DANCE ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,  TAKE_DOWN,    DOUBLE_EDGE,  \  
	     BLIZZARD,     HYPER_BEAM,   COUNTER,    SEISMIC_TOSS, EARTHQUAKE,   \ 
		 DOUBLE_TEAM,  BIDE,         SWIFT,      REST,         ROCK_SLIDE,   \
		 SUBSTITUTE,   X_SCISSOR,    CUT,        STRENGTH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,  TAKE_DOWN,    DOUBLE_EDGE,  \  
	     BLIZZARD,     HYPER_BEAM,   COUNTER,    SEISMIC_TOSS, EARTHQUAKE,   \ 
		 DOUBLE_TEAM,  BIDE,         SWIFT,      REST,         ROCK_SLIDE,   \
		 SUBSTITUTE,   CUT,          STRENGTH
ENDC
	; end

	db BANK(SandslashPicFront)
	assert BANK(SandslashPicFront) == BANK(SandslashPicBack)
