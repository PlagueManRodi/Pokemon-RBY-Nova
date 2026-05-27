	db DEX_ARCANINE ; pokedex id

	db  90, 115,  80,  90,  80
	;   hp  atk  def  spd  spc

	db FIRE, ROCK ; type
	db 75 ; catch rate
	db 194 ; base exp

	INCBIN "gfx/pokemon/front/arcanine.pic", 0, 1 ; sprite dimensions
	dw ArcaninePicFront, ArcaninePicBack

IF DEF(_MODERN)
	db EMBER, CRUNCH, TAKE_DOWN, ROCK_SLIDE ; level 1 learnset modern
ELSE
	db EMBER, BITE, TAKE_DOWN, ROCK_SLIDE ; level 1 learnset
ENDC
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   SOLARBEAM,    \
	     DIG,          DOUBLE_TEAM,  FIRE_BLAST,   SWIFT,        REST,         \   
		 ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	db BANK(ArcaninePicFront)
	assert BANK(ArcaninePicFront) == BANK(ArcaninePicBack)
