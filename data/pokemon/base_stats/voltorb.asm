	db DEX_VOLTORB ; pokedex id

	db  40,  30,  50, 100,  55
	;   hp  atk  def  spd  spc

	db ELECTRIC, GRASS ; type
	db 190 ; catch rate
	db 66 ; base exp

	INCBIN "gfx/pokemon/front/voltorb.pic", 0, 1 ; sprite dimensions
	dw VoltorbPicFront, VoltorbPicBack

	db TACKLE, THUNDERSHOCK, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TAKE_DOWN,    SOLARBEAM,    THUNDERBOLT,  THUNDER,      DOUBLE_TEAM,  \
	     REFLECT,      SELFDESTRUCT, SWIFT,        REST,         THUNDER_WAVE, \
	     EXPLOSION,    SUBSTITUTE,   FLASH
	; end

	db BANK(VoltorbPicFront)
	assert BANK(VoltorbPicFront) == BANK(VoltorbPicBack)
