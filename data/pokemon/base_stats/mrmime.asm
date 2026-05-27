	db DEX_MR_MIME ; pokedex id

	db  50,  65,  65, 100,  90
	;   hp  atk  def  spd  spc

	db ICE, PSYCHIC_TYPE ; type
	db 45 ; catch rate
	db 161 ; base exp

	INCBIN "gfx/pokemon/front/mr.mime.pic", 0, 1 ; sprite dimensions
	dw MrMimePicFront, MrMimePicBack

	db CONFUSION, POUND, BARRIER, NO_MOVE ; level 1 learnset
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

	db BANK(MrMimePicFront)
	assert BANK(MrMimePicFront) == BANK(MrMimePicBack)
