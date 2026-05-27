	db DEX_SANDYSHOCK ; pokedex id

	db  85,  81,  97, 101, 111
	;   hp  atk  def  spd  spc

	db ELECTRIC, GROUND ; type
	db 30 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/sandyshock.pic", 0, 1 ; sprite dimensions
	dw SandyshockPicFront, SandyshockPicBack

	db THUNDER_WAVE, SUPERSONIC, THUNDERSHOCK, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm BODY_SLAM,    TAKE_DOWN,    HYPER_BEAM,   THUNDERBOLT,  THUNDER,      \
	     EARTHQUAKE,   REFLECT,      SWIFT,        REST,         THUNDER_WAVE, \
	     TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	db BANK(SandyshockPicFront)
	assert BANK(SandyshockPicFront) == BANK(SandyshockPicBack)
