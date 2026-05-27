	db DEX_GLACEON ; pokedex id

	db  65,  60, 110,  65, 130
	;   hp  atk  def  spd  spc

	db ICE, ICE ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/glaceon.pic", 0, 1 ; sprite dimensions
	dw GlaceonPicFront, GlaceonPicBack

IF DEF(_MODERN)
	db TACKLE, TAIL_WHIP, ICY_WIND, NO_MOVE ; level 1 learnset modern
ELSE
	db TACKLE, TAIL_WHIP, BARRIER, NO_MOVE ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        SKULL_BASH,   REST,         \
		 SUBSTITUTE,   SHADOW_BALL,  STRENGTH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        SKULL_BASH,   REST,         \
		 SUBSTITUTE,   STRENGTH
ENDC
	; end

	db BANK(GlaceonPicFront)
	assert BANK(GlaceonPicFront) == BANK(GlaceonPicBack)
