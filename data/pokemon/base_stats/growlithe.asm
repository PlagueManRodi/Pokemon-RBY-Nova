	db DEX_GROWLITHE ; pokedex id

	db  60,  70,  45,  55,  50
	;   hp  atk  def  spd  spc

	db FIRE, ROCK ; type
	db 190 ; catch rate
	db 70 ; base exp

	INCBIN "gfx/pokemon/front/growlithe.pic", 0, 1 ; sprite dimensions
	dw GrowlithePicFront, GrowlithePicBack

	db EMBER, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  DIG,          DOUBLE_TEAM,  \
	     FIRE_BLAST,   SWIFT,        REST,         ROCK_SLIDE,   SUBSTITUTE,   \
		 STRENGTH      
	; end

	db BANK(GrowlithePicFront)
	assert BANK(GrowlithePicFront) == BANK(GrowlithePicBack)
