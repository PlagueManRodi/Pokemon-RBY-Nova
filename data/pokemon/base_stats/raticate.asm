	db DEX_RATICATE ; pokedex id

	db  75,  71,  70,  77,  40
	;   hp  atk  def  spd  spc

	db DARK, NORMAL ; type
	db 127 ; catch rate
	db 145 ; base exp

	INCBIN "gfx/pokemon/front/raticate.pic", 0, 1 ; sprite dimensions
	dw RaticatePicFront, RaticatePicBack

	db TACKLE, TAIL_WHIP, QUICK_ATTACK, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        DOUBLE_EDGE,  ICE_BEAM,    BLIZZARD,     \
	     HYPER_BEAM,   COUNTER,      DOUBLE_TEAM,  REST,        SUBSTITUTE,   \
		 SLUDGE_BOMB,  SHADOW_BALL,  ACID_STREAM,  CUT,          STRENGTH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        DOUBLE_EDGE,  ICE_BEAM,    BLIZZARD,     \
	     HYPER_BEAM,   COUNTER,      DOUBLE_TEAM,  REST,        SUBSTITUTE,   \
		 CUT,          STRENGTH
ENDC
	; end

	db BANK(RaticatePicFront)
	assert BANK(RaticatePicFront) == BANK(RaticatePicBack)
