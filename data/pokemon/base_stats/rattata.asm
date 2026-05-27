	db DEX_RATTATA ; pokedex id

	db  30,  56,  35,  72,  25
	;   hp  atk  def  spd  spc

	db DARK, NORMAL ; type
	db 255 ; catch rate
	db 51 ; base exp

	INCBIN "gfx/pokemon/front/rattata.pic", 0, 1 ; sprite dimensions
	dw RattataPicFront, RattataPicBack

	db TACKLE, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        DOUBLE_EDGE,  ICE_BEAM,    BLIZZARD,     COUNTER,      \  
	     DOUBLE_TEAM,  REST,         SUBSTITUTE,  SLUDGE_BOMB,  SHADOW_BALL,  \
		 ACID_STREAM,  CUT
ELSE
	tmhm TOXIC,        DOUBLE_EDGE,  ICE_BEAM,    BLIZZARD,     COUNTER,      \  
	     DOUBLE_TEAM,  REST,         SUBSTITUTE,  CUT
ENDC
	; end

	db BANK(RattataPicFront)
	assert BANK(RattataPicFront) == BANK(RattataPicBack)
	