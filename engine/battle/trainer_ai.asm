; creates a set of moves that may be used and returns its address in hl
; unused slots are filled with 0, all used slots may be chosen with equal probability
AIEnemyTrainerChooseMoves:
	ld a, 40
	ld hl, wBuffer ; init temporary move selection array. Only the moves with the lowest numbers are chosen in the end
	ld [hli], a   ; move 1
	ld [hli], a   ; move 2
	ld [hli], a   ; move 3
	ld [hl], a    ; move 4
	ld a, [wEnemyDisabledMove] ; forbid disabled move (if any)
	swap a
	and $f
	jr z, .noMoveDisabled
	ld hl, wBuffer
	dec a
	ld c, a
	ld b, $0
	add hl, bc    ; advance pointer to forbidden move
	ld [hl], 88  ; forbid (highly discourage) disabled move
.noMoveDisabled
	ld hl, TrainerClassMoveChoiceModifications
	ld a, [wTrainerClass]
	ld b, a
.loopTrainerClasses
	dec b
	jr z, .readTrainerClassData
.loopTrainerClassData
	ld a, [hli]
	and a
	jr nz, .loopTrainerClassData
	jr .loopTrainerClasses
.readTrainerClassData
	ld a, [hl]
	and a
	jp z, .useOriginalMoveSet
	push hl
.nextMoveChoiceModification
	pop hl
	ld a, [hli]
	and a
	jr z, .loopFindMinimumEntries
	push hl
	ld hl, AIMoveChoiceModificationFunctionPointers
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc    ; skip to pointer
	ld a, [hli]   ; read pointer into hl
	ld h, [hl]
	ld l, a
	ld de, .nextMoveChoiceModification  ; set return address
	push de
	jp hl         ; execute modification function
.loopFindMinimumEntries ; all entries will be decremented sequentially until one of them is zero
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.loopDecrementEntries
	ld a, [de]
	inc de
	and a
	jr z, .loopFindMinimumEntries
	dec [hl]
	jr z, .minimumEntriesFound
	inc hl
	dec c
	jr z, .loopFindMinimumEntries
	jr .loopDecrementEntries
.minimumEntriesFound
	ld a, c
.loopUndoPartialIteration ; undo last (partial) loop iteration
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .loopUndoPartialIteration
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.filterMinimalEntries ; all minimal entries now have value 1. All other slots will be disabled (move set to 0)
	ld a, [de]
	and a
	jr nz, .moveExisting
	ld [hl], a
.moveExisting
	ld a, [hl]
	dec a
	jr z, .slotWithMinimalValue
	xor a
	ld [hli], a     ; disable move slot
	jr .next
.slotWithMinimalValue
	ld a, [de]
	ld [hli], a     ; enable move slot
.next
	inc de
	dec c
	jr nz, .filterMinimalEntries
	ld hl, wBuffer    ; use created temporary array as move set
	ret
.useOriginalMoveSet
	ld hl, wEnemyMonMoves    ; use original move set
	ret

AIMoveChoiceModificationFunctionPointers:
	dw AIMoveChoiceModification1
	dw AIMoveChoiceModification2
	dw AIMoveChoiceModification3
	dw AIMoveChoiceModification4 ; unused, does nothing

; discourages moves that cause no damage but only a status ailment if player's mon already has one
AIMoveChoiceModification1:
	;;
	call AIHandleDamagingMoves
	call AIHandleStatusMoves
	ret
	;;
;	ld a, [wBattleMonStatus]
;	and a
;	ret z ; return if no status ailment on player's mon
;	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
;	ld de, wEnemyMonMoves ; enemy moves
;	ld b, NUM_MOVES + 1
;.nextMove
;	dec b
;	ret z ; processed all 4 moves
;	inc hl
;	ld a, [de]
;	and a
;	ret z ; no more moves in move set
;	inc de
;	call ReadMove
;	ld a, [wEnemyMovePower]
;	and a
;	jr nz, .nextMove
;	ld a, [wEnemyMoveEffect]
;	push hl
;	push de
;	push bc
;	ld hl, StatusAilmentMoveEffects
;	ld de, 1
;	call IsInArray
;	pop bc
;	pop de
;	pop hl
;	jr nc, .nextMove
;	ld a, [hl]
;	add $5 ; heavily discourage move
;	ld [hl], a
;	jr .nextMove

;StatusAilmentMoveEffects:
;	db EFFECT_01 ; unused sleep effect
;	db SLEEP_EFFECT
;	db POISON_EFFECT
;	db PARALYZE_EFFECT
;	db -1 ; end

; slightly encourage moves with specific effects.
; in particular, stat-modifying moves and other move effects
; that fall in-between
AIMoveChoiceModification2:
	;;
	ret
	;;
;	ld a, [wAILayer2Encouragement]
;	cp $1
;	ret nz
;	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
;	ld de, wEnemyMonMoves ; enemy moves
;	ld b, NUM_MOVES + 1
;.nextMove
;	dec b
;	ret z ; processed all 4 moves
;	inc hl
;	ld a, [de]
;	and a
;	ret z ; no more moves in move set
;	inc de
;	call ReadMove
;	ld a, [wEnemyMoveEffect]
;	cp ATTACK_UP1_EFFECT
;	jr c, .nextMove
;	cp BIDE_EFFECT
;	jr c, .preferMove
;	cp ATTACK_UP2_EFFECT
;	jr c, .nextMove
;	cp POISON_EFFECT
;	jr c, .preferMove
;	jr .nextMove
;.preferMove
;	dec [hl] ; slightly encourage this move
;	jr .nextMove

; encourages moves that are effective against the player's mon (even if non-damaging).
; discourage damaging moves that are ineffective or not very effective against the player's mon,
; unless there's no damaging move that deals at least neutral damage
AIMoveChoiceModification3:
	;;
	ret
	;;
;	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
;	ld de, wEnemyMonMoves ; enemy moves
;	ld b, NUM_MOVES + 1
;.nextMove
;	dec b
;	ret z ; processed all 4 moves
;	inc hl
;	ld a, [de]
;	and a
;	ret z ; no more moves in move set
;	inc de
;	call ReadMove
;	push hl
;	push bc
;	push de
;	callfar AIGetTypeEffectiveness
;	pop de
;	pop bc
;	pop hl
;	ld a, [wTypeEffectiveness]
;	cp $10
;	jr z, .nextMove
;	jr c, .notEffectiveMove
;	dec [hl] ; slightly encourage this move
;	jr .nextMove
;.notEffectiveMove ; discourages non-effective moves if better moves are available
;	push hl
;	push de
;	push bc
;	ld a, [wEnemyMoveType]
;	ld d, a
;	ld hl, wEnemyMonMoves  ; enemy moves
;	ld b, NUM_MOVES + 1
;	ld c, $0
;.loopMoves
;	dec b
;	jr z, .done
;	ld a, [hli]
;	and a
;	jr z, .done
;	call ReadMove
;	ld a, [wEnemyMoveEffect]
;	cp SUPER_FANG_EFFECT
;	jr z, .betterMoveFound ; Super Fang is considered to be a better move
;	cp SPECIAL_DAMAGE_EFFECT
;	jr z, .betterMoveFound ; any special damage moves are considered to be better moves
;	cp FLY_EFFECT
;	jr z, .betterMoveFound ; Fly is considered to be a better move
;	ld a, [wEnemyMoveType]
;	cp d
;	jr z, .loopMoves
;	ld a, [wEnemyMovePower]
;	and a
;	jr nz, .betterMoveFound ; damaging moves of a different type are considered to be better moves
;	jr .loopMoves
;.betterMoveFound
;	ld c, a
;.done
;	ld a, c
;	pop bc
;	pop de
;	pop hl
;	and a
;	jr z, .nextMove
;	inc [hl] ; slightly discourage this move
;	jr .nextMove
AIMoveChoiceModification4:
	ret

;;
AIHandleDamagingMoves:
	xor a
	ld [wDamage2], a ; initialise variable
	ld [wDamage2+1], a ; initialise variable
	ld [wPrioMoveMostDamage], a ; initialise variable
	ld [wPrioMoveMostDamage+1], a ; initialise variable
	ld [wMostDamage], a ; initialise variable
	ld [wMostDamage+1], a ; initialise variable
	ld [wGuaranteedMostDamage], a ; initialise variable
	ld [wGuaranteedMostDamage+1], a ; initialise variable
	ld [wDamageBuffer], a ; initialise variable
	ld [wDamageBuffer+1], a ; initialise variable
	ld [wHasDamagingPhysicalMove], a ; initialise variable
	ld [wHasDamagingSpecialMove], a ; initialise variable
	ld [wEncourageStatusMove], a ; initialise variable
	ld [wFishForCrits], a ; initialise variable
	call FishForCrits
	call GetVarsForEncourage
	call AIEncourageDamagingMoves
	ret

FishForCrits:
	ld hl, TrainerRiskTakingTable
	ld a, [wTrainerClass]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp 1
	ret nz
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld a, [wMonHBaseSpeed]
	ld b, a
	ld a, [wEnemyBattleStatus2]
	bit GETTING_PUMPED, a        ; test for focus energy
	jr z, .noFocusEnergyUsed
	sla b                        ; (effective (base speed*2))
	jr nc, .focusEnergyUsed
	ld b, $ff                    ; cap at 255/256
	jr .noFocusEnergyUsed
.focusEnergyUsed
	sla b                        ; (effective ((base speed*2)*2))
	jr nc, .noFocusEnergyUsed
	ld b, $ff                    ; cap at 255/256
.noFocusEnergyUsed
	call Random
	cp b
	ret nc
	ld a, 1
	ld [wFishForCrits], a   ; set fish for crit flag
	ret

GetVarsForEncourage:
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.varsGetLoop
	dec b
	ret z ; processed all 4 moves
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	;
	push bc
	push de
	;
	ld a, [wEnemyMovePower]
	cp 0
	jr z, .goToNext
	; EnemyMove has more than 0 BP
	call FlagDamagingMove
	call CheckIfSemiInvulerable
	and a
	jr nz, .goToNext
	; player not invulnerable
	ld a, [wEnemyMoveEffect]
	cp RAGE_EFFECT
	jr z, .goToNext
	cp OHKO_EFFECT
	jr z, .goToNext
	; ignore Ohko and Rage
	call CheckIfLastMon
	and a
	jr z, .skipHandleJumpKickAndExplosion
	; last mon
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jr z, .goToNext
	cp JUMP_KICK_EFFECT
	jr nz, .skipHandleJumpKickAndExplosion
	ld a, [wEnemyMonHP]
	and a
	jr nz, .skipHandleJumpKickAndExplosion
	ld a, [wEnemyMonHP+1]
	cp 2
	jr c, .goToNext ; if only 1hp left don't calc
.skipHandleJumpKickAndExplosion
	call CheckIfRecoil
	and a
	jr nz, .goToNext
	; handle recoil
	call CalcMoveMinDamage
	call SaveDamageIfPrio
	call SaveGuaranteedMostDamage
	call CalcMoveMaxDamage
	call SaveMostDamage
.goToNext
	;
	pop de
	pop bc
	;
	jr .varsGetLoop

AIEncourageDamagingMoves:
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.moveCheckLoop
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	;
	push bc
	push de
	push hl
	;
	ld a, [wEnemyMovePower]
	cp 0
	jp z, .checkNextMove
	; EnemyMove has more than 0 BP, calc accuracy
	call CheckIfSemiInvulerable
	and a
	jp z, .skipHandleSemiInvulnerable
	pop hl
	ld b, 6 ; disc move by 6
	ld a, [hl]
	add b
	ld [hl], a
	push hl
.skipHandleSemiInvulnerable
	; player not invulnerable
	ldh a, [hWhoseTurn] 
	push af
	ld a, 1
	ldh [hWhoseTurn], a
	callfar CalcHitChance
	pop af
	ldh [hWhoseTurn], a
	; calc Damage
	call CalcMoveMinDamage
	call CheckIfDamageGreaterThanZero
	and a
	jr nz, .skipHandleZeroDamage
	; wDamage2 is zero
	pop hl
	call HandleZeroDamageMoves
	push hl
	jp .checkNextMove
.skipHandleZeroDamage
	; handle Rage
	ld a, [wEnemyMoveEffect]
	cp RAGE_EFFECT
	jr nz, .skipHandleRage
	call CheckIfMostDamageGreaterThanZero
	and a
	jp z, .checkNextMove
	; wMostDamage greater than zero
	pop hl
	ld b, 3 ; disc move by 3
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jp .checkNextMove
.skipHandleRage
	call CheckIfLastMon
	and a
	jr z, .skipHandleJumpKickAndExplosion2
	; last mon
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jp z, .discourageSelfKO
	cp JUMP_KICK_EFFECT
	jr nz, .skipHandleJumpKickAndExplosion2
	ld a, [wEnemyMonHP]
	and a
	jr nz, .skipHandleJumpKickAndExplosion2
	ld a, [wEnemyMonHP+1]
	cp 2
	jp nc, .skipHandleJumpKickAndExplosion2
.discourageSelfKO
	; discourage Jump Kick and Explosion
	pop hl
	ld b, 9 ; disc move by 9
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jp .checkNextMove
.skipHandleJumpKickAndExplosion2
	call CheckIfRecoil
	and a
	jr nz, .discourageSelfKO
	; desperado check
	ld de, wBattleMonSpeed
	ld hl, wEnemyMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr nc, .skipDesperado
	; EnemyMon slower or speed tied to BattleMon
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	srl d
	rr e ; max hp / 4
	; de = EnemyMon HP Threshold
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp nc, .skipDesperado ; too healthy
	ld a, [wEnemyMoveNum]
	ld c, a
	ld hl, PriorityMoves2
.tableCheckLoop2
	ld a, [hli]                  
	cp c                         
	jp z, .prioMove         
	inc a                      
	jr nz, .tableCheckLoop2    
	jr .skipDesperado
.prioMove
	ld a, 80 percent + 1
	ld b, a
	call Random
	cp b
	jp c, .encourageDesperado
.skipDesperado
	; check accuracy
	ld a, [wEnemyMoveAccuracy]
	cp 255
	jr z, .perfectAcc
	ld b, a
	call Random
	cp b
	jp nc, .encourageIfMostDamage
.perfectAcc
	; Accuracy checked, handle ohko
	ld a, [wEnemyMoveEffect]
	cp OHKO_EFFECT
	jr nz, .skipHandleOhko
	pop hl
	ld b, 27 ; encourage move by 27
	ld a, [hl]
	sub b
	ld [hl], a
	call FurtherEncourageIfPerfectAccuracy
	call FurtherEncourageIfPerfectAccuracy
	push hl
	jp .checkNextMove
.skipHandleOhko
	; handle trapping move
	cp TRAPPING_EFFECT
	jp z, .handleTrappingEffect
	call CheckIfKill
	and a
	jr z, .checkAvrDamage
	pop hl
	call FurtherEncourageIfPerfectAccuracy
	push hl
.encourageMove
	pop hl
	ld b, 27 ; encourage move by 27
	ld a, [hl]
	sub b
	ld [hl], a
	call FurtherEncourageIfPerfectAccuracy
	call FurtherEncourageIfPrioMoveAndSlower
	call DiscourageNotPreferedMoves
	push hl
	jp .checkNextMove
.checkAvrDamage
	; Hyper Beam leaves here
	ld a, [wEnemyMoveEffect]
	cp HYPER_BEAM_EFFECT
	jr nz, .skipHandleHyperBeam
	call CheckIfMostDamageGreaterThanZero
	and a
	jp z, .checkNextMove
	; wMostDamage greater than zero
	pop hl
	ld b, 3 ; disc move by 3
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jp .checkNextMove
.skipHandleHyperBeam
	;
	call CalcMoveAvrDamage
	call CheckIfKill
	and a
	jr z, .checkMaxDamage
	ld a, 1
	ld hl, TrainerRiskTakingTable
	call GetChanceThreshold
	ld b, a
	call Random
	cp b
	jp nc, .check2HKO
	pop hl
	ld b, 6 ; disc move by 6 (later encouraged by 27 so a total of 21 encourage)
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jr .encourageMove
.checkMaxDamage
	call CalcMoveMaxDamage
	call CheckIfKill
	and a
	jr z, .check2HKO
	ld a, -1
	ld hl, TrainerRiskTakingTable
	call GetChanceThreshold
	ld b, a
	call Random
	cp b
	jp nc, .check2HKO
	pop hl
	ld b, 12 ; disc move by 12 (later encouraged by 27 so a total of 15 encourage)
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jr .encourageMove
.check2HKO
	ld a, [wEnemyMoveAccuracy]
	cp 255
	jr nz, .encourageIfMostDamage
	call CalcMoveMinDamage
	call CheckIfPrioDamageGreaterThanZero
	and a
	jr z, .skipPrioCheck
	; wPrioMoveMostDamage greater than zero
	call AddPrioDamage
	call CheckIfKill
	and a
	jr z, .skipPrioCheck2
	pop hl
	ld b, 12 ; encourage move by 12
	ld a, [hl]
	sub b
	ld [hl], a
	call FurtherEncourageIfSecondaryEffect
	call DiscourageNotPreferedMoves
	push hl
	jr .checkNextMove
.skipPrioCheck2
	call SubstractAddedDamage
.skipPrioCheck
	call CheckIfGuaranteedMostDamageGreaterThanZero
	and a
	jr z, .encourageIfMostDamage
	; wGuaranteedMostDamage greater than zero
	call AddGuaranteedMostDamage
	call CheckIfKill
	and a
	jr z, .encourageIfMostDamage
	pop hl
	ld b, 9 ; encourage move by 9
	ld a, [hl]
	sub b
	ld [hl], a
	call FurtherEncourageIfSecondaryEffect
	call DiscourageNotPreferedMoves
	push hl
	jr .checkNextMove
.encourageIfMostDamage
	call CalcMoveMaxDamage
	call CheckIfMostDamageGreaterThanZero
	and a
	jr z, .checkNextMove
	; wMostDamage greater than zero
	ld a, [wEnemyMoveEffect]
	cp HYPER_BEAM_EFFECT
	jr nz, .skipHandleHyperBeam2
	pop hl
	ld b, 3 ; disc move by 3
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jr .checkNextMove
.skipHandleHyperBeam2
	cp OHKO_EFFECT
	jr z, .checkNextMove
	call CheckIfDamageEqualThanMostDamage
	and a
	jr z, .checkNextMove
	pop hl
	ld b, 3 ; encourage move by 3
	ld a, [hl]
	sub b
	ld [hl], a
	call FurtherEncourageIfSecondaryEffect
	call DiscourageNotPreferedMoves
	push hl
.checkNextMove
	;
	pop hl
	pop de
	pop bc
	;
	jp .moveCheckLoop
.handleTrappingEffect
	ld de, wEnemyMonSpeed
	ld hl, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr c, .enemyIsFaster
	pop hl
	ld b, 10 ; encourage move by 10
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jr .checkNextMove
.enemyIsFaster
	pop hl
	ld b, 30 ; encourage move by 30
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jr .checkNextMove
.encourageDesperado
	pop hl
	ld b, 36 ; encourage move by 36
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jr .checkNextMove

AIHandleStatusMoves:
	; Status = 0 dmg moves
	ld hl, TrainerStatusFrequencyTable
	ld a, [wTrainerClass]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp 1
	ld a, [wAILayer2Encouragement]
	jr z, .highStatusChance
	jr c, .midStatusChance
	; lowStatusChance
	and a
	jr nz, .secondTurnLSC
	ld a, 50 percent + 1
	jr .statusChanceFound
.secondTurnLSC
	ld a, 10 percent + 1
	jr .statusChanceFound
.midStatusChance
	and a
	jr nz, .secondTurnMSC
	ld a, 70 percent + 1
	jr .statusChanceFound
.secondTurnMSC
	ld a, 30 percent + 1
	jr .statusChanceFound
.highStatusChance
	and a
	jr nz, .secondTurnHSC
	ld a, 90 percent + 1
	jr .statusChanceFound
.secondTurnHSC
	ld a, 50 percent + 1
.statusChanceFound
	ld b, a
	call Random
	cp b
	jr nc, .dontFlagForEncourage
	ld a, 1
	ld [wEncourageStatusMove], a
.dontFlagForEncourage
	call CheckIfMoreThan50PercentHPLeft
	and a
	jr nz, .dontUnflag
	; only use status moves if more than 50% health
	ld a, 0
	ld [wEncourageStatusMove], a
.dontUnflag
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.moveCheckLoop2
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	;
	push bc
	push de
	push hl
	;
	ld a, [wEnemyMovePower]
	and a
	jp nz, .checkNextMove2
	; check move effect and if conditions for encourage are met
	
	ld a, [wEnemyMoveEffect]
	
	cp SPLASH_EFFECT						; always discourage splash
	jp z, .discourageDoNothingMove
	
	cp HEAL_EFFECT
	jp z, .handleHealEffect
	
	cp SUBSTITUTE_EFFECT
	jp z, .handleSubEffect
	
	cp SWITCH_AND_TELEPORT_EFFECT
	jp z, .handleSwitchAndTele
	
	cp ACCURACY_DOWN1_EFFECT
	jp z, .handleAccDownEffect
	
	cp EVASION_UP1_EFFECT
	jp z, .handleEvaUpEffect
	
	cp LIGHT_SCREEN_EFFECT
	jp z, .handleLightScreenEffect
	
	cp REFLECT_EFFECT
	jp z, .handleReflectEffect
	
	cp CONFUSION_EFFECT
	jp z, .handleConfusionEffect
	
	cp DISABLE_EFFECT
	jp z, .handleDisableEffect
	
	cp FOCUS_ENERGY_EFFECT
	jp z, .handleFocusEnergyEffect
	
	cp LEECH_SEED_EFFECT
	jp z, .handleLeechSeedEffect
	
	cp MIST_EFFECT
	jp z, .handleMistEffect
	
	cp PARALYZE_EFFECT
	jp z, .handleAilmentEffect
	
	cp POISON_EFFECT
	jp z, .handleAilmentEffect
	
	cp SLEEP_EFFECT
	jp z, .handleSleepEffect
	
	cp SPEED_DOWN1_EFFECT
	jp z, .handleSpeedDownEffect
	
	cp SPEED_UP2_EFFECT
	jp z, .handleSpeedUpEffect
	
	cp HAZE_EFFECT
	jp z, .handleHazeEffect
	
	cp SPECIAL_UP1_EFFECT
	jp z, .handleSpclUpEffect
	
	cp SPECIAL_UP2_EFFECT
	jp z, .handleSpclUpEffect
	
	cp ATTACK_UP1_EFFECT
	jp z, .handleAtkUpEffect
	
	cp ATTACK_UP2_EFFECT
	jp z, .handleAtkUpEffect
	
	cp DEFENSE_DOWN1_EFFECT
	jp z, .handleDefDownEffect
	
	cp DEFENSE_DOWN2_EFFECT
	jp z, .handleDefDownEffect
	
	cp ATTACK_DOWN1_EFFECT
	jp z, .handleAtkDownEffect
	
	cp DEFENSE_UP1_EFFECT
	jp z, .handleDefUpEffect
	
	cp DEFENSE_UP2_EFFECT
	jp z, .handleDefUpEffect
	
	cp CONVERSION_EFFECT
	jp z, .handleConversionEffect
	
	cp MIRROR_MOVE_EFFECT
	jp z, .handleMirrorMoveEff
	
.encourageStatusMove
	; encourage using status move over most damaging (non kill, non 2HKO) move
	pop hl
	ld a, [wEncourageStatusMove]
	and a
	jr z, .skipMainEncourage
	ld b, 6 ; encourage move by 6
	ld a, [hl]
	sub b
	ld [hl], a
.skipMainEncourage
	call FurtherEncourageGoodStatusMoves
	call FurtherDiscourageBadStatusMoves
	push hl
.checkNextMove2
	;
	pop hl
	pop de
	pop bc
	;
	jp .moveCheckLoop2
.handleSwitchAndTele
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jr nz, .encourageStatusMove
.discourageDoNothingMove
	pop hl
	ld b, 6 ; discourage move by 6
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jr .checkNextMove2
.handleAccDownEffect
	ld hl, wPlayerBattleStatus2
	bit PROTECTED_BY_MIST, [hl]
	jr nz, .discourageDoNothingMove ; player protected by mist
	ld a, 4 ; ACC
	ld b, 1 ; MIN
	call CheckIfPlayerStatModIsMinOrMax
	and a
	jr nz, .discourageDoNothingMove ; player's accuracy already -6
	jr .encourageStatusMove
.handleEvaUpEffect
	ld a, 5 ; EVA
	ld b, 13 ; MAX
	call CheckIfEnemyStatModIsMinOrMax
	and a
	jr nz, .discourageDoNothingMove ; evasion already +6
	jr .encourageStatusMove
.handleLightScreenEffect
	ld hl, wEnemyBattleStatus3
	bit HAS_LIGHT_SCREEN_UP, [hl]
	jr nz, .discourageDoNothingMove ; light screen already up
	call ComparePlayerAtkAndSpcl
	jr c, .encourageStatusMove
	; Player's pokémon special is equal or higher than it's attack
	pop hl
	ld b, 1 ; encourage move by 1 (later encouraged by 6)
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jr .encourageStatusMove
.handleReflectEffect
	ld hl, wEnemyBattleStatus3
	bit HAS_REFLECT_UP, [hl]
	jr nz, .discourageDoNothingMove ; reflect already up
	call ComparePlayerAtkAndSpcl
	jr nc, .encourageStatusMove
	; Player's pokémon attack is equal or higher than it's special
	pop hl
	ld b, 1 ; encourage move by 1 (later encouraged by 6)
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jr .encourageStatusMove
.handleConfusionEffect
	ld hl, wPlayerBattleStatus1
	bit CONFUSED, [hl]
	jr nz, .discourageDoNothingMove ; player already confused
	jr .encourageStatusMove
.handleDisableEffect	
	ld a, [wPlayerDisabledMove]
	and a
	jr nz, .discourageDoNothingMove ; player has a disabled move
	jp .encourageStatusMove
.handleFocusEnergyEffect
	ld hl, wEnemyBattleStatus2
	bit GETTING_PUMPED, [hl]
	jr nz, .discourageDoNothingMove ; already pumped up
	jp .encourageStatusMove
.handleLeechSeedEffect
	ld hl, wPlayerBattleStatus2
	bit SEEDED, [hl]
	jr nz, .discourageDoNothingMove ; player already seeded
	jp .encourageStatusMove
.handleMistEffect
	ld hl, wEnemyBattleStatus2
	bit PROTECTED_BY_MIST, [hl]
	jr nz, .discourageDoNothingMove ; already protected by mist
	jp .encourageStatusMove
.handleSleepEffect
	ld a, [wPartyCount]
	ld d, a
	ld hl, wPartyMon1Status
.sleepCheckLoop
	ld a, [hl]
	and SLP_MASK
	jp nz, .discourageDoNothingMove ; player already has a sleeping mon
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	dec d
	jr nz, .sleepCheckLoop
	; no player mon is sleeping go to regular ailment check
.handleAilmentEffect
	ld a, [wBattleMonStatus]
	and a
	jp nz, .discourageDoNothingMove ; player has an ailment already
	jp .encourageStatusMove
.handleSpeedDownEffect
	ld hl, wPlayerBattleStatus2
	bit PROTECTED_BY_MIST, [hl]
	jp nz, .discourageDoNothingMove ; player protected by mist
	ld a, 2 ; SPE
	ld b, 1 ; MIN
	call CheckIfPlayerStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; player speed already -6
	jr .checkSpeed
.handleSpeedUpEffect
	ld a, 2 ; SPE
	ld b, 13 ; MAX
	call CheckIfEnemyStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; speed already +6
.checkSpeed
	ld de, wEnemyMonSpeed
	ld hl, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	and a
	jp c, .discourageDoNothingMove ; EnemyMon already faster
	jp .encourageStatusMove
.handleHazeEffect
	ld hl, wPlayerMonStatMods
	ld c, 6
	ld d, 0
	ld e, 1
.checkStatModsLoop
	ld a, [hl]
	cp 8
	jp nc, .encourageStatusMove ; player has an stat increase
	add hl, de
	dec c
	ld a, c
	and a
	jr nz, .checkStatModsLoop
	jp .discourageDoNothingMove
.handleSpclUpEffect
	ld a, 3 ; SPCL
	ld b, 13 ; MAX
	call CheckIfEnemyStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; special already +6
	ld a, [wHasDamagingSpecialMove]
	and a
	jp nz, .encourageStatusMove
	call ComparePlayerAtkAndSpcl
	jp c, .discourageDoNothingMove ; Player's pokémon attack is equal or higher than it's special
	jp .encourageStatusMove
.handleAtkUpEffect
	ld a, 0 ; ATK
	ld b, 13 ; MAX
	call CheckIfEnemyStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; attack already +6
	jr .checkIfNoDamagingPhysicalMoveInSet
.handleDefDownEffect
	ld hl, wPlayerBattleStatus2
	bit PROTECTED_BY_MIST, [hl]
	jp nz, .discourageDoNothingMove ; player protected by mist
	ld a, 1 ; DEF
	ld b, 1 ; MIN
	call CheckIfPlayerStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; player defense already -6
.checkIfNoDamagingPhysicalMoveInSet
	ld a, [wHasDamagingPhysicalMove]
	and a
	jp z, .discourageDoNothingMove ; no damaging physical moves
	jp .encourageStatusMove
.handleAtkDownEffect
	ld hl, wPlayerBattleStatus2
	bit PROTECTED_BY_MIST, [hl]
	jp nz, .discourageDoNothingMove ; player protected by mist
	ld a, 0 ; ATK
	ld b, 1 ; MIN
	call CheckIfPlayerStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; player attack already -6
	jr .checkCompareAtkSpcl
.handleDefUpEffect
	ld a, 1 ; DEF
	ld b, 13 ; MAX
	call CheckIfEnemyStatModIsMinOrMax
	and a
	jp nz, .discourageDoNothingMove ; defense already +6
.checkCompareAtkSpcl
	call ComparePlayerAtkAndSpcl
	jp nc, .discourageDoNothingMove ; Player's pokémon special higher than it's attack
	jp .encourageStatusMove
.handleConversionEffect
	ld a, [wBattleMonType1]
	cp GHOST
	jr z, .slightlyDiscourageConversion
	cp DRAGON
	jr z, .slightlyDiscourageConversion
	ld a, [wBattleMonType2]
	cp GHOST
	jr z, .slightlyDiscourageConversion
	cp DRAGON
	jr z, .slightlyDiscourageConversion
	jp .encourageStatusMove
.slightlyDiscourageConversion
	pop hl
	ld b, 3 ; discourage move by 3
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jp .checkNextMove2
.handleSubEffect
	ld hl, wEnemyBattleStatus2
	bit HAS_SUBSTITUTE_UP, [hl]
	jp nz, .discourageDoNothingMove ; already has sub
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b ; max hp / 4
	ld de, wEnemyMonHP - wEnemyMonMaxHP
	add hl, de ; point hl to current HP low byte
	ld a, [hld]
; subtract [max hp / 4] to current HP
	sub b
	ld d, a
	ld a, [hl]
	sbc 0
	jp c, .discourageDoNothingMove ; not enough hp
	jp z, .discourageDoNothingMove ; not enough hp
	ld a, [wEncourageStatusMove]
	and a
	jp z, .checkNextMove2
	pop hl
	ld b, 29 ; encourage move by 29
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jp .checkNextMove2
.handleHealEffect
	; failsafe: heavily discourage heal after 30 turns
	ld a, [wAILayer2Encouragement]
	cp 30
	jr nc, .healEffectFailsafe
	ld a, [wEnemyMoveNum]
	cp REST
	jr z, .checkIfAlreadyAsleep
	ld de, wEnemyMonSpeed
	ld hl, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr c, .enemyFaster
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	ld h, d
	ld l, e
	srl d
	rr e 
	add hl, de
	ld d, h
	ld e, l ; max hp * 3 / 4
	jr .gotHPThreshold
.enemyFaster
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e ; max hp / 2
.gotHPThreshold
	; de = EnemyMon HP Threshold
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp nc, .discourageDoNothingMove ; too healthy
	pop hl
	ld b, 31 ; encourage move by 31
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
	jp .checkNextMove2
.checkIfAlreadyAsleep
	ld a, [wEnemyMonStatus]
	and SLP_MASK
	jp nz, .discourageDoNothingMove ; already asleep
	jr .enemyFaster ; only heal if less than 50% HP
.healEffectFailsafe
	pop hl
	ld b, 9 ; heavily discourage move
	ld a, [hl]
	add b
	ld [hl], a
	push hl
	jp .checkNextMove2
.handleMirrorMoveEff
	ld a, [wPlayerSelectedMove]
	and a
	jp z, .discourageDoNothingMove
	jp .encourageStatusMove
	
FlagDamagingMove:
	ld a, [wEnemyMovePower]
	cp 2
	ret c
	; EnemyMove is damaging (no special damage)
	ld a, [wEnemyMoveType]
	cp 20
	ld a, 1
	jr nc, .special
	; physical
	ld [wHasDamagingPhysicalMove], a
	ret
.special
	ld [wHasDamagingSpecialMove], a
	ret

ComparePlayerAtkAndSpcl:
	ld de, wBattleMonAttack
	ld hl, wBattleMonSpecial
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ret

GetDEHLFromWramForCompare:
	push bc
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	ld h, b
	ld l, c
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld h, b
	ld l, c
	pop bc
	ret

CheckIfEnemyStatModIsMinOrMax:
	ld hl, wEnemyMonStatMods
	jr CheckIfStatModIsMinOrMax
	
CheckIfPlayerStatModIsMinOrMax:
	ld hl, wPlayerMonStatMods
	jr CheckIfStatModIsMinOrMax

CheckIfStatModIsMinOrMax:
	; a = 0 ATK / 1 DEF / 2 SPE / 3 SPCL / 4 ACC / 5 EVA - b = 1 MIN / 13 MAX
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp b
	ld a, 1
	ret z
	ld a, 0
	ret

FurtherEncourageGoodStatusMoves:
	push hl
	ld a, [wEnemyMoveEffect]
	ld c, a
	ld hl, GoodStatusEffectsList
.checkAgain
	ld a, [hli]                  
	cp c                         
	jr z, .hasGoodEff
	inc a                      
	jr nz, .checkAgain               
	jr .noGoodEff
.hasGoodEff
	pop hl
	dec [hl] ; Further Encourage Move
	push hl
.noGoodEff
	pop hl
	ret

GoodStatusEffectsList:
	db ATTACK_UP2_EFFECT
	db EVASION_UP1_EFFECT
	db METRONOME_EFFECT
	db MIRROR_MOVE_EFFECT
	db SPECIAL_UP2_EFFECT
	db SPEED_UP2_EFFECT
	db SUBSTITUTE_EFFECT
	db -1 ; end

FurtherDiscourageBadStatusMoves:
	push hl
	ld a, [wEnemyMoveEffect]
	ld c, a
	ld hl, BadStatusEffectsList
.checkAgain2
	ld a, [hli]                  
	cp c                         
	jr z, .hasBadEff
	inc a                      
	jr nz, .checkAgain2               
	jr .noBadEff
.hasBadEff
	pop hl
	inc [hl] ; Further Discourage Move
	push hl
.noBadEff
	pop hl
	ret

BadStatusEffectsList:
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db DEFENSE_UP1_EFFECT
	db DISABLE_EFFECT
	db HAZE_EFFECT
	db LEECH_SEED_EFFECT
	db MIMIC_EFFECT
	db MIST_EFFECT
	db POISON_EFFECT
	db -1 ; end

CheckIfMoreThan50PercentHPLeft:
	ld a, [wEnemyMonMaxHP]
	ld d, a
	ld a, [wEnemyMonMaxHP+1]
	ld e, a
	srl d
	rr e
	ld a, [wEnemyMonHP]
	ld h, a
	ld a, [wEnemyMonHP+1]
	ld l, a
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ld a, 1
	ret nc	; true
	ld a, 0
	ret		; false

CheckIfRecoil:
	cp RECOIL_EFFECT
	ld a, 0
	ret nz
	call CheckIfLastMon
	and a
	ret z
	call CalcMoveMaxDamage
	call CheckIfKill
	and a
	jr z, .doesntKill
	ld hl, wBattleMonHP
	jr .skipUsingDamage
.doesntKill
	ld hl, wDamage2
.skipUsingDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	srl b
	rr c
	srl b
	rr c
	or c
	jr nz, .checkIfSelfKO
	inc c ; minimum recoil damage is 1
.checkIfSelfKO
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	ld h, b ; recoil damage
	ld l, c
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ld a, 0
	ret c	; 0 if pokemon will live
	ld a, 1
	ret		; 1 if self KO

CheckIfSemiInvulerable:
	; if battlemon is semi-invulnerable and enemymon is faster ignore move unless swift
	ld a, [wEnemyMoveEffect]
	cp SWIFT_EFFECT
	ld a, 0
	jr z, .notInvulnerable
	ld hl, wPlayerBattleStatus1
	bit INVULNERABLE, [hl]
	ld a, 0
	jr z, .notInvulnerable
	; check for prio
	ld a, [wEnemyMoveNum]
	ld c, a
	ld hl, PriorityMoves2
.tableCheck
	ld a, [hli]                  
	cp c                         
	jr z, .invulnerable
	inc a                      
	jr nz, .tableCheck               
	; check speed
	ld de, wEnemyMonSpeed
	ld hl, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ld a, 0
	jr nc, .notInvulnerable ; BattleMon faster or speed tied to EnemyMon
	jr z, .notInvulnerable 	; BattleMon faster or speed tied to EnemyMon	
.invulnerable
	; EnemyMon faster than BattleMon
	ld a, 1
.notInvulnerable
	ret

FurtherEncourageIfSecondaryEffect:
	push hl
	ld a, [wEnemyMoveEffect]
	ld c, a
	ld hl, SecondaryEffectList
.tableLoop
	ld a, [hli]                  
	cp c                         
	jr z, .hasSecEff
	inc a                      
	jr nz, .tableLoop               
	jr .noSecEff
.hasSecEff
	pop hl
	dec [hl] ; Further Encourage Move
	push hl
.noSecEff
	pop hl
	ret

SecondaryEffectList:
; moves have a secondary effect
	db POISON_SIDE_EFFECT1
	db BURN_SIDE_EFFECT1
	db FREEZE_SIDE_EFFECT
	db PARALYZE_SIDE_EFFECT1
	db POISON_SIDE_EFFECT2
	db BURN_SIDE_EFFECT2
	db PARALYZE_SIDE_EFFECT2
	db ATTACK_DOWN_SIDE_EFFECT
	db DEFENSE_DOWN_SIDE_EFFECT
	db SPECIAL_DOWN_SIDE_EFFECT
	db CONFUSION_SIDE_EFFECT
	db TWINEEDLE_EFFECT
	db SPEED_DOWN_SIDE_EFFECT
	db FLINCH_SIDE_EFFECT1
	db FLINCH_SIDE_EFFECT2
	db -1 ; end

CheckIfMostDamageGreaterThanZero:
	ld hl, wMostDamage
	call CheckIfGreaterThanZero
	ret

CheckIfGuaranteedMostDamageGreaterThanZero:
	ld hl, wGuaranteedMostDamage
	call CheckIfGreaterThanZero
	ret

CheckIfPrioDamageGreaterThanZero:
	ld hl, wPrioMoveMostDamage
	call CheckIfGreaterThanZero
	ret

CheckIfDamageGreaterThanZero:
	ld hl, wDamage2
	call CheckIfGreaterThanZero
	ret

CheckIfGreaterThanZero:
	ld a, [hli]
	cp 0
	ld a, 1
	ret nz
	ld a, [hl]
	cp 0
	ld a, 1
	ret nz
	xor a
	ret
	
AddPrioDamage:
	ld hl, wDamage2
	ld a, [hli]
	ld [wDamageBuffer], a
	ld a, [hl]
	ld [wDamageBuffer+1], a
	ld hl, wPrioMoveMostDamage
	call AddDamage
	ret

AddGuaranteedMostDamage:
	ld hl, wGuaranteedMostDamage
	call AddDamage
	ret

AddDamage:
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	ld hl, wDamage2
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld h, b
	ld l, c
	add hl, de
	ld d, h
	ld e, l
	ld hl, wDamage2
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

SubstractAddedDamage:
	ld hl, wDamageBuffer
	ld a, [hli]
	ld [wDamage2], a
	ld a, [hl]
	ld [wDamage2+1], a
	ret

FurtherEncourageIfPerfectAccuracy:
	ld a, [wEnemyMoveAccuracy]
	cp 255
	ret nz
	ld b, 3 ; encourage move by 3 (27 total with the previous 24)
	ld a, [hl]
	sub b
	ld [hl], a
	ret

HandleZeroDamageMoves:
	ld a, [wEnemyMoveNum]
	cp COUNTER
	jr z, .handleCounter
	; discourage 0 damage moves
	ld b, 6 ; discourage by 6 (do nothing move)
	ld a, [hl]
	add b
	ld [hl], a
	ret
.handleCounter
	push hl
	; check accuracy
	ld a, [wEnemyMoveAccuracy]
	cp 255
	jr z, .perfectAccu
	ld b, a
	call Random
	cp b
	jr nc, .finishHandlingCounter
.perfectAccu
	ld a, [wPlayerSelectedMove]
	cp COUNTER
	jr z, .finishHandlingCounter
	ld a, [wPlayerMovePower]
	cp 0
	jr z, .finishHandlingCounter
	ld a, [wEnemyMonType]
	cp GHOST
	jr z, .finishHandlingCounter
	ld a, [wPlayerMoveType]
	cp NORMAL
	jr z, .counterableType
	cp FIGHTING
	jr nz, .finishHandlingCounter
.counterableType
	pop hl
	ld b, 3 ; encourage move by 3
	ld a, [hl]
	sub b
	ld [hl], a
	push hl
.finishHandlingCounter
	pop hl
	ret	

CalcMoveMinDamage:
	ld a, 217
	ld [wRollFactor], a
	jr CalcMoveDamage

CalcMoveAvrDamage:
	ld a, 236
	ld [wRollFactor], a
	jr CalcMoveDamage

CalcMoveMaxDamage:
	ld a, 255
	ld [wRollFactor], a
	jr CalcMoveDamage

CalcMoveDamage:
	call SwapPlayerAndEnemyLevels2
	ld a, [wEnemyMoveEffect]
	ld hl, SpecialDamageMoves
	ld de, $1
	call IsInArray
	jr c, .goToEnd
	ld a, [wEnemyMoveNum]
	cp COUNTER
	jr z, .goToEnd
	call CheckIfGuaranteedCrit
	call SwapPlayerAndEnemyLevels2
	call GetDamageVariables
	call SwapPlayerAndEnemyLevels2
	call CalculateRawDamage
	jp z, .goToEnd
	call BufferDamage
	ldh a, [hWhoseTurn] 
	push af
	ld a, 1
	ldh [hWhoseTurn], a
	callfar AdjustDamageForMoveType
	pop af
	ldh [hWhoseTurn], a
	call RestoreDamage
	call FactorInRoll
.goToEnd
	call HandleSpecialDamageMoves
	call SwapPlayerAndEnemyLevels2
	ret

; swaps the level values of the BattleMon and EnemyMon structs
SwapPlayerAndEnemyLevels2:
	push bc
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wEnemyMonLevel]
	ld [wBattleMonLevel], a
	ld a, b
	ld [wEnemyMonLevel], a
	pop bc
	ret

BufferDamage:
	ld hl, wDamage
	ld a, [hli]
	ld [wDamageBuffer], a
	ld a, [hl]
	ld [wDamageBuffer+1], a
	ld hl, wDamage2
	ld a, [hli]
	ld [wDamage], a
	ld a, [hl]
	ld [wDamage+1], a
	ret

RestoreDamage:
	ld hl, wDamage
	ld a, [hli]
	ld [wDamage2], a
	ld a, [hl]
	ld [wDamage2+1], a
	ld hl, wDamageBuffer
	ld a, [hli]
	ld [wDamage], a
	ld a, [hl]
	ld [wDamage+1], a
	ret

SpecialDamageMoves:
; moves that do damage but not through normal calculations
	db SUPER_FANG_EFFECT
	db SPECIAL_DAMAGE_EFFECT
	db -1 ; end
	
CheckIfGuaranteedCrit:
	xor a
	ld [wCriticalHitOrOHKO], a
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld a, [wMonHBaseSpeed]
	ld b, a
	ld hl, wEnemyMovePower
	ld de, wEnemyBattleStatus2
.calcCriticalHitProbability
	ld a, [hld]                  ; read base power from RAM
	and a
	ret z                        ; do nothing if zero
	;;
	ld a, [wFishForCrits]
	and a
	jr z, .ignoreFFC
	ld [wCriticalHitOrOHKO], a
	ret
.ignoreFFC
	;;
	dec hl
	ld c, [hl]                   ; read move id
	ld hl, HighCriticalMoves2    ; table of high critical hit moves
.Loop
	ld a, [hli]                  ; read move from move table
	cp c                         ; does it match the move about to be used?
	jr z, .HighCritical          ; if so, the move about to be used is a high critical hit ratio move
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .Loop                 ; check the next move in HighCriticalMoves
	srl b                        ; /2 for regular move
	jr .SkipHighCritical         ; continue as a normal move
.HighCritical
	sla b                        ; *2 for high critical hit moves
	jr nc, .noCarry
	ld b, $ff                    ; cap at 255/256
.noCarry
	sla b                        ; *4 for high critical move
	jr nc, .SkipHighCritical
	ld b, $ff
.SkipHighCritical
	ld a, [de]
	bit GETTING_PUMPED, a        ; test for focus energy
	jr z, .noFocusEnergyUsed
	sla b                        ; (effective (base speed*2))
	jr nc, .focusEnergyUsed
	ld b, $ff                    ; cap at 255/256
	jr .noFocusEnergyUsed
.focusEnergyUsed
	sla b                        ; (effective ((base speed*2)*2))
	jr nc, .noFocusEnergyUsed
	ld b, $ff                    ; cap at 255/256
.noFocusEnergyUsed
	ld a, b
	cp 255
	ret nz
	ld a, $1
	ld [wCriticalHitOrOHKO], a   ; set critical hit flag
	ret

HighCriticalMoves2:
	db KARATE_CHOP
	db RAZOR_LEAF
	db CRABHAMMER
	db SLASH
IF DEF(_MODERN)
	db STORM_THROW
	db STONE_EDGE
	db LEAF_BLADE
	db NIGHT_SLASH
	db CROSS_CHOP
	db POISON_TAIL
ENDC
	db -1 ; end
	
GetDamageVariables:
	ld hl, wDamage2 ; damage to eventually inflict, initialise to zero
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wEnemyMovePower
	ld a, [hli]
	ld d, a ; d = move power
	and a
	ret z ; return if move power is zero
	ld a, [hl] ; a = [wEnemyMoveType]
	cp SPECIAL ; types >= SPECIAL are all special
	jr nc, .specialAttack
.physicalAttack
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = player defense
	ld a, [wPlayerBattleStatus3]
	bit HAS_REFLECT_UP, a ; check for Reflect
	jr z, .physicalAttackCritCheck
; if the player has used Reflect, double the player's defense
	sla c
	rl b
	;
	push de
	ld d, b
	ld e, c
	ld hl, MAX_STAT_VALUE
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr nc, .noCap
	ld b, h
	ld c, l
.noCap
	pop de
	;
.physicalAttackCritCheck
	ld hl, wEnemyMonAttack
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's defense and the enemy's attack to their base values
	ld hl, wPartyMon1Defense
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, 2 ; attack stat
	call GetMonStat
	ld hl, hProduct + 2
	pop bc
	jr .scaleStats
.specialAttack
	ld hl, wBattleMonSpecial
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [wPlayerBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a ; check for Light Screen
	jr z, .specialAttackCritCheck
; if the player has used Light Screen, double the player's special
	sla c
	rl b
	;
	push de
	ld d, b
	ld e, c
	ld hl, MAX_STAT_VALUE
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr nc, .noCap2
	ld b, h
	ld c, l
.noCap2
	pop de
	;
; reflect and light screen boosts do not cap the stat at MAX_STAT_VALUE, so weird things will happen during stats scaling
; if a Pokemon with 512 or more Defense has used Reflect, or if a Pokemon with 512 or more Special has used Light Screen
.specialAttackCritCheck
	ld hl, wEnemyMonSpecial
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .scaleStats
; in the case of a critical hit, reset the player's and enemy's specials to their base values
	ld hl, wPartyMon1Special
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	ld c, 5 ; special stat
	call GetMonStat
	ld hl, hProduct + 2
	pop bc
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = enemy's offensive stat
	or b ; is either high byte nonzero?
	jr z, .next ; if not, we don't need to scale
; bc /= 4 (scale player's defensive stat)
	srl b
	rr c
	srl b
	rr c
	; fix
	ld a, c
	or b ; is the enemy's defensive stat 0?
	jr nz, .notZero
	inc c ; if the enemy's defensive stat is 0, bump it up to 1
.notZero
	; fix end
; defensive stat can actually end up as 0, leading to a division by 0 freeze during damage calculation
; hl /= 4 (scale enemy's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the enemy's offensive stat 0?
	jr nz, .next
	inc l ; if the enemy's offensive stat is 0, bump it up to 1
.next
	ld b, l ; b = enemy's offensive stat (possibly scaled)
	        ; (c already contains player's defensive stat (possibly scaled))
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .done
	sla e ; double level if it was a critical hit
.done
	ld a, $1
	and a
	and a
	ret
	
; get stat c of enemy mon
; c: stat to get (HP=1,Attack=2,Defense=3,Speed=4,Special=5)
GetMonStat:
	push de
	push bc
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
	ld hl, wEnemyMon1Stats
	dec c
	sla c
	ld b, $0
	add hl, bc
	ld a, [wEnemyMonPartyPos]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	pop bc
	pop de
	ret
.notLinkBattle
	ld a, [wEnemyMonLevel]
	ld [wCurEnemyLVL], a
	ld a, [wEnemyMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wEnemyMonDVs
	ld de, wLoadedMonSpeedExp
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop bc
	ld b, $0
	ld hl, wLoadedMonSpeedExp - $b ; this base address makes CalcStat look in [wLoadedMonSpeedExp] for DVs
	call CalcStat
	pop de
	ret

CalculateRawDamage:
	; input:
;   b: enemy attack
;   c: player defense
;   d: base power
;   e: level

	ld a, [wEnemyMoveEffect]

; EXPLODE_EFFECT halves defense.
	cp EXPLODE_EFFECT
	jr nz, .ok
	srl c
	jr nz, .ok
	inc c ; ...with a minimum value of 1 (used as a divisor later on)
.ok

; Multi-hit attacks may or may not have 0 bp.
	cp TWO_TO_FIVE_ATTACKS_EFFECT
	jr nz, .ok2
	push af
	push bc
	ld b, d
	sla d ; calc with minimum (2 hit)
	ld a, [wRollFactor]
	cp 236
	jr c, .preOk
	ld a, b
	add d
	ld d, a	; calc with average (3 hit)
.preOk
	pop bc
	pop af
.ok2

; Attacks that hit twice
	cp ATTACK_TWICE_EFFECT
	jr z, .double
	cp TWINEEDLE_EFFECT
	jr nz, .ok3
.double
	sla d ; calc with 2x BP
	jr z, .skipbp
.ok3

; Dream Eater check, if mon asleep change BP to 0 and back to beginning
	cp DREAM_EATER_EFFECT
	jr nz, .ok4
	ld a, [wBattleMonStatus]
	and SLP_MASK
	jr z, .ok4
	; player mon asleep
	ld d, 0
.ok4
	
; Ohko check
	cp OHKO_EFFECT
	jr nz, .ok5
	;
	push bc
	push de
	push hl
	;
	ld de, wEnemyMonSpeed
	ld hl, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	;
	pop hl
	pop de
	pop bc
	;
	jr c, .ok5
	; speed incorrect
	ld d, 0
.ok5

; Don't calculate damage for moves that don't do any.
	ld a, d ; base power
	and a
	ret z
.skipbp

	xor a
	ld hl, hDividend
	ldi [hl], a
	ldi [hl], a
	ld [hl], a

; Multiply level by 2
	ld a, e ; level
	add a
	jr nc, .nc
	push af
	ld a, 1
	ld [hl], a
	pop af
.nc
	inc hl
	ldi [hl], a

; Divide by 5
	ld a, 5
	ldd [hl], a
	push bc
	ld b, 4
	call Divide
	pop bc

; Add 2
	inc [hl]
	inc [hl]

	inc hl ; multiplier

; Multiply by attack base power
	ld [hl], d
	call Multiply

; Multiply by attack stat
	ld [hl], b
	call Multiply

; Divide by defender's defense stat
	ld [hl], c
	ld b, 4
	call Divide

; Divide by 50
	ld [hl], 50
	ld b, 4
	call Divide

; Update wCurDamage.
; Capped at MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE: 999 - 2 = 997.
	ld hl, wDamage2
	ld b, [hl]
	ldh a, [hQuotient + 3]
	add b
	ldh [hQuotient + 3], a
	jr nc, .dont_cap_1

	ldh a, [hQuotient + 2]
	inc a
	ldh [hQuotient + 2], a
	and a
	jr z, .cap

.dont_cap_1
	ldh a, [hQuotient]
	ld b, a
	ldh a, [hQuotient + 1]
	or a
	jr nz, .cap

	ldh a, [hQuotient + 2]
	cp HIGH(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_2

	cp HIGH(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, .cap

	ldh a, [hQuotient + 3]
	cp LOW(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr nc, .cap

.dont_cap_2
	inc hl

	ldh a, [hQuotient + 3]
	ld b, [hl]
	add b
	ld [hld], a

	ldh a, [hQuotient + 2]
	ld b, [hl]
	adc b
	ld [hl], a
	jr c, .cap

	ld a, [hl]
	cp HIGH(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_3

	cp HIGH(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, .cap

	inc hl
	ld a, [hld]
	cp LOW(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_3

.cap
	ld a, HIGH(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE)
	ld [hli], a
	ld a, LOW(MAX_NEUTRAL_DAMAGE - MIN_NEUTRAL_DAMAGE)
	ld [hld], a

.dont_cap_3
; Add back MIN_NEUTRAL_DAMAGE (capping at 999).
	inc hl
	ld a, [hl]
	add MIN_NEUTRAL_DAMAGE
	ld [hld], a
	jr nc, .dont_floor
	inc [hl]
.dont_floor

; Returns nz and nc.
	ld a, 1
	and a
	ret

FactorInRoll:
	ld hl, wDamage2
	ld a, [hli]
	and a
	jr nz, .DamageGreaterThanOne
	ld a, [hl]
	cp 2
	ret c ; return if damage is equal to 0 or 1
.DamageGreaterThanOne
	xor a
	ldh [hMultiplicand], a
	dec hl
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	ld a, [wRollFactor]
	ldh [hMultiplier], a
	call Multiply ; multiply damage by wRollFactor
	ld a, 255
	ldh [hDivisor], a
	ld b, $4
	call Divide ; divide the result by 255
; store the modified damage
	ldh a, [hQuotient + 2]
	ld hl, wDamage2
	ld [hli], a
	ldh a, [hQuotient + 3]
	ld [hl], a
	ret

CheckIfKill:
	ld de, wDamage2
	ld hl, wBattleMonHP
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ld a, 0
	ret nc	; no kill
	ld a, 1
	ret		; kill

CheckIfDamageEqualThanMostDamage:
	ld de, wMostDamage
	ld hl, wDamage2
	call GetDEHLFromWramForCompare
	; first byte comparison
    ld a, d
    cp h
	ld a, 0
    ret nz
    ; second byte comparison
    ld a, e
    cp l
	ld a, 0
    ret nz
	; wDamage2 = wMostDamage
	ld a, 1
	ret

FurtherEncourageIfPrioMoveAndSlower: ; (or speed tied)
	push hl
	ld de, wBattleMonSpeed
	ld hl, wEnemyMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jr nc, .isNotPrio
	; EnemyMon slower or speed tied to BattleMon
	ld a, [wEnemyMoveNum]
	ld c, a
	ld hl, PriorityMoves2
.tableCheckLoop
	ld a, [hli]                  
	cp c                         
	jr z, .isPrio         
	inc a                      
	jr nz, .tableCheckLoop               
	jr .isNotPrio
.isPrio
	pop hl
	dec [hl] ; Further Encourage Move
	push hl
.isNotPrio
	pop hl
	ret

SaveDamageIfPrio:
	ld a, [wEnemyMoveAccuracy]
	cp 255
	ret nz ; if move is not gonna hit don't bother
	ld de, wBattleMonSpeed
	ld hl, wEnemyMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ret nc
	; EnemyMon slower or speed tied to BattleMon
	ld a, [wEnemyMoveNum]
	ld c, a
	ld hl, PriorityMoves2
.tableCheckLoop2
	ld a, [hli]                  
	cp c                         
	jr z, .prio         
	inc a                      
	jr nz, .tableCheckLoop2               
	ret
.prio
	ld de, wDamage2
	ld hl, wPrioMoveMostDamage
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ret nc
	; Damage Bigger than PrioMoveMostDamage
	ld hl, wPrioMoveMostDamage
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

PriorityMoves2:
	db QUICK_ATTACK
IF DEF(_MODERN)
	db VACUUM_WAVE
	db SHADOW_SNEAK
	db AQUA_JET
ENDC
	db -1 ; end

HandleSpecialDamageMoves:
	ld a, [wEnemyMoveEffect]
	cp SUPER_FANG_EFFECT
	jr z, .superFangEffect
	cp SPECIAL_DAMAGE_EFFECT
	jr z, .specialDamage
	ld a, [wEnemyMoveNum]
	cp COUNTER
	jr z, .counterMove
	jr .done
.counterMove
	ld hl, wDamage2
	ld a, 0
	ld [hli], a
	ld [hl], a
	jr .done
.superFangEffect
; set the damage to half the target's HP
	ld hl, wBattleMonHP
	ld de, wDamage2
	ld a, [hli]
	srl a
	ld [de], a
	inc de
	ld b, a
	ld a, [hl]
	rr a
	ld [de], a
	or b
	jr nz, .done
; make sure Super Fang's damage is always at least 1
	ld a, $01
	ld [de], a
	jr .done
.specialDamage
	ld hl, wBattleMonLevel
	ld a, [hl]
	ld b, a
	ld a, [wEnemyMoveNum]
	cp SEISMIC_TOSS
	jr z, .storeDamage
	cp NIGHT_SHADE
	jr z, .storeDamage
	ld b, SONICBOOM_DAMAGE
	cp SONICBOOM
	jr z, .storeDamage
	ld b, DRAGON_RAGE_DAMAGE
	cp DRAGON_RAGE
	jr z, .storeDamage
; Psywave
	ld b, 1
.storeDamage
	ld hl, wDamage2
	xor a
	ld [hli], a
	ld a, b
	ld [hl], a
.done
	ret

DiscourageNotPreferedMoves:
	push hl
	ld a, [wEnemyMoveEffect]
	ld hl, NotPreferedMoves
	ld de, $1
	call IsInArray
	jr nc, .goEnd
	pop hl
	inc [hl]
	push hl
.goEnd
	pop hl
	ret
	
NotPreferedMoves:
	db CHARGE_EFFECT
	db THRASH_PETAL_DANCE_EFFECT
	db FLY_EFFECT
	db -1 ; end
	
SaveMostDamage:
	ld a, [wEnemyMoveEffect]
	cp HYPER_BEAM_EFFECT
	ret z
	ld de, wDamage2
	ld hl, wMostDamage
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ret nc
	; Damage Bigger than MostDamage
	ld hl, wMostDamage
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

SaveGuaranteedMostDamage:
	ld a, [wEnemyMoveAccuracy]
	cp 255
	ret nz ; if move is not gonna hit don't bother
	ld de, wDamage2
	ld hl, wGuaranteedMostDamage
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ret nc
	; Damage Bigger than GuaranteedMostDamage
	ld hl, wGuaranteedMostDamage
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

CheckIfLastMon:
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	cp 2    ; don't bother if only 1
	ld a, 0
	jr nc, .moreThan1Mon
	ld a, 1
.moreThan1Mon
	ret
;;

ReadMove:
	push hl
	push de
	push bc
	ld d, a
	callfar GetMoveData
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/trainers/move_choices.asm"

INCLUDE "data/trainers/pic_pointers_money.asm"

INCLUDE "data/trainers/names.asm"

INCLUDE "engine/battle/misc.asm"

INCLUDE "engine/battle/read_trainer_party.asm"

INCLUDE "data/trainers/special_moves.asm"

INCLUDE "data/trainers/parties.asm"

INCLUDE "data/trainers/status_frequency_table.asm"

TrainerAI:
	and a
	ld a, [wIsInBattle]
	dec a
	ret z ; if not a trainer, we're done here
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; if in a link battle, we're done as well
;	ld a, [wTrainerClass] ; what trainer class is this?
;	dec a
;	ld c, a
;	ld b, 0
;	ld hl, TrainerAIPointers
;	add hl, bc
;	add hl, bc
;	add hl, bc
;	ld a, [wAICount]
;	and a
;	ret z ; if no AI uses left, we're done here
;	inc hl
;	inc a
;	jr nz, .getpointer
;	dec hl
;	ld a, [hli]
;	ld [wAICount], a
;.getpointer
;	ld a, [hli]
;	ld h, [hl]
;	ld l, a
;	call Random
;	jp hl
	ld a, [wEnemyMoveNum]
	ld d, a
	push de
	call SwitchAI
	pop de
	ld a, d
	push af
	call ReadMove
	pop af
	ret
	

INCLUDE "data/trainers/ai_pointers.asm"

JugglerAI:
	cp 25 percent + 1
	ret nc
	jp AISwitchIfEnoughMons

BlackbeltAI:
	cp 13 percent - 1
	ret nc
	jp AIUseXAttack

GiovanniAI:
	cp 25 percent + 1
	ret nc
	jp AIUseGuardSpec

CooltrainerMAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXAttack

CooltrainerFAI:
	; The intended 25% chance to consider switching will not apply.
	; Uncomment the line below to fix this.
	cp 25 percent + 1
	ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AISwitchIfEnoughMons

BrockAI:
; if his active monster has a status condition, use a full heal
	ld a, [wEnemyMonStatus]
	and a
	ret z
	jp AIUseFullHeal

MistyAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXDefend

LtSurgeAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXSpeed

ErikaAI:
	cp 50 percent + 1
	ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseSuperPotion

KogaAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXAttack

BlaineAI:
	cp 25 percent + 1
	ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseSuperPotion

SabrinaAI:
	cp 25 percent + 1
	ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

Rival2AI:
	cp 13 percent - 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUsePotion

Rival3AI:
	cp 13 percent - 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseFullRestore

LoreleiAI:
	cp 50 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseSuperPotion

BrunoAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXDefend

AgathaAI:
	cp 8 percent
	jp c, AISwitchIfEnoughMons
	cp 50 percent + 1
	ret nc
	ld a, 4
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseSuperPotion

LanceAI:
	cp 50 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

GenericAI:
	and a ; clear carry
	ret

;;
SwitchAI:
	xor a
	ld [wSwitchTarget], a
	call CheckIfLastMon
	and a
	ret nz
	; Enemy has at least 2 mons
;	ld a, [wBattleMonTurnsOut]
;	and a
;	ret z
	; Player switched mons this turn
	ld hl, wEnemyBattleStatus1
	bit THRASHING_ABOUT, [hl]
	ret nz
	bit CHARGING_UP, [hl]
	ret nz
	ld hl, wEnemyBattleStatus2
	bit NEEDS_TO_RECHARGE, [hl]
	ret nz
	bit USING_RAGE, [hl]
	ret nz
	; Enemy can switch
	ld hl, wPlayerBattleStatus2
	bit USING_RAGE, [hl]
	jr nz, SwitchRage ; player is raging
	bit NEEDS_TO_RECHARGE, [hl]
	jr nz, .switchA1
	ld a, [wEnemyMonStatus]
	and SLP_MASK
	jr nz, .switchA1
	ld hl, wPlayerBattleStatus1
	bit CHARGING_UP, [hl]
	jr nz, .switchA0
	bit INVULNERABLE, [hl]
	jr nz, .switchA0
	bit THRASHING_ABOUT, [hl]
	jr nz, .switchA0
	jp SwitchStatusMoves
.notStatusMove
	ld hl, TrainerPredictionTable
	ld a, [wTrainerClass]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp 1
	jr nz, .noPredictionSwitch
.switchAMinus
	ld a, -1
	jp MainSwitch
.noPredictionSwitch
	and a
	ret
.switchA1
	ld a, 1
	jp MainSwitch
.switchA0
	ld a, 0
	jp MainSwitch

SwitchRage:
	ld d, 0
.biggerLoop
	;
	push de
	;
	ld a, [wEnemyMonType1]
	ld b, a
	ld a, [wEnemyMonType2]
	ld c, a
	ld a, [wPlayerMoveType]
	ld d, a
	call CompressIntoDE
	callfar AIGetTypeEffectiveness
	pop de
	ld a, d
	and a
	jr nz, .notFirstLoop
	ld a, [wTypeEffectiveness]
	and a
	ret z ; EnemyMon already inmune to RAGE_EFFECT move
	jr .cont
.notFirstLoop
	cp 1
	jr nz, .notSecondLoop
	ld a, [wTypeEffectiveness]
	cp 1
	ret z ; EnemyMon already x4 resistant to RAGE_EFFECT move
	jr .cont
.notSecondLoop
	ld a, [wTypeEffectiveness]
	cp 2
	ret z ; EnemyMon already x2 resistant to RAGE_EFFECT move
.cont
	ld a, [wEnemyPartyCount]
	ld c, a
	ld b, 0
.loop
	;
	push de
	push bc
	;
	ld a, [wEnemyMonPartyPos]
	pop bc
	cp b
	push bc
	jp z, .faintedMon
	; don't switch into current EnemyMon
	pop bc
	ld d, b
	push bc
	call CheckIfFainted
	ld a, d
	and a
	jp nz, .faintedMon
	; don't switch into a fainted mon
	pop bc
	ld d, b
	push bc
	call CheckIfAcePokemon
	ld a, d
	and a
	jp nz, .faintedMon
	; don't switch into an ace pokémon
	pop bc
	pop de
	ld a, d
	push de
	push bc
	and a
	jr z, .cont4
	cp 1
	jr nz, .notSecondLoop4
	ld hl, wEnemyMon1MaxHP
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e ; max hp / 2
	ld bc, wEnemyMon1HP - wEnemyMon1MaxHP - 1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	; de , max hp
	; hl , cur hp
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp c, .faintedMon ; too weak
	jr .cont4
.notSecondLoop4	
	ld hl, wEnemyMon1MaxHP
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	push hl
	ld h, d
	ld l, e
	srl d
	rr e 
	add hl, de
	ld d, h
	ld e, l ; max hp * 3 / 4
	pop hl
	ld bc, wEnemyMon1HP - wEnemyMon1MaxHP - 1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	; de , max hp
	; hl , cur hp
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp c, .faintedMon ; too weak
	; don't switch if under hp threshold
.cont4
	ld hl, wEnemyMon1Type1
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld a, [wPlayerMoveType]
	ld d, a
	call CompressIntoDE
	callfar AIGetTypeEffectiveness
	pop bc
	pop de
	ld a, d
	push de
	push bc
	and a
	jr nz, .notFirstLoop2
	ld a, [wTypeEffectiveness]
	and a
	jr nz, .faintedMon
	; don't switch into a pokémon that's not immune to the RAGE_EFFECT move
	jr .cont2
.notFirstLoop2
	cp 1
	jr nz, .notSecondLoop2
	ld a, [wTypeEffectiveness]
	cp 1
	jr nz, .faintedMon
	; don't switch into a pokémon that's not x4 resistant to the RAGE_EFFECT move
	jr .cont2
.notSecondLoop2
	ld a, [wTypeEffectiveness]
	cp 2
	jr nz, .faintedMon
	; don't switch into a pokémon that's not x2 resistant to the RAGE_EFFECT move
.cont2
	pop bc
	pop de
	ld a, d
	push de
	and a
	jr nz, .notFirstLoop3
	ld d, b
	push bc
	ld e, 1 ; MON HAS AT LEAST A x1/4 DAMAGING MOVE
	jr .cont3
.notFirstLoop3
	cp 1
	jr nz, .notSecondLoop3
	ld d, b
	push bc
	ld e, 2 ; MON HAS AT LEAST A x1/2 DAMAGING MOVE
	jr .cont3
.notSecondLoop3
	ld d, b
	push bc
	ld e, 4 ; MON HAS AT LEAST A x1 DAMAGING MOVE
.cont3
	call CheckIfDamagingMove
	ld a, d
	and a
	jr nz, .switchToThisPoke ; switch if mon has at least a x1/4 damaging move
.faintedMon
	;
	pop bc
	pop de
	;
	inc b
	dec c
	jp nz, .loop
	inc d
	ld a, d
	cp 3
	ret nc
	jp .biggerLoop
.switchToThisPoke
	;
	pop bc
	pop de
	;
	ld a, b
	inc a
	ld [wSwitchTarget], a
	jp SwitchEnemyMon
	
MainSwitch:
	ld hl, TrainerPredictionTable
	call GetChanceThreshold
.gotChanceThreshold
	ld b, a
	call Random
	cp b
	jr c, .success
	and a
	ret
.success
	ld a, [wEnemyMonStatus]
	and SLP_MASK
	jr nz, .curMonAsleep
	ld a, [wEnemyMonPartyPos]
	ld d, a
	ld e, 8
	call CheckIfDamagingMove
	ld a, d
	and a
	ret nz
	; don't switch if mon has a super-effective or quad-effective damaging move
.curMonAsleep
	ld e, 0
.evenBiggerLoop
	ld d, 0
.biggerLoop2
	ld a, [wEnemyPartyCount]
	ld c, a
	ld b, 0
.loop2
	;
	push de
	push bc
	;
	ld a, [wEnemyMonPartyPos]
	pop bc
	cp b
	push bc
	jp z, .faintedMon2
	; don't switch into current EnemyMon
	pop bc
	ld d, b
	push bc
	call CheckIfFainted
	ld a, d
	and a
	jp nz, .faintedMon2
	; don't switch into a fainted mon
	pop bc
	ld d, b
	push bc
	call CheckIfAcePokemon
	ld a, d
	and a
	jp nz, .faintedMon2
	; don't switch into an ace pokémon
	pop bc
	push bc
	ld a, [wPlayerMovePower]
	cp 0
	jr nz, .ignoreStatusMoveClauses
	call CheckStatusMoveClauses
	jp z, .faintedMon2
	; don't switch if a status move used by the player breaks a clause
.ignoreStatusMoveClauses
	pop bc
	pop de
	ld a, e
	and a
	push de
	push bc
	jr nz, .ignoreSpeed
	ld d, b
	call CheckIfSlower
	ld a, d
	and a
	jp nz, .faintedMon2
	; don't switch into a slower pokémon
.ignoreSpeed
	pop bc
	pop de
	ld a, d
	push de
	push bc
	and a
	jr z, .cont42
	cp 1
	jr nz, .notSecondLoop42
	ld hl, wEnemyMon1MaxHP
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e ; max hp / 2
	ld bc, wEnemyMon1HP - wEnemyMon1MaxHP - 1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	; de , max hp
	; hl , cur hp
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp c, .faintedMon2 ; too weak
	jr .cont42
.notSecondLoop42
	ld hl, wEnemyMon1MaxHP
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld d, a
	ld e, [hl]
	srl d
	rr e
	push hl
	ld h, d
	ld l, e
	srl d
	rr e 
	add hl, de
	ld d, h
	ld e, l ; max hp * 3 / 4
	pop hl
	ld bc, wEnemyMon1HP - wEnemyMon1MaxHP - 1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld h, b
	ld l, c
	; de , max hp
	; hl , cur hp
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	jp c, .faintedMon2 ; too weak
	; don't switch if under hp threshold
.cont42
	ld hl, wEnemyMon1Type1
	pop bc
	ld a, b
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld a, [wPlayerMovePower]
	cp 1
	jr z, .faintedMon2
	cp 0
	jr z, .cont22
	ld a, [wPlayerMoveType]
	ld d, a
	call CompressIntoDE
	callfar AIGetTypeEffectiveness
	pop bc
	pop de
	ld a, d
	push de
	push bc
	and a
	jr nz, .notFirstLoop22
	ld a, [wTypeEffectiveness]
	and a
	jr nz, .faintedMon2
	; don't switch into a pokémon that's not immune to the move
	jr .cont22
.notFirstLoop22
	cp 1
	jr nz, .notSecondLoop22
	ld a, [wTypeEffectiveness]
	cp 1
	jr nz, .faintedMon2
	; don't switch into a pokémon that's not x4 resistant to the move
	jr .cont22
.notSecondLoop22
	ld a, [wTypeEffectiveness]
	cp 2
	jr nz, .faintedMon2
	; don't switch into a pokémon that's not x2 resistant to the move
.cont22
	pop bc
	pop de
	ld a, d
	push de
	and a
	jr nz, .notFirstLoop32
	ld d, b
	push bc
	ld e, 8 ; MON HAS A SUPER-EFFECTIVE MOVE
	jr .cont32
.notFirstLoop32
	cp 1
	jr nz, .notSecondLoop32
	ld d, b
	push bc
	ld e, 8 ; MON HAS A SUPER-EFFECTIVE MOVE
	jr .cont32
.notSecondLoop32
	ld d, b
	push bc
	ld e, 8 ; MON HAS A SUPER-EFFECTIVE MOVE
.cont32
	call CheckIfDamagingMove
	ld a, d
	and a
	jr nz, .switchToThisPoke2 ; switch if mon has a super-effective move
.faintedMon2
	;
	pop bc
	pop de
	;
	inc b
	dec c
	jp nz, .loop2
	inc d
	ld a, d
	cp 3
	jp c, .biggerLoop2
	call CheckStatusMoveCondition
	inc e
	ld a, e
	cp 2
	ret nc
	jp .evenBiggerLoop
.switchToThisPoke2
	;
	pop bc
	pop de
	;
	ld a, b
	inc a
	ld [wSwitchTarget], a
	jp SwitchEnemyMon

CompressIntoDE:
	; b = type 1 def poke, c = type 2 def poke, d = attack type
	ld a, c
	and %00111
	sla a
	sla a
	sla a
	sla a
	sla a
	add d
	ld e, a
	sla b
	sla b
	ld a, c
	and %11000
	srl a
	srl a
	srl a
	add b
	ld d, a
	ret
	
CheckIfDamagingMove:
	; d = party position ,  e = 0 - 16 at least equal or more effective than "e"
	; NOTE: OHKO_EFFECT, SPECIAL_DAMAGE_EFFECT, SUPER_FANG_EFFECT only count if less than super effective (and level is correct for ohko)
	; NOTE: Don't count DREAM_EATER_EFFECT
	ld h, d
	ld l, e
	ld a, h
	push hl
	ld hl, wEnemyMon1Moves
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld b, NUM_MOVES + 1
.moveCheckLoop3
	dec b
	jr z, .endCheckNegative ; processed all 4 moves
	ld a, [de]
	and a
	jr z, .endCheckNegative ; no more moves in move set
	inc de
	call ReadMove
	;
	push bc
	push de
	;
	ld a, 4
	cp l
	ld a, [wEnemyMoveEffect]
	jr c, .skipWeirdMoves
	cp SPECIAL_DAMAGE_EFFECT
	jr z, .endCheckPositive
	cp SUPER_FANG_EFFECT
	jr z, .endCheckPositive
	cp OHKO_EFFECT
	jr nz, .skipWeirdMoves
	ld a, h
	push hl
	ld hl, wEnemyMon1Level
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [hl]
	cp b
	pop hl
	jr c, .loopBack
	jr .endCheckPositive
.skipWeirdMoves
	cp DREAM_EATER_EFFECT
	jr z, .loopBack
	ld a, [wEnemyMovePower]
	cp 2
	jr c, .loopBack
	;
	push bc
	push de
	push hl
	;
	ld a, [wEnemyMoveType]
	ld d, a
	ld a, [wBattleMonType1]
	ld b, a
	ld a, [wBattleMonType2]
	ld c, a
	call CompressIntoDE
	callfar AIGetTypeEffectiveness
	;
	pop hl
	pop de
	pop bc
	;
	ld a, [wTypeEffectiveness]
	cp l
	jr nc, .endCheckPositive
.loopBack
	;
	pop de
	pop bc
	;
	jr .moveCheckLoop3
.endCheckPositive
	;
	pop de
	pop bc
	;
	ld a, 1
	jr .endCheck
.endCheckNegative
	ld a, 0
.endCheck
	;
	ld d, a
	ret

CheckIfAcePokemon:
	; d = party position
	push de
	ld a, [wTrainerClass]
	ld hl, TrainerClassesWithAceMon
	ld de, $1
	call IsInArray
	ld a, 0
	jr nc, .noAcePokemon
	ld a, [wEnemyPartyCount]
	dec a
	pop de
	cp d
	push de
	ld a, 0
	jr nz, .noAcePokemon
	ld a, 1
.noAcePokemon
	pop de
	ld d, a
	ret
	
TrainerClassesWithAceMon:
	db RIVAL1
	db GIOVANNI
	db BRUNO
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db KOGA
	db BLAINE
	db SABRINA
	db RIVAL2
	db RIVAL3
	db LORELEI
	db AGATHA
	db LANCE
	db KAREN
	db -1 ; end
	
CheckIfFainted:
	ld hl, wEnemyMon1HP
	ld a, d
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	ld a, 1
	jr z, .faintedMon
	ld a, 0
.faintedMon
	ld d, a
	ret

CheckIfSlower:
	ld hl, wEnemyMon1Speed
	ld a, d
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	; hl = EnemyMonSpeed
	ld de, wBattleMonSpeed
	call GetDEHLFromWramForCompare
	call CompareDEHL ; c = de greater, nc = hl greater, z = equal
	ld a, 1
	jr c, .slowerMon
	ld a, 0
.slowerMon
	ld d, a
	ret
			
GetChanceThreshold:
	; a = -1 (low chance,) 0 (mid chance,) 1 (high chance)
	; hl = frequency table (status, risk-taking, prediction)
	ld b, a
	ld a, [wTrainerClass]
	ld d, 0
	ld e, a
	add hl, de
	ld a, b
	cp 1
	jr z, .highChance
	jr c, .midChance
	; lowChance
	ld a, [hl]
	cp 1
	jr z, .highStatusChance1
	jr c, .midStatusChance1
	; lowStatusChance1
	ld a, 10 percent + 1
	jr .statusChanceFound
.midStatusChance1
	ld a, 30 percent + 1
	jr .statusChanceFound
.highStatusChance1
	ld a, 50 percent + 1
	jr .statusChanceFound
.midChance
	ld a, [hl]
	cp 1
	jr z, .highStatusChance2
	jr c, .midStatusChance2
	; lowStatusChance2
	ld a, 30 percent + 1
	jr .statusChanceFound
.midStatusChance2
	ld a, 50 percent + 1
	jr .statusChanceFound
.highStatusChance2
	ld a, 70 percent + 1
	jr .statusChanceFound
.highChance
	ld a, [hl]
	cp 1
	jr z, .highStatusChance3
	jr c, .midStatusChance3
	; lowStatusChance3
	ld a, 50 percent + 1
	jr .statusChanceFound
.midStatusChance3
	ld a, 70 percent + 1
	jr .statusChanceFound
.highStatusChance3
	ld a, 90 percent + 1
.statusChanceFound
	ret

SwitchStatusMoves:
	ld a, [wPlayerMovePower]
	and a
	jp nz, SwitchAI.notStatusMove
	ld a, [wPlayerMoveEffect]
	ld hl, HighSwitchChance
	ld de, $1
	call IsInArray
	jp c, SwitchAI.switchA1
	ld hl, LowSwitchChance
	ld de, $1
	call IsInArray
	jp c, SwitchAI.switchAMinus
	
	cp HEAL_EFFECT
	jp z, SwitchAI.switchA0
	
	cp SWITCH_AND_TELEPORT_EFFECT
	jp z, SwitchAI.noPredictionSwitch
	
	ld a, 20 percent + 1
	jp MainSwitch.gotChanceThreshold

HighSwitchChance:
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db DEFENSE_UP1_EFFECT
	db DEFENSE_UP2_EFFECT
	db LIGHT_SCREEN_EFFECT
	db PARALYZE_EFFECT
	db POISON_EFFECT
	db REFLECT_EFFECT
	db SLEEP_EFFECT
	db SPLASH_EFFECT
	db -1 ; end

LowSwitchChance:
	db ATTACK_UP1_EFFECT
	db ATTACK_UP2_EFFECT
	db SPECIAL_UP1_EFFECT
	db SPECIAL_UP2_EFFECT
	db -1 ; end

CheckStatusMoveCondition:
	ld a, [wPlayerMoveEffect]
	
	cp DEFENSE_DOWN1_EFFECT
	jr z, .incE
	
	cp DEFENSE_DOWN2_EFFECT
	jr z, .incE
	
	cp ATTACK_UP1_EFFECT
	jr z, .incE
	
	cp ATTACK_UP2_EFFECT
	jr z, .incE
	
	cp SPECIAL_UP1_EFFECT
	jr z, .incE
	
	cp SPECIAL_UP2_EFFECT
	jr z, .incE
	
	ret
.incE
	inc e
	ret
	
CheckStatusMoveClauses:
	push bc
	ld a, [wPlayerMoveEffect]
	
	cp SPECIAL_UP1_EFFECT
	jr z, .superEffectiveMoveIsPhysical
	
	cp SPECIAL_UP2_EFFECT
	jr z, .superEffectiveMoveIsPhysical
	
	cp LIGHT_SCREEN_EFFECT
	jr z, .superEffectiveMoveIsPhysical
	
	cp ATTACK_DOWN1_EFFECT
	jr z, .superEffectiveMoveIsSpecial
	
	cp DEFENSE_UP1_EFFECT
	jr z, .superEffectiveMoveIsSpecial
	
	cp DEFENSE_UP2_EFFECT
	jr z, .superEffectiveMoveIsSpecial
	
	cp REFLECT_EFFECT
	jr z, .superEffectiveMoveIsSpecial
	
	cp HEAL_EFFECT
	jr z, .healEffect2
	
	cp SLEEP_EFFECT
	jr z, .sleepEffect2
	
	cp PARALYZE_EFFECT
	jr z, .paraEffect2
	
	cp POISON_EFFECT
	jp nz, .clauseNotBroken
	
; poisonEffect
	pop bc
	ld a, b
	push bc
	call IsStatused
	jp nz, .clauseNotBroken
	pop bc
	ld a, b
	push bc
	ld hl, wEnemyMon1Type1
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	
	cp POISON
	jr z, .clauseNotBroken
	
	cp STEEL
	jr z, .clauseNotBroken
	
	ld a, [hl]
	
	cp POISON
	jr z, .clauseNotBroken
	
	cp STEEL
	jr z, .clauseNotBroken
	
	jr .clauseBroken
.superEffectiveMoveIsPhysical
	pop bc
	ld d, b
	push bc
	ld e, 8 ; MON HAS A SUPER-EFFECTIVE MOVE
	call CheckIfDamagingMove
	ld a, d
	and a
	jr z, .clauseNotBroken
	ld a, [wEnemyMoveType]
	cp 20
	jr c, .clauseNotBroken
	jr nc, .clauseBroken
.superEffectiveMoveIsSpecial
	pop bc
	ld d, b
	push bc
	ld e, 8 ; MON HAS A SUPER-EFFECTIVE MOVE
	call CheckIfDamagingMove
	ld a, d
	and a
	jr z, .clauseNotBroken
	ld a, [wEnemyMoveType]
	cp 20
	jr nc, .clauseNotBroken
	jr c, .clauseBroken
.healEffect2
	ld a, [wBattleMonTurnsOut]
	cp 7
	jr nc, .clauseNotBroken
	jr .clauseBroken
.sleepEffect2
	pop bc
	ld a, b
	push bc
	call IsStatused
	jr nz, .clauseNotBroken
	jr .clauseBroken
.paraEffect2
	ld a, [wPlayerMoveType]
	cp ELECTRIC
	jr nz, .ignoreThisClause
	pop bc
	ld a, b
	push bc
	ld hl, wEnemyMon1Type1
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hli]
	
	cp GROUND
	jr z, .clauseNotBroken
	ld a, [hl]
	
	cp GROUND
	jr z, .clauseNotBroken
.ignoreThisClause
	pop bc
	ld a, b
	push bc
	call IsStatused
	jr nz, .clauseNotBroken
.clauseBroken
	xor a
	jr .goBack
.clauseNotBroken
	ld a, 1
.goBack
	and a
	pop bc
	ret

IsStatused:
	ld hl, wEnemyMon1Status
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a, [hl]
	and a
	ret ; nz is statused, z not statused
;;

; end of individual trainer AI routines

DecrementAICount:
	ld hl, wAICount
	dec [hl]
	scf
	ret

AIPlayRestoringSFX:
	ld a, SFX_HEAL_AILMENT
	jp PlaySoundWaitForCurrent

AIUseFullRestore:
	call AICureStatus
	ld a, FULL_RESTORE
	ld [wAIItem], a
	ld de, wHPBarOldHP
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, wEnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wHPBarMaxHP], a
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wHPBarMaxHP+1], a
	ld [wEnemyMonHP], a
	jr AIPrintItemUseAndUpdateHPBar

AIUsePotion:
; enemy trainer heals his monster with a potion
	ld a, POTION
	ld b, 20
	jr AIRecoverHP

AIUseSuperPotion:
; enemy trainer heals his monster with a super potion
	ld a, SUPER_POTION
	ld b, 50
	jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

AIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [wAIItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wHPBarOldHP], a
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	ld [wHPBarNewHP+1], a
	jr nc, .next
	inc a
	ld [hl], a
	ld [wHPBarNewHP+1], a
.next
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wHPBarMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wHPBarMaxHP+1], a
	sbc b
	jr nc, AIPrintItemUseAndUpdateHPBar
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wHPBarNewHP+1], a
	; fallthrough

AIPrintItemUseAndUpdateHPBar:
	call AIPrintItemUse_
	hlcoord 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2
	push af
	farcall DrawEnemyHUDAndHPBar
	pop af
	jp DecrementAICount

AISwitchIfEnoughMons:
; enemy trainer switches if there are 2 or more unfainted mons in party
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	cp 2    ; don't bother if only 1
	jp nc, SwitchEnemyMon
	and a
	ret

SwitchEnemyMon:

	xor a
	ld [wEnemySelectedMove], a
; prepare to withdraw the active monster: copy hp, number, and status to roster

	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonHP
	ld bc, 4
	call CopyData

	ld hl, AIBattleWithdrawText
	call PrintText

	; This wFirstMonsNotOutYet variable is abused to prevent the player from
	; switching in a new mon in response to this switch.
	ld a, 1
	ld [wFirstMonsNotOutYet], a
	callfar EnemySendOut
	xor a
	ld [wFirstMonsNotOutYet], a

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	scf
	ret

AIBattleWithdrawText:
	text_far _AIBattleWithdrawText
	text_end

AIUseFullHeal:
	call AIPlayRestoringSFX
	call AICureStatus
	ld a, FULL_HEAL
	jp AIPrintItemUse

AICureStatus:
; cures the status of enemy's active pokemon
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in enemy team roster
	ld [wEnemyMonStatus], a ; clear status of active enemy
	ld hl, wEnemyBattleStatus3
	res 0, [hl]
	push af
	farcall DrawEnemyHUDAndHPBar
	pop af
	ret

AIUseXAccuracy: ; unused
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 0, [hl]
	ld a, X_ACCURACY
	jp AIPrintItemUse

AIUseGuardSpec:
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 1, [hl]
	ld a, GUARD_SPEC
	jp AIPrintItemUse

AIUseDireHit: ; unused
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 2, [hl]
	ld a, DIRE_HIT
	jp AIPrintItemUse

AICheckIfHPBelowFraction:
; return carry if enemy trainer's current HP is below 1 / a of the maximum
	ldh [hDivisor], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld c, a
	ldh a, [hQuotient + 2]
	ld b, a
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret

AIUseXAttack:
	ld b, $A
	ld a, X_ATTACK
	jr AIIncreaseStat

AIUseXDefend:
	ld b, $B
	ld a, X_DEFEND
	jr AIIncreaseStat

AIUseXSpeed:
	ld b, $C
	ld a, X_SPEED
	jr AIIncreaseStat

AIUseXSpecial:
	ld b, $D
	ld a, X_SPECIAL
	; fallthrough

AIIncreaseStat:
	ld [wAIItem], a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl, wEnemyMoveEffect
	ld a, [hld]
	push af
	ld a, [hl]
	push af
	push hl
	ld a, XSTATITEM_DUPLICATE_ANIM
	ld [wAltAnimationID], a
	ld [hli], a
	ld [hl], b
	callfar StatModifierUpEffect
	pop hl
	pop af
	ld [hli], a
	pop af
	ld [hl], a
	jp DecrementAICount

AIPrintItemUse:
	ld [wAIItem], a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [wAIItem] on z!"
	ld a, [wAIItem]
	ld [wd11e], a
	call GetItemName
	ld hl, AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	text_far _AIBattleUseItemText
	text_end
