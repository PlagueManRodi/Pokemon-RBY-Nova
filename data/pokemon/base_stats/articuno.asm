	db DEX_ARTICUNO ; pokedex id

	db  90,  85,  85,  95, 100
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FLYING ; type
	db 3 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/articuno.pic", 0, 1 ; sprite dimensions
	dw ArticunoPicFront, ArticunoPicBack

	db GUST, HYPNOSIS, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TAKE_DOWN,    HYPER_BEAM,   PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      \
	     SWIFT,        REST,         SUBSTITUTE,   SHADOW_BALL,  FLY
ELSE
	tmhm TAKE_DOWN,    HYPER_BEAM,   PSYCHIC_M,    DOUBLE_TEAM,  REFLECT,      \
	     SWIFT,        REST,         SUBSTITUTE,   FLY
ENDC
	; end

	db BANK(ArticunoPicFront)
	assert BANK(ArticunoPicFront) == BANK(ArticunoPicBack)
