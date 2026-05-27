; function to adjust the base damage of an attack to account for type effectiveness
AdjustDamageForMoveType:
; values for player turn
	ld hl, wBattleMonType
	ld a, [hli]
	ld b, a    ; b = type 1 of attacker
	ld c, [hl] ; c = type 2 of attacker
	ld hl, wEnemyMonType
	ld a, [hli]
	ld d, a    ; d = type 1 of defender
	ld e, [hl] ; e = type 2 of defender
	ld a, [wPlayerMoveType]
	ld [wMoveType], a
	ldh a, [hWhoseTurn]
	and a
	jr z, .next
; values for enemy turn
	ld hl, wEnemyMonType
	ld a, [hli]
	ld b, a    ; b = type 1 of attacker
	ld c, [hl] ; c = type 2 of attacker
	ld hl, wBattleMonType
	ld a, [hli]
	ld d, a    ; d = type 1 of defender
	ld e, [hl] ; e = type 2 of defender
	ld a, [wEnemyMoveType]
	ld [wMoveType], a
.next
	ld a, [wMoveType]
	cp b ; does the move type match type 1 of the attacker?
	jr z, .sameTypeAttackBonus
	cp c ; does the move type match type 2 of the attacker?
	jr z, .sameTypeAttackBonus
	jr .skipSameTypeAttackBonus
.sameTypeAttackBonus
; if the move type matches one of the attacker's types
	ld hl, wDamage + 1
	ld a, [hld]
	ld h, [hl]
	ld l, a    ; hl = damage
	ld b, h
	ld c, l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	add hl, bc ; hl = floor(1.5 * damage)
; store damage
	ld a, h
	ld [wDamage], a
	ld a, l
	ld [wDamage + 1], a
	ld hl, wDamageMultipliers
	set 7, [hl]
.skipSameTypeAttackBonus
	ld a, [wMoveType]
	ld b, a
	ld hl, TypeEffects
.loop
	ld a, [hli] ; a = "attacking type" of the current type pair
	cp $ff
	jr z, .done
	cp b ; does move type match "attacking type"?
	jr nz, .nextTypePair
	ld a, [hl] ; a = "defending type" of the current type pair
	cp d ; does type 1 of defender match "defending type"?
	jr z, .matchingPairFound
	cp e ; does type 2 of defender match "defending type"?
	jr z, .matchingPairFound
	jr .nextTypePair
.matchingPairFound
; if the move type matches the "attacking type" and one of the defender's types matches the "defending type"
	push hl
	push bc
	inc hl
	ld a, [wDamageMultipliers]
	and $80
	ld b, a
	ld a, [hl] ; a = damage multiplier
	ldh [hMultiplier], a
	and a  ; cp NO_EFFECT
	jr z, .gotMultiplier
	cp NOT_VERY_EFFECTIVE
	jr nz, .nothalf
	ld a, [wDamageMultipliers]
	and $7f
	srl a
	jr .gotMultiplier
.nothalf
	cp SUPER_EFFECTIVE
	jr nz, .gotMultiplier
	ld a, [wDamageMultipliers]
	and $7f
	sla a
.gotMultiplier
	add b
	ld [wDamageMultipliers], a
	xor a
	ldh [hMultiplicand], a
	ld hl, wDamage
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hld]
	ldh [hMultiplicand + 2], a
	call Multiply
	ld a, 10
	ldh [hDivisor], a
	ld b, $04
	call Divide
	ldh a, [hQuotient + 2]
	ld [hli], a
	ld b, a
	ldh a, [hQuotient + 3]
	ld [hl], a
	or b ; is damage 0?
	jr nz, .skipTypeImmunity
.typeImmunity
; if damage is 0, make the move miss
; this only occurs if a move that would do 2 or 3 damage is 0.25x effective against the target
	inc a
	ld [wMoveMissed], a
.skipTypeImmunity
	pop bc
	pop hl
.nextTypePair
	inc hl
	inc hl
	jp .loop
.done
	ret

; function to tell how effective the type of an enemy attack is on the player's current pokemon
; edited: it will now take into account various levels of effectiveness
; the result is stored in [wTypeEffectiveness]
; (0 is not effective, 1 double not effective, 2 not effective, 4 neutral, 8 super effective, 16 double super effective)
AIGetTypeEffectiveness:
	; b = type 1 of defending pokémon / c = type 2 of defending pokémon / d = type of attacking move
	call UncompressDE
	ld a, 10
	ld [wTypeEffectiveness], a ; initialize to neutral effectiveness
	ld hl, TypeEffects
	push hl
	push bc ; to preserve the type 1
.loop1
	ld a, [hli]
	cp $ff
	jp z, .exitLoop1
	cp d                      ; match the type of the move
	jr nz, .nextTypePair11
	ld a, [hli]
	cp b                      ; match with type 1 of player's pokemon
	jr z, .done1
	jr .nextTypePair21
.nextTypePair11
	inc hl
.nextTypePair21
	inc hl
	jr .loop1
.done1
	ld a, [hl]
	ld [wTypeEffectiveness], a ; store damage multiplier
.exitLoop1
	ld a, 5 ; we divide by 5
	ldh [hDivisor], a
	ld a, [wTypeEffectiveness]
	ldh [hDividend], a
	ld b, 1
	call Divide ; we divide the type effectivness by 5: 0 for not effective, 1 for not very, 2 for normal, 4 for super
	; now [hQuotient + 3] contains the scaled-down effectiveness
; testing
	ldh a, [hQuotient]
	ldh a, [hQuotient+1]
	ldh a, [hQuotient+2]
	ldh a, [hQuotient+3]

	pop bc ; to restore the type 1
	pop hl ; restore the pointer to the effectiveness chart

	ld a, c
	cp b
	jr nz, .secondTypeCheck
; we don't check the same type twice for a monotype mon
	ldh a, [hQuotient+3]
	add a ; we double the current value, i.e. we multiply by 2, which happens to be the neutral damage of the "copy" of the only one type we have
	jr .completing

.secondTypeCheck
	ld b, a ; b = type 2 of player's pokemon

	ld a, 10
	ld [wTypeEffectiveness], a ; initialize to neutral effectiveness (in case we find no matches)
.loop2
	ld a, [hli]
	cp $ff
	jp z, .exitLoop2
	cp d                      ; match the type of the move
	jr nz, .nextTypePair12
	ld a, [hli]
	cp b                      ; match with type 2 of player's pokemon
	jr z, .done2
	jr .nextTypePair22
.nextTypePair12
	inc hl
.nextTypePair22
	inc hl
	jr .loop2
.done2
	ld a, [hl]
	ld [wTypeEffectiveness], a ; store damage multiplier
.exitLoop2

	xor a
	ldh [hMultiplicand], a
	ld a, [wTypeEffectiveness]
	ldh [hMultiplier], a
	call Multiply ; we have Effectivness1 / 5 * Effectivness2, which is at most 4*20=80<255, so still 1 byte

; testing
	ldh a, [hProduct]
	ldh a, [hProduct+1]
	ldh a, [hProduct+2]
	ldh a, [hProduct+3]

	ld a, 5
	ldh [hDivisor], a
	ld b, 4
	call Divide

; testing
	ldh a, [hQuotient]
	ldh a, [hQuotient+1]
	ldh a, [hQuotient+2]
	ldh a, [hQuotient+3]

	ldh a, [hQuotient + 3] ; now a contains Effectivness1 / 5 * Effectivness2 / 5:
						   ; 0 for not effective
						   ; 1 for 1/4
						   ; 2 for 1/2
						   ; 4 for 1
						   ; 8 for 2
						   ; 16 for 4
.completing
	ld [wTypeEffectiveness], a
	ret

UncompressDE:
	; b = type 1 def poke, c = type 2 def poke, d = attack type
	ld a, d
	srl a
	srl a
	ld b, a
	ld a, d
	and %00011
	sla a
	sla a
	sla a
	ld c, a
	ld a, e
	and %11100000
	rlc a
	rlc a
	rlc a
	add c
	ld c, a
	ld a, e
	and %11111
	ld d, a
	ret

INCLUDE "data/types/type_matchups.asm"

