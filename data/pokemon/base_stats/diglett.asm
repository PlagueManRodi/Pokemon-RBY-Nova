	db DEX_DIGLETT ; pokedex id

	db  10,  55,  30,  90,  45
	;   hp  atk  def  spd  spc

	db GROUND, STEEL ; type
	db 255 ; catch rate
	db 53 ; base exp

	INCBIN "gfx/pokemon/front/diglett.pic", 0, 1 ; sprite dimensions
	dw DiglettPicFront, DiglettPicBack

	db SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    EARTHQUAKE,   FISSURE,      \
	     DIG,          DOUBLE_TEAM,  REST,         ROCK_SLIDE,   SUBSTITUTE,   \
		 SLUDGE_BOMB,  FLASH 
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    EARTHQUAKE,   FISSURE,      \
	     DIG,          DOUBLE_TEAM,  REST,         ROCK_SLIDE,   SUBSTITUTE,   \
		 FLASH          
ENDC
	; end

	db BANK(DiglettPicFront)
	assert BANK(DiglettPicFront) == BANK(DiglettPicBack)
