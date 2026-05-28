	db DEX_SYLVEON ; pokedex id

	db  95,  65,  65,  60, 130
	;   hp  atk  def  spd  spc

	db FAIRY, FAIRY ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/sylveon.pic", 0, 1 ; sprite dimensions
	dw SylveonPicFront, SylveonPicBack

IF DEF(_MODERN)
	db TACKLE, TAIL_WHIP, FAIRY_WIND, NO_MOVE ; level 1 learnset modern
ELSE
	db TACKLE, TAIL_WHIP, SWIFT, NO_MOVE ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   SHADOW_BALL,  \
		 DAZZLE_GLEAM, CUT,          FLASH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   CUT,          \
		 FLASH
ENDC
	; end

	db BANK(SylveonPicFront)
	assert BANK(SylveonPicFront) == BANK(SylveonPicBack)
