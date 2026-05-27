	db DEX_MAGMORTAR ; pokedex id

	db  75,  95,  67,  83,  95
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 30 ; catch rate
	db 243 ; base exp

	INCBIN "gfx/pokemon/front/magmortar.pic", 0, 1 ; sprite dimensions
	dw MagmortarPicFront, MagmortarPicBack

	db SMOG, LEER, EMBER, SMOKESCREEN ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         SOLARBEAM,    THUNDERBOLT,  EARTHQUAKE,   PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    \
	     FIRE_BLAST,   SKULL_BASH,   REST,         PSYWAVE,      ROCK_SLIDE,   \
		 SUBSTITUTE,   ACID_STREAM,  STRENGTH
ELSE
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         SOLARBEAM,    THUNDERBOLT,  EARTHQUAKE,   PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    \
	     FIRE_BLAST,   SKULL_BASH,   REST,         PSYWAVE,      ROCK_SLIDE,   \
		 SUBSTITUTE,   STRENGTH
ENDC
	; end

	db BANK(MagmortarPicFront)
	assert BANK(MagmortarPicFront) == BANK(MagmortarPicBack)
