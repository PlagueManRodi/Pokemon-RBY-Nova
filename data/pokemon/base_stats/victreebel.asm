	db DEX_VICTREEBEL ; pokedex id

	db  80, 105,  65,  70, 100
	;   hp  atk  def  spd  spc

	db GRASS, POISON ; type
	db 45 ; catch rate
	db 191 ; base exp

	INCBIN "gfx/pokemon/front/victreebel.pic", 0, 1 ; sprite dimensions
	dw VictreebelPicFront, VictreebelPicBack

IF DEF(_MODERN)
	db SLEEP_POWDER, STUN_SPORE, SLUDGE_BOMB, LEAF_BLADE ; level 1 learnset modern
ELSE
	db SLEEP_POWDER, STUN_SPORE, ACID, RAZOR_LEAF ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     SLUDGE_BOMB,  ACID_STREAM,  CUT,          FLASH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT,          FLASH
ENDC
	; end

	db BANK(VictreebelPicFront)
	assert BANK(VictreebelPicFront) == BANK(VictreebelPicBack)
