	db DEX_SLOWPOKE ; pokedex id

	db  90,  65,  65,  15,  40
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 190 ; catch rate
	db 63 ; base exp

	INCBIN "gfx/pokemon/front/slowpoke.pic", 0, 1 ; sprite dimensions
	dw SlowpokePicFront, SlowpokePicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm BODY_SLAM,    TAKE_DOWN,    ICE_BEAM,     BLIZZARD,     PAY_DAY,      \
	     EARTHQUAKE,   DIG,          PSYCHIC_M,    DOUBLE_TEAM,  FIRE_BLAST,   \
	     SWIFT,        REST,         THUNDER_WAVE, TRI_ATTACK,   SUBSTITUTE,   \
	     SHADOW_BALL,  ACID_STREAM,  SURF,         STRENGTH,     FLASH
ELSE
	tmhm BODY_SLAM,    TAKE_DOWN,    ICE_BEAM,     BLIZZARD,     PAY_DAY,      \
	     EARTHQUAKE,   DIG,          PSYCHIC_M,    DOUBLE_TEAM,  FIRE_BLAST,   \
	     SWIFT,        REST,         THUNDER_WAVE, TRI_ATTACK,   SUBSTITUTE,   \
	     SURF,         STRENGTH,     FLASH
ENDC
	; end

	db BANK(SlowpokePicFront)
	assert BANK(SlowpokePicFront) == BANK(SlowpokePicBack)
