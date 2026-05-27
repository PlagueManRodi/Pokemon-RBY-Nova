	db DEX_EXEGGUTOR ; pokedex id

	db  95, 105,  85,  45, 125
	;   hp  atk  def  spd  spc

	db GRASS, DRAGON ; type
	db 45 ; catch rate
	db 186 ; base exp

	INCBIN "gfx/pokemon/front/exeggutor.pic", 0, 1 ; sprite dimensions
	dw ExeggutorPicFront, ExeggutorPicBack

IF DEF(_MODERN)
	db BARRAGE, HYPNOSIS, EGG_BOMB, DRAGONHAMMER ; level 1 learnset modern
ELSE
	db BARRAGE, HYPNOSIS, CONFUSION, EGG_BOMB ; level 1 learnset
ENDC
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    EARTHQUAKE,   \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SELFDESTRUCT, EGG_BOMB,     DREAM_EATER,  REST,         \
		 PSYWAVE,      EXPLOSION,    SUBSTITUTE,   SLUDGE_BOMB,  STRENGTH,     \
		 FLASH
ELSE
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    EARTHQUAKE,   \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SELFDESTRUCT, EGG_BOMB,     DREAM_EATER,  REST,         \
		 PSYWAVE,      EXPLOSION,    SUBSTITUTE,   STRENGTH,     FLASH
ENDC
	; end

	db BANK(ExeggutorPicFront)
	assert BANK(ExeggutorPicFront) == BANK(ExeggutorPicBack)
