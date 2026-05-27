	db DEX_MOLTRES ; pokedex id

	db  90,  85,  90,  90, 100
	;   hp  atk  def  spd  spc

	db DARK, FLYING ; type
	db 3 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/moltres.pic", 0, 1 ; sprite dimensions
	dw MoltresPicFront, MoltresPicBack

	db WING_ATTACK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TAKE_DOWN,    HYPER_BEAM,   DOUBLE_TEAM,  SWIFT,        SKY_ATTACK,   \
	     REST,         SUBSTITUTE,   SHADOW_BALL,  FLY
ELSE
	tmhm TAKE_DOWN,    HYPER_BEAM,   DOUBLE_TEAM,  SWIFT,        SKY_ATTACK,   \
	     REST,         SUBSTITUTE,   FLY
ENDC
	; end

	db BANK(MoltresPicFront)
	assert BANK(MoltresPicFront) == BANK(MoltresPicBack)
