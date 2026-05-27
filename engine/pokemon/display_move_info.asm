; New code based on the work of Rainbow Metal Pigeon

DisplayMoveInfoTextBoxes:
	; old-move info boxes borders
	hlcoord 9, 0
	lb bc, 3, 9
	call TextBoxBorder ; draws a c×b text box at hl
	; new-move info boxes borders
	hlcoord 9, 4
	lb bc, 3, 9
	call TextBoxBorder ; draws a c×b text box at hl
	; print info for new move
	call PrintInfoNewMove
	ret

PrintInfoNewMove: ; new
	push hl
	push bc
	push de
	push af

	xor a
	ldh [hAutoBGTransferEnabled], a

	ld de, wPlayerMoveNum
	ld a, [wMoveNum]
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes ; adds bc to hl a times
	ld a, BANK(Moves)
	call FarCopyData ; copies bc bytes from a:hl to de

	hlcoord 10, 3 ; 1, 6
	ld de, PPText2
	call PlaceString

	hlcoord 15, 2
	ld de, ACCText2
	call PlaceString
	
	hlcoord 10, 2
	ld de, POWText2
	call PlaceString

	hlcoord 12, 2 ; 3, 5
	ld a, [wPlayerMovePower]
	cp 0
	jr z, .zeroDamage
	cp 1
	jr z, .specialDamage
	hlcoord 11, 2 ; 1, 5
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

	hlcoord 16, 2 ; 5, 5
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
	ld hl, AlwaysHitEffects2     ; table of move effects that always hit
.alwaysHitLoop
	ld a, [hli]                  ; read effect from move table
	cp b                         ; does it match the move about to be used?
	jr z, .alwaysHitText         ; this effect always hits
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .alwaysHitLoop        ; check the next effect
	hlcoord 16, 2
	lb bc, 1, 3
	call PrintNumber ; prints the c-digit, b-byte value at de
	jr .skipAlwaysHitText
.alwaysHitText
	hlcoord 17, 2
	ld de, PerfectAccText2
	call PlaceString
.skipAlwaysHitText
	
;	hlcoord 13, 3 ; 7, 6
;	ld de, wPlayerMoveMaxPP ; wMaxPP
;	lb bc, 1, 2
;	call PrintNumber

;	callfar GetCurrentMove
	hlcoord 10, 1 ; 1, 4
	predef PrintMoveType

	ld a, $1
	ldh [hAutoBGTransferEnabled], a

	pop af
	pop de
	pop bc
	pop hl

	jp Delay3

PPText2:
	db "INFO <ST><ART>@"
	
PPText3:
	db "INFO <SEL><ECT>@"

ACCText2:
	db "A@"
	
POWText2:
	db "P@"

PerfectAccText2:
	db "-@"

; ==============================================================================

PrintInfoOldMove: ; new
	push hl
	push bc
	push de
	push af

	xor a
	ldh [hAutoBGTransferEnabled], a

	; clear screen area of the old move before printing its info
	hlcoord 10, 5 ; 1, 4
	lb bc, 3, 9
	call ClearScreenArea

	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wWhichPokemon]
	call AddNTimes ; adds bc to hl a times ; hl points to the moves

	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0 ; which move in the menu is the cursor pointing to? (0-3)
	add hl, bc ; points to the move in memory
	ld a, [hl] ; a should be holding the move ID
	dec a

	ld de, wPlayerMoveNum
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes ; adds bc to hl a times
	ld a, BANK(Moves)
	call FarCopyData ; copies bc bytes from a:hl to de

	hlcoord 10, 7 ; 11, 6
	ld de, PPText3
	call PlaceString

	hlcoord 15, 6
	ld de, ACCText2
	call PlaceString
	
	hlcoord 10, 6
	ld de, POWText2
	call PlaceString

	hlcoord 12, 6 ; 13, 5
	ld a, [wPlayerMovePower]
	cp 0
	jr z, .zeroDamage
	cp 1
	jr z, .specialDamage
	hlcoord 11, 6 ; 11, 5
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

	hlcoord 16, 6 ; 15, 5
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
	ld hl, AlwaysHitEffects2     ; table of move effects that always hit
.alwaysHitLoop
	ld a, [hli]                  ; read effect from move table
	cp b                         ; does it match the move about to be used?
	jr z, .alwaysHitText         ; this effect always hits
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .alwaysHitLoop        ; check the next effect
	hlcoord 16, 6
	lb bc, 1, 3
	call PrintNumber ; prints the c-digit, b-byte value at de
	jr .skipAlwaysHitText
.alwaysHitText
	hlcoord 17, 6
	ld de, PerfectAccText2
	call PlaceString
.skipAlwaysHitText

;	hlcoord 13, 7 ; 17, 6
;	ld de, wPlayerMoveMaxPP ; wMaxPP
;	lb bc, 1, 2
;	call PrintNumber

;	callfar GetCurrentMove
	hlcoord 10, 5 ; 11, 4
	predef PrintMoveType

	ld a, $1
	ldh [hAutoBGTransferEnabled], a

	pop af
	pop de
	pop bc
	pop hl

	jp Delay3

INCLUDE "data/battle/always_hit_effects_2.asm"
