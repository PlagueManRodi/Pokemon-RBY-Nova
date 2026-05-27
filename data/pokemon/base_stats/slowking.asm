	db DEX_SLOWKING ; pokedex id

	db  95,  65,  80,  30, 110
	;   hp  atk  def  spd  spc

	db POISON, PSYCHIC_TYPE ; type
	db 70 ; catch rate
	db 172 ; base exp

	INCBIN "gfx/pokemon/front/slowking.pic", 0, 1 ; sprite dimensions
	dw SlowkingPicFront, SlowkingPicBack

	db WITHDRAW, TACKLE, GROWL, ACID ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   PAY_DAY,      EARTHQUAKE,   \
	     DIG,          PSYCHIC_M,    DOUBLE_TEAM,  FIRE_BLAST,   SWIFT,        \
	     REST,         THUNDER_WAVE, TRI_ATTACK,   SUBSTITUTE,   SLUDGE_BOMB,  \
		 SHADOW_BALL,  ACID_STREAM,  SURF,         STRENGTH,     FLASH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   PAY_DAY,      EARTHQUAKE,   \
	     DIG,          PSYCHIC_M,    DOUBLE_TEAM,  FIRE_BLAST,   SWIFT,        \
	     REST,         THUNDER_WAVE, TRI_ATTACK,   SUBSTITUTE,   SURF,         \
		 STRENGTH,     FLASH
ENDC
	; end

	db BANK(SlowkingPicFront)
	assert BANK(SlowkingPicFront) == BANK(SlowkingPicBack)
