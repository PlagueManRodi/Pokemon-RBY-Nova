	db DEX_NINETALES ; pokedex id

	db  73,  67,  75, 109, 100
	;   hp  atk  def  spd  spc

	db ICE, FAIRY ; type
	db 75 ; catch rate
	db 177 ; base exp

	INCBIN "gfx/pokemon/front/ninetales.pic", 0, 1 ; sprite dimensions
	dw NinetalesPicFront, NinetalesPicBack

IF DEF(_MODERN)
	db CONFUSE_RAY, HYPNOSIS, AURORA_BEAM, DAZZLE_GLEAM ; level 1 learnset modern
ELSE
	db CONFUSE_RAY, HYPNOSIS, MIST, AURORA_BEAM ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   DOUBLE_TEAM,  SWIFT,        DREAM_EATER,  \
		 REST,         SUBSTITUTE,   DAZZLE_GLEAM
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   DOUBLE_TEAM,  SWIFT,        DREAM_EATER,  \
		 REST,         SUBSTITUTE
ENDC
	; end

	db BANK(NinetalesPicFront)
	assert BANK(NinetalesPicFront) == BANK(NinetalesPicBack)
