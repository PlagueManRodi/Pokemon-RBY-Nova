	db DEX_SIRFETCHD ; pokedex id

	db  62, 135,  95,  65,  68
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 177 ; base exp

	INCBIN "gfx/pokemon/front/sirfetchd.pic", 0, 1 ; sprite dimensions
	dw SirfetchdPicFront, SirfetchdPicBack

	db PECK, SAND_ATTACK, LEER, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, BODY_SLAM,    DOUBLE_EDGE,  COUNTER,      DOUBLE_TEAM,  \
	     SKY_ATTACK,   REST,         SUBSTITUTE,   CUT
	; end

	db BANK(SirfetchdPicFront)
	assert BANK(SirfetchdPicFront) == BANK(SirfetchdPicBack)
