MarkTownVisitedAndLoadMissableObjects::
	ld a, [wCurMap]
	cp FIRST_ROUTE_MAP
	jr nc, .notInTown
	cp VERMILION_BEACH
	jr z, .notInTown
	ld [wLastBlackoutMap], a
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
	jr .cont
.notInTown
	cp ROUTE_4
	jr nz, .checkRoute10
	ld [wLastBlackoutMap], a
	ld c, 11
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
	jr .cont
.checkRoute10
	cp ROUTE_10
	jr nz, .cont
	ld [wLastBlackoutMap], a
	ld c, 12
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.cont
	ld hl, MapHSPointers
	ld a, [wCurMap]
	ld b, $0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]                ; load missable objects pointer in hl
	ld h, [hl]
	; fall through

LoadMissableObjects:
	ld l, a
	push hl
	
	;;;;;;;;;; PureRGBnote: ADDED: when in some maps we use a different set of flags for hiding/showing objects.
	ld de, NewMissableObjects
	; check if hl address is >= ExtraMissableObjects, if so load ExtraMissableObjects
	ld a, d
	sub h
	jr c, .newMissables
	jr nz, .normal
	ld a, e
	sub l
	jr z, .newMissables
	jr c, .newMissables
.normal
	
	ResetEventA EVENT_IN_NEW_MISSABLE_OBJECTS_MAP
	ld de, MissableObjects     ; calculate difference between out pointer and the base pointer
	jr .load
.newMissables
	SetEventA EVENT_IN_NEW_MISSABLE_OBJECTS_MAP
.load
;;;;;;;;;;
	
;	ld de, MissableObjects     ; calculate difference between out pointer and the base pointer
	ld a, l
	sub e
	jr nc, .noCarry
	dec h
.noCarry
	ld l, a
	ld a, h
	sub d
	ld h, a
	ld a, h
	ldh [hDividend], a
	ld a, l
	ldh [hDividend+1], a
	xor a
	ldh [hDividend+2], a
	ldh [hDividend+3], a
	ld a, $3
	ldh [hDivisor], a
	ld b, $2
	call Divide                ; divide difference by 3, resulting in the global offset (number of missable items before ours)
	ld a, [wCurMap]
	ld b, a
	ldh a, [hDividend+3]
	ld c, a                    ; store global offset in c
	ld de, wMissableObjectList
	pop hl
.writeMissableObjectsListLoop
	ld a, [hli]
	cp -1
	jr z, .done     ; end of list
	cp b
	jr nz, .done    ; not for current map anymore
	ld a, [hli]
	inc hl
	ld [de], a                 ; write (map-local) sprite ID
	inc de
	ld a, c
	inc c
	ld [de], a                 ; write (global) missable object index
	inc de
	jr .writeMissableObjectsListLoop
.done
	ld a, -1
	ld [de], a                 ; write sentinel
	ret

InitializeMissableObjectsFlags:
	ld hl, wMissableObjectFlags
	ld bc, wMissableObjectFlagsEnd - wMissableObjectFlags
	xor a
	call FillMemory ; clear missable objects flags
	ld hl, MissableObjects
	xor a
	ld [wMissableObjectCounter], a
	ld d, 0
.missableObjectsLoop
	ld a, [hli]
	cp -1           ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp HIDE
	jr nz, .skip
	ld a, d
	and a
	ld hl, wMissableObjectFlags
	jr z, .normal
	ld hl, wMissableObjectFlags+32
.normal
	ld a, [wMissableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction ; set flag if Item is hidden
.skip
	ld a, [wMissableObjectCounter]
	inc a
	cp NUM_HS_OBJECTS
	jr nz, .cont
	xor a
	ld d, 1
.cont
	ld [wMissableObjectCounter], a
	pop hl
	inc hl
	inc hl
	jr .missableObjectsLoop

; tests if current sprite is a missable object that is hidden/has been removed
IsObjectHidden:
	ldh a, [hCurrentSpriteOffset]
	swap a
	ld b, a
	ld hl, wMissableObjectList
.loop
	ld a, [hli]
	cp -1
	jr z, .notHidden ; not missable -> not hidden
	cp b
	ld a, [hli]
	jr nz, .loop
	ld c, a
	ld b, FLAG_TEST
;;;;;;;;;; PureRGBnote: ADDED: when in certain maps we use a different set of flags for hiding/showing objects.
	CheckEvent EVENT_IN_NEW_MISSABLE_OBJECTS_MAP
	ld hl, wMissableObjectFlags
	jr z, .doAction
	ld hl, wMissableObjectFlags+32
.doAction
;;;;;;;;;;
	call MissableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
.notHidden
	xor a
.hidden
	ldh [hIsHiddenMissableObject], a
	ret

; adds missable object (items, leg. pokemon, etc.) to the map
; [wMissableObjectIndex]: index of the missable object to be added (global index)
ShowObject:
ShowObject2:
	ld hl, wMissableObjectFlags
	jr ShowObjectCommon
	
ShowNewObject:
	ld hl, wMissableObjectFlags+32
	; fallthrough
ShowObjectCommon:
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_RESET
	call MissableObjectFlagAction   ; reset "removed" flag
	jp UpdateSprites

; removes missable object (items, leg. pokemon, etc.) from the map
; [wMissableObjectIndex]: index of the missable object to be removed (global index)
HideObject:
	ld hl, wMissableObjectFlags
	jr HideObjectCommon
	
HideNewObject:
	ld hl, wMissableObjectFlags+32
	; fallthrough
HideObjectCommon:
	ld a, [wMissableObjectIndex]
	ld c, a
	ld b, FLAG_SET
	call MissableObjectFlagAction   ; set "removed" flag
	jp UpdateSprites

MissableObjectFlagAction:
; identical to FlagAction

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld a, [hl]
	ld b, a
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld a, [hl]
	ld b, a
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld a, [hl]
	ld b, a
	ld a, d
	and b

.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret

; lb de, FIRST_HS_INDEX, LAST_HS_INDEX
SetNewMissableObjectRangeBackToDefaultStatus::
	inc e
.loop
	ld a, d
	cp e
	ret nc
	ld [wMissableObjectIndex], a
	call GetNewObjectDefaultStatus
	cp SHOW
	jr z, .showObject
	call HideNewObject
	jr .skip
.showObject
	call ShowNewObject
.skip
	inc d
	jr .loop

; input a = which new object flag it is
; output a = what the default state is
GetNewObjectDefaultStatus:
	ld hl, NewMissableObjects + 2
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hl]
	ret	
