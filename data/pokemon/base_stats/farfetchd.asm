	db DEX_FARFETCHD ; pokedex id

	db  52,  95,  55,  55,  58
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 132 ; base exp

	INCBIN "gfx/pokemon/front/farfetchd.pic", 0, 1 ; sprite dimensions
	dw FarfetchdPicFront, FarfetchdPicBack

	db PECK, SAND_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, BODY_SLAM,    DOUBLE_EDGE,  COUNTER,      DOUBLE_TEAM,  \
	     SKY_ATTACK,   REST,         SUBSTITUTE,   CUT
	; end

	db BANK(FarfetchdPicFront)
	assert BANK(FarfetchdPicFront) == BANK(FarfetchdPicBack)
