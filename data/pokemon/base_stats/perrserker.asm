	db DEX_PERRSERKER ; pokedex id

	db  70, 110, 100,  50,  60
	;   hp  atk  def  spd  spc

	db STEEL, STEEL ; type
	db 90 ; catch rate
	db 154 ; base exp

	INCBIN "gfx/pokemon/front/perrserker.pic", 0, 1 ; sprite dimensions
	dw PerrserkerPicFront, PerrserkerPicBack

	db SCRATCH, GROWL, TAIL_WHIP, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
		 BUBBLEBEAM,   WATER_GUN,    HYPER_BEAM,   PAY_DAY,      RAGE,         \
		 THUNDERBOLT,  THUNDER,      DIG,          MIMIC,        DOUBLE_TEAM,  \
		 BIDE,         SWIFT,        SKULL_BASH,   DREAM_EATER,  REST,         \
		 SUBSTITUTE,   SHADOW_BALL,  CUT,          STRENGTH,     FLASH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
		 BUBBLEBEAM,   WATER_GUN,    HYPER_BEAM,   PAY_DAY,      RAGE,         \
		 THUNDERBOLT,  THUNDER,      DIG,          MIMIC,        DOUBLE_TEAM,  \
		 BIDE,         SWIFT,        SKULL_BASH,   DREAM_EATER,  REST,         \
		 SUBSTITUTE,   CUT,          STRENGTH,     FLASH
ENDC  
	; end

	db BANK(PerrserkerPicFront)
	assert BANK(PerrserkerPicFront) == BANK(PerrserkerPicBack)
