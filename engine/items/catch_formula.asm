CatchFormula:

; HP calc
;	ld a, [wEnemyMonHP]
;	ld d, a
;	ld a, [wEnemyMonHP + 1]
;	ld e, a
;	push de
;	xor a
;	ldh [hMultiplicand], a
;	ld hl, wEnemyMonMaxHP
;	ld a, [hli]
;	ldh [hMultiplicand + 1], a
;	ld a, [hl]
;	ldh [hMultiplicand + 2], a
;	ld a, 3
;	ldh [hMultiplier], a
;	call Multiply
;	ld a, 4
;	ldh [hDivisor], a
;	ld b, 4 ; number of bytes in dividend
;	call Divide
;	ldh a, [hQuotient + 2]
;	ld h, a
;	ldh a, [hQuotient + 3]
;	ld l, a
;	pop de
	; de = Cur HP
	; hl = Max HP * 3/4
;	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
;	jr c, .enemyHas75PercentTo100PercentHP
;	ld a, [wEnemyMonMaxHP]
;	ld h, a
;	ld a, [wEnemyMonMaxHP + 1]
;	ld l, a
;	srl h
;	rr l
;	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
;	jr c, .enemyHas50PercentTo75PercentHP
;	srl h
;	rr l
;	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
;	jr c, .enemyHas25PercentTo50PercentHP
;	ld hl, 1
;	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
;	jr c, .enemyHas1HPto25PercentHP
;	; enemy has 1HP
;	ld b, 1 ; multiplier
;	ld c, 1 ; divisor
;	jr .calcCatchThreshold
;.enemyHas1HPto25PercentHP
;	ld b, 5 ; multiplier
;	ld c, 6 ; divisor
;	jr .calcCatchThreshold
;.enemyHas25PercentTo50PercentHP
;	ld b, 2 ; multiplier
;	ld c, 3 ; divisor
;	jr .calcCatchThreshold
;.enemyHas50PercentTo75PercentHP
;	ld b, 1 ; multiplier
;	ld c, 2 ; divisor
;	jr .calcCatchThreshold	
;.enemyHas75PercentTo100PercentHP
;	ld b, 1 ; multiplier
;	ld c, 3 ; divisor
;.calcCatchThreshold	
	xor a
	ldh [hMultiplicand], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	ld a, 170
	ldh [hMultiplier], a
	call Multiply
	ld a, [wEnemyMonMaxHP]
	ld b, a
	ld a, [wEnemyMonMaxHP + 1]
	ld c, 1
.loop
	srl b
	jr c, .lastRotate
	jr z, .foundEnd
.lastRotate
	rra
	sla c
	jr nc, .noOverflow
	ld c, $FF
.noOverflow
	jr .loop
.foundEnd
	and a
	jr nz, .notDividingBy0
	inc a
.notDividingBy0
	ldh [hDivisor], a
	ld b, 4 ; number of bytes in dividend
	call Divide
	ld a, c
	ldh [hDivisor], a
	call Divide
	ldh a, [hQuotient + 1]
	and a
	jr z, .curHPLowerOrEqualThanMaxHP1
	ld a, 170
	ldh [hQuotient + 3], a
.curHPLowerOrEqualThanMaxHP1	
	ldh a, [hQuotient + 2]
	and a
	jr z, .curHPLowerOrEqualThanMaxHP2
	ld a, 170
	ldh [hQuotient + 3], a
.curHPLowerOrEqualThanMaxHP2	
	ldh a, [hQuotient + 3]
	cp 171
	jr c, .curHPLowerOrEqualThanMaxHP3
	ld a, 170
.curHPLowerOrEqualThanMaxHP3
	ld b, a
	ld a, 255
	sub b
	ld b, a		; multiplier
	ld c, 255	; divisor
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand + 1], a
	ld a, [wEnemyMonActualCatchRate]
	ldh [hMultiplicand + 2], a
	call MultiplyCatchRateByBAndDivideByC
; read ball table
	ld a, [wcf91]
	cp MASTER_BALL
	jr z, .captured
	ld b, a
	ld hl, BallMultipliers
.checkLoop
	ld a, [hli]
	cp b
	jr z, .ballFound
	cp -1
	jr z, .failedToCapture
	inc hl
	inc hl
	jr .checkLoop
.ballFound
	ld b, [hl]
	inc hl
	ld c, [hl]
	call SpecialBallCheck
	call MultiplyCatchRateByBAndDivideByC
	
; read status
	ld b, 1
	ld c, 1
	ld a, [wEnemyMonStatus]
	and a
	jr z, .ailmentMultiplierFound
	ld b, 3
	ld c, 2
	and (1 << FRZ) | SLP_MASK
	jr z, .ailmentMultiplierFound
	ld b, 2
	ld c, 1
.ailmentMultiplierFound
	call MultiplyCatchRateByBAndDivideByC

; Check for Catching Charm
	ld b, CAPTURE_CHARM
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr z, .playerHasNoCharm
	ld b, 6
	ld c, 5
	call MultiplyCatchRateByBAndDivideByC
.playerHasNoCharm

; threshold check
	ldh a, [hQuotient]
	and a
	jr nz, .captured
	ldh a, [hQuotient + 1]
	and a
	jr nz, .captured
	ldh a, [hQuotient + 2]
	and a
	jr nz, .captured
	ldh a, [hQuotient + 3]
	cp 255
	jr z, .captured
	ld b, a
	call Random
	cp b
	jr c, .captured
.failedToCapture
	ld d, 0
	ret
.captured
	ld d, 1
	ret

MultiplyCatchRateByBAndDivideByC:
	ld a, b
	ldh [hMultiplier], a
	call Multiply
	ld a, c
	ldh [hDivisor], a
	ld b, 4 ; number of bytes in dividend
	call Divide
	ret

SpecialBallCheck:
	
	cp DUSK_BALL
	jr z, .handleDusk
	
	cp NET_BALL
	jr z, .handleNet

	ret
	
.handleDusk
	ld a, [wCurMap]
	ld d, a
	ld hl, DuskDungeons
.tableCheckLoop
	ld a, [hli]                  
	cp d                         
	ret z         
	inc a                      
	jr nz, .tableCheckLoop
	ld bc, $0101
	ret

.handleNet
	ld a, [wEnemyMonType]
	cp WATER
	ret z
	cp BUG
	ret z
	ld a, [wEnemyMonType2]
	cp WATER
	ret z
	cp BUG
	ret z
	ld bc, $0101
	ret

DuskDungeons:
	db VIRIDIAN_FOREST
	db MT_MOON_1F
	db MT_MOON_B1F
	db MT_MOON_B2F
	db DIGLETTS_CAVE
	db ROCK_TUNNEL_1F
	db ROCK_TUNNEL_B1F
	db POKEMON_TOWER_3F
	db POKEMON_TOWER_4F
	db POKEMON_TOWER_5F
	db POKEMON_TOWER_6F
	db POKEMON_TOWER_7F
	db POWER_PLANT
	db SEAFOAM_ISLANDS_1F
	db SEAFOAM_ISLANDS_B1F
	db SEAFOAM_ISLANDS_B2F
	db SEAFOAM_ISLANDS_B3F
	db SEAFOAM_ISLANDS_B4F
	db POKEMON_MANSION_1F
	db POKEMON_MANSION_2F
	db POKEMON_MANSION_3F
	db POKEMON_MANSION_B1F
	db VICTORY_ROAD_1F
	db VICTORY_ROAD_2F
	db VICTORY_ROAD_3F
	db CERULEAN_CAVE_1F
	db CERULEAN_CAVE_2F
	db CERULEAN_CAVE_B1F
	db MT_MOON_B3F
	db MT_MOON_B4F
	db MT_MOON_B5F
	db -1 ; end

BallMultipliers:
; 	db ITEM_ID, Numerator, Denominator
	db POKE_BALL   , 1, 1	; x1
	db GREAT_BALL  , 3, 2	; x1.5
	db ULTRA_BALL  , 2, 1	; x2
	db SAFARI_BALL , 5, 2   ; x2.5
	db DUSK_BALL   , 3, 1   ; x3
	db NET_BALL    , 3, 1   ; x3
	db -1 ; end
