LancesRoom_Script:
	call LanceShowOrHideEntranceBlocks
	call EnableAutoTextBoxDrawing
	ld hl, LancesRoomTrainerHeaders
	ld de, LancesRoom_ScriptPointers
	ld a, [wLancesRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wLancesRoomCurScript], a
	ret

LanceShowOrHideEntranceBlocks:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_LANCES_ROOM_LOCK_DOOR
	jr nz, .closeEntrance
	; open entrance
	ld a, $31
	ld b, $32
	jp .setEntranceBlocks
.closeEntrance
	ld a, $72
	ld b, $73
.setEntranceBlocks
; Replaces the tile blocks so the player can't leave.
	push bc
	ld [wNewTileBlockID], a
	lb bc, 6, 2
	call .SetEntranceBlock
	pop bc
	ld a, b
	ld [wNewTileBlockID], a
	lb bc, 6, 3
.SetEntranceBlock:
	predef_jump ReplaceTileBlock

ResetLanceScript:
	xor a
	ld [wLancesRoomCurScript], a
	ret

LancesRoom_ScriptPointers:
	dw LanceScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw LanceScript2
	dw LanceScript3
	dw LanceScript4
	dw LanceScript5

LanceScript4:
	ret

LanceScript5:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .done
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	SetEvent EVENT_BEAT_LANCES_ROOM_TRAINER_0
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.done
	xor a
	ld [wJoyIgnore], a
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
	ret

LanceScript0:
	CheckEvent EVENT_BEAT_LANCE
	ret nz
	ld hl, LanceTriggerMovementCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [hJoyHeld], a
	ld a, [wYCoord]
	cp 1
;	ld a, [wCoordIndex]
;	cp $3  ; Is player standing next to Lance's sprite?
	jr nz, .notStandingNextToLance
	ld a, $2
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates
.notStandingNextToLance
	ld a, [wCoordIndex]
	cp $5  ; Is player standing on the entrance staircase?
	jr z, WalkToLance
	CheckAndSetEvent EVENT_LANCES_ROOM_LOCK_DOOR
	ret nz
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ld a, SFX_GO_INSIDE
	call PlaySound
	jp LanceShowOrHideEntranceBlocks

LanceTriggerMovementCoords:
	dbmapcoord  5,  1
	dbmapcoord  6,  2
	dbmapcoord  5, 11
	dbmapcoord  6, 11
	dbmapcoord 24, 16
	db -1 ; end

LanceScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetLanceScript
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

WalkToLance:
; Moves the player down the hallway to Lance's room.
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, WalkToLance_RLEList
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
	ret

WalkToLance_RLEList:
	db D_UP, 12
	db D_LEFT, 12
	db D_DOWN, 7
	db D_LEFT, 6
	db -1 ; end

LanceScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
	ret

LancesRoom_TextPointers:
	dw LanceText1
	dw LanceText2

LancesRoomTrainerHeaders:
	def_trainers
LancesRoomTrainerHeader0:
	trainer EVENT_BEAT_LANCES_ROOM_TRAINER_0, 0, LanceBeforeBattleText, LanceEndBattleText, LanceAfterBattleText
	db -1 ; end

LanceText1:
	text_asm
	ld hl, wVermilionBeachFlags
	lb bc, FLAG_TEST, 2
	predef FlagActionPredef
	ld a, c
	and a
	jr nz, .LanceRematch
	CheckEvent EVENT_BEAT_LANCES_ROOM_TRAINER_0
	jr nz, .noHealing
	predef HealParty
.noHealing
	ld hl, LancesRoomTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd
.LanceRematch
	CheckEvent EVENT_BEAT_LANCES_ROOM_TRAINER_0
	jr z, .beforeRematch
	ld hl, LanceRematchAfterBattleText
	call PrintText
	SetEvent EVENT_BEAT_LANCE
	jr .done
.beforeRematch
	predef HealParty
	ld hl, LanceRematchBeforeBattleText
	call PrintText
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, LanceRematchEndBattleText
	ld de, LanceRematchEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_LANCE
	ld [wCurOpponent], a
	ld a, 2
	ld [wTrainerNo], a
	ld a, 5
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

LanceBeforeBattleText:
	text_far _LanceBeforeBattleText
	text_end

LanceEndBattleText:
	text_far _LanceEndBattleText
	text_end

LanceAfterBattleText:
	text_far _LanceAfterBattleText
	text_asm
	SetEvent EVENT_BEAT_LANCE
	jp TextScriptEnd

LanceText2:
	text_far _LanceDontRunAwayText
	text_end

LanceRematchBeforeBattleText:
	text_far _LanceRematchBeforeBattleText
	text_end

LanceRematchEndBattleText:
	text_far _LanceRematchEndBattleText
	text_end

LanceRematchAfterBattleText:
	text_far _LanceRematchAfterBattleText
	text_end
