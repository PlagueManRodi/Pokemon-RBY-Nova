; All MOVEDEX RELATED CODE MADE BY RAINBOWMETALPIGEON EXCEPT FOR "TM MOVE TO ITEM NAME" MADE BY ZETAPHOENIX

ShowMovedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wLastMenuItem], a
	inc a
	ld [wd11e], a
	ldh [hJoy7], a
.setUpGraphics
	callfar LoadPokedexTilePatterns
.loop
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
.doAttackListMenu
	ld hl, wTopMenuItemY
	ld a, 3
	ld [hli], a ; top menu item Y
	xor a
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], D_LEFT | D_RIGHT | B_BUTTON | A_BUTTON
	call HandleAttackdexListMenu
	jr c, .goToSideMenu ; if the player chose an attack from the list
.exitAttackdex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ldh [hJoy7], a
	ld [wWastedByteCD3A], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	pop af
	ld [wListScrollOffset], a
	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
	jp ReloadMapData
.goToSideMenu
	call HandleAttackexSideMenu
	dec b
	jr z, .exitAttackdex ; if the player chose Quit
	dec b
	jr z, .doAttackListMenu ; if move not seen or player pressed B button
	dec b
	jr z, .loop
	jp .setUpGraphics ; if attack info was shown
; handles the menu on the lower right in the attackdex screen
; OUTPUT:
; b = reason for exiting menu
; 00: showed attack info
; 01: the player chose Quit
; 02: the attack has not been seen yet or the player pressed the B button

HandleAttackexSideMenu:
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	push af
	ld b, a
	ld a, [wLastMenuItem]
	push af
	ld a, [wListScrollOffset]
	push af
	add b
	inc a
	ld e, a
	callfar NextMove
	push af
	ld a, NUM_ATTACKS
	ld b, 2
	ld hl, wTopMenuItemY
	ld a, 10
	ld [hli], a ; top menu item Y
	ld a, 15
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, 1
	ld [hli], a ; max menu item ID
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; menu watched keys (A button and B button)
	xor a
	ld [hli], a ; old menu item ID
	ld [wMenuWatchMovingOutOfBounds], a
	ldh [hJoy7], a
.handleMenuInput
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	ld b, 2
	jr nz, .buttonBPressed
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseInfo
;choseQuit
	ld b, 1
.exitSideMenu
	pop af
	ld [wd11e], a
	pop af
	ld [wListScrollOffset], a
	pop af
	ld [wLastMenuItem], a
	pop af
	ld [wCurrentMenuItem], a
	ld a, $1
	ldh [hJoy7], a
	push bc
	hlcoord 0, 3
	ld de, 20
	lb bc, " ", 13
	call DrawTileLineCopy ; cover up the menu cursor in the attack list
	pop bc
	ret
.buttonBPressed
	push bc
	hlcoord 15, 8
	ld de, 20
	lb bc, " ", 9
	call DrawTileLineCopy ; cover up the menu cursor in the side menu
	pop bc
	jr .exitSideMenu
.choseInfo
	call ShowAttackdexDataInternal
	ld b, 0
	jr .exitSideMenu
; handles the list of attacks on the left of the attackdex screen
; sets carry flag if player presses A, unsets carry flag if player presses B

HandleAttackdexListMenu:
	call Attackdex_DrawInterface
.loop
	call Attackdex_PlaceAttackList
	call GBPalNormal
	call HandleMenuInput
	bit BIT_B_BUTTON, a ; was the B button pressed?
	jp nz, .buttonBPressed
	bit BIT_A_BUTTON, a ; was the A button pressed?
	jp nz, .buttonAPressed
.checkIfUpPressed
	bit BIT_D_UP, a ; was Up pressed?
	jr z, .checkIfDownPressed
.upPressed ; scroll up one row
	ld a, [wListScrollOffset]
	and a
	jp z, .loop
	dec a
	ld [wListScrollOffset], a
	jp .loop
.checkIfDownPressed
	bit BIT_D_DOWN, a ; was Down pressed?
	jr z, .checkIfRightPressed
.downPressed ; scroll down one row
IF DEF (_MODERN)
	callfar CheckIfATMFlagIsSet
	ld a, d
	and a
	ld a, NUM_ATTACKS-(LAST_ACID_TYPE_MOVE-FIRST_ACID_TYPE_MOVE)
	jr z, .notSet
	ld a, NUM_ATTACKS	
.notSet
ELSE
	ld a, NUM_ATTACKS
ENDC
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop
	inc a
	ld [wListScrollOffset], a
	jp .loop
.checkIfRightPressed
	bit BIT_D_RIGHT, a ; was Right pressed?
	jr z, .checkIfLeftPressed
.rightPressed ; scroll down 7 rows
IF DEF (_MODERN)
	callfar CheckIfATMFlagIsSet
	ld a, d
	and a
	ld a, NUM_ATTACKS-(LAST_ACID_TYPE_MOVE-FIRST_ACID_TYPE_MOVE)
	jr z, .notSet2
	ld a, NUM_ATTACKS
.notSet2
ELSE
	ld a, NUM_ATTACKS
ENDC
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 6
	ld b, a
	ld a, [wListScrollOffset]
	add 7
	ld [wListScrollOffset], a
	cp b
	jp c, .loop
	dec b
	ld a, b
	ld [wListScrollOffset], a
	jp .loop
.checkIfLeftPressed ; scroll up 7 rows
	bit BIT_D_LEFT, a ; was Left pressed?
	jr z, .buttonAPressed
.leftPressed
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop
.buttonAPressed
	scf
	ret
.buttonBPressed
	and a
	ret

Attackdex_DrawInterface:
	xor a
	ldh [hAutoBGTransferEnabled], a
; draw the horizontal line separating the seen amount from the bottom-right menu
	hlcoord 15, 8
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
; draw vertical line
	hlcoord 14, 0
	ld [hl], $71 ; vertical line tile
	hlcoord 14, 1
	call DrawAttackdexVerticalLine
	hlcoord 14, 9
	call DrawAttackdexVerticalLine
; print how many attacks have been seen
	hlcoord 1, 1
	ld de, AttackdexContentsText
	call PlaceString
	hlcoord 16, 10
	ld de, AttackdexMenuItemsText
	call PlaceString
; find the highest attackdex number among the attacks the player has seen
	ret

DrawAttackdexVerticalLine:
	ld c, 9 ; height of line
	ld de, SCREEN_WIDTH ; width of screen
	ld a, $71 ; vertical line tile
.loop
	ld [hl], a
	add hl, de
	xor 1 ; toggle between vertical line tile and box tile
	dec c
	jr nz, .loop
	ret

AttackdexSeenText:
	db "SEEN@"

PokedexOwnText2:
	db "OWN@"

AttackdexContentsText:
	db "MOVES@"

AttackdexMenuItemsText:
	db   "INFO"
	next "QUIT@"

Attackdex_PlaceAttackList:
	xor a
	ldh [hAutoBGTransferEnabled], a
	hlcoord 4, 2
	lb bc, 14, 10
	call ClearScreenArea
	hlcoord 1, 3
	ld a, [wListScrollOffset]
	ld [wd11e], a
	ld d, 7
	ld e, a
	ld a, NUM_ATTACKS
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld e, a
	ld [wMaxMenuItem], a
; loop to print attacks' indexes and names
; only if the player has seen the attack

.printPokemonLoop
	;
	push af
	push bc
	push hl
	inc e
	callfar NextMove
	pop hl
	pop bc
	;
	push de
	push hl
	ld de, -SCREEN_WIDTH
	add hl, de
;	ld de, wd11e
;	lb bc, LEADING_ZEROES | 1, 3
;	call PrintNumber ; print the pokedex number
	ld de, SCREEN_WIDTH
	add hl, de
	inc hl
	inc hl
	push hl
	jr .getAttackName ; if the player has seen the attack
	ld de, .dashedLine ; print a dashed line in place of the name if the player hasn't seen the attack
	jr .skipGettingName
.dashedLine ; for unseen attack in the list
	db "----------@"
.getAttackName
	call GetMoveName ; TBV
.skipGettingName
	pop hl
	dec hl
	call PlaceString
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	pop af
	ld [wd11e], a
	dec d
	jr nz, .printPokemonLoop
	ld a, 01
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ret

; tests if an attack's bit is set in the seen-attack bit field
; INPUT:
; [wd11e] = attackdex number
; hl = address of bit field
IsAttackBitSet:
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret
; function to display pokedex data from outside the pokedex

ShowAttackdexData:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
;	call UpdateSprites
	callfar LoadPokedexTilePatterns ; load pokedex tiles
; function to display pokedex data from inside the pokedex

ShowAttackdexDataInternal:
	ld hl, wd72c
	set 1, [hl]
	ld a, $33 ; 3/7 volume
	ldh [rNR50], a
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	call GBPalWhiteOut ; zero all palettes
	ld a, [wd11e] ; attack ID
	push af
	xor a
	ld [wcf91], a
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wd11e], a
	ld [wcf91], a
;	call DrawDexEntryOnScreen2
;	call Pokedex_PrintFlavorTextAtRow112
	call DrawAttackdexEntryOnScreen
	call Attackdex_PrintFlavorTextAtRow10
.waitForButtonPress
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and A_BUTTON | B_BUTTON
	jr z, .waitForButtonPress
	pop af
	ldh [hTileAnimations], a
	call GBPalWhiteOut
	call ClearScreen
	;
	ld hl, wNewFlags
	bit 1, [hl]
	jr nz, .skipRDPC
	;
	call RunDefaultPaletteCommand
	;
.skipRDPC
	;
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wd72c
	res 1, [hl]
	ld a, $77 ; max volume
	ldh [rNR50], a
	ret
; horizontal line that divides the pokedex text description from the rest of the data

PokedexDataDividerLine2:
	db $68, $69, $6B, $69, $6B, $69, $6B, $69, $6B, $6B
	db $6B, $6B, $69, $6B, $69, $6B, $69, $6B, $69, $6A
	db "@"

DrawAttackdexEntryOnScreen:
	call ClearScreen
	hlcoord 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLineCopy ; draw top border
	hlcoord 0, 17
	ld b, $6f
	call DrawTileLineCopy ; draw bottom border
	hlcoord 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLineCopy ; draw left border
	hlcoord 19, 1
	ld b, $67
	call DrawTileLineCopy ; draw right border
	
	hlcoord 1, 2
	ld de, 1
	lb bc, $6B, SCREEN_WIDTH-2
	call DrawTileLineCopy ; draw divider between attack name and its info
	
	hlcoord 3, 5
	ld de, 1
	lb bc, $6B, SCREEN_WIDTH-6
	call DrawTileLineCopy ; draw divider between attack name and its info
	
	ld a, $63 ; upper left corner tile
	ldcoord_a 0, 0
	ld a, $65 ; upper right corner tile
	ldcoord_a 19, 0
	ld a, $6c ; lower left corner tile
	ldcoord_a 0, 17
	ld a, $6e ; lower right corner tile
	ldcoord_a 19, 17
	hlcoord 0, 8
	ld de, PokedexDataDividerLine2
	call PlaceString ; draw horizontal divider line
; print move name
	call GetMoveName
	hlcoord 2, 1
	call PlaceString
; gather info on the move
	ld a, [wd11e]
	dec a
	
	ld de, wPlayerMoveNum
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes ; adds bc to hl a times
	ld a, BANK(Moves)
	call FarCopyData ; copies bc bytes from a:hl to de
	ld de, wPlayerMoveNum
	callfar AcidTypeMoveCheck
; print TYPE, BP, ACC, PP, and % texts
	hlcoord 1, 4
	ld de, CatTextAttackdex
	call PlaceString
	
	hlcoord 1, 3
	ld de, TypeTextAttackdex
	call PlaceString
	
	hlcoord 5, 6
	ld de, BPTextAttackdex
	call PlaceString
	
	hlcoord 11, 6
	ld de, AccuracyTextAttackdex
	call PlaceString
	
	hlcoord 3, 7
	ld de, PPTextAttackdex
	call PlaceString
	
	hlcoord 9, 7
	ld de, MaxTextAttackdex
	call PlaceString
	
	hlcoord 16, 7
	ld [hl], ")"

	hlcoord 7, 6 ; 3, 5
	ld a, [wPlayerMovePower]
	cp 0
	jr z, .zeroDamage
	cp 1
	jr z, .specialDamage
	hlcoord 6, 6 ; 1, 5
	ld de, wPlayerMovePower
	lb bc, 1, 3
	call PrintNumber ; prints the c-digit, b-byte value at de
	jr .afterDamagePrinting
.zeroDamage
	ld [hl], "-"
	jr .afterDamagePrinting
.specialDamage
	ld [hl], "?"
.afterDamagePrinting

	hlcoord 12, 6 ; 5, 5
	xor a
	ld b, a
	ld a, [wPlayerMoveAccuracy]
.loopAccuracy
	sub 12
	jr c, .accuracyFound
	ld c, a
	ld a, b
	add 5
	ld b, a
	ld a, c
	jr .loopAccuracy
.accuracyFound
	ld a, b
	cp 76 ; fine-tuned number because
	jr c, .noSub5
	sub 5
.noSub5
	ld [wPlayerMoveAccuracyPercent], a
	ld de, wPlayerMoveAccuracyPercent
	ld a, [wPlayerMoveEffect]    ; read effect id
	ld b, a
	ld hl, AlwaysHitEffects3      ; table of move effects that always hit
.alwaysHitLoop
	ld a, [hli]                  ; read effect from move table
	cp b                         ; does it match the move about to be used?
	jr z, .alwaysHitText         ; this effect always hits
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .alwaysHitLoop        ; check the next effect
	hlcoord 12, 6
	lb bc, 1, 3
	call PrintNumber ; prints the c-digit, b-byte value at de
	jr .skipAlwaysHitText
.alwaysHitText
	hlcoord 13, 6
	ld de, PerfectAccText3
	call PlaceString
.skipAlwaysHitText
; print (base) PP
	hlcoord 6, 7
	ld de, wPlayerMoveMaxPP
	lb bc, 1, 2
	call PrintNumber
	
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand + 1], a
	ld a, [wPlayerMoveMaxPP]
	ldh [hMultiplicand + 2], a
	ld a, 8
	ldh [hMultiplier], a
	call Multiply
	ld a, 5
	ldh [hDivisor], a
	ld b, 4 ; number of bytes in dividend
	call Divide
	ldh a, [hQuotient + 3]
	cp 64
	jr nz, .skip
	ld a, 61
.skip
	hlcoord 14, 7
	ld b, a
	ld a, [wd11e]
	push af
	ld a, b
	ld [wd11e], a
	ld de, wd11e
	lb bc, 1, 2
	call PrintNumber
	pop af
	ld [wd11e],a
	
	ld a, [wPlayerMovePower]
	and a
	jr z, .statusMove
	ld a, [wPlayerMoveType]
	cp 20
	jr c, .physicalMove
	ld de, SpecialTextAttackdex
	jr .printCategory
.physicalMove
	ld de, PhysicalTextAttackdex
	jr .printCategory
.statusMove	
	ld a, [wPlayerMoveNum]
	cp BIDE
	jr z, .physicalMove
	ld de, StatusTextAttackdex
.printCategory
	hlcoord 6, 4
	call PlaceString
	
; print move type
	hlcoord 6, 3
	predef PrintMoveType
; print move type
	ld a, [wd11e]
	push af
	
	decoord 15, 3
	callfar DisplayTMItemNameFromMoveName
	
	push bc
	push de
	push hl

	call GBPalNormal

	pop hl
	pop de
	pop bc
	
	pop af
	ld [wd11e], a           ; new, testing
	call GetMoveName        ; new, testing
	call CopyToStringBuffer ; new, testing
	
	ld hl, MovedexEntryPointers
	ld a, [wd11e]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl] ; de = address of pokedex entry
	ld h, d
	ld l, e

	ret

Attackdex_PrintFlavorTextAtRow10:
	bccoord 1, 10

Attackdex_PrintFlavorTextAtBC:
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor ; print pokedex description text
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
	ret

Pokedex_PrepareDexEntryForPrinting2:
	hlcoord 0, 0
	ld de, SCREEN_WIDTH
	lb bc, $66, $d
	call DrawTileLineCopy
	hlcoord 19, 0
	ld b, $67
	call DrawTileLineCopy
	hlcoord 0, 13
	ld de, $1
	lb bc, $6f, SCREEN_WIDTH
	call DrawTileLineCopy
	ld a, $6c
	ldcoord_a 0, 13
	ld a, $6e
	ldcoord_a 19, 13
	ld a, [wPrinterPokedexEntryTextPointer]
	ld l, a
	ld a, [wPrinterPokedexEntryTextPointer + 1]
	ld h, a
	bccoord 1, 1
	ldh a, [hUILayoutFlags]
	set 3, a
	ldh [hUILayoutFlags], a
	call Attackdex_PrintFlavorTextAtBC
	ldh a, [hUILayoutFlags]
	res 3, a
	ldh [hUILayoutFlags], a
	ret
; draws a line of tiles
; INPUT:
; b = tile ID
; c = number of tile ID's to write
; de = amount to destination address after each tile (1 for horizontal, 20 for vertical)
; hl = destination address

DrawTileLineCopy:
	push bc
	push de
.loop
	ld [hl], b
	add hl, de
	dec c
	jr nz, .loop
	pop de
	pop bc
	ret

INCLUDE "data/moves/movedex_entries.asm"
INCLUDE "data/battle/always_hit_effects_3.asm"

PPTextAttackdex:
	db "PP@"
BPTextAttackdex:
	db "P@"
CatTextAttackdex:
	db "CAT.@"
AccuracyTextAttackdex:
	db "A@"
PerfectAccText3:
	db "-@"
MaxTextAttackdex:
	db "(max@"
TypeTextAttackdex:
	db "TYPE@"
PhysicalTextAttackdex:
	db "PHYSICAL@"
SpecialTextAttackdex:
	db "SPECIAL@"
StatusTextAttackdex:
	db "STATUS@"
