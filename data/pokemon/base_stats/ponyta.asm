	db DEX_PONYTA ; pokedex id

	db  50,  85,  55,  90,  65
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 190 ; catch rate
	db 82 ; base exp

	INCBIN "gfx/pokemon/front/ponyta.pic", 0, 1 ; sprite dimensions
	dw PonytaPicFront, PonytaPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  PSYCHIC_M,    \
	     DOUBLE_TEAM,  SWIFT,        REST,         SUBSTITUTE,   DAZZLE_GLEAM, \
		 STRENGTH,     FLASH
ELSE
	tmhm HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  PSYCHIC_M,    \
	     DOUBLE_TEAM,  SWIFT,        REST,         SUBSTITUTE,   STRENGTH,     \
		 FLASH
ENDC         
	; end

	db BANK(PonytaPicFront)
	assert BANK(PonytaPicFront) == BANK(PonytaPicBack)
