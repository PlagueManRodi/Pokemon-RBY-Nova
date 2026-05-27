	db DEX_ZAPDOS ; pokedex id

	db  90, 125,  90, 100,  85
	;   hp  atk  def  spd  spc

	db FIGHTING, FLYING ; type
	db 3 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/zapdos.pic", 0, 1 ; sprite dimensions
	dw ZapdosPicFront, ZapdosPicBack

	db PECK, FOCUS_ENERGY, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_KICK,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   COUNTER,      \
	     DOUBLE_TEAM,  SWIFT,        REST,         SUBSTITUTE,   FLY
	; end

	db BANK(ZapdosPicFront)
	assert BANK(ZapdosPicFront) == BANK(ZapdosPicBack)
