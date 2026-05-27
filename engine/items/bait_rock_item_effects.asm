ItemUseBait_:
	ld hl, ThrewBaitText
	call PrintText
	ld hl, wEnemyMonActualCatchRate ; catch rate
	srl [hl] ; halve catch rate
	ld a, BAIT_ANIM
	ld hl, wSafariBaitFactor ; bait factor
	ld de, wSafariEscapeFactor ; escape factor
	jr BaitRockCommon

ItemUseRock_:
	ld hl, ThrewRockText
	call PrintText
	ld hl, wEnemyMonActualCatchRate ; catch rate
	ld a, [hl]
	add a ; double catch rate
	jr nc, .noCarry
	ld a, $ff
.noCarry
	ld [hl], a
	ld a, ROCK_ANIM
	ld hl, wSafariEscapeFactor ; escape factor
	ld de, wSafariBaitFactor ; bait factor

BaitRockCommon:
;	ld [wAnimationID], a
	ld [wAltAnimationID], a
	xor a
	ld [wAnimationType], a
	ldh [hWhoseTurn], a
	ld [de], a ; zero escape factor (for bait), zero bait factor (for rock)
.randomLoop ; loop until a random number less than 5 is generated
	call Random
	and 7
	cp 5
	jr nc, .randomLoop
	inc a ; increment the random number, giving a range from 1 to 5 inclusive
	ld b, a
	ld a, [hl]
	add b ; increase bait factor (for bait), increase escape factor (for rock)
	jr nc, .noCarry
	ld a, $ff
.noCarry
	ld [hl], a
	predef MoveAnimation ; do animation
	ld c, 70
	jp DelayFrames

ThrewBaitText:
	text_far _ThrewBaitText
	text_end

ThrewRockText:
	text_far _ThrewRockText
	text_end
