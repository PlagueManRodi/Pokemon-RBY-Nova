_CheckForBoulderCollisionWithSprites::
	ld a, [wBoulderSpriteIndex]
	dec a
	swap a
	ld d, 0
	ld e, a
	ld hl, wSprite01StateData2MapY
	add hl, de
	ld a, [hli] ; map Y position
	ldh [hPlayerYCoord], a
	ld a, [hl] ; map X position
	ldh [hPlayerXCoord], a
	ld a, [wNumSprites]
	ld c, a
	ld de, $f
	ld hl, wSprite01StateData2MapY
	ldh a, [hPlayerFacing]
	and $3 ; facing up or down?
	jr z, .pushingHorizontallyLoop
.pushingVerticallyLoop
	inc hl
	ldh a, [hPlayerXCoord]
	cp [hl]
	jr nz, .nextSprite1 ; if X coordinates don't match
	dec hl
	ld a, [hli]
	ld b, a
	ldh a, [hPlayerFacing]
	rrca
	jr c, .pushingDown
; pushing up
	ldh a, [hPlayerYCoord]
	dec a
	jr .compareYCoords
.pushingDown
	ldh a, [hPlayerYCoord]
	inc a
.compareYCoords
	cp b
	ld a, 0
	jr z, .failure
.nextSprite1
	dec c
	jr z, .success
	add hl, de
	jr .pushingVerticallyLoop
.pushingHorizontallyLoop
	ld a, [hli]
	ld b, a
	ldh a, [hPlayerYCoord]
	cp b
	jr nz, .nextSprite2
	ld b, [hl]
	ldh a, [hPlayerFacing]
	bit 2, a
	jr nz, .pushingLeft
; pushing right
	ldh a, [hPlayerXCoord]
	inc a
	jr .compareXCoords
.pushingLeft
	ldh a, [hPlayerXCoord]
	dec a
.compareXCoords
	cp b
	ld a, 1
	jr z, .failure
.nextSprite2
	dec c
	jr z, .success
	add hl, de
	jr .pushingHorizontallyLoop
.failure
;;;
	ld b, a
	call CheckIfSpriteIsHidden
	and a
	jr z, .cont
	ld a, b
	and a
	jr z, .nextSprite1
	jr .nextSprite2
.cont
;;;	
	ld d, -1
	ret
.success
	ld d, 0
	ret

CheckIfSpriteIsHidden:
	push bc
	ldh a, [hCurrentSpriteOffset]
	ld b, a
	push bc
	push de
	push hl
	ld a, [wNumSprites]
	inc a
	sub c
	swap a
	ldh [hCurrentSpriteOffset], a
	predef IsObjectHidden
	pop hl
	pop de
	pop bc
	ld a, b
	ldh [hCurrentSpriteOffset], a
	pop bc
	ldh a, [hIsHiddenMissableObject]
	ret
