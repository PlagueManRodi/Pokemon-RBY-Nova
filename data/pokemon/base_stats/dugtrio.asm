	db DEX_DUGTRIO ; pokedex id

	db  35, 100,  60, 110,  70
	;   hp  atk  def  spd  spc

	db GROUND, STEEL ; type
	db 50 ; catch rate
	db 149 ; base exp

	INCBIN "gfx/pokemon/front/dugtrio.pic", 0, 1 ; sprite dimensions
	dw DugtrioPicFront, DugtrioPicBack

	db SCRATCH, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    HYPER_BEAM,   DOUBLE_EDGE,  \
	     EARTHQUAKE,   FISSURE,      DIG,          DOUBLE_TEAM,  REST,         \
		 ROCK_SLIDE,   TRI_ATTACK,   SUBSTITUTE,   SLUDGE_BOMB,  FLASH
ELSE
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    HYPER_BEAM,   DOUBLE_EDGE,  \
	     EARTHQUAKE,   FISSURE,      DIG,          DOUBLE_TEAM,  REST,         \
		 ROCK_SLIDE,   TRI_ATTACK,   SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(DugtrioPicFront)
	assert BANK(DugtrioPicFront) == BANK(DugtrioPicBack)
