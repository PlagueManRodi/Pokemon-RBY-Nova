	db DEX_MR_RIME ; pokedex id

	db  80,  85,  75,  70, 110
	;   hp  atk  def  spd  spc

	db ICE, PSYCHIC_TYPE ; type
	db 45 ; catch rate
	db 182 ; base exp

	INCBIN "gfx/pokemon/front/mr.rime.pic", 0, 1 ; sprite dimensions
	dw MrRimePicFront, MrRimePicBack

	db CONFUSION, POUND, BARRIER, MEDITATE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   SOLARBEAM,    THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   SHADOW_BALL,  \
		 DAZZLE_GLEAM, FLASH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   SOLARBEAM,    THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      METRONOME,    \
	     DREAM_EATER,  REST,         THUNDER_WAVE, SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(MrRimePicFront)
	assert BANK(MrRimePicFront) == BANK(MrRimePicBack)
