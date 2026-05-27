	db DEX_SCREAMTAIL ; pokedex id

	db 115,  65,  99, 111,  85
	;   hp  atk  def  spd  spc

	db FAIRY, PSYCHIC_TYPE ; type
	db 50 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/screamtail.pic", 0, 1 ; sprite dimensions
	dw ScreamtailPicFront, ScreamtailPicBack

	db POUND, SING, DISABLE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   THUNDERBOLT,  THUNDER,      DIG,          PSYCHIC_M,    \
	     REFLECT,      METRONOME,    FIRE_BLAST,   REST,         THUNDER_WAVE, \
	     SUBSTITUTE,   DAZZLE_GLEAM, STRENGTH,     FLASH
ELSE
	tmhm BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   THUNDERBOLT,  THUNDER,      DIG,          PSYCHIC_M,    \
	     REFLECT,      METRONOME,    FIRE_BLAST,   REST,         THUNDER_WAVE, \
	     SUBSTITUTE,   STRENGTH,     FLASH
ENDC
	; end

	db BANK(ScreamtailPicFront)
	assert BANK(ScreamtailPicFront) == BANK(ScreamtailPicBack)
