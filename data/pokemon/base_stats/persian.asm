	db DEX_PERSIAN ; pokedex id

	db  65,  60,  60, 115,  70
	;   hp  atk  def  spd  spc

	db DARK, DARK ; type
	db 90 ; catch rate
	db 154 ; base exp

	INCBIN "gfx/pokemon/front/persian.pic", 0, 1 ; sprite dimensions
	dw PersianPicFront, PersianPicBack

	db SCRATCH, GROWL, TAIL_WHIP, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     PAY_DAY,      THUNDERBOLT,  THUNDER,      DOUBLE_TEAM,  SWIFT,        \
		 DREAM_EATER,  REST,         SUBSTITUTE,   SHADOW_BALL,  CUT,          \
		 FLASH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     PAY_DAY,      THUNDERBOLT,  THUNDER,      DOUBLE_TEAM,  SWIFT,        \
		 DREAM_EATER,  REST,         SUBSTITUTE,   CUT,          FLASH
ENDC
	; end

	db BANK(PersianPicFront)
	assert BANK(PersianPicFront) == BANK(PersianPicBack)
