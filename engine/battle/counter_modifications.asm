; c = 0 not counterable, c = 1 counterable
; d = 0 player counter, e = 1 enemy counter
SetCounterDamage:
	ld a, d
	and a
	ret z ; if it was confusion or self damage from hi-jump kick
	ld a, e
	and a
	jr z, .playerCounter
	ld a, [wPlayerMoveType]
	jr .typeFound
.playerCounter
	ld a, [wEnemyMoveType]
.typeFound
	cp NORMAL
	jr z, .validCounter
	cp FIGHTING
	jr z, .validCounter
	ld hl, wVermilionBeachFlags
	ld a, e
	and a
	jr z, .playerCounter3
	res 6, [hl]
	ld hl, wCounterDamageEnemy
	jr .done
.playerCounter3
	res 5, [hl]
	ld hl, wCounterDamagePlayer
.done
	xor a
	ld [hli], a
	ld [hl], a
	ret
.validCounter
	ld a, [wDamage]
	ld b, a
	ld a, [wDamage+1]
	ld c, a
	sla c
	rl b
	jr nc, .noOverflow
	lb bc, -1, -1
.noOverflow
	ld hl, wVermilionBeachFlags
	ld a, e
	and a
	jr z, .playerCounter2
	set 6, [hl]
	ld hl, wCounterDamageEnemy
	jr .saveAddressFound
.playerCounter2
	set 5, [hl]
	ld hl, wCounterDamagePlayer
.saveAddressFound
	ld a, b
	ld [hli], a
	ld a, c
	ld [hl], a
	ret
	
ResetCounterDamage:
	xor a
	ld hl, wVermilionBeachFlags
	bit 5, [hl]
	jr nz, .playerCounterActive
	ld [wCounterDamagePlayer], a
	ld [wCounterDamagePlayer+1], a
.playerCounterActive
	res 5, [hl]
	bit 6, [hl]
	jr nz, .enemyCounterActive
	ld [wCounterDamageEnemy], a
	ld [wCounterDamageEnemy+1], a
.enemyCounterActive
	res 6, [hl]
	ret
