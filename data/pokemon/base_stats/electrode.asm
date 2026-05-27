	db DEX_ELECTRODE ; pokedex id

	db  60,  50,  70, 150,  80
	;   hp  atk  def  spd  spc

	db ELECTRIC, GRASS ; type
	db 60 ; catch rate
	db 172 ; base exp

	INCBIN "gfx/pokemon/front/electrode.pic", 0, 1 ; sprite dimensions
	dw ElectrodePicFront, ElectrodePicBack

IF DEF(_MODERN)
	db STUN_SPORE, SWIFT, SELFDESTRUCT, DISCHARGE ; level 1 learnset modern
ELSE
	db THUNDERSHOCK, STUN_SPORE, SWIFT, SELFDESTRUCT ; level 1 learnset
ENDC
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TAKE_DOWN,    HYPER_BEAM,   SOLARBEAM,    THUNDERBOLT,  THUNDER,      \
	     DOUBLE_TEAM,  REFLECT,      SELFDESTRUCT, SWIFT,        REST,         \
	     THUNDER_WAVE, EXPLOSION,    SUBSTITUTE,   FLASH
	; end

	db BANK(ElectrodePicFront)
	assert BANK(ElectrodePicFront) == BANK(ElectrodePicBack)
