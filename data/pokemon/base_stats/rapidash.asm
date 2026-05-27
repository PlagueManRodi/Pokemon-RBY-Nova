	db DEX_RAPIDASH ; pokedex id

	db  65, 100,  70, 105,  80
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FAIRY ; type
	db 60 ; catch rate
	db 175 ; base exp

	INCBIN "gfx/pokemon/front/rapidash.pic", 0, 1 ; sprite dimensions
	dw RapidashPicFront, RapidashPicBack

	db TACKLE, GROWL, TAIL_WHIP, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   PAY_DAY,      PSYCHIC_M,    DOUBLE_TEAM,  SWIFT,        \
		 REST,         SUBSTITUTE,   DAZZLE_GLEAM, STRENGTH,     FLASH
ELSE
	tmhm SWORDS_DANCE, HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   PAY_DAY,      PSYCHIC_M,    DOUBLE_TEAM,  SWIFT,        \
		 REST,         SUBSTITUTE,   STRENGTH,     FLASH
ENDC		 
	; end

	db BANK(RapidashPicFront)
	assert BANK(RapidashPicFront) == BANK(RapidashPicBack)
