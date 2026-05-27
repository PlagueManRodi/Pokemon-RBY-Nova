	db DEX_PORYGONZ ; pokedex id

	db  85,  80,  70,  90, 105
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 241 ; base exp

	INCBIN "gfx/pokemon/front/porygon-z.pic", 0, 1 ; sprite dimensions
	dw PorygonZPicFront, PorygonZPicBack

IF DEF(_MODERN)
	db TACKLE, SHARPEN, CONVERSION, SPARK ; level 1 learnset modern
ELSE
	db TACKLE, SHARPEN, CONVERSION, PSYBEAM ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         SOLARBEAM,    THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKULL_BASH,   DREAM_EATER,  REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   SHADOW_BALL,  \
		 FLASH
ELSE
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         SOLARBEAM,    THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKULL_BASH,   DREAM_EATER,  REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(PorygonZPicFront)
	assert BANK(PorygonZPicFront) == BANK(PorygonZPicBack)
