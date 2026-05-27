	db DEX_BELLOSSOM ; pokedex id

	db  75,  80,  95,  50,  90
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 221 ; base exp

	INCBIN "gfx/pokemon/front/bellossom.pic", 0, 1 ; sprite dimensions
	dw BellossomPicFront, BellossomPicBack

IF DEF(_MODERN)
	db STUN_SPORE, SLEEP_POWDER, MOONBLAST, LEAF_BLADE ; level 1 learnset modern
ELSE
	db STUN_SPORE, SLEEP_POWDER, GROWTH, RAZOR_LEAF ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     SLUDGE_BOMB,  DAZZLE_GLEAM, ACID_STREAM,  CUT,          FLASH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT,          FLASH
ENDC
	; end

	db BANK(BellossomPicFront)
	assert BANK(BellossomPicFront) == BANK(BellossomPicBack)
