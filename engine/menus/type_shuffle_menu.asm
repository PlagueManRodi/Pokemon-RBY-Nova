AlternativeTypesTable:
	
	db TS_CHARIZARD,		CHARIZARD,			1,	FIRE,			FLYING,			FIRE,			DRAGON
	db TS_BLASTOISE,		BLASTOISE,			1,	WATER,			WATER,			WATER,			STEEL
	db TS_BUTTERFREE,		BUTTERFREE,  		1,	BUG,			FLYING,			BUG,			PSYCHIC_TYPE
	db TS_PIDGEY,			PIDGEY,				3,	NORMAL,			FLYING,			FLYING,			FLYING
	db TS_PIDGEOTTO,		PIDGEOTTO,   		2,	NORMAL,			FLYING,			FLYING,			FLYING
	db TS_PIDGEOT,			PIDGEOT,     		1,	NORMAL,			FLYING,			FLYING,			FLYING
	db TS_SPEAROW,			SPEAROW,			2, 	NORMAL,			FLYING,			FLYING,     	FLYING
	db TS_FEAROW,			FEAROW,				1,	NORMAL,     	FLYING,			FLYING,			FLYING
	db TS_EKANS,			EKANS,				2,	POISON,			POISON,			POISON,			DARK
	db TS_ARBOK,			ARBOK,				1,	POISON,			POISON,			POISON,			DARK
	db TS_BELLOSSOM,		BELLOSSOM,			1,	GRASS,			GRASS,			GRASS,			FAIRY
	db TS_VENONAT,			VENONAT,			2,	BUG,			POISON,			PSYCHIC_TYPE,	POISON
	db TS_VENOMOTH,			VENOMOTH,			1,	BUG,			POISON,			PSYCHIC_TYPE,	POISON
	db TS_PSYDUCK,			PSYDUCK,			2,	WATER,			WATER,			WATER,			PSYCHIC_TYPE
	db TS_GOLDUCK,			GOLDUCK,			1,	WATER,			WATER,			WATER,			PSYCHIC_TYPE
	db TS_POLITOED,			POLITOED,			1, 	WATER,			WATER,			WATER,			PSYCHIC_TYPE
	db TS_BELLSPROUT,		BELLSPROUT,			3,	GRASS,			POISON,			GRASS,			ACID_TYPE
	db TS_WEEPINBELL,		WEEPINBELL,			2,	GRASS,			POISON,			GRASS,			ACID_TYPE
	db TS_VICTREEBEL,		VICTREEBEL,			1,	GRASS,			POISON,			GRASS,			ACID_TYPE
	db TS_MAGNEMITE,		MAGNEMITE,			3, 	ELECTRIC,		STEEL,			ELECTRIC,		ELECTRIC
	db TS_MAGNETON,			MAGNETON,			2, 	ELECTRIC,		STEEL,			ELECTRIC,		ELECTRIC
	db TS_MAGNEZONE,		MAGNEZONE,			1, 	ELECTRIC,		STEEL,			ELECTRIC,		ELECTRIC
	db TS_DODUO,			DODUO,				2, 	NORMAL,			FLYING,			FIGHTING,		FLYING
	db TS_DODRIO,			DODRIO,				1, 	NORMAL,			FLYING,			FIGHTING,		FLYING
	db TS_GASTLY,			GASTLY,				3,	GHOST,			POISON,			GHOST,			DARK
	db TS_HAUNTER,			HAUNTER,			2,	GHOST,			POISON,			GHOST,			DARK
	db TS_GENGAR,			GENGAR,				1, 	GHOST,			POISON,			GHOST,			DARK
	db TS_DROWZEE,			DROWZEE,			2, 	PSYCHIC_TYPE,	PSYCHIC_TYPE,	PSYCHIC_TYPE,	ACID_TYPE
	db TS_HYPNO,			HYPNO,				1, 	PSYCHIC_TYPE,	PSYCHIC_TYPE,	PSYCHIC_TYPE,	ACID_TYPE
	db TS_GOLDEEN,			GOLDEEN,			2, 	WATER,			WATER,			WATER,			NORMAL
	db TS_SEAKING,			SEAKING,			1, 	WATER,			WATER,			WATER,			NORMAL
	db TS_STARMIE,			STARMIE,			1, 	WATER,			PSYCHIC_TYPE,	WATER,			ROCK
	db TS_ELEKID,			ELEKID,				3,	ELECTRIC,		ELECTRIC,		ELECTRIC,		FIGHTING
	db TS_ELECTABUZZ,		ELECTABUZZ,			2,	ELECTRIC,		ELECTRIC,		ELECTRIC,		FIGHTING
	db TS_ELECTIVIRE,		ELECTIVIRE,			1,	ELECTRIC,		ELECTRIC,		ELECTRIC,		FIGHTING
	db TS_PINSIR,			PINSIR,				1, 	BUG,			BUG,			BUG,			FIGHTING
	db TS_GYARADOS,			GYARADOS,			1, 	WATER,			FLYING,			WATER,			DRAGON
	db TS_PORYGON,			PORYGON,			3, 	NORMAL,			NORMAL,			NORMAL,			ELECTRIC
	db TS_PORYGON2,			PORYGON2,			2, 	NORMAL,			NORMAL,			NORMAL,			ELECTRIC
	db TS_PORYGONZ,			PORYGONZ,			1,	NORMAL,			NORMAL,			NORMAL,			ELECTRIC
	db TS_KABUTO,			KABUTO,				2,	ROCK,			WATER,			ROCK,			BUG
	db TS_KABUTOPS,			KABUTOPS,			1, 	ROCK,			WATER,			ROCK,			BUG
	db TS_AERODACTYL,		AERODACTYL,			1, 	ROCK,			FLYING,			ROCK,			DRAGON
	db TS_DRAGONITE,		DRAGONITE,			1, 	DRAGON,			FLYING,			DRAGON,			DRAGON
	db TS_ACID_TYPE_MOVES,	SPECIAL_ENTRY,		1,	0,				0,				0,				0

DisplayTypeShuffleMenu::
	ld a, [wShownPokeShuffleInfo]
	bit 2, a
	jr z, .checkBit0
	bit 1, a
	jr nz, .dontDisplay
	jr .display
.checkBit0
	bit 0, a
	jr nz, .dontDisplay
.display
	call DisplayInfoTextbox
.dontDisplay
	hlcoord 0, 0
	ld b, 10
	ld c, 18
	call TextBoxBorder
	hlcoord 0, 12
	ld b, 4
	ld c, 18
	call TextBoxBorder
	hlcoord 14, 0
	ld de, AInfoText
	call PlaceString
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	xor a
.loadNewPage
	ld [wTypeShufflePage], a
	call PrintPageContent
	call PrintCurrentPage
.placeNewCursor
	call GetMenuItemXFromArray
	ld [wTopMenuItemX], a
	call PlaceUnfilledCursors
	call PlaceMenuCursor
	call PrintInfoTextBox
.getJoypadStateLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	jr z, .getJoypadStateLoop
	bit BIT_A_BUTTON, b
	jr nz, .pressedA
	bit BIT_D_RIGHT, b
	jr nz, .pressedRight
	bit BIT_D_LEFT, b
	jr nz, .pressedLeft
	bit BIT_D_UP, b
	jr nz, .pressedUp
	bit BIT_D_DOWN, b
	jr nz, .pressedDown
	bit BIT_B_BUTTON, b
	ret nz
	bit BIT_START, b
	jr z, .getJoypadStateLoop
	ret
.pressedUp
	call EraseMenuCursor
	; decrease cur menu item
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	; check cur menu item y
	cp -1
	jr nz, .placeNewCursor
	; decrease page
	ld a, 4
	ld [wCurrentMenuItem], a
	ld a, [wTypeShufflePage]
	dec a
	cp -1
	jr nz, .loadNewPage
	; first to last page
	ld a, NUM_ALT_TYPE_PAGES
	jr .loadNewPage
.pressedDown
	call EraseMenuCursor
	; increase cur menu item
	ld a, [wCurrentMenuItem]
	inc a
	ld [wCurrentMenuItem], a
	; check cur menu item y
	cp 5
	jr nz, .placeNewCursor
	; increase page
	xor a
	ld [wCurrentMenuItem], a
	ld a, [wTypeShufflePage]
	inc a
	cp NUM_ALT_TYPE_PAGES+1
	jr c, .loadNewPage
	; last to first page
	xor a
	jr .loadNewPage
.pressedRight
	ld a, [wTopMenuItemX]
	cp 6
	jr z, .getJoypadStateLoop
	call EraseMenuCursor
	call SetTypeShuffleFlags
	jr .placeNewCursor
.pressedLeft
	ld a, [wTopMenuItemX]
	cp 2
	jr z, .getJoypadStateLoop
	call EraseMenuCursor
	call ResetTypeShuffleFlags
	jp .placeNewCursor
.pressedA
	call DisplayInfoTextbox
	jp .getJoypadStateLoop

PrintPageContent:
	; clear screen area
	hlcoord 1, 1
	lb bc, 10, 18
	call ClearScreenArea
	; find first element
	ld a, [wTypeShufflePage]
	ld b, a
	sla a
	sla a
	add b
	lb bc, 0, 0
	and a
	jr z, .firstElementFound
	ld d, a
.loop
	ld hl, AlternativeTypesTable+2
	ld a, 7
	call AddNTimes
	ld a, [hl]
	ld e, a
	add c
	ld c, a
	dec d
	ld a, d
	and a
	jr nz, .loop
.firstElementFound
	ld d, 5
	ld e, 0
.loop2
	ld hl, AlternativeTypesTable
	ld a, 7
	call AddNTimes
	ld a, [hli]
	cp LAST_ALT_TYPE
	jr nz, .notLastEntry
	ld d, 1
.notLastEntry
	ld a, [hli]
	cp -1
	jr z, .printSpecialEntry
	ld [wd11e], a
	ld a, [hl]
	cp 1
	jr z, .singleMon
	inc e
	dec a
	add c
	ld c, a
	jr .loop2
.singleMon
	push bc
	push de
	call GetMonName
	ld hl, CoordsNameStrings
	pop bc
	push bc
	push de
	dec b
	sla b
	ld e, b
	ld d, 0
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld h, a
	ld l, d
	pop de
	call PlaceString
	pop de
	push de
	push hl
	ld h, b
	ld l, c
	ld a, e
	and a
	jr nz, .addLineText
	ld de, AfterPokemonText
	jr .skip
.addLineText
	ld de, AfterPokemonLineText
.skip
	call PlaceString
	pop hl
	ld b, 0
	ld c, 22
	add hl, bc
	ld de, OgAltText
	call PlaceString
.prepLoop
	pop de
	pop bc
	ld e, 0
	inc c
	dec d
	ld a, d
	and a
	jr nz, .loop2
.end
	ret
.printSpecialEntry
	push bc
	push de
	dec hl
	dec hl
	ld a, [hl]
	cp TS_ACID_TYPE_MOVES
	jr z, .acidTypeMoves
	jr .prepLoop
.acidTypeMoves
	ld hl, CoordsNameStrings
	pop bc
	push bc
	dec b
	sla b
	ld e, b
	ld d, 0
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld h, a
	ld l, d
	ld de, AcidTypeMovesText
	call PlaceString
	ld b, 0
	ld c, 22
	add hl, bc
	ld de, NoYesText
	call PlaceString
	jr .prepLoop
	
DisplayInfoTextbox:
	call SaveScreenTilesToBuffer1
	call ClearScreen
	hlcoord 0, 0
	ld b, 16
	ld c, 18
	call TextBoxBorder
.showPage1Again
	ld a, [wShownPokeShuffleInfo]
	bit 2, a
	ld de, TypeShuffleInfoText
	jr z, .fromMM
	ld de, TypeShuffleInfoText3
.fromMM
	hlcoord 1, 1
	call PlaceString
	ld de, InfoPage1Text
	hlcoord 8, 17
	call PlaceString
.getJoypadStateLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | START | D_DOWN
	jr z, .getJoypadStateLoop
	bit BIT_B_BUTTON, b
	jr nz, .done
	bit BIT_START, b
	jr nz, .done
	; clear screen area
	hlcoord 1, 1
	lb bc, 16, 18
	call ClearScreenArea
	ld a, [wShownPokeShuffleInfo]
	bit 2, a
	ld de, TypeShuffleInfoText2
	jr z, .fromMM2
	ld de, TypeShuffleInfoText4
.fromMM2
	hlcoord 1, 1
	call PlaceString
	ld de, InfoPage2Text
	hlcoord 8, 17
	call PlaceString
.getJoypadStateLoop2
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | START | D_UP
	jr z, .getJoypadStateLoop2
	bit BIT_D_UP, b
	jr z, .done
	; clear screen area
	hlcoord 1, 1
	lb bc, 16, 18
	call ClearScreenArea
	jr .showPage1Again
.done
	call LoadScreenTilesFromBuffer1
	ld a, [wShownPokeShuffleInfo]
	bit 2, a
	jr z, .setBit0
	set 1, a
	jr .fullyDone
.setBit0
	set 0, a
.fullyDone
	ld [wShownPokeShuffleInfo], a
	ret
	
TypeShuffleInfoText:
	db "TYPE SHUFFLE sett-"
	next "ings will only be"
	next "applied to a new"
	next "game and can only"
	next "be changed again"
	next "after becoming"
	next "champion.@"
	
TypeShuffleInfoText2:
	db "The optional, new"
	next "ACID-TYPE can be"
	next "enabled here."
	next
	next "Read the TYPE SHU-"
	next "FFLE documentation"
	next "for more info.@"
	
TypeShuffleInfoText3:
	db "The optional, new"
	next "ACID-TYPE can be"
	next "enabled here."
	next
	next "Learned ACID-TYPE"
	next "moves won't be for-"
	next "gotten from disa-"
	next "bling the option.@"
	
TypeShuffleInfoText4:
	db "Owned TM55s also"
	next "won't be removed."
	next 
	next "Read the TYPE SHU-"
	next "FFLE documentation"
	next "for more info.@"
	
InfoPage1Text:
	db "INFO 1/2 ▼@"
InfoPage2Text:
	db "INFO 2/2 <UA>@"
AInfoText:
	db "<A:><I><NF><O>@"

AfterPokemonText:
	db ":@"
AfterPokemonLineText:
	db ": (LINE)@"
AcidTypeMovesText:
	db "ACID-TYPE MOVES:@"
OgAltText:
	db "<Og><oG>  <Alt><aLT>@"
NoYesText:
	db "<No><nO>  <Yes><yES>@"
CoordsNameStrings:
	dwcoord 1, 9
	dwcoord 1, 7
	dwcoord 1, 5
	dwcoord 1, 3
	dwcoord 1, 1

GetMenuItemXFromArray:
	call FindArrayPos
	and b
	ld a, 2
	ret z
	ld a, 6
	ret

FindArrayPos:
	ld a, [wTypeShufflePage]
	ld c, a
	ld a, [wCurrentMenuItem]
	ld l, a
	ld h, 0
	ld b, 0
	ld a, 5
	call AddNTimes
	ld a, l
	ld b, 0
	ld d, 0	; relative array byte position
	ld e, 0 ; array bit
	ld hl, AlternativeTypesTable+2
.loop2
	cp b
	jr z, .arrayPosFound
	ld c, a
	inc b
	push bc
	ld a, [hl]
	ld b, 0
	ld c, a
	add e
	cp 8
	jr c, .noIncreaseByte
	sub 8
	inc d
.noIncreaseByte
	ld e, a
	ld a, 7
	call AddNTimes
	pop bc
	ld a, c
	jr .loop2
.arrayPosFound
	dec hl
	dec hl
	ld a, [hl]
	ld c, a
	push bc
	ld hl, wTypeShuffleFlags
	ld b, 0
	ld c, d
	add hl, bc
	xor a
	cp e
	ld a, 1
	jr z, .gotBit
.loop3
	sla a
	dec e
	jr nz, .loop3
.gotBit
	pop de
	ld b, a
	ld a, [hl]
	ret
; a, corresponding flag array byte in memory
; b, corresponding bit of flag array byte
; d, menu item position
; e, type shuffle constant
; hl, wTypeShuffleFlags in corresponding byte

SetTypeShuffleFlags:
	call FindArrayPos
	push hl
	ld c, a
	push bc
	ld hl, AlternativeTypesTable+2
	ld b, 0
	ld c, e
	ld a, 7
	call AddNTimes
	ld a, [hl]
	pop de
	pop hl
	ld b, d
	push de
	ld c, 0
	ld e, 0
.loop
	dec a
	jr z, .done
	sla d
	rl e
	push af
	ld a, b
	or d
	ld b, a
	ld a, c
	or e
	ld c, a
	pop af
	jr .loop
.done
	pop de
	ld a, e
	or b
	ld [hli], a
	ld a, c
	and a
	jr z, .done2
	ld a, [hl]
	or c
	ld [hl], a
.done2
	ret

ResetTypeShuffleFlags:
	call FindArrayPos
	push hl
	ld c, a
	push bc
	ld hl, AlternativeTypesTable+2
	ld b, 0
	ld c, e
	ld a, 7
	call AddNTimes
	ld a, [hl]
	pop de
	pop hl
	ld b, d
	push de
	ld c, 0
	ld e, 0
.loop
	dec a
	jr z, .done
	sla d
	rl e
	push af
	ld a, b
	or d
	ld b, a
	ld a, c
	or e
	ld c, a
	pop af
	jr .loop
.done
	pop de
	ld a, b
	ld d, $FF
	xor d
	ld b, a
	ld a, e
	and b
	ld [hli], a
	ld a, c
	and a
	jr z, .done2
	ld a, c
	ld d, $FF
	xor d
	ld c, a
	ld a, [hl]
	and c
	ld [hl], a
.done2
	ret

PlaceUnfilledCursors:
	ld a, [wCurrentMenuItem]
	push af
	ld a, 0
.loop
	ld [wCurrentMenuItem], a
	call FindArrayPos
	and b
	ld d, 0
	ld e, 0
	jr z, .yFound
	ld e, 4
.yFound
	ld a, [wCurrentMenuItem]
	ld b, 0
	ld c, a
	ld a, 40
	ld hl, 0
	call AddNTimes
	add hl, de
	ld b, h
	ld c, l
	hlcoord 2, 2
	add hl, bc
	ld de, UnfilledCursorText
	call PlaceString
	ld a, [wCurrentMenuItem]
	inc a
	cp 5
	jr c, .loop
	pop af
	ld [wCurrentMenuItem], a
	ret

UnfilledCursorText:
	db "▷@"

PrintInfoTextBox:
	; clear screen area
	hlcoord 1, 13
	lb bc, 4, 18
	call ClearScreenArea
	call GetHeaderFromMenuItemPos
	ld a, [hl]
	cp TS_ACID_TYPE_MOVES
	jr z, .acidText
	push hl
	hlcoord 2, 13
	ld de, OgText
	call PlaceString
	hlcoord 2, 15
	ld de, AltText
	call PlaceString
	pop hl
	inc hl
	inc hl
	inc hl
	push hl
	bccoord 1,14
	call PrintHLTypeInBCCoord
	pop hl
	inc hl
	inc hl
	bccoord 1,16
	call PrintHLTypeInBCCoord
	ret
.acidText
	hlcoord 1, 13
	ld de, AcidTypeMovesInfoText
	call PlaceString
	ret

GetHeaderFromMenuItemPos:
	ld a, [wTypeShufflePage]
	ld c, a
	ld a, [wCurrentMenuItem]
	ld l, a
	ld h, 0
	ld b, 0
	ld a, 5
	call AddNTimes
	ld a, l
	ld b, 0
	ld d, 0	; relative array byte position
	ld e, 0 ; array bit
	ld hl, AlternativeTypesTable+2
.loop2
	cp b
	jr z, .arrayPosFound
	ld c, a
	inc b
	push bc
	ld a, [hl]
	ld b, 0
	ld c, a
	add e
	cp 8
	jr c, .noIncreaseByte
	sub 8
	inc d
.noIncreaseByte
	ld e, a
	ld a, 7
	call AddNTimes
	pop bc
	ld a, c
	jr .loop2
.arrayPosFound
	dec hl
	dec hl
	ret

PrintHLTypeInBCCoord:
	ld a, [hli]
	ld d, a
	ld a, [hl]
	cp d
	ld h, b
	ld l, c
	jr z, .singleType
	ld e, a
	push de
	call HomePrintType
	ld hl, 0
	add hl, bc
	ld de, SlashText
	call PlaceString
	ld hl, 0
	add hl, bc
	pop de
	ld a, e
.singleType
	ld d, a
	call HomePrintType
	ret

PrintCurrentPage:
	hlcoord 10,11
	ld de, PageText
	call PlaceString
	ld hl, 0
	add hl, bc
	ld a, [wTypeShufflePage]
	inc a
	ld b, $f6
	add b
	ld [hli], a
	ld a, "/"
	ld [hli], a
	ld [hl], "5"
	ret	

OgText:
	db "<Og><oG>@"
AltText:
	db "<Alt><aLT>@"
SlashText:
	db "/@"
AcidTypeMovesInfoText:
	db "Enable ACID-TYPE"
	next "MOVES.@"
PageText:
	db "PAGE @"

TypeShuffleCheck::
	ld hl, AlternativeTypesTable
	ld a, [wCurSpecies]
	ld d, 0
.loopTypesToChange
	ld b, a ; b holds the current mon species
	ld a, d
	and a
	ret nz
	ld a, [hli] ; a has the TS constant
	cp LAST_ALT_TYPE-1 ; terminator
	jr nz, .skip
	ld d, 1
.skip
; we didn't hit the terminator
	ld c, a
	ld a, [hli] ; a has the pokémon species
	cp b ; is the current pokemon we're looking at the same as the table entry?
	jr nz, .increaseHLby2 ; if not, go to the next entry
; it's a match!
	push hl
	inc c
	ld hl, wTypeShuffleFlags
	ld a, 1
	ld b, 0
.loop
	dec c
	jr z, .gotBit
	sla a
	jr nc, .loop
	inc b
	inc a
	jr .loop
.gotBit
	ld c, b
	ld b, 0
	add hl, bc
	ld b, a
	ld a, [hl]
	and b
	pop hl
	jr z, .end
	ld bc, 3
	add hl, bc
	ld a, [hli] ; a contains the first new type, hl points to the second new type
	ld [wMonHType1], a
	ld a, [hl]
	ld [wMonHType2], a
.end
IF DEF(_MODERN)
	call CheckIfATMFlagIsSet
	ld a, d
	and a
	ret z
	ld a, [wCurSpecies]
	cp VICTREEBEL
	ret nz
	ld a, CAUSTIC_BOMB
	ld [wMonHMoves+2], a
ENDC
	ret
.increaseHLby2
	ld a, b
	ld bc, 5
	add hl, bc
	jr .loopTypesToChange

AcidTypeMoveCheck:
	ld hl, 0
	add hl, de
	ld a, [hl]
	ld b, a
	ld hl, AcidTypeMoves
.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, .loop
	ld hl, wTypeShuffleFlags
	ld bc, 5
	add hl, bc
	ld a, [hl]
	ld b, 1<<4
	and b
	ret z
	ld hl, 3
	add hl, de
	ld a, ACID_TYPE
	ld [hl], a
	ret
	
CheckIfATMFlagIsSet::
	ld d, 0
	ld hl, wTypeShuffleFlags
	ld bc, 5
	add hl, bc
	ld a, [hl]
	ld b, 1<<4
	and b
	ret z
	ld d, 1
	ret

ATMCheck:
	call CheckIfATMFlagIsSet
	ld a, d
	and a
	ld d, 0
	ret nz
	ld a, [wMoveNum]
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wCurMoveData
	ld a, BANK(Moves)
	call FarCopyData
	ld de, wCurMoveData
	callfar AcidTypeMoveCheck
	ld a, [wCurMoveType]
	ld b, ACID_TYPE
	cp b
	ld d, 0
	ret nz
	ld d, 1
	ret	

AcidTypeMoves:
	db ACID
	db ACID_ARMOR
	db -1

MoveTSDataToBuffer:
	ld hl, wTypeShuffleFlags
	ld a, [hli]
	ld [wCurMoveData], a
	ld a, [hli]
	ld [wCurMoveData+1], a
	ld a, [hli]
	ld [wCurMoveData+2], a
	ld a, [hli]
	ld [wCurMoveData+3], a
	ld a, [hli]
	ld [wCurMoveData+4], a
	ld a, [hl]
	ld [wCurMoveData+5], a
	ret

MoveBufferToTSData:
	ld hl, wCurMoveData
	ld a, [hli]
	ld [wTypeShuffleFlags], a
	ld a, [hli]
	ld [wTypeShuffleFlags+1], a
	ld a, [hli]
	ld [wTypeShuffleFlags+2], a
	ld a, [hli]
	ld [wTypeShuffleFlags+3], a
	ld a, [hli]
	ld [wTypeShuffleFlags+4], a
	ld a, [hl]
	ld [wTypeShuffleFlags+5], a
	ret

ClearTSData:
	ld hl, wTypeShuffleFlags
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

UpdatePartyTypes::
	ld a, [wPartyCount]
	and a
	ret z
	ld hl, wPartyMon1Species
	ld d, a
.loop
	ld a, [hl]
	ld [wCurSpecies], a
	call GetMonHeader
	ld bc, wPartyMon1Type1-wPartyMon1Species
	add hl, bc
	ld a, [wMonHType1]
	ld [hli], a
	ld a, [wMonHType2]
	ld [hl], a
	ld bc, wPartyMon2Species-wPartyMon1Type2
	add hl, bc
	dec d
	jr nz, .loop
	ret

_UpdateType::
	push hl
	ld a, [hl]
	ld [wCurSpecies], a
	call GetMonHeader
	ld bc, wPartyMon1Type1-wPartyMon1Species
	add hl, bc
	ld a, [wMonHType1]
	ld [hli], a
	ld a, [wMonHType2]
	ld [hl], a
	pop hl
	ret
