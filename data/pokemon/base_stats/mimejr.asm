	db DEX_MIME_JR ; pokedex id

	db  20,  25,  45,  60,  70
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FAIRY ; type
	db 145 ; catch rate
	db 62 ; base exp

	INCBIN "gfx/pokemon/front/mimejr..pic", 0, 1 ; sprite dimensions
	dw MimeJrPicFront, MimeJrPicBack

	db CONFUSION, POUND, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
IF DEF(_MODERN)
	tmhm TOXIC,        SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      DREAM_EATER,  REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   SHADOW_BALL,  FLASH
ELSE
	tmhm TOXIC,        SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      DREAM_EATER,  REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   FLASH
ENDC
	; end

	db BANK(MimeJrPicFront)
	assert BANK(MimeJrPicFront) == BANK(MimeJrPicBack)
