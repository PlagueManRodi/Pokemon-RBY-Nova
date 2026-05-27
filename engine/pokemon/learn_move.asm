LearnMove:
	call SaveScreenTilesToBuffer1
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, wcd6d
	ld de, wLearnMoveMonName
	ld bc, NAME_LENGTH
	call CopyData

DontAbandonLearning:
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2Moves - wPartyMon1Moves
	ld a, [wWhichPokemon]
	call AddNTimes
	ld d, h
	ld e, l
	ld b, NUM_MOVES
.findEmptyMoveSlotLoop
	ld a, [hl]
	and a
	jr z, .next
	inc hl
	dec b
	jr nz, .findEmptyMoveSlotLoop
	push de
	call TryingToLearn
	pop de
	jp c, AbandonLearning
	push hl
	push de
	ld [wd11e], a
	call GetMoveName
	ld hl, OneTwoAndText
	call PrintText
	pop de
	pop hl
.next
	ld a, [wMoveNum]
	ld [hl], a
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl, bc
	push hl
	push de
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld de, wBuffer
	callfar AcidTypeMoveCheck
	ld a, [wBuffer + 5] ; a = move's max PP
	pop de
	pop hl
	ld [hl], a
	ld a, [wIsInBattle]
	and a
	jp z, PrintLearnedMove
	ld a, [wWhichPokemon]
	ld b, a
	ld a, [wPlayerMonNumber]
	cp b
	jp nz, PrintLearnedMove
	ld h, d
	ld l, e
	ld de, wBattleMonMoves
	ld bc, NUM_MOVES
	call CopyData
	ld bc, wPartyMon1PP - wPartyMon1OTID
	add hl, bc
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	call CopyData
	jp PrintLearnedMove

AbandonLearning:
	ld hl, AbandonLearningText
	call PrintText
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jp nz, DontAbandonLearning
	ld hl, DidNotLearnText
	call PrintText
	ld b, 0
	ret

PrintLearnedMove:
	ld hl, LearnedMove1Text
	call PrintText
	ld b, 1
	ret

TryingToLearn:
	push hl
	ld hl, TryingToLearnText
	call PrintText
	hlcoord 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	pop hl
	ld a, [wCurrentMenuItem]
	rra
	ret c
	ld bc, -NUM_MOVES
	add hl, bc
	push hl
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callfar FormatMovesString
	pop hl
.loop
	push hl
	ld hl, WhichMoveToForgetText
	call PrintText
	hlcoord 4, 8 ; used to be 4, 7
	ld b, 4
	ld c, 14
	call TextBoxBorder
	call UpdateSprites
	hlcoord 6, 9 ; used to be 6, 8
	ld de, wMovesString
	ldh a, [hUILayoutFlags]
	set 2, a
	ldh [hUILayoutFlags], a
	call PlaceString
	;;
	callfar DisplayMoveInfoTextBoxes
	call UpdateSprites
	;;
	ldh a, [hUILayoutFlags]
	res 2, a
	ldh [hUILayoutFlags], a
	ld hl, wTopMenuItemY
	ld a, 9 ; used to be 8
	ld [hli], a ; wTopMenuItemY
	ld a, 5
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, [wNumMovesMinusOne]
	ld [hli], a ; wMaxMenuItem
	ld a, A_BUTTON | B_BUTTON | D_DOWN | D_UP | SELECT | START
	ld [hli], a ; wMenuWatchedKeys
	ld [hl], 0 ; wLastMenuItem
	;;
	; print info for old move
	callfar PrintInfoOldMove
	call UpdateSprites
.inputLoop ; added
	ld hl, hUILayoutFlags
	set 1, [hl]
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res 1, [hl]
	;;
	; checking which button has been pressed
	bit BIT_A_BUTTON, a
	jr nz, .doTheThings
	bit BIT_B_BUTTON, a
	jr nz, .doTheThings
; not A or B, so is UP or DOWN
	bit BIT_SELECT, a
	jr nz, ShowDetailedInfoOldMove ; testing
	bit BIT_START, a
	jr nz, ShowDetailedInfoNewMove ; testing
; not A or B or START, so is UP or DOWN
	push af
	bit BIT_D_DOWN, a
	jr nz, .updateBox
	bit BIT_D_UP, a
	jr nz, .updateBox
	pop af
	jr .inputLoop
.updateBox
	callfar PrintInfoOldMove
	pop af
	jr .inputLoop
.doTheThings
	;;
	push af
	call LoadScreenTilesFromBuffer1
	pop af
	pop hl
	bit BIT_B_BUTTON, a
	jr nz, .cancel
	push hl
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld d, a
	push af
	push bc
	callfar IsMoveHM
	push de
	pop af
	pop bc
	pop de
	ld a, d
	jr c, .hm
	pop hl
	add hl, bc
	and a
	ret
.hm
	ld hl, HMCantDeleteText
	call PrintText
	pop hl
	jp .loop ; used to be jr
.cancel
	scf
	ret

ShowDetailedInfoOldMove:
	ld a, [wMoveNum]
	push af
	
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wWhichPokemon]
	call AddNTimes ; adds bc to hl a times ; hl points to the moves

	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0 ; which move in the menu is the cursor pointing to? (0-3)
	add hl, bc ; points to the move in memory
	ld a, [hl] ; a should be holding the move ID
	
	ld [wd11e], a
	jr ShowDetailedInfoMove
	
ShowDetailedInfoNewMove: ; new
	ld a, [wMoveNum]
	ld [wd11e], a
	push af
	; fallthrough
	
ShowDetailedInfoMove:
; check if we're learning the move after an evo
	ld hl, wNewFlags
	bit 1, [hl]
	jp nz, .evoLvUp
; check if we're learning the move in battle or in the party menu
	ld a, [wIsInBattle]
	and a
	jp nz, .inBattle
; in the party menu
	bit 0, [hl]
	jr z, .moveRelearner
	;
	call SaveScreenTilesToSSpriteBuffer
	call ClearSprites
	;
	callfar ShowAttackdexData
	;
	xor a
	ldh [hAutoBGTransferEnabled], a
	;
	call LoadHpBarAndStatusTilePatterns
	callfar DrawHPBars
	call LoadScreenTilesFromSSpriteBuffer
	;
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	;
	callfar DrawPartySprites
	;
	pop af
	ld [wd11e], a
	ld [wMoveNum], a
	;
	call GetMoveName
	ld bc, NAME_BUFFER_LENGTH
	ld de, wStringBuffer
	ld hl, wcd6d
	call CopyData
	;
	jp TryingToLearn.inputLoop
.moveRelearner
	call SaveScreenTilesToBuffer2
	xor a
	ld [wUpdateSpritesEnabled], a
	callfar ShowAttackdexData
	call GBPalWhiteOut
	call LoadScreenTilesFromBuffer2
	call RestoreScreenTilesAndReloadTilePatterns
	;
	pop af
	ld [wd11e], a
	ld [wMoveNum], a
	;
	call GetMoveName
	ld bc, NAME_BUFFER_LENGTH
	ld de, wStringBuffer
	ld hl, wcd6d
	call CopyData
	;
	call LoadGBPal
	;
	jp TryingToLearn.inputLoop
.inBattle
	call SaveScreenTilesToBuffer2
	callfar ShowAttackdexData
	ld a, [wBattleMonSpecies]
	ld [wd0b5], a
	call GetMonHeader
	predef LoadMonBackPic
	call LoadScreenTilesFromBuffer2
	callfar LoadHudAndHpBarAndStatusTilePatterns
	;
	pop af
	ld [wd11e], a
	ld [wMoveNum], a
	;
	call GetMoveName
	ld bc, NAME_BUFFER_LENGTH
	ld de, wStringBuffer
	ld hl, wcd6d
	call CopyData
	;
	jp TryingToLearn.inputLoop
.evoLvUp
	;
	call SaveScreenTilesToSSpriteBuffer
	call ClearSprites
	;
	callfar ShowAttackdexData
	;
	xor a
	ldh [hAutoBGTransferEnabled], a
	;
;	call LoadHpBarAndStatusTilePatterns
;	callfar DrawHPBars
	call LoadScreenTilesFromSSpriteBuffer
	;
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
;	call Delay3
	;
;	callfar DrawPartySprites
	;
	pop af
	ld [wd11e], a
	ld [wMoveNum], a
	;
	call GetMoveName
	ld bc, NAME_BUFFER_LENGTH
	ld de, wStringBuffer
	ld hl, wcd6d
	call CopyData
	;
	jp TryingToLearn.inputLoop

LearnedMove1Text:
	text_far _LearnedMove1Text
	sound_get_item_1 ; plays SFX_GET_ITEM_1 in the party menu (rare candy) and plays SFX_LEVEL_UP in battle
	text_promptbutton
	text_end

WhichMoveToForgetText:
	text_far _WhichMoveToForgetText
	text_end

AbandonLearningText:
	text_far _AbandonLearningText
	text_end

DidNotLearnText:
	text_far _DidNotLearnText
	text_end

TryingToLearnText:
	text_far _TryingToLearnText
	text_end

OneTwoAndText:
	text_far _OneTwoAndText
	text_pause
	text_asm
	push af
	push bc
	push de
	push hl
	ld a, $1
	ld [wMuteAudioAndPauseMusic], a
	call DelayFrame
	ld a, [wAudioROMBank]
	push af
	ld a, BANK(SFX_Swap_1)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	call WaitForSoundToFinish
	ld a, SFX_SWAP
	call PlaySound
	call WaitForSoundToFinish
	pop af
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wMuteAudioAndPauseMusic], a
	pop hl
	pop de
	pop bc
	pop af
	ld hl, PoofText
	ret

PoofText:
	text_far _PoofText
	text_pause
ForgotAndText:
	text_far _ForgotAndText
	text_end

HMCantDeleteText:
	text_far _HMCantDeleteText
	text_end

SaveScreenTilesToSSpriteBuffer:
    ld a, SRAM_ENABLE
    ld [MBC1SRamEnable], a
    xor a
    ld [MBC1SRamBank], a
    inc a
    ld [MBC1SRamBankingMode], a
    hlcoord 0, 0
    ld de, sSpriteBuffer0
    ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
    call CopyData
    xor a
    ld [MBC1SRamBankingMode], a
    ld [MBC1SRamEnable], a
    ret

LoadScreenTilesFromSSpriteBuffer::
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, SRAM_ENABLE
    ld [MBC1SRamEnable], a
    xor a
    ld [MBC1SRamBank], a
    inc a
    ld [MBC1SRamBankingMode], a
	ld hl, sSpriteBuffer0
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call CopyData
	xor a
    ld [MBC1SRamBankingMode], a
    ld [MBC1SRamEnable], a
	inc a
	ldh [hAutoBGTransferEnabled], a
	ret
